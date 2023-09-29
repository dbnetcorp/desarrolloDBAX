SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[SP_AX_UpdaInstUnit] (@pDescUnit varchar(50),@pCodiPers numeric(9,0),@pCorrInst numeric(10,0), @pVersInst numeric(5,0),@pCodiUnit varchar(50))
AS
BEGIN
update dbax_inst_unit set desc_unit =@pDescUnit  where codi_pers =@pCodiPers and corr_inst=@pCorrInst and vers_inst=@pVersInst and codi_unit=@pCodiUnit
END
GO
