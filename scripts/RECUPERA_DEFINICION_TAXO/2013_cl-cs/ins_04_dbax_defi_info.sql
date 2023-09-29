declare @p_taxo varchar(16)
declare @p_pref varchar(16)
declare @p_anno varchar(16)

set @p_taxo = '%cl-cs%2013%'
set @p_pref = 'EEFF 2013 - '
set @p_anno = '2013'

insert into dbax_info_defi (codi_empr, codi_emex, codi_info, orde_info, indi_eeff,tipo_taxo)
select	1 codi_empr,
		1 codi_emex,
		codi_info, 
		@p_anno + '#' + orde_info,
		'S'		indi_eeff,
		CASE substring(codi_info, charindex('cl-', codi_info)+3 , 2)
		  WHEN 'ci' THEN 'COME_INDU' 
		  WHEN 'hb' THEN 'COME_INDU'
		  WHEN 'hs' THEN 'COME_INDU'
		  WHEN 'cs' THEN 'SEGUROS'
		  ELSE '-' 
		END	tipo_taxo
from  dbax_taxo_info 
where codi_info like @p_taxo
and   (	codi_info like '%110000%' or 
	codi_info like '%200000%' or 
	codi_info like '%300000%' or 
	codi_info like '%500000%')
		

insert into dbax_desc_info
select	1 codi_empr,
		1 codi_emex,
		codi_info, 
		'es_ES' codi_lang,
		@p_pref +
		CASE substring(codi_info, charindex('role-', codi_info)+5 , 6)
		  WHEN 110000 THEN 'Información General' 
		  WHEN 200000 THEN 'Balance Clasificado'  
		  WHEN 300000 THEN 'Estado de Resultados' 
		  WHEN 500000 THEN 'Flujo de Efectivos'
		  ELSE '-' 
		END +
		CASE substring(codi_info, charindex('cl-', codi_info)+3 , 2)
		  WHEN 'ci' THEN '' 
		  WHEN 'hb' THEN ' - Holding Bancario '
		  WHEN 'hs' THEN ' - Holding Seguros '
		  WHEN 'cs' THEN ' - Seguros '
		  ELSE '-' 
		END as desc_info
from  dbax_taxo_info 
where codi_info like @p_taxo
and   (	codi_info like '%110000%' or 
		codi_info like '%200000%' or 
		codi_info like '%300000%' or 
		codi_info like '%500000%')
		

insert into dbax_info_cntx (codi_emex, codi_empr, codi_info, codi_cntx, orde_cntx)
select  distinct c.codi_empr,
		c.codi_emex,
		d.codi_info, 
		c.codi_cntx,
		c.orde_cntx
from  dbax_info_cntx c,
      dbax_info_defi d
where  c.codi_info like '%2011%'
and   (c.codi_info like '%110000%' or 
	   c.codi_info like '%210000%' or 
	   c.codi_info like '%310000%' or 
	   c.codi_info like '%510000%')
and    d.codi_emex = c.codi_emex
and    d.codi_empr = c.codi_empr
and    d.codi_info  like @p_taxo
and    substring(d.codi_info, charindex('role-', d.codi_info)+5 , 1) = 
	   substring(c.codi_info, charindex('role-', c.codi_info)+5 , 1)
and    not exists (	select 1 from dbax_info_cntx c1
			where c1.codi_empr = c.codi_empr
			and   c1.codi_emex = c.codi_emex
			and   c1.codi_info = d.codi_info
			and   c1.codi_cntx = c.codi_cntx)