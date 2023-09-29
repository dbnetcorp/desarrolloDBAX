DECLARE @P_PERIODO VARCHAR(30)
SET @P_PERIODO = '2018-09'


SELECT getdate()
	,'INICIO CARGA PERIODO: ' + @P_PERIODO

--DELETE PF_06_Periodos
--WHERE CodigoPeriodo = @P_PERIODO;

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
	FROM dbax.dbo.dbax_dime_conc dc
		,dbax.dbo.dbax_desc_conc de
		,dbax.dbo.dbax_desc_info di
		,dbax.dbo.dbax_desc_conc de2
		,dbax.dbo.dbax_defi_conc df
	WHERE dc.codi_dein LIKE '%cuadro%906042(2018)'
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

	--INSERT INTO PF_06_Periodos (
	--	CodigoPeriodo
	--	,Periodo
	--	)
	--VALUES (
	--	@P_PERIODO
	--	,@P_PERIODO
	--	)

	DECLARE @vCodiEmpr VARCHAR(20)
	DECLARE @vCorrInst VARCHAR(10)

	DECLARE curEmpresas CURSOR FOR
		SELECT codi_pers
			,replace(@P_PERIODO, '-', '')
		FROM dbax.dbo.dbax_defi_pers
		WHERE codi_segm IN (
				'SEGUROVIDA'
				--,'SEGUROGRAL'
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

		SET @vVersInst = dbax.dbo.FU_AX_getPersCorrVersInst(@vCodiEmpr, @vCorrInst, 'I', 'M')

		--select @P_PERIODO

		DELETE
		--SELECT *
		FROM PF_07_Valores
		WHERE 1=1
		and PKEmpresa LIKE '%[_]' + @vCodiEmpr
		AND Periodo = @P_PERIODO
		AND PKConcepto like '%CostoRentasTabla'

		DECLARE curContextos CURSOR FOR
			SELECT DISTINCT ic.codi_cntx
			FROM dbax.dbo.dbax_info_defi id
				,dbax.dbo.dbax_dime_conc dc
				,dbax.dbo.dbax_defi_conc df
				,dbax.dbo.dbax_inst_conc ic
				,dbax.dbo.dbax_inst_dicx ix
				,dbax.dbo.dbax_defi_pers dp
			WHERE id.indi_vige = '1'
				AND id.tipo_info = 'D'
				AND id.codi_info LIKE '%cuadro%906042(2018)'
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
				AND ix.codi_memb not in  ('cl-cs:RentasVitaliciasPrevisionalesMiembro',
										  'cl-cs:SubtotalRentasVitaliciasPrevisionalesMiembro',
										  'cl-cs:InvalidezSISMiembro',
										  'cl-cs:SobrevivenciaSISMiembro')

		OPEN curContextos

		FETCH NEXT FROM curContextos INTO @vCodiCntx

		WHILE @@fetch_status = 0
		BEGIN
			--SELECT @vRamo = dbo.FU_PF_ObtieneMiembro(@vCodiEmpr, @vCorrInst, @vVersInst, 'cl-cs:RamosEje', @vCodiCntx, 'R')
			SELECT @vRamo = case dbo.FU_PF_ObtieneMiembro(@vCodiEmpr, @vCorrInst, @vVersInst, 'cl-cs:RentasVitaliciasEje', @vCodiCntx, 'S')
								when 'cl-cs:VejezNormalMiembro' then '4211'
								when 'cl-cs:VejezAnticipadaMiembro' then '4212'
								when 'cl-cs:VejezMiembro' then '421'
								when 'cl-cs:InvalidezTotalMiembro' then '4221'
								when 'cl-cs:InvalidezParcialMiembro' then '4222'
								when 'cl-cs:InvalidezMiembro' then '422'
								when 'cl-cs:SobrevivenciaMiembro' then '423'
								--when 'cl-cs:SubtotalRentasVitaliciasPrevisionalesMiembro' then 
								when 'cl-cs:Circular528Miembro' then '424'
								when 'cl-cs:RentasVitaliciasSISMiembro' then '420'
								--when 'cl-cs:RentasVitaliciasPrevisionalesMiembro' then 
								when 'cl-cs:RentasPrivadasMiembro' then '105'
								else dbo.FU_PF_ObtieneMiembro(@vCodiEmpr, @vCorrInst, @vVersInst, 'cl-cs:RentasVitaliciasEje', @vCodiCntx, 'S') end
			Set @vSubRamo = '0'

			select @vRamo, @vSubRamo

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
				FROM dbax.dbo.dbax_info_defi id
					,dbax.dbo.dbax_dime_conc dc
					,dbax.dbo.dbax_defi_conc df
					,dbax.dbo.dbax_inst_conc ic
					,dbax.dbo.dbax_inst_dicx ix
					,dbax.dbo.dbax_defi_pers dp
				WHERE id.indi_vige = '1'
					AND id.tipo_info = 'D'
					AND id.codi_info LIKE '%cuadro%906042(2018)'
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
				AND @vRamo != '421'
				AND @vRamo != '422'

			FETCH NEXT FROM curContextos INTO @vCodiCntx
		END

		CLOSE curContextos

		DEALLOCATE curContextos

		FETCH NEXT FROM curEmpresas INTO @vCodiEmpr ,@vCorrInst
	END

	CLOSE curEmpresas

	DEALLOCATE curEmpresas

	SELECT getdate(),'FIN CARGA PERIODO: ' + @P_PERIODO