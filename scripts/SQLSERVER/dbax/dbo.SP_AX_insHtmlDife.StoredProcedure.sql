SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[SP_AX_insHtmlDife](
	@pCodi_pers numeric(9,0) ,
	@pCorr_inst varchar(10),
	@pVers_inst numeric(5,0),
	@pValo_html varchar(5000)) 
as
BEGIN
	insert into dbax_dife_xbrl values(@pCodi_pers,@pCorr_inst,@pVers_inst,@pValo_html)
END
GO
