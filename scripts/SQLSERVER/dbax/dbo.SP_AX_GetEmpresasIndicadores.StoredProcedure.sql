SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_GetEmpresasIndicadores]
as
BEGIN
select distinct indi.codi_empr,
				indi. codi_emex,
			    indi.codi_pers,
				indi.codi_indi,
				indi.corr_inst,
				vers.vers_inst
from dbax_temp_indi indi, dbax_inst_vers vers
where
indi.codi_pers = vers.codi_pers
and  vers.vers_inst in (select max (v.vers_inst)  
						from dbax_inst_vers v 
						where v.codi_pers = indi.codi_pers)
END
GO
