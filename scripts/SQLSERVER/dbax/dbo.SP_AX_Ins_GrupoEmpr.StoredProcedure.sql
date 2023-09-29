SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_AX_Ins_GrupoEmpr] (
@pcode varchar(100),
@pCodiPers numeric(9,0),
@pCodiEmex varchar(30),
@pCodiEmpr numeric(9,0))
AS
BEGIN
declare @Vdomain_code  varchar(50)

set @Vdomain_code =( select domain_code
from sys_code
where code = @pcode)

insert into dbax_pers_grup (codi_pers, codi_emex, code,codi_empr, domain_code) 
values (@pCodiPers,@pCodiEmex,@pcode,@pCodiEmpr, @Vdomain_code ) 
END
GO
