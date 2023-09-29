SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_InsDatosCalIndicadores](
    @p_codi_emex  varchar(30),
	@p_codi_empr  numeric(9,0),
	@p_corr_inst varchar(6),
	@p_codi_grup varchar(50),
	@p_codi_segm varchar(50),
	@p_codi_indi  varchar(100)
) as
BEGIN
	declare @pRuta_binario varchar(256)
	declare @pFecha_ini varchar(256)

	set @pRuta_binario = (select PARAM_VALUE from sys_param where PARAM_NAME = 'DBAX_XBRL_BINA')
	set @pFecha_ini  = (select getdate())

	insert dbax_dbne_proc(prog_proc, args_proc, fech_crea, fini_proc, esta_proc) 
	values (@pRuta_binario + '\CalculoIndicadores.exe ', '"' + convert(varchar,@p_codi_emex) + '" "' + convert(varchar,@p_codi_empr) + '" "' + @p_corr_inst + '" "' + convert(varchar,@p_codi_grup) + '" "' + convert(varchar,@p_codi_segm) + '" "' + convert(varchar,@p_codi_indi) + '"', @pFecha_ini, @pFecha_ini, 'I')
END
GO
