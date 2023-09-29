ALTER procedure [dbo].[SP_AX_GetDetaIndicadores](
	@p_CodiEmex varchar(30),
	@p_CodiEmpr varchar(16),
	@p_CorrInst numeric(10,0),
	@p_CodiIndi varchar(100)) as
BEGIN
	select  de.letr_vari,
			de.pref_conc, 
			de.codi_conc, 
			de.codi_cntx, 
			ct.desc_cntx, 
			ct.diai_cntx, 
			ct.anoi_cntx, 
			dbo.FU_AX_getFechas(@p_CorrInst , ct.diai_cntx, ct.anoi_cntx) AS fini_cntx,
			ct.diat_cntx, 
			ct.anot_cntx,
			dbo.FU_AX_getFechas(@p_CorrInst , ct.diat_cntx, ct.anot_cntx) AS ffin_cntx
	from	dbax_form_deta de, 
			dbax_defi_cntx ct  
	where	de.codi_cntx =ct.codi_cntx
	and		de.codi_emex = @p_CodiEmex 
	and		de.codi_empr = @p_CodiEmpr  
	and		de.codi_indi = @p_CodiIndi 
END
GO

ALTER function [dbo].[FU_AX_getFechas](
			@p_CorrInst numeric(10,0), 
			@p_DiaMes varchar(256),
			@p_Ano varchar(256)
			) returns varchar(4000)
begin
	declare @v_Valor varchar(256)
	declare @vMesActual varchar(2)
	declare @vAnoActual varchar(4)
	declare @vMes varchar(10)
	declare @vAno varchar(4)
	declare @vUltiDiaMes varchar(4)
	declare @vUltiDiaAno varchar(10)
	declare @vFechaActual varchar(15)
	declare @vFinTrimestreAnt varchar(4)
	declare @vPrimerDiaAno varchar(10)
	declare @vAnoAnterior varchar(10)
	declare @vAnoPrevioAnt varchar(10)

	select @vAnoActual=substring(convert(varchar,@p_CorrInst),1,4)
	select @vMesActual=substring(convert(varchar,@p_CorrInst),5,2)

	set @vFechaActual = @vAnoActual + @vMesActual + '01'
	set @vUltiDiaMes = substring(replace(convert(varchar, DATEADD(dd, -DAY(DATEADD(m,1,@vFechaActual)), DATEADD(m,1,@vFechaActual)), 111),'/',''),5,4)
	set @vFinTrimestreAnt = substring(replace(convert(varchar, DATEADD(dd, -DAY(DATEADD(m,-2,@vFechaActual)), DATEADD(m,-2,@vFechaActual)), 111),'/',''),5,4)
	set @vUltiDiaAno = '1231'
	set @vPrimerDiaAno = '0101'
	set @vAnoAnterior = @vAnoActual - 1
	set @vAnoPrevioAnt = @vAnoActual - 2

	if(@p_Ano = 'anoactual')
	begin
		declare @sCorrInst varchar(10)
		set @sCorrInst = @p_CorrInst
		if(substring(@sCorrInst,5,2)='03' and @p_DiaMes = 'iniciotrimestreactual')
		begin
			set @vAno = @vAnoAnterior
		end
		else
		begin
			set @vAno = @vAnoActual			
		end
	end
	else if(@p_Ano = 'anoanterior')
		set @vAno = @vAnoAnterior
	else if(@p_Ano = 'anoprevioanterior')
		set @vAno = @vAnoPrevioAnt

	if(@p_DiaMes = 'finano')
		set @vMes = @vUltiDiaAno
	else if(@p_DiaMes = 'inicioano')
		set @vMes = @vPrimerDiaAno
	else if(@p_DiaMes = 'iniciotrimestreactual')
		set @vMes = @vFinTrimestreAnt
	else if(@p_DiaMes = 'ultimodiatrimestreactual')
		set @vMes = @vUltiDiaMes
	
	return @vAno + '-' +  substring(@vMes,1,2) + '-' + substring(@vMes,3,2)
end
GO

ALTER procedure [dbo].[SP_AX_GetCntxActuales](
	@pCodi_pers	 varchar(16),
	@pCorr_inst  numeric(10,0),
	@pVers_inst  numeric(5,0)) as

BEGIN
	declare @vffin_cntx varchar(15)
	declare @vfini_cntx varchar(15)

	set @vfini_cntx = dbo.FU_AX_getFechas(@pCorr_inst , 'inicioano', 'anoactual')
	set @vffin_cntx = dbo.FU_AX_getFechas(@pCorr_inst , 'ultimodiatrimestreactual', 'anoactual')

	select	codi_cntx, fini_cntx, ffin_cntx
	from	dbax_view_cntx
	where	codi_pers = @pCodi_pers
	and		corr_inst = @pCorr_inst
	and		vers_inst = @pVers_inst
	and		(
				(fini_cntx = @vffin_cntx and ffin_cntx is null)
				or
				(fini_cntx = @vfini_cntx and ffin_cntx = @vffin_cntx)
			)
