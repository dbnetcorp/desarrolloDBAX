SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_AX_insInstDocu] (@pCodiPers numeric(9,0),@pCorrInst numeric(10,0),@CodiEsta varchar(3))
AS
BEGIN
	if((select count(1) from dbax_inst_docu where codi_pers = @pCodiPers and corr_inst = @pCorrInst)=0)
	begin
		insert into	dbax_inst_docu (codi_pers, corr_inst, codi_esta) 
		values		(@pCodiPers,@pCorrInst,@CodiEsta)
	end
END
GO
