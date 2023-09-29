SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[Actualiza_Orden_Infor]
	ON [dbo].[dbax_info_conc]
AFTER UPDATE 
AS
declare
	@CodiEmex varchar(30),	
	@CodiEmpr varchar(9),
	@CodiInfo varchar(50),
	@PrefConc varchar(50),
	@codi_conc varchar(100),
	@nueva int,
	@antigua int
BEGIN
	delete from TablaPrueba

	select	@CodiEmex = codi_emex,
			@CodiEmpr = codi_empr,
			@CodiInfo = codi_info, 
			@PrefConc = pref_conc, 
			@codi_conc = codi_conc,
			@antigua = orde_conc
	from  deleted;
	
	select @nueva = orde_conc  from  inserted;

	insert into TablaPrueba (colum1) values (@CodiEmex + ',' +@CodiEmpr+ ',' +@CodiInfo+ ',' +@PrefConc+ ',' + @codi_conc + ',' + convert(varchar,@antigua) + ',' + convert(varchar,@nueva))

	if(@antigua < @nueva)
	begin
		insert into TablaPrueba (colum1) values ('@antigua < @nueva')

	    update	dbax_info_conc
		set		orde_conc = orde_conc  -1
		where	codi_emex = @CodiEmex
		and		codi_empr = @CodiEmpr
		and		codi_info = @CodiInfo 
		and		pref_conc != @PrefConc 
		and		codi_conc != @codi_conc 
		and		orde_conc <= @nueva
		and		orde_conc > @antigua
	end;
    else if (@nueva < @antigua )
	begin 
		insert into TablaPrueba (colum1) values ('@antigua < @nueva')

        update	dbax_info_conc
		set		orde_conc = orde_conc  +1
		where	codi_emex = @CodiEmex
		and		codi_empr = @CodiEmpr
		and		codi_info = @CodiInfo 
		and		pref_conc != @PrefConc 
		and		codi_conc != @codi_conc 
		and		orde_conc >= @nueva
		and		orde_conc < @antigua
	end;
END;
GO
