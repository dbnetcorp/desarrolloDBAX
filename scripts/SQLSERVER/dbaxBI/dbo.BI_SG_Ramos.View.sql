USE [dbaxBI]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BI_SG_Ramos]
AS
SELECT  codi_ramo COLLATE Modern_Spanish_CI_AS codi_ramo,
        desc_ramo COLLATE Modern_Spanish_CI_AS desc_ramo,
        codi_ramo_supe COLLATE Modern_Spanish_CI_AS codi_ramo_supe,
        codi_segm COLLATE Modern_Spanish_CI_AS codi_segm,
        codi_ramo COLLATE Modern_Spanish_CI_AS orde_ramo ,
        CONVERT(numeric(18,0), nume_ramo) nume_ramo
FROM    dbax.dbo.dbax_defi_ramo
WHERE   CODI_SEGM like 'SEGURO%'
AND     tipo_ramo = 'R'
AND     codi_ramo not like '2012%'
GO
