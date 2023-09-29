SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_GetValoPara](
	@pCodiPara varchar(30)='')
as
BEGIN
	if(len(@pCodiPara)>0)
	begin
		select	PARAM_VALUE
		from	sys_param
		where	PARAM_NAME = @pCodiPara
	end
	begin
		select	PARAM_DESC, PARAM_VALUE
		from	sys_param
	end
END
GO
