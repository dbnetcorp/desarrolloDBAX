--FW5
ALTER procedure [dbo].[dbnet_init_sess]
(@P_CODI_USUA varchar(30), @P_CORR_SESS numeric(22) output  )  
as
begin
declare
    @P_CODI_EMEX varchar(30),
    @P_CODI_PERS varchar(30),
    @P_CODI_MODU varchar(30),
    @P_CODI_ROUS varchar(30),
    @P_CODI_CECO varchar(30),
    @P_CODI_CULT varchar(30),
    @P_CODI_EMPR numeric(9)
 
	select  @P_CODI_EMPR = u.codi_empr,
			@P_CODI_EMEX = u.codi_emex,
			@P_CODI_CECO = u.codi_ceco,
			@P_CODI_PERS = u.codi_pers,
			@P_CODI_MODU = r.codi_modu,
			@P_CODI_CULT = u.codi_cult,
			@P_CODI_ROUS = r.codi_rous
	from	usua_sist u, sys_rous r
 	where	codi_usua = @P_CODI_USUA
			and r.codi_rous=u.codi_rous 
        
 insert into sys_session (	codi_usua,codi_empr,
							codi_emex,codi_ceco,codi_pers,
							codi_modu,codi_cult,codi_rous,fein_sess)
 values (	@P_CODI_USUA,@P_CODI_EMPR,
			@P_CODI_EMEX,@P_CODI_CECO,@P_CODI_PERS,
			@P_CODI_MODU,@P_CODI_CULT,@P_CODI_ROUS,GETDATE()) 
 set @P_CORR_SESS=@@IDENTITY  
 select  @P_CORR_SESS CORR_SESS,@P_CODI_EMPR CODI_EMPR,
	@P_CODI_EMEX CODI_EMEX,@P_CODI_CECO CODI_CECO,
	@P_CODI_PERS CODI_PERS ,@P_CODI_MODU CODI_MODU,
	@P_CODI_ROUS CODI_ROUS,@P_CODI_CULT CODI_CULT
 into #sys_session
 delete from sys_session 
 where codi_usua = @P_CODI_USUA
    and fein_sess<=GETDATE()-4 
end
GO

ALTER PROCEDURE [dbo].[prc_erro_logi_update]
@P_CODI_USUA VARCHAR(30)
AS
BEGIN
	update usua_sist set erro_logi = 0 where codi_usua = @P_CODI_USUA;
END
GO
ALTER PROCEDURE [dbo].[prc_erro_logi2_update]
@P_CODI_USUA VARCHAR(30)
AS
BEGIN
	update usua_sist set erro_logi = erro_logi + 1 where codi_usua = @P_CODI_USUA;
END
GO
ALTER  procedure [dbo].[prc_read_dbax_defi_pers] (
 @tsTipo as Varchar(2),
 @tnPagina as integer,
 @tnRegPag as integer,
 @tsCondicion as Varchar(2048),
 @tsPar1 as Varchar(256), @tsPar2 as Varchar(256),
 @tsPar3 as Varchar(256), @tsPar4 as Varchar(256), @tsPar5 as Varchar(256),
 @p_codi_usua varchar(30), @p_codi_empr int, @p_codi_emex varchar(30))
AS 
    /*
     Procedimiento para rescatar datos de la tabla DBAX_DEFI_PERS
     CON EL 
     Parametros
        @tsTipo 
            S: Query utilizada para el mantenedor 
            L: Query utilizada para el listador 
            LV: Query utilizada para las listas de valor 
        @tnPagina	: Numero de pagina a rescatar 
        @tnRegPag	: Numero de registros por pagina
        @tsCondicion : Condicion, clausula Where
        @tsPar1		: Parametro 1 - codi_pers
        @tsPar2		: Parametro 2 - descripcion
        @tsPar3		: Parametro 3 - grupo
        @tsPar4		: Parametro 4 - segmento
        @tsPar5		: Parametro 5 - tipo
        @p_codi_usua    : Usuario
        @p_codi_empr    : Empresa
        @p_codi_emex    : Emex
     */
    declare @sql_dyn as integer
    declare @sql as nvarchar(4000)
	    
	declare @vComodinGrup varchar(3)
	declare @vComodinSegm varchar(3)
	declare @vComodinTipo varchar(3)
	declare @vComodinCorr varchar(3)
	declare @vPorcentaje varchar(3)

	set @vComodinGrup = '%'
	set @vComodinSegm = '%'
	set @vComodinCorr = '%'
	set @vComodinTipo = '%'
	set @vComodinCorr = '%'
	set @vPorcentaje = '%'
	
	if (@tsPar1 is not null) -- Correlativo de Instancia
	begin
		set @vComodinCorr = ''	
	end
	
	if (@tsPar2 is null) --descripcion
	begin
		set @tsPar2  = ''
	end
	
    if (@tsPar3 is not null) --grupo
	begin
		set @vComodinGrup = ''
	end
	
	if ( @tsPar4 is not null) --Codigo Segmento
	begin
		set @vComodinSegm = ''
	end
	
	if ( @tsPar5 is not null) --Tipo
	begin
		set @vComodinTipo = ''
	end

BEGIN
  IF (@tsTipo = 'S')
  BEGIN
	select 'S'
    SELECT codi_pers, 
           desc_pers, 
           codi_grup, 
           codi_segm, 
           tipo_taxo, 
           pres_burs, 
           emis_bono
  FROM dbax_defi_pers
  WHERE codi_pers = @tsPar1
  AND desc_pers = @tsPar2
 END
 ELSE IF (@tsTipo = 'L')
 BEGIN
