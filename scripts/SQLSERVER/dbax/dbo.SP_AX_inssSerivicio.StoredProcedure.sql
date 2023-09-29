SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_inssSerivicio] as

BEGIN
declare @pRuta_bianrio varchar(256)
declare @pFecha_ini varchar(256)

  set @pRuta_bianrio = (select PARAM_VALUE from sys_param where PARAM_NAME = 'DBAX_XBRL_BINA')
  set @pFecha_ini  = (select getdate())

	insert dbax_dbne_proc(prog_proc,args_proc, fech_crea, fini_proc, esta_proc) 
	values (@pRuta_bianrio,'1', @pFecha_ini, @pFecha_ini, 'I')
END
GO
