USE [dbaxBI]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BI_SG_Conceptos]
AS
SELECT DISTINCT 
                      CAST(codi_segm AS varchar(256)) COLLATE Modern_Spanish_CI_AS AS codi_segm, CAST(codi_conc AS varchar(512)) COLLATE Modern_Spanish_CI_AS
                       AS codi_conc, desc_conc COLLATE Modern_Spanish_CI_AS AS DescConc, desc_info COLLATE Modern_Spanish_CI_AS AS DescInfo, 
                      desc_dime COLLATE Modern_Spanish_CI_AS AS DescDime
FROM         (SELECT     'SEGUROVIDA' AS codi_segm, dbax.dbo.dbax_bi_getConcepto('SEGUROVIDA', cc.codi_conc) 
                                              + '_' + CAST(dc.codi_dime AS varchar(256)) COLLATE Modern_Spanish_CI_AS AS codi_conc, REPLACE(REPLACE(SUBSTRING(cc.desc_conc, 
                                              CHARINDEX('0 ', cc.desc_conc), 256), '0 ', ''), '  ', ' ') AS desc_conc, CASE de.letr_dime WHEN '' THEN '' ELSE '[' + isnull(de.letr_dime, 'a') 
                                              + '] ' END + REPLACE(cc1.desc_conc, '[tabla]', '') AS desc_dime, dc.codi_dein AS codi_conc1, dc.codi_dein AS codi_info, 
                                              SUBSTRING(CAST(fm.desc_info AS varchar(100)), 10, 256) COLLATE Modern_Spanish_CI_AS AS desc_info, dc.orde_conc
                       FROM          dbax.dbo.dbax_taxo_info AS fm INNER JOIN
                                              dbax.dbo.dbax_dime_diax AS dd ON fm.codi_info = dd.codi_dein INNER JOIN
                                              dbax.dbo.dbax_dime_conc AS dc ON dd.codi_dein = dc.codi_dein AND dd.codi_dime = dc.codi_dime INNER JOIN
                                              dbax.dbo.dbax_dime_defi AS de ON dd.codi_dein = de.codi_dein AND dd.pref_dime = de.pref_dime AND 
                                              dd.codi_dime = de.codi_dime INNER JOIN
                                              dbax.dbo.dbax_desc_conc AS cc ON dc.pref_conc = cc.pref_conc AND dc.codi_conc = cc.codi_conc INNER JOIN
                                              dbax.dbo.dbax_desc_conc AS cc1 ON dc.pref_dime = cc1.pref_conc AND dc.codi_dime = cc1.codi_conc
                       WHERE      (fm.codi_info LIKE '%cuadro%') AND (SUBSTRING(fm.codi_info, CHARINDEX('role', fm.codi_info) + 5 + 5, 1) = '2') AND 
                                              (cc.desc_conc NOT LIKE '%partidas%') AND (dc.orde_conc IN
                                                  (SELECT     MAX(orde_conc) AS Expr1
                                                    FROM          dbax.dbo.dbax_dime_conc AS dc1
                                                    WHERE      (codi_dein = dc.codi_dein) AND (codi_conc = dc.codi_conc)))
                       UNION
                       SELECT     'SEGUROGRAL' AS codi_segm, dbax.dbo.dbax_bi_getConcepto('SEGUROGRAL', cc.codi_conc) 
                                             + '_' + CAST(dc.codi_dime AS varchar(256)) COLLATE Modern_Spanish_CI_AS AS codi_conc, REPLACE(REPLACE(SUBSTRING(cc.desc_conc, 
                                             CHARINDEX('0 ', cc.desc_conc), 256), '0 ', ''), '  ', ' ') AS desc_conc, CASE de.letr_dime WHEN '' THEN '' ELSE '[' + isnull(de.letr_dime, 'a') 
                                             + '] ' END + REPLACE(cc1.desc_conc, '[tabla]', '') AS desc_dime, dc.codi_dein AS codi_conc1, dc.codi_dein AS codi_info, 
                                             SUBSTRING(CAST(fm.desc_info AS varchar(100)), 10, 256) COLLATE Modern_Spanish_CI_AS AS desc_info, dc.orde_conc
                       FROM         dbax.dbo.dbax_taxo_info AS fm INNER JOIN
                                             dbax.dbo.dbax_dime_diax AS dd ON fm.codi_info = dd.codi_dein INNER JOIN
                                             dbax.dbo.dbax_dime_conc AS dc ON dd.codi_dein = dc.codi_dein AND dd.codi_dime = dc.codi_dime INNER JOIN
                                             dbax.dbo.dbax_dime_defi AS de ON dd.codi_dein = de.codi_dein AND dd.pref_dime = de.pref_dime AND 
                                             dd.codi_dime = de.codi_dime INNER JOIN
                                             dbax.dbo.dbax_desc_conc AS cc ON dc.pref_conc = cc.pref_conc AND dc.codi_conc = cc.codi_conc INNER JOIN
                                             dbax.dbo.dbax_desc_conc AS cc1 ON dc.pref_dime = cc1.pref_conc AND dc.codi_dime = cc1.codi_conc
                       WHERE     (fm.codi_info LIKE '%cuadro%') AND (SUBSTRING(fm.codi_info, CHARINDEX('role', fm.codi_info) + 5 + 5, 1) = '1') AND 
                                             (cc.desc_conc NOT LIKE '%partidas%') AND (dc.orde_conc IN
                                                 (SELECT     MAX(orde_conc) AS Expr1
                                                   FROM          dbax.dbo.dbax_dime_conc AS dc1
                                                   WHERE      (codi_dein = dc.codi_dein) AND (codi_conc = dc.codi_conc)))) AS vista
GO
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
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'BI_SG_Conceptos'
GO
