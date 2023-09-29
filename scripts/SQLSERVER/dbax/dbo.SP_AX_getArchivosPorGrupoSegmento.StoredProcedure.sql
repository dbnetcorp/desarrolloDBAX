SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getArchivosPorGrupoSegmento](
@pCodiEmex varchar(30),
@pCodiEmpr numeric (9,0),
@pCorrInst varchar(10),
@pDescripcion varchar(100),
@pGrupo varchar(50),
@pSegmento varchar(50),
@pTipo varchar(10),
@pNombArch varchar(100)
)
as
BEGIN
	/*	
		@pTipoDesc = 'D' se devuelve descripcion "por defecto", 
		@pTipoDesc = 'P' devuelve descripcion por defecto y personalizada
		@pTipoDesc  = 'C' SE DEVUELVE SOLO LAS DE MAS DE UNA VERSIÓN
	*/
	declare @vComodinGrup varchar(1)
	declare @vComodinSegm varchar(1)
	declare @vComodinTipo varchar(1)
	set @vComodinGrup = '%'
	set @vComodinSegm = '%'
	set @vComodinTipo = '%'

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

	declare @vComodinCorr varchar(1)
	set @vComodinCorr = '%'

	if (@pCorrInst != '')
	begin
		set @vComodinCorr = ''
	end

	select distinct t.codi_pers, t.corr_inst, ia.vers_inst, max(ia.nomb_arch)
	from (select	v.codi_pers, v.corr_inst
		 from	(select distinct dp.codi_pers as codi_pers,
								dg.desc_grup as desc_grup,
								dp.codi_grup as codi_grup,
								dp.codi_segm as codi_segm,
								id.corr_inst as corr_inst,
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
		and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo) t
	left join dbax_inst_arch ia
	on	t.codi_pers = ia.codi_pers
	and	t.corr_inst = ia.corr_inst
	and	ia.vers_inst = dbo.FU_AX_getUltimaVersion(ia.codi_pers, ia.corr_inst)
	and	ia.nomb_arch like '%' + @pNombArch + '%'
	group by t.codi_pers, t.corr_inst, ia.vers_inst
	order by 1,2,3,4
END
GO
