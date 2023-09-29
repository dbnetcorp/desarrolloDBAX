SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_delInfoDefi] 
	@CodiEmex varchar(30),
	@CodiEmpr numeric(9,0),
	@CodiInfo varchar(50)
 as
BEGIN
	delete from dbax_desc_info
	where	codi_emex = @CodiEmex  
	and		codi_empr = @CodiEmpr
	and		codi_info = @CodiInfo

	delete from dbax_info_defi
	where	codi_emex = @CodiEmex  
	and		codi_empr = @CodiEmpr
	and		codi_info = @CodiInfo
END
GO
