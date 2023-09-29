SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_AX_Del_grupo] (
@pCodiEmpr numeric(9,0),
@pCodiEmex varchar(30)
)
AS
BEGIN
delete dbax_pers_grup 
where codi_empr = @pCodiEmpr 
and codi_emex = @pCodiEmex
END
GO
