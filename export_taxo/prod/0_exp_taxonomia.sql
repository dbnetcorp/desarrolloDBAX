SET NOCOUNT ON;

declare @codi_taxo varchar(128)
declare @tipo_taxo varchar(128)
declare @sufi_info varchar(128)
set  @codi_taxo = 'svs-cl-ci-2017-01-03'
set  @tipo_taxo = 'COME_INDU'
set  @sufi_info = '(2017)'

declare @QRY_TAXO varchar(1024)
declare @QRY_INFO varchar(1024)
declare @QRY_CONC varchar(1024)
declare @QRY_ICNC varchar(1024)
declare @QRY_ICTX varchar(1024)
declare @QRY_DIME1 varchar(1024)
declare @QRY_DIME2 varchar(1024)
declare @QRY_DIME3 varchar(1024)
declare @QRY_DIME4 varchar(1024)
declare @QRY_DIME5 varchar(1024)
declare @QRY_DIME6 varchar(1024)

print ('
SET NOCOUNT ON;
DECLARE @dbax_conc_tita TABLE (
	[pref_conc] [varchar](50) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[codi_conc] [varchar](256) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[tipo_taxo] [varchar](10) COLLATE Modern_Spanish_CS_AS NOT NULL
	)
DECLARE @dbax_defi_conc TABLE (
	[pref_conc] [varchar](50) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[codi_conc] [varchar](256) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[tipo_conc] [varchar](20) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[tipo_peri] [varchar](15) COLLATE Modern_Spanish_CS_AS NULL,
	[tipo_valo] [varchar](256) COLLATE Modern_Spanish_CS_AS NULL,
	[tipo_cuen] [varchar](10) COLLATE Modern_Spanish_CS_AS NULL,
	[codi_nume] [varchar](25) COLLATE Modern_Spanish_CS_AS NULL
	)	
DECLARE @dbax_desc_conc TABLE (
	[pref_conc] [varchar](50) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[codi_conc] [varchar](256) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[codi_lang] [varchar](50) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[desc_conc] [varchar](512) COLLATE Modern_Spanish_CS_AS NOT NULL
	)
DECLARE @dbax_desc_info TABLE (
	[codi_empr] [numeric](9, 0) NOT NULL,
	[codi_emex] [varchar](30) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[codi_info] [varchar](50) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[codi_lang] [varchar](50) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[desc_info] [varchar](256) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[tipo_info] [varchar](2) COLLATE Modern_Spanish_CI_AS NOT NULL
	)
DECLARE @dbax_dime_axis TABLE (
	[codi_axis] [varchar](256) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[pref_axis] [varchar](20) COLLATE Modern_Spanish_CS_AS NOT NULL
	)
DECLARE @dbax_dime_cntx TABLE (
	[codi_fcdi] [varchar](20) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[diai_actu] [varchar](50) COLLATE Modern_Spanish_CS_AS NULL,
	[anoi_actu] [varchar](50) COLLATE Modern_Spanish_CS_AS NULL,
	[diat_actu] [varchar](50) COLLATE Modern_Spanish_CS_AS NULL,
	[anot_actu] [varchar](50) COLLATE Modern_Spanish_CS_AS NULL,
	[diai_ante] [varchar](50) COLLATE Modern_Spanish_CS_AS NULL,
	[anoi_ante] [varchar](50) COLLATE Modern_Spanish_CS_AS NULL,
	[diat_ante] [varchar](50) COLLATE Modern_Spanish_CS_AS NULL,
	[anot_ante] [varchar](50) COLLATE Modern_Spanish_CS_AS NULL
	)
DECLARE @dbax_dime_conc TABLE (
	[codi_dein] [varchar](50) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[codi_conc] [varchar](256) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[pref_conc] [varchar](20) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[orde_conc] [numeric](5, 0) NOT NULL,
	[codi_dime] [varchar](256) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[pref_dime] [varchar](20) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[sald_ini] [varchar](5) COLLATE Modern_Spanish_CS_AS NULL,
	[negr_conc] [varchar](10) COLLATE Modern_Spanish_CS_AS NULL
	)
DECLARE @dbax_dime_defi TABLE (
	[codi_dein] [varchar](50) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[codi_dime] [varchar](256) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[pref_dime] [varchar](20) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[codi_fcdi] [varchar](20) COLLATE Modern_Spanish_CS_AS NULL,
	[letr_dime] [varchar](1) COLLATE Modern_Spanish_CS_AS NULL,
	[role_uri] [varchar](256) COLLATE Modern_Spanish_CS_AS NULL,
	[dime_tran] [varchar](1) COLLATE Modern_Spanish_CS_AS NULL
	)
DECLARE @dbax_dime_diax TABLE (
	[codi_dime] [varchar](256) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[pref_dime] [varchar](20) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[codi_axis] [varchar](256) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[pref_axis] [varchar](20) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[orde_axis] [numeric](1, 0) NOT NULL,
	[codi_dein] [varchar](50) COLLATE Modern_Spanish_CS_AS NOT NULL
	)
DECLARE @dbax_dime_memb TABLE (
	[codi_axis] [varchar](256) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[pref_axis] [varchar](20) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[codi_memb] [varchar](256) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[pref_memb] [varchar](20) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[orde_memb] [int] NULL,
	[tipo_memb] [varchar](256) COLLATE Modern_Spanish_CS_AS NULL
	)
DECLARE @dbax_dime_tita TABLE (
	[codi_dein] [varchar](50) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[codi_dime] [varchar](256) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[pref_dime] [varchar](20) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[tipo_taxo] [varchar](10) COLLATE Modern_Spanish_CS_AS NOT NULL
	)

DECLARE @dbax_info_cntx TABLE (
	[codi_empr] [numeric](9, 0) NOT NULL,
	[codi_emex] [varchar](30) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[codi_info] [varchar](50) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[codi_cntx] [varchar](50) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[orde_cntx] [int] NULL,
	[tipo_info] [varchar](2) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[emex_cntx] [varchar](30) COLLATE Modern_Spanish_CS_AS NULL,
	[empr_cntx] [numeric](9, 0) NULL
	)

DECLARE @dbax_info_conc TABLE (
	[codi_empr] [numeric](9, 0) NOT NULL,
	[codi_emex] [varchar](30) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[codi_info] [varchar](50) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[pref_conc] [varchar](50) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[codi_conc] [varchar](256) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[orde_conc] [numeric](5, 0) NOT NULL,
	[codi_conc1] [varchar](256) COLLATE Modern_Spanish_CS_AS NULL,
	[nive_conc] [numeric](5, 0) NULL,
	[negr_conc] [varchar](10) COLLATE Modern_Spanish_CS_AS NULL,
	[tipo_info] [varchar](2) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[conc_sini] [varchar](1) COLLATE Modern_Spanish_CS_AS NULL
	)

DECLARE @dbax_info_defi TABLE (
	[codi_empr] [numeric](9, 0) NOT NULL,
	[codi_emex] [varchar](30) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[codi_info] [varchar](50) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[orde_info] [varchar](50) COLLATE Modern_Spanish_CS_AS NULL,
	[indi_eeff] [varchar](1) COLLATE Modern_Spanish_CS_AS NULL,
	[indi_situ] [varchar](1) COLLATE Modern_Spanish_CS_AS NULL,
	[indi_resu] [varchar](1) COLLATE Modern_Spanish_CS_AS NULL,
	[indi_fluj] [varchar](1) COLLATE Modern_Spanish_CS_AS NULL,
	[indi_patr] [varchar](1) COLLATE Modern_Spanish_CS_AS NULL,
	[indi_inte] [varchar](1) COLLATE Modern_Spanish_CS_AS NULL,
	[tipo_xml] [varchar](1) COLLATE Modern_Spanish_CS_AS NULL,
	[sche_info] [varchar](256) COLLATE Modern_Spanish_CS_AS NULL,
	[info_taxo] [varchar](1) COLLATE Modern_Spanish_CS_AS NULL,
	[indi_vige] [varchar](1) COLLATE Modern_Spanish_CS_AS NULL,
	[tipo_info] [varchar](2) COLLATE Modern_Spanish_CI_AS NOT NULL
	)

DECLARE @dbax_info_tita TABLE (
	[codi_empr] [numeric](9, 0) NOT NULL,
	[codi_emex] [varchar](30) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[codi_info] [varchar](50) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[tipo_info] [varchar](2) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[tipo_taxo] [varchar](10) COLLATE Modern_Spanish_CS_AS NOT NULL)

DECLARE @dbax_taxo_conc TABLE (
	[pref_conc] [varchar](50) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[codi_conc] [varchar](256) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[vers_taxo] [varchar](256) COLLATE Modern_Spanish_CS_AS NOT NULL)

DECLARE @dbax_taxo_info TABLE (
	[codi_info] [varchar](50) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[desc_info] [varchar](256) COLLATE Modern_Spanish_CS_AS NULL,
	[orde_info] [varchar](50) COLLATE Modern_Spanish_CS_AS NULL,
	[sche_info] [varchar](256) COLLATE Modern_Spanish_CS_AS NULL,
	[sche_info2] [varchar](256) COLLATE Modern_Spanish_CS_AS NULL)

DECLARE @dbax_taxo_vers TABLE (
	[vers_taxo] [varchar](256) COLLATE Modern_Spanish_CS_AS NOT NULL,
	[ubic_taxo] [varchar](256) COLLATE Modern_Spanish_CS_AS NULL,
	[tipo_taxo] [varchar](10) COLLATE Modern_Spanish_CS_AS NULL,
	[desc_taxo] [varchar](256) COLLATE Modern_Spanish_CS_AS NULL)
')

SET  @QRY_TAXO = 'INSERT INTO ' + char(64) + 'DBAX_TAXO_VERS (VERS_TAXO, UBIC_TAXO, TIPO_TAXO, DESC_TAXO) VALUES (''#VERS_TAXO'',''#UBIC_TAXO'',''#TIPO_TAXO'',''#DESC_TAXO'')'

SET  @QRY_INFO = 'INSERT INTO ' + char(64) + 'DBAX_INFO_DEFI (CODI_EMPR, CODI_EMEX, CODI_INFO, ORDE_INFO, INDI_EEFF, INDI_SITU, INDI_RESU, INDI_FLUJ, INDI_PATR, INDI_INTE, TIPO_XML, SCHE_INFO, INFO_TAXO, INDI_VIGE, TIPO_INFO) VALUES (''0'', ''0'', ''#CODI_INFO' + @sufi_info + ''', ''#ORDE_INFO'', ''#INDI_EEFF'', ''#INDI_SITU'', ''#INDI_RESU'', ''#INDI_FLUJ'', ''#INDI_PATR'', ''#INDI_INTE'', ''#TIPO_XML'', ''#SCHE_INFO'', ''S'', 1, ''#TIPO_INFO'')' + CHAR(10) +
		 'INSERT INTO ' + char(64) + 'DBAX_TAXO_INFO (CODI_INFO, DESC_INFO, ORDE_INFO, SCHE_INFO, SCHE_INFO2) VALUES (''#CODI_INFO' + @sufi_info + ''',''#DESC_INFO'',''#ORDE_INFO'',''#SCHE_INFO'',NULL)' + CHAR(10) +
		 'INSERT INTO ' + char(64) + 'DBAX_DESC_INFO (CODI_EMPR, CODI_EMEX, CODI_INFO, CODI_LANG, DESC_INFO, TIPO_INFO) VALUES (0, 0,''#CODI_INFO' + @sufi_info + ''',''es_ES'',''#DESC_INFO'',''#TIPO_INFO'')' + CHAR(10) +
		 'INSERT INTO ' + char(64) + 'DBAX_INFO_TITA (CODI_EMPR,CODI_EMEX, CODI_INFO, TIPO_INFO, TIPO_TAXO) VALUES (0, 0,''#CODI_INFO' + @sufi_info + ''',''#TIPO_INFO'',''#TIPO_TAXO'')'

SET  @QRY_CONC = 'INSERT INTO ' + char(64) + 'DBAX_DEFI_CONC (PREF_CONC, CODI_CONC, TIPO_CONC, TIPO_PERI, TIPO_VALO, TIPO_CUEN) VALUES (''#PREF_CONC'',''#CODI_CONC'',''#TIPO_CONC'',''#TIPO_PERI'',''#TIPO_VALO'',''#TIPO_CUEN'')' + CHAR(10) +
		 'INSERT INTO ' + char(64) + 'DBAX_DESC_CONC (PREF_CONC, CODI_CONC, CODI_LANG, DESC_CONC) VALUES (''#PREF_CONC'',''#CODI_CONC'',''es_ES'',''#DESC_CONC'')' + CHAR(10) +
		 'INSERT INTO ' + char(64) + 'DBAX_TAXO_CONC (PREF_CONC, CODI_CONC, VERS_TAXO) VALUES (''#PREF_CONC'',''#CODI_CONC'',''#VERS_TAXO'')'

SET  @QRY_ICNC = 'INSERT INTO ' + char(64) + 'DBAX_INFO_CONC (CODI_EMPR, CODI_EMEX, CODI_INFO, PREF_CONC, CODI_CONC, ORDE_CONC, NIVE_CONC, TIPO_INFO) VALUES (0, 0, ''#CODI_INFO' + @sufi_info + ''', ''#PREF_CONC'', ''#CODI_CONC'', #ORDE_CONC, #NIVE_CONC, ''#TIPO_INFO'')'

SET  @QRY_ICTX = 'INSERT INTO ' + char(64) + 'DBAX_INFO_CNTX (CODI_EMPR, CODI_EMEX, CODI_INFO, CODI_CNTX, ORDE_CNTX, TIPO_INFO, EMEX_CNTX, EMPR_CNTX) VALUES (0, 0, ''#CODI_INFO' + @sufi_info + ''', ''#CODI_CNTX'', #POSI_VALO, ''#TIPO_INFO'', 0, 0)'

SET  @QRY_DIME1 = 'INSERT INTO ' + char(64) + 'DBAX_DIME_DEFI (CODI_DEIN, PREF_DIME, CODI_DIME, LETR_DIME, ROLE_URI) VALUES (''#CODI_INFO' + @sufi_info + ''',''#PREF_DIME'',''#CODI_DIME'',''#LETR_DIME'',''#ROLE_URI'')'
SET  @QRY_DIME2 = 'INSERT INTO ' + char(64) + 'DBAX_DIME_DIAX (PREF_DIME, CODI_DIME, PREF_AXIS, CODI_AXIS, ORDE_AXIS, CODI_DEIN) VALUES (''#PREF_DIME'',''#CODI_DIME'',''#PREF_AXIS'',''#CODI_AXIS'', #ORDE_AXIS,''#CODI_INFO' + @sufi_info + ''')'
SET  @QRY_DIME3 = 'INSERT INTO ' + char(64) + 'DBAX_DIME_MEMB (PREF_AXIS, CODI_AXIS, PREF_MEMB, CODI_MEMB, ORDE_MEMB, TIPO_MEMB) VALUES (''#PREF_AXIS'',''#CODI_AXIS'',''#PREF_MEMB'',''#CODI_MEMB'',#ORDE_MEMB,''#TIPO_MEMB'')'
SET  @QRY_DIME4 = 'INSERT INTO ' + char(64) + 'DBAX_DIME_CONC (CODI_DEIN, PREF_CONC, CODI_CONC, ORDE_CONC, PREF_DIME, CODI_DIME) VALUES (''#CODI_INFO' + @sufi_info + ''',''#PREF_CONC'',''#CODI_CONC'',''#ORDE_CONC'',''#PREF_DIME'',''#CODI_DIME'')'
SET  @QRY_DIME5 = 'INSERT INTO ' + char(64) + 'DBAX_DIME_TITA (CODI_DEIN, PREF_DIME, CODI_DIME, TIPO_TAXO) VALUES (''#CODI_INFO' + @sufi_info + ''',''#PREF_DIME'',''#CODI_DIME'',''#TIPO_TAXO'')'
SET  @QRY_DIME6 = 'INSERT INTO ' + char(64) + 'DBAX_DIME_AXIS (PREF_AXIS, CODI_AXIS) VALUES (''#PREF_AXIS'',''#CODI_AXIS'')'


