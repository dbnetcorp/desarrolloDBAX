SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_AX_insInstConc] (
@pCodiPers numeric(9,0),
@pCorrInst numeric(10,0),
 @pVersInst numeric(5,0),
@pPrefConc varchar(50),
@pCodiConc varchar(256),
@pCodiCntx varchar(256),
@pValoCntx varchar(5000),
@pCodiUnit varchar(50))
AS
BEGIN
insert into dbax_inst_conc (codi_pers, corr_inst, vers_inst, pref_conc, codi_conc, codi_cntx, valo_cntx, codi_unit) values (@pCodiPers,@pCorrInst,@pVersInst,@pPrefConc,@pCodiConc,@pCodiCntx,@pValoCntx,@pCodiUnit) 
END
GO
