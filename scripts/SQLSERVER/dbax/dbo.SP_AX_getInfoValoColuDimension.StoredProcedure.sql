SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getInfoValoColuDimension] 
	@p_CodiPers  numeric(9,0),
	@p_CorrInst  numeric(10,0),
	@p_VersInst  numeric(5,0),
	@p_codi_info varchar(50),
	@p_desc_miemb varchar(256),
	@p_dimension varchar(256),
    @p_tipo_memb varchar(256)
 as

BEGIN
declare @V_eje varchar(256)
declare @V_periodo_Inicio varchar(50)
declare @V_periodo_InicioCambiado varchar(50)
declare @V_periodo_Final varchar(50)
------------------------------------------------------------------------------------------------------
-- obtenciòn de eje por dimension
set @V_eje =(select dd.pref_axis + ':' + dd.codi_axis
			from dbax_dime_diax dd,
			dbax_defi_conc dc
			where  dd.codi_dein = @p_codi_info
			and    dd.codi_dime = @p_dimension
			and    dd.codi_axis = dc.codi_conc)
-------------------------------------------------------------------------------------------------------
print @V_eje 
-- período de inicio  termino de la dimension por informe ---------------------------------------------
   --INICIAL
SET @V_periodo_Inicio =(select dbo.FU_AX_getFechas(@p_CorrInst,diai_actu, anoi_actu) as período_inicial
			            from 
						dbax_dime_cntx
						where codi_fcdi = (select codi_fcdi 
										   from dbax_dime_defi
			   							   where codi_dime = @p_dimension
										   and codi_dein = @p_codi_info))

--SELECT DATEADD(year,DATEDIFF(year, 0, GETDATE()),0); PRIMER DIA DEL AÑO
print @V_periodo_Inicio
 IF ( @V_periodo_Inicio = '2012-01-01') 
	BEGIN                                

     SET @V_periodo_InicioCambiado  = (SELECT convert(varchar,DATEADD(DAY, -1, @V_periodo_Inicio), 23))         
	END

print @V_periodo_InicioCambiado

   -- FINAL
SET @V_periodo_Final =(select  dbo.FU_AX_getFechas(@p_CorrInst,diat_actu, anot_actu) as período_termino
						from 
						dbax_dime_cntx
						where codi_fcdi = (select codi_fcdi 
										   from dbax_dime_defi
			   							   where codi_dime = @p_dimension
										   and codi_dein = @p_codi_info))
print @V_periodo_Final
------------------------------------------------------------------------------------
print  @p_tipo_memb 

-- obtencion de los conceptos y valores -------------------------------------------------------
if( @p_tipo_memb = 'dimension-default')
	begin
		select 
		dbo.separaMiles(dbo.FU_AX_getValormiembroDimension(@p_CodiPers,
															@p_CorrInst,
															@p_VersInst,
															dc.pref_conc ,
															dc.codi_conc,
															@V_periodo_Inicio,
															@V_periodo_Final,
															null,
															null,
															dc.sald_ini,
															de.tipo_peri,
															@V_periodo_InicioCambiado)) as valo_cntx
		from 
		dbax_dime_conc dc,
		dbax_desc_conc des,
		dbax_defi_conc de
		where 
		dc.codi_dein = @p_codi_info
		and dc.codi_dime = @p_dimension
		and dc.codi_conc = des.codi_conc
		and des.codi_conc = de.codi_conc
		and dc.codi_conc = de.codi_conc
		and dc.pref_conc = des.pref_conc
		and dc.pref_conc = de.pref_conc
		and des.pref_conc = de.pref_conc
		order by dc.orde_conc
	end
else -- domain-member
	begin
		select 
		dbo.separaMiles(dbo.FU_AX_getValormiembroDimension(@p_CodiPers,
															@p_CorrInst,
															@p_VersInst,
															dc.pref_conc ,
															dc.codi_conc,
															@V_periodo_Inicio,
															@V_periodo_Final,
															@V_eje,
															@p_desc_miemb,
															dc.sald_ini,
															de.tipo_peri,
															@V_periodo_InicioCambiado)) as valo_cntx
		from 
		dbax_dime_conc dc,
		dbax_desc_conc des,
		dbax_defi_conc de
		where 
		dc.codi_dein = @p_codi_info
		and dc.codi_dime = @p_dimension
		and dc.codi_conc = des.codi_conc
		and des.codi_conc = de.codi_conc
		and dc.codi_conc = de.codi_conc
		and dc.pref_conc = des.pref_conc
		and dc.pref_conc = de.pref_conc
		and des.pref_conc = de.pref_conc
		order by dc.orde_conc
	end
---------------------------------------------------------------------------------------------
END
GO
