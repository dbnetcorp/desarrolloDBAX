SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_InsBase64XBRL](
	@pCodi_pers numeric(9,0) ,
	@pCorr_inst varchar(10),
	@pVersInst numeric(5,0),
	@pCont_arch text,
	@pNomb_Arch varchar(256),
    @pTipo_mime varchar(50)) as
BEGIN 
	insert into dbax_inst_arch (codi_pers,corr_inst,vers_inst,cont_arch,nomb_arch, tipo_mime) 
    values (@pCodi_pers,@pCorr_inst,@pVersInst,@pCont_arch,@pNomb_Arch,@pTipo_mime)
END
GO
