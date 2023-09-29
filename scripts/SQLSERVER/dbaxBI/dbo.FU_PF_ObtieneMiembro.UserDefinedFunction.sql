USE [dbaxBI]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[FU_PF_ObtieneMiembro] 
(
	-- Add the parameters for the function here
	@CodiPers varchar(16),
	@CorrInst numeric(10,0),
	@VersInst numeric(5,0),
	@CodiAxis varchar(256),
	@CodiCntx varchar(350),
	@Modo varchar(1)
)
RETURNS varchar(256)
AS
BEGIN
	DECLARE @vMiembro varchar(256)
	if(@Modo='S' and (@CodiAxis='cl-cs:DetalleSubRamosEje' or @CodiAxis='cl-cs:RentasVitaliciasEje'))
	begin
			select	@vMiembro = codi_memb 
			from	dbax.dbo.dbax_inst_dicx 
			where	codi_pers = @CodiPers
			and		corr_inst = @CorrInst
			and		vers_inst = @VersInst
			and		codi_cntx = @CodiCntx
			and		codi_axis = @CodiAxis
		
		if(@vMiembro is null)
			set @vMiembro = '0'
	end
	else
	if(@Modo='R' and @CodiAxis='cl-cs:RamosEje')
	begin
		/*select	@vMiembro = replace(replace(replace(replace(upper(dc.codi_memb),'TX','' ),':',''),'C',''),'ITEM','')
		from	dbax.dbo.dbax_inst_dicx dc
		where	dc.codi_pers = @CodiPers
		and		dc.corr_inst = @CorrInst
		and		dc.vers_inst = @VersInst
		and		dc.codi_cntx = @CodiCntx
		and		dc.codi_axis = @CodiAxis*/

		select	@vMiembro = replace(replace(replace(replace(replace(replace(replace(upper(im.desc_memb),'TX','' ),':',''),'C',''),'ITEM',''),',',''),'.',''),'RSA','')
		from	dbax.dbo.dbax_inst_dicx dc,
				dbax.dbo.dbax_inst_memb im
		where	dc.codi_pers = @CodiPers
		and		dc.corr_inst = @CorrInst
		and		dc.vers_inst = @VersInst
		and		dc.codi_cntx = @CodiCntx
		and		dc.codi_axis = @CodiAxis
		and		im.codi_pers collate Modern_Spanish_CI_AS = dc.codi_pers collate Modern_Spanish_CI_AS
		and		im.corr_inst = dc.corr_inst
		and		im.vers_inst = dc.vers_inst
		and		im.codi_memb collate Modern_Spanish_CI_AS = dc.codi_memb

		if(@vMiembro is null)
			set @vMiembro = '0'
	end

	return @vMiembro
END
GO
