SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[SP_AX_insConcDife](
	@pCodi_pers numeric(9,0) ,
	@pCorr_inst varchar(10),
	@pVers_inst numeric(5,0),
	@pCodi_conc varchar(256),
	@pCodi_cntx varchar(256),
	@pValo_cntx varchar(256)) 
as
BEGIN
insert into dbax_dife_xbrl(codi_pers,corr_inst,vers_inst,codi_conc,codi_cntx,valo_cntx)
values (@pCodi_pers,@pCorr_inst,@pVers_inst,@pCodi_conc,@pCodi_cntx,@pValo_cntx)
END
GO
