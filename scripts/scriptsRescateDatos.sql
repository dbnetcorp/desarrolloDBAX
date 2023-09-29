delete from [dbax].[dbo].[xbrl_defi_conc]
delete from [dbax].[dbo].[xbrl_info_conc]
delete from [dbax].[dbo].[xbrl_taxo_info]
delete from [dbax].[dbo].[xbrl_info_defi]
delete from [dbax].[dbo].[xbrl_taxo_vers]

insert into [dbax].[dbo].[xbrl_taxo_vers] (vers_taxo, ubic_taxo)
select vers_taxo, ubic_taxo from [xbrl4].[dbo].[xbrl_taxo_vers]

select * from [dbax].[dbo].[xbrl_taxo_vers]
--
insert [dbax].[dbo].[xbrl_info_defi] (codi_info,orde_info,indi_eeff,indi_situ,indi_resu,indi_fluj,indi_patr,indi_inte,tipo_xml)
select codi_info,orde_info,indi_eeff,indi_situ,indi_resu,indi_fluj,indi_patr,indi_inte,tipo_xml from [xbrl4].[dbo].[xbrl_info_defi]

select * from [dbax].[dbo].[xbrl_info_defi]
--
insert [dbax].[dbo].[xbrl_taxo_info] (codi_info,vers_taxo)
select codi_info,vers_taxo from [xbrl4].[dbo].[xbrl_taxo_info]

select codi_info,vers_taxo from [dbax].[dbo].[xbrl_taxo_info]

----------------------dbax_defi_conc---------------------------------------------------
insert into [dbax].[dbo].[dbax_defi_conc] (pref_conc, codi_conc,tipo_conc,tipo_peri,tipo_valo,tipo_cuen)
select  substring(concepto, 1, charindex('_', concepto)-1) prefijo, 
		substring(concepto, charindex('_', concepto)+1, 200) concepto,
		replace(replace(replace(tipo_conc, 'xbrli:item', 'concepto'),'xbrldt:hypercubeItem','hipercubo'),'xbrldt:dimensionItem','dimension') as tipo_conc,
		tipo_peri,
		tipo_valo,
		tipo_cuen
from	(
		select	distinct substring(dc.codi_conc,charindex('#',dc.codi_conc)+1,200) as concepto,
				max(tipo_conc) tipo_conc,
				max(tipo_peri) tipo_peri,
				max(tipo_valo) tipo_valo,
				max(tipo_cuen) tipo_cuen 
		from	[xbrl4].[dbo].[xbrl_defi_conc] dc, [xbrl4].[dbo].[xbrl_info_conc] ic
		where 
				dc.codi_conc like '%cl-cs[_]%' 
		and		dc.codi_conc not like '%ifrs[_]gp%'
		and     ic.codi_conc = dc.codi_conc
		--and		codi_conc = 'cl-ci_CompromisosFuturos'
		group by substring(dc.codi_conc,charindex('#',dc.codi_conc)+1,200)
		--order by prefijo, concepto
		) C
group by concepto,		tipo_conc,		tipo_peri,		tipo_valo,		tipo_cuen
having count(concepto) > 0
order by prefijo, concepto



-- dbax_desc_conc-------------------------------------------------------------------------
insert into [dbax].[dbo].[dbax_desc_conc] (pref_conc, codi_conc, codi_lang, desc_conc )
select  substring(concepto, 1, charindex('_', concepto)-1) pref_conc, 
		substring(concepto, charindex('_', concepto)+1, 200) codi_conc,
        'es_ES' as codi_lang,
        desc_conc

from	(
		select	distinct substring(dc.codi_conc,charindex('#',dc.codi_conc)+1,200) as concepto,
				max(tipo_conc) tipo_conc,
				max(tipo_peri) tipo_peri,
				max(tipo_valo) tipo_valo,
				max(tipo_cuen) tipo_cuen,
                max(desc_conc) desc_conc
		from	[xbrl4].[dbo].[xbrl_defi_conc] dc, [xbrl4].[dbo].[xbrl_info_conc] ic
		where 
				dc.codi_conc like '%cl-cs[_]%' 
		and		dc.codi_conc not like '%ifrs[_]gp%'
		and     ic.codi_conc = dc.codi_conc
		group by substring(dc.codi_conc,charindex('#',dc.codi_conc)+1,200)
		) C
group by concepto,tipo_conc,tipo_peri,tipo_valo,tipo_cuen, desc_conc
having count(concepto) > 0
order by pref_conc, codi_conc, desc_conc
-------------------------------------------------------------------------



select codi_conc,tipo_conc,tipo_peri,tipo_valo,tipo_cuen from [dbax].[dbo].[xbrl_defi_conc]
--
delete from [dbax].[dbo].[xbrl_info_conc]
insert into [dbax].[dbo].[xbrl_info_conc] (codi_info,codi_conc,codi_conc1,orde_conc,nive_conc)
select codi_info,codi_conc,codi_conc1,orde_conc,nive_conc from [xbrl4].[dbo].[xbrl_info_conc]

delete from [dbax].[dbo].[xbrl_inst_docu]
delete from [dbax].[dbo].[xbrl_inst_vers]
delete from [dbax].[dbo].[xbrl_inst_conc]
delete from [dbax].[dbo].[xbrl_inst_cntx]
delete from [dbax].[dbo].[xbrl_inst_dicx]
delete from [dbax].[dbo].[xbrl_inst_unit]

update empr set desc_empr = convert(varchar,codi_empr) + convert(varchar,codi_empr) + convert(varchar,codi_empr)

