SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Lorena Bezares>
-- Create date: <27-09-2012>
-- Description:	<inserta usuarios con pass encriptada>
-- =============================================
CREATE PROCEDURE [dbo].[SP_AX_InseUsuaSys]  
	(@usua varchar(30), @pass varchar(30))
	
AS
declare @password varchar(34)

set @password = master.dbo.fn_varbintohexstr(HASHBYTES('md5',@pass))
BEGIN
	insert into dbne_usua (codi_usua, pass_usua, fech_usua) values (@usua, @password, getdate())
END
GO
