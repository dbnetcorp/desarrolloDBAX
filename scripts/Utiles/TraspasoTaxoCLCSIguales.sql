--TAXO_VERS
insert into dbax_taxo_vers 
select 'cl-cs-2014-09-01', replace(ubic_taxo,'2014-06-15','2014-09-01'), tipo_taxo, 'Seguros 2014 2' from dbax_taxo_vers
where  vers_taxo = 'cl-cs-2014-06-15'

--INFO_DEFI
insert into dbax_info_defi
select codi_empr, codi_emex, replace(codi_info,'(2014)','(2014_2)'), orde_info, indi_eeff, indi_situ, indi_resu, indi_fluj, indi_patr, indi_inte, tipo_xml, sche_info, info_taxo, indi_vige, tipo_info from dbax_info_defi where codi_info like 'pre_cl-cs%(2014)'

--DESC_INFO
insert into dbax_desc_info
select codi_empr, codi_emex, replace(codi_info,'(2014)','(2014_2)'), codi_lang,desc_info,tipo_info from dbax_desc_info where codi_info like 'pre_cl-cs%(2014)'

--INFO_TITA
insert into dbax_info_tita
select codi_empr, codi_emex, replace(codi_info,'(2014)','(2014_2)'), tipo_info, tipo_taxo 
from dbax_info_tita where codi_info like 'pre_cl-cs%(2014)'

--DEFI_CONC
insert into dbax_defi_conc
values('cl-cs','PropiedadesDeInversionResultadoInversion','concepto','instant','xbrli:monetaryItemType','debit',NULL)

insert into dbax_defi_conc
values('cl-cs','BancosRepresentativos','concepto','instant','xbrli:monetaryItemType','debit',NULL)

insert into dbax_defi_conc
values('cl-cs','OtraRentaVariableNacionalResultadoInversion','concepto','instant','xbrli:monetaryItemType','debit',NULL)

insert into dbax_defi_conc
values('cl-cs','FondosInversionResultadoInversiones','concepto','instant','xbrli:monetaryItemType','debit',NULL)

insert into dbax_defi_conc
values('cl-cs','PatrimonioRiesgoOPatrimonioNeto','concepto','instant','xbrli:monetaryItemType','credit',NULL)

insert into dbax_defi_conc
values('cl-cs','CuentasPorCobrarLeasingResultadoInversion','concepto','instant','xbrli:monetaryItemType','debit',NULL)

insert into dbax_defi_conc
values('cl-cs','FondosMutuosResultadoInversion','concepto','instant','xbrli:monetaryItemType','debit',NULL)

insert into dbax_defi_conc
values('cl-cs','AccionesSociedadesExtranjerasResultadoInversion','concepto','instant','xbrli:monetaryItemType','debit',NULL)

insert into dbax_defi_conc
values('cl-cs','PropiedadesUsoPropioResultadoInversion','concepto','instant','xbrli:monetaryItemType','debit',NULL)

--DESC-CONC
insert into dbax_desc_conc
values('cl-cs','PropiedadesDeInversionResultadoInversion','es_ES','1.3.2.2 Bienes raices de inversión')

insert into dbax_desc_conc
values('cl-cs','BancosRepresentativos','es_ES','Bancos')

insert into dbax_desc_conc
values('cl-cs','OtraRentaVariableNacionalResultadoInversion','es_ES','1.2.4 Otros renta variable')

insert into dbax_desc_conc
values('cl-cs','FondosInversionResultadoInversiones','es_ES','1.2.2 Fondos de inversión')

insert into dbax_desc_conc
values('cl-cs','PatrimonioRiesgoOPatrimonioNeto','es_ES','Patrimonio de riesgo (patrimonio neto mutuales)')

insert into dbax_desc_conc
values('cl-cs','CuentasPorCobrarLeasingResultadoInversion','es_ES','1.3.2.1 Bienes raíces en leasing')

insert into dbax_desc_conc
values('cl-cs','FondosMutuosResultadoInversion','es_ES','1.2.3 Fondos mutuos')

insert into dbax_desc_conc
values('cl-cs','AccionesSociedadesExtranjerasResultadoInversion','es_ES','2.2 Acciones')

insert into dbax_desc_conc
values('cl-cs','PropiedadesUsoPropioResultadoInversion','es_ES','1.3.1 Bienes raíces de uso propio')

--CONC_TITA
insert into dbax_conc_tita
values('cl-cs','PropiedadesDeInversionResultadoInversion','COME_INDU')

insert into dbax_conc_tita
values('cl-cs','BancosRepresentativos','COME_INDU')

insert into dbax_conc_tita
values('cl-cs','OtraRentaVariableNacionalResultadoInversion','COME_INDU')

insert into dbax_conc_tita
values('cl-cs','FondosInversionResultadoInversiones','COME_INDU')

insert into dbax_conc_tita
values('cl-cs','PatrimonioRiesgoOPatrimonioNeto','COME_INDU')

insert into dbax_conc_tita
values('cl-cs','CuentasPorCobrarLeasingResultadoInversion','COME_INDU')

insert into dbax_conc_tita
values('cl-cs','FondosMutuosResultadoInversion','COME_INDU')

insert into dbax_conc_tita
values('cl-cs','AccionesSociedadesExtranjerasResultadoInversion','COME_INDU')

insert into dbax_conc_tita
values('cl-cs','PropiedadesUsoPropioResultadoInversion','COME_INDU')

--INFO_CONC
insert into dbax_info_conc
select codi_empr, codi_emex, replace(codi_info,'(2014)','(2014_2)'), pref_conc, codi_conc, orde_conc, codi_conc1, nive_conc, negr_conc, tipo_info, conc_sini from dbax_info_conc
where codi_info like 'pre_cl-cs%(2014)'

--DIME_DEFI
insert into dbax_dime_defi
select replace(codi_dein,'(2014)','(2014_2)'), codi_dime, pref_dime, codi_fcdi, letr_dime, role_uri, dime_tran
from dbax_dime_defi
where codi_dein like 'pre_cl-cs%(2014)'



--DIME_DIAX
insert into dbax_dime_diax
select codi_dime, pref_dime, codi_axis, pref_axis, orde_axis, replace(codi_dein,'(2014)','(2014_2)') from dbax_dime_diax
where codi_dein like 'pre_cl-cs%(2014)'

--DIME_CONC
insert into dbax_dime_conc
select replace(codi_dein,'(2014)','(2014_2)'), codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini, negr_conc from dbax_dime_conc where codi_dein like 'pre_cl-cs%(2014)'



update dbax_info_defi set indi_vige = 0 where codi_info like 'pre[_]cl-cs%(2014)'
select * from dbax_info_defi where codi_info like '%(2014%)' order by orde_info