END
GO

ALTER procedure [dbo].[SP_AX_GetListaIndicadoresEmpresa](
	@p_CodiEmex varchar(30),
	@p_CodiEmpr numeric(9,0),
	@p_TipoTaxo varchar(10),
	@p_Codi_indi varchar(100)) as
BEGIN

declare @vComoTipo varchar(1)

if(len(@p_TipoTaxo)=0)
begin
	set @vComoTipo = '%'
end
else
begin
	set @vComoTipo = ''
end

if(  @p_Codi_indi = '')
	begin
		select	codi_emex as codi_emex,
				codi_empr as codi_empr,
				codi_indi as Nombre, 
				tipo_conc as Tipo, 
				desc_indi as Descripción, 
				form_indi as Fórmula
		from	dbax_form_enca
		where	((codi_emex = '0' and codi_empr = 0) or (codi_emex = @p_CodiEmex and codi_empr = @p_CodiEmpr))
		--and     tipo_taxo like '%'+isnull(@p_TipoTaxo,'')+'%'
		and     (tipo_conc like 'indLi%' or tipo_conc like 'indEnd%')
		and		tipo_taxo like @vComoTipo + @p_TipoTaxo + @vComoTipo
	end
else
	begin
		select	codi_emex as codi_emex,
				codi_empr as codi_empr,
				codi_indi as Nombre, 
				tipo_conc as Tipo, 
				desc_indi as Descripción, 
				form_indi as Fórmula
		from	dbax_form_enca
		where	((codi_emex = '0' and codi_empr = 0) or (codi_emex = @p_CodiEmex and codi_empr = @p_CodiEmpr))
		--and     tipo_taxo like '%'+isnull(@p_TipoTaxo,'')+'%'
		and     codi_indi = @p_Codi_indi
		and		tipo_taxo like @vComoTipo + @p_TipoTaxo + @vComoTipo
	end
END
GO

ALTER procedure [dbo].[SP_AX_InsDatosCalIndicadores](
    @p_codi_emex  varchar(30),
	@p_codi_empr  numeric(9,0),
	@p_corr_inst varchar(6),
	@p_codi_grup varchar(50),
	@p_codi_segm varchar(50),
	@p_codi_indi  varchar(100),
	@p_TipoTaxo varchar(10)
) as
BEGIN
	declare @pRuta_binario varchar(256)
	declare @pFecha_ini varchar(256)

	set @pRuta_binario = (select PARAM_VALUE from sys_param where PARAM_NAME = 'DBAX_XBRL_BINA')
	set @pFecha_ini  = (select getdate())

	insert dbax_dbne_proc(prog_proc, args_proc, fech_crea, fini_proc, esta_proc) 
	values (@pRuta_binario + '\CalculoIndicadores.exe ', '"' + convert(varchar,@p_codi_emex) + '" "' + convert(varchar,@p_codi_empr) + '" "' + @p_corr_inst + '" "' + convert(varchar,@p_codi_grup) + '" "' + convert(varchar,@p_codi_segm) + '" "' + convert(varchar,@p_codi_indi) + '" "' + @p_TipoTaxo + '"', @pFecha_ini, @pFecha_ini, 'I')
END
GO