-- Inserción Taxonomía
select replace(replace(replace(replace(@qry_taxo,  
		'#VERS_TAXO', vers_taxo),  
		'#UBIC_TAXO', ubic_taxo),  
		'#TIPO_TAXO', @tipo_taxo),  
		'#DESC_TAXO', vers_taxo) 
from   xbrl_taxo_vers 
where  vers_taxo = @codi_taxo

-- Inserción informes normales
select	replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(@qry_info,  
		'#CODI_INFO', di.codi_info),  
		'#DESC_INFO', di.desc_info),  
		'#ORDE_INFO', di.orde_info),  
		'#TIPO_TAXO', @tipo_taxo),
		'#INDI_EEFF', isnull(di.INDI_EEFF,'')),  
		'#INDI_SITU', isnull(di.INDI_SITU,'')),  
		'#INDI_RESU', isnull(di.INDI_RESU,'')),  
		'#INDI_FLUJ', isnull(di.INDI_FLUJ,'')),  
		'#INDI_PATR', isnull(di.INDI_PATR,'')),  
		'#INDI_INTE', isnull(di.INDI_INTE,'')),  
		'#TIPO_XML', isnull(di.TIPO_XML,'')),  
		'#SCHE_INFO', isnull(ti.SCHE_INFO,'')),  
		'#TIPO_INFO', 'C') 
