select 'insert into dbax_defi_conc (pref_conc,codi_conc,tipo_conc,tipo_peri,tipo_valo,tipo_cuen,tipo_taxo) values ('
		+ '''' + pref_conc + ''',''' + codi_conc + ''',''' + tipo_conc + ''',''' + tipo_peri + ''',''' + tipo_valo + ''',''' + tipo_cuen + ''',''COME_INDU'''
	   + ')'
from (
select  substring(codi_conc, 1, charindex('_',codi_conc) - 1) pref_conc, 
		substring(codi_conc, charindex('_',codi_conc) + 1, 256) codi_conc, 
		tipo_conc,
		tipo_peri,
		tipo_valo,
		tipo_cuen
from   (select	distinct substring(ic.codi_conc,charindex('#',ic.codi_conc)+1,1000) codi_conc,
				dc.desc_conc,
				replace(replace(replace(
				dc.tipo_conc,
				'xbrli:item','concepto'),
				'xbrldt:dimensionItem', 'dimension'),
				'xbrldt:hypercubeItem', 'hipercubo') tipo_conc,
				dc.tipo_peri,
				dc.tipo_cuen,
				dc.tipo_valo
		from	xbrl_taxo_info ti,
				xbrl_info_conc ic,
				xbrl_defi_conc dc
		where	ti.vers_taxo in ('cl-hb-2011-04-26',
								'cl-hb-2012-03-23',
								'cl-hb-2013-01-31',
								'cl-hb-2013-07-15',
								'cl-hs-2011-04-26',
								'cl-hs-2012-03-23',
								'cl-hs-2013-01-31',
								'cl-hs-2013-07-15',
								'svs-cl-ci-2010-05-15',
								'svs-cl-ci-2011-04-26',
								'svs-cl-ci-2012-03-21',
								'svs-cl-ci-2013-01-31',
								'svs-cl-ci-2013-07-15')
		and		ti.codi_info = ic.codi_info
		and		ic.codi_conc = dc.codi_conc) tmp1) tmp2
		
select 'insert into dbax_desc_conc (pref_conc,codi_conc,codi_lang,desc_conc) values ('
		+ '''' + pref_conc + ''',''' + codi_conc + ''',''es_ES'',''' + desc_conc + ''''
	   + ')'
from (
select  substring(codi_conc, 1, charindex('_',codi_conc) - 1) pref_conc, 
		substring(codi_conc, charindex('_',codi_conc) + 1, 256) codi_conc, 
		desc_conc
from   (select	distinct substring(ic.codi_conc,charindex('#',ic.codi_conc)+1,1000) codi_conc,
				dc.desc_conc,
				replace(replace(replace(
				dc.tipo_conc,
				'xbrli:item','concepto'),
				'xbrldt:dimensionItem', 'dimension'),
				'xbrldt:hypercubeItem', 'hipercubo') tipo_conc,
				dc.tipo_peri,
				dc.tipo_cuen,
				dc.tipo_valo
		from	xbrl_taxo_info ti,
				xbrl_info_conc ic,
				xbrl_defi_conc dc
		where	ti.vers_taxo in ('cl-hb-2011-04-26',
								'cl-hb-2012-03-23',
								'cl-hb-2013-01-31',
								'cl-hb-2013-07-15',
								'cl-hs-2011-04-26',
								'cl-hs-2012-03-23',
								'cl-hs-2013-01-31',
								'cl-hs-2013-07-15',
								'svs-cl-ci-2010-05-15',
								'svs-cl-ci-2011-04-26',
								'svs-cl-ci-2012-03-21',
								'svs-cl-ci-2013-01-31',
								'svs-cl-ci-2013-07-15')
		and		ti.codi_info = ic.codi_info
		and		ic.codi_conc = dc.codi_conc) tmp1) tmp2		


select 'insert into dbax_taxo_conc (pref_conc,codi_conc,vers_taxo) values ('
		+ '''' + pref_conc + ''',''' + codi_conc + ''',''' + vers_taxo + ''''
	   + ')'
from (
select  substring(codi_conc, 1, charindex('_',codi_conc) - 1) pref_conc, 
		substring(codi_conc, charindex('_',codi_conc) + 1, 256) codi_conc, 
		vers_taxo
from   (select	distinct substring(ic.codi_conc,charindex('#',ic.codi_conc)+1,1000) codi_conc,
				ti.vers_taxo
		from	xbrl_taxo_info ti,
				xbrl_info_conc ic,
				xbrl_defi_conc dc
		where	ti.vers_taxo in ('cl-hb-2011-04-26',
								'cl-hb-2012-03-23',
								'cl-hb-2013-01-31',
								'cl-hb-2013-07-15',
								'cl-hs-2011-04-26',
								'cl-hs-2012-03-23',
								'cl-hs-2013-01-31',
								'cl-hs-2013-07-15',
								'svs-cl-ci-2010-05-15',
								'svs-cl-ci-2011-04-26',
								'svs-cl-ci-2012-03-21',
								'svs-cl-ci-2013-01-31',
								'svs-cl-ci-2013-07-15')
		and		ti.codi_info = ic.codi_info
		and		ic.codi_conc = dc.codi_conc) tmp1) tmp2	
order by vers_taxo, pref_conc, codi_conc	