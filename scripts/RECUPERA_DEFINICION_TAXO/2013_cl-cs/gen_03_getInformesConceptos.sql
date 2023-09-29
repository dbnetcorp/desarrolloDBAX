declare @p_taxo varchar(16)
declare @p_pref varchar(16)
declare @p_anno varchar(16)

set @p_taxo = '%cl-cs%2013%'
set @p_pref = 'EEFF 2013 - '
set @p_anno = '2013'


select  'INSERT INTO dbax_info_conc (codi_emex, codi_empr, codi_info, pref_conc, codi_conc, orde_conc, nive_conc) VALUES (''' + '1' + ''',''' + '1' + ''',''' + codi_info  + ''',''' + 
		substring(substring(codi_conc, 
			charindex('#',codi_conc) + 1, 100), 1, 
			charindex('_',substring(codi_conc, 
			charindex('#',codi_conc) + 1, 100)) - 1)  + ''',''' +
	   substring(substring(codi_conc, 
			charindex('#',codi_conc) + 1, 100), 
			charindex('_',substring(codi_conc, 
			charindex('#',codi_conc) + 1, 100)) + 1, 100)  + ''',''' + 
		convert(varchar(5), orde_conc)  + ''',''' +
		convert(varchar(5), nive_conc)  + ''')'
from xbrl_info_conc
where codi_info in (select codi_info
			from   xbrl_info_defi 
			where  (sche_info like @p_taxo)
			and   (codi_info like '%110000%'
			or     codi_info like '%200000%'
			or     codi_info like '%300000%'
			or     codi_info like '%500000%'))