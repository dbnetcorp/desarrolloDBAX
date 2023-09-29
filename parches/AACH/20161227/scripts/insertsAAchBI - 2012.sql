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
	and	peri_conc >= '201212'
	and	peri_conc <= '201212'
	ORDER BY peri_conc ASC

OPEN curPeriodos
	FETCH NEXT FROM curPeriodos INTO @CorrInst

	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT @CorrInst

		--INSERT INTO PF_02_Empresas (
		--	PKEmpresa
		--	,Rut
		--	,RazonSocial
		--	,RazonSocialCompleta
		--	,Vigente
		--	)
		--SELECT CODI_SEGM + '_' + codi_pers
		--	,codi_pers
		--	,desc_pers
		--	,codi_pers + ' ' + desc_pers
		--	,'NO'
		--FROM [dbaxAach].[dbo].[dbax_defi_pers]
		--WHERE codi_pers IN (
		--		SELECT dh.[codi_pers] AS PKEmpresa
		--		FROM [dbaxAach].[dbo].[dbax_data_hira] dh
		--		WHERE dh.[peri_conc] = @CorrInst
				
		--		EXCEPT
				
		--		SELECT Rut collate Modern_Spanish_CI_AS
		--		FROM PF_02_Empresas
		--		)

		--Obtiene los conceptos a insertar		
		--SELECT DISTINCT dp.codi_segm + '_cl-cs_' + dh.codi_conc collate Modern_Spanish_CI_AS + '_' + dc.codi_dime
		--FROM [dbaxAach].[dbo].[dbax_data_hira] dh
		--	,[dbaxAach].[dbo].[dbax_defi_pers] dp
		--	,[dbaxAach].[dbo].[dbax_dime_conc] dc
		--WHERE dh.[peri_conc] = @CorrInst
		--AND dp.codi_pers = dh.codi_pers
		--AND dh.codi_conc = dc.codi_conc
		--AND dc.codi_dein LIKE '%uadro%'
		--	AND dp.codi_segm + '_cl-cs_' + dh.codi_conc collate Modern_Spanish_CI_AS + '_' + dc.codi_dime != 'SEGUROGRAL_cl-cs_VariacionOtrasReservasTecnicas_CuadroOtrasReservasTecnicasTablas'
		--	AND dp.codi_segm + '_cl-cs_' + dh.codi_conc collate Modern_Spanish_CI_AS + '_' + dc.codi_dime != 'SEGUROVIDA_cl-cs_OtrasReservasVoluntarias_CuadroReservasTabla'
		--	AND dp.codi_segm + '_cl-cs_' + dh.codi_conc collate Modern_Spanish_CI_AS + '_' + dc.codi_dime != 'SEGUROVIDA_cl-cs_ReservaInsuficienciaPrimasNeta_CuadroReservasTabla'
		--	AND dp.codi_segm + '_cl-cs_' + dh.codi_conc collate Modern_Spanish_CI_AS + '_' + dc.codi_dime != 'SEGUROVIDA_cl-cs_ReservaRiesgoCursoNeta_CuadroReservasTabla'
		--	AND dp.codi_segm + '_cl-cs_' + dh.codi_conc collate Modern_Spanish_CI_AS + '_' + dc.codi_dime != 'SEGUROGRAL_cl-cs_OtrasReservasVoluntarias_CuadroOtrasReservasTecnicasTablas'
		--and		dh.codi_conc = 'ReservaInsuficienciaPrimasNeta'
		
		--EXCEPT
		
		--SELECT *
		--FROM [PF_03_Conceptos]

		--insert into [PF_03_Conceptos]
		--SELECT	distinct dp.codi_segm + '_cl-cs_' + dh.codi_conc collate Modern_Spanish_CI_AS + '_' + dc.codi_dime as PKConcepto
		--		,substring(di.desc_info,21,1000) collate Modern_Spanish_CI_AS as Cuadros
		--		,di.desc_info collate Modern_Spanish_CI_AS as tabla
		--		,dp.codi_segm + '_cl-cs_' + dh.codi_conc collate Modern_Spanish_CI_AS + '_' + dc.codi_dime as CodigoConcepto
		--		,de.desc_conc collate Modern_Spanish_CI_AS as Concepto
		--		--,*
		--FROM [dbaxAach].[dbo].[dbax_data_hira] dh
		--   ,[dbaxAach].[dbo].[dbax_defi_pers] dp
		--   ,[dbaxAach].[dbo].[dbax_dime_conc] dc
		--   ,[dbaxAach].[dbo].[dbax_info_defi] id
		--   ,[dbaxAach].[dbo].[dbax_desc_info] di
		--   ,[dbaxAach].[dbo].[dbax_desc_conc] de
		--WHERE dh.[peri_conc] = @CorrInst
		--and   dp.codi_pers = dh.codi_pers
		--AND	dh.codi_conc = dc.codi_conc
		--and dc.codi_conc = 'PrimaAceptadaReservaRiesgoEnCurso'
		--and (dc.codi_dein like '%cuadro%')
		--and	dc.codi_dein = id.codi_info
		--and	di.codi_info = id.codi_info
		--and di.codi_lang = 'es_ES'
		--and de.codi_conc = dh.codi_conc
		--and	de.codi_lang = 'es_ES'
		----and dp.codi_segm + '_cl-cs_' + dh.codi_conc + '_' + dc.codi_dime in (
		----	SELECT dp.codi_segm + '_cl-cs_' + dh.codi_conc collate Modern_Spanish_CI_AS + '_' + dc.codi_dime as PKConcepto
		----	FROM [dbaxAach].[dbo].[dbax_data_hira] dh
		----	   ,[dbaxAach].[dbo].[dbax_defi_pers] dp
		----	   ,[dbaxAach].[dbo].[dbax_dime_conc] dc
		----	WHERE dh.[peri_conc] = @CorrInst
		----	and   dp.codi_pers = dh.codi_pers
		----	AND	dh.codi_conc = dc.codi_conc
		--	except
		--	select PKconcepto, Cuadro, Tabla, CodigoConcepto, Concepto from [PF_03_Conceptos]
		----)
