SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_AX_GetRutaXBRL]
as
BEGIN
	select PARAM_VALUE
	from sys_param
	where PARAM_NAME='DBAX_XBRL_PATH'

END
GO
