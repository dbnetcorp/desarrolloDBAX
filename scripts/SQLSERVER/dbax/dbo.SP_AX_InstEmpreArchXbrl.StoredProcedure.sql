SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_AX_InstEmpreArchXbrl] (@pCodiPers numeric(9,0))
AS
BEGIN
insert into dbax_defi_pers (codi_pers) values (@pCodiPers)
END
GO
