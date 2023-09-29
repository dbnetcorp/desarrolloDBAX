USE dbaxBI
GO

--select top 1000 * from PF_07_Valores
--use dbaxAach
--GO
DECLARE @CorrInst VARCHAR(6)

DECLARE curPeriodos CURSOR FOR
	SELECT DISTINCT peri_conc
	FROM [dbaxAach].[dbo].[dbax_data_hira]
	WHERE 1=1
	and	peri_conc >= '199403'
	and	peri_conc <= '201112'
	ORDER BY peri_conc ASC

OPEN curPeriodos
	FETCH NEXT FROM curPeriodos INTO @CorrInst

	WHILE @@FETCH_STATUS = 0
	BEGIN
		print @CorrInst
	
		DELETE
		FROM	PF_07_Valores
		WHERE	Periodo = substring(@CorrInst, 1, 4) + '-' + substring(@CorrInst, 5, 4)
		and		PKConcepto like '%[_]cl-cs[_]VariacionReservasTecnicas[_]%'

		INSERT INTO PF_07_Valores (
			Segmento
			,Periodo
			,PKEmpresa
			,PKConcepto
			,PKramo
			,PKSubRamo
			,ValorPesos
			,ValorUF
			,ValorUSD
			)
		SELECT DISTINCT dp.codi_segm AS Segmento
			,substring(dh.[peri_conc], 1, 4) + '-' + substring(dh.[peri_conc], 5, 4) AS Periodo
			,dp.codi_segm + '_' + dh.[codi_pers] AS PKEmpresa
			,dp.codi_segm + '_cl-cs_' + dh.codi_conc + '_' + dc.codi_dime AS PKConcepto
			,dp.codi_segm + '_' + dh.[codi_ramo] AS PKRamo
			,dp.codi_segm + '_' + isnull(dh.sub_ramo, '0') collate Modern_Spanish_CS_AS AS PKSubRamo
			,dh.valo_base AS ValorPeso
			,dh.valo_refe AS ValorUF
			,dh.valo_extr AS ValorUSD
		FROM [dbaxAach].[dbo].[dbax_data_hira] dh
			,[dbaxAach].[dbo].[dbax_defi_pers] dp
			,[dbaxAach].[dbo].[dbax_dime_conc] dc
		WHERE dh.[peri_conc] = @CorrInst
			--AND dh.codi_pers = '992920002'
			AND dp.codi_pers = dh.codi_pers
			AND dh.codi_conc = dc.codi_conc
			and dh.codi_conc = 'VariacionReservasTecnicas'
			AND dc.codi_dein LIKE '%cuadro%'
			AND dp.codi_segm + '_cl-cs_' + dh.codi_conc collate Modern_Spanish_CI_AS + '_' + dc.codi_dime != 'SEGUROGRAL_cl-cs_VariacionOtrasReservasTecnicas_CuadroOtrasReservasTecnicasTablas'
			AND dp.codi_segm + '_cl-cs_' + dh.codi_conc collate Modern_Spanish_CI_AS + '_' + dc.codi_dime != 'SEGUROGRAL_cl-cs_OtrasReservasVoluntarias_CuadroOtrasReservasTecnicasTablas'
			AND dp.codi_segm + '_cl-cs_' + dh.codi_conc collate Modern_Spanish_CI_AS + '_' + dc.codi_dime != 'SEGUROVIDA_cl-cs_OtrasReservasVoluntarias_CuadroReservasTabla'
			AND dp.codi_segm + '_cl-cs_' + dh.codi_conc collate Modern_Spanish_CI_AS + '_' + dc.codi_dime != 'SEGUROVIDA_cl-cs_ReservaInsuficienciaPrimasNeta_CuadroReservasTabla'
			AND dp.codi_segm + '_cl-cs_' + dh.codi_conc collate Modern_Spanish_CI_AS + '_' + dc.codi_dime != 'SEGUROVIDA_cl-cs_ReservaRiesgoCursoNeta_CuadroReservasTabla'
			AND dp.codi_segm + '_' + dh.[codi_ramo] IN (
				SELECT PKRamo collate Modern_Spanish_CI_AS
				FROM dbo.PF_04_Ramos
				)
		FETCH NEXT FROM curPeriodos INTO @CorrInst
	END
CLOSE curPeriodos
DEALLOCATE curPeriodos