select 1 ord, 'insert into dbax_dime_defi (codi_dein,pref_dime,codi_dime,codi_fcdi,letr_dime) values ('
		+ '''' + codi_dein + ''',''' + pref_dime + ''',''' + codi_dime + ''',''' + codi_fcdi + ''',''' + letr_dime + ''''
	    + ')' qry
from (
select  codi_info							codi_dein,
		substring(codi_dime, 1, charindex('_',codi_dime) - 1)	pref_dime, 
		substring(codi_dime, charindex('_',codi_dime) + 1, 100) codi_dime, 
		'ACT'							codi_fcdi,
		letr_dime						letr_dime
from   (select	codi_info, 
				substring(codi_dime, charindex('#',codi_dime) + 1, 100) codi_dime,
				letr_dime
		from    xbrl_dime_defi 
		where   codi_dime like '%cl-ci%2013%' or 
				codi_dime like '%cl-hs%2013%' or 
				codi_dime like '%cl-hb%2013%'
		) tmp1) tmp
union
select  2, 'insert into dbax_dime_conc (codi_dein, pref_dime, codi_dime, pref_conc, codi_conc, orde_conc, sald_ini) values ('
		+ '''' + codi_dein + ''',''' + pref_dime + ''',''' + codi_dime + ''',''' + pref_conc + ''',''' + codi_conc + ''',''' + convert(varchar(5),orde_conc) + ''', NULL ' 
	    + ')' qry
from (
select  codi_info							codi_dein,
		substring(codi_dime, 1, charindex('_',codi_dime) - 1)	pref_dime, 
		substring(codi_dime, charindex('_',codi_dime) + 1, 100) codi_dime, 
		substring(codi_conc, 1, charindex('_',codi_conc) - 1)	pref_conc, 
		substring(codi_conc, charindex('_',codi_conc) + 1, 100) codi_conc, 
		orde_conc						orde_conc
from   (select	c.codi_info	codi_info, 
				substring(codi_dime, charindex('#',codi_dime) + 1, 100) codi_dime,
				substring(codi_conc, charindex('#',codi_conc) + 1, 100) codi_conc,
				c.orde_conc
		from    xbrl_dime_defi d,
				xbrl_info_conc c
		where   (d.codi_dime like '%cl-ci%2013%' or
		         d.codi_dime like '%cl-hs%2013%' or
		         d.codi_dime like '%cl-hb%2013%')
		and     c.codi_info = d.codi_info
		and     c.orde_conc between d.orde_conc1 and d.orde_conc2) tmp) tmp1
union
select  3, 'insert into dbax_dime_axis (pref_axis, codi_axis) values ('
		+ '''' + pref_axis + ''',''' + codi_axis + ''''
	    + ')' qry
from (
select  substring(codi_axis, 1, charindex('_',codi_axis) - 1)	pref_axis, 
		substring(codi_axis, charindex('_',codi_axis) + 1, 100) codi_axis 
from   (
select	substring(codi_axis, charindex('#',codi_axis) + 1, 100) codi_axis
from    xbrl_dime_axis
where   codi_axis like '%cl-ci%2013%' or
        codi_axis like '%cl-hb%2013%' or
        codi_axis like '%cl-hs%2013%') tmp) tmp1
union
select  4, 'insert into dbax_dime_diax (codi_dein, pref_dime, codi_dime, pref_axis, codi_axis, orde_axis) values ('
		+ '''' + codi_dein + ''',''' + pref_dime + ''',''' + codi_dime + ''',''' + pref_axis + ''',''' + codi_axis + ''', ' + convert(varchar(5),orde_axis) + '' 
	    + ')' qry
from (
select  codi_info							codi_dein,
		substring(codi_dime, 1, charindex('_',codi_dime) - 1)	pref_dime, 
		substring(codi_dime, charindex('_',codi_dime) + 1, 100) codi_dime, 
		substring(codi_axis, 1, charindex('_',codi_axis) - 1)	pref_axis, 
		substring(codi_axis, charindex('_',codi_axis) + 1, 100) codi_axis, 
		orde_axis						orde_axis
from   (
select	c.codi_info	codi_info, 
		substring(c.codi_dime, charindex('#',c.codi_dime) + 1, 100) codi_dime,
		substring(c.codi_axis, charindex('#',c.codi_axis) + 1, 100) codi_axis,
		orde_axis
		from    xbrl_dime_defi d,
				xbrl_dime_diax c
		where   (	d.codi_dime like '%cl-ci%2013%' or 
					d.codi_dime like '%cl-hs%2013%' or 
					d.codi_dime like '%cl-hb%2013%')
		and     c.codi_info = d.codi_info) tmp) tmp1
union
select  5, 'insert into dbax_dime_memb (pref_axis, codi_axis, pref_memb, codi_memb, orde_memb, tipo_memb) values ('
		+ '''' + pref_axis + ''',''' + codi_axis + ''',''' + pref_memb + ''',''' + codi_memb + ''',''' + convert(varchar(5),orde_memb) + ''', ''' + tipo_memb + '''' 
	    + ')' qry
from (
select  substring(codi_axis, 1, charindex('_',codi_axis) - 1)	pref_axis, 
		substring(codi_axis, charindex('_',codi_axis) + 1, 100) codi_axis, 
		substring(codi_memb, 1, charindex('_',codi_memb) - 1)	pref_memb, 
		substring(codi_memb, charindex('_',codi_memb) + 1, 100) codi_memb, 
		orde_memb						orde_memb, 
		tipo_memb						tipo_memb
from   (
select	substring(codi_axis, charindex('#',codi_axis) + 1, 100) codi_axis,
		substring(codi_memb, charindex('#',codi_memb) + 1, 100) codi_memb,
		orde_memb,
		tipo_memb
from    xbrl_dime_memb
where   codi_axis like '%cl-ci_cor_2013-01-31%' or
        codi_axis like '%cl-hs_cor_2013-01-31%' or
        codi_axis like '%cl-hb_cor_2013-01-31%') tmp) tmp1
