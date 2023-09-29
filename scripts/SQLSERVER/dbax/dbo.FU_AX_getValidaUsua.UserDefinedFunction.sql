SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Lorena Bezares>
-- Create date: <27-09-2012>
-- Description:	<valida si usuario y contraseña son validos>
-- =============================================
CREATE FUNCTION [dbo].[FU_AX_getValidaUsua] 
(@usua varchar(30), @pass varchar(30))
RETURNS VARCHAR(1)
AS

BEGIN
	declare @valida VARCHAR(1)

    set @valida = 'N'

	select @valida = 'S'
    from dbne_usua
	where pass_usua = master.dbo.fn_varbintohexstr(HASHBYTES('md5',@pass))
    and codi_usua = @usua

	-- Return the result of the function
	RETURN @valida

END
GO
