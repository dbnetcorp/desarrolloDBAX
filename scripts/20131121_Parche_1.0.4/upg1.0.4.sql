/****** Objeto:  StoredProcedure [dbo].[SP_AX_getEmpresaPorGrupoSegmento]    Fecha de la secuencia de comandos: 12/12/2013 09:28:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




ALTER procedure [dbo].[SP_AX_getEmpresaPorGrupoSegmento](
	@pCodiEmex varchar(30),
	@pCodiEmpr numeric (9,0),
	@pCorrInst varchar(10),
	@pDescripcion varchar(100),
	@pGrupo varchar(50),
	@pSegmento varchar(50),
	@pTipo varchar(10),
	@pTipoDesc varchar(100) = 'P',
	@pTipoArch varchar(10) = 'Oficial'
	)
as
BEGIN
	--select @pTipoDesc, @pTipoArch
	/*	
		@pTipoDesc = 'P' devuelve descripcion por defecto y personalizada
		@pTipoDesc  = 'C' SE DEVUELVE SOLO LAS DE MAS DE UNA VERSIÓN
		@pTipoDesc  = 'E' SE DEVUELVE SOLO LAS QUE TENGAN CORR_INST CREADO

		@pTipoArch = O significa oficial, E = externo (no oficial)
	*/

	set @pDescripcion = upper(@pDescripcion)

	declare @vComodinGrup varchar(1)
	declare @vComodinSegm varchar(1)
	declare @vComodinTipo varchar(1)
	declare @vComodinCorr varchar(1)
	declare @AccesoLimitado numeric(4,0)
	declare @vMaxiVers numeric(3,0)
	declare @vMinVers numeric(2,0)

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

	if(@pTipoArch='Oficial')
	begin
		set @vMinVers = 0
		set @vMaxiVers = 30
	end
	else
	begin
		set @vMinVers = 30
		set @vMaxiVers = 999
	end

	-- TODAS LAS EMPRESAS
	if(@pTipoDesc = 'P') 
	begin
		select @AccesoLimitado = count(*) from dbax_exte_pers where codi_emex = @pCodiEmex

		--Todos los periodos
		if(@pCorrInst = '')
		BEGIN
			if(@AccesoLimitado > 0)
			begin
				select	v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, desc_tipo
				from	(select distinct dp.codi_pers as codi_pers,
										dp.desc_pers as desc_pers,
										isnull(dh.desc_empr,dp.desc_pers) as desc_peho,
										dg.desc_grup as desc_grup,
										dp.codi_grup as codi_grup,
										dp.codi_segm as codi_segm,
										dp.tipo_taxo as tipo_taxo,
										(select max(vi.vers_inst) from dbax_inst_vers vi where vi.corr_inst = isnull(@pCorrInst,0) and vi.codi_pers = dp.codi_pers) as vers_inst
						from	dbax_defi_pers dp 
									left join dbax_defi_peho dh 
									on	dh.codi_emex = @pCodiEmex 
									and	dh.codi_empr = @pCodiEmpr 
									and	dp.codi_pers = dh.codi_pers
										left join dbax_defi_grup dg
										on	dg.codi_grup = dp.codi_grup,
								dbax_inst_docu id,
								dbax_exte_pers ep
						where	(dp.codi_pers like '%' + @pDescripcion + '%' 
								or upper(dh.desc_empr) like '%' + @pDescripcion + '%' 
								or upper(dp.desc_pers) like '%' + @pDescripcion + '%')
						and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
						and		dp.codi_pers = id.codi_pers
						and		dp.empr_vige = 'SI'
						and		ep.codi_emex = dh.codi_emex
						and		ep.codi_pers = id.codi_pers) v
				left join dbax_defi_segm ds
					on v.codi_segm = ds.codi_segm
				left join dbax_tipo_taxo tt
					on v.tipo_taxo = tt.tipo_taxo
				where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
				and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo
				order by v.desc_pers asc
			end
			else
			begin
				select	v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, desc_tipo
				from	(select distinct dp.codi_pers as codi_pers,
										dp.desc_pers as desc_pers,
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
								or upper(dh.desc_empr) like '%' + @pDescripcion + '%' 
								or upper(dp.desc_pers) like '%' + @pDescripcion + '%')
						and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
						and		dp.codi_pers = id.codi_pers
						and		dp.empr_vige = 'SI') v
				left join dbax_defi_segm ds
					on v.codi_segm = ds.codi_segm
				left join dbax_tipo_taxo tt
					on v.tipo_taxo = tt.tipo_taxo
				where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
				and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo
				order by v.desc_pers asc
			end
		END
		--Fin todos los periodos
		ELSE
		--Un periodo en particular
		BEGIN
			if(@AccesoLimitado > 0)
			begin
				print 1
				select	v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, desc_tipo, v.vers_inst, @pCorrInst corr_inst
				from	(select distinct dp.codi_pers as codi_pers,
										dp.desc_pers as desc_pers,
										isnull(dh.desc_empr,dp.desc_pers) as desc_peho,
										dg.desc_grup as desc_grup,
										dp.codi_grup as codi_grup,
										dp.codi_segm as codi_segm,
										dp.tipo_taxo as tipo_taxo,
										(select max(vi.vers_inst) from dbax_inst_vers vi where vi.corr_inst = isnull(@pCorrInst,0) and vi.codi_pers = dp.codi_pers) as vers_inst
						from	dbax_defi_pers dp 
									left join dbax_defi_peho dh 
									on	dh.codi_emex = @pCodiEmex 
									and	dh.codi_empr = @pCodiEmpr 
									and	dp.codi_pers = dh.codi_pers
										left join dbax_defi_grup dg
										on	dg.codi_grup = dp.codi_grup,
								dbax_inst_docu id,
								dbax_exte_pers ep
						where	(dp.codi_pers like '%' + @pDescripcion + '%' 
								or upper(dh.desc_empr) like '%' + @pDescripcion + '%' 
								or upper(dp.desc_pers) like '%' + @pDescripcion + '%')
						and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
						and		dp.codi_pers = id.codi_pers
						and		dp.empr_vige = 'SI'
						and		ep.codi_emex = dh.codi_emex
						and		ep.codi_pers = id.codi_pers) v
				left join dbax_defi_segm ds
					on v.codi_segm = ds.codi_segm
				left join dbax_tipo_taxo tt
					on v.tipo_taxo = tt.tipo_taxo
				where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
				and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo
				order by v.desc_pers asc
			end
			else
			begin
				select	v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, desc_tipo, v.vers_inst, @pCorrInst corr_inst
				from	(select distinct dp.codi_pers as codi_pers,
										dp.desc_pers as desc_pers,
										isnull(dh.desc_empr,dp.desc_pers) as desc_peho,
										dg.desc_grup as desc_grup,
										dp.codi_grup as codi_grup,
										dp.codi_segm as codi_segm,
										dp.tipo_taxo as tipo_taxo,
										(select max(vi.vers_inst) from dbax_inst_vers vi where vi.corr_inst = isnull(@pCorrInst,0) and vi.codi_pers = dp.codi_pers) as vers_inst
						from	dbax_defi_pers dp 
									left join dbax_defi_peho dh 
									on	dh.codi_emex = @pCodiEmex 
									and	dh.codi_empr = @pCodiEmpr 
									and	dp.codi_pers = dh.codi_pers
										left join dbax_defi_grup dg
										on	dg.codi_grup = dp.codi_grup,
								dbax_inst_docu id
						where	(dp.codi_pers like '%' + @pDescripcion + '%' 
								or upper(dh.desc_empr) like '%' + @pDescripcion + '%' 
								or upper(dp.desc_pers) like '%' + @pDescripcion + '%')
						and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
						and		dp.codi_pers = id.codi_pers
						and		dp.empr_vige = 'SI') v
				left join dbax_defi_segm ds
					on v.codi_segm = ds.codi_segm
				left join dbax_tipo_taxo tt
					on v.tipo_taxo = tt.tipo_taxo
				where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
				and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo
				order by v.desc_pers asc
			end
		END
		--Fin un periodo en particular
	end
	--Fin todas las empresas
	
	if(@pTipoDesc = 'C') -- SE DEVUELVE SOLO LAS DE MAS DE UNA VERSIÓN (para grilla de diferencias)
	begin
		select	distinct v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, desc_tipo, vt.vers_inst
		from	(select distinct dp.codi_pers as codi_pers,
								dp.desc_pers as desc_pers,
								isnull(dh.desc_empr,dp.desc_pers) as desc_peho,
								dg.desc_grup as desc_grup,
								dp.codi_grup as codi_grup,
								dp.codi_segm as codi_segm,
								dp.tipo_taxo as tipo_taxo,
								(select max(vi.vers_inst) from dbax_inst_vers vi where vi.corr_inst = isnull(@pCorrInst,0) and vi.codi_pers = dp.codi_pers) as vers_inst
				from	dbax_defi_pers dp 
							left join dbax_defi_peho dh 
							on	dh.codi_emex = @pCodiEmex 
							and	dh.codi_empr = @pCodiEmpr 
							and	dp.codi_pers = dh.codi_pers
								left join dbax_defi_grup dg
								on	dg.codi_grup = dp.codi_grup,
						dbax_inst_docu id
				where	(dp.codi_pers like '%' + @pDescripcion + '%' 
						or upper(dh.desc_empr) like '%' + @pDescripcion + '%' 
						or upper(dp.desc_pers) like '%' + @pDescripcion + '%')
				and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
				and		dp.codi_pers = id.codi_pers
				and		id.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
				and		dp.empr_vige = 'SI') v
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
		order by v.desc_pers asc
	end

	if(@pTipoDesc = 'E') -- TODAS LAS EMPRESAS CON PERIODO CREADO CORR_INST
	begin
		select @AccesoLimitado = count(*) from dbax_exte_pers where codi_emex = @pCodiEmex

		if(@AccesoLimitado > 0)
		begin
			Print 'Acceso limitado > 0'
			--select @pCodiEmex, @pCodiEmpr, @pDescripcion, @pGrupo, @pCorrInst, @pSegmento, @pTipo
			select	v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, desc_tipo
			from	(select distinct dp.codi_pers as codi_pers,
									dp.desc_pers as desc_pers,
									isnull(dh.desc_empr,dp.desc_pers) as desc_peho,
									dg.desc_grup as desc_grup,
									dp.codi_grup as codi_grup,
									dp.codi_segm as codi_segm,
									dp.tipo_taxo as tipo_taxo,
								    (select max(vi.vers_inst) from dbax_inst_vers vi where vi.corr_inst = isnull(@pCorrInst,0) and vi.codi_pers = dp.codi_pers) as vers_inst
					from	dbax_defi_pers dp 
								left join dbax_defi_peho dh 
								on	dh.codi_emex = @pCodiEmex 
								and	dh.codi_empr = @pCodiEmpr 
								and	dp.codi_pers = dh.codi_pers
									left join dbax_defi_grup dg
									on	dg.codi_grup = dp.codi_grup,
							dbax_inst_docu id,
							dbax_exte_pers ep
					where	(dp.codi_pers like '%' + @pDescripcion + '%' 
							or upper(dh.desc_empr) like '%' + @pDescripcion + '%' 
							or upper(dp.desc_pers) like '%' + @pDescripcion + '%')
					and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
					and		dp.codi_pers = id.codi_pers
					and		id.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
					and		dp.empr_vige = 'SI'
					and		ep.codi_emex = dh.codi_emex
					and		ep.codi_pers = id.codi_pers) v
			left join dbax_defi_segm ds
				on v.codi_segm = ds.codi_segm
			left join dbax_tipo_taxo tt
				on v.tipo_taxo = tt.tipo_taxo,
			dbax_inst_vers vt
			where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
			and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo
			and	vt.codi_pers = v.codi_pers
			and	vt.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
			and	vt.vers_inst >= @vMinVers
			and	vt.vers_inst < @vMaxiVers
			and vt.vers_inst= dbo.FU_AX_getUltimaVersion(vt.codi_pers, vt.corr_inst)
			order by v.desc_pers asc
		end
		else
		begin
			--Select @vMinVers, @vMaxiVers
			Print 'Acceso limitado >= 0'
			--select @pCodiEmex, @pCodiEmpr, @pDescripcion, @pGrupo, @pCorrInst, @pSegmento, @pTipo
			select	v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, desc_tipo
			from	(select distinct dp.codi_pers as codi_pers,
									dp.desc_pers as desc_pers,
									isnull(dh.desc_empr,dp.desc_pers) as desc_peho,
									dg.desc_grup as desc_grup,
									dp.codi_grup as codi_grup,
									dp.codi_segm as codi_segm,
									dp.tipo_taxo as tipo_taxo,
									(select max(vi.vers_inst) from dbax_inst_vers vi where vi.corr_inst = isnull(@pCorrInst,0) and vi.codi_pers = dp.codi_pers) as vers_inst
					from	dbax_defi_pers dp 
								left join dbax_defi_peho dh 
								on	dh.codi_emex = @pCodiEmex 
								and	dh.codi_empr = @pCodiEmpr 
								and	dp.codi_pers = dh.codi_pers
									left join dbax_defi_grup dg
									on	dg.codi_grup = dp.codi_grup,
							dbax_inst_docu id
					where	(dp.codi_pers like '%' + @pDescripcion + '%' 
							or upper(dh.desc_empr) like '%' + @pDescripcion + '%' 
							or upper(dp.desc_pers) like '%' + @pDescripcion + '%')
					and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
					and		dp.codi_pers = id.codi_pers
					and		id.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
					and		dp.empr_vige = 'SI') v
			left join dbax_defi_segm ds
				on v.codi_segm = ds.codi_segm
			left join dbax_tipo_taxo tt
				on v.tipo_taxo = tt.tipo_taxo,
			dbax_inst_vers vt
			where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
			and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo
			and	vt.codi_pers = v.codi_pers
			and	vt.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
			and	vt.vers_inst >= @vMinVers
			and	vt.vers_inst < @vMaxiVers
			and vt.vers_inst= dbo.FU_AX_getUltimaVersion(vt.codi_pers, vt.corr_inst)
			order by v.desc_pers asc
		end
	end
