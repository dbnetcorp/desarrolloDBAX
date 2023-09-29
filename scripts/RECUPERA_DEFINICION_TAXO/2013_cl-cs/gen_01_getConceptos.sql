select 'insert into dbax_defi_conc (pref_conc,codi_conc,tipo_conc,tipo_peri,tipo_valo,tipo_cuen,tipo_taxo) values ('
		+ '''' + pref_conc + ''',''' + codi_conc + ''',''' + tipo_conc + ''',''' + tipo_peri + ''',''' + tipo_valo + ''',''' + tipo_cuen + ''',''SEGUROS'''
	   + ')'
from (
select  substring(codi_conc, 1, charindex('_',codi_conc) - 1) pref_conc, 
		substring(codi_conc, charindex('_',codi_conc) + 1, 100) codi_conc, 
		tipo_conc,
		tipo_peri,
		tipo_valo,
		tipo_cuen
from   (select	substring(codi_conc, charindex('#',codi_conc) + 1, 100) codi_conc, 
				desc_conc,
				replace(replace(replace(
				tipo_conc,
				'xbrli:item','concepto'),
				'xbrldt:dimensionItem', 'dimension'),
				'xbrldt:hypercubeItem', 'hipercubo') tipo_conc,
				tipo_peri,
				tipo_cuen,
				tipo_valo
		from    xbrl_defi_conc 
		where   xsd_conc like 'cl-cs_cor_2013-01-31.xsd') tmp1) tmp2
		
		
select 'insert into dbax_desc_conc (pref_conc,codi_conc,codi_lang,desc_conc) values ('
		+ '''' + pref_conc + ''',''' + codi_conc + ''',''es_ES'',''' + desc_conc + ''''
	   + ')'
from (
select  substring(codi_conc, 1, charindex('_',codi_conc) - 1) pref_conc, 
		substring(codi_conc, charindex('_',codi_conc) + 1, 100) codi_conc, 
		desc_conc
from   (select	substring(codi_conc, charindex('#',codi_conc) + 1, 100) codi_conc, 
				desc_conc,
				replace(replace(replace(
				tipo_conc,
				'xbrli:item','concepto'),
				'xbrldt:dimensionItem', 'dimension'),
				'xbrldt:hypercubeItem', 'hipercubo') tipo_conc,
				tipo_peri,
				tipo_cuen,
				tipo_valo
		from    xbrl_defi_conc 
		where   xsd_conc like 'cl-cs_cor_2013-01-31.xsd') tmp1) tmp2		