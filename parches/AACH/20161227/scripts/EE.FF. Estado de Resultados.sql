--select top 100 * from PF_07_Valores

declare @vCorrInst varchar(7)
set @vCorrInst='201709'

declare curPeriodos cursor for
	select distinct corr_inst from dbaxAach.dbo.dbax_inst_conc where corr_inst = @vCorrInst

open curPeriodos
fetch next from curPeriodos into @vCorrInst
while @@FETCH_STATUS = 0
begin
	select @vCorrInst
	declare @vCorrInst2 varchar(7)
	set @vCorrInst2 = SUBSTRING(@vCorrInst,1,4) + '-' + SUBSTRING(@vCorrInst,5,2)
	select @vCorrInst2
	delete from PF_07_Valores where Periodo = @vCorrInst and PKConcepto like '%pre_cl-cs_eeff_role-[2,5,6]00000%'
	
	insert into PF_07_Valores (Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, PKSubRamo, ValorPesos)
	select distinct
			--A.*, 
			A.codi_segm collate Latin1_General_CS_AS as Segmento,
			dbaxAach.dbo.dbax_bi_getPeriodo(F.fini_cntx,F.ffin_cntx) collate Latin1_General_CS_AS Periodo,
			A.codi_segm + '_' + E.codi_pers collate Latin1_General_CS_AS PKEmpresa,
			replace(A.codi_segm + '_' + dbaxAach.dbo.dbax_bi_getConcepto(B.codi_info,E.codi_conc),'(2017)','') collate Latin1_General_CS_AS PKConcepto,
			--'0' peri_actu,
		   A.codi_segm + '_0' collate Latin1_General_CS_AS as codi_ramo,
		   A.codi_segm + '_0' collate Latin1_General_CS_AS as sub_ramo,
		   --(select top 1 case tipo_valo when 'xbrli:monetaryItemType' then convert(numeric(18), replace(E.valo_cntx,',','.'))/1000 else convert(numeric(18), replace(E.valo_cntx,',','.')) end from dbaxAach.dbo.dbax_defi_conc r where r.codi_conc = E.codi_conc) valo_cntx,
		   replace(E.valo_cntx,',','.') collate Latin1_General_CS_AS ValorPesos--,
		   --replace(E.valo_refe,',','.') valorUF,
		   --replace(E.valo_inte,',','.') valorUSD
	from   dbaxAach.dbo.dbax_defi_pers A,
		   dbaxAach.dbo.dbax_inst_conc E,
		   dbaxAach.dbo.dbax_info_conc B,
		   dbaxAach.dbo.dbax_view_cntx F,
		   dbaxAach.dbo.dbax_defi_conc G,
		   dbaxAach.dbo.dbax_info_defi D
	where E.valo_cntx not in ('Infinito')
	--and   A.codi_segm = 'SEGUROGRAL'
	and   D.indi_vige = '1'
	and   D.codi_info = B.codi_info
	and   E.codi_pers = A.codi_pers
	and   E.codi_cntx not like '%Posterior%'
	AND   E.codi_conc in (select codi_conc from dbaxAach.dbo.dbax_info_conc)
	--AND   E.corr_inst in (substring(replace(F.fini_cntx,'-',''),1,6), substring(replace(F.ffin_cntx,'-',''),1,6))
	AND	  E.corr_inst = replace(@vCorrInst2,'-','')
	AND   E.vers_inst = (	select max(vers_inst)
							from dbaxAach.dbo.dbax_inst_vers v
							where	v.codi_pers = E.codi_pers
							and		v.corr_inst = E.corr_inst)
	AND   B.pref_conc = E.pref_conc
	AND   B.codi_conc = E.codi_conc
	AND   F.codi_pers = E.codi_pers
	AND   F.corr_inst = E.corr_inst
	AND   F.vers_inst = E.vers_inst
	AND   F.codi_cntx = E.codi_cntx
	AND   G.pref_conc = E.pref_conc
	AND   G.codi_conc = E.codi_conc
	AND   G.tipo_valo in ('indi','xbrli:monetaryItemType',
			'xbrli:decimalItemType',
			'xbrli:pureItemType',
			'xbrli:sharesItemType',
			'num:percentItemType',
			'num:perShareItemType')
	AND    B.codi_info not like '%nota%'
	AND   dbaxAach.dbo.dbax_bi_getPeriodo(F.fini_cntx,F.ffin_cntx) = @vCorrInst2
	and  (dbaxAach.dbo.dbax_bi_getConcepto(B.codi_info,E.codi_conc) LIKE '%pre_cl-cs_eeff_role-200000(2017)%'
			or dbaxAach.dbo.dbax_bi_getConcepto(B.codi_info,E.codi_conc) LIKE '%pre_cl-cs_eeff_role-300000(2017)%'
			or dbaxAach.dbo.dbax_bi_getConcepto(B.codi_info,E.codi_conc) LIKE '%pre_cl-cs_eeff_role-500000(2017)%')
	--and A.codi_segm + '_' + E.codi_pers collate Latin1_General_CS_AS not in (select PKEmpresa from PF_02_Empresas)
	--AND A.codi_segm is null
	--and	replace(A.codi_segm + '_' + dbaxAach.dbo.dbax_bi_getConcepto(B.codi_info,E.codi_conc),'(2017)','') collate Latin1_General_CS_AS not in (select PKConcepto from PF_03_Conceptos)
	
	fetch next from curPeriodos into @vCorrInst
end
close curPeriodos
deallocate curPeriodos

1



