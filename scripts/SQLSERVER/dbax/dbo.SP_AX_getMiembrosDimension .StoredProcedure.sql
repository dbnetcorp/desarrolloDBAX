SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getMiembrosDimension ]
	@p_CodiInfo varchar(256),
	@p_dimension varchar(256)
as
BEGIN
declare @v_eje varchar(256)

-- obtenciòn de eje por dimension

 set @v_eje =(select dd.codi_axis
			 from dbax_dime_diax dd,
			 dbax_defi_conc dc
			 where  dd.codi_dein = @p_CodiInfo
			 and    dd.codi_dime = @p_dimension
			 and    dd.codi_axis = dc.codi_conc)

-- obtenciòn de miembros por eje y dimension

		select distinct dm.pref_memb, dm.codi_memb, dc.desc_conc, dm.orde_memb, dm.tipo_memb
		from dbax_dime_diax dd,
		dbax_dime_memb dm,
		dbax_desc_conc dc
		where	dd.codi_dein = @p_CodiInfo
		and		dd.codi_dime = @p_dimension
		and		dd.codi_axis = @v_eje
		and		dd.codi_axis = dm.codi_axis
		and		dm.codi_memb = dc.codi_conc
		order by dm.orde_memb
END
GO
