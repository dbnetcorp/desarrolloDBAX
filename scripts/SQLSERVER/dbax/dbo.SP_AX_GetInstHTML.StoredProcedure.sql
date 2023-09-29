SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_GetInstHTML](
@pCodiPers numeric(9,0),
@CorrInst numeric(10,0),
@VersInst numeric(5,0)
)
as
declare @vValo_html varchar(5000)
BEGIN
	select @vValo_html = valo_html 
	from dbax_dife_xbrl 
	where codi_pers=@pCodiPers 
	and corr_inst=@CorrInst 
	and vers_inst=@VersInst
	
	if(len(@vValo_html)>0)
	begin
		select @vValo_html
	end
	else
	begin
		select ''
	end
END
GO