select * from dbaxAach.dbo.dbax_inst_dicx where codi_pers = '700157302' and corr_inst = 201706 and codi_cntx = 'Saldo_cl-cs_CostoSiniestroTabla_C101_4_ACT'

--update dbaxAach.dbo.dbax_defi_pers 
--set codi_segm = 'SEGUROGRAL', rutt_pers = '76743492-8', empr_vige = 'SI', desc_pers = 'REALE'
--where codi_pers = '767434921'

--update dbaxAach.dbo.dbax_defi_pers 
--set codi_segm = 'SEGUROGRAL', rutt_pers = '76620932-7', empr_vige = 'SI', desc_pers = 'STARR INTERNATIONAL'
--where codi_pers = '766209321'

--select * from dbaxAach.dbo.dbax_defi_pers where codi_pers in ('767434921')
--select * from PF_02_Empresas where Rut in ('766208161','766209321')
--SEGUROGRAL_766208161
--SEGUROGRAL_766209321


--700157302,201706, 1, cl-cs:RamosEje, Periodo_cl-cs_CostoSiniestroTabla_C101_4_ACT, R

SELECT DISTINCT ic.codi_pers
				,ic.corr_inst
				,ic.vers_inst
				,CASE substring(dc.codi_dein, charindex('(', dc.codi_dein) - 1, 1)
					WHEN '1'
						THEN 'SEGUROGRAL'
					ELSE 'SEGUROVIDA'
					END AS Segmento
				,dc.pref_conc + '_' + dc.codi_conc + '_' + codi_dime AS PKConcepto
				,convert(NUMERIC, replace(ic.valo_cntx, ',', '.')) AS ValorPesos
				,convert(NUMERIC, replace(ic.valo_refe, ',', '.')) AS ValorUF
				,convert(NUMERIC, replace(ic.valo_inte, ',', '.')) AS ValorUSD
FROM dbaxAach.dbo.dbax_info_defi id
	,dbaxAach.dbo.dbax_dime_conc dc
	,dbaxAach.dbo.dbax_defi_conc df
	,dbaxAach.dbo.dbax_inst_conc ic
	,dbaxAach.dbo.dbax_inst_dicx ix
	,dbaxAach.dbo.dbax_defi_pers dp
WHERE id.indi_vige = '1'
	AND id.tipo_info = 'D'
	AND id.codi_info LIKE '%cuadro%'
	AND dc.codi_dein = id.codi_info
	AND dc.pref_conc = df.pref_conc
	AND dc.codi_conc = df.codi_conc
	AND df.tipo_cuen != 'abstract'
	AND dp.codi_pers = 700157302
	AND dp.codi_segm = CASE substring(dc.codi_dein, charindex('(', dc.codi_dein) - 1, 1)
		WHEN '1'
			THEN 'SEGUROGRAL'
		ELSE 'SEGUROVIDA'
		END
	AND ic.codi_pers = dp.codi_pers
	AND ic.corr_inst = 201706
	AND ic.vers_inst = 1
	AND ic.pref_conc = dc.pref_conc
	AND ic.codi_conc = dc.codi_conc
	AND ic.codi_conc NOT IN (
		'RamosVida'
		,'RamosGenerales'
		)
	AND ic.codi_cntx = 'Saldo_cl-cs_CostoSiniestroTabla_C101_4_ACT'
	AND ix.codi_pers = ic.codi_pers
	AND ix.corr_inst = ic.corr_inst
	AND ix.vers_inst = ic.vers_inst
	AND ix.codi_cntx = ic.codi_cntx
	AND ix.codi_axis IN (
		'cl-cs:RamosEje'
		,'cl-cs:DetalleSubRamosEje'
		)
	AND	ic.codi_conc like '%ReservaMatematicaBruta%'

select * from dbaxAach.dbo.dbax_inst_conc where corr_inst = 201706 and codi_conc like '%ReservaMatematicaBruta'
select * from PF_07_Valores where PKEmpresa like 'SEGUROVIDA_%' and Periodo = '2017-06' and PKConcepto like '%ReservaMatematicaBruta%'


700157302,201706, 1, cl-cs:RamosEje, Periodo_cl-cs_CostoSiniestroTabla_C101_4_ACT, R
Saldo_cl-cs_CostoSiniestroTabla_C101_4_ACT


select  *
from	dbaxAach.dbo.dbax_inst_cntx ic
		,dbaxAach.dbo.dbax_inst_dicx id
where	ic.codi_pers = 700157302
and		ic.corr_inst = 201706
and		ic.vers_inst = 1
and		ic.fini_cntx is not null
and		ic.ffin_cntx = '2017-06-30'
and		id.codi_pers = ic.codi_pers
and		id.corr_inst = ic.corr_inst
and		id.vers_inst = ic.vers_inst
and		id.codi_cntx = ic.codi_cntx
and		id.codi_axis = 'cl-cs:DetalleSubRamosEje'
and		id.codi_memb = 'tx:C101'

select  *
from	dbaxAach.dbo.dbax_inst_cntx ic
		,dbaxAach.dbo.dbax_inst_dicx id
where	ic.codi_pers = 700157302
and		ic.corr_inst = 201706
and		ic.vers_inst = 1
and		ic.fini_cntx is not null
and		ic.ffin_cntx = '2017-06-30'
and		id.codi_pers = ic.codi_pers
and		id.corr_inst = ic.corr_inst
and		id.vers_inst = ic.vers_inst
and		id.codi_cntx = ic.codi_cntx
and		id.codi_axis = 'cl-cs:DetalleSubRamosEje'
and		id.codi_memb = 'tx:C101'