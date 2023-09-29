USE [dbaxBI]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BI_SG_Segmento]
AS
SELECT  codi_segm COLLATE Modern_Spanish_CI_AS codi_segm, desc_segm COLLATE Modern_Spanish_CI_AS desc_segm
from    dbax.dbo.dbax_defi_segm
WHERE   CODI_SEGM like 'SEGURO%'
GO
