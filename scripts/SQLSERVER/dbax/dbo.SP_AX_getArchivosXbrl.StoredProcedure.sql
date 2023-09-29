SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getArchivosXbrl] 
	@p_Codi_Pers numeric(9,0),
	@p_Corr_Inst  numeric(10,0),
    @p_Vers_Inst  numeric(5,0),
	@vNombArch	  varchar(256)=''
as
BEGIN
declare @V_cant_zip varchar (10)

	select  @V_cant_zip = count(*)
	from	dbax_inst_arch 
	where	codi_pers = @p_Codi_Pers 
	and		corr_inst = @p_Corr_Inst
	and		vers_inst  = @p_Vers_Inst
	and		substring(nomb_arch,charindex('.',nomb_arch), len(nomb_arch)) = '.zip'

	if ( @V_cant_zip = '0' and	len(@vNombArch)=0)
	begin
		select nomb_arch as Archivos,
               '' as Contenido
		from dbax_inst_arch 
		where codi_pers = @p_Codi_Pers
		and corr_inst = @p_Corr_Inst
		and vers_inst  = @p_Vers_Inst
	end
	else if(len(@vNombArch)=0)
	begin
       	select  nomb_arch as Archivos,
                '' as Contenido
		from dbax_inst_arch 
		where codi_pers = @p_Codi_Pers
		and corr_inst = @p_Corr_Inst
		and vers_inst  = @p_Vers_Inst
        and( substring(nomb_arch,charindex('.',nomb_arch), len(nomb_arch)) = '.pdf.zip'
        or substring(nomb_arch,charindex('.',nomb_arch), len(nomb_arch)) = '.zip'
        or substring(nomb_arch,charindex('.',nomb_arch), len(nomb_arch)) = '.pdf')
	end
	else
	begin
		select nomb_arch as Archivos,
               cont_arch as Contenido
		from dbax_inst_arch 
		where codi_pers = @p_Codi_Pers
		and corr_inst = @p_Corr_Inst
		and vers_inst  = @p_Vers_Inst
		and	nomb_arch = @vNombArch
	end
END
GO
