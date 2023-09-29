USE [dbaxBI]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<JGALDAMEZ>
-- Create date: <2014-03-06>
-- Description:	<Crea tablas y las llena a partir de las vistas,
--				 aca se elimina y se inserta todo sin filtros>
-- =============================================
CREATE PROCEDURE [dbo].[prc_bi_dbax_create] 
	
as

select getdate(), 'INICIO'

	drop table PF_07_Valores
	drop table PF_06_Periodos
	drop table PF_05_SubRamos
	--drop table PF_05_Otros
	drop table PF_04_Ramos
	drop table PF_03_Conceptos
	drop table PF_02_Empresas
	drop table PF_01_Segmentos

BEGIN
	
select	codi_segm			as Segmento, 
			desc_segm			as NombreSegmento 
	into	PF_01_Segmentos
	from 	BI_SG_Segmento
	

	select	codi_segm + '_' + codi_pers	as PKEmpresa, 
			codi_pers			as Rut, 
			nomb_pers			as RazonSocial,
			codi_pers + ' ' + nomb_pers	as RazonSocialCompleta,
			empr_vige			as Vigente
	into	PF_02_Empresas
	from	BI_SG_Empresas
	

	select	codi_segm + '_' + codi_conc	as PKConcepto,
			desc_info			as Cuadro,
			desc_dime			as Tabla,
			codi_conc			as CodigoConcepto, 
			desc_conc			as Concepto 
	into	PF_03_Conceptos 
	from BI_SG_Conceptos
	

	select	codi_segm + '_' + codi_ramo	as PKRamo, 
			codi_ramo			as CodigoRamo, 
			desc_ramo			as Ramo,
			nume_ramo			as NumeroRamo
	into	PF_04_Ramos
	from BI_SG_Ramos
	

	select	distinct
			codi_segm + '_' + codi_ramo	as PKSubRamo, 
			codi_ramo			as CodigoSubRamo, 
			desc_ramo			as SubRamo,
			nume_ramo			as NumeroSubRamo
	into	PF_05_SubRamos
	from BI_SG_SubRamos
	order by 1
	

	select	distinct
			codi_cntx			as CodigoPeriodo, 
			desc_cntx			as Periodo
	into	PF_06_Periodos
	from BI_SG_Periodos
	order by codi_cntx
	

	alter table PF_01_Segmentos	alter column	Segmento	varchar(30) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_01_Segmentos	add constraint	PK_Segmentos	PRIMARY KEY CLUSTERED (Segmento)
	
	alter table PF_02_Empresas	alter column	PKEmpresa	varchar(30) collate Modern_Spanish_CI_AS not null 
	alter table PF_02_Empresas	alter column	Rut		varchar(15) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_02_Empresas	add constraint	PK_Empresas	PRIMARY KEY CLUSTERED (PKEmpresa)
	
	alter table PF_04_Ramos		alter column	PKRamo		varchar(80) collate Modern_Spanish_CI_AS not null 
	alter table PF_04_Ramos		alter column	CodigoRamo	varchar(50) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_04_Ramos		add constraint	PK_Ramos	PRIMARY KEY CLUSTERED (PKRamo)
	
	alter table PF_05_SubRamos	alter column	PKSubRamo	varchar(80) collate Modern_Spanish_CI_AS not null 
	alter table PF_05_SubRamos	alter column	CodigoSubRamo	varchar(50) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_05_SubRamos	add constraint	PK_SubRamos	PRIMARY KEY CLUSTERED (PKSubRamo)
	
	alter table PF_03_Conceptos	alter column	PKConcepto	varchar(256) collate Modern_Spanish_CI_AS not null 
	alter table PF_03_Conceptos	alter column	CodigoConcepto	varchar(256) collate Modern_Spanish_CI_AS not null 
	alter table PF_03_Conceptos	alter column	Cuadro		varchar(512) collate Modern_Spanish_CI_AS not null 
	alter table PF_03_Conceptos	alter column	Tabla		varchar(512) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_03_Conceptos	add constraint	PK_Conceptos	PRIMARY KEY CLUSTERED (PKConcepto)
	
	alter table PF_06_Periodos	alter column	Periodo		varchar(7) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_06_Periodos	add constraint	PK_Periodos	PRIMARY KEY CLUSTERED (Periodo DESC)
	
	select getdate(), 'Tablas Basica Creadas'
	
	--drop table [ZZ_inst_ramo]
	--go
	CREATE TABLE	[dbo].[ZZ_inst_ramo](
		[codi_pers]	[varchar](16) 		COLLATE Modern_Spanish_CS_AS NOT NULL,
		[corr_inst]	[numeric](7, 0)		NOT NULL,
		[corr_inst1] [numeric](7, 0) 		NOT NULL,
		[vers_inst] [numeric](5, 0) 		NOT NULL,
		[codi_cntx] [varchar](256) 		COLLATE Modern_Spanish_CS_AS NOT NULL,
		[codi_axis] [varchar](256) 		COLLATE Modern_Spanish_CS_AS NOT NULL,
		[fini_cntx] [varchar](10) 		COLLATE Modern_Spanish_CS_AS NULL,
		[ffin_cntx] [varchar](10) 		COLLATE Modern_Spanish_CS_AS NULL,
		[ceje_ramo] [varchar](256) 		COLLATE Modern_Spanish_CS_AS NOT NULL,
		[codi_ramo] [varchar](256) 		COLLATE Modern_Spanish_CS_AS NULL,
		[desc_ramo] [varchar](256) 		COLLATE Modern_Spanish_CI_AS NULL,
		[ceje_subr] [varchar](256) 		COLLATE Modern_Spanish_CS_AS NULL,
		[codi_subr] [varchar](256) 		COLLATE Modern_Spanish_CS_AS NULL,
		[desc_subr] [varchar](256) 		COLLATE Modern_Spanish_CS_AS NULL
	) ON [PRIMARY]
	

	CREATE CLUSTERED INDEX [idx_ZZ_inst_ramo] ON ZZ_inst_ramo
	(
		[corr_inst] ASC,
		[codi_pers] ASC,
		[vers_inst] ASC,
		[codi_cntx] ASC
	)
	
	insert into ZZ_inst_ramo
	select	codi_pers, corr_inst, replace(substring(isnull(ffin_cntx,fini_cntx),1,7),'-','') corr_inst1,
		vers_inst, 
		codi_cntx, 
		codi_axis, fini_cntx, ffin_cntx, ceje_ramo, codi_ramo, desc_ramo, ceje_subr, codi_subr, desc_subr
	from	dbax.dbo.dbax_inst_ramo
	
	select getdate(), 'Tabla ZZ_inst_ramo Creada'

	--drop table dbo.ZZ_inst_conc
	--GO

	select	*
	into    ZZ_inst_conc
	from	dbax.dbo.dbax_inst_conc ic
	where   exists (select 1 from dbax.dbo.dbax_defi_pers d where d.codi_pers = ic.codi_pers and codi_segm like '%SEGUR%')
	and     exists (select 1 from dbax.dbo.dbax_dime_conc d where d.codi_conc = ic.codi_conc and d.codi_dein like '%cuadro%')
	and     exists (select 1 from ZZ_inst_ramo d where d.codi_cntx = ic.codi_cntx)
	

	CREATE CLUSTERED INDEX [idx_ZZ_inst_conc] ON [dbo].[ZZ_inst_conc] 
	(
		[corr_inst] ASC,
		[codi_pers] ASC,
		[vers_inst] ASC,
		[codi_conc] ASC,
		[codi_cntx] ASC
	)
	

	select getdate(), 'Tabla ZZ_inst_conc Creada'
	

	UPDATE	ZZ_inst_conc
	SET	valo_refe = convert(varchar(5000),replace(convert(numeric(38,4),convert(numeric(38,14),CAST(LTRIM(RTRIM(replace(valo_cntx,',','.')))AS FLOAT)) / d.valo_camo),'.',','))
	FROM	ZZ_inst_conc i,
		dbax.dbo.dbax_inst_unit u,
		dbax.dbo.dbn_camb_mone d,
		dbax.dbo.dbn_defi_mone dm
	WHERE	u.codi_pers	= i.codi_pers
	AND	u.corr_inst	= i.corr_inst
	AND	u.vers_inst	= i.vers_inst
	AND	u.codi_unit	= i.codi_unit
	AND	i.corr_conc	= i.corr_conc
	AND	d.codi_mone	= 'CLP'
	AND	d.codi_mone1	= 'CLF'
	AND	substring(u.desc_unit, charindex(':',u.desc_unit)+1,10) = dm.codi_mone
	AND	d.fech_camo = dbax.dbo.lastday(i.corr_inst)
	AND     exists (select 1 
			from dbax.dbo.dbax_defi_conc c 
			where c.pref_conc = i.pref_conc 
			and   c.codi_conc = i.codi_conc 
			and   c.tipo_valo = 'xbrli:monetaryItemType')

	UPDATE	ZZ_inst_conc
	SET	valo_inte = convert(varchar(5000),replace(convert(numeric(38,4),convert(numeric(38,14),CAST(LTRIM(RTRIM(replace(valo_cntx,',','.')))AS FLOAT)) / d.valo_camo),'.',','))
	FROM	ZZ_inst_conc i,
		dbax.dbo.dbax_inst_unit u,
		dbax.dbo.dbn_camb_mone d,
		dbax.dbo.dbn_defi_mone dm
	WHERE	u.codi_pers	= i.codi_pers
	AND	u.corr_inst	= i.corr_inst
	AND	u.vers_inst	= i.vers_inst
	AND	u.codi_unit	= i.codi_unit
	AND	i.corr_conc	= i.corr_conc
	AND	d.codi_mone	= 'CLP'
	AND	d.codi_mone1	= 'USD'
	AND	substring(u.desc_unit, charindex(':',u.desc_unit)+1,10) = dm.codi_mone
	AND	d.fech_camo = dbax.dbo.lastday(i.corr_inst)
	AND     exists (select 1 
			from dbax.dbo.dbax_defi_conc c 
			where c.pref_conc = i.pref_conc 
			and   c.codi_conc = i.codi_conc 
			and   c.tipo_valo = 'xbrli:monetaryItemType')

	UPDATE	ZZ_inst_conc
	SET	valo_refe = valo_cntx,
		valo_inte = valo_cntx
	FROM	ZZ_inst_conc i
	WHERE	exists (select 1 
			from dbax.dbo.dbax_defi_conc c 
			where c.pref_conc = i.pref_conc 
			and   c.codi_conc = i.codi_conc 
			and   c.tipo_valo != 'xbrli:monetaryItemType');
	
	select getdate(), 'Valores de Cambio Actualizados'

	exec prc_bi_dbax_Fact_Table;	

END
GO
