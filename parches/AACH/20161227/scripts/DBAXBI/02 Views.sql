/****** Object:  View [dbo].[SG_07_Valores]    Script Date: 01/06/2017 13:50:10 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SG_07_Valores]'))
DROP VIEW [dbo].[SG_07_Valores]
GO
/****** Object:  View [dbo].[SV_07_Valores]    Script Date: 01/06/2017 13:50:10 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SV_07_Valores]'))
DROP VIEW [dbo].[SV_07_Valores]
GO
/****** Object:  View [dbo].[SV_02_Empresas]    Script Date: 01/06/2017 13:50:10 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SV_02_Empresas]'))
DROP VIEW [dbo].[SV_02_Empresas]
GO
/****** Object:  View [dbo].[SV_03_Conceptos]    Script Date: 01/06/2017 13:50:10 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SV_03_Conceptos]'))
DROP VIEW [dbo].[SV_03_Conceptos]
GO
/****** Object:  View [dbo].[SV_04_Ramos]    Script Date: 01/06/2017 13:50:10 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SV_04_Ramos]'))
DROP VIEW [dbo].[SV_04_Ramos]
GO
/****** Object:  View [dbo].[SV_05_SubRamos]    Script Date: 01/06/2017 13:50:10 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SV_05_SubRamos]'))
DROP VIEW [dbo].[SV_05_SubRamos]
GO
/****** Object:  View [dbo].[SG_02_Empresas]    Script Date: 01/06/2017 13:50:10 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SG_02_Empresas]'))
DROP VIEW [dbo].[SG_02_Empresas]
GO
/****** Object:  View [dbo].[SG_03_Conceptos]    Script Date: 01/06/2017 13:50:10 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SG_03_Conceptos]'))
DROP VIEW [dbo].[SG_03_Conceptos]
GO
/****** Object:  View [dbo].[SG_04_Ramos]    Script Date: 01/06/2017 13:50:10 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SG_04_Ramos]'))
DROP VIEW [dbo].[SG_04_Ramos]
GO
/****** Object:  View [dbo].[SG_05_SubRamos]    Script Date: 01/06/2017 13:50:10 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SG_05_SubRamos]'))
DROP VIEW [dbo].[SG_05_SubRamos]
GO
/****** Object:  View [dbo].[BI_SG_Conceptos]    Script Date: 01/06/2017 13:50:10 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[BI_SG_Conceptos]'))
DROP VIEW [dbo].[BI_SG_Conceptos]
GO
/****** Object:  View [dbo].[BI_SG_Empresas]    Script Date: 01/06/2017 13:50:10 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[BI_SG_Empresas]'))
DROP VIEW [dbo].[BI_SG_Empresas]
GO
/****** Object:  View [dbo].[BI_SG_Otros]    Script Date: 01/06/2017 13:50:10 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[BI_SG_Otros]'))
DROP VIEW [dbo].[BI_SG_Otros]
GO
/****** Object:  View [dbo].[BI_SG_Periodos]    Script Date: 01/06/2017 13:50:10 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[BI_SG_Periodos]'))
DROP VIEW [dbo].[BI_SG_Periodos]
GO
/****** Object:  View [dbo].[BI_SG_Ramos]    Script Date: 01/06/2017 13:50:10 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[BI_SG_Ramos]'))
DROP VIEW [dbo].[BI_SG_Ramos]
GO
/****** Object:  View [dbo].[BI_SG_Segmento]    Script Date: 01/06/2017 13:50:10 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[BI_SG_Segmento]'))
DROP VIEW [dbo].[BI_SG_Segmento]
GO
/****** Object:  View [dbo].[BI_SG_SubRamos]    Script Date: 01/06/2017 13:50:10 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[BI_SG_SubRamos]'))
DROP VIEW [dbo].[BI_SG_SubRamos]
GO
/****** Object:  View [dbo].[BI_SG_SubRamos]    Script Date: 01/06/2017 13:50:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[BI_SG_SubRamos]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [dbo].[BI_SG_SubRamos]
AS
SELECT     codi_conc COLLATE Modern_Spanish_CI_AS AS codiRamo, desc_ramo COLLATE Modern_Spanish_CI_AS AS descRamo, nume_ramo AS numeRamo, 
                      codi_segm COLLATE Modern_Spanish_CI_AS AS codiSegm
FROM         dbax.dbo.dbax_defi_ramo
WHERE     (tipo_ramo = ''S'') AND (codi_segm = ''SEGUROGRAL'') AND (codi_ramo <> ''0'')
UNION
SELECT     codi_conc COLLATE Modern_Spanish_CI_AS AS codi_ramo, desc_ramo COLLATE Modern_Spanish_CI_AS AS Expr1, nume_ramo, 
                      codi_segm COLLATE Modern_Spanish_CI_AS AS Expr2
FROM         dbax.dbo.dbax_defi_ramo AS dbax_defi_ramo_1
WHERE     (tipo_ramo = ''S'') AND (codi_segm = ''SEGUROVIDA'') AND (codi_ramo <> ''0'') AND (codi_conc IS NOT NULL)
UNION
SELECT     ''0'' COLLATE Modern_Spanish_CI_AS AS codi_ramo, ''Total Sub-Ramos'' COLLATE Modern_Spanish_CI_AS AS desc_ramo, ''0'' AS nume_ramo, 
                      codi_segm COLLATE Modern_Spanish_CI_AS AS Expr1
FROM         dbax.dbo.dbax_defi_segm
WHERE     (codi_segm LIKE ''SEGURO%'')

'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'BI_SG_SubRamos', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4[30] 2[40] 3) )"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 3
   End
   Begin DiagramPane = 
      PaneHidden = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 3945
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 5
         Column = 4380
         Alias = 1350
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'BI_SG_SubRamos'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'BI_SG_SubRamos', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'BI_SG_SubRamos'
GO
/****** Object:  View [dbo].[BI_SG_Segmento]    Script Date: 01/06/2017 13:50:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[BI_SG_Segmento]'))
EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [dbo].[BI_SG_Segmento]
AS
SELECT  codi_segm COLLATE Modern_Spanish_CI_AS codi_segm, desc_segm COLLATE Modern_Spanish_CI_AS desc_segm
from    dbax.dbo.dbax_defi_segm
WHERE   CODI_SEGM like ''SEGURO%''

'
GO
/****** Object:  View [dbo].[BI_SG_Ramos]    Script Date: 01/06/2017 13:50:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[BI_SG_Ramos]'))
EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [dbo].[BI_SG_Ramos]
AS
SELECT  codi_ramo COLLATE Modern_Spanish_CI_AS codi_ramo,
        desc_ramo COLLATE Modern_Spanish_CI_AS desc_ramo,
        codi_ramo_supe COLLATE Modern_Spanish_CI_AS codi_ramo_supe,
        codi_segm COLLATE Modern_Spanish_CI_AS codi_segm,
        codi_ramo COLLATE Modern_Spanish_CI_AS orde_ramo ,
        CONVERT(numeric(18,0), nume_ramo) nume_ramo
FROM    dbax.dbo.dbax_defi_ramo
WHERE   CODI_SEGM like ''SEGURO%''
AND     tipo_ramo = ''R''
AND     codi_ramo not like ''2012%''

'
GO
/****** Object:  View [dbo].[BI_SG_Periodos]    Script Date: 01/06/2017 13:50:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[BI_SG_Periodos]'))
EXEC dbo.sp_executesql @statement = N'




CREATE VIEW [dbo].[BI_SG_Periodos]
AS
SELECT	distinct
		dbax.dbo.dbax_bi_getPeriodo(ic.fini_cntx,ic.ffin_cntx) codi_cntx,
		dbax.dbo.dbax_bi_getPeriodo(ic.fini_cntx,ic.ffin_cntx) desc_cntx,
		dbax.dbo.dbax_bi_getPeriodo(ic.fini_cntx,ic.ffin_cntx) periodo
FROM   dbax.dbo.dbax_inst_cntx AS ic WITH (INDEX (IDX_dbax_inst_cntx))
WHERE  codi_pers in (select codi_pers from dbax.dbo.dbax_defi_pers where codi_segm like ''%SEGURO%'') 
AND	   (NOT EXISTS (SELECT  1
                    FROM    dbax.dbo.dbax_inst_dicx AS id
                    WHERE   id.codi_pers = ic.codi_pers 
					AND		id.corr_inst = ic.corr_inst 
					AND		id.vers_inst = ic.vers_inst 
					AND		id.codi_cntx = ic.codi_cntx))
and    substring(ic.fini_cntx,1,4) = substring(cast(corr_inst as varchar(6)),1,4)
--group by dbax.dbo.dbax_bi_getPeriodo(ic.fini_cntx,ic.ffin_cntx)




'
GO
/****** Object:  View [dbo].[BI_SG_Otros]    Script Date: 01/06/2017 13:50:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[BI_SG_Otros]'))
EXEC dbo.sp_executesql @statement = N'


CREATE VIEW [dbo].[BI_SG_Otros]
AS
select distinct codi_segm, codi_memb, desc_memb, orde_memb, codi_axis, desc_axis
	from (
select  ''SEGUROVIDA'' codi_segm,
		cast(m.codi_memb as varchar(50)) collate Modern_Spanish_CI_AS	codi_memb,
		replace(c2.desc_conc, ''[miembro]'','''')							desc_memb,
		m.orde_memb														orde_memb,
		cast(m.codi_axis as varchar(50)) collate Modern_Spanish_CI_AS	codi_axis,
		replace(c1.desc_conc, ''[eje]'','''')								desc_axis
from	dbax.dbo.dbax_dime_memb m,
		dbax.dbo.dbax_desc_conc c1,
		dbax.dbo.dbax_desc_conc c2
where	m.tipo_memb = ''domain-member''
and     c1.pref_conc = m.pref_axis
and     c1.codi_conc = m.codi_axis
and     c2.pref_conc = m.pref_memb
and     c2.codi_conc = m.codi_memb
and     exists (select  1
				from	dbax.dbo.dbax_dime_diax d
				where	d.codi_dein like ''%cuadro%''
				and     substring(d.codi_dein, charindex(''role'',d.codi_dein) + 5 + 5,1) = ''2''
				and     d.codi_axis = m.codi_axis)
UNION
select  ''SEGUROGRAL'' codi_segm,
		cast(m.codi_memb as varchar(50)) collate Modern_Spanish_CI_AS	codi_memb,
		replace(c2.desc_conc, ''[miembro]'','''')	desc_memb,
		m.orde_memb								orde_memb,
		cast(m.codi_axis as varchar(50)) collate Modern_Spanish_CI_AS	codi_axis,
		replace(c1.desc_conc, ''[eje]'','''')		desc_axis
from	dbax.dbo.dbax_dime_memb m,
		dbax.dbo.dbax_desc_conc c1,
		dbax.dbo.dbax_desc_conc c2
where	m.tipo_memb = ''domain-member''
and     c1.pref_conc = m.pref_axis
and     c1.codi_conc = m.codi_axis
and     c2.pref_conc = m.pref_memb
and     c2.codi_conc = m.codi_memb
and     exists (select  1
				from	dbax.dbo.dbax_dime_diax d
				where	d.codi_dein like ''%cuadro%''
				and     substring(d.codi_dein, charindex(''role'',d.codi_dein) + 5 + 5,1) = ''1''
				and     d.codi_axis = m.codi_axis)
) vista





'
GO
/****** Object:  View [dbo].[BI_SG_Empresas]    Script Date: 01/06/2017 13:50:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[BI_SG_Empresas]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [dbo].[BI_SG_Empresas]
AS
SELECT     CONVERT(varchar(15), codi_pers) COLLATE Modern_Spanish_CI_AS AS codi_pers, desc_pers COLLATE Modern_Spanish_CI_AS AS nomb_pers, 
                      codi_segm COLLATE Modern_Spanish_CI_AS AS codi_segm, rutt_pers, empr_vige
FROM         dbax.dbo.dbax_defi_pers
WHERE     (tipo_taxo = ''SEGUROS'') AND (codi_segm COLLATE Modern_Spanish_CI_AS LIKE ''SEGURO%'')

'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'BI_SG_Empresas', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "dbax_defi_pers (dbax.dbo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'BI_SG_Empresas'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'BI_SG_Empresas', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'BI_SG_Empresas'
GO
/****** Object:  View [dbo].[BI_SG_Conceptos]    Script Date: 01/06/2017 13:50:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[BI_SG_Conceptos]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [dbo].[BI_SG_Conceptos]
AS
SELECT DISTINCT 
                      CAST(codi_segm AS varchar(256)) COLLATE Modern_Spanish_CI_AS AS codi_segm, CAST(codi_conc AS varchar(512)) COLLATE Modern_Spanish_CI_AS
                       AS codi_conc, desc_conc COLLATE Modern_Spanish_CI_AS AS DescConc, desc_info COLLATE Modern_Spanish_CI_AS AS DescInfo, 
                      desc_dime COLLATE Modern_Spanish_CI_AS AS DescDime
FROM         (SELECT     ''SEGUROVIDA'' AS codi_segm, dbax.dbo.dbax_bi_getConcepto(''SEGUROVIDA'', cc.codi_conc) 
                                              + ''_'' + CAST(dc.codi_dime AS varchar(256)) COLLATE Modern_Spanish_CI_AS AS codi_conc, REPLACE(REPLACE(SUBSTRING(cc.desc_conc, 
                                              CHARINDEX(''0 '', cc.desc_conc), 256), ''0 '', ''''), ''  '', '' '') AS desc_conc, CASE de.letr_dime WHEN '''' THEN '''' ELSE ''['' + isnull(de.letr_dime, ''a'') 
                                              + ''] '' END + REPLACE(cc1.desc_conc, ''[tabla]'', '''') AS desc_dime, dc.codi_dein AS codi_conc1, dc.codi_dein AS codi_info, 
                                              SUBSTRING(CAST(fm.desc_info AS varchar(100)), 10, 256) COLLATE Modern_Spanish_CI_AS AS desc_info, dc.orde_conc
                       FROM          dbax.dbo.dbax_taxo_info AS fm INNER JOIN
                                              dbax.dbo.dbax_dime_diax AS dd ON fm.codi_info = dd.codi_dein INNER JOIN
                                              dbax.dbo.dbax_dime_conc AS dc ON dd.codi_dein = dc.codi_dein AND dd.codi_dime = dc.codi_dime INNER JOIN
                                              dbax.dbo.dbax_dime_defi AS de ON dd.codi_dein = de.codi_dein AND dd.pref_dime = de.pref_dime AND 
                                              dd.codi_dime = de.codi_dime INNER JOIN
                                              dbax.dbo.dbax_desc_conc AS cc ON dc.pref_conc = cc.pref_conc AND dc.codi_conc = cc.codi_conc INNER JOIN
                                              dbax.dbo.dbax_desc_conc AS cc1 ON dc.pref_dime = cc1.pref_conc AND dc.codi_dime = cc1.codi_conc
                       WHERE      (fm.codi_info LIKE ''%cuadro%'') AND (SUBSTRING(fm.codi_info, CHARINDEX(''role'', fm.codi_info) + 5 + 5, 1) = ''2'') AND 
                                              (cc.desc_conc NOT LIKE ''%partidas%'') AND (dc.orde_conc IN
                                                  (SELECT     MAX(orde_conc) AS Expr1
                                                    FROM          dbax.dbo.dbax_dime_conc AS dc1
                                                    WHERE      (codi_dein = dc.codi_dein) AND (codi_conc = dc.codi_conc)))
                       UNION
                       SELECT     ''SEGUROGRAL'' AS codi_segm, dbax.dbo.dbax_bi_getConcepto(''SEGUROGRAL'', cc.codi_conc) 
                                             + ''_'' + CAST(dc.codi_dime AS varchar(256)) COLLATE Modern_Spanish_CI_AS AS codi_conc, REPLACE(REPLACE(SUBSTRING(cc.desc_conc, 
                                             CHARINDEX(''0 '', cc.desc_conc), 256), ''0 '', ''''), ''  '', '' '') AS desc_conc, CASE de.letr_dime WHEN '''' THEN '''' ELSE ''['' + isnull(de.letr_dime, ''a'') 
                                             + ''] '' END + REPLACE(cc1.desc_conc, ''[tabla]'', '''') AS desc_dime, dc.codi_dein AS codi_conc1, dc.codi_dein AS codi_info, 
                                             SUBSTRING(CAST(fm.desc_info AS varchar(100)), 10, 256) COLLATE Modern_Spanish_CI_AS AS desc_info, dc.orde_conc
                       FROM         dbax.dbo.dbax_taxo_info AS fm INNER JOIN
                                             dbax.dbo.dbax_dime_diax AS dd ON fm.codi_info = dd.codi_dein INNER JOIN
                                             dbax.dbo.dbax_dime_conc AS dc ON dd.codi_dein = dc.codi_dein AND dd.codi_dime = dc.codi_dime INNER JOIN
                                             dbax.dbo.dbax_dime_defi AS de ON dd.codi_dein = de.codi_dein AND dd.pref_dime = de.pref_dime AND 
                                             dd.codi_dime = de.codi_dime INNER JOIN
                                             dbax.dbo.dbax_desc_conc AS cc ON dc.pref_conc = cc.pref_conc AND dc.codi_conc = cc.codi_conc INNER JOIN
                                             dbax.dbo.dbax_desc_conc AS cc1 ON dc.pref_dime = cc1.pref_conc AND dc.codi_dime = cc1.codi_conc
                       WHERE     (fm.codi_info LIKE ''%cuadro%'') AND (SUBSTRING(fm.codi_info, CHARINDEX(''role'', fm.codi_info) + 5 + 5, 1) = ''1'') AND 
                                             (cc.desc_conc NOT LIKE ''%partidas%'') AND (dc.orde_conc IN
                                                 (SELECT     MAX(orde_conc) AS Expr1
                                                   FROM          dbax.dbo.dbax_dime_conc AS dc1
                                                   WHERE      (codi_dein = dc.codi_dein) AND (codi_conc = dc.codi_conc)))) AS vista

'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'BI_SG_Conceptos', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[17] 4[24] 2[40] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "vista"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 227
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 1815
         Table = 1260
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'BI_SG_Conceptos'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'BI_SG_Conceptos', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'BI_SG_Conceptos'
GO
/****** Object:  View [dbo].[SG_05_SubRamos]    Script Date: 01/06/2017 13:50:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SG_05_SubRamos]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[SG_05_SubRamos]
AS
SELECT     *
FROM       dbo.PF_05_SubRamos
WHERE     (PKSubRamo LIKE ''SEGUROGRAL%'')
'
GO
/****** Object:  View [dbo].[SG_04_Ramos]    Script Date: 01/06/2017 13:50:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SG_04_Ramos]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[SG_04_Ramos]
AS
SELECT     *
FROM       dbo.PF_04_Ramos
WHERE     (PKRamo LIKE ''SEGUROGRAL%'')
'
GO
/****** Object:  View [dbo].[SG_03_Conceptos]    Script Date: 01/06/2017 13:50:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SG_03_Conceptos]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[SG_03_Conceptos]
AS
SELECT     PKConcepto, Cuadro, Tabla, CodigoConcepto, Concepto
FROM         dbo.PF_03_Conceptos
WHERE     (PKConcepto LIKE ''SEGUROGRAL%'')
'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'SG_03_Conceptos', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "PF_03_Conceptos"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 206
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'SG_03_Conceptos'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'SG_03_Conceptos', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'SG_03_Conceptos'
GO
/****** Object:  View [dbo].[SG_02_Empresas]    Script Date: 01/06/2017 13:50:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SG_02_Empresas]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[SG_02_Empresas]
AS
SELECT     *
FROM       dbo.PF_02_Empresas
WHERE     (PKEmpresa LIKE ''SEGUROGRAL%'')
'
GO
/****** Object:  View [dbo].[SV_05_SubRamos]    Script Date: 01/06/2017 13:50:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SV_05_SubRamos]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[SV_05_SubRamos]
AS
SELECT     *
FROM       dbo.PF_05_SubRamos
WHERE     (PKSubRamo LIKE ''SEGUROVIDA%'')
'
GO
/****** Object:  View [dbo].[SV_04_Ramos]    Script Date: 01/06/2017 13:50:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SV_04_Ramos]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[SV_04_Ramos]
AS
SELECT     *
FROM       dbo.PF_04_Ramos
WHERE     (PKRamo LIKE ''SEGUROVIDA%'')
'
GO
/****** Object:  View [dbo].[SV_03_Conceptos]    Script Date: 01/06/2017 13:50:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SV_03_Conceptos]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[SV_03_Conceptos]
AS
SELECT     PKConcepto, Cuadro, Tabla, CodigoConcepto, Concepto
FROM         dbo.PF_03_Conceptos
WHERE     (PKConcepto LIKE ''SEGUROVIDA%'')
'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'SV_03_Conceptos', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "PF_03_Conceptos"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 206
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 10
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'SV_03_Conceptos'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'SV_03_Conceptos', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'SV_03_Conceptos'
GO
/****** Object:  View [dbo].[SV_02_Empresas]    Script Date: 01/06/2017 13:50:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SV_02_Empresas]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[SV_02_Empresas]
AS
SELECT     PKEmpresa, Rut, RazonSocial, RazonSocialCompleta, Vigente
FROM         dbo.PF_02_Empresas
WHERE     (PKEmpresa LIKE ''SEGUROVIDA%'')
'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'SV_02_Empresas', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "PF_02_Empresas"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 229
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'SV_02_Empresas'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'SV_02_Empresas', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'SV_02_Empresas'
GO
/****** Object:  View [dbo].[SV_07_Valores]    Script Date: 01/06/2017 13:50:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SV_07_Valores]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[SV_07_Valores]
AS
SELECT     Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, PKSubRamo, ValorPesos, ValorUF, ValorUSD
FROM         dbo.PF_07_Valores
WHERE     (PKEmpresa LIKE ''SEGUROVIDA%'')
'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'SV_07_Valores', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "PF_07_Valores"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 10
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'SV_07_Valores'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'SV_07_Valores', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'SV_07_Valores'
GO
/****** Object:  View [dbo].[SG_07_Valores]    Script Date: 01/06/2017 13:50:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SG_07_Valores]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[SG_07_Valores]
AS
SELECT     *
FROM       dbo.PF_07_Valores
WHERE     (PKEmpresa LIKE ''SEGUROGRAL%'')
'
GO
