SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_AX_insInfoDefi]
 (	@CodiEmex varchar(50),
	@CodiEmpr varchar(20),
	@CodiInfo varchar(50),
	@DescInfo varchar(50),
	@Tipotaxo varchar(10)
	)
AS
BEGIN
	insert into dbax_info_defi (codi_emex, codi_empr, codi_info, tipo_taxo)
			values (@CodiEmex, @CodiEmpr, @CodiInfo, @Tipotaxo)

	insert into dbax_desc_info (codi_emex, codi_empr, codi_info, codi_lang, desc_info)
			values (@CodiEmex,@CodiEmpr,@CodiInfo,'es_ES',@DescInfo)
END
GO
