SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_AX_insCntxInst] (@pCodiPers numeric(9,0),@pCorrInst numeric(10,0), @pVersInst numeric(5,0),@pCodiCntx varchar(256))
AS
BEGIN
insert into dbax_inst_cntx (codi_pers, corr_inst, vers_inst, codi_cntx) values (@pCodiPers,@pCorrInst,@pVersInst,@pCodiCntx)
END
GO
