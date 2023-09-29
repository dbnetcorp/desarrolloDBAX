SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_AX_getProcesosPendientes] 
AS
BEGIN
	select codi_proc,
    prog_proc, 
    args_proc 
    from   dbax_dbne_proc 
    where  esta_proc = 'I' 
    order by fech_crea
END
GO