from   xbrl_taxo_info ti, 
       xbrl_info_defi di
where ti.vers_taxo = @codi_taxo
and   ti.codi_info = di.codi_info
order by orde_info

-- Inserción informes de dimension
select	replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(@qry_info,  
		'#CODI_INFO', di.codi_info),  
		'#DESC_INFO', di.desc_info),  
		'#ORDE_INFO', di.orde_info),  
		'#TIPO_TAXO', @tipo_taxo),
		'#INDI_EEFF', isnull(di.INDI_EEFF,'')),  
		'#INDI_SITU', isnull(di.INDI_SITU,'')),  
		'#INDI_RESU', isnull(di.INDI_RESU,'')),  
		'#INDI_FLUJ', isnull(di.INDI_FLUJ,'')),  
		'#INDI_PATR', isnull(di.INDI_PATR,'')),  
		'#INDI_INTE', isnull(di.INDI_INTE,'')),  
		'#TIPO_XML', isnull(di.TIPO_XML,'')),  
		'#SCHE_INFO', isnull(ti.SCHE_INFO,'')),  
		'#TIPO_INFO', 'D') 
from   xbrl_taxo_info ti, 
       xbrl_info_defi di,
       xbrl_dime_defi dd
where ti.vers_taxo = @codi_taxo
and   ti.codi_info = di.codi_info
and   ti.codi_info = dd.codi_info
order by orde_info

