----Inserción de miembros 1313
----delete from PF_04_Columnas
----delete from PF_07_Valores
----delete from PF_03_Conceptos 
--insert into PF_04_Columnas (PKColumna,CodigoColumna,Columna)
--select  distinct me.pref_memb + '_' + me.codi_memb + '_' + de.codi_dime as PKColumna
--		,me.pref_memb + '_' +me.codi_memb as CodigoColumna
--		,convert(varchar,me.orde_memb) + ' ' + replace(dc.desc_conc,' [miembro]','') as Columna
--		--,di.*
--from [192.168.14.5].dbax.dbo.dbax_dime_defi de
--	,[192.168.14.5].dbax.dbo.dbax_dime_diax di
--	,[192.168.14.5].dbax.dbo.dbax_dime_memb me
--	,[192.168.14.5].dbax.dbo.dbax_desc_conc dc
--where (		de.codi_dein like '%851000%'
--			or  de.codi_dein like '%864000%')
--and de.codi_dime in ('CuadroResumenTabla'
--					,'ResultadoInversionesTabla'
--					,'InvetarioInversionesTabla')
--and di.codi_dein = de.codi_dein
--and	di.codi_dime = de.codi_dime
--and me.codi_axis = di.codi_axis
--and	me.tipo_memb != 'dimension-default'
--and	dc.codi_conc = me.codi_memb
--and dc.codi_lang = 'es_ES'
--union
--select  'Total' as PKColumna
--		,'Total' as CodigoColumna
--		,'100000 Total'as Columna
--union
--select  'Total' as PKColumna
--		,'Total' as CodigoColumna
--		,'100000 Total'as Columna
--union
--select  'Total' as PKColumna
--		,'Total' as CodigoColumna
--		,'100000 Total'as Columna

----Insercion en PF_03_Conceptos
--INSERT PF_03_Conceptos (PKConcepto,Cuadro,Tabla,CodigoConcepto,Concepto)
--select PKConcepto,MAX(Cuadro),MAX(Tabla),MAX(CodigoConcepto),MAX(Concepto) from (
--			select distinct --de.codi_dein, di.desc_info, *
--					ic.pref_conc + '_' + ic.codi_conc + '_' + de.codi_dime as PKConcepto
--					, di.desc_info as Cuadro
--					, dc2.desc_conc as Tabla
--					,ic.pref_conc + '_' +ic.codi_conc + '_' + de.codi_dime as CodigoConcepto
--					,RIGHT('00000'+ convert(varchar,ic.orde_conc),5) + ' ' + dc1.desc_conc as Concepto
--			from [192.168.14.5].dbax.dbo.dbax_dime_defi de
--				,[192.168.14.5].dbax.dbo.dbax_dime_conc ic
--				,[192.168.14.5].dbax.dbo.dbax_desc_conc dc1
--				,[192.168.14.5].dbax.dbo.dbax_desc_conc dc2
--				,[192.168.14.5].dbax.dbo.dbax_desc_info di
--			where (		de.codi_dein = 'pre_cl-cs_nota-35_role-851000(2018)'
--					or  de.codi_dein like 'pre_cl-cs_nota-48_role-864000(2018)')
--			and de.codi_dime in ('CuadroResumenTabla'
--								,'ResultadoInversionesTabla'
--								,'InvetarioInversionesTabla')
--			and	 ic.codi_dein = de.codi_dein
--			and  ic.codi_dime = de.codi_dime
--			and	 dc1.codi_conc = ic.codi_conc
--			and  dc1.codi_lang = 'es_ES'
--			and	 dc2.codi_conc = de.codi_dime
--			and  dc2.codi_lang= 'es_ES'
--			and	 di.codi_info = de.codi_dein
--			and	 di.tipo_info = 'D'
--			and  di.codi_lang = 'es_ES'
--			) V
--group by PKConcepto
--order by 2,3,5

--update PF_03_Conceptos set Cuadro = '[851000] Nota 35 - Resultado de inversiones' where Cuadro = '[Dimensión][851000] Nota 35 - Resultado de inversiones'



