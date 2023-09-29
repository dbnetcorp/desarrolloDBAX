SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_AX_insInstInfo] (@pCodiPers numeric(9,0),@pCorrInst numeric(10,0), @pVersInst numeric(5,0),@pCodiInfo varchar(50))
AS
BEGIN
if ((select count(*) from dbax_inst_info where codi_pers=@pCodiPers and corr_inst=@pCorrInst and vers_inst=@pVersInst and codi_info=@pCodiInfo)=0)
insert into dbax_inst_info (codi_pers,corr_inst,vers_inst,codi_info)values(@pCodiPers,@pCorrInst,@pVersInst,@pCodiInfo)
END
GO
