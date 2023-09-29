SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_AX_UpdOrdenInforme] 
@CodiEmex varchar(30),
@CodiEmpr numeric(9,0),
@CodiInfo varchar(50),
@CodiCntx varchar(50),
@OrdeConcAnt numeric(5,0),
@OrdeConcAct numeric(5,0)
 as
BEGIN
	UPDATE	dbax_info_cntx 
	set		orde_cntx =  @OrdeConcAct
	where	codi_emex = @CodiEmex
	and		codi_empr = @CodiEmpr
	and		codi_info = @CodiInfo
	and		codi_cntx = @CodiCntx
	and		orde_cntx = @OrdeConcAnt
END
GO
