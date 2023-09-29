SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_GetMaxColum](
@pCodiInfo varchar(50),
@pCodiEmpr numeric (9,0),
@pCodiEmex varchar(30)
)
as
BEGIN

select isnull(max(orde_cntx),0)+ 1 as orde_conc
from dbax_info_cntx 
where codi_info  =@pCodiInfo
and codi_empr = @pCodiEmpr
and codi_emex = @pCodiEmex

END
GO
