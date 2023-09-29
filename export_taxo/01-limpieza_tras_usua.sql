select count(*) cnt
--delete dbax_tras_usua
from   dbax_tras_usua t
where  codi_usua = 'DBNET'
and    t.codi_arch in (select codi_arch 
					   from   dbax_tras_arch a
					   where  path_arch like '201703%CI%%'
					   and    codi_arch in (	select	max(codi_arch) 
												from	dbax_tras_arch m
												where   m.path_arch = a.path_arch
												and     m.codi_taxo = a.codi_taxo)
					  )

select count(*) cnt
from   dbax_tras_arch t
where  t.codi_arch in (select codi_arch 
					   from   dbax_tras_arch a
					   where  path_arch like '201703%CI%%'
					   and    codi_arch in (	select	max(codi_arch) 
												from	dbax_tras_arch m
												where   m.path_arch = a.path_arch
												and     m.codi_taxo = a.codi_taxo)
					  )


--RUT 96640360
--RUT 76003557