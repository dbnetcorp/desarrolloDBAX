SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getGrupos] 
as
BEGIN
	select '' as codi_grup, '' as desc_grup, '1'
	union
	select codi_grup, desc_grup, 'n' from dbax_defi_grup order by 3, 2
END
GO