-- Inserción Conceptos
select	replace(replace(replace(replace(replace(replace(replace(replace(@qry_conc,  
		'#PREF_CONC', pref_conc),  
		'#CODI_CONC', codi_conc),  
		'#DESC_CONC', desc_conc),  
		'#VERS_TAXO', vers_taxo),
		'#TIPO_CONC', isnull(tipo_conc,'')),  
		'#TIPO_PERI', isnull(tipo_peri,'')),  
		'#TIPO_VALO', isnull(tipo_valo,'')),  
		'#TIPO_CUEN', isnull(tipo_cuen,'')) 
from (select distinct 
			ic.codi_conc codi_conc_orig, 
			substring(codi_conc_, 1, charindex('_',codi_conc_)-1)		pref_conc,
			substring(codi_conc_, charindex('_',codi_conc_)+1, 1024)	codi_conc,
			case dc.tipo_conc when 'xbrli:item' then 'concepto'  
							  when 'xbrldt:dimensionItem' then 'dimension'
							  when 'xbrldt:hypercubeItem' then 'hipercubo'
							  else dc.tipo_conc
			end tipo_conc,
			dc.desc_conc,
			dc.tipo_peri, 
			dc.tipo_valo, 
			dc.tipo_cuen,
			ti.vers_taxo
		from	(select substring(codi_conc, charindex('#',codi_conc)+1, 1024) codi_conc_,* from xbrl_defi_conc) dc, 
				xbrl_info_conc ic,
				xbrl_taxo_info ti
		where ti.vers_taxo = @codi_taxo
		and   ic.codi_info = ti.codi_info
		and   dc.codi_conc = ic.codi_conc) as t
