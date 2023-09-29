SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_insCntx] (
	@p_CodiEmex varchar(30),
	@p_CodiEmpr numeric(9,0),
	@p_CodiCntx varchar(100),
	@p_DescCntx varchar(100),
	@p_DiaiCntx varchar(100),
	@p_AnoiCntx varchar(100),
	@p_DiatCntx varchar(100),
	@p_AnotCntx varchar(100)
	)as
BEGIN
	insert dbax_defi_cntx (codi_emex, codi_empr, codi_cntx, desc_cntx, diai_cntx, anoi_cntx, diat_cntx, anot_cntx) 
	values (@p_CodiEmex, @p_CodiEmpr, @p_CodiCntx, @p_DescCntx,@p_DiaiCntx,@p_AnoiCntx,@p_DiatCntx,@p_AnotCntx)
END
GO
