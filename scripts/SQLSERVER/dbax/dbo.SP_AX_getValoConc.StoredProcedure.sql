SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getValoConc] 
	@p_CodiPers		numeric(9,0),
	@p_CorrInst		numeric(10,0),
	@p_VersInst		numeric(5,0),
	@p_PrefConc		varchar(50),
	@p_CodiConc		varchar(256),
	@p_finiCntx		varchar(15),
	@p_ffinCntx		varchar(15) as

BEGIN
	--Si version = 0, significa que debe calcularse la ultima version para la empresa/instancia
	if(@p_VersInst = 0)
	begin
		select @p_VersInst = max(vers_inst) from dbax_inst_vers where codi_pers = @p_CodiPers and corr_inst = @p_CorrInst
	end
	
	select	dbo.separaMiles(dbo.FU_AX_getValorPorFecha(@p_CodiPers,@p_CorrInst,@p_VersInst,@p_PrefConc,@p_CodiConc,@p_finiCntx,@p_ffinCntx))
END
GO