--		--select top 10 * from [PF_03_Conceptos]
--		/****** Script for SelectTopNRows command from SSMS  ******/
		
		
		DELETE
		FROM PF_07_Valores
		WHERE Periodo = substring(@CorrInst, 1, 4) + '-' + substring(@CorrInst, 5, 4)
		
		
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
		SELECT DISTINCT 
			dp.codi_segm AS Segmento
			,substring(dh.[peri_conc], 1, 4) + '-' + substring(dh.[peri_conc], 5, 4) AS Periodo
			,dp.codi_segm + '_' + dh.[codi_pers] AS PKEmpresa
			,dp.codi_segm + '_cl-cs_' + dh.codi_conc collate Modern_Spanish_CI_AS + '_' + dc.codi_dime AS PKConcepto
			,dp.codi_segm + '_' + dh.[ramo_actu] AS PKRamo
			,dp.codi_segm + '_' + isnull(dh.sub_ramo, '0') collate Modern_Spanish_CS_AS AS PKSubRamo
			,dh.valo_base AS ValorPeso
			,dh.valo_refe AS ValorUF
			,dh.valo_extr AS ValorUSD
		FROM [dbaxAach].[dbo].[dbax_data_hira] dh
			,[dbaxAach].[dbo].[dbax_defi_pers] dp
			,[dbaxAach].[dbo].[dbax_dime_conc] dc
		WHERE dh.[peri_conc] = @CorrInst
			--AND dh.codi_pers = '992250001'
			AND dp.codi_pers = dh.codi_pers
			AND dh.codi_conc = dc.codi_conc
			AND dc.codi_dein LIKE '%cuadro%'
			AND dp.codi_segm + '_cl-cs_' + dh.codi_conc collate Modern_Spanish_CI_AS + '_' + dc.codi_dime != 'SEGUROGRAL_cl-cs_VariacionOtrasReservasTecnicas_CuadroOtrasReservasTecnicasTablas'
			AND dp.codi_segm + '_cl-cs_' + dh.codi_conc collate Modern_Spanish_CI_AS + '_' + dc.codi_dime != 'SEGUROGRAL_cl-cs_OtrasReservasVoluntarias_CuadroOtrasReservasTecnicasTablas'
			AND dp.codi_segm + '_cl-cs_' + dh.codi_conc collate Modern_Spanish_CI_AS + '_' + dc.codi_dime != 'SEGUROVIDA_cl-cs_OtrasReservasVoluntarias_CuadroReservasTabla'
			AND dp.codi_segm + '_cl-cs_' + dh.codi_conc collate Modern_Spanish_CI_AS + '_' + dc.codi_dime != 'SEGUROVIDA_cl-cs_ReservaInsuficienciaPrimasNeta_CuadroReservasTabla'
			AND dp.codi_segm + '_cl-cs_' + dh.codi_conc collate Modern_Spanish_CI_AS + '_' + dc.codi_dime != 'SEGUROVIDA_cl-cs_ReservaRiesgoCursoNeta_CuadroReservasTabla'
			--AND dp.codi_segm + '_' + dh.[ramo_actu] NOT IN (
			--	SELECT dp.codi_segm + '_' + dh.[ramo_actu] AS PKRamo
			--	FROM [dbaxAach].[dbo].[dbax_data_hira] dh
			--		,[dbaxAach].[dbo].[dbax_defi_pers] dp
			--	WHERE dh.[peri_conc] = @CorrInst
			--		AND dp.codi_pers = dh.codi_pers
			--	EXCEPT
			--	SELECT PKRamo collate Modern_Spanish_CI_AS
			--	FROM dbo.PF_04_Ramos
			--	)
			AND dp.codi_segm + '_' + dh.[ramo_actu] IN (
				SELECT PKRamo collate Modern_Spanish_CI_AS
				FROM dbo.PF_04_Ramos
				)
			--EXCEPT
			--SELECT PKconcepto
			--FROM [PF_03_Conceptos]
			
