SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_AX_updInfoDefi]
	(	
	@CodiEmex varchar(50),
	@CodiEmpr varchar(20),
	@CodiInfo varchar(50),
	@DescInfo varchar(50)
	)
AS
BEGIN
	select @CodiEmex, @CodiEmpr, @CodiInfo, @DescInfo
	update	dbax_desc_info 
	set desc_info = @DescInfo
	where	codi_emex =@CodiEmex 
	and		codi_empr = @CodiEmpr
	and		codi_info = @CodiInfo
	and		codi_lang = 'es_ES'

	select	* 
	from	dbax_desc_info 
	where	codi_emex =@CodiEmex 
	and		codi_empr = @CodiEmpr
	and		codi_info = @CodiInfo
END
GO
