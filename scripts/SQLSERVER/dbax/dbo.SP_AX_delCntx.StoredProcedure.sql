SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_delCntx] 
	@p_CodiEmex varchar(30),
	@p_CodiEmpr numeric(9,0),
	@p_CodiCntx varchar(100)
 as
BEGIN
	delete dbax_defi_cntx 
	where codi_emex = @p_CodiEmex 
	and codi_empr  = @p_CodiEmpr
	and codi_cntx = @p_CodiCntx 
END
GO