order by 1

-- Inserción Conceptos de informe
select	replace(replace(replace(replace(replace(replace(@QRY_ICNC,  
		'#CODI_INFO', codi_info),  
		'#PREF_CONC', pref_conc),  
		'#CODI_CONC', codi_conc),  
		'#ORDE_CONC', orde_conc),  
		'#NIVE_CONC', nive_conc),
		'#TIPO_INFO', 'C') 
from (select	codi_info, 
				substring(codi_conc_, 1, charindex('_',codi_conc_)-1)		pref_conc,
				substring(codi_conc_, charindex('_',codi_conc_)+1, 1024)	codi_conc,
				orde_conc, 
				nive_conc
from (select substring(codi_conc, charindex('#',codi_conc)+1, 1024) codi_conc_,* from xbrl_info_conc) ic
where exists (select 1 from xbrl_taxo_info ti where ti.vers_taxo = @codi_taxo and ti.codi_info = ic.codi_info)) v
order by codi_info

-- Inserción Contextos de informe
select	replace(replace(replace(replace(@QRY_ICTX,  
		'#CODI_INFO', codi_info),  
		'#CODI_CNTX', codi_cntx),  
		'#POSI_VALO', posi_valo),
		'#TIPO_INFO', 'C') 
from xbrl_info_cntx ic
where exists (select 1 from xbrl_taxo_info ti where ti.vers_taxo = @codi_taxo and ti.codi_info = ic.codi_info)
order by codi_info, posi_valo

-- Inserción Dimension 1
select	replace(replace(replace(replace(replace(@QRY_DIME1,  
		'#CODI_INFO', codi_info),  
		'#PREF_DIME', pref_dime),  
		'#CODI_DIME', codi_dime),  
		'#LETR_DIME', isnull(letr_dime,'')),
		'#ROLE_URI',  isnull(role_uri,''))
