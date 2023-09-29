use dbaxBI
GO
--select * from PF_03_Conceptos
--select * from PF_07_Valores where Periodo = '2013-03' and PKConcepto like '%200000%'

insert into PF_03_Conceptos
select	'SEGUROGRAL_' + replace(dbaxAach.dbo.dbax_bi_getConcepto(c.codi_info,c.codi_conc),'(2013)','') collate Latin1_General_CS_AS PK_Concepto,
		i.desc_info  collate Latin1_General_CS_AS Cuadro,
		i.desc_info  collate Latin1_General_CS_AS Tabla,
		'SEGUROGRAL_' + replace(dbaxAach.dbo.dbax_bi_getConcepto(c.codi_info,c.codi_conc),'(2013)','')  collate Latin1_General_CS_AS CodigoConcepto,
		replace(s.desc_conc,'[sinopsis]','')  collate Latin1_General_CS_AS Concepto--,
		 --dbo.dbax_bi_getConcepto(c.codi_info,c.codi_conc1) codi_conc1,
		 --c.codi_info,
		 --c.orde_conc
from dbaxAach.dbo.dbax_info_defi d,
 dbaxAach.dbo.dbax_info_conc c,
 dbaxAach.dbo.dbax_desc_info i,
 dbaxAach.dbo.dbax_desc_conc s
where i.codi_info = d.codi_info
and   c.codi_info = d.codi_info
and   s.pref_conc = c.pref_conc
and   s.codi_conc = c.codi_conc
and   d.indi_vige = '1'
and   s.codi_lang = substring(c.codi_info,charindex('role-',c.codi_info)+5,6)
and   c.codi_conc not like '%Sinopsis%'
and   i.codi_lang = 'es_ES'
and   c.codi_info not in ('pre_cl-cs_eeff_role-110000(2013)')
except 
select PKConcepto, Cuadro, Tabla, CodigoConcepto, Concepto 
from PF_03_Conceptos
order by 4
--union
--select d.codi_info, i.desc_info, '', d.codi_info, i.desc_info, 0
--from dbax_info_defi d, dbax_desc_info i
--where   i.codi_info = d.codi_info
--and   d.indi_vige = '1'
--and   d.codi_info not like '%VIDA%'
--and   I.desc_info like 'EE.FF%'

--delete from PF_03_Conceptos where PKConcepto like '%pre_cl-cs_eeff_role-_00000%'
--select * from PF_03_Conceptos where PKConcepto like '%pre_cl-cs_eeff_role-_00000%'