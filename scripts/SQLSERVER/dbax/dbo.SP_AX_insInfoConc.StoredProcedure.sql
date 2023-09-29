SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_AX_insInfoConc] 
@pCodiEmex varchar(30),
@pCodiEmpr numeric(9,0),
@p_Codi_info varchar(100),
@p_pref_conc varchar(50),
@p_Codi_Conc varchar(100),
@p_Orden varchar(10),
@p_Nivel varchar(10)
 as
BEGIN

insert dbax_info_conc (codi_emex, codi_empr, codi_info, pref_conc, codi_conc, orde_conc, nive_conc) 
values (@pCodiEmex, @pCodiEmpr,@p_Codi_info, @p_pref_conc, @p_Codi_Conc, @p_Orden, @p_Nivel)
END
GO
