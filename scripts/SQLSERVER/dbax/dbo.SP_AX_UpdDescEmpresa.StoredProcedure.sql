SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_AX_UpdDescEmpresa](
@pCodiEmex varchar(30),
@pCodiEmpr numeric(9,0),
@pCodiPers numeric(9,0),
@pDescEmpr varchar(200),
@pCodiGrup varchar(50),
@pCodiSegm varchar(50),
@pTipoTaxo varchar(10)
)
AS
BEGIN
	IF (@pDescEmpr = '')
	BEGIN
		SET @pDescEmpr =  NULL;
	END

	IF (@pCodiGrup = '')
	BEGIN
		SET @pCodiGrup =  NULL;
	END

	IF (@pCodiSegm = '')
	BEGIN
		SET @pCodiSegm =  NULL;
	END	

	IF (@pTipoTaxo = '')
	BEGIN
		SET @pTipoTaxo =  NULL;
	END	

    update	dbax_defi_peho
	set		desc_empr = @pDescEmpr
	where	codi_emex = @pCodiEmex
	and		codi_empr = @pCodiEmpr
	and		codi_pers = @pCodiPers
	
	update	dbax_defi_pers
	set		codi_grup = @pCodiGrup,
			codi_segm = @pCodiSegm,
			tipo_taxo = @pTipoTaxo
	where	codi_pers = @pCodiPers
END
GO
