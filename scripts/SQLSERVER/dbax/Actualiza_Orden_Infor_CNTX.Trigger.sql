SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[Actualiza_Orden_Infor_CNTX]
ON [dbo].[dbax_info_cntx]
AFTER UPDATE 
AS
declare
	@nueva int,
	@antigua int,
	@orde_conc int,
	@codi_inct varchar(50),
	@codi_info varchar(100),
	@CodiCntx varchar(50)
BEGIN
	select  @antigua = orde_cntx, @CodiCntx = codi_cntx, @codi_info = codi_info  from  deleted
	select @nueva  = orde_cntx  from  INSERTED
	select @codi_inct = codi_inct  from  deleted

	--Si estoy moviendo concepto hacia abajo...
	if(@antigua < @nueva)
	begin
	    update	dbax_info_cntx
		set		orde_cntx = orde_cntx  -1
		where	orde_cntx <= @nueva
		and		orde_cntx > @antigua
        and		codi_info = @codi_info 
        and		codi_cntx != @CodiCntx
	end
	--Si estoy moviendo concepto hacia arriba...
    else if (@nueva < @antigua )
	begin 
        update	dbax_info_cntx
		set		orde_cntx = orde_cntx  +1
		where	orde_cntx >= @nueva
		and		orde_cntx < @antigua
        and		codi_info = @codi_info
        and		codi_cntx != @CodiCntx
	end
END
GO
