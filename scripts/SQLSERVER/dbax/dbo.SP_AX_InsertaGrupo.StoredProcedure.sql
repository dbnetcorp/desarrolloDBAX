SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_AX_InsertaGrupo] (
@pNombreGrupo varchar(100)
)
AS
declare
@vCode varchar(100)
BEGIN
set @vCode = (select replace(@pNombreGrupo, ' ', ''))
set @vCode =  @vCode + '100'

insert into sys_code(code, code_desc, domain_code) 
values (@vCode,@pNombreGrupo,'100')
END
GO
