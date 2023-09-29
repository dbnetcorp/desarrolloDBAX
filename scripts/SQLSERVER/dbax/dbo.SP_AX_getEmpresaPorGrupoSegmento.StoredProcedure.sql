SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getEmpresaPorGrupoSegmento](
@pCodiEmex varchar(30),
@pCodiEmpr numeric (9,0),
@pCorrInst varchar(10),
@pDescripcion varchar(100),
@pGrupo varchar(50),
@pSegmento varchar(50),
@pTipo varchar(10),
@pTipoDesc varchar(100) = 'P'
)
as
BEGIN
	/*	
		@pTipoDesc = 'P' devuelve descripcion por defecto y personalizada
		@pTipoDesc  = 'C' SE DEVUELVE SOLO LAS DE MAS DE UNA VERSIÓN
	*/
	declare @vComodinGrup varchar(1)
	declare @vComodinSegm varchar(1)
	declare @vComodinTipo varchar(1)
	declare @vComodinCorr varchar(1)

	set @vComodinGrup = '%'
	set @vComodinSegm = '%'
	set @vComodinTipo = '%'
	set @vComodinCorr = '%'

	if ( @pGrupo != '')
	begin
		set @vComodinGrup = ''
	end

	if ( @pSegmento != '')
	begin
		set @vComodinSegm = ''
	end

	if ( @pTipo != '')
	begin
		set @vComodinTipo = ''
	end

	if (@pCorrInst != '')
	begin
		set @vComodinCorr = ''
	end

	if(@pTipoDesc = 'P') -- TODAS LAS EMPRESAS PARA COMBOBOX
	begin
		select	v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, desc_tipo
		from	(select distinct dp.codi_pers as codi_pers,
								'[' + convert(varchar,dp.codi_pers) + '] ' + dp.desc_pers as desc_pers,
								isnull(dh.desc_empr,dp.desc_pers) as desc_peho,
								dg.desc_grup as desc_grup,
								dp.codi_grup as codi_grup,
								dp.codi_segm as codi_segm,
								dp.tipo_taxo as tipo_taxo
				from	dbax_defi_pers dp 
							left join dbax_defi_peho dh 
							on	dh.codi_emex = @pCodiEmex 
							and	dh.codi_empr = @pCodiEmpr 
							and	dp.codi_pers = dh.codi_pers
								left join dbax_defi_grup dg
								on	dg.codi_grup = dp.codi_grup,
						dbax_inst_docu id
				where	(dp.codi_pers like '%' + @pDescripcion + '%' 
						or dh.desc_empr like '%' + @pDescripcion + '%' 
						or dp.desc_pers like '%' + @pDescripcion + '%')
				and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
				and		dp.codi_pers = id.codi_pers) v
		left join dbax_defi_segm ds
			on v.codi_segm = ds.codi_segm
		left join dbax_tipo_taxo tt
			on v.tipo_taxo = tt.tipo_taxo
		where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
		and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo
	end

	if(@pTipoDesc = 'C') -- SE DEVUELVE SOLO LAS DE MAS DE UNA VERSIÓN (para grilla de diferencias)
	begin
		/*
		select distinct dp.codi_pers as codi_pers,
		'[' + convert(varchar,dp.codi_pers) + '] ' + dp.desc_pers as desc_pers,
		isnull(dh.desc_empr,dp.desc_pers) as desc_peho 
		from dbax_defi_pers dp left join dbax_defi_peho dh on dh.codi_emex = @pCodiEmex 
		and dh.codi_empr = @pCodiEmpr 
		and dp.codi_pers = dh.codi_pers 
		where dp.codi_pers like '%' + @pDescripcion + '%'
		and dp.codi_pers in (select distinct a.codi_pers from dbax_inst_info a where  a.vers_inst > '1')
		union
		select distinct dp.codi_pers as codi_pers, '[' + convert(varchar,dp.codi_pers) + '] ' + dp.desc_pers as desc_pers,
		dh.desc_empr as desc_peho 
		from dbax_defi_pers dp left join dbax_defi_peho dh on dh.codi_emex = @pCodiEmex 
		and dh.codi_empr = @pCodiEmpr 
		and dp.codi_pers = dh.codi_pers 
		where 
		dp.codi_pers in (select distinct a.codi_pers from dbax_inst_info a where  a.vers_inst > '1') 
		and dp.desc_pers like '%' + @pDescripcion + '%' or dh.desc_empr like '%' + @pDescripcion + '%'
		*/
		select	distinct v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, desc_tipo, vt.vers_inst
		from	(select distinct dp.codi_pers as codi_pers,
								'[' + convert(varchar,dp.codi_pers) + '] ' + dp.desc_pers as desc_pers,
								isnull(dh.desc_empr,dp.desc_pers) as desc_peho,
								dg.desc_grup as desc_grup,
								dp.codi_grup as codi_grup,
								dp.codi_segm as codi_segm,
								dp.tipo_taxo as tipo_taxo
				from	dbax_defi_pers dp 
							left join dbax_defi_peho dh 
							on	dh.codi_emex = @pCodiEmex 
							and	dh.codi_empr = @pCodiEmpr 
							and	dp.codi_pers = dh.codi_pers
								left join dbax_defi_grup dg
								on	dg.codi_grup = dp.codi_grup,
						dbax_inst_docu id
				where	(dp.codi_pers like '%' + @pDescripcion + '%' 
						or dh.desc_empr like '%' + @pDescripcion + '%' 
						or dp.desc_pers like '%' + @pDescripcion + '%')
				and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
				and		dp.codi_pers = id.codi_pers
				and		id.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
				) v
		left join dbax_defi_segm ds
			on v.codi_segm = ds.codi_segm
		left join dbax_tipo_taxo tt
			on v.tipo_taxo = tt.tipo_taxo,
		dbax_inst_vers vt
		where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
		and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo
		and	vt.codi_pers = v.codi_pers
		and	vt.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
		and	vt.vers_inst > 1
	end

	if(@pTipoDesc = 'E') -- TODAS LAS EMPRESAS PARA COMBOBOX
	begin
		select	v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, desc_tipo
		from	(select distinct dp.codi_pers as codi_pers,
								'[' + convert(varchar,dp.codi_pers) + '] ' + dp.desc_pers as desc_pers,
								isnull(dh.desc_empr,dp.desc_pers) as desc_peho,
								dg.desc_grup as desc_grup,
								dp.codi_grup as codi_grup,
								dp.codi_segm as codi_segm,
								dp.tipo_taxo as tipo_taxo
				from	dbax_defi_pers dp 
							left join dbax_defi_peho dh 
							on	dh.codi_emex = @pCodiEmex 
							and	dh.codi_empr = @pCodiEmpr 
							and	dp.codi_pers = dh.codi_pers
								left join dbax_defi_grup dg
								on	dg.codi_grup = dp.codi_grup,
						dbax_inst_docu id
				where	(dp.codi_pers like '%' + @pDescripcion + '%' 
						or dh.desc_empr like '%' + @pDescripcion + '%' 
						or dp.desc_pers like '%' + @pDescripcion + '%')
				and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
				and		dp.codi_pers = id.codi_pers
				and		id.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
				) v
		left join dbax_defi_segm ds
			on v.codi_segm = ds.codi_segm
		left join dbax_tipo_taxo tt
			on v.tipo_taxo = tt.tipo_taxo
		where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
		and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo
	end
END
GO
