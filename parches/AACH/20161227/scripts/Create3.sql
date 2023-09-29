USE [dbaxBI]
GO
/****** Object:  StoredProcedure [dbo].[prc_bi_dbax_create_3]    Script Date: 01/03/2017 08:24:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<JGALDAMEZ>
-- Create date: <2014-03-06>
-- Description:	<2>
-- =============================================
ALTER PROCEDURE [dbo].[prc_bi_dbax_create_3] @P_PERIODO VARCHAR(30)
AS
SELECT getdate()
	,'INICIO CARGA PERIODO: ' + @P_PERIODO

DELETE PF_07_Valores
WHERE Periodo = @P_PERIODO;

DELETE PF_06_Periodos
WHERE CodigoPeriodo = @P_PERIODO;

BEGIN
	/*** Inserta PF_2_01_Segmentos ***/
	/*INSERT INTO	PF_01_Segmentos 
		SELECT 	* FROM BI_SG_Segmento A 
		where   not exists (select	1 
							from 	PF_01_Segmentos B 
							where   A.codi_segm  = B.Segmento
							and		A.desc_segm  = B.NombreSegmento)*/
	/*** Crea o Inserta PF_2_02_Empresas ***/
	--INSERT INTO PF_02_Empresas
	--SELECT codi_segm + '_' + codi_pers AS PKEmpresa
	--	,codi_pers AS Rut
	--	,nomb_pers AS RazonSocial
	--	,codi_pers + ' ' + nomb_pers AS RazonSocialCompleta
	--	,empr_vige AS Vigente
	--FROM BI_SG_Empresas A
	--WHERE NOT EXISTS (
	--		SELECT 1
	--		FROM PF_02_Empresas B
	--		WHERE A.codi_pers = B.Rut
	--		)

	--and     A.codi_segm + '_' + A.codi_pers = B.PKEmpresa
	--and		A.codi_pers = B.Rut
	--and		A.nomb_pers = B.RazonSocial
	--and		A.codi_pers + ' ' + A.nomb_pers	= B.RazonSocialCompleta
	--and		A.empr_vige = B.Vigente)
	/*** Crea o Inserta PF_2_03_Conceptos ***/
	/*INSERT INTO PF_03_Conceptos 
	select	codi_segm + '_' + codi_conc	as PKConcepto,
			descInfo			as Cuadro,
			descDime			as Tabla,
			codi_conc			as CodigoConcepto, 
			descConc			as Concepto 
	from BI_SG_Conceptos A
	where   not exists (select	1 
					from 	PF_03_Conceptos B 
					where	codi_segm + '_' + codi_conc	= PKConcepto
					and		descInfo = Cuadro
					and		descDime = Tabla
					and		codi_conc = CodigoConcepto
					and		descConc = Concepto)*/
	INSERT PF_03_Conceptos (
		PKConcepto
		,Cuadro
		,Tabla
		,CodigoConcepto
		,Concepto
		)
	SELECT DISTINCT CASE substring(dc.codi_dein, charindex('(', dc.codi_dein) - 1, 1)
			WHEN '1'
				THEN 'SEGUROGRAL'
			ELSE 'SEGUROVIDA'
			END + '_' + dc.pref_conc + '_' + dc.codi_conc + '_' + codi_dime AS PKConcepto
		,substring(di.desc_info, len(di.desc_info) - charindex(' ]', reverse(di.desc_info)) + 2, 10000) AS Cuadro
		,
		--di.desc_info,
		de2.desc_conc AS Tabla
		,CASE substring(dc.codi_dein, charindex('(', dc.codi_dein) - 1, 1)
			WHEN '1'
				THEN 'SEGUROGRAL'
			ELSE 'SEGUROVIDA'
			END + '_' + dc.pref_conc + '_' + dc.codi_conc + '_' + codi_dime AS CodigoConcepto
		,dbo.FU_PF_getMaxOrdenConcepto(dc.pref_conc, dc.codi_conc) + ' - ' + de.desc_conc AS Concepto
	--df.*
	FROM dbaxAach.dbo.dbax_dime_conc dc
		,dbaxAach.dbo.dbax_desc_conc de
		,dbaxAach.dbo.dbax_desc_info di
		,dbaxAach.dbo.dbax_desc_conc de2
		,dbaxAach.dbo.dbax_defi_conc df
	WHERE dc.codi_dein LIKE '%cuadro%'
		AND de.pref_conc = dc.pref_conc
		AND de.codi_conc = dc.codi_conc
		AND di.codi_info = dc.codi_dein
		AND di.codi_lang = 'es_ES'
		AND di.tipo_info = 'D'
		AND de2.pref_conc = dc.pref_dime
		AND de2.codi_conc = dc.codi_dime
		AND dc.pref_conc = df.pref_conc
		AND dc.codi_conc = df.codi_conc
		AND df.tipo_cuen != 'abstract'
		AND CASE substring(dc.codi_dein, charindex('(', dc.codi_dein) - 1, 1)
			WHEN '1'
				THEN 'SEGUROGRAL'
			ELSE 'SEGUROVIDA'
			END + '_' + dc.pref_conc + '_' + dc.codi_conc + '_' + codi_dime NOT IN (
			SELECT PKConcepto collate Modern_Spanish_CI_AS
			FROM PF_03_Conceptos
			)

	/*** Crea o Inserta PF_2_04_Ramos ***/
	/*INSERT INTO PF_04_Ramos 
	select	codi_segm + '_' + codi_ramo	as PKRamo, 
			codi_ramo			as CodigoRamo, 
			desc_ramo			as Ramo,
			nume_ramo			as NumeroRamo
	from BI_SG_Ramos A
	where   not exists (select	1 
					from 	PF_04_Ramos B 
					where codi_segm + '_' + codi_ramo	= PKRamo
					and codi_ramo = CodigoRamo
					and desc_ramo = Ramo
					and nume_ramo = NumeroRamo)*/
	/*** Crea o Inserta PF_2_05_SubRamos ***/
	/*INSERT INTO PF_05_SubRamos 
	select	distinct
			codiSegm + '_' + codiRamo	as PKSubRamo, 
			codiRamo			as CodigoSubRamo, 
			descRamo			as SubRamo,
			numeRamo			as NumeroSubRamo
	from BI_SG_SubRamos A
	where   not exists (select	1 
					from 	PF_05_SubRamos B 
					where codiSegm + '_' + codiRamo	= PKSubRamo
					and codiRamo = CodigoSubRamo
					and descRamo = SubRamo
					and numeRamo = NumeroSubRamo)				
	order by 1*/
	/*** Inserta PF_2_06_Periodos segun periodo ***/
	/*INSERT INTO PF_06_Periodos 
	select	distinct
			codi_cntx			as CodigoPeriodo, 
			desc_cntx			as Periodo
	from BI_SG_Periodos A
	where codi_cntx = @P_PERIODO
	order by codi_cntx*/
	INSERT INTO PF_06_Periodos (
		CodigoPeriodo
		,Periodo
		)
	VALUES (
		@P_PERIODO
		,@P_PERIODO
		)

	DECLARE @vCodiEmpr VARCHAR(20)
	DECLARE @vCorrInst VARCHAR(10)

	DECLARE curEmpresas CURSOR
	FOR
	SELECT codi_pers
		,replace(@P_PERIODO, '-', '')
	FROM dbaxAach.dbo.dbax_defi_pers
	WHERE codi_segm IN (
			'SEGUROVIDA'
			,'SEGUROGRAL'
			) 
	--and codi_pers not in (762125191,762634142,965792802,990120002,992890002,762821912)
	--and codi_pers in ('762125191')

	DECLARE @vRamo VARCHAR(300)
	DECLARE @vSubRamo VARCHAR(300)
	DECLARE @vCodiCntx VARCHAR(300)

	OPEN curEmpresas

	FETCH NEXT FROM curEmpresas INTO @vCodiEmpr,@vCorrInst

	WHILE @@fetch_status = 0
	BEGIN
		PRINT @vCodiEmpr

		DECLARE @vVersInst VARCHAR(3)

		SET @vVersInst = dbaxAach.dbo.FU_AX_getPersCorrVersInst(@vCodiEmpr, @vCorrInst, 'I', 'M')

		--DELETE
		--FROM PF_07_Valores
		--WHERE PKEmpresa LIKE '%[_]' + @vCodiEmpr
		--AND Periodo = @P_PERIODO

		DECLARE curContextos CURSOR
		FOR
		SELECT DISTINCT ic.codi_cntx
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
			AND dp.codi_pers = @vCodiEmpr
			AND dp.codi_segm = CASE substring(dc.codi_dein, charindex('(', dc.codi_dein) - 1, 1)
				WHEN '1'
					THEN 'SEGUROGRAL'
				ELSE 'SEGUROVIDA'
				END
			AND ic.codi_pers = dp.codi_pers
			AND ic.corr_inst = @vCorrInst
			AND ic.vers_inst = @vVersInst
			AND ic.pref_conc = dc.pref_conc
			AND ic.codi_conc = dc.codi_conc
			AND ic.codi_conc NOT IN (
				'RamosVida'
				,'RamosGenerales'
				)
			AND ix.codi_pers = ic.codi_pers
			AND ix.corr_inst = ic.corr_inst
			AND ix.vers_inst = ic.vers_inst
			AND ix.codi_cntx = ic.codi_cntx
			AND ix.codi_axis IN (
				'cl-cs:RamosEje'
				,'cl-cs:DetalleSubRamosEje'
				)
			
		OPEN curContextos

		FETCH NEXT FROM curContextos INTO @vCodiCntx

		WHILE @@fetch_status = 0
		BEGIN
			print @vCodiEmpr + ',' + @vCorrInst + ', ' + @vVersInst + ', cl-cs:RamosEje, ' + @vCodiCntx + ', R'
			SELECT @vRamo = dbo.FU_PF_ObtieneMiembro(@vCodiEmpr, @vCorrInst, @vVersInst, 'cl-cs:RamosEje', @vCodiCntx, 'R')

			SELECT @vSubRamo = dbo.FU_PF_ObtieneMiembro(@vCodiEmpr, @vCorrInst, @vVersInst, 'cl-cs:DetalleSubRamosEje', @vCodiCntx, 'S')
			print @vRamo + ', ' + @vSubRamo
			
			INSERT PF_07_Valores
			SELECT distinct Segmento
				,@P_PERIODO
				,Segmento + '_' + codi_pers AS PKEmpresa
				,Segmento + '_' + PKConcepto
				,Segmento + '_' + @vRamo AS PKRamo
				,Segmento + '_' + @vSubRamo AS PKSubRamo
				,ValorPesos
				,ValorUF
				,ValorUSD
			FROM (
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
					AND dp.codi_pers = @vCodiEmpr
					AND dp.codi_segm = CASE substring(dc.codi_dein, charindex('(', dc.codi_dein) - 1, 1)
						WHEN '1'
							THEN 'SEGUROGRAL'
						ELSE 'SEGUROVIDA'
						END
					AND ic.codi_pers = dp.codi_pers
					AND ic.corr_inst = @vCorrInst
					AND ic.vers_inst = @vVersInst
					AND ic.pref_conc = dc.pref_conc
					AND ic.codi_conc = dc.codi_conc
					AND ic.codi_conc NOT IN (
						'RamosVida'
						,'RamosGenerales'
						)
					AND ic.codi_cntx = @vCodiCntx
					AND ix.codi_pers = ic.codi_pers
					AND ix.corr_inst = ic.corr_inst
					AND ix.vers_inst = ic.vers_inst
					AND ix.codi_cntx = ic.codi_cntx
					AND ix.codi_axis IN (
						'cl-cs:RamosEje'
						,'cl-cs:DetalleSubRamosEje'
						)
				) V
			WHERE 1=1
				--@vSubRamo != '0'
				--AND @vRamo != '0'
				AND @vRamo != '421'
				AND @vRamo != '422'
			--except
			--select distinct PKRamo from PF_04_Ramos
			
			FETCH NEXT FROM curContextos INTO @vCodiCntx
		END

		CLOSE curContextos

		DEALLOCATE curContextos

		DECLARE curContextos CURSOR
		FOR
		SELECT DISTINCT ic.codi_cntx
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
			AND dp.codi_pers = @vCodiEmpr
			AND dp.codi_segm = CASE substring(dc.codi_dein, charindex('(', dc.codi_dein) - 1, 1)
				WHEN '1'
					THEN 'SEGUROGRAL'
				ELSE 'SEGUROVIDA'
				END
			AND ic.codi_pers = dp.codi_pers
			AND ic.corr_inst = @vCorrInst
			AND ic.vers_inst = @vVersInst
			AND ic.pref_conc = dc.pref_conc
			AND ic.codi_conc = dc.codi_conc
			AND ic.codi_conc NOT IN (
				'RamosVida'
				,'RentasVitaliciasEje'
				)
			AND ix.codi_pers = ic.codi_pers
			AND ix.corr_inst = ic.corr_inst
			AND ix.vers_inst = ic.vers_inst
			AND ix.codi_cntx = ic.codi_cntx
			AND ix.codi_axis = 'cl-cs:RentasVitaliciasEje'

		OPEN curContextos

		FETCH NEXT FROM curContextos INTO @vCodiCntx

		WHILE @@fetch_status = 0
		BEGIN
			SELECT @vRamo = dbo.FU_PF_ObtieneMiembro(@vCodiEmpr, @vCorrInst, @vVersInst, 'cl-cs:RamosEje', @vCodiCntx, 'R')

			SELECT @vSubRamo = dbo.FU_PF_ObtieneMiembro(@vCodiEmpr, @vCorrInst, @vVersInst, 'cl-cs:RentasVitaliciasEje', @vCodiCntx, 'S')

			INSERT PF_07_Valores
			SELECT Segmento
				,@P_PERIODO
				,Segmento + '_' + codi_pers AS PKEmpresa
				,Segmento + '_' + PKConcepto
				,Segmento + '_' + @vRamo AS PKRamo
				,Segmento + '_' + @vSubRamo AS PKSubRamo
				,ValorPesos
				,ValorUF
				,ValorUSD
			FROM (
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
					AND dp.codi_pers = @vCodiEmpr
					AND dp.codi_segm = CASE substring(dc.codi_dein, charindex('(', dc.codi_dein) - 1, 1)
						WHEN '1'
							THEN 'SEGUROGRAL'
						ELSE 'SEGUROVIDA'
						END
					AND ic.codi_pers = dp.codi_pers
					AND ic.corr_inst = @vCorrInst
					AND ic.vers_inst = @vVersInst
					AND ic.pref_conc = dc.pref_conc
					AND ic.codi_conc = dc.codi_conc
					AND ic.codi_conc NOT IN (
						'RamosVida'
						,'RentasVitaliciasEje'
						)
					AND ic.codi_cntx = @vCodiCntx
					AND ix.codi_pers = ic.codi_pers
					AND ix.corr_inst = ic.corr_inst
					AND ix.vers_inst = ic.vers_inst
					AND ix.codi_cntx = ic.codi_cntx
					AND ix.codi_axis = 'cl-cs:RentasVitaliciasEje'
				) V
			WHERE 1=1
				--AND @vSubRamo != '0'
				AND @vRamo != '421'
				AND @vRamo != '422'

			FETCH NEXT FROM curContextos INTO @vCodiCntx
		END
		CLOSE curContextos
		DEALLOCATE curContextos


		--Esto inserta los EEFF para el periodo en ejecución
		delete from PF_07_Valores where Periodo = @vCorrInst and PKConcepto like '%pre_cl-cs_eeff_role-[2,5,6]00000%'
		insert into PF_07_Valores (Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, PKSubRamo, ValorPesos)
		select distinct 
				A.codi_segm collate Latin1_General_CS_AS as Segmento,
				dbaxAach.dbo.dbax_bi_getPeriodo(F.fini_cntx,F.ffin_cntx) collate Latin1_General_CS_AS Periodo,
				A.codi_segm + '_' + E.codi_pers collate Latin1_General_CS_AS PKEmpresa,
				replace(A.codi_segm + '_' + dbaxAach.dbo.dbax_bi_getConcepto(B.codi_info,E.codi_conc),'(2013)','') collate Latin1_General_CS_AS PKConcepto,
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
		AND	  E.corr_inst = replace(@vCorrInst,'-','')
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
		AND   dbaxAach.dbo.dbax_bi_getPeriodo(F.fini_cntx,F.ffin_cntx) = @vCorrInst
		and  (dbaxAach.dbo.dbax_bi_getConcepto(B.codi_info,E.codi_conc) LIKE '%pre_cl-cs_eeff_role-200000(2013)%'
				or dbaxAach.dbo.dbax_bi_getConcepto(B.codi_info,E.codi_conc) LIKE '%pre_cl-cs_eeff_role-300000(2013)%'
				or dbaxAach.dbo.dbax_bi_getConcepto(B.codi_info,E.codi_conc) LIKE '%pre_cl-cs_eeff_role-500000(2013)%')

		FETCH NEXT FROM curEmpresas INTO @vCodiEmpr ,@vCorrInst
	END

	CLOSE curEmpresas

	DEALLOCATE curEmpresas

	SELECT getdate()
		,'FIN CARGA PERIODO: ' + @P_PERIODO
END
