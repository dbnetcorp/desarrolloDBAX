SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_GetBase64XBRL](
	@pCodi_pers numeric(9,0) ,
	@pCorr_inst varchar(10),
	@pNomb_Arch varchar(256)) as
BEGIN
	select top 1 cont_arch 
	from dbax_inst_arch 
	where codi_pers = @pCodi_pers
    and   corr_inst = @pCorr_inst
	and   nomb_arch = @pNomb_Arch
	order by vers_inst desc
END
GO
