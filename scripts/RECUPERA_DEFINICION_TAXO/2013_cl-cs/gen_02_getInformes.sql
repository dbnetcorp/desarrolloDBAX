select	'INSERT INTO dbo.dbax_taxo_info(codi_info,desc_info,orde_info,sche_info) VALUES(''' + 
		codi_info + ''',''' +
		desc_info + ''',''' +
		orde_info + ''',''' +
		replace(sche_info,'cl-cs-2013-01-31','http://www.svs.cl/cl/fr/cs/2013-01-31') + ''')'
from   xbrl_info_defi 
where  sche_info like '%cl-cs%2013%'