from    (select	dd.codi_info, 
				substring(codi_dime_, 1, charindex('_',codi_dime_)-1)		pref_dime,
				substring(codi_dime_, charindex('_',codi_dime_)+1, 1024)	codi_dime,
				dd.letr_dime,
				dl.role_uri
		 from  (select substring(codi_dime, charindex('#',codi_dime)+1, 1024) codi_dime_,* from xbrl_dime_defi) dd
		 		left join xbrl_dime_link dl on dl.codi_info = dd.codi_info
		 					and    dl.codi_dime = dd.codi_dime
		 					and    dl.vers_taxo = @codi_taxo
		 where exists (select 1 from xbrl_taxo_info ti where ti.vers_taxo = @codi_taxo and ti.codi_info = dd.codi_info)
		 ) v

-- Inserción Dimension 2
select  replace(replace(replace(replace(replace(replace(@QRY_DIME2,  
		'#CODI_INFO', codi_info),  
		'#PREF_DIME', pref_dime),  
		'#CODI_DIME', codi_dime),  
		'#PREF_AXIS', pref_axis),  
		'#CODI_AXIS', codi_axis),  
		'#ORDE_AXIS', orde_axis)
from    (select codi_info,
				orde_axis,
				substring(codi_dime_, 1, charindex('_',codi_dime_)-1)		pref_dime,
				substring(codi_dime_, charindex('_',codi_dime_)+1, 1024)	codi_dime,
				substring(codi_axis_, 1, charindex('_',codi_axis_)-1)		pref_axis,
				substring(codi_axis_, charindex('_',codi_axis_)+1, 1024)	codi_axis
		 from   (select substring(codi_dime, charindex('#',codi_dime)+1, 1024) codi_dime_,substring(codi_axis, charindex('#',codi_axis)+1, 1024) codi_axis_,* from xbrl_dime_diax) dd
		 where exists (select 1 from xbrl_taxo_info ti where ti.vers_taxo = @codi_taxo and ti.codi_info = dd.codi_info)) v
order by codi_info, codi_dime, orde_axis

-- Inserción Dimension 3
select  replace(replace(replace(replace(replace(replace(@QRY_DIME3,  
		'#PREF_MEMB', pref_memb),  
		'#CODI_MEMB', codi_memb),  
		'#PREF_AXIS', pref_axis),  
		'#CODI_AXIS', codi_axis),  
		'#ORDE_MEMB', isnull(orde_memb,'')),  
		'#TIPO_MEMB', isnull(tipo_memb,''))
from    (select codi_info,
				substring(codi_memb_, 1, charindex('_',codi_memb_)-1)		pref_memb,
				substring(codi_memb_, charindex('_',codi_memb_)+1, 1024)	codi_memb,
				substring(codi_axis_, 1, charindex('_',codi_axis_)-1)		pref_axis,
				substring(codi_axis_, charindex('_',codi_axis_)+1, 1024)	codi_axis,
				tipo_memb,
				orde_memb		 
		 from   (select substring(codi_axis, charindex('#',codi_axis)+1, 1024) codi_axis_,substring(codi_memb, charindex('#',codi_memb)+1, 1024) codi_memb_, * from xbrl_dime_memb) dm
		 where exists (select 1 from xbrl_taxo_info ti where ti.vers_taxo = @codi_taxo and ti.codi_info = dm.codi_info)) v
order by codi_info, codi_memb, orde_memb

-- Inserción Dimension 4
select  replace(replace(replace(replace(replace(replace(@QRY_DIME4,  
		'#PREF_DIME', pref_dime),
		'#CODI_DIME', codi_dime),
		'#PREF_CONC', pref_conc),
		'#CODI_CONC', codi_conc),
		'#ORDE_CONC', isnull(orde_conc,'')),  
		'#CODI_INFO', isnull(codi_info,''))
from    (select dd.codi_info,
				substring(codi_dime_, 1, charindex('_',codi_dime_)-1)		pref_dime,
				substring(codi_dime_, charindex('_',codi_dime_)+1, 1024)	codi_dime,
				substring(codi_conc_, 1, charindex('_',codi_conc_)-1)		pref_conc,
				substring(codi_conc_, charindex('_',codi_conc_)+1, 1024)	codi_conc,
				orde_conc
		 from   (select substring(codi_dime, charindex('#',codi_dime)+1, 1024) codi_dime_,* from xbrl_dime_defi) dd,
				(select substring(codi_conc, charindex('#',codi_conc)+1, 1024) codi_conc_,* from xbrl_info_conc) ic
		 where  dd.codi_info = ic.codi_info	
		 and	exists (select 1 from xbrl_taxo_info ti where ti.vers_taxo = @codi_taxo and ti.codi_info = dd.codi_info) 
		 and	dd.orde_conc1 <= ic.orde_conc
		 and dd.orde_conc2 >= ic.orde_conc
		) v
