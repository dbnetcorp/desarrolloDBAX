SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getEmpresa](
@pCodiPers varchar(100)
)
as
BEGIN
	select isnull(max(1),0) from dbax_defi_pers where codi_pers = @pCodiPers
END
GO
