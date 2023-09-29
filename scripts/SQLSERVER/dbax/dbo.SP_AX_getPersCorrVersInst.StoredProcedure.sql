SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getPersCorrVersInst](
	@pCodiPers varchar(30),
	@pCorrInst numeric(10,0),
	@pTipo varchar(1)='T') as
BEGIN
	if(@pTipo='T')
	begin
		select distinct vers_inst, vers_inst
		from	dbax_inst_vers
		where	codi_pers = @pCodiPers
		and		corr_inst = @pCorrInst
		order by 1 desc
	end 
	else if(@pTipo='M')
	begin
		select distinct top 1  isnull(max(vers_inst),'0'), isnull(max(vers_inst),'0')
		from	dbax_inst_vers
		where	codi_pers = @pCodiPers
		and		corr_inst = @pCorrInst
		order by 1 desc
	end
	else if(@pTipo='S')
		begin
			select distinct top 1 isnull(max(vers_inst),0) + 1, isnull(max(vers_inst),0) + 1
			from	dbax_inst_vers
			where	codi_pers = @pCodiPers
			and		corr_inst = @pCorrInst
			order by 1 desc
		end
END
GO
