SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_Elimina_grilla_grupo] 
@p_code_desc varchar(100)
 as
BEGIN

delete sys_code where code_desc = @p_code_desc 
END
GO
