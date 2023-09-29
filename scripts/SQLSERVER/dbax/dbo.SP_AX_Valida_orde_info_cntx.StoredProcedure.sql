SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_Valida_orde_info_cntx](
	@codi_info varchar(100),
	@codi_empr varchar(10),
	@orden varchar(10)
) as
BEGIN
	select count(*) 
	from dbax_info_cntx 
	where orde_cntx = @orden  
	and codi_empr =  @codi_empr
	and codi_info = @codi_info 
END
GO
