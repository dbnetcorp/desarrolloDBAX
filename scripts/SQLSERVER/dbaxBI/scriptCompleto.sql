IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'dbaxBI')
CREATE USER [dbaxBI] FOR LOGIN [dbaxBI] WITH DEFAULT_SCHEMA=[dbo]
GO
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
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[BI_SG_Fact_Table]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[BI_SG_Fact_Table]
AS
SELECT     codi_segm COLLATE Modern_Spanish_CI_AS AS codiSegm, codi_ramo COLLATE Modern_Spanish_CI_AS AS codiRamo, 
                      sub_ramo COLLATE Modern_Spanish_CI_AS AS subRamo, codi_pers COLLATE Modern_Spanish_CI_AS AS codiPers, 
                      codi_conc COLLATE Modern_Spanish_CI_AS AS codiConc, codi_cntx, valo_cntx, valo_refe, valo_inte
FROM         (SELECT     CAST(p.codi_segm AS varchar(30)) COLLATE Modern_Spanish_CI_AS AS codi_segm, dbax.dbo.dbax_bi_getPeriodo(ir.fini_cntx, ir.ffin_cntx) 
                                              AS codi_cntx, CAST(ic.codi_pers AS varchar(30)) COLLATE Modern_Spanish_CI_AS AS codi_pers, 
                                              CAST(ir.codi_ramo AS varchar(30)) COLLATE Modern_Spanish_CI_AS AS codi_ramo, CAST(ISNULL(ir.codi_subr, ''0'') 
                                              AS varchar(50)) COLLATE Modern_Spanish_CI_AS AS sub_ramo, CAST(dbax.dbo.dbax_bi_getConcepto(p.codi_segm, cc.codi_conc) 
                                              + ''_'' + dc.codi_dime AS varchar(256)) COLLATE Modern_Spanish_CI_AS AS codi_conc, ic.valo_cntx, REPLACE(ic.valo_refe, '','', ''.'') 
                                              AS valo_refe, REPLACE(ic.valo_inte, '','', ''.'') AS valo_inte, '''' AS codi_ramoo
                       FROM          dbax.dbo.dbax_defi_pers AS p INNER JOIN
                                              dbo.ZZ_inst_conc AS ic ON p.codi_pers = ic.codi_pers INNER JOIN
                                              dbax.dbo.dbax_dime_conc AS dc ON ic.pref_conc = dc.pref_conc AND ic.codi_conc = dc.codi_conc INNER JOIN
                                              dbo.ZZ_inst_ramo AS ir ON ic.corr_inst = ir.corr_inst AND ic.codi_pers = ir.codi_pers AND ic.vers_inst = ir.vers_inst AND 
                                              ic.codi_cntx = ir.codi_cntx INNER JOIN
                                              dbax.dbo.dbax_desc_conc AS cc ON ic.pref_conc = cc.pref_conc AND ic.codi_conc = cc.codi_conc
                       WHERE      (p.codi_segm LIKE ''SEGURO%'') AND (dc.codi_dein LIKE ''%cuadro%'') AND (ic.vers_inst =
                                                  (SELECT     MAX(vers_inst) AS Expr1
                                                    FROM          dbax.dbo.dbax_inst_vers AS v
                                                    WHERE      (corr_inst = ic.corr_inst) AND (codi_pers = ic.codi_pers))) AND (ic.valo_cntx <> ''0'') AND (ir.corr_inst1 = ir.corr_inst)) AS tmp
' 
GO
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
         Begin Table = "tmp"
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
' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'BI_SG_Fact_Table'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'BI_SG_Fact_Table'

GO
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
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PF_01_Segmentos]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PF_01_Segmentos](
	[Segmento] [varchar](30) NOT NULL,
	[NombreSegmento] [varchar](100) NULL,
 CONSTRAINT [PK_Segmentos] PRIMARY KEY CLUSTERED 
(
	[Segmento] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PF_02_Empresas]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PF_02_Empresas](
	[PKEmpresa] [varchar](30) NOT NULL,
	[Rut] [varchar](15) NOT NULL,
	[RazonSocial] [varchar](100) NULL,
	[RazonSocialCompleta] [varchar](116) NULL,
	[Vigente] [varchar](10) NULL,
 CONSTRAINT [PK_Empresas] PRIMARY KEY CLUSTERED 
(
	[PKEmpresa] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PF_03_Conceptos]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PF_03_Conceptos](
	[PKConcepto] [varchar](256) NOT NULL,
	[Cuadro] [varchar](512) NOT NULL,
	[Tabla] [varchar](512) NOT NULL,
	[CodigoConcepto] [varchar](256) NOT NULL,
	[Concepto] [varchar](8000) NULL,
 CONSTRAINT [PK_Conceptos] PRIMARY KEY CLUSTERED 
(
	[PKConcepto] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PF_04_Ramos]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PF_04_Ramos](
	[PKRamo] [varchar](80) NOT NULL,
	[CodigoRamo] [varchar](50) NOT NULL,
	[Ramo] [varchar](80) NOT NULL,
	[NumeroRamo] [numeric](18, 0) NULL,
 CONSTRAINT [PK_Ramos] PRIMARY KEY CLUSTERED 
(
	[PKRamo] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PF_05_SubRamos]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PF_05_SubRamos](
	[PKSubRamo] [varchar](80) NOT NULL,
	[CodigoSubRamo] [varchar](50) NOT NULL,
	[SubRamo] [varchar](80) NOT NULL,
	[NumeroSubRamo] [varchar](10) NULL,
 CONSTRAINT [PK_SubRamos] PRIMARY KEY CLUSTERED 
(
	[PKSubRamo] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PF_06_Periodos]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PF_06_Periodos](
	[CodigoPeriodo] [varchar](256) NULL,
	[Periodo] [varchar](7) NOT NULL,
 CONSTRAINT [PK_Periodos] PRIMARY KEY CLUSTERED 
(
	[Periodo] DESC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[BI_SG_SubRamos]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[BI_SG_SubRamos]
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
' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'BI_SG_SubRamos'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'BI_SG_SubRamos'

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FU_PF_ObtieneMiembro]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[FU_PF_ObtieneMiembro] 
(
	-- Add the parameters for the function here
	@CodiPers varchar(16),
	@CorrInst numeric(10,0),
	@VersInst numeric(5,0),
	@CodiAxis varchar(256),
	@CodiCntx varchar(350),
	@Modo varchar(1)
)
RETURNS varchar(256)
AS
BEGIN
	DECLARE @vMiembro varchar(256)
	if(@Modo=''S'' and (@CodiAxis=''cl-cs:DetalleSubRamosEje'' or @CodiAxis=''cl-cs:RentasVitaliciasEje''))
	begin
			select	@vMiembro = codi_memb 
			from	dbax.dbo.dbax_inst_dicx 
			where	codi_pers = @CodiPers
			and		corr_inst = @CorrInst
			and		vers_inst = @VersInst
			and		codi_cntx = @CodiCntx
			and		codi_axis = @CodiAxis
		
		if(@vMiembro is null)
			set @vMiembro = ''0''
	end
	else
	if(@Modo=''R'' and @CodiAxis=''cl-cs:RamosEje'')
	begin
		/*select	@vMiembro = replace(replace(replace(replace(upper(dc.codi_memb),''TX'','''' ),'':'',''''),''C'',''''),''ITEM'','''')
		from	dbax.dbo.dbax_inst_dicx dc
		where	dc.codi_pers = @CodiPers
		and		dc.corr_inst = @CorrInst
		and		dc.vers_inst = @VersInst
		and		dc.codi_cntx = @CodiCntx
		and		dc.codi_axis = @CodiAxis*/

		select	@vMiembro = replace(replace(replace(replace(replace(replace(replace(upper(im.desc_memb),''TX'','''' ),'':'',''''),''C'',''''),''ITEM'',''''),'','',''''),''.'',''''),''RSA'','''')
		from	dbax.dbo.dbax_inst_dicx dc,
				dbax.dbo.dbax_inst_memb im
		where	dc.codi_pers = @CodiPers
		and		dc.corr_inst = @CorrInst
		and		dc.vers_inst = @VersInst
		and		dc.codi_cntx = @CodiCntx
		and		dc.codi_axis = @CodiAxis
		and		im.codi_pers collate Modern_Spanish_CI_AS = dc.codi_pers collate Modern_Spanish_CI_AS
		and		im.corr_inst = dc.corr_inst
		and		im.vers_inst = dc.vers_inst
		and		im.codi_memb collate Modern_Spanish_CI_AS = dc.codi_memb

		if(@vMiembro is null)
			set @vMiembro = ''0''
	end

	return @vMiembro
END



' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FU_PF_getMaxOrdenConcepto]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[FU_PF_getMaxOrdenConcepto] 
(
	@vPrefConc varchar(10),
	@vCodiConc varchar(256)
)
RETURNS varchar(10)
AS
BEGIN
	declare @vOrden varchar(10)

	select	@vOrden = isnull(max(orde_conc),''0'')
	from	dbax.dbo.dbax_dime_conc
	where	pref_conc = @vPrefConc
	and		codi_conc = @vCodiConc

	RETURN @vOrden
END


' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_PRUEBA]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[prc_PRUEBA] 
	
as

SET NOCOUNT ON

BEGIN

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name=''PF_2_06_Periodos'') 
	BEGIN
			CREATE TABLE [dbo].[PF_2_06_Periodos](
				[CodigoPeriodo] [varchar](256) COLLATE Modern_Spanish_CI_AS NULL,
				[Periodo] [varchar](7) COLLATE Modern_Spanish_CI_AS NOT NULL,
			CONSTRAINT [PK2_Periodos] PRIMARY KEY CLUSTERED 
			(
				[Periodo] DESC
			)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
			) ON [PRIMARY]

	END
ELSE
	BEGIN

	INSERT INTO PF_2_06_Periodos 
	select	distinct
			codi_cntx			as CodigoPeriodo, 
			desc_cntx			as Periodo
	from BI_SG_Periodos A
	where   not exists (select	1 
						from 	PF_2_06_Periodos B 
						where codi_cntx = CodigoPeriodo
						and   desc_cntx = Periodo
						)
	order by codi_cntx
	END
END




' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_bi_dbax_Fact_Table]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		<JGALDAMEZ>
-- Create date: <2014-03-06>
-- Description:	<Inserta>
-- =============================================
CREATE PROCEDURE [dbo].[prc_bi_dbax_Fact_Table] 
	
as

SET NOCOUNT ON

