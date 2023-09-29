SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_AX_delInstDocu] (@pCodiPers numeric(9,0),@pCorrInst numeric(10,0))
AS
BEGIN
	delete from dbax_inst_dicx where codi_pers = @pCodiPers  and corr_inst = @pCorrInst
	delete from dbax_inst_cntx where codi_pers = @pCodiPers  and corr_inst = @pCorrInst
	delete from dbax_inst_vers where codi_pers = @pCodiPers  and corr_inst = @pCorrInst
	delete from dbax_inst_docu where codi_pers = @pCodiPers  and corr_inst = @pCorrInst
END
GO
