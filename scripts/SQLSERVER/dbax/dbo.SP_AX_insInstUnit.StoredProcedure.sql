SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[SP_AX_insInstUnit] (@pCodiPers numeric(9,0),@pCorrInst numeric(10,0), @pVersInst numeric(5,0),@pCodiUnit varchar(50))
AS
BEGIN
insert into dbax_inst_unit (codi_pers, corr_inst, vers_inst, codi_unit) values (@pCodiPers,@pCorrInst,@pVersInst,@pCodiUnit)
END
GO
