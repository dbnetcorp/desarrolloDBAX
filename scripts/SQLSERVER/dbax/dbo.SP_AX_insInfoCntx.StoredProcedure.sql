SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_insInfoCntx] 
	@p_Codi_informe varchar(100),
	@p_Codi_cntx varchar(100),
	@p_Orden varchar(10),
	@p_codi_empr varchar(10)
 as
BEGIN
	insert dbax_info_cntx (codi_empr, codi_info, codi_cntx, orde_cntx) 
	values (@p_codi_empr, @p_Codi_informe, @p_Codi_cntx, @p_Orden)
END
GO
