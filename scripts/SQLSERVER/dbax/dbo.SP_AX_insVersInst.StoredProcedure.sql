SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[SP_AX_insVersInst] (@pCodiPers numeric(9,0),@pCorrInst numeric(10,0), @pVersInst numeric(5,0),@pDescVers varchar(256),@pCodiEsta varchar(3))
AS
BEGIN
insert into dbax_inst_vers (codi_pers, corr_inst, vers_inst,fech_carg, desc_vers, codi_esta) 
values (@pCodiPers,@pCorrInst,@pVersInst, substring (convert (varchar,getdate()), 0, 20) ,@pDescVers,@pCodiEsta)
END
GO
