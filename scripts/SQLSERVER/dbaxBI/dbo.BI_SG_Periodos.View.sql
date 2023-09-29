USE [dbaxBI]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BI_SG_Periodos]
AS
SELECT	distinct
		dbax.dbo.dbax_bi_getPeriodo(ic.fini_cntx,ic.ffin_cntx) codi_cntx,
		dbax.dbo.dbax_bi_getPeriodo(ic.fini_cntx,ic.ffin_cntx) desc_cntx,
		dbax.dbo.dbax_bi_getPeriodo(ic.fini_cntx,ic.ffin_cntx) periodo
FROM   dbax.dbo.dbax_inst_cntx AS ic WITH (INDEX (IDX_dbax_inst_cntx))
WHERE  codi_pers in (select codi_pers from dbax.dbo.dbax_defi_pers where codi_segm like '%SEGURO%') 
AND	   (NOT EXISTS (SELECT  1
                    FROM    dbax.dbo.dbax_inst_dicx AS id
                    WHERE   id.codi_pers = ic.codi_pers 
					AND		id.corr_inst = ic.corr_inst 
					AND		id.vers_inst = ic.vers_inst 
					AND		id.codi_cntx = ic.codi_cntx))
and    substring(ic.fini_cntx,1,4) = substring(cast(corr_inst as varchar(6)),1,4)
--group by dbax.dbo.dbax_bi_getPeriodo(ic.fini_cntx,ic.ffin_cntx)
GO