--		/* select * from dbax_defi_pers
--		 select * from dbax_defi_conc where codi_conc = 'SV_691000000'
--		 select * from dbax_dime_conc
		 
--		 use dbaxAach
--		 GO
--		 select * from dbax_defi_ramo where tipo_ramo = 'S'

--		use dbaxBI
--		GO 
--		select distinct top 1000 PKSubRamo from PF_07_Valores
--		*/
--		--insert into PF_02_Empresas (PKEmpresa, Rut, RazonSocial, RazonSocialCompleta, Vigente)
--		--SELECT distinct 'SEGUROVIDA_' + dh.codi_pers, dh.codi_pers, dh.codi_pers, dh.codi_pers, 'NO' FROM [dbaxAach].[dbo].[dbax_data_hira] dh
--		--except
--		--select 'SEGUROVIDA_' + codi_pers, codi_pers,codi_pers,codi_pers, 'NO' from [dbaxAach].[dbo].[dbax_defi_pers]
--		--select * from dbaxAach.dbo.dbax_dime_conc where codi_conc like '%OtrasReservasVoluntarias%'
--		--select * from dbaxAach.dbo.dbax_desc_conc where codi_conc like '%CuadroReservasTabla'
--		--select * from dbaxAach.dbo.dbax_dime_defi where codi_dime like '%CuadroReservasTabla'
--		--select * from dbaxAach.dbo.dbax_desc_info where codi_info in ('pre_cl-cs_cuadro-603_role-906051(2013)')
--		--select * from dbaxAach.dbo.dbax_desc_conc where codi_conc = 'NumeroDeAseguradosEnElPeriodoPorRamo'
		FETCH NEXT FROM curPeriodos INTO @CorrInst
	END

CLOSE curPeriodos

DEALLOCATE curPeriodos
	--set @CorrInst = '200212'




----SELECT dp.codi_segm + '_' + dh.[ramo_actu] AS PKRamo
----FROM [dbaxAach].[dbo].[dbax_data_hira] dh
----	,[dbaxAach].[dbo].[dbax_defi_pers] dp
----WHERE dh.[peri_conc] = '200012'
----	AND dp.codi_pers = dh.codi_pers
----EXCEPT
----SELECT PKRamo collate Modern_Spanish_CI_AS
----FROM dbo.PF_04_Ramos
----order by 1