END




/****** Objeto:  StoredProcedure [dbo].[SP_AX_getArchivosPorGrupoSegmento]    Fecha de la secuencia de comandos: 12/12/2013 09:28:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER procedure [dbo].[SP_AX_getArchivosPorGrupoSegmento](
@pCodiEmex varchar(30),
@pCodiEmpr numeric (9,0),
@pCorrInst varchar(10),
@pDescripcion varchar(100),
@pGrupo varchar(50),
@pSegmento varchar(50),
@pTipo varchar(10),
@pNombArch varchar(100),
@pTipoArch varchar(10)='Oficial')
as
BEGIN
	/*	
		@pTipoDesc = 'D' se devuelve descripcion "por defecto", 
		@pTipoDesc = 'P' devuelve descripcion por defecto y personalizada
		@pTipoDesc  = 'C' SE DEVUELVE SOLO LAS DE MAS DE UNA VERSIÓN

		@pTipoArch = Oficial significa oficial, Externo = externo (no oficial)
	*/
	declare @vComodinGrup varchar(1)
	declare @vComodinSegm varchar(1)
	declare @vComodinTipo varchar(1)
	declare @vMaxiVers numeric(3,0)
	declare @vMinVers numeric(2,0)
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
	if(@pTipoArch='Oficial')
	begin
		set @vMinVers = 0
		set @vMaxiVers = 30
	end
	else
	begin
		set @vMinVers = 30
		set @vMaxiVers = 999
	end

	declare @AccesoLimitado numeric(4,0)
	select @AccesoLimitado = count(*) from dbax_exte_pers where codi_emex = @pCodiEmex

	Print @vMinVers
	Print @vMaxiVers
	Print @AccesoLimitado
	if(@AccesoLimitado > 0)
	--inicio acceso limitado
	begin
		if(@pTipoArch = 'Oficial')
		begin
		--Inicio oficial
			select t.codi_pers, t.corr_inst, ia.vers_inst, max(ia.nomb_arch) nomb_arch
			from (select	v.desc_pers, v.codi_pers, v.corr_inst
				 from	(select distinct dp.codi_pers as codi_pers,
										dg.desc_grup as desc_grup,
										dp.codi_grup as codi_grup,
										dp.codi_segm as codi_segm,
										id.corr_inst as corr_inst,
										dp.tipo_taxo as tipo_taxo,
										dp.desc_pers as desc_pers
						from	dbax_defi_pers dp 
									left join dbax_defi_peho dh 
									on	dh.codi_emex = @pCodiEmex 
									and	dh.codi_empr = @pCodiEmpr 
									and	dp.codi_pers = dh.codi_pers
										left join dbax_defi_grup dg
										on	dg.codi_grup = dp.codi_grup,
								dbax_inst_docu id,
								dbax_exte_pers ep
						where	(dp.codi_pers like '%' + @pDescripcion + '%' 
								or dh.desc_empr like '%' + @pDescripcion + '%' 
								or dp.desc_pers like '%' + @pDescripcion + '%')
						and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
						and		dp.codi_pers = id.codi_pers
						and		id.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
						and		dp.empr_vige = 'SI'
						and		ep.codi_emex = dh.codi_emex
						and		ep.codi_pers = id.codi_pers
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
				and	vt.vers_inst >= @vMinVers
				and	vt.vers_inst < @vMaxiVers) t
			left join dbax_inst_arch ia
			on	t.codi_pers = ia.codi_pers
			and	t.corr_inst = ia.corr_inst
			and	ia.vers_inst = dbo.FU_AX_getUltimaVersion(ia.codi_pers, ia.corr_inst)
			and	ia.nomb_arch like @pNombArch + '%'
			group by t.desc_pers, t.codi_pers, t.corr_inst, ia.vers_inst
			order by t.desc_pers, t.codi_pers, t.corr_inst, ia.vers_inst
		end
		--fin oficial
		else
		--inicio externo
		begin
			select t.codi_pers, t.corr_inst, ia.vers_inst, max(ia.nomb_arch) nomb_arch
			from (select	v.desc_pers, v.codi_pers, v.corr_inst
				 from	(select distinct dp.codi_pers as codi_pers,
										dg.desc_grup as desc_grup,
										dp.codi_grup as codi_grup,
										dp.codi_segm as codi_segm,
										id.corr_inst as corr_inst,
										dp.tipo_taxo as tipo_taxo,
										dp.desc_pers as desc_pers
						from	dbax_defi_pers dp 
									left join dbax_defi_peho dh 
									on	dh.codi_emex = @pCodiEmex 
									and	dh.codi_empr = @pCodiEmpr 
									and	dp.codi_pers = dh.codi_pers
										left join dbax_defi_grup dg
										on	dg.codi_grup = dp.codi_grup,
								dbax_inst_docu id,
								dbax_exte_pers ep
						where	(dp.codi_pers like '%' + @pDescripcion + '%' 
								or dh.desc_empr like '%' + @pDescripcion + '%' 
								or dp.desc_pers like '%' + @pDescripcion + '%')
						and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
						and		dp.codi_pers = id.codi_pers
						and		id.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
						and		dp.empr_vige = 'SI'
						and		ep.codi_emex = dh.codi_emex
						and		ep.codi_pers = id.codi_pers
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
				and	vt.vers_inst >= @vMinVers
				and	vt.vers_inst < @vMaxiVers) t
			left join dbax_inst_arch ia
			on	t.codi_pers = ia.codi_pers
			and	t.corr_inst = ia.corr_inst
			and	ia.vers_inst = dbo.FU_AX_getUltimaVersionExterna(ia.codi_pers, ia.corr_inst,@vMinVers,@vMaxiVers)
			and	ia.nomb_arch like @pNombArch + '%'
			group by t.desc_pers, t.codi_pers, t.corr_inst, ia.vers_inst
			order by t.desc_pers, t.codi_pers, t.corr_inst, ia.vers_inst
		end
		--fin externo
	end
	--Fin acceso limitado
	else
	begin
	--inicio accceso ilimitado
		if(@pTipoArch = 'Oficial')
		begin
		--Inicio oficial
			select t.codi_pers, t.corr_inst, ia.vers_inst, max(ia.nomb_arch) nomb_arch
			from (select	v.desc_pers, v.codi_pers, v.corr_inst
				 from	(select distinct dp.codi_pers as codi_pers,
										dg.desc_grup as desc_grup,
										dp.codi_grup as codi_grup,
										dp.codi_segm as codi_segm,
										id.corr_inst as corr_inst,
										dp.tipo_taxo as tipo_taxo,
										dp.desc_pers as desc_pers
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
						and		dp.empr_vige = 'SI'
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
				and	vt.vers_inst >= @vMinVers
				and	vt.vers_inst < @vMaxiVers) t
			left join dbax_inst_arch ia
			on	t.codi_pers = ia.codi_pers
			and	t.corr_inst = ia.corr_inst
			and	ia.vers_inst = dbo.FU_AX_getUltimaVersion(ia.codi_pers, ia.corr_inst)
			and	ia.nomb_arch like @pNombArch + '%'
			group by t.desc_pers, t.codi_pers, t.corr_inst, ia.vers_inst
			order by t.desc_pers, t.codi_pers, t.corr_inst, ia.vers_inst
		end
		--Fin oficial
		else
		--Inicio externo
		begin
			select t.codi_pers, t.corr_inst, ia.vers_inst, max(ia.nomb_arch) nomb_arch
			from (select	v.desc_pers, v.codi_pers, v.corr_inst
				 from	(select distinct dp.codi_pers as codi_pers,
										dg.desc_grup as desc_grup,
										dp.codi_grup as codi_grup,
										dp.codi_segm as codi_segm,
										id.corr_inst as corr_inst,
										dp.tipo_taxo as tipo_taxo,
										dp.desc_pers as desc_pers
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
						and		dp.empr_vige = 'SI'
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
				and	vt.vers_inst >= @vMinVers
				and	vt.vers_inst < @vMaxiVers) t
			left join dbax_inst_arch ia
			on	t.codi_pers = ia.codi_pers
			and	t.corr_inst = ia.corr_inst
			and	ia.vers_inst = dbo.FU_AX_getUltimaVersionExterna(ia.codi_pers, ia.corr_inst,@vMinVers,@vMaxiVers)
			and	ia.nomb_arch like @pNombArch + '%'
			group by t.desc_pers, t.codi_pers, t.corr_inst, ia.vers_inst
			order by t.desc_pers, t.codi_pers, t.corr_inst, ia.vers_inst
		end
		--Fin externo
	end
	--fin accceso ilimitado
END
GO

/****** Objeto:  StoredProcedure [dbo].[SP_AX_getPersCorrVersInst]    Fecha de la secuencia de comandos: 12/12/2013 09:29:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[SP_AX_getPersCorrVersInst](
	@pCodiPers varchar(30),
	@pCorrInst numeric(10,0),
	@pTipoXbrl varchar(1),
	@pTipo varchar(1)='T') as
BEGIN
	/*
		@pTipo = T -> Todas
		@pTipo = M -> Maxima (la ultima)
		@pTipo = S -> Siguiente (la que sigue)

		@pTipoXbrl='I' -> Interno -> XBRL oficial
		@pTipoXbrl='E' -> Externo -> XBRL cargado manualmente (no oficial)
	*/
	if(@pTipo='T')
	begin
		if(@pTipoXbrl='I')
		begin
			select distinct vers_inst, vers_inst
			from	dbax_inst_vers
			where	codi_pers = @pCodiPers
			and		corr_inst = @pCorrInst
			and     vers_inst < 30
			order by 1 desc
		end
		else if (@pTipoXbrl='E')
		begin
			select distinct vers_inst, vers_inst
			from	dbax_inst_vers
			where	codi_pers = @pCodiPers
			and		corr_inst = @pCorrInst
			and     vers_inst >= 30
			order by 1 desc
		end
	end 
	else if(@pTipo='M')
	begin
		select distinct top 1  isnull(max(vers_inst),'0'), isnull(max(vers_inst),'0')
		from	dbax_inst_vers
		where	codi_pers = @pCodiPers
		and		corr_inst = @pCorrInst
		and     vers_inst < 30
		order by 1 desc
	end
	else if(@pTipo='S')
		begin
			if(@pTipoXbrl='I')
			begin
				select distinct top 1 isnull(max(vers_inst),0) + 1, isnull(max(vers_inst),0) + 1
				from	dbax_inst_vers
				where	codi_pers = @pCodiPers
				and		corr_inst = @pCorrInst
				and     vers_inst < 30
				order by 1 desc
			end
			else if (@pTipoXbrl='E')
			begin
				
				select distinct top 1 isnull(max(vers_inst),29) + 1, isnull(max(vers_inst),29) + 1
				from	dbax_inst_vers
				where	codi_pers = @pCodiPers
				and		corr_inst = @pCorrInst
				and     vers_inst > 29
				order by 1 desc
			end
		end
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER function [dbo].[FU_AX_getUltimaVersion](
			@p_codi_empr numeric(10), 
			@p_fini_cntx varchar(50)) returns numeric(5,0)
begin
	declare @vVersion numeric(5,0)

	select @vVersion = max(vers_inst) 
	from dbax_inst_vers 
	where codi_pers = @p_codi_empr 
	and corr_inst = @p_fini_cntx
	and	vers_inst < 30
	return @vVersion
end
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Objeto:  UserDefinedFunction [dbo].[FU_AX_getUltimaVersionExterna]    Fecha de la secuencia de comandos: 12/12/2013 09:30:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER function [dbo].[FU_AX_getUltimaVersionExterna](
			@p_codi_empr numeric(10), 
			@p_fini_cntx varchar(50),
			@p_Min_Vers numeric(2,0) = 0,
			@p_Max_Vers numeric(3,0) = 999) returns numeric(5,0)
begin
	declare @vVersion numeric(5,0)

	select @vVersion = max(vers_inst) 
	from dbax_inst_vers 
	where codi_pers = @p_codi_empr 
	and corr_inst = @p_fini_cntx
	and	vers_inst >= @p_Min_Vers
	and	vers_inst < @p_Max_Vers

	return @vVersion
end
GO

ALTER function [dbo].[separaMiles] (@p_valor varchar(8000)) returns varchar(8000)
as
begin
	declare	@v_entero varchar(8000)
	declare	@v_numero  varchar(8000)
	declare	@v_decimal varchar(30)
	declare	@subvalor varchar (3)
    declare @v_signo varchar(1)
	
	declare @pLargo	  integer
	select  @pLargo = param_value from sys_param where param_name = 'DBAX_LARG_DECI'
	set     @p_valor = replace(@p_valor,',','.')
	
	if(dbo.esNumero(@p_valor)='S' and @p_valor != '')
	begin
		set @p_valor = convert(varchar(256), convert(decimal(38,14),@p_valor))

		set @v_numero = ''
		set @v_signo = ''
		if(substring(@p_valor,1,1)='-')
		begin
			set @v_signo='-'
			set @p_valor=replace(@p_valor,'-','')
		end

		if (charindex('.', @p_valor)>0)
		begin
			set @v_entero  = substring(@p_valor,1,charindex('.', @p_valor)-1)
			set @v_decimal = substring(@p_valor,charindex('.', @p_valor)+1, 256)
			set @v_decimal = replace(round('0.' + @v_decimal, @pLargo),'0.','')
		end
		else
		begin
			set @v_entero  = @p_valor
		end

		while(len(@v_entero) > 3)
		begin
			set @subvalor = substring(@v_entero, len(@v_entero)-2, 3)
			set @v_numero = '.' + @subvalor +  @v_numero
			set @v_entero = substring(@v_entero, 1, len(@v_entero)-3)
		end

		if(@v_signo = '')
			set @v_numero = @v_entero + @v_numero
		else
			set @v_numero = @v_signo + @v_entero + @v_numero

		if(@v_decimal!='0')
		begin
			set @v_numero = @v_numero + ',' + @v_decimal
		end
			
	end
	else
	begin
		set @v_numero = '<div>' + replace(replace(@p_valor,'<!--',''),'-->','') + '</div>'
	end
	
	return @v_numero 
end
GO

ALTER procedure [dbo].[SP_AX_inssServicio] (@prog_proc varchar(128), @args_proc varchar(1024)) as

BEGIN
declare @pRuta_bianrio varchar(256)
declare @pFecha_ini varchar(256)

  set @pRuta_bianrio = (select PARAM_VALUE from sys_param where PARAM_NAME = 'DBAX_XBRL_BINA')
  set @pFecha_ini  = (select getdate())
  set @pRuta_bianrio = @pRuta_bianrio + '\' + @prog_proc
	insert dbax_dbne_proc(prog_proc,args_proc, fech_crea, fini_proc, esta_proc) 
	values (@pRuta_bianrio,@args_proc, @pFecha_ini, NULL, 'I')
END

GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER procedure [dbo].[SP_AX_getInformesContextos ]
	@p_CodiEmex varchar(30),
	@p_CodiEmpr varchar(100),
	@p_CorrInst numeric(10,0),
	@p_CodiInfo varchar(50)
as
BEGIN
	/*select	dc.codi_cntx, 
			dc.diai_cntx, dc.anoi_cntx,
			dc.diat_cntx, dc.anot_cntx,
			dbo.FU_AX_getFechas(@p_CorrInst, dc.diai_cntx, dc.anoi_cntx) fini_cntx, 
			dbo.FU_AX_getFechas(@p_CorrInst, dc.diat_cntx, dc.anot_cntx) ffin_cntx,
			dc.desc_cntx,
			ic.orde_cntx
	from	dbax_defi_cntx dc,
			dbax_info_cntx ic
	where	((dc.codi_emex = '0' and dc.codi_empr = 0) or (dc.codi_emex = @p_CodiEmex and dc.codi_empr = @p_CodiEmpr))
	and		ic.codi_emex = @p_CodiEmex
	and		ic.codi_empr = @p_CodiEmpr
	and		ic.codi_info = @p_CodiInfo
	and		ic.codi_cntx = dc.codi_cntx
	order by ic.orde_cntx*/

	select	dc.codi_cntx, 
			dc.diai_cntx, dc.anoi_cntx,
			dc.diat_cntx, dc.anot_cntx,
			dbo.FU_AX_getFechas(@p_CorrInst, dc.diai_cntx, dc.anoi_cntx) fini_cntx, 
			dbo.FU_AX_getFechas(@p_CorrInst, dc.diat_cntx, dc.anot_cntx) ffin_cntx,
			dc.desc_cntx,
			ic.orde_cntx
	from	dbax_info_cntx ic,
			dbax_defi_cntx dc		
	where	((ic.emex_cntx = '0' and ic.empr_cntx = 0) or (ic.emex_cntx = @p_CodiEmex and ic.empr_cntx = @p_CodiEmpr))
	and		ic.codi_info = @p_CodiInfo
	and		((dc.codi_emex = '0' and dc.codi_empr = 0) or (dc.codi_emex = @p_CodiEmex and dc.codi_empr = @p_CodiEmpr))
	and		dc.codi_cntx = ic.codi_cntx
	order by ic.orde_cntx
END
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER procedure [dbo].[SP_AX_insInfoCntx] 
	@p_codi_emex varchar(30),
	@p_codi_empr varchar(10),
	@p_Codi_informe varchar(100),
	@p_cntx_emex varchar(30),
	@p_cntx_empr varchar(10),
	@p_codi_cntx varchar(100),
	@p_Orden varchar(10)
 as
BEGIN
	insert dbax_info_cntx (codi_emex, codi_empr, codi_info, emex_cntx, empr_cntx, codi_cntx, orde_cntx) 
	values (@p_codi_emex, @p_codi_empr, @p_Codi_informe, @p_cntx_emex, @p_cntx_empr, @p_codi_cntx, @p_Orden)
END
GO

ALTER procedure [dbo].[SP_AX_getPrefConcPorCodiConc]
	@p_codi_emex varchar(50),
	@p_codi_empr numeric(9,0),
	@p_codi_conc varchar(256)	
AS
BEGIN
	select	dc.pref_conc, dc.codi_conc, ct.tipo_taxo
	from	dbax_defi_conc dc, dbax_conc_tita ct
	where	dc.pref_conc = ct.pref_conc 
	and		dc.codi_conc = ct.codi_conc
	and		dc.codi_conc = @p_codi_conc
	union
	select	'indi', fe.codi_indi, fe.tipo_taxo
	from	dbax_form_enca fe
	where	((fe.codi_emex = '0' and fe.codi_empr = '0') or (fe.codi_emex = @p_codi_emex and fe.codi_empr = @p_codi_empr))
	and		fe.codi_indi = @p_codi_conc
END
GO

--Hecho por daniel
ALTER procedure [dbo].[SP_AX_getEmpresaPorGrupoSegmento](
	@pCodiEmex varchar(30),
	@pCodiEmpr numeric (9,0),
	@pCorrInst varchar(10),
	@pDescripcion varchar(100),
	@pGrupo varchar(50),
	@pSegmento varchar(50),
	@pTipo varchar(10),
	@pTipoDesc varchar(100) = 'P',
	@pTipoArch varchar(10) = 'Oficial'
	)
as
BEGIN
	--select @pTipoDesc, @pTipoArch
	/*	
		@pTipoDesc = 'P' devuelve descripcion por defecto y personalizada
		@pTipoDesc  = 'C' SE DEVUELVE SOLO LAS DE MAS DE UNA VERSIÓN
		@pTipoDesc  = 'E' SE DEVUELVE SOLO LAS QUE TENGAN CORR_INST CREADO

		@pTipoArch = O significa oficial, E = externo (no oficial)
	*/

	set @pDescripcion = upper(@pDescripcion)

	declare @vComodinGrup varchar(1)
	declare @vComodinSegm varchar(1)
	declare @vComodinTipo varchar(1)
	declare @vComodinCorr varchar(1)
	declare @AccesoLimitado numeric(4,0)
	declare @vMaxiVers numeric(3,0)
	declare @vMinVers numeric(2,0)

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

	if(@pTipoArch='Oficial')
	begin
		set @vMinVers = 0
		set @vMaxiVers = 30
	end
	else
	begin
		set @vMinVers = 30
		set @vMaxiVers = 999
	end

	-- TODAS LAS EMPRESAS
	if(@pTipoDesc = 'P') 
	begin
		select @AccesoLimitado = count(*) from dbax_exte_pers where codi_emex = @pCodiEmex

		--Todos los periodos
		if(@pCorrInst = '')
		BEGIN
			if(@AccesoLimitado > 0)
			begin
				select	v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, desc_tipo
				from	(select distinct dp.codi_pers as codi_pers,
										dp.desc_pers as desc_pers,
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
								dbax_inst_docu id,
								dbax_exte_pers ep
						where	(dp.codi_pers like '%' + @pDescripcion + '%' 
								or upper(dh.desc_empr) like '%' + @pDescripcion + '%' 
								or upper(dp.desc_pers) like '%' + @pDescripcion + '%')
						and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
						and		dp.codi_pers = id.codi_pers
						and		dp.empr_vige = 'SI'
						and		ep.codi_emex = dh.codi_emex
						and		ep.codi_pers = id.codi_pers) v
				left join dbax_defi_segm ds
					on v.codi_segm = ds.codi_segm
				left join dbax_tipo_taxo tt
					on v.tipo_taxo = tt.tipo_taxo
				where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
				and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo
				order by v.desc_pers asc
			end
			else
			begin
				select	v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, desc_tipo
				from	(select distinct dp.codi_pers as codi_pers,
										dp.desc_pers as desc_pers,
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
								or upper(dh.desc_empr) like '%' + @pDescripcion + '%' 
								or upper(dp.desc_pers) like '%' + @pDescripcion + '%')
						and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
						and		dp.codi_pers = id.codi_pers
						and		dp.empr_vige = 'SI') v
				left join dbax_defi_segm ds
					on v.codi_segm = ds.codi_segm
				left join dbax_tipo_taxo tt
					on v.tipo_taxo = tt.tipo_taxo
				where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
				and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo
				order by v.desc_pers asc
			end
		END
		--Fin todos los periodos
		ELSE
		--Un periodo en particular
		BEGIN
			if(@AccesoLimitado > 0)
			begin
		
				select	v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, desc_tipo, v.vers_inst, @pCorrInst corr_inst
				from	(select distinct dp.codi_pers as codi_pers,
										dp.desc_pers as desc_pers,
										isnull(dh.desc_empr,dp.desc_pers) as desc_peho,
										dg.desc_grup as desc_grup,
										dp.codi_grup as codi_grup,
										dp.codi_segm as codi_segm,
										dp.tipo_taxo as tipo_taxo,
										(select max(vi.vers_inst) from dbax_inst_vers vi where vi.corr_inst = isnull(@pCorrInst,0) and vi.codi_pers = dp.codi_pers) as vers_inst
						from	dbax_defi_pers dp 
									left join dbax_defi_peho dh 
									on	dh.codi_emex = @pCodiEmex 
									and	dh.codi_empr = @pCodiEmpr 
									and	dp.codi_pers = dh.codi_pers
										left join dbax_defi_grup dg
										on	dg.codi_grup = dp.codi_grup,
								dbax_inst_docu id,
								dbax_exte_pers ep
						where	(dp.codi_pers like '%' + @pDescripcion + '%' 
								or upper(dh.desc_empr) like '%' + @pDescripcion + '%' 
								or upper(dp.desc_pers) like '%' + @pDescripcion + '%')
						and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
						and		dp.codi_pers = id.codi_pers
						and		dp.empr_vige = 'SI'
						and		ep.codi_emex = dh.codi_emex
						and		ep.codi_pers = id.codi_pers) v
				left join dbax_defi_segm ds
					on v.codi_segm = ds.codi_segm
				left join dbax_tipo_taxo tt
					on v.tipo_taxo = tt.tipo_taxo
				where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
				and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo
				order by v.desc_pers asc
			end
			else
			begin
	
				select	v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, desc_tipo, v.vers_inst, @pCorrInst corr_inst
				from	(select distinct dp.codi_pers as codi_pers,
										dp.desc_pers as desc_pers,
										isnull(dh.desc_empr,dp.desc_pers) as desc_peho,
										dg.desc_grup as desc_grup,
										dp.codi_grup as codi_grup,
										dp.codi_segm as codi_segm,
										dp.tipo_taxo as tipo_taxo,
										(select max(vi.vers_inst) from dbax_inst_vers vi where vi.corr_inst = isnull(@pCorrInst,0) and vi.codi_pers = dp.codi_pers) as vers_inst
						from	dbax_defi_pers dp 
									left join dbax_defi_peho dh 
									on	dh.codi_emex = @pCodiEmex 
									and	dh.codi_empr = @pCodiEmpr 
									and	dp.codi_pers = dh.codi_pers
										left join dbax_defi_grup dg
										on	dg.codi_grup = dp.codi_grup,
								dbax_inst_docu id
						where	(dp.codi_pers like '%' + @pDescripcion + '%' 
								or upper(dh.desc_empr) like '%' + @pDescripcion + '%' 
								or upper(dp.desc_pers) like '%' + @pDescripcion + '%')
						and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
						and		dp.codi_pers = id.codi_pers
						and		dp.empr_vige = 'SI') v
				left join dbax_defi_segm ds
					on v.codi_segm = ds.codi_segm
				left join dbax_tipo_taxo tt
					on v.tipo_taxo = tt.tipo_taxo
				where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
				and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo
				order by v.desc_pers asc
			end
		END
		--Fin un periodo en particular
	end
	--Fin todas las empresas
	
	if(@pTipoDesc = 'C') -- SE DEVUELVE SOLO LAS DE MAS DE UNA VERSIÓN (para grilla de diferencias)
	begin
		select	distinct v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, desc_tipo, vt.vers_inst
		from	(select distinct dp.codi_pers as codi_pers,
								dp.desc_pers as desc_pers,
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
						or upper(dh.desc_empr) like '%' + @pDescripcion + '%' 
						or upper(dp.desc_pers) like '%' + @pDescripcion + '%')
				and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
				and		dp.codi_pers = id.codi_pers
				and		id.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
				and		dp.empr_vige = 'SI') v
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
		order by v.desc_pers asc
	end

	if(@pTipoDesc = 'E') -- TODAS LAS EMPRESAS CON PERIODO CREADO CORR_INST
	begin
		select @AccesoLimitado = count(*) from dbax_exte_pers where codi_emex = @pCodiEmex

		if(@AccesoLimitado > 0)
		begin
			Print 'Acceso limitado > 0'
			print 1
			--select @pCodiEmex, @pCodiEmpr, @pDescripcion, @pGrupo, @pCorrInst, @pSegmento, @pTipo
			select	v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, desc_tipo
			from	(select distinct dp.codi_pers as codi_pers,
									dp.desc_pers as desc_pers,
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
							dbax_inst_docu id,
							dbax_exte_pers ep
					where	(dp.codi_pers like '%' + @pDescripcion + '%' 
							or upper(dh.desc_empr) like '%' + @pDescripcion + '%' 
							or upper(dp.desc_pers) like '%' + @pDescripcion + '%')
					and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
					and		dp.codi_pers = id.codi_pers
					and		id.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
					and		dp.empr_vige = 'SI'
					and		ep.codi_emex = dh.codi_emex
					and		ep.codi_pers = id.codi_pers) v
			left join dbax_defi_segm ds
				on v.codi_segm = ds.codi_segm
			left join dbax_tipo_taxo tt
				on v.tipo_taxo = tt.tipo_taxo,
			dbax_inst_vers vt
			where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
			and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo
			and	vt.codi_pers = v.codi_pers
			and	vt.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
			and	vt.vers_inst >= @vMinVers
			and	vt.vers_inst < @vMaxiVers
			and vt.vers_inst= dbo.FU_AX_getUltimaVersion(v.codi_pers, @pCorrInst)
			order by v.desc_pers asc
		end
		else
		begin
			--Select @vMinVers, @vMaxiVers
			
			Print 'Acceso limitado >= 0'
			--select @pCodiEmex, @pCodiEmpr, @pDescripcion, @pGrupo, @pCorrInst, @pSegmento, @pTipo
			select	v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, desc_tipo
			from	(select distinct dp.codi_pers as codi_pers,
									dp.desc_pers as desc_pers,
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
							or upper(dh.desc_empr) like '%' + @pDescripcion + '%' 
							or upper(dp.desc_pers) like '%' + @pDescripcion + '%')
					and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
					and		dp.codi_pers = id.codi_pers
					and		id.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
					and		dp.empr_vige = 'SI') v
			left join dbax_defi_segm ds
				on v.codi_segm = ds.codi_segm
			left join dbax_tipo_taxo tt
				on v.tipo_taxo = tt.tipo_taxo,
			dbax_inst_vers vt
			where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
			and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo
			and	vt.codi_pers = v.codi_pers
			and	vt.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
			and	vt.vers_inst >= @vMinVers
			and	vt.vers_inst < @vMaxiVers
			and vt.vers_inst= dbo.FU_AX_getUltimaVersion(v.codi_pers, @pCorrInst)
			order by v.desc_pers asc
		end
	end
END
GO

/****** Object:  StoredProcedure [dbo].[SP_AX_insInstValoConc]    Script Date: 12/19/2013 17:36:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_AX_insInstValoConc]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_AX_insInstValoConc]
GO

/****** Object:  StoredProcedure [dbo].[SP_AX_insInstValoConc]    Script Date: 12/19/2013 17:36:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[SP_AX_insInstValoConc] (
@pCorrConc numeric(10,0),
@pCodiPers varchar(16),
@pCorrInst numeric(10,0),
@pVersInst numeric(5,0),
@pValoConc text)
AS
BEGIN
insert into dbax_inst_valo
 (corr_conc, codi_pers, corr_inst, vers_inst,clob_conc) 
 values (@pCorrConc,@pCodiPers,@pCorrInst,@pVersInst,@pValoConc) 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_AX_GetCorrConc]    Script Date: 12/19/2013 18:12:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_AX_GetCorrConc]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_AX_GetCorrConc]
GO

/****** Object:  StoredProcedure [dbo].[SP_AX_GetCorrConc]    Script Date: 12/19/2013 18:12:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[SP_AX_GetCorrConc] (
@pCodiPers varchar(16),
@pCorrInst numeric(10,0),
@pVersInst numeric(5,0),
@pPrefConc varchar(50),
@pCodiConc varchar(256),
@pCodiCntx varchar(256))
AS
BEGIN
select corr_conc 
from   dbax_inst_conc
where  codi_pers = @pCodiPers
and    corr_inst = @pCorrInst
and    vers_inst = @pVersInst
and    pref_conc = @pPrefConc
and    codi_conc = @pCodiConc
and    codi_cntx = @pCodiCntx
END

Go
ALTER procedure [dbo].[SP_AX_delInfoDefi] 
	@CodiEmex varchar(30),
	@CodiEmpr numeric(9,0),
	@CodiInfo varchar(50)
 as
BEGIN
	delete from dbax_desc_info
	where	codi_emex = @CodiEmex  
	and		codi_empr = @CodiEmpr
	and		codi_info = @CodiInfo
	and     tipo_info = 'C'
	
	delete from dbax_info_tita
	where	codi_emex = @CodiEmex  
	and		codi_empr = @CodiEmpr
	and		codi_info = @CodiInfo
	and     tipo_info = 'C'

	delete from dbax_info_defi
	where	codi_emex = @CodiEmex  
	and		codi_empr = @CodiEmpr
	and		codi_info = @CodiInfo
	and     tipo_info = 'C'
	
	delete from dbax_info_conc
	where	codi_emex = @CodiEmex  
	and		codi_empr = @CodiEmpr
	and		codi_info = @CodiInfo
	and     tipo_info = 'C'

END
Go
ALTER procedure [dbo].[SP_AX_delInfoDefi] 
	@CodiEmex varchar(30),
	@CodiEmpr numeric(9,0),
	@CodiInfo varchar(50)
 as
BEGIN
	delete from dbax_desc_info
	where	codi_emex = @CodiEmex  
	and		codi_empr = @CodiEmpr
	and		codi_info = @CodiInfo
	and     tipo_info = 'C'
	
	delete from dbax_info_tita
	where	codi_emex = @CodiEmex  
	and		codi_empr = @CodiEmpr
	and		codi_info = @CodiInfo
	and     tipo_info = 'C'

	delete from dbax_info_defi
	where	codi_emex = @CodiEmex  
	and		codi_empr = @CodiEmpr
	and		codi_info = @CodiInfo
	and     tipo_info = 'C'
	
	delete from dbax_info_conc
	where	codi_emex = @CodiEmex  
	and		codi_empr = @CodiEmpr
	and		codi_info = @CodiInfo
	and     tipo_info = 'C'

END
GO

ALTER procedure [dbo].[SP_AX_insInfoConc] 
@pCodiEmex varchar(30),
@pCodiEmpr numeric(9,0),
@p_Codi_info varchar(100),
@p_pref_conc varchar(50),
@p_Codi_Conc varchar(100),
@p_Orden varchar(10),
@p_Nivel varchar(10)
 as
BEGIN

insert dbax_info_conc (codi_emex, codi_empr, codi_info, pref_conc, codi_conc, orde_conc, nive_conc,tipo_info) 
values (@pCodiEmex, @pCodiEmpr,@p_Codi_info, @p_pref_conc, @p_Codi_Conc, @p_Orden, @p_Nivel,'C')
END

go

ALTER PROCEDURE [dbo].[SP_AX_updInfoDefi]
	(	
	@CodiEmex varchar(50),
	@CodiEmpr varchar(20),
	@CodiInfo varchar(50),
	@DescInfo varchar(50),
	@IndiVige varchar(1),
	@CodiCort varchar(256)
	)
AS
BEGIN
	update	dbax_desc_info 
	set desc_info = @DescInfo
	where	codi_emex =@CodiEmex 
	and		codi_empr = @CodiEmpr
	and		codi_info = @CodiInfo
	and		codi_lang = 'es_ES'
	and		tipo_info = 'C'

	update	dbax_desc_info 
	set desc_info = @CodiCort
	where	codi_emex =@CodiEmex 
	and		codi_empr = @CodiEmpr
	and		codi_info = @CodiInfo
	and		codi_lang = 'codi_cort'
	and		tipo_info = 'C'
	
	update	dbax_info_defi
	set		indi_vige = @IndiVige
	where	codi_emex =@CodiEmex 
	and		codi_empr = @CodiEmpr
	and		codi_info = @CodiInfo
	and		tipo_info = 'C'

END
Go

ALTER procedure [dbo].[SP_AX_delInfoConc] 
@pCodiEmex varchar(50),
@pCodiEmpr varchar(9),
@pCodiInfo varchar(50),
@pPrefConc varchar(50),
@pCodiConc varchar(100),
@pOrdeConc varchar(50)
 as
BEGIN
	delete	dbax_info_conc 
	where	codi_emex = @pCodiEmex
	and		codi_empr = @pCodiEmpr
	and		codi_info = @pCodiInfo
	and		pref_conc = @pPrefConc
	and		codi_conc = @pCodiConc
	and		orde_conc = @pOrdeConc
	and     tipo_info = 'C'
END