order by codi_info, codi_dime, orde_conc	

-- Inserción Dimension 5
select  replace(replace(replace(replace(@QRY_DIME5,
		'#PREF_DIME', pref_dime),
		'#CODI_DIME', codi_dime),
		'#CODI_INFO', codi_info),
		'#TIPO_TAXO', @tipo_taxo)
from    (select dd.codi_info,
				substring(codi_dime_, 1, charindex('_',codi_dime_)-1)		pref_dime,
				substring(codi_dime_, charindex('_',codi_dime_)+1, 1024)	codi_dime
		 from   (select substring(codi_dime, charindex('#',codi_dime)+1, 1024) codi_dime_,* from xbrl_dime_defi) dd
		 where  exists (select 1 from xbrl_taxo_info ti where ti.vers_taxo = @codi_taxo and ti.codi_info = dd.codi_info)
		) v

-- Inserción Dimension 6
select  replace(replace(@QRY_DIME6,  
		'#PREF_AXIS', pref_axis),  
		'#CODI_AXIS', codi_axis)
from    (select substring(codi_axis_, 1, charindex('_',codi_axis_)-1)		pref_axis,
				substring(codi_axis_, charindex('_',codi_axis_)+1, 1024)	codi_axis
		 from   (select substring(codi_axis, charindex('#',codi_axis)+1, 1024) codi_axis_,* from xbrl_dime_axis) dd) v

