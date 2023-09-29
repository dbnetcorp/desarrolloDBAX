SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getContextosInforme](
@p_codi_informe varchar(100))
as
BEGIN
	select	ic.codi_inct, 
			ic.orde_cntx, 
			ic.codi_cntx, 
			ic.codi_info,
			dc.desc_cntx
	from	dbax_info_cntx ic,
			dbax_defi_cntx dc
	where	ic.codi_info = @p_codi_informe
	and		ic.codi_cntx = dc.codi_cntx
	ORDER BY ic.orde_cntx
END
GO
