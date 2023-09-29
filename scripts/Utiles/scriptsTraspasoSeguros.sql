select * from xbrl_taxo_vers
where vers_taxo = 'cl-cs-2014-06-15'

select 0,0,codi_info, orde_info, indi_eeff, indi_situ, indi_resu, indi_fluj, indi_patr, indi_inte, tipo_xml, sche_info, 'S', 1, 'C' from xbrl_info_defi
where codi_info in (select codi_info from xbrl_taxo_info
where vers_taxo = 'cl-cs-2014-06-15')
order by orde_info

select ti.codi_info, di.desc_info, di.orde_info, di.sche_info, NULL  from xbrl_taxo_info ti, xbrl_info_defi di
where ti.vers_taxo = 'cl-cs-2014-06-15'
and	ti.codi_info = di.codi_info
order by orde_info

select 0,0,codi_info, 'es_ES', desc_info, 'C' from xbrl_info_defi
where codi_info in (select codi_info from xbrl_taxo_info
where vers_taxo = 'cl-cs-2014-06-15')
order by orde_info

select	distinct ic.codi_conc, tipo_conc, tipo_peri, tipo_valo, tipo_cuen, null
from	xbrl_defi_conc dc, xbrl_info_conc ic
where	ic.codi_info in (select codi_info from xbrl_taxo_info
						where vers_taxo = 'cl-cs-2014-06-15')
and		dc.codi_conc = ic.codi_conc
order by ic.codi_conc

select	distinct ic.codi_conc, 'es_ES', desc_conc
from	xbrl_defi_conc dc, xbrl_info_conc ic
where	ic.codi_info in (select codi_info from xbrl_taxo_info
						where vers_taxo = 'cl-cs-2014-06-15')
and		dc.codi_conc = ic.codi_conc
order by ic.codi_conc

select 0,0,codi_info, codi_conc, orde_conc, nive_conc, 'C' from xbrl_info_conc
where codi_info in (select codi_info from xbrl_taxo_info
where vers_taxo = 'cl-cs-2014-06-15')
order by codi_info

select distinct 0,0,codi_info, codi_cntx, 'C', 0,0, posi_valo from xbrl_info_cntx
where codi_info in (select codi_info from xbrl_taxo_info
	where vers_taxo = 'cl-cs-2014-06-15')
order by codi_info, posi_valo

select 0,0,codi_info,'C','SEGUROS' from xbrl_taxo_info
where vers_taxo = 'cl-cs-2014-06-15'

select codi_info codi_dein, codi_dime, letr_dime, role_uri from xbrl_dime_defi
where codi_info in (select codi_info from xbrl_taxo_info
	where vers_taxo = 'cl-cs-2014-06-15')

select * from xbrl_dime_axis where codi_axis like '%2014-06-15%'

select codi_dime, codi_axis, orde_axis, codi_info codi_dein from xbrl_dime_diax
where codi_info in (select codi_info from xbrl_taxo_info
	where vers_taxo = 'cl-cs-2014-06-15')
order by codi_info, codi_dime, orde_axis

select codi_axis, codi_memb, orde_memb, tipo_memb from xbrl_dime_memb
where codi_info in (select codi_info from xbrl_taxo_info
	where vers_taxo = 'cl-cs-2014-06-15')
order by codi_info, codi_memb, orde_memb

select dd.codi_info, ic.codi_conc, ic.orde_conc, dd.codi_dime from xbrl_dime_defi dd, xbrl_info_conc ic
where dd.codi_info = ic.codi_info
and	dd.codi_info in (select codi_info from xbrl_taxo_info
	where vers_taxo = 'cl-cs-2014-06-15')
and	dd.orde_conc1 <= ic.orde_conc
and dd.orde_conc2 >= ic.orde_conc
order by dd.codi_info, codi_dime, ic.orde_conc

select distinct codi_info codi_dein, codi_dime, 'SEGUROS' from xbrl_dime_defi
where codi_info in (select codi_info from xbrl_taxo_info
	where vers_taxo = 'cl-cs-2014-06-15')

select 0,0,codi_info, orde_info, indi_eeff, indi_situ, indi_resu, indi_fluj, indi_patr, indi_inte, tipo_xml, sche_info, 'S', 1, 'D' from xbrl_info_defi																
where codi_info in (select ti.codi_info from xbrl_taxo_info ti, xbrl_dime_defi dd
					where ti.vers_taxo = 'cl-cs-2014-06-15'
					and	  ti.codi_info = dd.codi_info)

select 0,0,codi_info, 'es_ES', desc_info, 'D' from xbrl_info_defi
where codi_info in (select ti.codi_info from xbrl_taxo_info ti, xbrl_dime_defi dd
					where ti.vers_taxo = 'cl-cs-2014-06-15'
					and	  ti.codi_info = dd.codi_info)
order by orde_info

select 0,0,dd.codi_info,'D','SEGUROS' 
from xbrl_taxo_info ti, xbrl_dime_defi dd
where ti.vers_taxo = 'cl-cs-2014-06-15'
and	  ti.codi_info = dd.codi_info