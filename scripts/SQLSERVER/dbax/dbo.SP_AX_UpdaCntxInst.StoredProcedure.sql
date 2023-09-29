SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_AX_UpdaCntxInst] (@pFiniCntx varchar(10),@pFfinCntx varchar(10)='0' ,@pCodiPers numeric(9,0),@pCorrInst numeric(10,0), @pVersInst numeric(5,0),@pCodiCntx varchar(256))
AS
BEGIN

	if(@pFfinCntx='0')
	begin
		update dbax_inst_cntx set fini_cntx =@pFiniCntx where codi_pers =@pCodiPers and corr_inst=@pCorrInst and vers_inst=@pVersInst and codi_cntx =@pCodiCntx
	end
	else
	begin
		update dbax_inst_cntx set fini_cntx =@pFiniCntx, ffin_cntx =@pFfinCntx where codi_pers =@pCodiPers and corr_inst=@pCorrInst and vers_inst=@pVersInst and codi_cntx =@pCodiCntx
	end
END
GO
