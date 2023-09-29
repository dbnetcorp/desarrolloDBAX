SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_UpdEstadoservicio] 
(@p_esta_proc varchar(50),
 @p_codi_proc varchar(50),
 @p_mens_proc varchar(50))
AS
BEGIN

update dbax_dbne_proc 
 set ffin_proc=getdate(),
 esta_proc = @p_esta_proc,
 mens_proc = @p_mens_proc
 where codi_proc = @p_codi_proc

END
GO