BEGIN

	select	codi_segm			as Segmento, 
		codi_cntx			as Periodo, 
		codi_segm + ''_'' + codi_pers	as PKEmpresa, 
		codi_segm + ''_'' + codi_conc	as PKConcepto, 
		codi_segm + ''_'' + codi_ramo	as PKRamo, 
		codi_segm + ''_'' + sub_ramo	as PKSubRamo, 
		valo_cntx			as ValorPesos, 
		valo_refe			as ValorUF, 
		valo_inte			as ValorUSD
	into    PF_07_Valores
	from	BI_SG_Fact_Table
	where	exists (select	1
			from	PF_04_Ramos
			where	PKRamo		= codi_segm + ''_'' + codi_ramo) 
	and     exists (select	1 
			from	PF_05_SubRamos
			where	PKSubRamo	= codi_segm + ''_'' + sub_ramo) 
	and     exists (select	1 
			from	PF_03_Conceptos 
			where	PKConcepto 	=  codi_segm + ''_'' + codi_conc)
					
	
	select getdate(), ''Tabla BI_SG_Fact_Table Creada''

	update	PF_07_Valores
	set	ValorPesos = replace(ValorPesos,'','','''')
	where	charindex('','',ValorPesos) > 1
	

	alter table PF_07_Valores alter column Segmento		varchar(30)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column Periodo		varchar(7)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column PKEmpresa	varchar(30)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column PKRamo		varchar(80)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column PKSubRamo	varchar(80)	collate Modern_Spanish_CI_AS
	alter table PF_07_Valores alter column PKConcepto	varchar(256)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column ValorPesos	numeric(38,4)
	alter table PF_07_Valores alter column ValorUF		numeric(38,4)
	alter table PF_07_Valores alter column ValorUsd		numeric(38,4)

	alter table PF_07_Valores WITH CHECK add constraint	Valores_FK_Segmentos
		FOREIGN KEY	(Segmento) REFERENCES PF_01_Segmentos (Segmento)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Segmentos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Periodos
		FOREIGN KEY (Periodo) REFERENCES PF_06_Periodos (Periodo)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Periodos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Empresas
		FOREIGN KEY	(PKEmpresa)	REFERENCES PF_02_Empresas  (PKEmpresa)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Empresas
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Ramos
		FOREIGN KEY (PKRamo) REFERENCES PF_04_Ramos (PKRamo)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Ramos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_SubRamos
		FOREIGN KEY (PKSubRamo) REFERENCES PF_05_SubRamos  (PKSubRamo)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_SubRamos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Conceptos
		FOREIGN KEY (PKConcepto) REFERENCES PF_03_Conceptos (PKConcepto)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Conceptos
	

	-- Limpia periodos
	delete	PF_06_Periodos
	from	PF_06_Periodos p
	where	not exists (select 1 from PF_07_Valores v where v.Periodo = p.Periodo)

	drop table dbo.ZZ_inst_ramo
	
	drop table dbo.ZZ_inst_conc
	

	select getdate(), ''Completando Totales''

	insert into PF_07_Valores (Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, PKSubRamo,ValorPesos, ValorUF, ValorUSD)
	select	Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, ''SEGUROGRAL_cl-cs:MasivoMiembro'' PKSubRamo, 
			sum(ValorPesos) ValorPesos, sum(ValorUF) ValorUF, sum(ValorUSD) ValorUSD
	from   PF_07_Valores v1
	where  not exists (select 1
					   from   PF_07_Valores v2
					   where  v2.Segmento = v1.Segmento
					   and	  v2.Periodo  = v1.Periodo
					   and    v2.PKEmpresa = v1.PKEmpresa
					   and    v2.PKConcepto = v1.PKConcepto
					   and    v2.PKRamo = v1.PKRamo
					   and	  v2.PKSubRamo = ''SEGUROGRAL_cl-cs:MasivoMiembro'')
	and   Segmento = ''SEGUROGRAL''
	and   (	PKSubRamo like ''%CarteraHipotecariaMiembro''
		or  PKSubRamo like ''%CarteraConsumoMiembro''
		or  PKSubRamo like ''%OtraCarteraMiembro'')
	group by Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo

	insert into PF_07_Valores (Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, PKSubRamo,ValorPesos, ValorUF, ValorUSD)
	select	Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, ''SEGUROVIDA_cl-cs:MasivoMiembro'' PKSubRamo, 
			sum(ValorPesos) ValorPesos, sum(ValorUF) ValorUF, sum(ValorUSD) ValorUSD
	from   PF_07_Valores v1
	where  not exists (select 1
					   from   PF_07_Valores v2
					   where  v2.Segmento = v1.Segmento
					   and	  v2.Periodo  = v1.Periodo
					   and    v2.PKEmpresa = v1.PKEmpresa
					   and    v2.PKConcepto = v1.PKConcepto
					   and    v2.PKRamo = v1.PKRamo
					   and	  v2.PKSubRamo = ''SEGUROVIDA_cl-cs:MasivoMiembro'')
	and   Segmento = ''SEGUROVIDA''
	and   (	PKSubRamo like ''%CarteraHipotecariaMiembro''
		or  PKSubRamo like ''%CarteraConsumoMiembro''
		or  PKSubRamo like ''%OtraCarteraMiembro'')
	group by Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo

	insert into PF_07_Valores (Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, PKSubRamo,ValorPesos, ValorUF, ValorUSD)
	select	Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, ''SEGUROGRAL_0'' PKSubRamo, 
			sum(ValorPesos) ValorPesos, sum(ValorUF) ValorUF, sum(ValorUSD) ValorUSD
	from   PF_07_Valores v1
	where  not exists (select 1
					   from   PF_07_Valores v2
					   where  v2.Segmento = v1.Segmento
					   and	  v2.Periodo  = v1.Periodo
					   and    v2.PKEmpresa = v1.PKEmpresa
					   and    v2.PKConcepto = v1.PKConcepto
					   and    v2.PKRamo = v1.PKRamo
					   and	  v2.PKSubRamo = ''SEGUROGRAL_0'')
	and   Segmento = ''SEGUROGRAL''
	and   (	PKSubRamo like ''%IndustriaInfraestructuraComercioMiembro''
		or  PKSubRamo like ''%IndividualesMiembro''
		or  PKSubRamo like ''%ColectivosMiembro''
		or  PKSubRamo like ''%MasivoMiembro''
		or  PKSubRamo like ''%PrevisionalesMiembro'')
	group by Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo

	insert into PF_07_Valores (Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, PKSubRamo,ValorPesos, ValorUF, ValorUSD)
	select	Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, ''SEGUROVIDA_0'' PKSubRamo, 
			sum(ValorPesos) ValorPesos, sum(ValorUF) ValorUF, sum(ValorUSD) ValorUSD
	from   PF_07_Valores v1
	where  not exists (select 1
					   from   PF_07_Valores v2
					   where  v2.Segmento = v1.Segmento
					   and	  v2.Periodo  = v1.Periodo
					   and    v2.PKEmpresa = v1.PKEmpresa
					   and    v2.PKConcepto = v1.PKConcepto
					   and    v2.PKRamo = v1.PKRamo
					   and	  v2.PKSubRamo = ''SEGUROVIDA_0'')
	and   Segmento = ''SEGUROVIDA''
	and   (	PKSubRamo like ''%IndustriaInfraestructuraComercioMiembro''
		or  PKSubRamo like ''%IndividualesMiembro''
		or  PKSubRamo like ''%ColectivosMiembro''
		or  PKSubRamo like ''%MasivoMiembro''
		or  PKSubRamo like ''%PrevisionalesMiembro'')
	group by Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo

	select getdate(), ''FIN''

END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_bi_dbax_Fact_Table_2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		<JGALDAMEZ>
-- Create date: <2014-03-06>
-- Description:	<Inserta>
-- =============================================
CREATE PROCEDURE [dbo].[prc_bi_dbax_Fact_Table_2] 
	
AS
SET NOCOUNT ON

BEGIN

	INSERT INTO PF_07_Valores 
	select	codi_segm			as Segmento, 
			codi_cntx			as Periodo, 
			codi_segm + ''_'' + codi_pers	as PKEmpresa, 
			codi_segm + ''_'' + codi_conc	as PKConcepto, 
			codi_segm + ''_'' + codi_ramo	as PKRamo, 
			codi_segm + ''_'' + sub_ramo	as PKSubRamo, 
			convert(numeric(38,4),replace(valo_cntx,'','',''''))			as ValorPesos, 
			convert(numeric(38,4), valo_refe)			as ValorUF, 
			convert(numeric(38,4), valo_inte)			as ValorUSD
		from	BI_SG_Fact_Table
		where	exists (select	1
						from	PF_04_Ramos
						where	PKRamo		= codi_segm + ''_'' + codi_ramo) 
		and     exists (select	1 
						from	PF_05_SubRamos
						where	PKSubRamo	= codi_segm + ''_'' + sub_ramo) 
		and     exists (select	1 
						from	PF_03_Conceptos 
						where	PKConcepto 	=  codi_segm + ''_'' + codi_conc)
	and		not exists (select	1 
							from 	PF_07_Valores B 
							where codi_segm = B.Segmento
							and codi_cntx = B.Periodo 
							and codi_segm + ''_'' + codi_pers = B.PKEmpresa
							and codi_segm + ''_'' + codi_conc	= B.PKConcepto
							and codi_segm + ''_'' + codi_ramo	= B.PKRamo 
							and codi_segm + ''_'' + sub_ramo  = B.PKSubRamo 
							and convert(numeric(38,4),replace(valo_cntx,'','','''')) = ValorPesos
							and convert(numeric(38,4), valo_refe) = ValorUF
							and convert(numeric(38,4), valo_inte) = ValorUSD
							)
					
	select getdate(), ''Tabla BI_SG_Fact_Table Creada''

	/*
	update	PF_07_Valores
	set	ValorPesos = replace(ValorPesos,'','','''')
	where	charindex('','',ValorPesos) > 1
	*/
	
	/*
	alter table PF_07_Valores alter column Segmento		varchar(30)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column Periodo		varchar(7)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column PKEmpresa	varchar(30)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column PKRamo		varchar(80)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column PKSubRamo	varchar(80)	collate Modern_Spanish_CI_AS
	alter table PF_07_Valores alter column PKConcepto	varchar(256)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column ValorPesos	numeric(38,4)
	alter table PF_07_Valores alter column ValorUF		numeric(38,4)
	alter table PF_07_Valores alter column ValorUsd		numeric(38,4)

	alter table PF_07_Valores WITH CHECK add constraint	Valores_FK_Segmentos
		FOREIGN KEY	(Segmento) REFERENCES PF_01_Segmentos (Segmento)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Segmentos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Periodos
		FOREIGN KEY (Periodo) REFERENCES PF_06_Periodos (Periodo)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Periodos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Empresas
		FOREIGN KEY	(PKEmpresa)	REFERENCES PF_02_Empresas  (PKEmpresa)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Empresas
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Ramos
		FOREIGN KEY (PKRamo) REFERENCES PF_04_Ramos (PKRamo)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Ramos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_SubRamos
		FOREIGN KEY (PKSubRamo) REFERENCES PF_05_SubRamos  (PKSubRamo)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_SubRamos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Conceptos
		FOREIGN KEY (PKConcepto) REFERENCES PF_03_Conceptos (PKConcepto)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Conceptos
	*/
	

	-- Limpia periodos
	delete	PF_06_Periodos
	from	PF_06_Periodos p
	where	not exists (select 1 from PF_07_Valores v where v.Periodo = p.Periodo)

	drop table dbo.ZZ_inst_ramo
	
	drop table dbo.ZZ_inst_conc
	

	select getdate(), ''Completando Totales''

	insert into PF_07_Valores (Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, PKSubRamo,ValorPesos, ValorUF, ValorUSD)
	select	Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, ''SEGUROGRAL_cl-cs:MasivoMiembro'' PKSubRamo, 
			sum(ValorPesos) ValorPesos, sum(ValorUF) ValorUF, sum(ValorUSD) ValorUSD
	from   PF_07_Valores v1
	where  not exists (select 1
					   from   PF_07_Valores v2
					   where  v2.Segmento = v1.Segmento
					   and	  v2.Periodo  = v1.Periodo
					   and    v2.PKEmpresa = v1.PKEmpresa
					   and    v2.PKConcepto = v1.PKConcepto
					   and    v2.PKRamo = v1.PKRamo
					   and	  v2.PKSubRamo = ''SEGUROGRAL_cl-cs:MasivoMiembro'')
	and   Segmento = ''SEGUROGRAL''
	and   (	PKSubRamo like ''%CarteraHipotecariaMiembro''
		or  PKSubRamo like ''%CarteraConsumoMiembro''
		or  PKSubRamo like ''%OtraCarteraMiembro'')
	group by Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo

	insert into PF_07_Valores (Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, PKSubRamo,ValorPesos, ValorUF, ValorUSD)
	select	Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, ''SEGUROVIDA_cl-cs:MasivoMiembro'' PKSubRamo, 
			sum(ValorPesos) ValorPesos, sum(ValorUF) ValorUF, sum(ValorUSD) ValorUSD
	from   PF_07_Valores v1
	where  not exists (select 1
					   from   PF_07_Valores v2
					   where  v2.Segmento = v1.Segmento
					   and	  v2.Periodo  = v1.Periodo
					   and    v2.PKEmpresa = v1.PKEmpresa
					   and    v2.PKConcepto = v1.PKConcepto
					   and    v2.PKRamo = v1.PKRamo
					   and	  v2.PKSubRamo = ''SEGUROVIDA_cl-cs:MasivoMiembro'')
	and   Segmento = ''SEGUROVIDA''
	and   (	PKSubRamo like ''%CarteraHipotecariaMiembro''
		or  PKSubRamo like ''%CarteraConsumoMiembro''
		or  PKSubRamo like ''%OtraCarteraMiembro'')
	group by Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo

	insert into PF_07_Valores (Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, PKSubRamo,ValorPesos, ValorUF, ValorUSD)
	select	Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, ''SEGUROGRAL_0'' PKSubRamo, 
			sum(ValorPesos) ValorPesos, sum(ValorUF) ValorUF, sum(ValorUSD) ValorUSD
	from   PF_07_Valores v1
	where  not exists (select 1
					   from   PF_07_Valores v2
					   where  v2.Segmento = v1.Segmento
					   and	  v2.Periodo  = v1.Periodo
					   and    v2.PKEmpresa = v1.PKEmpresa
					   and    v2.PKConcepto = v1.PKConcepto
					   and    v2.PKRamo = v1.PKRamo
					   and	  v2.PKSubRamo = ''SEGUROGRAL_0'')
	and   Segmento = ''SEGUROGRAL''
	and   (	PKSubRamo like ''%IndustriaInfraestructuraComercioMiembro''
		or  PKSubRamo like ''%IndividualesMiembro''
		or  PKSubRamo like ''%ColectivosMiembro''
		or  PKSubRamo like ''%MasivoMiembro''
		or  PKSubRamo like ''%PrevisionalesMiembro'')
	group by Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo

	insert into PF_07_Valores (Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, PKSubRamo,ValorPesos, ValorUF, ValorUSD)
	select	Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, ''SEGUROVIDA_0'' PKSubRamo, 
			sum(ValorPesos) ValorPesos, sum(ValorUF) ValorUF, sum(ValorUSD) ValorUSD
	from   PF_07_Valores v1
	where  not exists (select 1
					   from   PF_07_Valores v2
					   where  v2.Segmento = v1.Segmento
					   and	  v2.Periodo  = v1.Periodo
					   and    v2.PKEmpresa = v1.PKEmpresa
					   and    v2.PKConcepto = v1.PKConcepto
					   and    v2.PKRamo = v1.PKRamo
					   and	  v2.PKSubRamo = ''SEGUROVIDA_0'')
	and   Segmento = ''SEGUROVIDA''
	and   (	PKSubRamo like ''%IndustriaInfraestructuraComercioMiembro''
		or  PKSubRamo like ''%IndividualesMiembro''
		or  PKSubRamo like ''%ColectivosMiembro''
		or  PKSubRamo like ''%MasivoMiembro''
		or  PKSubRamo like ''%PrevisionalesMiembro'')
	group by Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo

	select getdate(), ''FIN''

END








' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[BI_SG_Conceptos]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[BI_SG_Conceptos]
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
' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'BI_SG_Conceptos'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'BI_SG_Conceptos'

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[BI_SG_Empresas]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [dbo].[BI_SG_Empresas]
AS
SELECT     CONVERT(varchar(15), codi_pers) COLLATE Modern_Spanish_CI_AS AS codi_pers,
		   desc_pers COLLATE Modern_Spanish_CI_AS AS nomb_pers,
		   codi_segm COLLATE Modern_Spanish_CI_AS codi_segm, 
		   rutt_pers COLLATE Modern_Spanish_CI_AS rutt_pers, 
		   empr_vige COLLATE Modern_Spanish_CI_AS empr_vige
FROM       dbax.dbo.dbax_defi_pers
WHERE     (tipo_taxo = ''SEGUROS'') AND (codi_segm LIKE ''SEGURO%'')
' 
GO
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
               Bottom = 114
               Right = 227
            End
            DisplayFlags = 280
            TopColumn = 5
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
' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'BI_SG_Empresas'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'BI_SG_Empresas'

GO
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
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PF_07_Valores]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PF_07_Valores](
	[Segmento] [varchar](30) NOT NULL,
	[Periodo] [varchar](7) NOT NULL,
	[PKEmpresa] [varchar](30) NOT NULL,
	[PKConcepto] [varchar](256) NOT NULL,
	[PKRamo] [varchar](80) NOT NULL,
	[PKSubRamo] [varchar](80) NULL,
	[ValorPesos] [numeric](38, 4) NULL,
	[ValorUF] [numeric](38, 4) NULL,
	[ValorUSD] [numeric](38, 4) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_bi_dbax_Fact_Table_3]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'




-- =============================================
-- Author:		<JGALDAMEZ>
-- Create date: <2014-03-06>
-- Description:	<Inserta>
-- =============================================
CREATE PROCEDURE [dbo].[prc_bi_dbax_Fact_Table_3] 
		@P_PERIODO VARCHAR(30)
AS
SET NOCOUNT ON

BEGIN

	
	INSERT INTO PF_07_Valores 
	select	codiSegm			as Segmento, 
			codi_cntx			as Periodo, 
			codiSegm + ''_'' + codiPers	as PKEmpresa, 
			codiSegm + ''_'' + codiConc	as PKConcepto, 
			codiSegm + ''_'' + codiRamo	as PKRamo, 
			codiSegm + ''_'' + subRamo	as PKSubRamo, 
			convert(numeric(38,4),replace(valo_cntx,'','',''''))			as ValorPesos, 
			convert(numeric(38,4), valo_refe)			as ValorUF, 
			convert(numeric(38,4), valo_inte)			as ValorUSD
		from	BI_SG_Fact_Table
		where	exists (select	1
						from	PF_04_Ramos
						where	PKRamo		= codiSegm + ''_'' + codiRamo) 
		/*and     exists (select	1 
						from	PF_05_SubRamos
						where	PKSubRamo	= codiSegm + ''_'' + subRamo) */
		and     exists (select	1 
						from	PF_03_Conceptos 
						where	PKConcepto 	=  codiSegm + ''_'' + codiConc)
	and		codi_cntx = 	@P_PERIODO
					
	select getdate(), ''Tabla BI_SG_Fact_Table Creada''

	/*
	update	PF_07_Valores
	set	ValorPesos = replace(ValorPesos,'','','''')
	where	charindex('','',ValorPesos) > 1
	*/
	
	/*
	alter table PF_07_Valores alter column Segmento		varchar(30)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column Periodo		varchar(7)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column PKEmpresa	varchar(30)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column PKRamo		varchar(80)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column PKSubRamo	varchar(80)	collate Modern_Spanish_CI_AS
	alter table PF_07_Valores alter column PKConcepto	varchar(256)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column ValorPesos	numeric(38,4)
	alter table PF_07_Valores alter column ValorUF		numeric(38,4)
	alter table PF_07_Valores alter column ValorUsd		numeric(38,4)

	alter table PF_07_Valores WITH CHECK add constraint	Valores_FK_Segmentos
		FOREIGN KEY	(Segmento) REFERENCES PF_01_Segmentos (Segmento)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Segmentos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Periodos
		FOREIGN KEY (Periodo) REFERENCES PF_06_Periodos (Periodo)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Periodos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Empresas
		FOREIGN KEY	(PKEmpresa)	REFERENCES PF_02_Empresas  (PKEmpresa)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Empresas
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Ramos
		FOREIGN KEY (PKRamo) REFERENCES PF_04_Ramos (PKRamo)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Ramos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_SubRamos
		FOREIGN KEY (PKSubRamo) REFERENCES PF_05_SubRamos  (PKSubRamo)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_SubRamos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Conceptos
		FOREIGN KEY (PKConcepto) REFERENCES PF_03_Conceptos (PKConcepto)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Conceptos
	*/
	

	-- Limpia periodos
	delete	PF_06_Periodos
	from	PF_06_Periodos p
	where	not exists (select 1 from PF_07_Valores v where v.Periodo = p.Periodo)

	drop table dbo.ZZ_inst_ramo
	
	drop table dbo.ZZ_inst_conc
	

	select getdate(), ''Completando Totales''

	insert into PF_07_Valores (Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, PKSubRamo,ValorPesos, ValorUF, ValorUSD)
	select	Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, ''SEGUROGRAL_cl-cs:MasivoMiembro'' PKSubRamo, 
			sum(ValorPesos) ValorPesos, sum(ValorUF) ValorUF, sum(ValorUSD) ValorUSD
	from   PF_07_Valores v1
	where  v1.Periodo = 	@P_PERIODO
	and   not exists (select 1
					   from   PF_07_Valores v2
					   where  v2.Segmento = v1.Segmento
					   and	  v2.Periodo  = v1.Periodo
					   and    v2.PKEmpresa = v1.PKEmpresa
					   and    v2.PKConcepto = v1.PKConcepto
					   and    v2.PKRamo = v1.PKRamo
					   and	  v2.PKSubRamo = ''SEGUROGRAL_cl-cs:MasivoMiembro'')
	and   Segmento = ''SEGUROGRAL''
	and   (	PKSubRamo like ''%CarteraHipotecariaMiembro''
		or  PKSubRamo like ''%CarteraConsumoMiembro''
		or  PKSubRamo like ''%OtraCarteraMiembro'')
	group by Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo

	insert into PF_07_Valores (Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, PKSubRamo,ValorPesos, ValorUF, ValorUSD)
	select	Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, ''SEGUROVIDA_cl-cs:MasivoMiembro'' PKSubRamo, 
			sum(ValorPesos) ValorPesos, sum(ValorUF) ValorUF, sum(ValorUSD) ValorUSD
	from   PF_07_Valores v1
	where	   v1.Periodo = 	@P_PERIODO
	and  not exists (select 1
					   from   PF_07_Valores v2
					   where  v2.Segmento = v1.Segmento
					   and	  v2.Periodo  = v1.Periodo
					   and    v2.PKEmpresa = v1.PKEmpresa
					   and    v2.PKConcepto = v1.PKConcepto
					   and    v2.PKRamo = v1.PKRamo
					   and	  v2.PKSubRamo = ''SEGUROVIDA_cl-cs:MasivoMiembro'')
	and   Segmento = ''SEGUROVIDA''
	and   (	PKSubRamo like ''%CarteraHipotecariaMiembro''
		or  PKSubRamo like ''%CarteraConsumoMiembro''
		or  PKSubRamo like ''%OtraCarteraMiembro'')
	group by Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo

	insert into PF_07_Valores (Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, PKSubRamo,ValorPesos, ValorUF, ValorUSD)
	select	Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, ''SEGUROGRAL_0'' PKSubRamo, 
			sum(ValorPesos) ValorPesos, sum(ValorUF) ValorUF, sum(ValorUSD) ValorUSD
	from   PF_07_Valores v1
	where	   v1.Periodo = 	@P_PERIODO
	and  not exists (select 1
					   from   PF_07_Valores v2
					   where  v2.Segmento = v1.Segmento
					   and	  v2.Periodo  = v1.Periodo
					   and    v2.PKEmpresa = v1.PKEmpresa
					   and    v2.PKConcepto = v1.PKConcepto
					   and    v2.PKRamo = v1.PKRamo
					   and	  v2.PKSubRamo = ''SEGUROGRAL_0'')
	and   Segmento = ''SEGUROGRAL''
	and   (	PKSubRamo like ''%IndustriaInfraestructuraComercioMiembro''
		or  PKSubRamo like ''%IndividualesMiembro''
		or  PKSubRamo like ''%ColectivosMiembro''
		or  PKSubRamo like ''%MasivoMiembro''
		or  PKSubRamo like ''%PrevisionalesMiembro'')
	group by Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo

	insert into PF_07_Valores (Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, PKSubRamo,ValorPesos, ValorUF, ValorUSD)
	select	Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, ''SEGUROVIDA_0'' PKSubRamo, 
			sum(ValorPesos) ValorPesos, sum(ValorUF) ValorUF, sum(ValorUSD) ValorUSD
	from   PF_07_Valores v1
	where	   v1.Periodo = 	@P_PERIODO
	and  not exists (select 1
					   from   PF_07_Valores v2
					   where  v2.Segmento = v1.Segmento
					   and	  v2.Periodo  = v1.Periodo
					   and    v2.PKEmpresa = v1.PKEmpresa
					   and    v2.PKConcepto = v1.PKConcepto
					   and    v2.PKRamo = v1.PKRamo
					   and	  v2.PKSubRamo = ''SEGUROVIDA_0'')
	and   Segmento = ''SEGUROVIDA''
	and   (	PKSubRamo like ''%IndustriaInfraestructuraComercioMiembro''
		or  PKSubRamo like ''%IndividualesMiembro''
		or  PKSubRamo like ''%ColectivosMiembro''
		or  PKSubRamo like ''%MasivoMiembro''
		or  PKSubRamo like ''%PrevisionalesMiembro'')
	group by Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo

	select getdate(), ''FIN CARGA PERIODO: '' + @P_PERIODO

END












' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_bi_dbax_create_2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'




-- =============================================
-- Author:		<JGALDAMEZ>
-- Create date: <2014-03-06>
-- Description:	<2>
-- =============================================
CREATE PROCEDURE [dbo].[prc_bi_dbax_create_2] 	
as

select getdate(), ''INICIO''
/*
	drop table PF_07_Valores
	drop table PF_06_Periodos
	drop table PF_05_SubRamos
  --drop table PF_05_Otros
	drop table PF_04_Ramos
	drop table PF_03_Conceptos
	drop table PF_02_Empresas
	drop table PF_01_Segmentos
*/
BEGIN
	
/*** Inserta PF_2_01_Segmentos ***/

		INSERT INTO	PF_01_Segmentos 
		SELECT 	* FROM BI_SG_Segmento A 
		where   not exists (select	1 
							from 	PF_01_Segmentos B 
							where   A.codi_segm  = B.Segmento
							and		A.desc_segm  = B.NombreSegmento)

/*** Crea o Inserta PF_2_02_Empresas ***/

		INSERT INTO PF_02_Empresas 
		SELECT 	codi_segm + ''_'' + codi_pers	as PKEmpresa, 
				codi_pers			as Rut, 
				nomb_pers			as RazonSocial,
				codi_pers + '' '' + nomb_pers	as RazonSocialCompleta,
				empr_vige			as Vigente FROM BI_SG_Empresas A 
		where   not exists (select	1 
					from 	PF_02_Empresas B 
					where	A.codi_pers = B.Rut
					and     A.codi_segm + ''_'' + A.codi_pers = B.PKEmpresa
					and		A.codi_pers = B.Rut
					and		A.nomb_pers = B.RazonSocial
					and		A.codi_pers + '' '' + A.nomb_pers	= B.RazonSocialCompleta
					and		A.empr_vige = B.Vigente)

/*** Crea o Inserta PF_2_03_Conceptos ***/

	INSERT INTO PF_03_Conceptos 
	select	codi_segm + ''_'' + codi_conc	as PKConcepto,
			desc_info			as Cuadro,
			desc_dime			as Tabla,
			codi_conc			as CodigoConcepto, 
			desc_conc			as Concepto 
	from BI_SG_Conceptos A
	where   not exists (select	1 
					from 	PF_03_Conceptos B 
					where	codi_segm + ''_'' + codi_conc	= PKConcepto
					and		desc_info = Cuadro
					and		desc_dime = Tabla
					and		codi_conc = CodigoConcepto
					and		desc_conc = Concepto)
	
/*** Crea o Inserta PF_2_04_Ramos ***/

	INSERT INTO PF_04_Ramos 
	select	codi_segm + ''_'' + codi_ramo	as PKRamo, 
			codi_ramo			as CodigoRamo, 
			desc_ramo			as Ramo,
			nume_ramo			as NumeroRamo
	from BI_SG_Ramos A
	where   not exists (select	1 
					from 	PF_04_Ramos B 
					where codi_segm + ''_'' + codi_ramo	= PKRamo
					and codi_ramo = CodigoRamo
					and desc_ramo = Ramo
					and nume_ramo = NumeroRamo)
	

/*** Crea o Inserta PF_2_05_SubRamos ***/

	INSERT INTO PF_05_SubRamos 
	select	distinct
			codi_segm + ''_'' + codi_ramo	as PKSubRamo, 
			codi_ramo			as CodigoSubRamo, 
			desc_ramo			as SubRamo,
			nume_ramo			as NumeroSubRamo
	from BI_SG_SubRamos A
	where   not exists (select	1 
					from 	PF_05_SubRamos B 
					where codi_segm + ''_'' + codi_ramo	= PKSubRamo
					and codi_ramo = CodigoSubRamo
					and desc_ramo = SubRamo
					and nume_ramo = NumeroSubRamo)				
	order by 1
	

/*** Crea o Inserta PF_2_06_Periodos ***/

	INSERT INTO PF_06_Periodos 
	select	distinct
			codi_cntx			as CodigoPeriodo, 
			desc_cntx			as Periodo
	from BI_SG_Periodos A
	where   not exists (select	1 
						from 	PF_06_Periodos B 
						where codi_cntx = CodigoPeriodo
						and   desc_cntx = Periodo)
	order by codi_cntx


	/*
	alter table PF_01_Segmentos	alter column	Segmento	varchar(30) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_01_Segmentos	add constraint	PK_Segmentos	PRIMARY KEY CLUSTERED (Segmento)
	
	alter table PF_02_Empresas	alter column	PKEmpresa	varchar(30) collate Modern_Spanish_CI_AS not null 
	alter table PF_02_Empresas	alter column	Rut		varchar(15) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_02_Empresas	add constraint	PK_Empresas	PRIMARY KEY CLUSTERED (PKEmpresa)
	
	alter table PF_04_Ramos		alter column	PKRamo		varchar(80) collate Modern_Spanish_CI_AS not null 
	alter table PF_04_Ramos		alter column	CodigoRamo	varchar(50) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_04_Ramos		add constraint	PK_Ramos	PRIMARY KEY CLUSTERED (PKRamo)
	
	alter table PF_05_SubRamos	alter column	PKSubRamo	varchar(80) collate Modern_Spanish_CI_AS not null 
	alter table PF_05_SubRamos	alter column	CodigoSubRamo	varchar(50) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_05_SubRamos	add constraint	PK_SubRamos	PRIMARY KEY CLUSTERED (PKSubRamo)
	
	alter table PF_03_Conceptos	alter column	PKConcepto	varchar(256) collate Modern_Spanish_CI_AS not null 
	alter table PF_03_Conceptos	alter column	CodigoConcepto	varchar(256) collate Modern_Spanish_CI_AS not null 
	alter table PF_03_Conceptos	alter column	Cuadro		varchar(512) collate Modern_Spanish_CI_AS not null 
	alter table PF_03_Conceptos	alter column	Tabla		varchar(512) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_03_Conceptos	add constraint	PK_Conceptos	PRIMARY KEY CLUSTERED (PKConcepto)
	
	alter table PF_06_Periodos	alter column	Periodo		varchar(7) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_06_Periodos	add constraint	PK_Periodos	PRIMARY KEY CLUSTERED (Periodo DESC)
	*/
	
	select getdate(), ''Tablas Basica Creadas''
	
	--drop table [ZZ_inst_ramo]
	--go
	CREATE TABLE	[dbo].[ZZ_inst_ramo](
		[codi_pers]	[varchar](16) 		COLLATE Modern_Spanish_CS_AS NOT NULL,
		[corr_inst]	[numeric](7, 0)		NOT NULL,
		[corr_inst1] [numeric](7, 0) 		NOT NULL,
		[vers_inst] [numeric](5, 0) 		NOT NULL,
		[codi_cntx] [varchar](256) 		COLLATE Modern_Spanish_CS_AS NOT NULL,
		[codi_axis] [varchar](256) 		COLLATE Modern_Spanish_CS_AS NOT NULL,
		[fini_cntx] [varchar](10) 		COLLATE Modern_Spanish_CS_AS NULL,
		[ffin_cntx] [varchar](10) 		COLLATE Modern_Spanish_CS_AS NULL,
		[ceje_ramo] [varchar](256) 		COLLATE Modern_Spanish_CS_AS NOT NULL,
		[codi_ramo] [varchar](256) 		COLLATE Modern_Spanish_CS_AS NULL,
		[desc_ramo] [varchar](256) 		COLLATE Modern_Spanish_CI_AS NULL,
		[ceje_subr] [varchar](256) 		COLLATE Modern_Spanish_CS_AS NULL,
		[codi_subr] [varchar](256) 		COLLATE Modern_Spanish_CS_AS NULL,
		[desc_subr] [varchar](256) 		COLLATE Modern_Spanish_CS_AS NULL
	) ON [PRIMARY]
	

	CREATE CLUSTERED INDEX [idx_ZZ_inst_ramo] ON ZZ_inst_ramo
	(
		[corr_inst] ASC,
		[codi_pers] ASC,
		[vers_inst] ASC,
		[codi_cntx] ASC
	)
	
	insert into ZZ_inst_ramo
	select	codi_pers, corr_inst, replace(substring(isnull(ffin_cntx,fini_cntx),1,7),''-'','''') corr_inst1,
		vers_inst, 
		codi_cntx, 
		codi_axis, fini_cntx, ffin_cntx, ceje_ramo, codi_ramo, desc_ramo, ceje_subr, codi_subr, desc_subr
	from	dbax.dbo.dbax_inst_ramo
	
	select getdate(), ''Tabla ZZ_inst_ramo Creada''

	--drop table dbo.ZZ_inst_conc
	--GO

	select	*
	into    ZZ_inst_conc
	from	dbax.dbo.dbax_inst_conc ic
	where   exists (select 1 from dbax.dbo.dbax_defi_pers d where d.codi_pers = ic.codi_pers and codi_segm like ''%SEGUR%'')
	and     exists (select 1 from dbax.dbo.dbax_dime_conc d where d.codi_conc = ic.codi_conc and d.codi_dein like ''%cuadro%'')
	and     exists (select 1 from ZZ_inst_ramo d where d.codi_cntx = ic.codi_cntx)
	

	CREATE CLUSTERED INDEX [idx_ZZ_inst_conc] ON [dbo].[ZZ_inst_conc] 
	(
		[corr_inst] ASC,
		[codi_pers] ASC,
		[vers_inst] ASC,
		[codi_conc] ASC,
		[codi_cntx] ASC
	)
	

	select getdate(), ''Tabla ZZ_inst_conc Creada''
	

	UPDATE	ZZ_inst_conc
	SET	valo_refe = convert(varchar(5000),replace(convert(numeric(38,4),convert(numeric(38,14),CAST(LTRIM(RTRIM(replace(valo_cntx,'','',''.'')))AS FLOAT)) / d.valo_camo),''.'','',''))
	FROM	ZZ_inst_conc i,
		dbax.dbo.dbax_inst_unit u,
		dbax.dbo.dbn_camb_mone d,
		dbax.dbo.dbn_defi_mone dm
	WHERE	u.codi_pers	= i.codi_pers
	AND	u.corr_inst	= i.corr_inst
	AND	u.vers_inst	= i.vers_inst
	AND	u.codi_unit	= i.codi_unit
	AND	i.corr_conc	= i.corr_conc
	AND	d.codi_mone	= ''CLP''
	AND	d.codi_mone1	= ''CLF''
	AND	substring(u.desc_unit, charindex('':'',u.desc_unit)+1,10) = dm.codi_mone
	AND	d.fech_camo = dbax.dbo.lastday(i.corr_inst)
	AND     exists (select 1 
			from dbax.dbo.dbax_defi_conc c 
			where c.pref_conc = i.pref_conc 
			and   c.codi_conc = i.codi_conc 
			and   c.tipo_valo = ''xbrli:monetaryItemType'')

	UPDATE	ZZ_inst_conc
	SET	valo_inte = convert(varchar(5000),replace(convert(numeric(38,4),convert(numeric(38,14),CAST(LTRIM(RTRIM(replace(valo_cntx,'','',''.'')))AS FLOAT)) / d.valo_camo),''.'','',''))
	FROM	ZZ_inst_conc i,
		dbax.dbo.dbax_inst_unit u,
		dbax.dbo.dbn_camb_mone d,
		dbax.dbo.dbn_defi_mone dm
	WHERE	u.codi_pers	= i.codi_pers
	AND	u.corr_inst	= i.corr_inst
	AND	u.vers_inst	= i.vers_inst
	AND	u.codi_unit	= i.codi_unit
	AND	i.corr_conc	= i.corr_conc
	AND	d.codi_mone	= ''CLP''
	AND	d.codi_mone1	= ''USD''
	AND	substring(u.desc_unit, charindex('':'',u.desc_unit)+1,10) = dm.codi_mone
	AND	d.fech_camo = dbax.dbo.lastday(i.corr_inst)
	AND     exists (select 1 
			from dbax.dbo.dbax_defi_conc c 
			where c.pref_conc = i.pref_conc 
			and   c.codi_conc = i.codi_conc 
			and   c.tipo_valo = ''xbrli:monetaryItemType'')

	UPDATE	ZZ_inst_conc
	SET	valo_refe = valo_cntx,
		valo_inte = valo_cntx
	FROM	ZZ_inst_conc i
	WHERE	exists (select 1 
			from dbax.dbo.dbax_defi_conc c 
			where c.pref_conc = i.pref_conc 
			and   c.codi_conc = i.codi_conc 
			and   c.tipo_valo != ''xbrli:monetaryItemType'');
	
	select getdate(), ''Valores de Cambio Actualizados''

	exec prc_bi_dbax_Fact_Table_2;	

END







' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_bi_dbax_create]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


-- =============================================
-- Author:		<JGALDAMEZ>
-- Create date: <2014-03-06>
-- Description:	<Crea tablas y las llena a partir de las vistas,
--				 aca se elimina y se inserta todo sin filtros>
-- =============================================
CREATE PROCEDURE [dbo].[prc_bi_dbax_create] 
	
as

select getdate(), ''INICIO''

	drop table PF_07_Valores
	drop table PF_06_Periodos
	drop table PF_05_SubRamos
	--drop table PF_05_Otros
	drop table PF_04_Ramos
	drop table PF_03_Conceptos
	drop table PF_02_Empresas
	drop table PF_01_Segmentos

BEGIN
	
select	codi_segm			as Segmento, 
			desc_segm			as NombreSegmento 
	into	PF_01_Segmentos
	from 	BI_SG_Segmento
	

	select	codi_segm + ''_'' + codi_pers	as PKEmpresa, 
			codi_pers			as Rut, 
			nomb_pers			as RazonSocial,
			codi_pers + '' '' + nomb_pers	as RazonSocialCompleta,
			empr_vige			as Vigente
	into	PF_02_Empresas
	from	BI_SG_Empresas
	

	select	codi_segm + ''_'' + codi_conc	as PKConcepto,
			desc_info			as Cuadro,
			desc_dime			as Tabla,
			codi_conc			as CodigoConcepto, 
			desc_conc			as Concepto 
	into	PF_03_Conceptos 
	from BI_SG_Conceptos
	

	select	codi_segm + ''_'' + codi_ramo	as PKRamo, 
			codi_ramo			as CodigoRamo, 
			desc_ramo			as Ramo,
			nume_ramo			as NumeroRamo
	into	PF_04_Ramos
	from BI_SG_Ramos
	

	select	distinct
			codi_segm + ''_'' + codi_ramo	as PKSubRamo, 
			codi_ramo			as CodigoSubRamo, 
			desc_ramo			as SubRamo,
			nume_ramo			as NumeroSubRamo
	into	PF_05_SubRamos
	from BI_SG_SubRamos
	order by 1
	

	select	distinct
			codi_cntx			as CodigoPeriodo, 
			desc_cntx			as Periodo
	into	PF_06_Periodos
	from BI_SG_Periodos
	order by codi_cntx
	

	alter table PF_01_Segmentos	alter column	Segmento	varchar(30) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_01_Segmentos	add constraint	PK_Segmentos	PRIMARY KEY CLUSTERED (Segmento)
	
	alter table PF_02_Empresas	alter column	PKEmpresa	varchar(30) collate Modern_Spanish_CI_AS not null 
	alter table PF_02_Empresas	alter column	Rut		varchar(15) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_02_Empresas	add constraint	PK_Empresas	PRIMARY KEY CLUSTERED (PKEmpresa)
	
	alter table PF_04_Ramos		alter column	PKRamo		varchar(80) collate Modern_Spanish_CI_AS not null 
	alter table PF_04_Ramos		alter column	CodigoRamo	varchar(50) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_04_Ramos		add constraint	PK_Ramos	PRIMARY KEY CLUSTERED (PKRamo)
	
	alter table PF_05_SubRamos	alter column	PKSubRamo	varchar(80) collate Modern_Spanish_CI_AS not null 
	alter table PF_05_SubRamos	alter column	CodigoSubRamo	varchar(50) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_05_SubRamos	add constraint	PK_SubRamos	PRIMARY KEY CLUSTERED (PKSubRamo)
	
	alter table PF_03_Conceptos	alter column	PKConcepto	varchar(256) collate Modern_Spanish_CI_AS not null 
	alter table PF_03_Conceptos	alter column	CodigoConcepto	varchar(256) collate Modern_Spanish_CI_AS not null 
	alter table PF_03_Conceptos	alter column	Cuadro		varchar(512) collate Modern_Spanish_CI_AS not null 
	alter table PF_03_Conceptos	alter column	Tabla		varchar(512) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_03_Conceptos	add constraint	PK_Conceptos	PRIMARY KEY CLUSTERED (PKConcepto)
	
	alter table PF_06_Periodos	alter column	Periodo		varchar(7) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_06_Periodos	add constraint	PK_Periodos	PRIMARY KEY CLUSTERED (Periodo DESC)
	
	select getdate(), ''Tablas Basica Creadas''
	
	--drop table [ZZ_inst_ramo]
	--go
	CREATE TABLE	[dbo].[ZZ_inst_ramo](
		[codi_pers]	[varchar](16) 		COLLATE Modern_Spanish_CS_AS NOT NULL,
		[corr_inst]	[numeric](7, 0)		NOT NULL,
		[corr_inst1] [numeric](7, 0) 		NOT NULL,
		[vers_inst] [numeric](5, 0) 		NOT NULL,
		[codi_cntx] [varchar](256) 		COLLATE Modern_Spanish_CS_AS NOT NULL,
		[codi_axis] [varchar](256) 		COLLATE Modern_Spanish_CS_AS NOT NULL,
		[fini_cntx] [varchar](10) 		COLLATE Modern_Spanish_CS_AS NULL,
		[ffin_cntx] [varchar](10) 		COLLATE Modern_Spanish_CS_AS NULL,
		[ceje_ramo] [varchar](256) 		COLLATE Modern_Spanish_CS_AS NOT NULL,
		[codi_ramo] [varchar](256) 		COLLATE Modern_Spanish_CS_AS NULL,
		[desc_ramo] [varchar](256) 		COLLATE Modern_Spanish_CI_AS NULL,
		[ceje_subr] [varchar](256) 		COLLATE Modern_Spanish_CS_AS NULL,
		[codi_subr] [varchar](256) 		COLLATE Modern_Spanish_CS_AS NULL,
		[desc_subr] [varchar](256) 		COLLATE Modern_Spanish_CS_AS NULL
	) ON [PRIMARY]
	

	CREATE CLUSTERED INDEX [idx_ZZ_inst_ramo] ON ZZ_inst_ramo
	(
		[corr_inst] ASC,
		[codi_pers] ASC,
		[vers_inst] ASC,
		[codi_cntx] ASC
	)
	
	insert into ZZ_inst_ramo
	select	codi_pers, corr_inst, replace(substring(isnull(ffin_cntx,fini_cntx),1,7),''-'','''') corr_inst1,
		vers_inst, 
		codi_cntx, 
		codi_axis, fini_cntx, ffin_cntx, ceje_ramo, codi_ramo, desc_ramo, ceje_subr, codi_subr, desc_subr
	from	dbax.dbo.dbax_inst_ramo
	
	select getdate(), ''Tabla ZZ_inst_ramo Creada''

	--drop table dbo.ZZ_inst_conc
	--GO

	select	*
	into    ZZ_inst_conc
	from	dbax.dbo.dbax_inst_conc ic
	where   exists (select 1 from dbax.dbo.dbax_defi_pers d where d.codi_pers = ic.codi_pers and codi_segm like ''%SEGUR%'')
	and     exists (select 1 from dbax.dbo.dbax_dime_conc d where d.codi_conc = ic.codi_conc and d.codi_dein like ''%cuadro%'')
	and     exists (select 1 from ZZ_inst_ramo d where d.codi_cntx = ic.codi_cntx)
	

	CREATE CLUSTERED INDEX [idx_ZZ_inst_conc] ON [dbo].[ZZ_inst_conc] 
	(
		[corr_inst] ASC,
		[codi_pers] ASC,
		[vers_inst] ASC,
		[codi_conc] ASC,
		[codi_cntx] ASC
	)
	

	select getdate(), ''Tabla ZZ_inst_conc Creada''
	

	UPDATE	ZZ_inst_conc
	SET	valo_refe = convert(varchar(5000),replace(convert(numeric(38,4),convert(numeric(38,14),CAST(LTRIM(RTRIM(replace(valo_cntx,'','',''.'')))AS FLOAT)) / d.valo_camo),''.'','',''))
	FROM	ZZ_inst_conc i,
		dbax.dbo.dbax_inst_unit u,
		dbax.dbo.dbn_camb_mone d,
		dbax.dbo.dbn_defi_mone dm
	WHERE	u.codi_pers	= i.codi_pers
	AND	u.corr_inst	= i.corr_inst
	AND	u.vers_inst	= i.vers_inst
	AND	u.codi_unit	= i.codi_unit
	AND	i.corr_conc	= i.corr_conc
	AND	d.codi_mone	= ''CLP''
	AND	d.codi_mone1	= ''CLF''
	AND	substring(u.desc_unit, charindex('':'',u.desc_unit)+1,10) = dm.codi_mone
	AND	d.fech_camo = dbax.dbo.lastday(i.corr_inst)
	AND     exists (select 1 
			from dbax.dbo.dbax_defi_conc c 
			where c.pref_conc = i.pref_conc 
			and   c.codi_conc = i.codi_conc 
			and   c.tipo_valo = ''xbrli:monetaryItemType'')

	UPDATE	ZZ_inst_conc
	SET	valo_inte = convert(varchar(5000),replace(convert(numeric(38,4),convert(numeric(38,14),CAST(LTRIM(RTRIM(replace(valo_cntx,'','',''.'')))AS FLOAT)) / d.valo_camo),''.'','',''))
	FROM	ZZ_inst_conc i,
		dbax.dbo.dbax_inst_unit u,
		dbax.dbo.dbn_camb_mone d,
		dbax.dbo.dbn_defi_mone dm
	WHERE	u.codi_pers	= i.codi_pers
	AND	u.corr_inst	= i.corr_inst
	AND	u.vers_inst	= i.vers_inst
	AND	u.codi_unit	= i.codi_unit
	AND	i.corr_conc	= i.corr_conc
	AND	d.codi_mone	= ''CLP''
	AND	d.codi_mone1	= ''USD''
	AND	substring(u.desc_unit, charindex('':'',u.desc_unit)+1,10) = dm.codi_mone
	AND	d.fech_camo = dbax.dbo.lastday(i.corr_inst)
	AND     exists (select 1 
			from dbax.dbo.dbax_defi_conc c 
			where c.pref_conc = i.pref_conc 
			and   c.codi_conc = i.codi_conc 
			and   c.tipo_valo = ''xbrli:monetaryItemType'')

	UPDATE	ZZ_inst_conc
	SET	valo_refe = valo_cntx,
		valo_inte = valo_cntx
	FROM	ZZ_inst_conc i
	WHERE	exists (select 1 
			from dbax.dbo.dbax_defi_conc c 
			where c.pref_conc = i.pref_conc 
			and   c.codi_conc = i.codi_conc 
			and   c.tipo_valo != ''xbrli:monetaryItemType'');
	
	select getdate(), ''Valores de Cambio Actualizados''

	exec prc_bi_dbax_Fact_Table;	

END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_bi_dbax_create_3]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


-- =============================================
-- Author:		<JGALDAMEZ>
-- Create date: <2014-03-06>
-- Description:	<2>
-- =============================================
CREATE PROCEDURE [dbo].[prc_bi_dbax_create_3] 	

	@P_PERIODO VARCHAR(30)
as

	select getdate(), ''INICIO CARGA PERIODO: '' + @P_PERIODO 

	delete PF_07_Valores
	where Periodo = @P_PERIODO;

	delete PF_06_Periodos
	where CodigoPeriodo = @P_PERIODO;

BEGIN
	
/*** Inserta PF_2_01_Segmentos ***/

		/*INSERT INTO	PF_01_Segmentos 
		SELECT 	* FROM BI_SG_Segmento A 
		where   not exists (select	1 
							from 	PF_01_Segmentos B 
							where   A.codi_segm  = B.Segmento
							and		A.desc_segm  = B.NombreSegmento)*/
		

/*** Crea o Inserta PF_2_02_Empresas ***/

		INSERT INTO PF_02_Empresas 
		SELECT 	codi_segm + ''_'' + codi_pers	as PKEmpresa, 
				codi_pers			as Rut, 
				nomb_pers			as RazonSocial,
				codi_pers + '' '' + nomb_pers	as RazonSocialCompleta,
				empr_vige			as Vigente FROM BI_SG_Empresas A 
		where   not exists (select	1 
					from 	PF_02_Empresas B 
					where	A.codi_pers = B.Rut
					and     A.codi_segm + ''_'' + A.codi_pers = B.PKEmpresa
					and		A.codi_pers = B.Rut
					and		A.nomb_pers = B.RazonSocial
					and		A.codi_pers + '' '' + A.nomb_pers	= B.RazonSocialCompleta
					and		A.empr_vige = B.Vigente)

/*** Crea o Inserta PF_2_03_Conceptos ***/

	/*INSERT INTO PF_03_Conceptos 
	select	codi_segm + ''_'' + codi_conc	as PKConcepto,
			descInfo			as Cuadro,
			descDime			as Tabla,
			codi_conc			as CodigoConcepto, 
			descConc			as Concepto 
	from BI_SG_Conceptos A
	where   not exists (select	1 
					from 	PF_03_Conceptos B 
					where	codi_segm + ''_'' + codi_conc	= PKConcepto
					and		descInfo = Cuadro
					and		descDime = Tabla
					and		codi_conc = CodigoConcepto
					and		descConc = Concepto)*/

	insert PF_03_Conceptos (PKConcepto,Cuadro,Tabla,CodigoConcepto, Concepto)
	select	distinct case substring(dc.codi_dein,charindex(''('',dc.codi_dein)-1,1) when ''1''  then ''SEGUROGRAL'' else ''SEGUROVIDA'' end + ''_'' + dc.pref_conc + ''_'' + dc.codi_conc + ''_'' + codi_dime as PKConcepto,
			substring(di.desc_info, len(di.desc_info) - charindex('' ]'',reverse(di.desc_info))+2,10000) as Cuadro,
			--di.desc_info,
			de2.desc_conc as Tabla,
			case substring(dc.codi_dein,charindex(''('',dc.codi_dein)-1,1) when ''1''  then ''SEGUROGRAL'' else ''SEGUROVIDA'' end + ''_'' + dc.pref_conc + ''_'' + dc.codi_conc + ''_'' + codi_dime as CodigoConcepto,
			dbo.FU_PF_getMaxOrdenConcepto(dc.pref_conc, dc.codi_conc) + '' - '' + de.desc_conc as Concepto
			--df.*
	from	dbax.dbo.dbax_dime_conc dc,
			dbax.dbo.dbax_desc_conc de,
			dbax.dbo.dbax_desc_info di,
			dbax.dbo.dbax_desc_conc de2,
			dbax.dbo.dbax_defi_conc df
	where	dc.codi_dein like ''%cuadro%''
	and		de.pref_conc = dc.pref_conc
	and		de.codi_conc = dc.codi_conc
	and		di.codi_info = dc.codi_dein
	and		di.codi_lang = ''es_ES''
	and		di.tipo_info = ''D''
	and		de2.pref_conc = dc.pref_dime
	and		de2.codi_conc = dc.codi_dime
	and		dc.pref_conc = df.pref_conc
	and		dc.codi_conc = df.codi_conc
	and		df.tipo_cuen != ''abstract''
	and		case substring(dc.codi_dein,charindex(''('',dc.codi_dein)-1,1) when ''1''  then ''SEGUROGRAL'' else ''SEGUROVIDA'' end + ''_'' + dc.pref_conc + ''_'' + dc.codi_conc + ''_'' + codi_dime not in (
				select PKConcepto collate Modern_Spanish_CI_AS from PF_03_Conceptos)
	
/*** Crea o Inserta PF_2_04_Ramos ***/

	/*INSERT INTO PF_04_Ramos 
	select	codi_segm + ''_'' + codi_ramo	as PKRamo, 
			codi_ramo			as CodigoRamo, 
			desc_ramo			as Ramo,
			nume_ramo			as NumeroRamo
	from BI_SG_Ramos A
	where   not exists (select	1 
					from 	PF_04_Ramos B 
					where codi_segm + ''_'' + codi_ramo	= PKRamo
					and codi_ramo = CodigoRamo
					and desc_ramo = Ramo
					and nume_ramo = NumeroRamo)*/
	

/*** Crea o Inserta PF_2_05_SubRamos ***/

	/*INSERT INTO PF_05_SubRamos 
	select	distinct
			codiSegm + ''_'' + codiRamo	as PKSubRamo, 
			codiRamo			as CodigoSubRamo, 
			descRamo			as SubRamo,
			numeRamo			as NumeroSubRamo
	from BI_SG_SubRamos A
	where   not exists (select	1 
					from 	PF_05_SubRamos B 
					where codiSegm + ''_'' + codiRamo	= PKSubRamo
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

	insert into PF_06_Periodos (CodigoPeriodo, Periodo)
	values (@P_PERIODO,@P_PERIODO)

	declare @vCodiEmpr varchar(20)
	declare @vCorrInst varchar(10) 

	declare curEmpresas cursor for
		select codi_pers,replace(@P_PERIODO,''-'','''') from dbax.dbo.dbax_defi_pers where codi_segm in (''SEGUROVIDA'',''SEGUROGRAL'') --and codi_pers in (700157302)

	open curEmpresas
	fetch next from curEmpresas into @vCodiEmpr, @vCorrInst
	while @@fetch_status = 0
	begin
		print @vCodiEmpr
		insert PF_07_Valores
		select * from (
			select	 distinct case substring(dc.codi_dein,charindex(''('',dc.codi_dein)-1,1) when ''1''  then ''SEGUROGRAL'' else ''SEGUROVIDA'' end as Segmento,
					substring(convert(varchar,ic.corr_inst),1,4) + ''-'' + substring(convert(varchar,ic.corr_inst),5,2) as Periodo,
					case substring(dc.codi_dein,charindex(''('',dc.codi_dein)-1,1) when ''1''  then ''SEGUROGRAL'' else ''SEGUROVIDA'' end + ''_'' + ic.codi_pers as PKEmpresa,
					case substring(dc.codi_dein,charindex(''('',dc.codi_dein)-1,1) when ''1''  then ''SEGUROGRAL'' else ''SEGUROVIDA'' end + ''_'' + dc.pref_conc + ''_'' + dc.codi_conc + ''_'' + codi_dime as PKConcepto,
					case substring(dc.codi_dein,charindex(''('',dc.codi_dein)-1,1) when ''1''  then ''SEGUROGRAL'' else ''SEGUROVIDA'' end + ''_'' + dbo.FU_PF_ObtieneMiembro (ic.codi_pers, ic.corr_inst, ic.vers_inst, ''cl-cs:RamosEje'', ic.codi_cntx, ''R'') as PKRamo,
					case substring(dc.codi_dein,charindex(''('',dc.codi_dein)-1,1) when ''1''  then ''SEGUROGRAL'' else ''SEGUROVIDA'' end + ''_'' + dbo.FU_PF_ObtieneMiembro (ic.codi_pers, ic.corr_inst, ic.vers_inst, ''cl-cs:DetalleSubRamosEje'', ic.codi_cntx,''S'') as PKSubRamo,
					--case substring(dc.codi_dein,charindex(''('',dc.codi_dein)-1,1) when ''1''  then ''SEGUROGRAL'' else ''SEGUROVIDA'' end + ''_'' + dbo.FU_PF_ObtieneMiembro (ic.codi_pers, ic.corr_inst, ic.vers_inst, ''cl-cs:RentasVitaliciasEje'', ic.codi_cntx,''S'') as PKSubRamo2,
					--ic.valo_cntx as ValorPesos,
					--ic.codi_cntx,
					convert(numeric,replace(ic.valo_cntx,'','',''.'')) as ValorPesos,
					convert(numeric,replace(ic.valo_refe,'','',''.'')) as ValorUF,
					convert(numeric,replace(ic.valo_inte,'','',''.'')) as ValorUSD
					--ic.valo_orig
			from	dbax.dbo.dbax_dime_conc dc,
					dbax.dbo.dbax_defi_conc df,
					dbax.dbo.dbax_inst_conc ic,
					dbax.dbo.dbax_inst_dicx ix,
					dbax.dbo.dbax_defi_pers dp
			where	dc.codi_dein like ''%cuadro%''
			and		dc.pref_conc = df.pref_conc
			and		dc.codi_conc = df.codi_conc
			and		df.tipo_cuen != ''abstract''
			and		dp.codi_pers = @vCodiEmpr
			and		dp.codi_segm = case substring(dc.codi_dein,charindex(''('',dc.codi_dein)-1,1) when ''1''  then ''SEGUROGRAL'' else ''SEGUROVIDA'' end
			and		ic.codi_pers = dp.codi_pers
			and		ic.corr_inst = @vCorrInst
			and		ic.vers_inst = dbax.dbo.FU_AX_getPersCorrVersInst(dp.codi_pers, ic.corr_inst,''I'', ''M'')
			and		ic.pref_conc = dc.pref_conc
			and		ic.codi_conc = dc.codi_conc
			--and		ic.valo_cntx like (''%,%'')
			and		ic.codi_conc not in (''RamosVida'', ''RamosGenerales'')
			and		ix.codi_pers = ic.codi_pers
			and		ix.corr_inst = ic.corr_inst
			and		ix.vers_inst = ic.vers_inst
			and		ix.codi_cntx = ic.codi_cntx
			and		ix.codi_axis in (''cl-cs:RamosEje'',''cl-cs:DetalleSubRamosEje''))V
		where	PKSubRamo not like ''%[_]0''
		and		PKRamo not like ''%[_]0''
		--and		PKRamo = ''SEGUROVIDA_110''

		insert PF_07_Valores
		select * from (
			select	 distinct case substring(dc.codi_dein,charindex(''('',dc.codi_dein)-1,1) when ''1''  then ''SEGUROGRAL'' else ''SEGUROVIDA'' end as Segmento,
					substring(convert(varchar,ic.corr_inst),1,4) + ''-'' + substring(convert(varchar,ic.corr_inst),5,2) as Periodo,
					case substring(dc.codi_dein,charindex(''('',dc.codi_dein)-1,1) when ''1''  then ''SEGUROGRAL'' else ''SEGUROVIDA'' end + ''_'' + ic.codi_pers as PKEmpresa,
					case substring(dc.codi_dein,charindex(''('',dc.codi_dein)-1,1) when ''1''  then ''SEGUROGRAL'' else ''SEGUROVIDA'' end + ''_'' + dc.pref_conc + ''_'' + dc.codi_conc + ''_'' + codi_dime as PKConcepto,
					case substring(dc.codi_dein,charindex(''('',dc.codi_dein)-1,1) when ''1''  then ''SEGUROGRAL'' else ''SEGUROVIDA'' end + ''_'' + dbo.FU_PF_ObtieneMiembro (ic.codi_pers, ic.corr_inst, ic.vers_inst, ''cl-cs:RamosEje'', ic.codi_cntx, ''R'') as PKRamo,
					--case substring(dc.codi_dein,charindex(''('',dc.codi_dein)-1,1) when ''1''  then ''SEGUROGRAL'' else ''SEGUROVIDA'' end + ''_'' + dbo.FU_PF_ObtieneMiembro (ic.codi_pers, ic.corr_inst, ic.vers_inst, ''cl-cs:DetalleSubRamosEje'', ic.codi_cntx,''S'') as PKSubRamo,
					case substring(dc.codi_dein,charindex(''('',dc.codi_dein)-1,1) when ''1''  then ''SEGUROGRAL'' else ''SEGUROVIDA'' end + ''_'' + dbo.FU_PF_ObtieneMiembro (ic.codi_pers, ic.corr_inst, ic.vers_inst, ''cl-cs:RentasVitaliciasEje'', ic.codi_cntx,''S'') as PKSubRamo,
					--ic.valo_cntx as ValorPesos,
					--ic.codi_cntx,
					convert(numeric,replace(ic.valo_cntx,'','',''.'')) as ValorPesos,
					convert(numeric,replace(ic.valo_refe,'','',''.'')) as ValorUF,
					convert(numeric,replace(ic.valo_inte,'','',''.'')) as ValorUSD
					--ic.valo_orig
			from	dbax.dbo.dbax_dime_conc dc,
					dbax.dbo.dbax_defi_conc df,
					dbax.dbo.dbax_inst_conc ic,
					dbax.dbo.dbax_inst_dicx ix,
					dbax.dbo.dbax_defi_pers dp
			where	dc.codi_dein like ''%cuadro%''
			and		dc.pref_conc = df.pref_conc
			and		dc.codi_conc = df.codi_conc
			and		df.tipo_cuen != ''abstract''
			and		dp.codi_pers = @vCodiEmpr
			and		dp.codi_segm = case substring(dc.codi_dein,charindex(''('',dc.codi_dein)-1,1) when ''1''  then ''SEGUROGRAL'' else ''SEGUROVIDA'' end
			and		ic.codi_pers = dp.codi_pers
			and		ic.corr_inst = @vCorrInst
			and		ic.vers_inst = dbax.dbo.FU_AX_getPersCorrVersInst(dp.codi_pers, ic.corr_inst,''I'', ''M'')
			and		ic.pref_conc = dc.pref_conc
			and		ic.codi_conc = dc.codi_conc
			--and		ic.valo_cntx like (''%,%'')
			and		ic.codi_conc not in (''RamosVida'', ''RentasVitaliciasEje'')
			and		ix.codi_pers = ic.codi_pers
			and		ix.corr_inst = ic.corr_inst
			and		ix.vers_inst = ic.vers_inst
			and		ix.codi_cntx = ic.codi_cntx
			and		ix.codi_axis in (''cl-cs:RentasVitaliciasEje''))V
		where	PKSubRamo not like ''%[_]0''
		--and		PKRamo not like ''%_0''

		fetch next from curEmpresas into @vCodiEmpr, @vCorrInst
	end
	close curEmpresas
	deallocate curEmpresas	

	select getdate(), ''FIN CARGA PERIODO: '' + @P_PERIODO 	
END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_table_create_3]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE  PROCEDURE [dbo].[prc_table_create_3] 	
		@P_PERIODO VARCHAR(30)
AS
SET NOCOUNT ON

BEGIN

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name=''PF_01_Segmentos'') 

	BEGIN
		CREATE TABLE [dbo].[PF_01_Segmentos](
			[Segmento] [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[NombreSegmento] [varchar](100) COLLATE Modern_Spanish_CI_AS NULL)
		/*,
		 CONSTRAINT [PK_Segmentos] PRIMARY KEY CLUSTERED 
		(
			[Segmento] ASC
		)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]*/
	END
	
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name=''PF_02_Empresas'') 

	BEGIN
		CREATE TABLE [dbo].[PF_02_Empresas](
			[PKEmpresa] [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[Rut] [varchar](15) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[RazonSocial] [varchar](100) COLLATE Modern_Spanish_CI_AS NULL,
			[RazonSocialCompleta] [varchar](116) COLLATE Modern_Spanish_CI_AS NULL,
			[Vigente] [varchar](10) COLLATE Modern_Spanish_CI_AS NULL)
/*,
		 CONSTRAINT [PK_Empresas] PRIMARY KEY CLUSTERED 
		(
			[PKEmpresa] ASC
		)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]*/
	END

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name=''PF_03_Conceptos'') 

	BEGIN
		CREATE TABLE [dbo].[PF_03_Conceptos](
			[PKConcepto] [varchar](256) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[Cuadro] [varchar](512) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[Tabla] [varchar](512) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[CodigoConcepto] [varchar](256) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[Concepto] [varchar](8000) COLLATE Modern_Spanish_CI_AS NULL)
/*,
		 CONSTRAINT [PK_Conceptos] PRIMARY KEY CLUSTERED 
		(
			[PKConcepto] ASC
		)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]*/
	END
	
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name=''PF_04_Ramos'') 

	BEGIN
		CREATE TABLE [dbo].[PF_04_Ramos](
			[PKRamo] [varchar](80) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[CodigoRamo] [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[Ramo] [varchar](80) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[NumeroRamo] [numeric](18, 0) NULL)
/*,
		 CONSTRAINT [PK_Ramos] PRIMARY KEY CLUSTERED 
		(
			[PKRamo] ASC
		)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]*/
	END

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name=''PF_05_SubRamos'') 

	BEGIN
		CREATE TABLE [dbo].[PF_05_SubRamos](
			[PKSubRamo] [varchar](80) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[CodigoSubRamo] [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[SubRamo] [varchar](80) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[NumeroSubRamo] [varchar](10) COLLATE Modern_Spanish_CI_AS NULL)
/*,
		 CONSTRAINT [PK_SubRamos] PRIMARY KEY CLUSTERED 
		(
			[PKSubRamo] ASC
		)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]*/
	END

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name=''PF_06_Periodos'') 

	BEGIN
		CREATE TABLE [dbo].[PF_06_Periodos](
				[CodigoPeriodo] [varchar](256) COLLATE Modern_Spanish_CI_AS NULL,
				[Periodo] [varchar](7) COLLATE Modern_Spanish_CI_AS NOT NULL)
/*,
		CONSTRAINT [PK_Periodos] PRIMARY KEY CLUSTERED 
		(
			[Periodo] DESC
		)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]*/
	END

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name=''PF_07_Valores'') 

	BEGIN
		CREATE TABLE [dbo].[PF_07_Valores](
					[Segmento] [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
					[Periodo] [varchar](7) COLLATE Modern_Spanish_CI_AS NOT NULL,
					[PKEmpresa] [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
					[PKConcepto] [varchar](256) COLLATE Modern_Spanish_CI_AS NOT NULL,
					[PKRamo] [varchar](80) COLLATE Modern_Spanish_CI_AS NOT NULL,
					[PKSubRamo] [varchar](80) COLLATE Modern_Spanish_CI_AS NULL,
					[ValorPesos] [numeric](38, 4) NULL,
					[ValorUF] [numeric](38, 4) NULL,
					[ValorUSD] [numeric](38, 4) NULL)
				/*) ON [PRIMARY]*/

		

	END


	alter table PF_01_Segmentos	alter column	Segmento	varchar(30) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_01_Segmentos	add constraint	PK_Segmentos	PRIMARY KEY CLUSTERED (Segmento)
	
	alter table PF_02_Empresas	alter column	PKEmpresa	varchar(30) collate Modern_Spanish_CI_AS not null 
	alter table PF_02_Empresas	alter column	Rut		varchar(15) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_02_Empresas	add constraint	PK_Empresas	PRIMARY KEY CLUSTERED (PKEmpresa)
	
	alter table PF_04_Ramos		alter column	PKRamo		varchar(80) collate Modern_Spanish_CI_AS not null 
	alter table PF_04_Ramos		alter column	CodigoRamo	varchar(50) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_04_Ramos		add constraint	PK_Ramos	PRIMARY KEY CLUSTERED (PKRamo)
	
	alter table PF_05_SubRamos	alter column	PKSubRamo	varchar(80) collate Modern_Spanish_CI_AS not null 
	alter table PF_05_SubRamos	alter column	CodigoSubRamo	varchar(50) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_05_SubRamos	add constraint	PK_SubRamos	PRIMARY KEY CLUSTERED (PKSubRamo)
	
	alter table PF_03_Conceptos	alter column	PKConcepto	varchar(256) collate Modern_Spanish_CI_AS not null 
	alter table PF_03_Conceptos	alter column	CodigoConcepto	varchar(256) collate Modern_Spanish_CI_AS not null 
	alter table PF_03_Conceptos	alter column	Cuadro		varchar(512) collate Modern_Spanish_CI_AS not null 
	alter table PF_03_Conceptos	alter column	Tabla		varchar(512) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_03_Conceptos	add constraint	PK_Conceptos	PRIMARY KEY CLUSTERED (PKConcepto)
	
	alter table PF_06_Periodos	alter column	Periodo		varchar(7) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_06_Periodos	add constraint	PK_Periodos	PRIMARY KEY CLUSTERED (Periodo DESC)

	/*** PF_07_Valores ***/

alter table PF_07_Valores alter column Segmento		varchar(30)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column Periodo		varchar(7)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column PKEmpresa	varchar(30)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column PKRamo		varchar(80)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column PKSubRamo	varchar(80)	collate Modern_Spanish_CI_AS
	alter table PF_07_Valores alter column PKConcepto	varchar(256)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column ValorPesos	numeric(38,4)
	alter table PF_07_Valores alter column ValorUF		numeric(38,4)
	alter table PF_07_Valores alter column ValorUsd		numeric(38,4)

	alter table PF_07_Valores WITH CHECK add constraint	Valores_FK_Segmentos
		FOREIGN KEY	(Segmento) REFERENCES PF_01_Segmentos (Segmento)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Segmentos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Periodos
		FOREIGN KEY (Periodo) REFERENCES PF_06_Periodos (Periodo)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Periodos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Empresas
		FOREIGN KEY	(PKEmpresa)	REFERENCES PF_02_Empresas  (PKEmpresa)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Empresas
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Ramos
		FOREIGN KEY (PKRamo) REFERENCES PF_04_Ramos (PKRamo)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Ramos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_SubRamos
		FOREIGN KEY (PKSubRamo) REFERENCES PF_05_SubRamos  (PKSubRamo)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_SubRamos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Conceptos
		FOREIGN KEY (PKConcepto) REFERENCES PF_03_Conceptos (PKConcepto)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Conceptos



		EXEC prc_bi_dbax_create_3 @P_PERIODO;




END











' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_table_create]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'




CREATE PROCEDURE [dbo].[prc_table_create] 	
AS
SET NOCOUNT ON

BEGIN

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name=''PF_01_Segmentos'') 

	BEGIN
		CREATE TABLE [dbo].[PF_01_Segmentos](
			[Segmento] [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[NombreSegmento] [varchar](100) COLLATE Modern_Spanish_CI_AS NULL)
		/*,
		 CONSTRAINT [PK_Segmentos] PRIMARY KEY CLUSTERED 
		(
			[Segmento] ASC
		)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]*/
	END
	
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name=''PF_02_Empresas'') 

	BEGIN
		CREATE TABLE [dbo].[PF_02_Empresas](
			[PKEmpresa] [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[Rut] [varchar](15) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[RazonSocial] [varchar](100) COLLATE Modern_Spanish_CI_AS NULL,
			[RazonSocialCompleta] [varchar](116) COLLATE Modern_Spanish_CI_AS NULL,
			[Vigente] [varchar](10) COLLATE Modern_Spanish_CI_AS NULL)
/*,
		 CONSTRAINT [PK_Empresas] PRIMARY KEY CLUSTERED 
		(
			[PKEmpresa] ASC
		)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]*/
	END

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name=''PF_03_Conceptos'') 

	BEGIN
		CREATE TABLE [dbo].[PF_03_Conceptos](
			[PKConcepto] [varchar](256) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[Cuadro] [varchar](512) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[Tabla] [varchar](512) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[CodigoConcepto] [varchar](256) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[Concepto] [varchar](8000) COLLATE Modern_Spanish_CI_AS NULL)
/*,
		 CONSTRAINT [PK_Conceptos] PRIMARY KEY CLUSTERED 
		(
			[PKConcepto] ASC
		)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]*/
	END
	
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name=''PF_04_Ramos'') 

	BEGIN
		CREATE TABLE [dbo].[PF_04_Ramos](
			[PKRamo] [varchar](80) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[CodigoRamo] [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[Ramo] [varchar](80) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[NumeroRamo] [numeric](18, 0) NULL)
/*,
		 CONSTRAINT [PK_Ramos] PRIMARY KEY CLUSTERED 
		(
			[PKRamo] ASC
		)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]*/
	END

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name=''PF_05_SubRamos'') 

	BEGIN
		CREATE TABLE [dbo].[PF_05_SubRamos](
			[PKSubRamo] [varchar](80) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[CodigoSubRamo] [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[SubRamo] [varchar](80) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[NumeroSubRamo] [varchar](10) COLLATE Modern_Spanish_CI_AS NULL)
/*,
		 CONSTRAINT [PK_SubRamos] PRIMARY KEY CLUSTERED 
		(
			[PKSubRamo] ASC
		)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]*/
	END

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name=''PF_06_Periodos'') 

	BEGIN
		CREATE TABLE [dbo].[PF_06_Periodos](
				[CodigoPeriodo] [varchar](256) COLLATE Modern_Spanish_CI_AS NULL,
				[Periodo] [varchar](7) COLLATE Modern_Spanish_CI_AS NOT NULL)
/*,
		CONSTRAINT [PK_Periodos] PRIMARY KEY CLUSTERED 
		(
			[Periodo] DESC
		)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]*/
	END

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name=''PF_07_Valores'') 

	BEGIN
		CREATE TABLE [dbo].[PF_07_Valores](
					[Segmento] [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
					[Periodo] [varchar](7) COLLATE Modern_Spanish_CI_AS NOT NULL,
					[PKEmpresa] [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
					[PKConcepto] [varchar](256) COLLATE Modern_Spanish_CI_AS NOT NULL,
					[PKRamo] [varchar](80) COLLATE Modern_Spanish_CI_AS NOT NULL,
					[PKSubRamo] [varchar](80) COLLATE Modern_Spanish_CI_AS NULL,
					[ValorPesos] [numeric](38, 4) NULL,
					[ValorUF] [numeric](38, 4) NULL,
					[ValorUSD] [numeric](38, 4) NULL)
				/*) ON [PRIMARY]*/

		

	END


	alter table PF_01_Segmentos	alter column	Segmento	varchar(30) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_01_Segmentos	add constraint	PK_Segmentos	PRIMARY KEY CLUSTERED (Segmento)
	
	alter table PF_02_Empresas	alter column	PKEmpresa	varchar(30) collate Modern_Spanish_CI_AS not null 
	alter table PF_02_Empresas	alter column	Rut		varchar(15) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_02_Empresas	add constraint	PK_Empresas	PRIMARY KEY CLUSTERED (PKEmpresa)
	
	alter table PF_04_Ramos		alter column	PKRamo		varchar(80) collate Modern_Spanish_CI_AS not null 
	alter table PF_04_Ramos		alter column	CodigoRamo	varchar(50) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_04_Ramos		add constraint	PK_Ramos	PRIMARY KEY CLUSTERED (PKRamo)
	
	alter table PF_05_SubRamos	alter column	PKSubRamo	varchar(80) collate Modern_Spanish_CI_AS not null 
	alter table PF_05_SubRamos	alter column	CodigoSubRamo	varchar(50) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_05_SubRamos	add constraint	PK_SubRamos	PRIMARY KEY CLUSTERED (PKSubRamo)
	
	alter table PF_03_Conceptos	alter column	PKConcepto	varchar(256) collate Modern_Spanish_CI_AS not null 
	alter table PF_03_Conceptos	alter column	CodigoConcepto	varchar(256) collate Modern_Spanish_CI_AS not null 
	alter table PF_03_Conceptos	alter column	Cuadro		varchar(512) collate Modern_Spanish_CI_AS not null 
	alter table PF_03_Conceptos	alter column	Tabla		varchar(512) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_03_Conceptos	add constraint	PK_Conceptos	PRIMARY KEY CLUSTERED (PKConcepto)
	
	alter table PF_06_Periodos	alter column	Periodo		varchar(7) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_06_Periodos	add constraint	PK_Periodos	PRIMARY KEY CLUSTERED (Periodo DESC)

	/*** PF_07_Valores ***/

alter table PF_07_Valores alter column Segmento		varchar(30)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column Periodo		varchar(7)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column PKEmpresa	varchar(30)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column PKRamo		varchar(80)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column PKSubRamo	varchar(80)	collate Modern_Spanish_CI_AS
	alter table PF_07_Valores alter column PKConcepto	varchar(256)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column ValorPesos	numeric(38,4)
	alter table PF_07_Valores alter column ValorUF		numeric(38,4)
	alter table PF_07_Valores alter column ValorUsd		numeric(38,4)

	alter table PF_07_Valores WITH CHECK add constraint	Valores_FK_Segmentos
		FOREIGN KEY	(Segmento) REFERENCES PF_01_Segmentos (Segmento)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Segmentos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Periodos
		FOREIGN KEY (Periodo) REFERENCES PF_06_Periodos (Periodo)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Periodos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Empresas
		FOREIGN KEY	(PKEmpresa)	REFERENCES PF_02_Empresas  (PKEmpresa)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Empresas
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Ramos
		FOREIGN KEY (PKRamo) REFERENCES PF_04_Ramos (PKRamo)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Ramos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_SubRamos
		FOREIGN KEY (PKSubRamo) REFERENCES PF_05_SubRamos  (PKSubRamo)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_SubRamos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Conceptos
		FOREIGN KEY (PKConcepto) REFERENCES PF_03_Conceptos (PKConcepto)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Conceptos



		EXEC prc_bi_dbax_create_2;




END







' 
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Valores_FK_Conceptos]') AND parent_object_id = OBJECT_ID(N'[dbo].[PF_07_Valores]'))
ALTER TABLE [dbo].[PF_07_Valores]  WITH CHECK ADD  CONSTRAINT [Valores_FK_Conceptos] FOREIGN KEY([PKConcepto])
REFERENCES [dbo].[PF_03_Conceptos] ([PKConcepto])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Valores_FK_Empresas]') AND parent_object_id = OBJECT_ID(N'[dbo].[PF_07_Valores]'))
ALTER TABLE [dbo].[PF_07_Valores]  WITH CHECK ADD  CONSTRAINT [Valores_FK_Empresas] FOREIGN KEY([PKEmpresa])
REFERENCES [dbo].[PF_02_Empresas] ([PKEmpresa])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Valores_FK_Periodos]') AND parent_object_id = OBJECT_ID(N'[dbo].[PF_07_Valores]'))
ALTER TABLE [dbo].[PF_07_Valores]  WITH CHECK ADD  CONSTRAINT [Valores_FK_Periodos] FOREIGN KEY([Periodo])
REFERENCES [dbo].[PF_06_Periodos] ([Periodo])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Valores_FK_Ramos]') AND parent_object_id = OBJECT_ID(N'[dbo].[PF_07_Valores]'))
ALTER TABLE [dbo].[PF_07_Valores]  WITH CHECK ADD  CONSTRAINT [Valores_FK_Ramos] FOREIGN KEY([PKRamo])
REFERENCES [dbo].[PF_04_Ramos] ([PKRamo])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Valores_FK_Segmentos]') AND parent_object_id = OBJECT_ID(N'[dbo].[PF_07_Valores]'))
ALTER TABLE [dbo].[PF_07_Valores]  WITH CHECK ADD  CONSTRAINT [Valores_FK_Segmentos] FOREIGN KEY([Segmento])
REFERENCES [dbo].[PF_01_Segmentos] ([Segmento])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Valores_FK_SubRamos]') AND parent_object_id = OBJECT_ID(N'[dbo].[PF_07_Valores]'))
ALTER TABLE [dbo].[PF_07_Valores]  WITH CHECK ADD  CONSTRAINT [Valores_FK_SubRamos] FOREIGN KEY([PKSubRamo])
REFERENCES [dbo].[PF_05_SubRamos] ([PKSubRamo])
