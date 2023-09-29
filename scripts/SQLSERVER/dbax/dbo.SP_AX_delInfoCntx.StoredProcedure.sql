SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_delInfoCntx] 
	@CodiEmex varchar(30),
	@CodiEmpr numeric(9,0),
	@CodiInfo varchar(50),
	@CodiCntx varchar(50)
 as
BEGIN
	delete from dbax_info_cntx 
	where	codi_emex = @CodiEmex  
	and		codi_empr = @CodiEmpr
	and		codi_info = @CodiInfo
	and		codi_cntx = @CodiCntx
END
GO