CREATE NONCLUSTERED INDEX [_dta_index_dbax_info_conc_2] ON [dbo].[dbax_info_conc] 
(
	[codi_conc] ASC,
	[pref_conc] ASC
)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [_dta_index_dbax_inst_conc_idx6] ON [dbo].[dbax_inst_conc] 
(
	[codi_conc] ASC,
	[pref_conc] ASC
)
INCLUDE ( [corr_conc],
[codi_pers],
[corr_inst],
[vers_inst]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO

AGREGAR EMEX_CNTX, EMPR_CNTX y FK con DBAX_DEFI_CNTX

/****** Objeto:  StoredProcedure [dbo].[SP_AX_InsDetaIndi]    Fecha de la secuencia de comandos: 10/22/2013 18:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_InsDetaIndi](
	@p_codi_emex  varchar(30),
	@p_codi_empr  numeric(9,0),
	@p_codi_indi  varchar(100),
	@p_letr_vari  varchar(20),
	@p_pref_conc  varchar(256),
	@p_codi_conc  varchar(100),
	@p_emex_cntx  varchar(30),
	@p_empr_cntx  numeric(9,0),
	@p_codi_cntx  varchar(50)) as
BEGIN
	insert into dbax_form_deta (codi_emex, codi_empr, codi_indi, letr_vari, pref_conc, codi_conc, emex_cntx, empr_cntx, codi_cntx)
	values					   (@p_codi_emex, @p_codi_empr, @p_codi_indi, @p_letr_vari, @p_pref_conc, @p_codi_conc, @p_emex_cntx, @p_empr_cntx, @p_codi_cntx)
END
GO

ALTER procedure [dbo].[SP_AX_GetDetaIndicadores](
	@p_CodiEmex varchar(30),
	@p_CodiEmpr varchar(16),
	@p_CorrInst numeric(10,0),
	@p_CodiIndi varchar(100)) as
BEGIN
	select  de.letr_vari,
			de.pref_conc, 
			de.codi_conc, 
			de.codi_cntx, 
			ct.desc_cntx, 
			ct.diai_cntx, 
			ct.anoi_cntx, 
			dbo.FU_AX_getFechas(@p_CorrInst , ct.diai_cntx, ct.anoi_cntx) AS fini_cntx,
			ct.diat_cntx, 
			ct.anot_cntx,
			dbo.FU_AX_getFechas(@p_CorrInst , ct.diat_cntx, ct.anot_cntx) AS ffin_cntx
	from	dbax_form_deta de, 
			dbax_defi_cntx ct  
	where	de.codi_emex = @p_CodiEmex 
	and		de.codi_empr = @p_CodiEmpr  
	and		de.codi_indi = @p_CodiIndi 
	and		de.emex_cntx = ct.codi_emex
	and		de.empr_cntx = ct.codi_empr
	and		de.codi_cntx = ct.codi_cntx
END
GO

CREATE procedure [dbo].[SP_AX_GetCntxActuales](
	@pCodi_pers	 varchar(16),
	@pCorr_inst  numeric(10,0),
	@pVers_inst  numeric(5,0)) as

BEGIN
	declare @vffin_cntx varchar(15)
	declare @vfini_cntx varchar(15)

	set @vfini_cntx = dbo.FU_AX_getFechas(@pCorr_inst , 'inicioano', 'anoactual')
	set @vffin_cntx = dbo.FU_AX_getFechas(@pCorr_inst , 'ultimodiatrimestreactual', 'anoactual')

	select	codi_cntx, fini_cntx, ffin_cntx
	from	dbax_view_cntx
	where	codi_pers = @pCodi_pers
	and		corr_inst = @pCorr_inst
	and		vers_inst = @pVers_inst
	and		(
				(fini_cntx = @vffin_cntx and ffin_cntx is null)
				or
				(fini_cntx = @vfini_cntx and ffin_cntx = @vffin_cntx)
			)
END
Go
ALTER PROCEDURE [dbo].[SP_AX_getPrefConcPorCodiConc]
	@p_codi_conc varchar(256)
AS
BEGIN
	select dc.pref_conc, dc.codi_conc, ct.tipo_taxo
	from dbax_defi_conc dc, dbax_conc_tita ct
	where dc.pref_conc = ct.pref_conc 
	and   dc.codi_conc = ct.codi_conc
	and   dc.codi_conc = @p_codi_conc
END
Go
ALTER procedure [dbo].[SP_AX_getInforme] 
	@p_CodiEmex varchar(30),
	@p_CodiEmpr numeric(9,0),
	@pCodiInfo varchar(50),
	@pTipoInfo varchar(2) = 'C'
AS
BEGIN
	select	id.codi_info, 
			dbo.AX_getDescInfo (id.codi_emex,id.codi_empr,@pCodiInfo, 'es_ES', @pTipoInfo) as desc_info,
			dbo.AX_getDescInfo (id.codi_emex,id.codi_empr,@pCodiInfo, 'codi_cort', @pTipoInfo) as codi_cort,
			it.tipo_taxo,
			id.codi_emex,
			id.codi_empr,
			isnull(id.indi_vige,0) as indi_vige,
			id.tipo_info
	from	dbax_info_defi id, dbax_info_tita it
	where	((id.codi_emex = '0'	and		id.codi_empr = 0) or (id.codi_emex = @p_CodiEmex	and		id.codi_empr = @p_CodiEmpr))
	and     id.codi_emex = it.codi_emex
	and     id.codi_empr = it.codi_empr
	and     id.codi_info = it.codi_info
	and     id.tipo_info = it.tipo_info
	and		id.codi_info = @pCodiInfo
	and		id.tipo_info = @pTipoInfo
	order by id.orde_info
END
GO

ALTER procedure [dbo].[SP_AX_InsVisualizador](
    @p_codi_emex  varchar(30),
	@p_codi_empr  numeric(9,0),
	@p_corr_inst varchar(6),
	@p_codi_pers  varchar(16),
	@p_codi_grup varchar(50),
	@p_codi_segm varchar(50),
	@p_tipo_taxo varchar(30),
	@p_sobr_arch  varchar(1)
) as
BEGIN
	declare @pRuta_binario varchar(256)
	declare @pFecha_ini varchar(256)

	set @pRuta_binario = (select PARAM_VALUE from sys_param where PARAM_NAME = 'DBAX_XBRL_BINA')
	set @pFecha_ini  = (select getdate())

	insert dbax_dbne_proc(prog_proc, args_proc, fech_crea, fini_proc, esta_proc) 
	values (@pRuta_binario + '\dbax.GeneraHTML.exe ', 
	'"' + convert(varchar,@p_codi_emex) + '" "' + convert(varchar,@p_codi_empr) + '" "' + @p_corr_inst +  '" "' + @p_codi_pers + '" "' +convert(varchar,@p_codi_grup) + '" "' + convert(varchar,@p_codi_segm) + '" "' + convert(varchar,@p_tipo_taxo) + '" "'+@p_sobr_arch+'"', 
	@pFecha_ini, 
	@pFecha_ini,
	 'I')
END
GO

/****** Objeto:  Table [dbo].[dbax_exte_pers]    Fecha de la secuencia de comandos: 11/12/2013 13:59:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_exte_pers](
	[codi_emex] [varchar](30) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[codi_pers] [varchar](16) COLLATE Modern_Spanish_CS_AS NOT NULL,
 CONSTRAINT [PK_dbax_exte_pers] PRIMARY KEY CLUSTERED 
(
	[codi_emex] ASC,
	[codi_pers] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[dbax_exte_pers]  WITH CHECK ADD  CONSTRAINT [FK_dbax_exte_pers_dbax_exte_pers] FOREIGN KEY([codi_emex], [codi_pers])
REFERENCES [dbo].[dbax_exte_pers] ([codi_emex], [codi_pers])
GO
ALTER TABLE [dbo].[dbax_exte_pers]  WITH CHECK ADD  CONSTRAINT [FK_dbax_exte_pers_empr_exte] FOREIGN KEY([codi_pers])
REFERENCES [dbo].[dbax_defi_pers] ([codi_pers])
GO

ALTER procedure [dbo].[SP_AX_getArchivosPorGrupoSegmento](
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

	declare @AccesoLimitado numeric(4,0)
	select @AccesoLimitado = count(*) from dbax_exte_pers where codi_emex = @pCodiEmex

	if(@AccesoLimitado > 0)
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
				on v.tipo_taxo = tt.tipo_taxo
			where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
			and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo) t
		left join dbax_inst_arch ia
		on	t.codi_pers = ia.codi_pers
		and	t.corr_inst = ia.corr_inst
		and	ia.vers_inst = dbo.FU_AX_getUltimaVersion(ia.codi_pers, ia.corr_inst)
		and	ia.nomb_arch like @pNombArch + '%'
		group by t.desc_pers, t.codi_pers, t.corr_inst, ia.vers_inst
		order by t.desc_pers, t.codi_pers, t.corr_inst, ia.vers_inst
	end
	else
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
				on v.tipo_taxo = tt.tipo_taxo
			where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
			and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo) t
		left join dbax_inst_arch ia
		on	t.codi_pers = ia.codi_pers
		and	t.corr_inst = ia.corr_inst
		and	ia.vers_inst = dbo.FU_AX_getUltimaVersion(ia.codi_pers, ia.corr_inst)
		and	ia.nomb_arch like @pNombArch + '%'
		group by t.desc_pers, t.codi_pers, t.corr_inst, ia.vers_inst
		order by t.desc_pers, t.codi_pers, t.corr_inst, ia.vers_inst
	end
END
GO

ALTER procedure [dbo].[SP_AX_getEmpresaPorGrupoSegmento](
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

	set @pDescripcion = upper(@pDescripcion)

	declare @vComodinGrup varchar(1)
	declare @vComodinSegm varchar(1)
	declare @vComodinTipo varchar(1)
	declare @vComodinCorr varchar(1)
	declare @AccesoLimitado numeric(4,0)

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

	if(@pTipoDesc = 'P') -- TODAS LAS EMPRESAS
	begin
		select @AccesoLimitado = count(*) from dbax_exte_pers where codi_emex = @pCodiEmex

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
		ELSE
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
	end

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
					and		id.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
					and		dp.empr_vige = 'SI') v
			left join dbax_defi_segm ds
				on v.codi_segm = ds.codi_segm
			left join dbax_tipo_taxo tt
				on v.tipo_taxo = tt.tipo_taxo
			where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
			and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo
			order by v.desc_pers asc
		end
	end
END
GO