SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[dbax_view_cntx]
AS
SELECT     codi_pers, corr_inst, vers_inst, codi_cntx, fini_cntx, ffin_cntx
FROM         dbo.dbax_inst_cntx AS ic
WHERE     (NOT EXISTS
                          (SELECT     1 AS EXPR1
                            FROM          dbo.dbax_inst_dicx AS id
                            WHERE      (codi_pers = ic.codi_pers) AND (corr_inst = ic.corr_inst) AND (vers_inst = ic.vers_inst) AND (codi_cntx = ic.codi_cntx)))
GO
