SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getMaxOrdeConc](
@pCodiEmex varchar(30),
@pCodiEmpr numeric (9,0),
@pCodiInfo varchar(50)
)
as
BEGIN
	select isnull(max(orde_conc),0)+1 as orde_conc
	from	dbax_info_conc
	where	codi_emex = @pCodiEmex
	and		codi_empr = @pCodiEmpr
	and		codi_info = @pCodiInfo
END
GO
