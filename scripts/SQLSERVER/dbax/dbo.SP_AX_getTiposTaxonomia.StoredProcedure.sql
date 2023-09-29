SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getTiposTaxonomia] 
as
BEGIN
	select '' as tipo_taxo, '' as desc_tipo, '1'
	union
	select tipo_taxo, desc_tipo, 'n' from dbax_tipo_taxo order by 3, 2
END
GO
