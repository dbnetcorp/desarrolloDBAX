SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[SP_AX_insInstDicx] (@pCodiPers numeric(9,0),@pCorrInst numeric(10,0), @pVersInst numeric(5,0),@pCodiCntx varchar(256),@pCodiAxis varchar(256),@pCodiMemb varchar(256))
AS
BEGIN
insert into dbax_inst_dicx (codi_pers, corr_inst, vers_inst, codi_cntx, codi_axis, codi_memb) values (@pCodiPers,@pCorrInst,@pVersInst,@pCodiCntx,@pCodiAxis,@pCodiMemb)
END
GO
