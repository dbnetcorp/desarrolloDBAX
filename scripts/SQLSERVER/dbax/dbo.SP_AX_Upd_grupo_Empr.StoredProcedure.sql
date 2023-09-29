SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_AX_Upd_grupo_Empr](
@pCodi_empr numeric(9,0),
@pCodi_Emex varchar(30),
@pDes_grup varchar(200),
@pCodi_grup varchar(200))
AS
BEGIN

update sys_code
set code_desc = @pDes_grup
where code = @pCodi_grup 

END
GO
