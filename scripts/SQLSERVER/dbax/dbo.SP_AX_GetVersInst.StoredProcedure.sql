SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[SP_AX_GetVersInst] (
	@pCodiPers numeric(9,0),
	@pCorrInst numeric(10,0),
	@tipo varchar(3) = 'S')
AS
BEGIN
	if(@tipo='S')
	begin
		select	(isnull(max(vers_inst),0) + 1) vers_inst 
		from	dbax_inst_vers 
		where	codi_pers = @pCodiPers 
		and		corr_inst= @pCorrInst
	end
	else
	begin
		select	max(vers_inst) vers_inst 
		from	dbax_inst_vers 
		where	codi_pers = @pCodiPers 
		and		corr_inst= @pCorrInst
	end
END
GO