--	SET @sql = 'SELECT ROW_NUMBER() OVER( ORDER BY convert(numeric(9,0),v.codi_pers) ASC) AS REG,
--				v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, pres_burs, emis_bono, desc_tipo
--				from	(select distinct dp.codi_pers as codi_pers, dp.desc_pers as desc_pers,
--						isnull(dh.desc_empr,dp.desc_pers) as desc_peho,
--						dg.desc_grup as desc_grup,
--						dp.codi_grup as codi_grup,
--						dp.codi_segm as codi_segm,
--						dp.tipo_taxo as tipo_taxo,
--						dp.pres_burs as pres_burs,
--						dp.emis_bono as emis_bono,
--						dp.empr_vige
--				from	dbax_defi_pers dp 
--					left join dbax_defi_peho dh 
--					on	dh.codi_emex = '''+ @p_codi_emex +''' 
--					and	dh.codi_empr = '''+ CONVERT(varchar(9),@p_codi_empr) +''' 
--					and	dp.codi_pers = dh.codi_pers
--						left join dbax_defi_grup dg
--						on	dg.codi_grup = dp.codi_grup,
--					dbax_inst_docu id
--				where	(dp.codi_pers like ''%'+ isnull(@tsPar2,'')+'%''
--					or dh.desc_empr like  ''%' + isnull(@tsPar2,'')+'%''
--					or dp.desc_pers like ''%'+isnull(@tsPar2,'')+'%'')
--				and		isnull(dp.codi_grup,'''+''+''')like'''+@vComodinGrup+isnull(@tsPar3, '')+@vComodinGrup +'''
--				and		dp.codi_pers = id.codi_pers) v
--					left join dbax_defi_segm ds
--						on v.codi_segm = ds.codi_segm
--					left join dbax_tipo_taxo tt
--						on v.tipo_taxo = tt.tipo_taxo
--					where isnull(v.codi_segm,'''') like '''+@vComodinSegm + isnull(@tsPar4, '') + @vComodinSegm +'''
--					and	isnull(v.tipo_taxo,'''') like '''+@vComodinTipo + isnull(@tspar5, '') + @vComodinTipo   +''' '

	SET @sql = 'SELECT ROW_NUMBER() OVER( ORDER BY v.desc_pers ASC) AS REG,
				v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, pres_burs, emis_bono, desc_tipo, v.empr_vige
				from	(select distinct dp.codi_pers as codi_pers, dp.desc_pers as desc_pers,
						isnull(dh.desc_empr,dp.desc_pers) as desc_peho,
						dg.desc_grup as desc_grup,
						dp.codi_grup as codi_grup,
						dp.codi_segm as codi_segm,
						dp.tipo_taxo as tipo_taxo,
						dp.pres_burs as pres_burs,
						dp.emis_bono as emis_bono,
						dp.empr_vige
				from	dbax_defi_pers dp 
					left join dbax_defi_peho dh 
					on	dh.codi_emex = '''+ @p_codi_emex +''' 
					and	dh.codi_empr = '''+ CONVERT(varchar(9),@p_codi_empr) +''' 
					and	dp.codi_pers = dh.codi_pers
						left join dbax_defi_grup dg
						on	dg.codi_grup = dp.codi_grup
				where	dp.codi_pers like ''%'+ isnull(@tsPar1,'')+'%''
				and		isnull(dp.codi_grup,'''+''+''')like'''+@vComodinGrup+isnull(@tsPar3, '')+@vComodinGrup +''') v
					left join dbax_defi_segm ds
						on v.codi_segm = ds.codi_segm
					left join dbax_tipo_taxo tt
						on v.tipo_taxo = tt.tipo_taxo
					where isnull(v.codi_segm,'''') like '''+@vComodinSegm + isnull(@tsPar4, '') + @vComodinSegm +'''
					and	isnull(v.tipo_taxo,'''') like '''+@vComodinTipo + isnull(@tsPar5, '') + @vComodinTipo   +''' '
   set @sql = @sql + isnull(@tsCondicion,'')
   EXECUTE dbo.prc_list_dyn @sql, @tnPagina, @tnRegPag
 END
END;
GO
--DBAX
ALTER procedure [dbo].[SP_AX_GetConcPorPrefConc](
	@p_CodiEmex varchar(30),
	@p_CodiEmpr numeric(9,0),
	@p_TipoTaxo  varchar(50),
	@p_CodiConc  varchar(100),
	@p_TipoRepo varchar(30)) as
BEGIN
	if(@p_TipoRepo = 'Indicadores')
	BEGIN
		select	distinct
				--sc.desc_conc as desc_conc,
				sc.desc_conc + ' (' + cast(dc.pref_conc as varchar(12)) collate Modern_Spanish_CS_AS + ')' as desc_conc,
				dc.pref_conc as pref_conc, 
				dc.codi_conc as codi_conc 
		from	dbax_defi_conc dc, 
				dbax_desc_conc sc, 
				dbax_tipo_conc tc,
				sys_code s 
		where	dc.pref_conc = sc.pref_conc 
		and		dc.codi_conc = sc.codi_conc 
		and		dc.tipo_conc = tc.tipo_conc 
	--	and		tc.tipo_conc = 'concepto' 
		and		dc.tipo_taxo like '%' + @p_TipoTaxo + '%'
		--and		sc.desc_conc like '' + @p_CodiConc + '%'
		and		upper(sc.desc_conc  + ' (' + cast(dc.pref_conc as varchar(12)) collate Modern_Spanish_CS_AS + ')') like upper('%' + @p_CodiConc + '%')
		and		s.domain_code in ('200','210')
		and		dc.tipo_valo = s.code
		and		dc.pref_conc != 'indi'
		order by desc_conc ASC
	END
	ELSE if(@p_TipoRepo = 'RepoXBRL')
	BEGIN
		select	distinct sc.desc_conc as desc_conc,
				dc.pref_conc as pref_conc, 
				dc.codi_conc as codi_conc 
		from	dbax_defi_conc dc, 
				dbax_desc_conc sc, 
				dbax_tipo_conc tc,
				sys_code s 
		where	dc.pref_conc = sc.pref_conc 
		and		dc.codi_conc = sc.codi_conc 
		and		dc.tipo_conc = tc.tipo_conc 
	--	and		tc.tipo_conc = 'concepto' 
		and		dc.tipo_taxo like '%' + @p_TipoTaxo + '%'
		and		upper(sc.desc_conc) like upper('%' + @p_CodiConc + '%')
		and		s.domain_code in ('200','210')
		and		dc.tipo_valo = s.code
		order by desc_conc ASC
	END	
END
GO

--DBAXDESA
--ALTER procedure [dbo].[SP_AX_GetConcPorPrefConc](
--	@p_CodiEmex varchar(30),
--	@p_CodiEmpr numeric(9,0),
--	@p_TipoTaxo  varchar(50),
--	@p_CodiConc  varchar(100),
--	@p_TipoRepo varchar(30)) as
--BEGIN
--	if(@p_TipoRepo = 'Indicadores')
--	BEGIN
--		select	distinct sc.desc_conc as desc_conc,
--				dc.pref_conc as pref_conc, 
--				dc.codi_conc as codi_conc 
--		from	dbax_defi_conc dc, 
--				dbax_desc_conc sc, 
--				dbax_tipo_conc tc,
--				sys_code s 
--		where	dc.pref_conc = sc.pref_conc 
--		and		dc.codi_conc = sc.codi_conc 
--		and		dc.tipo_conc = tc.tipo_conc 
--		and		dc.tipo_taxo like '%' + @p_TipoTaxo + '%'
--		and		upper(sc.desc_conc) like upper(@p_CodiConc + '%')
--		and		s.domain_code in ('200','210')
--		and		dc.tipo_valo = s.code
--		and		dc.pref_conc != 'indi'
--		order by desc_conc ASC
--	END
--	ELSE if(@p_TipoRepo = 'RepoXBRL')
--	BEGIN
--		select	distinct sc.desc_conc as desc_conc,
--				dc.pref_conc as pref_conc, 
--				dc.codi_conc as codi_conc 
--		from	dbax_defi_conc dc, 
--				dbax_desc_conc sc, 
--				dbax_tipo_conc tc,
--				sys_code s 
--		where	dc.pref_conc = sc.pref_conc 
--		and		dc.codi_conc = sc.codi_conc 
--		and		dc.tipo_conc = tc.tipo_conc 
--		and		dc.tipo_taxo like '%' + @p_TipoTaxo + '%'
--		and		upper(sc.desc_conc) like upper(@p_CodiConc + '%')
--		and		s.domain_code in ('200','210')
--		and		dc.tipo_valo = s.code
--		order by desc_conc ASC
--	END	
--END
--GO

--DBAX
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

	select t.codi_pers, t.corr_inst, ia.vers_inst, max(ia.nomb_arch)
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
	group by t.desc_pers, t.codi_pers, t.corr_inst, ia.vers_inst
	order by t.desc_pers, t.codi_pers, t.corr_inst, ia.vers_inst
	--order by 1,2,3
END
GO

--DESA
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
	group by t.desc_pers, t.codi_pers, t.corr_inst, ia.vers_inst
	order by t.desc_pers, t.codi_pers, t.corr_inst, ia.vers_inst
	--order by 1,2,3
END
GO

--DESA
ALTER procedure [dbo].[SP_AX_getArchivosXbrl] 
	@p_Codi_Pers numeric(9,0),
	@p_Corr_Inst  numeric(10,0),
    @p_Vers_Inst  numeric(5,0),
	@vNombArch	  varchar(256)=''
as
BEGIN
declare @V_cant_zip varchar (10)

	select  @V_cant_zip = count(*)
	from	dbax_inst_arch 
	where	codi_pers = @p_Codi_Pers 
	and		corr_inst = @p_Corr_Inst
	and		vers_inst  = @p_Vers_Inst
	and		substring(nomb_arch,charindex('.',nomb_arch), len(nomb_arch)) = '.zip'

	if ( @V_cant_zip = '0' and	len(@vNombArch)=0)
	begin
		select nomb_arch as Archivos,
               '' as Contenido
		from dbax_inst_arch 
		where codi_pers = @p_Codi_Pers
		and corr_inst = @p_Corr_Inst
		and vers_inst  = @p_Vers_Inst
	end
	else if(len(@vNombArch)=0)
	begin
       	select  nomb_arch as Archivos,
                '' as Contenido
		from dbax_inst_arch 
		where codi_pers = @p_Codi_Pers
		and corr_inst = @p_Corr_Inst
		and vers_inst  = @p_Vers_Inst
        and( substring(nomb_arch,charindex('.',nomb_arch), len(nomb_arch)) = '.pdf.zip'
        or substring(nomb_arch,charindex('.',nomb_arch), len(nomb_arch)) = '.zip'
        or substring(nomb_arch,charindex('.',nomb_arch), len(nomb_arch)) = '.pdf'
		or substring(nomb_arch,charindex('.',nomb_arch), len(nomb_arch)) = '.html'
		)
	end
	else
	begin
		select nomb_arch as Archivos,
               cont_arch as Contenido
		from dbax_inst_arch 
		where codi_pers = @p_Codi_Pers
		and corr_inst = @p_Corr_Inst
		and vers_inst  = @p_Vers_Inst
		and	nomb_arch = @vNombArch
	end
END
GO

ALTER PROCEDURE [dbo].[prc_read_codi_conc]
(
	@tsTipo as Varchar(2),	
	@tnPagina as integer,	
	@tnRegPag as integer, 
	@tsCondicion as Varchar(128),
	@tsPar1 as Varchar(30), @tsPar2 as Varchar(30), 
	@tsPar3 as Varchar(30), @tsPar4 as Varchar(30), @tsPar5 as Varchar(30),
	@p_codi_usua varchar(30), @p_codi_empr int, @p_codi_emex varchar(30)
)
AS
/*
     Procedimiento para rescatar datos de la tabla CENT_COST
     CON EL 
     Parametros
        @tsTipo 
            S: Query utilizada para el mantenedor 
            L: Query utilizada para el listador 
            LV: Query utilizada para las listas de valor 
        @tnPagina	: Numero de pagina a rescatar 
        @tnRegPag	: Numero de registros por pagina
        @tsCondicion : Condicion, clausula Where
        @tsPar1		: Parametro 1 - Version Taxonomía
        @tsPar2		: Parametro 2 - Prefijo de Concepto
        @tsPar3		: Parametro 3 - 
        @tsPar4		: Parametro 4 - 
        @tsPar5		: Parametro 5 - 
        @p_codi_usua    : Usuario
        @p_codi_empr    : Empresa
        @p_codi_emex    : Emex
     */
     
BEGIN
	declare @vDescripcion varchar(100)
	set @vDescripcion = isnull(upper(@tsPar3),'')
	select '' as CODIGO, 'Seleccione' as VALOR, 1
	union
	select	distinct tc.codi_conc as CODIGO, dc.desc_conc VALOR,2 
	from	dbax_taxo_conc tc, dbax_desc_conc dc
	where	vers_taxo = @tsPar1
	and		dc.pref_conc = @tsPar2
	and		tc.pref_conc = dc.pref_conc
	and		tc.codi_conc = dc.codi_conc
	and     upper(dc.desc_conc) like '%' + @vDescripcion + '%' 
	order by 3,2;
END
Go

ALTER PROCEDURE [dbo].[SP_AX_delInstDocu] (@pCodiPers numeric(9,0),@pCorrInst numeric(10,0))
AS
BEGIN
	delete from dbax_inst_conc where codi_pers = @pCodiPers  and corr_inst = @pCorrInst
	delete from dbax_inst_arch where codi_pers = @pCodiPers  and corr_inst = @pCorrInst
	delete from dbax_inst_unit where codi_pers = @pCodiPers  and corr_inst = @pCorrInst
	delete from dbax_inst_dicx where codi_pers = @pCodiPers  and corr_inst = @pCorrInst
	delete from dbax_inst_cntx where codi_pers = @pCodiPers  and corr_inst = @pCorrInst
	delete from dbax_inst_info where codi_pers = @pCodiPers  and corr_inst = @pCorrInst
	delete from dbax_inst_vers where codi_pers = @pCodiPers  and corr_inst = @pCorrInst
	delete from dbax_inst_docu where codi_pers = @pCodiPers  and corr_inst = @pCorrInst
END
GO

 ALTER procedure [dbo].[SP_AX_InsBase64XBRL](
	@pCodi_pers numeric(9,0) ,
	@pCorr_inst varchar(10),
	@pVersInst numeric(5,0),
	@pCont_arch text,
	@pNomb_Arch varchar(256),
    @pTipo_mime varchar(50)) as
BEGIN 
	delete from dbax_inst_arch 
	where codi_pers = @pCodi_pers 
	and corr_inst = @pCorr_inst 
	and vers_inst =  @pVersInst 
	and nomb_arch = @pNomb_Arch
	
	insert into dbax_inst_arch (codi_pers,corr_inst,vers_inst,cont_arch,nomb_arch, tipo_mime) 
    values (@pCodi_pers,@pCorr_inst,@pVersInst,@pCont_arch,@pNomb_Arch,@pTipo_mime)
END
GO

/****** Objeto:  Table [dbo].[dbax_proc_even]    Fecha de la secuencia de comandos: 09/03/2013 11:48:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
Create TABLE [dbo].[dbax_proc_even](
	[corr_proc] [numeric](10, 0) IDENTITY(1,1) NOT NULL,
	[codi_usua] [varchar](30) NOT NULL,
	[desc_proc] [varchar](256) NOT NULL,
	[fech_even] [datetime] NOT NULL,
	[borr_mens] [varchar](1) NOT NULL,
 CONSTRAINT [PK_dbax_proc_even] PRIMARY KEY CLUSTERED 
(
	[corr_proc] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO

/****** Objeto:  StoredProcedure [dbo].[prc_create_dbax_proc_even]    Fecha de la secuencia de comandos: 09/03/2013 11:49:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter procedure [dbo].[prc_create_dbax_proc_even]
					(@p_desc_proc varchar(500),
				     @p_borr_mens varchar(1),
					 @pCodiUsua varchar(25)='')
as
BEGIN
	if(@pCodiUsua!='')
	begin
		insert into dbax_proc_even
					(codi_usua, desc_proc, fech_even, borr_mens)
		values		('dbax', @p_desc_proc, GETDATE(), @p_borr_mens)
	end
	else
	begin
		insert into dbax_proc_even
					(codi_usua, desc_proc, fech_even, borr_mens)
		values		(@pCodiUsua, @p_desc_proc, GETDATE(), @p_borr_mens)
	end
END
GO

/****** Objeto:  StoredProcedure [dbo].[prc_read_dbax_proc_even]    Fecha de la secuencia de comandos: 09/03/2013 11:50:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[prc_read_dbax_proc_even] 
					(@pCodiUsua varchar(25)='')
as
BEGIN
	select	top 1 desc_proc  
	from	dbax_proc_even  
	where	codi_usua like '%%'  
	and		corr_proc = (select max(corr_proc) from dbax_proc_even where codi_usua like '%%')  
	and		(  
		   (datediff(s, fech_even, getdate()) < 5  
		   and	borr_mens = '1')  
	   OR (borr_mens = '0'))
END
GO

ALTER  procedure [dbo].[prc_read_dbax_homo_conc] (
 @tsTipo as Varchar(2),
 @tnPagina as integer,
 @tnRegPag as integer,
 @tsCondicion as Varchar(2048),
 @tsPar1 as Varchar(30), @tsPar2 as Varchar(30),
 @tsPar3 as Varchar(30), @tsPar4 as Varchar(30), @tsPar5 as Varchar(30),
 @p_codi_usua varchar(30), @p_codi_empr int, @p_codi_emex varchar(30))
AS 
    /*
     Procedimiento para rescatar datos de la tabla DBAX_HOMO_CONC
     CON EL 
     Parametros
        @tsTipo 
            S: Query utilizada para el mantenedor 
            L: Query utilizada para el listador 
            LV: Query utilizada para las listas de valor 
        @tnPagina	: Numero de pagina a rescatar 
        @tnRegPag	: Numero de registros por pagina
        @tsCondicion : Condicion, clausula Where
        @tsPar1		: Parametro 1 - codi_hoco
        @tsPar2		: Parametro 2 - 
        @tsPar3		: Parametro 3 - 
        @tsPar4		: Parametro 4 - 
        @tsPar5		: Parametro 5 - 
        @p_codi_usua    : Usuario
        @p_codi_empr    : Empresa
        @p_codi_emex    : Emex
     */
     declare @sql_dyn as integer
     declare @sql as nvarchar(4000)
BEGIN
  IF (@tsTipo = 'S')
  BEGIN
    SELECT codi_hoco, 
           tipo_taxo, 
           pref_conc, 
           vers_taxo, 
           vers_taxo_dest, 
           fech_hoco,
		   fini_homo,
		   ffin_homo
  FROM dbax_homo_conc
  WHERE codi_hoco = @tsPar1
 END
 ELSE IF (@tsTipo = 'L')
 BEGIN
   SET @sql = 'SELECT ROW_NUMBER() OVER(ORDER BY codi_hoco ASC) AS REG, 
                codi_hoco, tipo_taxo, pref_conc, 
                vers_taxo, vers_taxo_dest, SUBSTRING(CONVERT(varchar(30),fech_hoco,105),0,11) fech_hoco,
				CONVERT(varchar(30),fini_homo,120) fini_homo,
				CONVERT(varchar(30),ffin_homo,120) ffin_homo
               FROM dbax_homo_conc
               WHERE 1 = 1 '
 
   SET @sql = @sql + isnull(@tsCondicion,'')
   EXECUTE dbo.prc_list_dyn @sql, @tnPagina, @tnRegPag 
 END
END;
GO

AGREGAR A DBAX_HOMO_CONC
	[fini_homo] [datetime] NULL,
	[ffin_homo] [datetime] NULL,
 

ALTER PROCEDURE [dbo].[prc_dbax_proc_homo]
(
	@p_tipo_taxo varchar(10),
	@p_pref_conc varchar(10),
	@p_fein_proc datetime,
	@p_erro varchar(30) output,
	@p_mens varchar(250) output
)
AS
DECLARE @p_donde VARCHAR(200)
DECLARE	@c_codi_hoco VARCHAR(22), 
		@c_tipo_taxo VARCHAR(10), 
		@c_pref_conc VARCHAR(50),
		@c_vers_taxo VARCHAR(256), 
		@c_vers_taxo_dest VARCHAR(256), 
		@c_fech_hoco datetime

BEGIN TRY
	SET @p_donde = 'Declare'
	DECLARE  hc CURSOR FOR
		SELECT codi_hoco, tipo_taxo, pref_conc, vers_taxo, vers_taxo_dest, fech_hoco  
		FROM   dbax_homo_conc
		WHERE tipo_taxo = @p_tipo_taxo
		and   pref_conc = @p_pref_conc
		and   fech_hoco = @p_fein_proc
		order by fech_hoco;

	SET @p_donde = 'Inicio'
	OPEN hc
		FETCH NEXT FROM hc
		INTO @c_codi_hoco, @c_tipo_taxo, @c_pref_conc, @c_vers_taxo, @c_vers_taxo_dest, @c_fech_hoco
		WHILE(@@FETCH_STATUS = 0)
				BEGIN
				SET @p_donde = 'Homologando Conceptos: homologación '+ @c_codi_hoco
				
				update dbax_homo_conc 
				set fini_homo = getdate(),
					ffin_homo = null
				WHERE codi_hoco = @c_codi_hoco
				
				update dbax_inst_conc
				set	  pref_conc1 = c.pref_conc,
				      codi_conc1 = c.codi_conc
				from  dbax_inst_conc c,
					  dbax_homo_deta d
				where d.codi_hoco = @c_codi_hoco
				and	  d.codi_conc = c.codi_conc
				and	  d.pref_conc = c.pref_conc
				and   c.pref_conc1 is null
				and   c.codi_conc1 is null;

				/*select c.pref_conc1, c.pref_conc, c.codi_conc1, c.codi_conc
				from  dbax_inst_conc c,
					  dbax_homo_deta d
				where d.codi_hoco = @c_codi_hoco
				and	  d.codi_conc = c.codi_conc
				and	  d.pref_conc = c.pref_conc
				and   c.pref_conc1 is null
				and   c.codi_conc1 is null;*/
				
				
				update dbax_inst_conc
				set   pref_conc = d.pref_conc1,
				      codi_conc = d.codi_conc1
				from  dbax_inst_conc c,
					  dbax_homo_deta d
				where d.codi_hoco = @c_codi_hoco
				and	  d.pref_conc = c.pref_conc1
				and	  d.codi_conc = c.codi_conc1
				
				
				/*select c.pref_conc, d.pref_conc1, c.codi_conc, d.codi_conc1
				from  dbax_inst_conc c,
					  dbax_homo_deta d
				where d.codi_hoco = @c_codi_hoco
				and	  d.pref_conc = c.pref_conc1
				and	  d.codi_conc = c.codi_conc1*/

				update dbax_homo_conc 
				set ffin_homo = getdate() 
				WHERE codi_hoco = @c_codi_hoco

				FETCH NEXT FROM hc
				INTO @c_codi_hoco, @c_tipo_taxo, @c_pref_conc, @c_vers_taxo, @c_vers_taxo_dest, @c_fech_hoco
			END
	CLOSE hc;
	DEALLOCATE hc;
END TRY
BEGIN CATCH
	CLOSE hc;
	DEALLOCATE hc;
	
	set @p_erro = 'S'
	set @p_mens = 'Error: dbax_proc_homo'+' '+@p_donde+' - '+SUBSTRING(ERROR_MESSAGE(),0,200)
END CATCH
GO

CREATE PROCEDURE [dbo].[SP_AX_cambiaPassDemo]
(
	@pPassEnc varchar(100) = 'nopfCGGNK1'
)
AS
	--'nopfCGGNK1' = dbax1860
BEGIN TRY
	update usua_sist set pass_usua = @pPassEnc where codi_usua like 'demo[1,2,3,4,5]'
END TRY
BEGIN CATCH
	select 'Error'
END CATCH
GO

ALTER procedure [dbo].[SP_AX_getMiembrosDimensionEmpresaPeriodoVersion]
	@pCodiPers	 varchar(16),
	@pCorrInst	 numeric(10,0),
	@pVersInst	 numeric(5,0),
	@p_codi_info varchar(256),
	@p_pref_axis varchar(50),
	@p_codi_axis varchar(256)
as
BEGIN
	select distinct dm.pref_memb + ':' + dm.codi_memb COLLATE Modern_Spanish_CS_AS, dc.desc_conc COLLATE Modern_Spanish_CS_AS, dm.tipo_memb, dm.orde_memb
	from	dbax_dime_memb dm,
			dbax_desc_conc dc
	where	dm.pref_axis = @p_pref_axis
	and		dm.codi_axis = @p_codi_axis
	and		dm.pref_memb = dc.pref_conc
	and		dm.codi_memb = dc.codi_conc
	and		dc.codi_lang = 'es_ES'
	union
	select	im.codi_memb COLLATE Modern_Spanish_CS_AS, im.desc_memb COLLATE Modern_Spanish_CS_AS, 'domain-member', id.orde_memb
	from	dbax_inst_memb im,
			dbax_inst_dime id
	where	1=1
	and		im.codi_pers = @pCodiPers
	and		im.corr_inst = @pCorrInst
	and		im.vers_inst = @pVersInst
	and		id.codi_pers = im.codi_pers
	and		id.corr_inst = im.corr_inst
	and		id.vers_inst = im.vers_inst
	and		id.codi_dein like '%' + @p_codi_info + '%'
	and		id.pref_axis = @p_pref_axis
	and		id.codi_axis = @p_codi_axis
	and		id.codi_memb = im.codi_memb
	group by im.codi_memb, im.desc_memb, id.orde_memb
	order by 4,1
END
GO

CREATE procedure [dbo].[SP_AX_getMiembrosDimensionEmpresaPeriodoVersion]
	@pCodiPers	 varchar(16),
	@pCorrInst	 numeric(10,0),
	@pVersInst	 numeric(5,0),
	@p_codi_info varchar(256),
	@p_pref_axis varchar(50),
	@p_codi_axis varchar(256)
as
BEGIN
	select distinct dm.pref_memb + ':' + dm.codi_memb COLLATE Modern_Spanish_CS_AS codi_memb, dc.desc_conc COLLATE Modern_Spanish_CS_AS, dm.tipo_memb, dm.orde_memb
	from	dbax_dime_memb dm,
			dbax_desc_conc dc
	where	dm.pref_axis = @p_pref_axis
	and		dm.codi_axis = @p_codi_axis
	and		dm.pref_memb = dc.pref_conc
	and		dm.codi_memb = dc.codi_conc
	and		dc.codi_lang = 'es_ES'
	union
	select	im.codi_memb, im.desc_memb, 'domain-member', id.orde_memb
	from	dbax_inst_memb im,
			dbax_inst_dime id
	where	1=1
	and		im.codi_pers = @pCodiPers
	and		im.corr_inst = @pCorrInst
	and		im.vers_inst = @pVersInst
	and		id.codi_pers = im.codi_pers
	and		id.corr_inst = im.corr_inst
	and		id.vers_inst = im.vers_inst
	and		id.codi_dein like '%' + @p_codi_info + '%'
	and		id.pref_axis = @p_pref_axis
	and		id.codi_axis = @p_codi_axis
	and		id.codi_memb = im.codi_memb
	group by im.codi_memb, im.desc_memb, id.orde_memb
	order by 4,1
END
GO

--execute [SP_AX_getMiembrosDimensionEmpresaPeriodoVersion] 966123101,201303,1,'pre_cl-cs_cuadro-601_role-906011(2013)','cl-cs','RamosEje'
--execute [SP_AX_getMiembrosDimensionEmpresaPeriodoVersion] 992880001,201303,1,'pre_cl-cs_cuadro-601_role-906011(2013)','cl-cs','RamosEje'


ALTER procedure [dbo].[SP_AX_getValoresPorInfoDimeCntx]
	@pCodiPers	 varchar(16),
	@pCorrInst	 numeric(10,0),
	@pVersInst	 numeric(5,0),
	@pCodiCntx	 varchar(1000),
	@pCodiInfo   varchar(256),
	@pPrefDime varchar(50),
	@pCodiDime varchar(256)
as
BEGIN
	select	ic.valo_cntx, dc.orde_conc
	from	dbax_dime_conc dc left join
			dbax_inst_conc ic
			on	ic.codi_pers = @pCodiPers
			and	ic.corr_inst = @pCorrInst
			and	ic.vers_inst = @pVersInst
			and	ic.codi_cntx = @pCodiCntx
			and		dc.pref_conc = ic.pref_conc
			and		dc.codi_conc = ic.codi_conc
	where	dc.codi_dein = @pCodiInfo
	and		dc.pref_dime = @pPrefDime
	and		dc.codi_dime = @pCodiDime
	group by ic.corr_conc, ic.pref_conc, ic.codi_conc, dc.orde_conc, ic.valo_cntx
	order by orde_conc
END
GO

--execute [SP_AX_getValoresPorInfoDimeCntx] 966123101, 201303, 1, 'Periodo_cl-cs_CostoSiniestroTabla_tx_C24_cl-cs_IndividualesMiembro_ACT', 'pre_cl-cs_cuadro-601_role-906011(2013)', 'cl-cs', 'CuadroMargenContribucionTabla'

AGREGAR COLUMNA dbax_dime_defi.tipo_taxo VARCHAR(10) null

update dbax_dime_defi
set tipo_taxo = 'COME_INDU'
where codi_dein like 'pre_cl-ci_%'
or	  codi_dein like 'pre_ias_%'
or	  codi_dein like 'pre_ifrs_%'

update dbax_dime_defi
set tipo_taxo = 'SEGUROS'
where codi_dein like '%cl-cs_%'

update dbax_defi_conc set tipo_taxo = 'HOLDBANC' where pref_conc = 'cl-hb'
update dbax_defi_conc set tipo_taxo = 'HOLDSEGU' where pref_conc = 'cl-hs'

CREATE TABLE [dbo].[dbax_inst_dime](
	[codi_pers] [varchar](16) NOT NULL,
	[corr_inst] [numeric](10, 0) NOT NULL,
	[vers_inst] [numeric](5, 0) NOT NULL,
	[codi_dein] [varchar](50) NOT NULL,
	[pref_dime] [varchar](20) NOT NULL,
	[codi_dime] [varchar](256) NOT NULL,
	[letr_dime] [varchar](1) NULL,
	[pref_axis] [varchar](20) NULL,
	[codi_axis] [varchar](256) NULL,
	[codi_memb] [varchar](256) NOT NULL,
	[orde_memb] [int] NULL,
	[memb_papa] [varchar](256) NULL,
 CONSTRAINT [PK_dbax_inst_dime] PRIMARY KEY CLUSTERED 
(
	[codi_pers] ASC,
	[corr_inst] ASC,
	[vers_inst] ASC,
	[codi_dein] ASC,
	[pref_dime] ASC,
	[codi_dime] ASC,
	[codi_memb] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO

CREATE TABLE [dbo].[dbax_inst_memb](
	[codi_pers] [varchar](16) NOT NULL,
	[corr_inst] [numeric](10, 0) NOT NULL,
	[vers_inst] [numeric](5, 0) NOT NULL,
	[codi_memb] [varchar](256) NOT NULL,
	[desc_memb] [varchar](256) NULL,
 CONSTRAINT [PK_dbax_inst_memb] PRIMARY KEY CLUSTERED 
(
	[codi_pers] ASC,
	[corr_inst] ASC,
	[vers_inst] ASC,
	[codi_memb] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO

insert into [DBAX].[DBO].[dbax_inst_dime]
SELECT * FROM [DBAXDESA].[DBO].[dbax_inst_dime]

insert into [DBAX].[DBO].[dbax_inst_memb]
SELECT * FROM [DBAXDESA].[DBO].[dbax_inst_memb]

ALTER procedure [dbo].[SP_AX_getInformesDimension] 
	@p_tipo_info varchar(1),
	@p_codi_pers varchar(30),
	@p_corr_inst varchar(30),
	@p_tipo_taxo varchar(10) = 'SEGUROS'
AS
BEGIN
	if(@p_tipo_info = 'R') --R= Reportado, o sea, se detectó en el XBRL
	BEGIN
		select ii.codi_info, ti.desc_info
		from	dbax_inst_info ii,
				dbax_taxo_info ti
		where	ii.codi_pers = @p_codi_pers
		and		ii.corr_inst  = @p_corr_inst
		and		ii.codi_info = ti.codi_info
	END
	else
	BEGIN	--Trae todos los informes, cargados y no
		select distinct codi_dein, ti.desc_info
		from	dbax_dime_defi dd,
				dbax_taxo_info ti
		where dd.codi_dein = ti.codi_info
		and	  dd.tipo_taxo = @p_tipo_taxo
	END
END
GO 

ALTER procedure [dbo].[SP_AX_getDimensionesUsables]
	@p_CodiInfo varchar(256)
as
BEGIN
	select distinct dd.pref_dime + ':' + dd.codi_dime codi_dime, dc1.desc_conc desc_conc
	--select distinct dd.codi_dime codi_dime, dc1.desc_conc desc_conc	
	from	dbax_dime_defi dd,
			dbax_defi_conc dc,
			dbax_desc_conc dc1
    where	dd.codi_dein = @p_CodiInfo
    and		dd.codi_dime = dc.codi_conc 
	and		dc.codi_conc = dc1.codi_conc
END
GO

--indeices pruebas
CREATE NONCLUSTERED INDEX [_dta_index_dbax_inst_cntx_6_1805249486__K2_K3_K4_K1_K5_K6] ON [dbo].[dbax_inst_cntx] 
(
	[corr_inst] ASC,
	[vers_inst] ASC,
	[codi_cntx] ASC,
	[codi_pers] ASC,
	[fini_cntx] ASC,
	[ffin_cntx] ASC
)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [_dta_index_dbax_inst_dicx_6_1773249372__K2_K4_K6_K5_K1_K3] ON [dbo].[dbax_inst_dicx] 
(
	[corr_inst] ASC,
	[codi_axis] ASC,
	[vers_inst] ASC,
	[codi_memb] ASC,
	[codi_pers] ASC,
	[codi_cntx] ASC
)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [_dta_index_dbax_dime_conc_6_749245724__K5_K1_K6_K3_K2] ON [dbo].[dbax_dime_conc] 
(
	[codi_dime] ASC,
	[codi_dein] ASC,
	[pref_dime] ASC,
	[pref_conc] ASC,
	[codi_conc] ASC
)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [_dta_index_dbax_inst_conc_6_1981250113__K7_K2_K3_K4_K1_K5_K6_8] ON [dbo].[dbax_inst_conc] 
(
	[codi_cntx] ASC,
	[codi_pers] ASC,
	[corr_inst] ASC,
	[vers_inst] ASC,
	[corr_conc] ASC,
	[pref_conc] ASC,
	[codi_conc] ASC
)
INCLUDE ( [valo_cntx]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
Go
CREATE NONCLUSTERED INDEX [_dta_index_dbax_inst_dicx_5_1773249372__K4_K3_K2_K6_K1_K5] ON [dbo].[dbax_inst_dicx] 
(
	[codi_axis] ASC,
	[codi_cntx] ASC,
	[corr_inst] ASC,
	[vers_inst] ASC,
	[codi_pers] ASC,
	[codi_memb] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [_dta_index_dbax_inst_dicx_5_1773249372__K6_K3_K2_K1] ON [dbo].[dbax_inst_dicx] 
(
	[codi_pers] ASC,
	[corr_inst] ASC,
	[vers_inst] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [_dta_index_dbax_inst_dicx_5_1773249372__K6_K3_K2_K1_9987] ON [dbo].[dbax_inst_dicx] 
(
	[vers_inst] ASC,
	[codi_cntx] ASC,
	[corr_inst] ASC,
	[codi_pers] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
alter PROCEDURE [dbo].[prc_read_dbax_ejes] 
	@P_CODI_DEIN VARCHAR(128),
	@P_CODI_DIME VARCHAR(128)
AS
BEGIN
	select  dd.codi_dime,pref_axis,codi_axis,orde_axis
	from	dbax_dime_diax dd
	where	dd.codi_dein = @P_CODI_DEIN
	and     dd.codi_dime = @P_CODI_DIME
	order by dd.orde_axis
END
GO
alter procedure [dbo].[SP_AX_getCounDimeEjes]
	@p_CodiInfo varchar(256),
	@p_CodiDime varchar(256)
as
BEGIN
	select  count(codi_axis)
	from	dbax_dime_diax
    where	codi_dein = @p_CodiInfo
    and		codi_dime = @p_CodiDime
    group by codi_dein,codi_dime

END
GO


alter procedure [dbo].[SP_AX_getValoresPorInfoDimeCntx]
	@pCodiPers	 varchar(16),
	@pCorrInst	 numeric(10,0),
	@pVersInst	 numeric(5,0),
	@pCodiCntx	 varchar(1000),
	@pCodiInfo   varchar(256),
	@pPrefDime varchar(50),
	@pCodiDime varchar(256)
as
BEGIN
	select	ic.valo_cntx, dc.orde_conc
	from	dbax_dime_conc dc left join
			dbax_inst_conc ic
			on	ic.codi_pers = @pCodiPers
			and	ic.corr_inst = @pCorrInst
			and	ic.vers_inst = @pVersInst
			and	ic.codi_cntx = @pCodiCntx
			and		dc.pref_conc = ic.pref_conc
			and		dc.codi_conc = ic.codi_conc
	where	dc.codi_dein = @pCodiInfo
	and		dc.pref_dime = @pPrefDime
	and		dc.codi_dime = @pCodiDime
	group by ic.corr_conc, ic.pref_conc, ic.codi_conc, dc.orde_conc, ic.valo_cntx
	order by orde_conc
END
GO


ALTER  procedure [dbo].[prc_read_dbax_taxo_vers] (
 @tsTipo as Varchar(2),
 @tnPagina as integer,
 @tnRegPag as integer,
 @tsCondicion as Varchar(2048),
 @tsPar1 as Varchar(30))
AS 
    /*
     Procedimiento para rescatar datos de la tabla DBAX_TAXO_VERS
     CON EL 
     Parametros
        @tsTipo 
            S: Query utilizada para el mantenedor 
            L: Query utilizada para el listador 
            LV: Query utilizada para las listas de valor 
        @tnPagina	: Numero de pagina a rescatar 
        @tnRegPag	: Numero de registros por pagina
        @tsCondicion : Condicion, clausula Where
        @tsPar1		: Parametro 1 - vers_taxo
     */
     declare @sql_dyn as integer
     declare @sql as nvarchar(4000)
BEGIN
  IF (@tsTipo = 'S')
  BEGIN
    SELECT vers_taxo, 
           ubic_taxo, 
           tipo_taxo
  FROM dbax_taxo_vers
  WHERE vers_taxo = @tsPar1
 END
 ELSE IF (@tsTipo = 'L')
 BEGIN
   SET @sql = 'SELECT ROW_NUMBER() OVER(ORDER BY vers_taxo ASC) AS REG, 
                vers_taxo, ubic_taxo, tipo_taxo
               FROM dbax_taxo_vers
               WHERE 1 = 1 '
 
   SET @sql = @sql + isnull(@tsCondicion,'')
   EXECUTE dbo.prc_list_dyn @sql, @tnPagina, @tnRegPag 
 END
 ELSE IF(@tsTipo = 'LV')
 BEGIN
	declare @Comodin varchar(1)
	select '' as CODIGO, 'Seleccione' as VALOR
	union
	SELECT vers_taxo as CODIGO, vers_taxo as VALOR
	FROM dbax_taxo_vers
	WHERE tipo_taxo like '%' + @tsPar1 + '%'
 END
END;
GO

ALTER procedure [dbo].[SP_AX_getPrefConc ]
@pVersTaxo varchar(256) = ''
as
BEGIN
	declare @vComodinTipo varchar(1)

	set @vComodinTipo = '%'

	if ( @pVersTaxo != '')
	begin
		set @vComodinTipo = ''
	end

	/*
	select distinct pref_conc,pref_conc 
	from dbax_defi_conc 
	where tipo_taxo like @vComodinTipo + @pTipoTaxo + @vComodinTipo
	*/
	select distinct tc.pref_conc, tc.pref_conc
	from	dbax_taxo_conc tc
	where	tc.vers_taxo like @vComodinTipo + @pVersTaxo + @vComodinTipo
END
GO

ALTER procedure [dbo].[SP_AX_GetConcPorTaxonomia](
	@p_VersTaxo  varchar(50),
	@p_CodiConc  varchar(100),
	@p_TipoRepo varchar(30),
	@p_TipoTaxo varchar(10)='') as
BEGIN
	if(@p_TipoRepo = 'Indicadores')
	BEGIN
		select	distinct
				--sc.desc_conc as desc_conc,
				sc.desc_conc + ' (' + cast(dc.pref_conc as varchar(12)) collate Modern_Spanish_CS_AS + ')' as desc_conc,
				dc.pref_conc as pref_conc, 
				dc.codi_conc as codi_conc 
		from	dbax_defi_conc dc, 
				dbax_desc_conc sc, 
				dbax_tipo_conc tc,
				sys_code s,
				dbax_taxo_conc vt 
		where	dc.pref_conc = sc.pref_conc 
		and		dc.codi_conc = sc.codi_conc 
		and		dc.tipo_conc = tc.tipo_conc 
		and		upper(sc.desc_conc  + ' (' + cast(dc.pref_conc as varchar(12)) collate Modern_Spanish_CS_AS + ')') like upper('%' + @p_CodiConc + '%')
		and		s.domain_code in ('200','210')
		and		dc.tipo_valo = s.code
		and		dc.pref_conc != 'indi'
		and		dc.tipo_taxo like '%' + @p_TipoTaxo + '%'
		and		vt.vers_taxo like '%' + replace(@p_VersTaxo,'Seleccione','') + '%'
		and		vt.pref_conc = dc.pref_conc
		and		vt.codi_conc = dc.codi_conc
		order by desc_conc ASC
	END
END
GO
ALTER PROCEDURE [dbo].[SP_AX_insInstDicx] (
		@pCodiPers numeric(9,0),@pCorrInst numeric(10,0), 
		@pVersInst numeric(5,0),@pCodiCntx varchar(256),
		@pCodiAxis varchar(256),@pCodiMemb varchar(256))
AS
BEGIN
	insert into dbax_inst_dicx (
			codi_pers, corr_inst, vers_inst, codi_cntx, 
			codi_axis, codi_memb)
	values (@pCodiPers,@pCorrInst,@pVersInst,@pCodiCntx,
			@pCodiAxis,@pCodiMemb)
END

Create PROCEDURE [dbo].[SP_AX_insInstMemb] (
		@pCodiPers numeric(9,0),@pCorrInst numeric(10,0), 
		@pVersInst numeric(5,0),@pCodiMemb varchar(256),
		@pDescMemb varchar(256))
AS
BEGIN
	insert into dbax_inst_memb (
			codi_pers, corr_inst, vers_inst, codi_memb, 
			desc_memb)
	values (@pCodiPers,@pCorrInst,@pVersInst,@pCodiMemb,
			@pDescMemb)
END
Create PROCEDURE [dbo].[SP_AX_insInstDime] (
		@pCodiPers numeric(9,0),@pCorrInst numeric(10,0), 
		@pVersInst numeric(5,0),@pCodiDein varchar(256),@pPrefDime varchar(20),@pCodiDime varchar(256),
		@pLtrDime varchar(1),@pPrefAxis varchar(20),@pCodiAxis varchar(256),@pCodiMemb varchar(256),
		@pOrdeMemb int,@pMembPapa varchar(256))
AS
BEGIN
	insert into dbax_inst_dime (
			codi_pers, corr_inst, vers_inst, codi_dein,pref_dime,codi_dime,letr_dime,pref_axis,	 
			codi_axis,codi_memb,orde_memb,memb_papa)
	values (@pCodiPers,@pCorrInst,@pVersInst,@pCodiDein,
			@pPrefDime,@pCodiDime,@pLtrDime,@pPrefAxis,@pCodiAxis,@pCodiMemb,@pOrdeMemb,@pMembPapa)
END

Insert into dbax_defi_conc (pref_conc,codi_conc,tipo_conc,tipo_peri,tipo_valo,tipo_cuen,codi_nume,tipo_taxo) Values ('ifrs','NumberOfSharesIssuedAbstract','concepto','duration','xbrli:stringItemType','abstract',NULL,'COME_INDU')
Go
insert into dbax_desc_conc (pref_conc,codi_conc,codi_lang,desc_conc) values('ifrs','NumberOfSharesIssuedAbstract','es_ES','Número de acciones emitidas [resumen]')

if not Exists(select * from sys.columns where Name = 'sche_info2'  
            and Object_ID = Object_ID('dbax_taxo_info'))
begin

  ALTER TABLE dbo.dbax_taxo_info ADD sche_info2 VARCHAR(256) NULL;

end
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2012-03-21/cl-ci_ias-1_2011-03-25/cl-ci_ias-1_2011-03-25_role-110000.xsd',sche_info2=NULL where codi_info='pre_cl-ci_ias-1_2011-03-25_role-110000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2012-03-21/cl-ci_ias-1_2011-03-25/cl-ci_ias-1_2011-03-25_role-210000.xsd',sche_info2=NULL where codi_info='pre_cl-ci_ias-1_2011-03-25_role-210000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2012-03-21/cl-ci_ias-1_2011-03-25/cl-ci_ias-1_2011-03-25_role-220000.xsd',sche_info2=NULL where codi_info='pre_cl-ci_ias-1_2011-03-25_role-220000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2012-03-21/cl-ci_ias-1_2011-03-25/cl-ci_ias-1_2011-03-25_role-310000.xsd',sche_info2=NULL where codi_info='pre_cl-ci_ias-1_2011-03-25_role-310000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2012-03-21/cl-ci_ias-1_2011-03-25/cl-ci_ias-1_2011-03-25_role-320000.xsd',sche_info2=NULL where codi_info='pre_cl-ci_ias-1_2011-03-25_role-320000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2012-03-21/cl-ci_ias-1_2011-03-25/cl-ci_ias-1_2011-03-25_role-420000.xsd',sche_info2=NULL where codi_info='pre_cl-ci_ias-1_2011-03-25_role-420000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2012-03-21/cl-ci_ias-1_2011-03-25/cl-ci_ias-1_2011-03-25_role-610000.xsd',sche_info2=NULL where codi_info='pre_cl-ci_ias-1_2011-03-25_role-610000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2012-03-21/notas/cl-ci_ias-1_2011-03-25.xsd',sche_info2=NULL where codi_info='pre_cl-ci_ias-1_2011-03-25_role-800100'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2012-03-21/notas/cl-ci_ias-1_2011-03-25.xsd',sche_info2=NULL where codi_info='pre_cl-ci_ias-1_2011-03-25_role-800200'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2012-03-21/notas/cl-ci_ias-1_2011-03-25.xsd',sche_info2=NULL where codi_info='pre_cl-ci_ias-1_2011-03-25_role-810000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2012-03-21/notas/cl-ci_ias-1_2011-03-25.xsd',sche_info2=NULL where codi_info='pre_cl-ci_ias-1_2011-03-25_role-861200'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2013-01-31/cl-ci_ias-1_2012-03-29/cl-ci_ias-1_2012-03-29_role-110000.xsd',sche_info2=NULL where codi_info='pre_cl-ci_ias-1_2012-03-29_role-110000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2013-01-31/cl-ci_ias-1_2012-03-29/cl-ci_ias-1_2012-03-29_role-210000.xsd',sche_info2=NULL where codi_info='pre_cl-ci_ias-1_2012-03-29_role-210000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2013-01-31/cl-ci_ias-1_2012-03-29/cl-ci_ias-1_2012-03-29_role-220000.xsd',sche_info2=NULL where codi_info='pre_cl-ci_ias-1_2012-03-29_role-220000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2013-01-31/cl-ci_ias-1_2012-03-29/cl-ci_ias-1_2012-03-29_role-310000.xsd',sche_info2=NULL where codi_info='pre_cl-ci_ias-1_2012-03-29_role-310000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2013-01-31/cl-ci_ias-1_2012-03-29/cl-ci_ias-1_2012-03-29_role-320000.xsd',sche_info2=NULL where codi_info='pre_cl-ci_ias-1_2012-03-29_role-320000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2013-01-31/cl-ci_ias-1_2012-03-29/cl-ci_ias-1_2012-03-29_role-420000.xsd',sche_info2=NULL where codi_info='pre_cl-ci_ias-1_2012-03-29_role-420000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2013-01-31/cl-ci_ias-1_2012-03-29/cl-ci_ias-1_2012-03-29_role-610000.xsd',sche_info2=NULL where codi_info='pre_cl-ci_ias-1_2012-03-29_role-610000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2013-01-31/cl-ci_ias-1_2012-03-29/cl-ci_ias-1_2012-03-29_role-800100.xsd',sche_info2='http://www.svs.cl/cl/fr/ci/2013-01-31/notas/cl-ci_ias-1_2012-03-29.xsd' where codi_info='pre_cl-ci_ias-1_2012-03-29_role-800100'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2013-01-31/cl-ci_ias-1_2012-03-29/cl-ci_ias-1_2012-03-29_role-800200.xsd',sche_info2='http://www.svs.cl/cl/fr/ci/2013-01-31/notas/cl-ci_ias-1_2012-03-29.xsd' where codi_info='pre_cl-ci_ias-1_2012-03-29_role-800200'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2013-01-31/cl-ci_ias-1_2012-03-29/cl-ci_ias-1_2012-03-29_role-810000.xsd',sche_info2='http://www.svs.cl/cl/fr/ci/2013-01-31/notas/cl-ci_ias-1_2012-03-29.xsd' where codi_info='pre_cl-ci_ias-1_2012-03-29_role-810000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2013-01-31/cl-ci_ias-1_2012-03-29/cl-ci_ias-1_2012-03-29_role-861200.xsd',sche_info2='http://www.svs.cl/cl/fr/ci/2013-01-31/notas/cl-ci_ias-1_2012-03-29.xsd' where codi_info='pre_cl-ci_ias-1_2012-03-29_role-861200'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2013-01-31/cl-ci_ias-1_2012-03-29/cl-ci_ias-1_2012-03-29_role-880000.xsd',sche_info2='http://www.svs.cl/cl/fr/ci/2013-01-31/notas/cl-ci_ias-1_2012-03-29.xsd' where codi_info='pre_cl-ci_ias-1_2012-03-29_role-880000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2012-03-21/notas/cl-ci_ias-24_2011-03-25.xsd',sche_info2=NULL where codi_info='pre_cl-ci_ias-24_2011-03-25_role-818000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2013-01-31/cl-ci_ias-24_2012-03-29/cl-ci_ias-24_2012-03-29_role-818000.xsd',sche_info2='http://www.svs.cl/cl/fr/ci/2013-01-31/notas/cl-ci_ias-24_2012-03-29.xsd' where codi_info='pre_cl-ci_ias-24_2012-03-29_role-818000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2012-03-21/notas/cl-ci_ias-28_2011-03-25.xsd',sche_info2=NULL where codi_info='pre_cl-ci_ias-28_2011-03-25_role-825600'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2012-03-21/notas/cl-ci_ias-31_2011-03-25.xsd',sche_info2=NULL where codi_info='pre_cl-ci_ias-31_2011-03-25_role-825500'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2012-03-21/cl-ci_ias-7_2011-03-25/cl-ci_ias-7_2011-03-25_role-510000.xsd',sche_info2=NULL where codi_info='pre_cl-ci_ias-7_2011-03-25_role-510000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2012-03-21/cl-ci_ias-7_2011-03-25/cl-ci_ias-7_2011-03-25_role-520000.xsd',sche_info2=NULL where codi_info='pre_cl-ci_ias-7_2011-03-25_role-520000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2013-01-31/cl-ci_ias-7_2012-03-29/cl-ci_ias-7_2012-03-29_role-510000.xsd',sche_info2=NULL where codi_info='pre_cl-ci_ias-7_2012-03-29_role-510000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2013-01-31/cl-ci_ias-7_2012-03-29/cl-ci_ias-7_2012-03-29_role-520000.xsd',sche_info2=NULL where codi_info='pre_cl-ci_ias-7_2012-03-29_role-520000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2013-01-31/cl-ci_ifrs-12_2012-03-29/cl-ci_ifrs-12_2012-03-29_role-825700.xsd',sche_info2=NULL where codi_info='pre_cl-ci_ifrs-12_2012-03-29_role-825700'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2012-03-21/notas/cl-ci_ifrs-2_2011-03-25.xsd',sche_info2=NULL where codi_info='pre_cl-ci_ifrs-2_2011-03-25_role-834120'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2013-01-31/notas/cl-ci_ifrs-2_2012-03-29.xsd',sche_info2=NULL where codi_info='pre_cl-ci_ifrs-2_2012-03-29_role-834120'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2012-03-21/notas/cl-ci_ifrs-7_2011-03-25.xsd',sche_info2=NULL where codi_info='pre_cl-ci_ifrs-7_2011-03-25_role-822400'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2013-01-31/cl-ci_ifrs-7_2012-03-29/cl-ci_ifrs-7_2012-03-29_role-822400.xsd',sche_info2='http://www.svs.cl/cl/fr/ci/2013-01-31/notas/cl-ci_ias-1_2012-03-29.xsd' where codi_info='pre_cl-ci_ifrs-7_2012-03-29_role-822400'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2013-01-31/cl-ci_ifrs-8_2012-03-29/cl-ci_ifrs-8_2012-03-29_role-871100.xsd',sche_info2='http://www.svs.cl/cl/fr/ci/2013-01-31/notas/cl-ci_ifrs-8_2012-03-29.xsd' where codi_info='pre_cl-ci_ifrs-8_2012-03-29_role-871100'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_cuadro-601/cl-cs_cuadro-601_role-906011.xsd',sche_info2=NULL where codi_info='pre_cl-cs_cuadro-601_role-906011(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_cuadro-601/cl-cs_cuadro-601_role-906012.xsd',sche_info2=NULL where codi_info='pre_cl-cs_cuadro-601_role-906012(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_cuadro-602/cl-cs_cuadro-602_role-906022.xsd',sche_info2=NULL where codi_info='pre_cl-cs_cuadro-602_role-906022(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_cuadro-602/cl-cs_cuadro-602_role-906031.xsd',sche_info2=NULL where codi_info='pre_cl-cs_cuadro-602_role-906031(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_cuadro-603/cl-cs_cuadro-603_role-906032.xsd',sche_info2=NULL where codi_info='pre_cl-cs_cuadro-603_role-906032(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_cuadro-603/cl-cs_cuadro-603_role-906051.xsd',sche_info2=NULL where codi_info='pre_cl-cs_cuadro-603_role-906051(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_cuadro-604/cl-cs_cuadro-604_role-906042.xsd',sche_info2=NULL where codi_info='pre_cl-cs_cuadro-604_role-906042(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_cuadro-604/cl-cs_cuadro-604_role-906081.xsd',sche_info2=NULL where codi_info='pre_cl-cs_cuadro-604_role-906081(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_cuadro-605/cl-cs_cuadro-605_role-906052.xsd',sche_info2=NULL where codi_info='pre_cl-cs_cuadro-605_role-906052(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_cuadro-607/cl-cs_cuadro-607_role-906072.xsd',sche_info2=NULL where codi_info='pre_cl-cs_cuadro-607_role-906072(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_cuadro-608/cl-cs_cuadro-608_role-906082.xsd',sche_info2=NULL where codi_info='pre_cl-cs_cuadro-608_role-906082(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2012-01-02/cl-cs_eeff/cl-cs_eeff_role-110000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_eeff_role-110000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_eeff/cl-cs_eeff_role-110000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_eeff_role-110000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2012-01-02/cl-cs_eeff/cl-cs_eeff_role-200000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_eeff_role-200000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_eeff/cl-cs_eeff_role-200000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_eeff_role-200000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2012-01-02/cl-cs_eeff/cl-cs_eeff_role-300000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_eeff_role-300000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_eeff/cl-cs_eeff_role-300000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_eeff_role-300000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2012-01-02/cl-cs_eeff/cl-cs_eeff_role-500000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_eeff_role-500000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_eeff/cl-cs_eeff_role-500000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_eeff_role-500000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2012-01-02/cl-cs_eeff/cl-cs_eeff_role-600000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_eeff_role-600000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_eeff/cl-cs_eeff_role-600000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_eeff_role-600000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-1/cl-cs_nota-1_role-810000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-1_role-810000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-10/cl-cs_nota-10_role-822000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-10_role-822000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-11/cl-cs_nota-11_role-823000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-11_role-823000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-12/cl-cs_nota-12_role-824000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-12_role-824000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-13/cl-cs_nota-13_role-825000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-13_role-825000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-14/cl-cs_nota-14_role-826000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-14_role-826000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-15/cl-cs_nota-15_role-827000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-15_role-827000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-16/cl-cs_nota-16_role-828000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-16_role-828000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-17/cl-cs_nota-17_role-829000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-17_role-829000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-18/cl-cs_nota-18_role-830000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-18_role-830000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-19/cl-cs_nota-19_role-832100.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-19_role-832100(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-19/cl-cs_nota-19_role-832200.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-19_role-832200(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-2/cl-cs_nota-2_role-811000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-2_role-811000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-20/cl-cs_nota-20_role-833000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-20_role-833000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-21/cl-cs_nota-21_role-834000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-21_role-834000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-22/cl-cs_nota-22_role-835000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-22_role-835000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-23/cl-cs_nota-23_role-836000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-23_role-836000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-24/cl-cs_nota-24_role-837000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-24_role-837000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-25/cl-cs_nota-25_role-838100.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-25_role-838100(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-25/cl-cs_nota-25_role-838200.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-25_role-838200(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-26/cl-cs_nota-26_role-840000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-26_role-840000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-27/cl-cs_nota-27_role-842000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-27_role-842000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-28/cl-cs_nota-28_role-843000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-28_role-843000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-29/cl-cs_nota-29_role-844000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-29_role-844000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-3/cl-cs_nota-3_role-811100.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-3_role-811100(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-30/cl-cs_nota-30_role-846000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-30_role-846000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-31/cl-cs_nota-31_role-847000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-31_role-847000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-32/cl-cs_nota-32_role-848000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-32_role-848000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-33/cl-cs_nota-33_role-849000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-33_role-849000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-34/cl-cs_nota-34_role-850000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-34_role-850000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-35/cl-cs_nota-35_role-851000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-35_role-851000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-36/cl-cs_nota-36_role-852000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-36_role-852000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-37/cl-cs_nota-37_role-853000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-37_role-853000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-38/cl-cs_nota-38_role-854000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-38_role-854000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-39/cl-cs_nota-39_role-855000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-39_role-855000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-4/cl-cs_nota-4_role-811200.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-4_role-811200(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-40/cl-cs_nota-40_role-856000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-40_role-856000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-41/cl-cs_nota-41_role-857000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-41_role-857000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-42/cl-cs_nota-42_role-858000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-42_role-858000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-43/cl-cs_nota-43_role-859000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-43_role-859000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-44/cl-cs_nota-44_role-860000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-44_role-860000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-45/cl-cs_nota-45_role-861000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-45_role-861000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-46/cl-cs_nota-46_role-862100.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-46_role-862100(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-46/cl-cs_nota-46_role-862200.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-46_role-862200(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-47/cl-cs_nota-47_role-863100.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-47_role-863100(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-47/cl-cs_nota-47_role-863200.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-47_role-863200(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-48/cl-cs_nota-48_role-864000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-48_role-864000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-48/cl-cs_nota-48_role-864300.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-48_role-864300(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-5/cl-cs_nota-5_role-812000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-5_role-812000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-6/cl-cs_nota-6_role-814000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-6_role-814000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-7/cl-cs_nota-7_role-815000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-7_role-815000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-8/cl-cs_nota-8_role-816000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-8_role-816000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/cs/2013-01-31/cl-cs_nota-9/cl-cs_nota-9_role-821000.xsd',sche_info2=NULL where codi_info='pre_cl-cs_nota-9_role-821000(2013)'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/hb/2013-01-31/cl-hb_ias-1_2012-03-29_role-210000.xsd',sche_info2=NULL where codi_info='pre_cl-hb_ias-1_2012-03-29_role-210000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/hb/2013-01-31/cl-hb_ias-1_2012-03-29_role-310000.xsd',sche_info2=NULL where codi_info='pre_cl-hb_ias-1_2012-03-29_role-310000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/hb/2013-01-31/cl-hb_ias-7_2012-03-29_role-510000.xsd',sche_info2=NULL where codi_info='pre_cl-hb_ias-7_2012-03-29_role-510000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/hs/2013-01-31/cl-hs_ias-1_2012-03-29_role-210000.xsd',sche_info2=NULL where codi_info='pre_cl-hs_ias-1_2012-03-29_role-210000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/hs/2013-01-31/cl-hs_ias-1_2012-03-29_role-310000.xsd',sche_info2=NULL where codi_info='pre_cl-hs_ias-1_2012-03-29_role-310000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/hs/2013-01-31/cl-hs_ias-7_2012-03-29_role-510000.xsd',sche_info2=NULL where codi_info='pre_cl-hs_ias-7_2012-03-29_role-510000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2013-01-31/notas/cl-ci_ias-1_2012-03-29.xsd',sche_info2=NULL where codi_info='pre_ias_1_2012-03-29_role-800600'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2013-01-31/notas/cl-ci_ias-12_2012-03-29.xsd',sche_info2=NULL where codi_info='pre_ias_12_2012-03-29_role-835110'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2013-01-31/notas/cl-ci_ias-41_2012-03-29.xsd',sche_info2=NULL where codi_info='pre_ias_41_2012-03-29_role-824180'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2013-01-31/notas/cl-ci_ifrs-13_2012-03-29.xsd',sche_info2=NULL where codi_info='pre_ifrs_13_2012-03-29_role-823000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2012-03-21/notas/cl-ci_ifrs-3_2011-03-25.xsd',sche_info2=NULL where codi_info='pre_ifrs_3_2011-03-25_role-817000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2013-01-31/notas/cl-ci_ifrs-3_2012-03-29.xsd',sche_info2=NULL where codi_info='pre_ifrs_3_2012-03-29_role-817000'
update dbax_taxo_info set sche_info='http://www.svs.cl/cl/fr/ci/2012-03-21/notas/cl-ci_ifrs-8_2011-03-25.xsd',sche_info2=NULL where codi_info='pre_ifrs_8_2011-03-25_role-871100'
Go
if not Exists(select * from sys.columns where Name = 'role_uri'  
            and Object_ID = Object_ID('dbax_dime_defi'))
begin

  ALTER TABLE dbo.dbax_dime_defi ADD role_uri VARCHAR(256) NULL;

end
update dbax_dime_defi set role_uri=NULL where codi_dein='pre_cl-ci_ias-1_2011-03-25_role-610000' and codi_dime='StatementOfChangesInEquityTable' and pref_dime='ifrs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ias-1_2011-03-25_role-810000b' where codi_dein='pre_cl-ci_ias-1_2011-03-25_role-810000' and codi_dime='DisclosureOfAssetsAndLiabilitiesWithSignificantRiskOfMaterialAdjustmentTable' and pref_dime='ifrs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ias-1_2011-03-25_role-810000c' where codi_dein='pre_cl-ci_ias-1_2011-03-25_role-810000' and codi_dime='DisclosureOfObjectivesPoliciesAndProcessesForManagingCapitalTable' and pref_dime='ifrs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ias-1_2011-03-25_role-810000a' where codi_dein='pre_cl-ci_ias-1_2011-03-25_role-810000' and codi_dime='DisclosureOfReclassificationsOrChangesInPresentationTable' and pref_dime='ifrs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ias-1_2011-03-25_role-810000' where codi_dein='pre_cl-ci_ias-1_2011-03-25_role-810000' and codi_dime='InformacionSobreSubsidiariasConsolidadasTabla' and pref_dime='cl-ci' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ias-1_2011-03-25_role-861200' where codi_dein='pre_cl-ci_ias-1_2011-03-25_role-861200' and codi_dime='DisclosureOfClassesOfShareCapitalTable' and pref_dime='ifrs' and letr_dime=''
update dbax_dime_defi set role_uri=NULL where codi_dein='pre_cl-ci_ias-1_2011-03-25_role-861200' and codi_dime='DisclosureOfReservesWithinEquityTable' and pref_dime='ifrs' and letr_dime='a'
update dbax_dime_defi set role_uri=NULL where codi_dein='pre_cl-ci_ias-1_2012-03-29_role-610000' and codi_dime='StatementOfChangesInEquityTable' and pref_dime='ifrs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ias-1_2012-03-29_role-810000b' where codi_dein='pre_cl-ci_ias-1_2012-03-29_role-810000' and codi_dime='DisclosureOfAssetsAndLiabilitiesWithSignificantRiskOfMaterialAdjustmentTable' and pref_dime='ifrs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ias-1_2012-03-29_role-810000c' where codi_dein='pre_cl-ci_ias-1_2012-03-29_role-810000' and codi_dime='DisclosureOfObjectivesPoliciesAndProcessesForManagingCapitalTable' and pref_dime='ifrs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ias-1_2012-03-29_role-810000a' where codi_dein='pre_cl-ci_ias-1_2012-03-29_role-810000' and codi_dime='DisclosureOfReclassificationsOrChangesInPresentationTable' and pref_dime='ifrs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ias-1_2012-03-29_role-810000' where codi_dein='pre_cl-ci_ias-1_2012-03-29_role-810000' and codi_dime='InformacionSobreSubsidiariasConsolidadasTabla' and pref_dime='cl-ci' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ias-1_2012-03-29_role-861200' where codi_dein='pre_cl-ci_ias-1_2012-03-29_role-861200' and codi_dime='DisclosureOfClassesOfShareCapitalTable' and pref_dime='ifrs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ias-1_2012-03-29_role-861200a' where codi_dein='pre_cl-ci_ias-1_2012-03-29_role-861200' and codi_dime='DisclosureOfReservesWithinEquityTable' and pref_dime='ifrs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ias-24_2011-03-25_role-818000' where codi_dein='pre_cl-ci_ias-24_2011-03-25_role-818000' and codi_dime='DisclosureOfTransactionsBetweenRelatedPartiesTable' and pref_dime='ifrs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ias-24_2012-03-29_role-818000' where codi_dein='pre_cl-ci_ias-24_2012-03-29_role-818000' and codi_dime='DisclosureOfTransactionsBetweenRelatedPartiesTable' and pref_dime='ifrs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ias-28_2011-03-25_role-825600' where codi_dein='pre_cl-ci_ias-28_2011-03-25_role-825600' and codi_dime='DescriptionOfInformationOfAssociatesTable' and pref_dime='ifrs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ias-31_2011-03-25_role-825500' where codi_dein='pre_cl-ci_ias-31_2011-03-25_role-825500' and codi_dime='DisclosureOfInterestsInSignificantJointVenturesTable' and pref_dime='ifrs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-12_2012-03-29_role-825700a' where codi_dein='pre_cl-ci_ifrs-12_2012-03-29_role-825700' and codi_dime='DisclosureOfInformationAboutConsolidatedStructuredEntitiesTable' and pref_dime='ifrs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-12_2012-03-29_role-825700c' where codi_dein='pre_cl-ci_ifrs-12_2012-03-29_role-825700' and codi_dime='DisclosureOfJointOperationsTable' and pref_dime='ifrs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-12_2012-03-29_role-825700d' where codi_dein='pre_cl-ci_ifrs-12_2012-03-29_role-825700' and codi_dime='DisclosureOfJointVenturesTable' and pref_dime='ifrs' and letr_dime='d'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-12_2012-03-29_role-825700b' where codi_dein='pre_cl-ci_ifrs-12_2012-03-29_role-825700' and codi_dime='DisclosureOfSignificantInvestmentsInAssociatesTable' and pref_dime='ifrs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-12_2012-03-29_role-825700' where codi_dein='pre_cl-ci_ifrs-12_2012-03-29_role-825700' and codi_dime='DisclosureOfSignificantInvestmentsInSubsidiariesTable' and pref_dime='ifrs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-12_2012-03-29_role-825700e' where codi_dein='pre_cl-ci_ifrs-12_2012-03-29_role-825700' and codi_dime='DisclosureOfUnconsolidatedStructuredEntitiesTable' and pref_dime='ifrs' and letr_dime='e'
update dbax_dime_defi set role_uri=NULL where codi_dein='pre_cl-ci_ifrs-2_2011-03-25_role-834120' and codi_dime='DisclosureOfNumberAndWeightedAverageExercisePricesOfShareOptionsTable' and pref_dime='ifrs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-2_2011-03-25_role-834120b' where codi_dein='pre_cl-ci_ifrs-2_2011-03-25_role-834120' and codi_dime='DisclosureOfNumberAndWeightedAverageRemainingContractualLifeOfOutstandingShareOptionsTable' and pref_dime='ifrs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-2_2011-03-25_role-834120' where codi_dein='pre_cl-ci_ifrs-2_2011-03-25_role-834120' and codi_dime='DisclosureOfTermsAndConditionsOfSharebasedPaymentArrangementTable' and pref_dime='ifrs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-2_2012-03-29_role-834120b' where codi_dein='pre_cl-ci_ifrs-2_2012-03-29_role-834120' and codi_dime='DisclosureOfNumberAndWeightedAverageRemainingContractualLifeOfOutstandingShareOptionsTable' and pref_dime='ifrs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-2_2012-03-29_role-834120c' where codi_dein='pre_cl-ci_ifrs-2_2012-03-29_role-834120' and codi_dime='DisclosureOfRangeOfExercisePricesOfOutstandingShareOptionsTable' and pref_dime='ifrs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-2_2012-03-29_role-834120a' where codi_dein='pre_cl-ci_ifrs-2_2012-03-29_role-834120' and codi_dime='DisclosureOfTermsAndConditionsOfSharebasedPaymentArrangementTable' and pref_dime='ifrs' and letr_dime='a'
update dbax_dime_defi set role_uri=NULL where codi_dein='pre_cl-ci_ifrs-7_2011-03-25_role-822400' and codi_dime='CarteraProtestadaYEnCobranzaJudicialTabla' and pref_dime='cl-ci' and letr_dime='e'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-7_2011-03-25_role-822400f' where codi_dein='pre_cl-ci_ifrs-7_2011-03-25_role-822400' and codi_dime='DetalleOperacionesTabla' and pref_dime='cl-ci' and letr_dime='f'
update dbax_dime_defi set role_uri=NULL where codi_dein='pre_cl-ci_ifrs-7_2011-03-25_role-822400' and codi_dime='DeudoresComercialesYOtrasCuentasPorCobrarTabla' and pref_dime='cl-ci' and letr_dime='c'
update dbax_dime_defi set role_uri=NULL where codi_dein='pre_cl-ci_ifrs-7_2011-03-25_role-822400' and codi_dime='EstratificacionCarteraTabla' and pref_dime='cl-ci' and letr_dime='d'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-7_2011-03-25_role-822400b' where codi_dein='pre_cl-ci_ifrs-7_2011-03-25_role-822400' and codi_dime='ObligacionesConPublicoTabla' and pref_dime='cl-ci' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-7_2011-03-25_role-822400a' where codi_dein='pre_cl-ci_ifrs-7_2011-03-25_role-822400' and codi_dime='ObligacionesLeasingTabla' and pref_dime='cl-ci' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-7_2011-03-25_role-822400' where codi_dein='pre_cl-ci_ifrs-7_2011-03-25_role-822400' and codi_dime='PrestamosBancariosTabla' and pref_dime='cl-ci' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-7_2012-03-29_role-822400e' where codi_dein='pre_cl-ci_ifrs-7_2012-03-29_role-822400' and codi_dime='CarteraProtestadaYEnCobranzaJudicialTabla' and pref_dime='cl-ci' and letr_dime='e'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-7_2012-03-29_role-822400f' where codi_dein='pre_cl-ci_ifrs-7_2012-03-29_role-822400' and codi_dime='DetalleOperacionesTabla' and pref_dime='cl-ci' and letr_dime='f'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-7_2012-03-29_role-822400c' where codi_dein='pre_cl-ci_ifrs-7_2012-03-29_role-822400' and codi_dime='DeudoresComercialesYOtrasCuentasPorCobrarTabla' and pref_dime='cl-ci' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-7_2012-03-29_role-822400d' where codi_dein='pre_cl-ci_ifrs-7_2012-03-29_role-822400' and codi_dime='EstratificacionCarteraTabla' and pref_dime='cl-ci' and letr_dime='d'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-7_2012-03-29_role-822400b' where codi_dein='pre_cl-ci_ifrs-7_2012-03-29_role-822400' and codi_dime='ObligacionesConPublicoTabla' and pref_dime='cl-ci' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-7_2012-03-29_role-822400a' where codi_dein='pre_cl-ci_ifrs-7_2012-03-29_role-822400' and codi_dime='ObligacionesLeasingTabla' and pref_dime='cl-ci' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-7_2012-03-29_role-822400' where codi_dein='pre_cl-ci_ifrs-7_2012-03-29_role-822400' and codi_dime='PrestamosBancariosTabla' and pref_dime='cl-ci' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-8_2012-03-29_role-871100c' where codi_dein='pre_cl-ci_ifrs-8_2012-03-29_role-871100' and codi_dime='DisclosureOfGeographicalAreasTable' and pref_dime='ifrs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-8_2012-03-29_role-871100d' where codi_dein='pre_cl-ci_ifrs-8_2012-03-29_role-871100' and codi_dime='DisclosureOfMajorCustomersTable' and pref_dime='ifrs' and letr_dime='d'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-8_2012-03-29_role-871100a' where codi_dein='pre_cl-ci_ifrs-8_2012-03-29_role-871100' and codi_dime='DisclosureOfOperatingSegmentsTable' and pref_dime='ifrs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-8_2012-03-29_role-871100b' where codi_dein='pre_cl-ci_ifrs-8_2012-03-29_role-871100' and codi_dime='DisclosureOfProductsAndServicesTable' and pref_dime='ifrs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/cuadro-601_role-906011b' where codi_dein='pre_cl-cs_cuadro-601_role-906011(2013)' and codi_dime='CuadroCostosAdministracionTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/cuadro-601_role-906011a' where codi_dein='pre_cl-cs_cuadro-601_role-906011(2013)' and codi_dime='CuadroMargenContribucionTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/cuadro-601_role-906012b' where codi_dein='pre_cl-cs_cuadro-601_role-906012(2013)' and codi_dime='CuadroCostosAdministracionTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/cuadro-601_role-906012a' where codi_dein='pre_cl-cs_cuadro-601_role-906012(2013)' and codi_dime='CuadroMargenContribucionTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/cuadro-602_role-906022a' where codi_dein='pre_cl-cs_cuadro-602_role-906022(2013)' and codi_dime='PrimaRetenidaNetaTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/cuadro-602_role-906022b' where codi_dein='pre_cl-cs_cuadro-602_role-906022(2013)' and codi_dime='ReservaDeRiesgoEnCursoTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/cuadro-602_role-906022c' where codi_dein='pre_cl-cs_cuadro-602_role-906022(2013)' and codi_dime='ReservaMatematicaTabla' and pref_dime='cl-cs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/cuadro-602_role-906031' where codi_dein='pre_cl-cs_cuadro-602_role-906031(2013)' and codi_dime='CostoSiniestroTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/cuadro-603_role-906032' where codi_dein='pre_cl-cs_cuadro-603_role-906032(2013)' and codi_dime='CostoSiniestroTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/cuadro-603_role-906051' where codi_dein='pre_cl-cs_cuadro-603_role-906051(2013)' and codi_dime='CuadroReservasTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/cuadro-604_role-906042' where codi_dein='pre_cl-cs_cuadro-604_role-906042(2013)' and codi_dime='CostoRentasTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/cuadro-604_role-906081a' where codi_dein='pre_cl-cs_cuadro-604_role-906081(2013)' and codi_dime='CuadroDatosEstadisticosTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/cuadro-604_role-906081b' where codi_dein='pre_cl-cs_cuadro-604_role-906081(2013)' and codi_dime='CuadroDatosVariosTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/cuadro-605_role-906052b' where codi_dein='pre_cl-cs_cuadro-605_role-906052(2013)' and codi_dime='CuadroOtrasReservasTecnicasTablas' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/cuadro-605_role-906052a' where codi_dein='pre_cl-cs_cuadro-605_role-906052(2013)' and codi_dime='CuadroReservasDePrimasTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/cuadro-607_role-906072' where codi_dein='pre_cl-cs_cuadro-607_role-906072(2013)' and codi_dime='CuadroPrimasTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/cuadro-608_role-906082a' where codi_dein='pre_cl-cs_cuadro-608_role-906082(2013)' and codi_dime='CuadroDatosEstadisticosTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/cuadro-608_role-906082b' where codi_dein='pre_cl-cs_cuadro-608_role-906082(2013)' and codi_dime='CuadroDatosVariosTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri=NULL where codi_dein='pre_cl-cs_eeff_role-600000' and codi_dime='EstadoCambiosEnPatrimonioTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri=NULL where codi_dein='pre_cl-cs_eeff_role-600000(2013)' and codi_dime='EstadoCambiosEnPatrimonioTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-1_role-810000b' where codi_dein='pre_cl-cs_nota-1_role-810000' and codi_dime='InformacionSobreClasificadoresRiesgoTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-1_role-810000a' where codi_dein='pre_cl-cs_nota-1_role-810000' and codi_dime='InformacionSobreDiezMayoresAccionistasTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-1_role-810000b' where codi_dein='pre_cl-cs_nota-1_role-810000(2013)' and codi_dime='InformacionSobreClasificadoresRiesgoTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-1_role-810000a' where codi_dein='pre_cl-cs_nota-1_role-810000(2013)' and codi_dime='InformacionSobreDiezMayoresAccionistasTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-10_role-822000' where codi_dein='pre_cl-cs_nota-10_role-822000' and codi_dime='ValorizacionPrestamosTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-10_role-822000' where codi_dein='pre_cl-cs_nota-10_role-822000(2013)' and codi_dime='ValorizacionPrestamosTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-11_role-823000' where codi_dein='pre_cl-cs_nota-11_role-823000' and codi_dime='InversionesSegurosConCuentaUnicaInversionTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-11_role-823000' where codi_dein='pre_cl-cs_nota-11_role-823000(2013)' and codi_dime='InversionesSegurosConCuentaUnicaInversionTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-12_role-824000c' where codi_dein='pre_cl-cs_nota-12_role-824000' and codi_dime='CambioEnInversionesEnEmpresasRelacionadasTabla' and pref_dime='cl-cs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-12_role-824000b' where codi_dein='pre_cl-cs_nota-12_role-824000' and codi_dime='InversionesEmpresasAsociadasTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-12_role-824000a' where codi_dein='pre_cl-cs_nota-12_role-824000' and codi_dime='InversionesEmpresasSubsidiariasTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-12_role-824000c' where codi_dein='pre_cl-cs_nota-12_role-824000(2013)' and codi_dime='CambioEnInversionesEnEmpresasRelacionadasTabla' and pref_dime='cl-cs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-12_role-824000b' where codi_dein='pre_cl-cs_nota-12_role-824000(2013)' and codi_dime='InversionesEmpresasAsociadasTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-12_role-824000a' where codi_dein='pre_cl-cs_nota-12_role-824000(2013)' and codi_dime='InversionesEmpresasSubsidiariasTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-13_role-825000b' where codi_dein='pre_cl-cs_nota-13_role-825000' and codi_dime='InformacionCarteraInversionesTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-13_role-825000c' where codi_dein='pre_cl-cs_nota-13_role-825000' and codi_dime='InversionCuotasFondosPorCuentaAseguradosTabla' and pref_dime='cl-cs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-13_role-825000a' where codi_dein='pre_cl-cs_nota-13_role-825000' and codi_dime='MovimientoCarteraInversionesTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-13_role-825000b' where codi_dein='pre_cl-cs_nota-13_role-825000(2013)' and codi_dime='InformacionCarteraInversionesTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-13_role-825000c' where codi_dein='pre_cl-cs_nota-13_role-825000(2013)' and codi_dime='InversionCuotasFondosPorCuentaAseguradosTabla' and pref_dime='cl-cs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-13_role-825000a' where codi_dein='pre_cl-cs_nota-13_role-825000(2013)' and codi_dime='MovimientoCarteraInversionesTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-14_role-826000b' where codi_dein='pre_cl-cs_nota-14_role-826000' and codi_dime='AñosRemanentesContratoLeasingTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-14_role-826000a' where codi_dein='pre_cl-cs_nota-14_role-826000' and codi_dime='PropiedadesDeInversionTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-14_role-826000c' where codi_dein='pre_cl-cs_nota-14_role-826000' and codi_dime='PropiedadesDeUsoPropioTabla' and pref_dime='cl-cs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-14_role-826000b' where codi_dein='pre_cl-cs_nota-14_role-826000(2013)' and codi_dime='AñosRemanentesContratoLeasingTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-14_role-826000a' where codi_dein='pre_cl-cs_nota-14_role-826000(2013)' and codi_dime='PropiedadesDeInversionTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-14_role-826000c' where codi_dein='pre_cl-cs_nota-14_role-826000(2013)' and codi_dime='PropiedadesDeUsoPropioTabla' and pref_dime='cl-cs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-15_role-827000' where codi_dein='pre_cl-cs_nota-15_role-827000' and codi_dime='ActivosNoCorrientesMantenidosParaVentaTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-15_role-827000' where codi_dein='pre_cl-cs_nota-15_role-827000(2013)' and codi_dime='ActivosNoCorrientesMantenidosParaVentaTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-16_role-828000b' where codi_dein='pre_cl-cs_nota-16_role-828000' and codi_dime='CuentasPorCobrarAseguradosFormaPagoTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-16_role-828000c' where codi_dein='pre_cl-cs_nota-16_role-828000' and codi_dime='EvolucionDeterioroCuentasPorCobrarAseguradosTabla' and pref_dime='cl-cs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-16_role-828000a' where codi_dein='pre_cl-cs_nota-16_role-828000' and codi_dime='SaldosAdeudadosPorAseguradosTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-16_role-828000b' where codi_dein='pre_cl-cs_nota-16_role-828000(2013)' and codi_dime='CuentasPorCobrarAseguradosFormaPagoTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-16_role-828000c' where codi_dein='pre_cl-cs_nota-16_role-828000(2013)' and codi_dime='EvolucionDeterioroCuentasPorCobrarAseguradosTabla' and pref_dime='cl-cs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-16_role-828000a' where codi_dein='pre_cl-cs_nota-16_role-828000(2013)' and codi_dime='SaldosAdeudadosPorAseguradosTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-17_role-829000b' where codi_dein='pre_cl-cs_nota-17_role-829000' and codi_dime='EvolucionDelDeterioroPorReaseguradoresTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-17_role-829000a' where codi_dein='pre_cl-cs_nota-17_role-829000' and codi_dime='SaldosAdeudadosPorReaseguroTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-17_role-829000d' where codi_dein='pre_cl-cs_nota-17_role-829000' and codi_dime='SiniestrosPorCobrarReaseguradoresExtranjerosTabla' and pref_dime='cl-cs' and letr_dime='d'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-17_role-829000c' where codi_dein='pre_cl-cs_nota-17_role-829000' and codi_dime='SiniestrosPorCobrarReaseguradoresNacionalesTabla' and pref_dime='cl-cs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-17_role-829000b' where codi_dein='pre_cl-cs_nota-17_role-829000(2013)' and codi_dime='EvolucionDelDeterioroPorReaseguradoresTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-17_role-829000a' where codi_dein='pre_cl-cs_nota-17_role-829000(2013)' and codi_dime='SaldosAdeudadosPorReaseguroTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-17_role-829000d' where codi_dein='pre_cl-cs_nota-17_role-829000(2013)' and codi_dime='SiniestrosPorCobrarReaseguradoresExtranjerosTabla' and pref_dime='cl-cs' and letr_dime='d'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-17_role-829000c' where codi_dein='pre_cl-cs_nota-17_role-829000(2013)' and codi_dime='SiniestrosPorCobrarReaseguradoresNacionalesTabla' and pref_dime='cl-cs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-18_role-830000b' where codi_dein='pre_cl-cs_nota-18_role-830000' and codi_dime='EvolucionDelDeterioroPorCoaseguroTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-18_role-830000a' where codi_dein='pre_cl-cs_nota-18_role-830000' and codi_dime='SaldosAdeudadosPorCoaseguroTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-18_role-830000b' where codi_dein='pre_cl-cs_nota-18_role-830000(2013)' and codi_dime='EvolucionDelDeterioroPorCoaseguroTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-18_role-830000a' where codi_dein='pre_cl-cs_nota-18_role-830000(2013)' and codi_dime='SaldosAdeudadosPorCoaseguroTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-19_role-832100b' where codi_dein='pre_cl-cs_nota-19_role-832100' and codi_dime='ParticipacionReaseguroEnReservasTecnicasTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-19_role-832100a' where codi_dein='pre_cl-cs_nota-19_role-832100' and codi_dime='ReservasTecnicasTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-19_role-832100b' where codi_dein='pre_cl-cs_nota-19_role-832100(2013)' and codi_dime='ParticipacionReaseguroEnReservasTecnicasTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-19_role-832100a' where codi_dein='pre_cl-cs_nota-19_role-832100(2013)' and codi_dime='ReservasTecnicasTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-19_role-832200b' where codi_dein='pre_cl-cs_nota-19_role-832200' and codi_dime='ParticipacionReaseguroEnReservasTecnicasTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-19_role-832200a' where codi_dein='pre_cl-cs_nota-19_role-832200' and codi_dime='ReservasTecnicasTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-19_role-832200b' where codi_dein='pre_cl-cs_nota-19_role-832200(2013)' and codi_dime='ParticipacionReaseguroEnReservasTecnicasTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-19_role-832200a' where codi_dein='pre_cl-cs_nota-19_role-832200(2013)' and codi_dime='ReservasTecnicasTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-21_role-834000' where codi_dein='pre_cl-cs_nota-21_role-834000' and codi_dime='EfectoImpuestosDiferidosEnPatrimonioYEnResultadosTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-21_role-834000' where codi_dein='pre_cl-cs_nota-21_role-834000(2013)' and codi_dime='EfectoImpuestosDiferidosEnPatrimonioYEnResultadosTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-22_role-835000c' where codi_dein='pre_cl-cs_nota-22_role-835000' and codi_dime='CompensacionesPersonalDirectivoClaveYAdministradoresTabla' and pref_dime='cl-cs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-22_role-835000a' where codi_dein='pre_cl-cs_nota-22_role-835000' and codi_dime='CuentasPorCobrarIntermediariosTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-22_role-835000b' where codi_dein='pre_cl-cs_nota-22_role-835000' and codi_dime='SaldosPorCobrarYPagarAEntidadesRelacionadasTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-22_role-835000d' where codi_dein='pre_cl-cs_nota-22_role-835000' and codi_dime='TransaccionesActivosConPartesRelacionadasTabla' and pref_dime='cl-cs' and letr_dime='d'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-22_role-835000f' where codi_dein='pre_cl-cs_nota-22_role-835000' and codi_dime='TransaccionesOtrosConPartesRelacionadasTabla' and pref_dime='cl-cs' and letr_dime='f'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-22_role-835000e' where codi_dein='pre_cl-cs_nota-22_role-835000' and codi_dime='TransaccionesPasivosConPartesRelacionadasTabla' and pref_dime='cl-cs' and letr_dime='e'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-22_role-835000c' where codi_dein='pre_cl-cs_nota-22_role-835000(2013)' and codi_dime='CompensacionesPersonalDirectivoClaveYAdministradoresTabla' and pref_dime='cl-cs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-22_role-835000a' where codi_dein='pre_cl-cs_nota-22_role-835000(2013)' and codi_dime='CuentasPorCobrarIntermediariosTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-22_role-835000b' where codi_dein='pre_cl-cs_nota-22_role-835000(2013)' and codi_dime='SaldosPorCobrarYPagarAEntidadesRelacionadasTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-22_role-835000d' where codi_dein='pre_cl-cs_nota-22_role-835000(2013)' and codi_dime='TransaccionesActivosConPartesRelacionadasTabla' and pref_dime='cl-cs' and letr_dime='d'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-22_role-835000f' where codi_dein='pre_cl-cs_nota-22_role-835000(2013)' and codi_dime='TransaccionesOtrosConPartesRelacionadasTabla' and pref_dime='cl-cs' and letr_dime='f'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-22_role-835000e' where codi_dein='pre_cl-cs_nota-22_role-835000(2013)' and codi_dime='TransaccionesPasivosConPartesRelacionadasTabla' and pref_dime='cl-cs' and letr_dime='e'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-23_role-836000b' where codi_dein='pre_cl-cs_nota-23_role-836000' and codi_dime='DeudasConEntidadesFinancierasTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-23_role-836000a' where codi_dein='pre_cl-cs_nota-23_role-836000' and codi_dime='PasivosFinancierosValorRazonableCambiosEnResultadoTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-23_role-836000b' where codi_dein='pre_cl-cs_nota-23_role-836000(2013)' and codi_dime='DeudasConEntidadesFinancierasTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-23_role-836000a' where codi_dein='pre_cl-cs_nota-23_role-836000(2013)' and codi_dime='PasivosFinancierosValorRazonableCambiosEnResultadoTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-24_role-837000' where codi_dein='pre_cl-cs_nota-24_role-837000' and codi_dime='PasivosNoCorrientesMantenidosParaVentaTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-24_role-837000' where codi_dein='pre_cl-cs_nota-24_role-837000(2013)' and codi_dime='PasivosNoCorrientesMantenidosParaVentaTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838100b' where codi_dein='pre_cl-cs_nota-25_role-838100' and codi_dime='AntecedentesVentaSOAPTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838100a' where codi_dein='pre_cl-cs_nota-25_role-838100' and codi_dime='ReservaDeSiniestrosTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838100b' where codi_dein='pre_cl-cs_nota-25_role-838100(2013)' and codi_dime='AntecedentesVentaSOAPTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838100a' where codi_dein='pre_cl-cs_nota-25_role-838100(2013)' and codi_dime='ReservaDeSiniestrosTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838200d' where codi_dein='pre_cl-cs_nota-25_role-838200' and codi_dime='AjusteReservaCalceTabla' and pref_dime='cl-cs' and letr_dime='d'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838200n' where codi_dein='pre_cl-cs_nota-25_role-838200' and codi_dime='AntecedentesVentaSOAPTabla' and pref_dime='cl-cs' and letr_dime='n'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838200f' where codi_dein='pre_cl-cs_nota-25_role-838200' and codi_dime='AplicacionTablasMortalidadRentasVitaliciasTabla' and pref_dime='cl-cs' and letr_dime='f'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838200e' where codi_dein='pre_cl-cs_nota-25_role-838200' and codi_dime='IndicesCoberturasTabla' and pref_dime='cl-cs' and letr_dime='e'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838200g' where codi_dein='pre_cl-cs_nota-25_role-838200' and codi_dime='InformacionContratosYGruposTabla' and pref_dime='cl-cs' and letr_dime='g'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838200h' where codi_dein='pre_cl-cs_nota-25_role-838200' and codi_dime='InvalidezSinPrimerDictamenTabla' and pref_dime='cl-cs' and letr_dime='h'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838200j' where codi_dein='pre_cl-cs_nota-25_role-838200' and codi_dime='InvalidosParcialesTransitoriosConSolicitudTabla' and pref_dime='cl-cs' and letr_dime='j'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838200k' where codi_dein='pre_cl-cs_nota-25_role-838200' and codi_dime='InvalidosTransitoriosFallecidosTabla' and pref_dime='cl-cs' and letr_dime='k'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838200i' where codi_dein='pre_cl-cs_nota-25_role-838200' and codi_dime='InvalidosTransitoriosTabla' and pref_dime='cl-cs' and letr_dime='i'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838200b' where codi_dein='pre_cl-cs_nota-25_role-838200' and codi_dime='ReservaDescalceSegurosCUITabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838200c' where codi_dein='pre_cl-cs_nota-25_role-838200' and codi_dime='ReservaDeSiniestrosTabla' and pref_dime='cl-cs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838200m' where codi_dein='pre_cl-cs_nota-25_role-838200' and codi_dime='ReservasInvalidezYSobrevivenciaTabla' and pref_dime='cl-cs' and letr_dime='m'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838200a' where codi_dein='pre_cl-cs_nota-25_role-838200' and codi_dime='ReservaValorDelFondoTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838200l' where codi_dein='pre_cl-cs_nota-25_role-838200' and codi_dime='SobrevivenciaTabla' and pref_dime='cl-cs' and letr_dime='l'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838200d' where codi_dein='pre_cl-cs_nota-25_role-838200(2013)' and codi_dime='AjusteReservaCalceTabla' and pref_dime='cl-cs' and letr_dime='d'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838200n' where codi_dein='pre_cl-cs_nota-25_role-838200(2013)' and codi_dime='AntecedentesVentaSOAPTabla' and pref_dime='cl-cs' and letr_dime='n'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838200f' where codi_dein='pre_cl-cs_nota-25_role-838200(2013)' and codi_dime='AplicacionTablasMortalidadRentasVitaliciasTabla' and pref_dime='cl-cs' and letr_dime='f'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838200e' where codi_dein='pre_cl-cs_nota-25_role-838200(2013)' and codi_dime='IndicesCoberturasTabla' and pref_dime='cl-cs' and letr_dime='e'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838200g' where codi_dein='pre_cl-cs_nota-25_role-838200(2013)' and codi_dime='InformacionContratosYGruposTabla' and pref_dime='cl-cs' and letr_dime='g'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838200h' where codi_dein='pre_cl-cs_nota-25_role-838200(2013)' and codi_dime='InvalidezSinPrimerDictamenTabla' and pref_dime='cl-cs' and letr_dime='h'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838200j' where codi_dein='pre_cl-cs_nota-25_role-838200(2013)' and codi_dime='InvalidosParcialesTransitoriosConSolicitudTabla' and pref_dime='cl-cs' and letr_dime='j'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838200k' where codi_dein='pre_cl-cs_nota-25_role-838200(2013)' and codi_dime='InvalidosTransitoriosFallecidosTabla' and pref_dime='cl-cs' and letr_dime='k'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838200i' where codi_dein='pre_cl-cs_nota-25_role-838200(2013)' and codi_dime='InvalidosTransitoriosTabla' and pref_dime='cl-cs' and letr_dime='i'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838200b' where codi_dein='pre_cl-cs_nota-25_role-838200(2013)' and codi_dime='ReservaDescalceSegurosCUITabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838200c' where codi_dein='pre_cl-cs_nota-25_role-838200(2013)' and codi_dime='ReservaDeSiniestrosTabla' and pref_dime='cl-cs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838200m' where codi_dein='pre_cl-cs_nota-25_role-838200(2013)' and codi_dime='ReservasInvalidezYSobrevivenciaTabla' and pref_dime='cl-cs' and letr_dime='m'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838200a' where codi_dein='pre_cl-cs_nota-25_role-838200(2013)' and codi_dime='ReservaValorDelFondoTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-25_role-838200l' where codi_dein='pre_cl-cs_nota-25_role-838200(2013)' and codi_dime='SobrevivenciaTabla' and pref_dime='cl-cs' and letr_dime='l'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-26_role-840000a' where codi_dein='pre_cl-cs_nota-26_role-840000' and codi_dime='DeudasConAseguradosTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-26_role-840000c' where codi_dein='pre_cl-cs_nota-26_role-840000' and codi_dime='DeudasOperacionesCoaseguroTabla' and pref_dime='cl-cs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-26_role-840000b' where codi_dein='pre_cl-cs_nota-26_role-840000' and codi_dime='PrimasPorPagarReaseguradoresTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-26_role-840000a' where codi_dein='pre_cl-cs_nota-26_role-840000(2013)' and codi_dime='DeudasConAseguradosTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-26_role-840000c' where codi_dein='pre_cl-cs_nota-26_role-840000(2013)' and codi_dime='DeudasOperacionesCoaseguroTabla' and pref_dime='cl-cs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-26_role-840000b' where codi_dein='pre_cl-cs_nota-26_role-840000(2013)' and codi_dime='PrimasPorPagarReaseguradoresTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-27_role-842000' where codi_dein='pre_cl-cs_nota-27_role-842000' and codi_dime='ProvisionesTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-27_role-842000' where codi_dein='pre_cl-cs_nota-27_role-842000(2013)' and codi_dime='ProvisionesTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-28_role-843000' where codi_dein='pre_cl-cs_nota-28_role-843000' and codi_dime='DeudasConIntermediariosTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-28_role-843000' where codi_dein='pre_cl-cs_nota-28_role-843000(2013)' and codi_dime='DeudasConIntermediariosTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-29_role-844000' where codi_dein='pre_cl-cs_nota-29_role-844000' and codi_dime='OtrasReservasPatrimonialesTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-29_role-844000' where codi_dein='pre_cl-cs_nota-29_role-844000(2013)' and codi_dime='OtrasReservasPatrimonialesTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-31_role-846000b' where codi_dein='pre_cl-cs_nota-30_role-846000' and codi_dime='PrimaCedidaReaseguradoresExtranjerosTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-31_role-846000a' where codi_dein='pre_cl-cs_nota-30_role-846000' and codi_dime='PrimaCedidaReaseguradoresNacionalesTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-31_role-846000c' where codi_dein='pre_cl-cs_nota-30_role-846000' and codi_dime='ReaseguroNacionalYExtranjeroTabla' and pref_dime='cl-cs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-31_role-846000b' where codi_dein='pre_cl-cs_nota-30_role-846000(2013)' and codi_dime='PrimaCedidaReaseguradoresExtranjerosTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-31_role-846000a' where codi_dein='pre_cl-cs_nota-30_role-846000(2013)' and codi_dime='PrimaCedidaReaseguradoresNacionalesTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-31_role-846000c' where codi_dein='pre_cl-cs_nota-30_role-846000(2013)' and codi_dime='ReaseguroNacionalYExtranjeroTabla' and pref_dime='cl-cs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-31_role-847000' where codi_dein='pre_cl-cs_nota-31_role-847000' and codi_dime='VariacionReservasTecnicasTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-31_role-847000' where codi_dein='pre_cl-cs_nota-31_role-847000(2013)' and codi_dime='VariacionReservasTecnicasTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-35_role-851000' where codi_dein='pre_cl-cs_nota-35_role-851000' and codi_dime='ResultadoInversionesTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-35_role-851000' where codi_dein='pre_cl-cs_nota-35_role-851000(2013)' and codi_dime='ResultadoInversionesTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-38_role-854000a' where codi_dein='pre_cl-cs_nota-38_role-854000' and codi_dime='DiferenciaCambioTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-38_role-854000b' where codi_dein='pre_cl-cs_nota-38_role-854000' and codi_dime='UtilidadPerdidaUnidadesReajustablesTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-38_role-854000a' where codi_dein='pre_cl-cs_nota-38_role-854000(2013)' and codi_dime='DiferenciaCambioTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-38_role-854000b' where codi_dein='pre_cl-cs_nota-38_role-854000(2013)' and codi_dime='UtilidadPerdidaUnidadesReajustablesTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-40_role-856000' where codi_dein='pre_cl-cs_nota-40_role-856000' and codi_dime='ReconciliacionTasaImpuestoEfectivaTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-40_role-856000' where codi_dein='pre_cl-cs_nota-40_role-856000(2013)' and codi_dime='ReconciliacionTasaImpuestoEfectivaTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-42_role-858000' where codi_dein='pre_cl-cs_nota-42_role-858000' and codi_dime='ContingenciasCompromisosTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-42_role-858000' where codi_dein='pre_cl-cs_nota-42_role-858000(2013)' and codi_dime='ContingenciasCompromisosTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-44_role-860000c' where codi_dein='pre_cl-cs_nota-44_role-860000' and codi_dime='MargenContribucionOperacionesSegurosEnMonedaExtranjeraTabla' and pref_dime='cl-cs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-44_role-860000b' where codi_dein='pre_cl-cs_nota-44_role-860000' and codi_dime='MovimientoDivisasPorConceptoReasegurosTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-44_role-860000a' where codi_dein='pre_cl-cs_nota-44_role-860000' and codi_dime='PosicionEnActivosYPasivosEnMonedaExtranjeraTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-44_role-860000c' where codi_dein='pre_cl-cs_nota-44_role-860000(2013)' and codi_dime='MargenContribucionOperacionesSegurosEnMonedaExtranjeraTabla' and pref_dime='cl-cs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-44_role-860000b' where codi_dein='pre_cl-cs_nota-44_role-860000(2013)' and codi_dime='MovimientoDivisasPorConceptoReasegurosTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-44_role-860000a' where codi_dein='pre_cl-cs_nota-44_role-860000(2013)' and codi_dime='PosicionEnActivosYPasivosEnMonedaExtranjeraTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-45_role-861000' where codi_dein='pre_cl-cs_nota-45_role-861000' and codi_dime='CuadroVentasPorRegionesSegurosGeneralesTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-45_role-861000' where codi_dein='pre_cl-cs_nota-45_role-861000(2013)' and codi_dime='CuadroVentasPorRegionesSegurosGeneralesTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-46_role-862100c' where codi_dein='pre_cl-cs_nota-46_role-862100' and codi_dime='MargenSolvenciaGeneralesTabla' and pref_dime='cl-cs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-46_role-862100a' where codi_dein='pre_cl-cs_nota-46_role-862100' and codi_dime='PrimasYFactorReaseguroTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-46_role-862100b' where codi_dein='pre_cl-cs_nota-46_role-862100' and codi_dime='SiniestrosUltimosTresAñosTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-46_role-862100c' where codi_dein='pre_cl-cs_nota-46_role-862100(2013)' and codi_dime='MargenSolvenciaGeneralesTabla' and pref_dime='cl-cs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-46_role-862100a' where codi_dein='pre_cl-cs_nota-46_role-862100(2013)' and codi_dime='PrimasYFactorReaseguroTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-46_role-862100b' where codi_dein='pre_cl-cs_nota-46_role-862100(2013)' and codi_dime='SiniestrosUltimosTresAñosTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-46_role-862200b' where codi_dein='pre_cl-cs_nota-46_role-862200' and codi_dime='CostoDeSiniestrosUltimosTresAñosTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-46_role-862200a' where codi_dein='pre_cl-cs_nota-46_role-862200' and codi_dime='InformacionGeneralMargenSolvenciaTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-46_role-862200c' where codi_dein='pre_cl-cs_nota-46_role-862200' and codi_dime='SegAccidentesSaludYAdicionalesTabla' and pref_dime='cl-cs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-46_role-862200b' where codi_dein='pre_cl-cs_nota-46_role-862200(2013)' and codi_dime='CostoDeSiniestrosUltimosTresAñosTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-46_role-862200a' where codi_dein='pre_cl-cs_nota-46_role-862200(2013)' and codi_dime='InformacionGeneralMargenSolvenciaTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-46_role-862200c' where codi_dein='pre_cl-cs_nota-46_role-862200(2013)' and codi_dime='SegAccidentesSaludYAdicionalesTabla' and pref_dime='cl-cs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-47_role-863100c' where codi_dein='pre_cl-cs_nota-47_role-863100' and codi_dime='CreditoDevengadoYNoDevengadoPorPolizasIndividualesTabla' and pref_dime='cl-cs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-47_role-863100a' where codi_dein='pre_cl-cs_nota-47_role-863100' and codi_dime='DeterminacionPrimaNoDevengadaACompararConCreditoAAseguradosTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-47_role-863100b' where codi_dein='pre_cl-cs_nota-47_role-863100' and codi_dime='PrimaPorCobrarReaseguradosTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-47_role-863100c' where codi_dein='pre_cl-cs_nota-47_role-863100(2013)' and codi_dime='CreditoDevengadoYNoDevengadoPorPolizasIndividualesTabla' and pref_dime='cl-cs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-47_role-863100a' where codi_dein='pre_cl-cs_nota-47_role-863100(2013)' and codi_dime='DeterminacionPrimaNoDevengadaACompararConCreditoAAseguradosTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-47_role-863100b' where codi_dein='pre_cl-cs_nota-47_role-863100(2013)' and codi_dime='PrimaPorCobrarReaseguradosTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-47_role-863200c' where codi_dein='pre_cl-cs_nota-47_role-863200' and codi_dime='CreditoDevengadoYNoDevengadoPorPolizasIndividualesTabla' and pref_dime='cl-cs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-47_role-863200a' where codi_dein='pre_cl-cs_nota-47_role-863200' and codi_dime='DeterminacionPrimaNoDevengadaACompararConCreditoAAseguradosTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-47_role-863200b' where codi_dein='pre_cl-cs_nota-47_role-863200' and codi_dime='PrimaPorCobrarReaseguradosTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-47_role-863200c' where codi_dein='pre_cl-cs_nota-47_role-863200(2013)' and codi_dime='CreditoDevengadoYNoDevengadoPorPolizasIndividualesTabla' and pref_dime='cl-cs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-47_role-863200a' where codi_dein='pre_cl-cs_nota-47_role-863200(2013)' and codi_dime='DeterminacionPrimaNoDevengadaACompararConCreditoAAseguradosTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-47_role-863200b' where codi_dein='pre_cl-cs_nota-47_role-863200(2013)' and codi_dime='PrimaPorCobrarReaseguradosTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-48_role-864000' where codi_dein='pre_cl-cs_nota-48_role-864000' and codi_dime='ActivoNoEfectivoTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-48_role-864000' where codi_dein='pre_cl-cs_nota-48_role-864000(2013)' and codi_dime='ActivoNoEfectivoTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-48_role-864300' where codi_dein='pre_cl-cs_nota-48_role-864300(2013)' and codi_dime='ActivoNoEfectivoTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-6_role-814000' where codi_dein='pre_cl-cs_nota-6_role-814000' and codi_dime='RiesgoCreditoPorClaseActivoFinancieroTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-6_role-814000' where codi_dein='pre_cl-cs_nota-6_role-814000(2013)' and codi_dime='RiesgoCreditoPorClaseActivoFinancieroTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-7_role-815000' where codi_dein='pre_cl-cs_nota-7_role-815000' and codi_dime='DetalleEfectivoYEfectivoEquivalenteTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-7_role-815000' where codi_dein='pre_cl-cs_nota-7_role-815000(2013)' and codi_dime='DetalleEfectivoYEfectivoEquivalenteTabla' and pref_dime='cl-cs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-8_role-816000l' where codi_dein='pre_cl-cs_nota-8_role-816000' and codi_dime='CoberturaRiesgoCreditoTabla' and pref_dime='cl-cs' and letr_dime='l'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-8_role-816000g' where codi_dein='pre_cl-cs_nota-8_role-816000' and codi_dime='ForwardsCompraTabla' and pref_dime='cl-cs' and letr_dime='g'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-8_role-816000h' where codi_dein='pre_cl-cs_nota-8_role-816000' and codi_dime='ForwardsVentaTabla' and pref_dime='cl-cs' and letr_dime='h'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-8_role-816000i' where codi_dein='pre_cl-cs_nota-8_role-816000' and codi_dime='FuturosCompraTabla' and pref_dime='cl-cs' and letr_dime='i'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-8_role-816000j' where codi_dein='pre_cl-cs_nota-8_role-816000' and codi_dime='FuturosVentaTabla' and pref_dime='cl-cs' and letr_dime='j'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-8_role-816000a' where codi_dein='pre_cl-cs_nota-8_role-816000' and codi_dime='InstrumentosFinancierosValorRazonablePorClasesYNivelesTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-8_role-816000e' where codi_dein='pre_cl-cs_nota-8_role-816000' and codi_dime='OpcionesCompraTabla' and pref_dime='cl-cs' and letr_dime='e'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-8_role-816000f' where codi_dein='pre_cl-cs_nota-8_role-816000' and codi_dime='OpcionesVentaTabla' and pref_dime='cl-cs' and letr_dime='f'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-8_role-816000d' where codi_dein='pre_cl-cs_nota-8_role-816000' and codi_dime='OperacionesVentaCortaTabla' and pref_dime='cl-cs' and letr_dime='d'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-8_role-816000b' where codi_dein='pre_cl-cs_nota-8_role-816000' and codi_dime='PosicionContratosDerivadosForwardOpcionesYSwapTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-8_role-816000c' where codi_dein='pre_cl-cs_nota-8_role-816000' and codi_dime='PosicionContratosDerivadosFuturosTabla' and pref_dime='cl-cs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-8_role-816000k' where codi_dein='pre_cl-cs_nota-8_role-816000' and codi_dime='SwapsTabla' and pref_dime='cl-cs' and letr_dime='k'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-8_role-816000l' where codi_dein='pre_cl-cs_nota-8_role-816000(2013)' and codi_dime='CoberturaRiesgoCreditoTabla' and pref_dime='cl-cs' and letr_dime='l'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-8_role-816000g' where codi_dein='pre_cl-cs_nota-8_role-816000(2013)' and codi_dime='ForwardsCompraTabla' and pref_dime='cl-cs' and letr_dime='g'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-8_role-816000h' where codi_dein='pre_cl-cs_nota-8_role-816000(2013)' and codi_dime='ForwardsVentaTabla' and pref_dime='cl-cs' and letr_dime='h'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-8_role-816000i' where codi_dein='pre_cl-cs_nota-8_role-816000(2013)' and codi_dime='FuturosCompraTabla' and pref_dime='cl-cs' and letr_dime='i'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-8_role-816000j' where codi_dein='pre_cl-cs_nota-8_role-816000(2013)' and codi_dime='FuturosVentaTabla' and pref_dime='cl-cs' and letr_dime='j'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-8_role-816000a' where codi_dein='pre_cl-cs_nota-8_role-816000(2013)' and codi_dime='InstrumentosFinancierosValorRazonablePorClasesYNivelesTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-8_role-816000e' where codi_dein='pre_cl-cs_nota-8_role-816000(2013)' and codi_dime='OpcionesCompraTabla' and pref_dime='cl-cs' and letr_dime='e'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-8_role-816000f' where codi_dein='pre_cl-cs_nota-8_role-816000(2013)' and codi_dime='OpcionesVentaTabla' and pref_dime='cl-cs' and letr_dime='f'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-8_role-816000d' where codi_dein='pre_cl-cs_nota-8_role-816000(2013)' and codi_dime='OperacionesVentaCortaTabla' and pref_dime='cl-cs' and letr_dime='d'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-8_role-816000b' where codi_dein='pre_cl-cs_nota-8_role-816000(2013)' and codi_dime='PosicionContratosDerivadosForwardOpcionesYSwapTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-8_role-816000c' where codi_dein='pre_cl-cs_nota-8_role-816000(2013)' and codi_dime='PosicionContratosDerivadosFuturosTabla' and pref_dime='cl-cs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-8_role-816000k' where codi_dein='pre_cl-cs_nota-8_role-816000(2013)' and codi_dime='SwapsTabla' and pref_dime='cl-cs' and letr_dime='k'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-9_role-821000a' where codi_dein='pre_cl-cs_nota-9_role-821000' and codi_dime='InversionesCostoAmortizadoTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-9_role-821000b' where codi_dein='pre_cl-cs_nota-9_role-821000' and codi_dime='OperacionesCompromisosEfectuadosSobreInstrumentosFinancierosTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-9_role-821000a' where codi_dein='pre_cl-cs_nota-9_role-821000(2013)' and codi_dime='InversionesCostoAmortizadoTabla' and pref_dime='cl-cs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/cs/role/nota-9_role-821000b' where codi_dein='pre_cl-cs_nota-9_role-821000(2013)' and codi_dime='OperacionesCompromisosEfectuadosSobreInstrumentosFinancierosTabla' and pref_dime='cl-cs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ias-12_2012-03-29_role-835110' where codi_dein='pre_ias_12_2012-03-29_role-835110' and codi_dime='DisclosureOfTemporaryDifferenceUnusedTaxLossesAndUnusedTaxCreditsTable' and pref_dime='ifrs' and letr_dime=''
update dbax_dime_defi set role_uri='http://xbrl.ifrs.org/role/ifrs/ias_41_2012-03-29_role-824180' where codi_dein='pre_ias_41_2012-03-29_role-824180' and codi_dime='DisclosureOfReconciliationOfChangesInBiologicalAssetsTable' and pref_dime='ifrs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-13_2012-03-29_role-823000' where codi_dein='pre_ifrs_13_2012-03-29_role-823000' and codi_dime='DisclosureOfFairValueMeasurementOfAssetsTable' and pref_dime='ifrs' and letr_dime=''
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-13_2012-03-29_role-823000b' where codi_dein='pre_ifrs_13_2012-03-29_role-823000' and codi_dime='DisclosureOfFairValueMeasurementOfEquityTable' and pref_dime='ifrs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-13_2012-03-29_role-823000a' where codi_dein='pre_ifrs_13_2012-03-29_role-823000' and codi_dime='DisclosureOfFairValueMeasurementOfLiabilitiesTable' and pref_dime='ifrs' and letr_dime='a'
update dbax_dime_defi set role_uri=NULL where codi_dein='pre_ifrs_13_2012-03-29_role-823000' and codi_dime='DisclosureOfLiabilitiesMeasuredAtFairValueAndIssuedWithInseparableThirdpartyCreditEnhancementTa' and pref_dime='ifrs' and letr_dime='f'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-13_2012-03-29_role-823000c' where codi_dein='pre_ifrs_13_2012-03-29_role-823000' and codi_dime='DisclosureOfSignificantUnobservableInputsUsedInFairValueMeasurementOfAssetsTable' and pref_dime='ifrs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-13_2012-03-29_role-823000e' where codi_dein='pre_ifrs_13_2012-03-29_role-823000' and codi_dime='DisclosureOfSignificantUnobservableInputsUsedInFairValueMeasurementOfEquityTable' and pref_dime='ifrs' and letr_dime='e'
update dbax_dime_defi set role_uri='http://www.svs.cl/cl/fr/ci/role/ifrs-13_2012-03-29_role-823000d' where codi_dein='pre_ifrs_13_2012-03-29_role-823000' and codi_dime='DisclosureOfSignificantUnobservableInputsUsedInFairValueMeasurementOfLiabilitiesTable' and pref_dime='ifrs' and letr_dime='d'
update dbax_dime_defi set role_uri='http://xbrl.ifrs.org/role/ifrs/ifrs_3_2011-03-25_role-817000b' where codi_dein='pre_ifrs_3_2011-03-25_role-817000' and codi_dime='DisclosureOfAcquiredReceivablesTable' and pref_dime='ifrs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://xbrl.ifrs.org/role/ifrs/ifrs_3_2011-03-25_role-817000' where codi_dein='pre_ifrs_3_2011-03-25_role-817000' and codi_dime='DisclosureOfBusinessCombinationsTable' and pref_dime='ifrs' and letr_dime=''
update dbax_dime_defi set role_uri='http://xbrl.ifrs.org/role/ifrs/ifrs_3_2011-03-25_role-817000c' where codi_dein='pre_ifrs_3_2011-03-25_role-817000' and codi_dime='DisclosureOfContingentLiabilitiesInBusinessCombinationTable' and pref_dime='ifrs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://xbrl.ifrs.org/role/ifrs/ifrs_3_2011-03-25_role-817000d' where codi_dein='pre_ifrs_3_2011-03-25_role-817000' and codi_dime='DisclosureOfReconciliationOfChangesInGoodwillTable' and pref_dime='ifrs' and letr_dime='d'
update dbax_dime_defi set role_uri='http://xbrl.ifrs.org/role/ifrs/ifrs_3_2011-03-25_role-817000a' where codi_dein='pre_ifrs_3_2011-03-25_role-817000' and codi_dime='DisclosureOfTransactionsRecognisedSeparatelyFromAcquisitionOfAssetsAndAssumptionOfLiabilitiesInBusinessCombinationTable' and pref_dime='ifrs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://xbrl.ifrs.org/role/ifrs/ifrs_3_2012-03-29_role-817000b' where codi_dein='pre_ifrs_3_2012-03-29_role-817000' and codi_dime='DisclosureOfAcquiredReceivablesTable' and pref_dime='ifrs' and letr_dime='b'
update dbax_dime_defi set role_uri='http://xbrl.ifrs.org/role/ifrs/ifrs_3_2012-03-29_role-817000' where codi_dein='pre_ifrs_3_2012-03-29_role-817000' and codi_dime='DisclosureOfBusinessCombinationsTable' and pref_dime='ifrs' and letr_dime=''
update dbax_dime_defi set role_uri='http://xbrl.ifrs.org/role/ifrs/ifrs_3_2012-03-29_role-817000c' where codi_dein='pre_ifrs_3_2012-03-29_role-817000' and codi_dime='DisclosureOfContingentLiabilitiesInBusinessCombinationTable' and pref_dime='ifrs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://xbrl.ifrs.org/role/ifrs/ifrs_3_2012-03-29_role-817000d' where codi_dein='pre_ifrs_3_2012-03-29_role-817000' and codi_dime='DisclosureOfReconciliationOfChangesInGoodwillTable' and pref_dime='ifrs' and letr_dime='d'
update dbax_dime_defi set role_uri=NULL where codi_dein='pre_ifrs_3_2012-03-29_role-817000' and codi_dime='DisclosureOfTransactionsRecognisedSeparatelyFromAcquisitionOfAssetsAndAssumptionOfLiabilitiesIn' and pref_dime='ifrs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://xbrl.ifrs.org/role/ifrs/ifrs_8_2011-03-25_role-871100c' where codi_dein='pre_ifrs_8_2011-03-25_role-871100' and codi_dime='DisclosureOfGeographicalAreasTable' and pref_dime='ifrs' and letr_dime='c'
update dbax_dime_defi set role_uri='http://xbrl.ifrs.org/role/ifrs/ifrs_8_2011-03-25_role-871100d' where codi_dein='pre_ifrs_8_2011-03-25_role-871100' and codi_dime='DisclosureOfMajorCustomersTable' and pref_dime='ifrs' and letr_dime='d'
update dbax_dime_defi set role_uri='http://xbrl.ifrs.org/role/ifrs/ifrs_8_2011-03-25_role-871100a' where codi_dein='pre_ifrs_8_2011-03-25_role-871100' and codi_dime='DisclosureOfOperatingSegmentsTable' and pref_dime='ifrs' and letr_dime='a'
update dbax_dime_defi set role_uri='http://xbrl.ifrs.org/role/ifrs/ifrs_8_2011-03-25_role-871100b' where codi_dein='pre_ifrs_8_2011-03-25_role-871100' and codi_dime='DisclosureOfProductsAndServicesTable' and pref_dime='ifrs' and letr_dime='b'

alter PROCEDURE [dbo].[SP_AX_getAxisMemb] 
	@pPrefMemb VARCHAR(20),
	@pCodiMemb VARCHAR(256),
	@pPrefDime VARCHAR(20),
	@pCodiDime VARCHAR(256),
	@pCodiDein VARCHAR(50)
	
AS
BEGIN
	select dm.pref_axis,dm.codi_axis,orde_memb
from dbax_dime_memb dm,
dbax_dime_diax dd
where dm.codi_axis=dd.codi_axis
and dm.pref_memb=@pPrefMemb
and dm.codi_memb=@pCodiMemb
and dd.pref_dime=@pPrefDime
and dd.codi_dime=@pCodiDime
and dd.codi_dein=@pCodiDein
END
Go
ALTER PROCEDURE [dbo].[SP_AX_GetScheInfo] (@pScheInfo varchar(256))
AS
BEGIN
set @pScheInfo = replace(replace(@pScheInfo,'//','/'),':/','://')
select codi_info from dbax_taxo_info where sche_info = @pScheInfo or sche_info2=@pScheInfo
END
Go
ALTER PROCEDURE [dbo].[SP_AX_insInstInfo] (@pCodiPers numeric(9,0),@pCorrInst numeric(10,0), @pVersInst numeric(5,0),@pCodiInfo varchar(50))
AS
BEGIN
if ((select count(*) from dbax_inst_info where codi_pers=@pCodiPers and corr_inst=@pCorrInst and vers_inst=@pVersInst and codi_info=@pCodiInfo)=0)
insert into dbax_inst_info (codi_pers,corr_inst,vers_inst,codi_info)values(@pCodiPers,@pCorrInst,@pVersInst,@pCodiInfo)
END
Go
alter procedure [dbo].[SP_AX_getMiembroInstMemb ]
	@p_codi_pers varchar(30),
	@p_corr_inst varchar(10),
	@p_vers_inst varchar(2),
	@p_pref_memb varchar(20),
	@p_codi_memb varchar(256)
	
as
BEGIN
select codi_memb
from dbax_inst_memb
where codi_pers=@p_codi_pers
and   corr_inst=@p_corr_inst
and   vers_inst=@p_vers_inst
and   codi_memb=@p_pref_memb + ':' +  @p_codi_memb
END
GO
create PROCEDURE [dbo].[SP_AX_getDimeDefi] 
	@pRoleUri VARCHAR(256)
AS
BEGIN
	select codi_dein,pref_dime,codi_dime,letr_dime
	from	dbax_dime_defi 	
	where	role_uri=@pRoleUri
	
END
Go
create PROCEDURE [dbo].[SP_AX_GetOrdenMembVari] 
	@pCodiPers VARCHAR(16),
	@pCorrInst NUMERIC(10,0),
	@pVersInst NUMERIC(5,0),
	@pCodiDein VARCHAR(50),
	@pPrefDime VARCHAR(20),
	@pCodiDime VARCHAR(256),
	@pPrefMem VARCHAR(20),
	@pCodiMemb VARCHAR(256)
AS
BEGIN
select isnull(max(orde_memb),0) orde_memb
from dbax_inst_dime
where codi_pers=@pCodiPers
and corr_inst=@pCorrInst
and vers_inst=@pVersInst
and codi_dein=@pCodiDein
and pref_dime=@pPrefDime
and codi_dime=@pCodiDime
and memb_papa=@pPrefMem + ':' + @pCodiMemb
END
GO

delete from dbax_taxo_vers where vers_taxo = 'cl-hb-2009-03-31'
GO
delete from dbax_taxo_conc where vers_taxo = 'svs-cl-ci-2008-10-31'
GO
delete from dbax_taxo_vers where vers_taxo = 'svs-cl-ci-2008-10-31'
GO

ALTER procedure [dbo].[SP_AX_GetConcDife](
	@pCodi_pers numeric(9,0) ,
	@pCorr_inst varchar(10),
	@pVers_inst numeric(5,0)) 
as
declare @pVers_ante numeric (5,0)
BEGIN
set @pVers_ante = @pVers_inst - 1
	select  v.codi_conc,x1.fini_cntx,isnull(x1.ffin_cntx,0)ffin_cntx
		from	dbax_inst_conc v,
			dbax_inst_cntx x1,
			dbax_defi_conc c,
			dbax_info_defi i,
			dbax_desc_conc d
		where v.codi_pers = @pCodi_pers
		and   v.corr_inst = @pCorr_inst
		and   v.vers_inst = @pVers_ante
		and   v.pref_conc = c.pref_conc
		and   v.codi_conc = c.codi_conc
		and   x1.codi_pers = v.codi_pers
		and   x1.corr_inst = v.corr_inst
		and   x1.codi_cntx = v.codi_cntx
		and   c.pref_conc  = d.pref_conc
		and   c.codi_conc  = d.codi_conc    
		and   exists (	select 1
					   from dbax_inst_conc v1,
							dbax_inst_cntx x2
					   where v1.codi_pers = @pCodi_pers
					   and   v1.corr_inst = @pCorr_inst
					   and   v1.vers_inst = @pVers_inst
					   and   v1.pref_conc = v.pref_conc
					   and   v1.codi_conc = v.codi_conc
					   and   v1.codi_cntx = v.codi_cntx
					   and   x2.codi_pers = v1.codi_pers 
					   and   x2.corr_inst = v1.corr_inst
					   and   x2.vers_inst = v1.vers_inst
					   and   x2.fini_cntx = x1.fini_cntx
					   and   isnull(x2.ffin_cntx,'') = isnull(x1.ffin_cntx,'')
					   and   x1.codi_pers = v1.codi_pers
					   and   replace(v1.valo_cntx,'.00','') != replace(v.valo_cntx,'.00',''))
		group by  v.codi_conc,x1.fini_cntx,x1.ffin_cntx
union 
 select  v.codi_conc,x1.fini_cntx,isnull(x1.ffin_cntx,0)ffin_cntx
		from	dbax_inst_conc v,
			dbax_inst_cntx x1,
			dbax_defi_conc c,
			dbax_info_defi i,
			dbax_desc_conc d
		where v.codi_pers = @pCodi_pers
		and   v.corr_inst = @pCorr_inst
		and   v.vers_inst = @pVers_ante
		and   v.pref_conc = c.pref_conc
		and   v.codi_conc = c.codi_conc
		and   x1.codi_pers = v.codi_pers
		and   x1.corr_inst = v.corr_inst
		and   x1.codi_cntx = v.codi_cntx
		and   c.pref_conc  = d.pref_conc
		and   c.codi_conc  = d.codi_conc  
		and   not exists (	select 1
					   from dbax_inst_conc v1,
							dbax_inst_cntx x2
					   where v1.codi_pers = @pCodi_pers
					   and   v1.corr_inst = @pCorr_inst
					   and   v1.vers_inst = @pVers_inst
					   and   v1.pref_conc = v.pref_conc
					   and   v1.codi_conc = v.codi_conc
					   and   v1.codi_cntx = v.codi_cntx
					   and   x2.codi_pers = v1.codi_pers 
					   and   x2.corr_inst = v1.corr_inst
					   and   x2.vers_inst = v1.vers_inst
					   and   x2.fini_cntx = x1.fini_cntx
					   and   isnull(x2.ffin_cntx,'') = isnull(x1.ffin_cntx,'')
					   and   x1.codi_pers = v1.codi_pers
					   )
		group by v.codi_conc,x1.fini_cntx,x1.ffin_cntx
union
select  v.codi_conc,x1.fini_cntx,isnull(x1.ffin_cntx,0)ffin_cntx
	from	dbax_inst_conc v,
			dbax_inst_cntx x1,
			dbax_defi_conc c,
			dbax_info_defi i,
			dbax_desc_conc d
		where v.codi_pers = @pCodi_pers
		and   v.corr_inst = @pCorr_inst
		and   v.vers_inst = @pVers_inst
		and   v.pref_conc = c.pref_conc
		and   v.codi_conc = c.codi_conc
		and   x1.codi_pers = v.codi_pers
		and   x1.corr_inst = v.corr_inst
		and   x1.codi_cntx = v.codi_cntx
		and   c.pref_conc  = d.pref_conc
		and   c.codi_conc  = d.codi_conc   
		and   not exists (	select 1
					   from dbax_inst_conc v1,
							dbax_inst_cntx x2
					   where v1.codi_pers = @pCodi_pers
					   and   v1.corr_inst = @pCorr_inst
					   and   v1.vers_inst = @pVers_ante
					   and   v1.pref_conc = v.pref_conc
					   and   v1.codi_conc = v.codi_conc
					   and   v1.codi_cntx = v.codi_cntx
					   and   x2.codi_pers = v1.codi_pers 
					   and   x2.corr_inst = v1.corr_inst
					   and   x2.vers_inst = v1.vers_inst
					   and   x2.fini_cntx = x1.fini_cntx
					   and   isnull(x2.ffin_cntx,'') = isnull(x1.ffin_cntx,'')
					   and   x1.codi_pers = v1.codi_pers
					   )
		group by  v.codi_conc,x1.fini_cntx,x1.ffin_cntx
END
GO

/*
select	distinct substring(C.codi_conc, 1, charindex('_', C.codi_conc)-1) prefijo,
		substring(C.codi_conc, charindex('_', C.codi_conc)+1, 1000) sufijo
from	(select	substring(ic.codi_conc,charindex('#',ic.codi_conc)+1,1000) codi_conc
		from	xbrl_taxo_info ti,
				xbrl_info_conc ic
		where	ti.vers_taxo = 'svs-cl-ci-2013-01-31'
		and		ti.codi_info = ic.codi_info) C
--where	substring(C.codi_conc, 1, 4) = 'ifrs'
order by 1,2
*/

AGREGAR DATO en dbnet_defi_lang

insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'INDICADORESGESTIONVIDA','codi_cort','IndiGestVida')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'InformeIndicador','codi_cort','InfoIndi')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'Mercurio','codi_cort','Merc')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-ci_ias-1_2011-03-25_role-210000','codi_cort','BALA_CLAS')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-ci_ias-1_2011-03-25_role-220000','codi_cort','BALA_LIQU')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-ci_ias-1_2011-03-25_role-310000','codi_cort','RESU_FUNC')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-ci_ias-1_2011-03-25_role-320000','codi_cort','RESU_NATU')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-ci_ias-1_2011-03-25_role-420000','codi_cort','RESU_INTE')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-ci_ias-1_2012-03-29_role-110000','codi_cort','INFO_GENE')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-ci_ias-1_2012-03-29_role-110000(2013)','codi_cort','INFO_GENE')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-ci_ias-1_2012-03-29_role-210000','codi_cort','BALA_CLAS')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-ci_ias-1_2012-03-29_role-210000(2013)','codi_cort','BALA_CLAS')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-ci_ias-1_2012-03-29_role-220000','codi_cort','BALA_LIQU')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-ci_ias-1_2012-03-29_role-310000','codi_cort','RESU_FUNC')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-ci_ias-1_2012-03-29_role-310000(2013)','codi_cort','RESU_FUNC')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-ci_ias-1_2012-03-29_role-320000','codi_cort','RESU_NATU')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-ci_ias-7_2011-03-25_role-510000','codi_cort','FLUJ_DIRE')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-ci_ias-7_2011-03-25_role-520000','codi_cort','FLUJ_INDI')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-ci_ias-7_2012-03-29_role-510000','codi_cort','FLUJ_DIRE')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-ci_ias-7_2012-03-29_role-510000(2013)','codi_cort','FLUJ_DIRE')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-ci_ias-7_2012-03-29_role-520000','codi_cort','FLUJ_INDI')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-cs_eeff_role-110000','codi_cort','INFO_GENE')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-cs_eeff_role-110000(2013)','codi_cort','INFO_GENE')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-cs_eeff_role-200000','codi_cort','BALA_SEGU')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-cs_eeff_role-200000(2013)','codi_cort','BALA_SEGU')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-cs_eeff_role-300000','codi_cort','RESU_SEGU')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-cs_eeff_role-300000(2013)','codi_cort','RESU_SEGU')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-cs_eeff_role-500000','codi_cort','FLUJ_SEGU')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-cs_eeff_role-500000(2013)','codi_cort','FLUJ_SEGU')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-hb_ias-1_2012-03-29_role-210000','codi_cort','BALA_HBAN')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-hb_ias-1_2012-03-29_role-310000','codi_cort','RESU_HBAN')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-hb_ias-7_2012-03-29_role-510000','codi_cort','FLUJ_HBAN')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-hs_ias-1_2012-03-29_role-210000','codi_cort','BALA_HSEG')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-hs_ias-1_2012-03-29_role-310000','codi_cort','RESU_HSEG')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'pre_cl-hs_ias-7_2012-03-29_role-510000','codi_cort','FLUJ_HSEG')
insert into dbax_desc_info (codi_empr, codi_emex, codi_info, codi_lang, desc_info) values (1,1,'ResumenFinanciero','codi_cort','RESU_FINA')

--HOLDING 0 HOLDING BASE
empr_exte
0	Holding base	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
empr
0	0	NULL	asd	101060	SANT	1	9	NULL	Empresa Base	NULL	0	NULL	NULL	0	NULL	NULL	NULL	NULL	0,00	0,00	01-04-2013 0:00:00	01-04-2013 0:00:00	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	Empresa base


DROPEAR FK POR QUE SE ACTUALIZO
ALTER TABLE [dbo].[dbax_info_cntx]  WITH CHECK ADD  CONSTRAINT [FK_dbax_info_cntx_dbax_defi_cntx] FOREIGN KEY([codi_empr], [codi_emex], [codi_cntx])
REFERENCES [dbo].[dbax_defi_cntx] ([codi_empr], [codi_emex], [codi_cntx])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dbax_info_cntx] CHECK CONSTRAINT [FK_dbax_info_cntx_dbax_defi_cntx]
GO

delete from dbax_defi_cntx  where codi_emex = 0
insert into dbax_defi_cntx (codi_emex,codi_empr, codi_cntx, diai_cntx, anoi_cntx, diat_cntx, anot_cntx, desc_cntx, orde_cntx) values (0,0,'Cierre Trimestre Anterior','ultimodiatrimestreactual','anoanterior','0','0','Cierre Trimestre Anterior','3')
insert into dbax_defi_cntx (codi_emex,codi_empr, codi_cntx, diai_cntx, anoi_cntx, diat_cntx, anot_cntx, desc_cntx, orde_cntx) values (0,0,'CierreAnualAnterior','finano','anoanterior','0','0','CierreAnualAnterior','7')
insert into dbax_defi_cntx (codi_emex,codi_empr, codi_cntx, diai_cntx, anoi_cntx, diat_cntx, anot_cntx, desc_cntx, orde_cntx) values (0,0,'CierreAnualPrevioAnterior','finano','anoprevioanterior','0','0','CierreAnualPrevioAnterior','8')
insert into dbax_defi_cntx (codi_emex,codi_empr, codi_cntx, diai_cntx, anoi_cntx, diat_cntx, anot_cntx, desc_cntx, orde_cntx) values (0,0,'CierreTrimestreActual','ultimodiatrimestreactual','anoactual','0','0','Cierre Trimestre Actual','1')
insert into dbax_defi_cntx (codi_emex,codi_empr, codi_cntx, diai_cntx, anoi_cntx, diat_cntx, anot_cntx, desc_cntx, orde_cntx) values (0,0,'Contexto desde cero','ultimodiatrimestreactual','anoactual','finano','anoactual','Contextodesdecero','9')
insert into dbax_defi_cntx (codi_emex,codi_empr, codi_cntx, diai_cntx, anoi_cntx, diat_cntx, anot_cntx, desc_cntx, orde_cntx) values (0,0,'TrimestreActual','iniciotrimestreactual','anoactual','ultimodiatrimestreactual','anoactual','TrimestreActual','5')
insert into dbax_defi_cntx (codi_emex,codi_empr, codi_cntx, diai_cntx, anoi_cntx, diat_cntx, anot_cntx, desc_cntx, orde_cntx) values (0,0,'TrimestreAcumuladoActual','inicioano','anoactual','ultimodiatrimestreactual','anoactual','Trimestre Acumulado Actual','2')
insert into dbax_defi_cntx (codi_emex,codi_empr, codi_cntx, diai_cntx, anoi_cntx, diat_cntx, anot_cntx, desc_cntx, orde_cntx) values (0,0,'TrimestreAcumuladoAnterior','inicioano','anoanterior','ultimodiatrimestreactual','anoanterior','TrimestreAcumuladoAnterior','4')
insert into dbax_defi_cntx (codi_emex,codi_empr, codi_cntx, diai_cntx, anoi_cntx, diat_cntx, anot_cntx, desc_cntx, orde_cntx) values (0,0,'TrimestreAnterior','iniciotrimestreactual','anoanterior','ultimodiatrimestreactual','anoanterior','TrimestreAnterior','6')

update dbax_form_enca set codi_emex = 0, codi_empr = 0 where codi_emex = 1 and codi_empr = 1

delete from dbax_form_enca where codi_emex = 1 and codi_empr = 1
delete from dbax_form_deta where codi_emex = 1 and codi_empr = 1


--Columnas agregadas
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'dbax_info_defi' AND COLUMN_NAME = 'tipo_info')
BEGIN
	ALTER TABLE dbax_info_defi ADD tipo_info varchar(2) NOT NULL CONSTRAINT DF_DBAX_INFO_DEFI_TIPO_INFO DEFAULT 'C'
END
Go

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'dbax_info_conc' AND COLUMN_NAME = 'tipo_info')
BEGIN
	ALTER TABLE dbax_info_conc ADD tipo_info varchar(2) NOT NULL CONSTRAINT DF_DBAX_INFO_CONC_TIPO_INFO DEFAULT 'C'
END
Go

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'dbax_desc_info' AND COLUMN_NAME = 'tipo_info')
BEGIN
	ALTER TABLE dbax_desc_info ADD tipo_info varchar(2) NOT NULL CONSTRAINT DF_DBAX_DESC_INFO_TIPO_INFO DEFAULT 'C'
END
Go

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'dbax_info_cntx' AND COLUMN_NAME = 'tipo_info')
BEGIN
	ALTER TABLE dbax_info_cntx ADD tipo_info varchar(2) NOT NULL CONSTRAINT DF_DBAX_INFO_CNTX_TIPO_INFO DEFAULT 'C'
END
Go

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'dbax_taxo_vers' AND COLUMN_NAME = 'desc_taxo')
BEGIN
	ALTER TABLE dbax_taxo_vers ADD desc_taxo varchar(2)
END
Go
--PK y FK modificados
if exists(SELECT * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_NAME ='FK_dbax_info_conc_dbax_info_defi') ALTER TABLE [dbax_info_conc] DROP CONSTRAINT [FK_dbax_info_conc_dbax_info_defi]
GO
if exists(SELECT * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_NAME ='FK_dbax_info_cntx_dbax_info_defi') ALTER TABLE [dbax_info_cntx] DROP CONSTRAINT [FK_dbax_info_cntx_dbax_info_defi]
GO
if exists(SELECT * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_NAME ='FK_dbax_desc_info_dbax_info_defi') ALTER TABLE [dbax_desc_info] DROP CONSTRAINT [FK_dbax_desc_info_dbax_info_defi]
GO

if exists(select name from sysobjects where name = 'PK_dbax_info_defi_1') ALTER TABLE [dbo].[dbax_info_defi] DROP  CONSTRAINT [PK_dbax_info_defi_1]
Go
if exists(select name from sysobjects where name = 'PK_xbrl_info_conc') ALTER TABLE [dbo].[dbax_info_conc] DROP  CONSTRAINT [PK_xbrl_info_conc]
Go
if exists(select name from sysobjects where name = 'PK_dbax_info_cntx') ALTER TABLE [dbo].[dbax_info_cntx] DROP  CONSTRAINT [PK_dbax_info_cntx]
Go
if exists(select name from sysobjects where name = 'PK_xbrl_desc_info') ALTER TABLE [dbo].[dbax_desc_info] DROP  CONSTRAINT [PK_xbrl_desc_info]
Go

/****** Objeto:  Index [PK_dbax_info_defi_1]    Fecha de la secuencia de comandos: 10/03/2013 18:15:01 ******/
ALTER TABLE [dbo].[dbax_info_defi] ADD  CONSTRAINT [PK_dbax_info_defi_1] PRIMARY KEY CLUSTERED 
(
	[codi_empr] ASC,
	[codi_emex] ASC,
	[codi_info] ASC,
	[tipo_info] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Objeto:  Index [PK_xbrl_info_conc]    Fecha de la secuencia de comandos: 10/03/2013 18:15:18 ******/
ALTER TABLE [dbo].[dbax_info_conc] ADD  CONSTRAINT [PK_xbrl_info_conc] PRIMARY KEY CLUSTERED 
(
	[codi_empr] ASC,
	[codi_emex] ASC,
	[codi_info] ASC,
	[pref_conc] ASC,
	[codi_conc] ASC,
	[orde_conc] ASC,
	[tipo_info] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Objeto:  Index [PK_dbax_info_cntx]    Fecha de la secuencia de comandos: 10/03/2013 18:15:32 ******/
ALTER TABLE [dbo].[dbax_info_cntx] ADD  CONSTRAINT [PK_dbax_info_cntx] PRIMARY KEY CLUSTERED 
(
	[codi_inct] ASC,
	[codi_empr] ASC,
	[codi_emex] ASC,
	[codi_info] ASC,
	[codi_cntx] ASC,
	[tipo_info] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


/****** Objeto:  Index [PK_xbrl_desc_info]    Fecha de la secuencia de comandos: 10/03/2013 18:15:46 ******/
ALTER TABLE [dbo].[dbax_desc_info] ADD  CONSTRAINT [PK_xbrl_desc_info] PRIMARY KEY CLUSTERED 
(
	[codi_empr] ASC,
	[codi_emex] ASC,
	[codi_info] ASC,
	[codi_lang] ASC,
	[tipo_info] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


ALTER TABLE [dbo].[dbax_info_conc]  WITH CHECK ADD  CONSTRAINT [FK_dbax_info_conc_dbax_info_defi] FOREIGN KEY([codi_empr], [codi_emex], [codi_info], [tipo_info])
REFERENCES [dbo].[dbax_info_defi] ([codi_empr], [codi_emex], [codi_info], [tipo_info])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dbax_info_conc] CHECK CONSTRAINT [FK_dbax_info_conc_dbax_info_defi]
GO

ALTER TABLE [dbo].[dbax_info_cntx]  WITH CHECK ADD  CONSTRAINT [FK_dbax_info_cntx_dbax_info_defi] FOREIGN KEY([codi_empr], [codi_emex], [codi_info], [tipo_info])
REFERENCES [dbo].[dbax_info_defi] ([codi_empr], [codi_emex], [codi_info], [tipo_info])
GO
ALTER TABLE [dbo].[dbax_info_cntx] CHECK CONSTRAINT [FK_dbax_info_cntx_dbax_info_defi]
GO


ALTER TABLE [dbo].[dbax_desc_info]  WITH CHECK ADD  CONSTRAINT [FK_dbax_desc_info_dbax_info_defi] FOREIGN KEY([codi_empr], [codi_emex], [codi_info], [tipo_info])
REFERENCES [dbo].[dbax_info_defi] ([codi_empr], [codi_emex], [codi_info], [tipo_info])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dbax_desc_info] CHECK CONSTRAINT [FK_dbax_desc_info_dbax_info_defi]
GO

ALTER TABLE [dbo].[dbax_homo_conc] ALTER COLUMN [pref_conc] varchar(50) NULL;