/**************************************************************/
/*************************************************************
Es siguiente script de poblado de datos puede ser ejecutado acá pero es muy lento. 
Es mejor ejecutarlo directamente en prisma y luego copiar los datos

delete from PF_07_Valores
GO

insert into PF_07_Valores
select * from [192.168.14.5].dbax.dbo.PF_07_Valores
*************************************************************/
/**************************************************************/
/**************************************************************/

DECLARE @P_PERIODO VARCHAR(30)

declare curPeriodos cursor for
	select distinct substring( convert(varchar,corr_inst),1,4) + '-' + substring( convert(varchar,corr_inst),5,2)
	from [192.168.14.5].dbax.dbo.dbax_inst_docu
	where corr_inst = 201506
	order by 1

open curPeriodos
fetch next from curPeriodos into @P_PERIODO
while @@FETCH_STATUS = 0
begin
	select @P_PERIODO
	
	--Inserción de valores
	declare @vFiniCntx varchar(10)
	declare @vFfinCntx varchar(10)


	--SET @P_PERIODO = '2018-09'
	set @vFiniCntx = substring(@P_PERIODO,1,4) + '-01-01'
	if(substring(@P_PERIODO,6,2)='03' or substring(@P_PERIODO,6,2)='12')
	begin
		set @vFfinCntx = @P_PERIODO + '-31'
	end
	else
	begin
		set @vFfinCntx = @P_PERIODO + '-30'
	end

	select @vFiniCntx, @vFfinCntx

	--select @vFiniCntx, @vFfinCntx, @vFfinCntx2

	DECLARE @vCodiEmpr VARCHAR(20)
	DECLARE @vCorrInst VARCHAR(10)
	DECLARE @vCodiSegm VARCHAR(20)

	DECLARE curEmpresas CURSOR FOR
		SELECT codi_pers
			,replace(@P_PERIODO, '-', '')
			,codi_segm
		FROM [192.168.14.5].dbax.dbo.dbax_defi_pers
		WHERE codi_segm IN (
				'SEGUROVIDA'
				,'SEGUROGRAL'
				) 
		--and codi_pers = 700157302

	DECLARE @vRamo VARCHAR(300)
	DECLARE @vSubRamo VARCHAR(300)
	DECLARE @vCodiCntx VARCHAR(300)
	DECLARE @vCodiMemb VARCHAR(300)

	OPEN curEmpresas

	FETCH NEXT FROM curEmpresas INTO @vCodiEmpr,@vCorrInst,@vCodiSegm
	WHILE @@fetch_status = 0
	BEGIN

		delete from PF_07_Valores
		where PKEmpresa like '%' + @vCodiEmpr
		and Periodo = @P_PERIODO

		DECLARE @vVersInst VARCHAR(3)

		select @vVersInst = V.Version1 from 
			(select distinct top 1 isnull(max(vers_inst),'0') as Version1, isnull(max(vers_inst),'0') as Version2
			from	[192.168.14.5].dbax.dbo.dbax_inst_vers
			where	codi_pers = @vCodiEmpr
			and		corr_inst = @vCorrInst
			and     vers_inst < 30
			order by 1 desc) V

		print @vCodiEmpr + ', ' + @vCorrInst + ', ' + @vCodiSegm
		--select @vCodiEmpr,@vCorrInst ,@vCodiSegm, @P_PERIODO

		if(@vVersInst>0)
		begin
			--select  @vVersInst
			declare @vCodiAxis varchar(256)
			declare @vMiembroDefault varchar(256)
			declare @vPrefDefault varchar(5)
			declare @vCodiDime varchar(256)

			select		top 1 @vCodiAxis = me.codi_axis
							, @vCodiDime = dd.codi_dime
							, @vPrefDefault = me.pref_memb
							, @vMiembroDefault = me.codi_memb
			from		[192.168.14.5].dbax.dbo.dbax_dime_diax dd
						,[192.168.14.5].dbax.dbo.dbax_dime_memb me
			where		(		dd.codi_dein = 'pre_cl-cs_nota-35_role-851000(2018)'
							or  dd.codi_dein = 'pre_cl-cs_nota-35_role-851000(2017)'
						)
			and			dd.codi_dime = 'ResultadoInversionesTabla'
			and			dd.codi_axis = 'ResultadoInversionesEje'
			and			me.codi_axis = dd.codi_axis
			and			me.tipo_memb = 'dimension-default'
			order by	me.orde_memb asc

			--select @vCodiAxis, @vCodiDime, @vPrefDefault, @vMiembroDefault

			INSERT PF_07_Valores (Segmento, Periodo, PKEmpresa, PKConcepto, PKColumna, ValorPesos, ValorUF, ValorUSD)
			select Segmento, Periodo, PKEmpresa, PKConcepto, PKColumna, max(ValorPesos) ValorPesos, max(ValorUF) ValorUF, max(ValorUSD) ValorUSD
			--select distinct PKColumna
			from (
				select	 distinct @vCodiSegm as Segmento
							,@P_PERIODO Periodo
							,@vCodiSegm + '_' + convert(varchar,@vCodiEmpr) as PKEmpresa
							,ic.pref_conc + '_' + ic.codi_conc + '_' + dc.codi_dime as PKConcepto
							,isnull(replace(ix.codi_memb + '_' + dc.codi_dime,':','_'), @vPrefDefault + '_' + @vMiembroDefault + '_' + dc.codi_dime) PKColumna
							,convert(NUMERIC, replace(ic.valo_cntx, ',', '.')) AS ValorPesos
							,convert(NUMERIC, replace(ic.valo_refe, ',', '.')) AS ValorUF
							,convert(NUMERIC, replace(ic.valo_inte, ',', '.')) AS ValorUSD
				FROM [192.168.14.5].dbax.dbo.dbax_dime_conc dc
					,[192.168.14.5].dbax.dbo.dbax_inst_conc ic
					,[192.168.14.5].dbax.dbo.dbax_inst_cntx cn
					left join [192.168.14.5].dbax.dbo.dbax_inst_dicx ix
					on ix.codi_pers = cn.codi_pers
					AND ix.corr_inst = cn.corr_inst
					AND ix.vers_inst = cn.vers_inst
					AND ix.codi_cntx = cn.codi_cntx
					--AND IX.codi_axis = 'cl-cs:InvetarioInversionesEje'
				where	(		dc.codi_dein = 'pre_cl-cs_nota-35_role-851000(2018)'
							or  dc.codi_dein = 'pre_cl-cs_nota-35_role-851000(2017)'
						)
				and		dc.codi_dime = @vCodiDime
				AND		ic.codi_pers = @vCodiEmpr
				AND		ic.corr_inst = @vCorrInst
				AND		ic.vers_inst = @vVersInst
				AND		ic.pref_conc = dc.pref_conc
				AND		ic.codi_conc = dc.codi_conc
				and		cn.codi_pers = ic.codi_pers
				and		cn.corr_inst = ic.corr_inst
				and		cn.vers_inst = ic.vers_inst
				and		cn.codi_cntx = ic.codi_cntx
				and		(
							(cn.fini_cntx = @vFiniCntx and cn.ffin_cntx = @vFfinCntx)
							or
							(cn.fini_cntx = @vFfinCntx and isnull(cn.ffin_cntx,'') = '')
						)
				and (IX.codi_axis = 'cl-cs:ResultadoInversionesEje' or IX.codi_axis is null )
			) V
			group by Segmento, Periodo, PKEmpresa, PKConcepto, PKColumna

			select		top 1 @vCodiAxis = me.codi_axis
							, @vCodiDime = dd.codi_dime
							, @vPrefDefault = me.pref_memb
							, @vMiembroDefault = me.codi_memb
			from		[192.168.14.5].dbax.dbo.dbax_dime_diax dd
						,[192.168.14.5].dbax.dbo.dbax_dime_memb me
			where		(		dd.codi_dein = 'pre_cl-cs_nota-35_role-851000(2018)'
							or  dd.codi_dein = 'pre_cl-cs_nota-35_role-851000(2017)'
						)
			and			dd.codi_dime = 'CuadroResumenTabla'
			and			dd.codi_axis = 'ConceptoResultadoInversionesEje'
			and			me.codi_axis = dd.codi_axis
			and			me.tipo_memb = 'dimension-default'
			order by	me.orde_memb asc

			--select @vCodiAxis, @vPrefDefault, @vMiembroDefault

			INSERT PF_07_Valores (Segmento, Periodo, PKEmpresa, PKConcepto, PKColumna, ValorPesos, ValorUF, ValorUSD)
			select Segmento, Periodo, PKEmpresa, PKConcepto, PKColumna, max(ValorPesos) ValorPesos, max(ValorUF) ValorUF, max(ValorUSD) ValorUSD
			--select distinct PKColumna
			from (
				select	 distinct @vCodiSegm as Segmento
							,@P_PERIODO Periodo
							,@vCodiSegm + '_' + convert(varchar,@vCodiEmpr) as PKEmpresa
							,ic.pref_conc + '_' + ic.codi_conc + '_' + dc.codi_dime as PKConcepto
							,isnull(replace(ix.codi_memb + '_' + dc.codi_dime,':','_'), @vPrefDefault + '_' + @vMiembroDefault + '_' + dc.codi_dime) PKColumna
							,convert(NUMERIC, replace(ic.valo_cntx, ',', '.')) AS ValorPesos
							,convert(NUMERIC, replace(ic.valo_refe, ',', '.')) AS ValorUF
							,convert(NUMERIC, replace(ic.valo_inte, ',', '.')) AS ValorUSD
				FROM [192.168.14.5].dbax.dbo.dbax_dime_conc dc
					,[192.168.14.5].dbax.dbo.dbax_inst_conc ic
					,[192.168.14.5].dbax.dbo.dbax_inst_cntx cn
					left join [192.168.14.5].dbax.dbo.dbax_inst_dicx ix
					on ix.codi_pers = cn.codi_pers
					AND ix.corr_inst = cn.corr_inst
					AND ix.vers_inst = cn.vers_inst
					AND ix.codi_cntx = cn.codi_cntx
					--AND IX.codi_axis = 'cl-cs:InvetarioInversionesEje'
				where	(		dc.codi_dein = 'pre_cl-cs_nota-35_role-851000(2018)'
							or  dc.codi_dein = 'pre_cl-cs_nota-35_role-851000(2017)'
						)
				and		dc.codi_dime = @vCodiDime
				AND		ic.codi_pers = @vCodiEmpr
				AND		ic.corr_inst = @vCorrInst
				AND		ic.vers_inst = @vVersInst
				AND		ic.pref_conc = dc.pref_conc
				AND		ic.codi_conc = dc.codi_conc
				and		cn.codi_pers = ic.codi_pers
				and		cn.corr_inst = ic.corr_inst
				and		cn.vers_inst = ic.vers_inst
				and		cn.codi_cntx = ic.codi_cntx
				and		(
							(cn.fini_cntx = @vFiniCntx and cn.ffin_cntx = @vFfinCntx)
							or
							(cn.fini_cntx = @vFfinCntx and isnull(cn.ffin_cntx,'') = '')
						)
				and (IX.codi_axis = 'cl-cs:ConceptoResultadoInversionesEje' or IX.codi_axis is null )
			) V
			--except
			--select PKColumna collate Modern_Spanish_CI_AS from PF_04_Columnas
			group by Segmento, Periodo, PKEmpresa, PKConcepto, PKColumna

			select		top 1 @vCodiAxis = me.codi_axis
							, @vCodiDime = dd.codi_dime
							, @vPrefDefault = me.pref_memb
							, @vMiembroDefault = me.codi_memb
			from		[192.168.14.5].dbax.dbo.dbax_dime_diax dd
						,[192.168.14.5].dbax.dbo.dbax_dime_memb me
			where		(		dd.codi_dein = 'pre_cl-cs_nota-48_role-864000(2018)'
							or  dd.codi_dein = 'pre_cl-cs_nota-48_role-864000(2017)'
						)
			and			dd.codi_dime = 'InvetarioInversionesTabla'
			and			dd.codi_axis = 'InvetarioInversionesEje'
			and			me.codi_axis = dd.codi_axis
			and			me.tipo_memb = 'dimension-default'
			order by	me.orde_memb asc

			--select @vCodiAxis, @vPrefDefault, @vMiembroDefault
			
			INSERT PF_07_Valores (Segmento, Periodo, PKEmpresa, PKConcepto, PKColumna, ValorPesos, ValorUF, ValorUSD)
			select Segmento, Periodo, PKEmpresa, PKConcepto, PKColumna, max(ValorPesos) ValorPesos, max(ValorUF) ValorUF, max(ValorUSD) ValorUSD
			--select distinct PKColumna
			from (
				select	 distinct @vCodiSegm as Segmento
							,@P_PERIODO Periodo
							,@vCodiSegm + '_' + convert(varchar,@vCodiEmpr) as PKEmpresa
							,ic.pref_conc + '_' + ic.codi_conc + '_' + dc.codi_dime as PKConcepto
							,isnull(replace(ix.codi_memb + '_' + dc.codi_dime,':','_'), @vPrefDefault + '_' + @vMiembroDefault + '_' + dc.codi_dime) PKColumna
							,convert(NUMERIC, replace(ic.valo_cntx, ',', '.')) AS ValorPesos
							,convert(NUMERIC, replace(ic.valo_refe, ',', '.')) AS ValorUF
							,convert(NUMERIC, replace(ic.valo_inte, ',', '.')) AS ValorUSD
				FROM [192.168.14.5].dbax.dbo.dbax_dime_conc dc
					,[192.168.14.5].dbax.dbo.dbax_inst_conc ic
					,[192.168.14.5].dbax.dbo.dbax_inst_cntx cn
					left join [192.168.14.5].dbax.dbo.dbax_inst_dicx ix
					on ix.codi_pers = cn.codi_pers
					AND ix.corr_inst = cn.corr_inst
					AND ix.vers_inst = cn.vers_inst
					AND ix.codi_cntx = cn.codi_cntx
					--AND IX.codi_axis = 'cl-cs:InvetarioInversionesEje'
				where	(		dc.codi_dein = 'pre_cl-cs_nota-48_role-864000(2018)'
							or  dc.codi_dein = 'pre_cl-cs_nota-48_role-864000(2017)'
						)
				and		dc.codi_dime = @vCodiDime
				AND		ic.codi_pers = @vCodiEmpr
				AND		ic.corr_inst = @vCorrInst
				AND		ic.vers_inst = @vVersInst
				AND		ic.pref_conc = dc.pref_conc
				AND		ic.codi_conc = dc.codi_conc
				and		cn.codi_pers = ic.codi_pers
				and		cn.corr_inst = ic.corr_inst
				and		cn.vers_inst = ic.vers_inst
				and		cn.codi_cntx = ic.codi_cntx
				and		(
							(cn.fini_cntx = @vFiniCntx and cn.ffin_cntx = @vFfinCntx)
							or
							(cn.fini_cntx = @vFfinCntx and isnull(cn.ffin_cntx,'') = '')
						)
				and (IX.codi_axis = 'cl-cs:InvetarioInversionesEje' or IX.codi_axis is null )
			) V
			--except
			--select PKColumna collate Modern_Spanish_CI_AS from PF_04_Columnas
			group by Segmento, Periodo, PKEmpresa, PKConcepto, PKColumna				
		end
		FETCH NEXT FROM curEmpresas INTO @vCodiEmpr ,@vCorrInst,@vCodiSegm
	END

	CLOSE curEmpresas
	DEALLOCATE curEmpresas

	fetch next from curPeriodos into @P_PERIODO
end
close curPeriodos
deallocate curPeriodos