PRINT('		
INSERT INTO DBAX_TAXO_VERS SELECT * FROM @DBAX_TAXO_VERS T WHERE NOT EXISTS (SELECT 1 FROM DBAX_TAXO_VERS V WHERE T.VERS_TAXO = V.VERS_TAXO)

INSERT INTO DBAX_INFO_DEFI SELECT DISTINCT * FROM @DBAX_INFO_DEFI T WHERE NOT EXISTS (SELECT 1 FROM DBAX_INFO_DEFI V WHERE T.CODI_EMEX = V.CODI_EMEX AND T.CODI_EMPR = V.CODI_EMPR AND T.CODI_INFO = V.CODI_INFO AND T.TIPO_INFO = V.TIPO_INFO)
INSERT INTO DBAX_TAXO_INFO SELECT DISTINCT * FROM @DBAX_TAXO_INFO T WHERE NOT EXISTS (SELECT 1 FROM DBAX_TAXO_INFO V WHERE T.CODI_INFO = V.CODI_INFO)
INSERT INTO DBAX_DESC_INFO SELECT DISTINCT * FROM @DBAX_DESC_INFO T WHERE NOT EXISTS (SELECT 1 FROM DBAX_DESC_INFO V WHERE T.CODI_EMEX = V.CODI_EMEX AND T.CODI_EMPR = V.CODI_EMPR AND T.CODI_INFO = V.CODI_INFO AND T.TIPO_INFO = V.TIPO_INFO)
INSERT INTO DBAX_INFO_TITA SELECT DISTINCT * FROM @DBAX_INFO_TITA T WHERE NOT EXISTS (SELECT 1 FROM DBAX_INFO_TITA V WHERE T.CODI_EMEX = V.CODI_EMEX AND T.CODI_EMPR = V.CODI_EMPR AND T.CODI_INFO = V.CODI_INFO AND T.TIPO_INFO = V.TIPO_INFO AND T.TIPO_TAXO = V.TIPO_TAXO)

INSERT INTO DBAX_DEFI_CONC SELECT DISTINCT * FROM @DBAX_DEFI_CONC T WHERE NOT EXISTS (SELECT 1 FROM DBAX_DEFI_CONC V WHERE T.PREF_CONC = V.PREF_CONC AND T.CODI_CONC = V.CODI_CONC)
INSERT INTO DBAX_DESC_CONC SELECT DISTINCT * FROM @DBAX_DESC_CONC T WHERE NOT EXISTS (SELECT 1 FROM DBAX_DESC_CONC V WHERE T.PREF_CONC = V.PREF_CONC AND T.CODI_CONC = V.CODI_CONC AND T.CODI_LANG = V.CODI_LANG)
INSERT INTO DBAX_TAXO_CONC SELECT DISTINCT * FROM @DBAX_TAXO_CONC T WHERE NOT EXISTS (SELECT 1 FROM DBAX_TAXO_CONC V WHERE T.PREF_CONC = V.PREF_CONC AND T.CODI_CONC = V.CODI_CONC AND T.VERS_TAXO = V.VERS_TAXO)

INSERT INTO DBAX_INFO_CONC SELECT * FROM @DBAX_INFO_CONC T WHERE NOT EXISTS (SELECT 1 FROM DBAX_INFO_CONC V WHERE T.CODI_EMEX = V.CODI_EMEX AND T.CODI_EMPR = V.CODI_EMPR AND T.CODI_INFO = V.CODI_INFO AND T.PREF_CONC = V.PREF_CONC AND T.CODI_CONC = V.CODI_CONC)
INSERT INTO DBAX_INFO_CNTX SELECT * FROM @DBAX_INFO_CNTX T WHERE NOT EXISTS (SELECT 1 FROM DBAX_INFO_CNTX V WHERE T.CODI_EMEX = V.CODI_EMEX AND T.CODI_EMPR = V.CODI_EMPR AND T.CODI_INFO = V.CODI_INFO AND T.CODI_CNTX = V.CODI_CNTX) AND EXISTS (SELECT 1 FROM DBAX_DEFI_CNTX V WHERE T.CODI_EMEX = V.CODI_EMEX AND T.CODI_EMPR = V.CODI_EMPR AND T.CODI_CNTX = V.CODI_CNTX)

INSERT INTO DBAX_DIME_DEFI SELECT * FROM @DBAX_DIME_DEFI T WHERE NOT EXISTS (SELECT 1 FROM DBAX_DIME_DEFI V WHERE T.CODI_DEIN = V.CODI_DEIN AND T.PREF_DIME = V.PREF_DIME AND T.CODI_DIME = V.CODI_DIME)
INSERT INTO DBAX_DIME_AXIS SELECT * FROM @DBAX_DIME_AXIS T WHERE NOT EXISTS (SELECT 1 FROM DBAX_DIME_AXIS V WHERE T.PREF_AXIS = V.PREF_AXIS AND T.CODI_AXIS = V.CODI_AXIS)
INSERT INTO DBAX_DIME_DIAX SELECT * FROM @DBAX_DIME_DIAX T WHERE NOT EXISTS (SELECT 1 FROM DBAX_DIME_DIAX V WHERE T.PREF_DIME = V.PREF_DIME AND T.CODI_DIME = V.CODI_DIME AND T.PREF_AXIS = V.PREF_AXIS AND T.CODI_AXIS = V.CODI_AXIS)
INSERT INTO DBAX_DIME_MEMB SELECT * FROM @DBAX_DIME_MEMB T WHERE NOT EXISTS (SELECT 1 FROM DBAX_DIME_MEMB V WHERE T.PREF_AXIS = V.PREF_AXIS AND T.CODI_AXIS = V.CODI_AXIS AND T.PREF_MEMB = V.PREF_MEMB AND T.CODI_MEMB = V.CODI_MEMB)
INSERT INTO DBAX_DIME_CONC SELECT * FROM @DBAX_DIME_CONC T WHERE NOT EXISTS (SELECT 1 FROM DBAX_DIME_CONC V WHERE T.CODI_DEIN = V.CODI_DEIN AND T.PREF_DIME = V.PREF_DIME AND T.CODI_DIME = V.CODI_DIME AND T.PREF_CONC = V.PREF_CONC AND T.CODI_CONC = V.CODI_CONC)
INSERT INTO DBAX_DIME_TITA SELECT * FROM @DBAX_DIME_TITA T WHERE NOT EXISTS (SELECT 1 FROM DBAX_DIME_TITA V WHERE T.CODI_DEIN = V.CODI_DEIN AND T.PREF_DIME = V.PREF_DIME AND T.CODI_DIME = V.CODI_DIME)

SELECT ''' + @CODI_TAXO + ''' taxo,''DBAX_TAXO_VERS'' tabla, COUNT(*) cnt FROM DBAX_TAXO_VERS WHERE VERS_TAXO = ''' + @CODI_TAXO + '''
SELECT ''' + @CODI_TAXO + ''' taxo,''DBAX_INFO_DEFI'' tabla, COUNT(*) cnt FROM DBAX_INFO_DEFI WHERE CODI_INFO LIKE ''%' + @SUFI_INFO + '%''
SELECT ''' + @CODI_TAXO + ''' taxo,''DBAX_INFO_CNTX'' tabla, COUNT(*) cnt FROM DBAX_INFO_CNTX WHERE CODI_INFO LIKE ''%' + @SUFI_INFO + '%''
SELECT ''' + @CODI_TAXO + ''' taxo,''DBAX_DIME_DEFI'' tabla, COUNT(*) cnt FROM DBAX_DIME_DEFI WHERE CODI_DEIN LIKE ''%' + @SUFI_INFO + '%''
')
