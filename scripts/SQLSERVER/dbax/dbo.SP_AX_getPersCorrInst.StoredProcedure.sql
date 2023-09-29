SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_AX_getPersCorrInst](
	@pCodiPers varchar(30),
	@pCorrInst numeric(6,0) = 0) as
BEGIN
	if(len(@pCodiPers) > 0)
	begin
		select distinct corr_inst, corr_inst 
		from	dbax_inst_docu
		where	codi_pers = @pCodiPers
		and		corr_inst >= @pCorrInst
		order by 1 desc
	end
	else
	begin
		select distinct corr_inst, corr_inst 
		from	dbax_inst_docu
		where	corr_inst >= @pCorrInst
		order by 1 desc
	end
END
GO
