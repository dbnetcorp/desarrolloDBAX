USE [dbaxdesa]
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_DelTempIndi]    Fecha de la secuencia de comandos: 09/23/2013 12:13:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_DelTempIndi] as
BEGIN
	--truncate table dbax_temp_indi 
	select 1
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_GetValoInst]    Fecha de la secuencia de comandos: 09/23/2013 12:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_GetValoInst](
	@pCodi_pers numeric(9,0) ,
	@pCorr_inst varchar(10),
	@pVers_inst numeric(5,0),
	@pCodi_conc varchar(256),
	@pFini_cntx varchar(10),
	@pFfin_cntx varchar(10)) 
as
declare @pVers_ante numeric (5,0)
declare @vDesc_ante varchar(256)
declare @vDesc_actu varchar(256)
declare @vFini_ante varchar(10)
declare @vFini_actu varchar(10)
declare @vFfin_ante varchar(10)
declare @vFfin_actu varchar(10)
declare @vValo_ante varchar(100)
declare @vValo_actu varchar(100)


BEGIN
set @pVers_ante = @pVers_inst - 1
if(@pFfin_cntx='0')
set @pFfin_cntx =null

select @vDesc_ante=d.desc_conc,@vFini_ante=c.fini_cntx,@vFfin_ante=c.ffin_cntx,@vValo_ante =i.valo_cntx
--select d.desc_conc,c.fini_cntx,c.ffin_cntx,i.valo_cntx
	from dbax_inst_conc i,dbax_inst_cntx c,
	dbax_desc_conc d
	where c.codi_pers=i.codi_pers
	and c.corr_inst =i.corr_inst
	and c.vers_inst=i.vers_inst
	and c.codi_cntx=i.codi_cntx
	and d.pref_conc=i.pref_conc
	and d.codi_conc=i.codi_conc 
	and i.codi_pers = @pCodi_pers
	and i.corr_inst =@pCorr_inst
	and i.vers_inst= @pVers_ante 
	and i.codi_conc=@pCodi_conc
	and c.fini_cntx=@pFini_cntx
	and isnull(c.ffin_cntx,'')=isnull(@pFfin_cntx,'')

select @vDesc_actu=d.desc_conc,@vFini_actu=c.fini_cntx,@vFfin_actu=c.ffin_cntx,@vValo_actu=i.valo_cntx 
	from dbax_inst_conc i,dbax_inst_cntx c,
	dbax_desc_conc d
	where c.codi_pers=i.codi_pers
	and c.corr_inst=i.corr_inst
	and c.vers_inst=i.vers_inst
	and c.codi_cntx=i.codi_cntx
	and d.pref_conc=i.pref_conc
	and d.codi_conc=i.codi_conc 
	and i.codi_pers = @pCodi_pers
	and i.corr_inst=@pCorr_inst
	and i.vers_inst=@pVers_inst
	and i.codi_conc=@pCodi_conc
	and c.fini_cntx=@pFini_cntx
	and isnull(c.ffin_cntx,'')=isnull(@pFfin_cntx,'')

set @vDesc_actu=isnull(@vDesc_ante,@vDesc_actu)
set @vFini_actu=isnull(@vFini_ante,@vFini_actu)
set @vFfin_actu=isnull(@vFfin_ante,@vFfin_actu)


select @vDesc_actu desc_conc,@vFini_actu fini_cntx,@vFfin_actu ffin_cntx,@vValo_actu valo_actu,@vValo_ante valo_ante


END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_insCntxInst]    Fecha de la secuencia de comandos: 09/23/2013 12:13:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_AX_insCntxInst] (@pCodiPers numeric(9,0),@pCorrInst numeric(10,0), @pVersInst numeric(5,0),@pCodiCntx varchar(256))
AS
BEGIN
insert into dbax_inst_cntx (codi_pers, corr_inst, vers_inst, codi_cntx) values (@pCodiPers,@pCorrInst,@pVersInst,@pCodiCntx)
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_InstEmpreArchXbrl]    Fecha de la secuencia de comandos: 09/23/2013 12:13:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_AX_InstEmpreArchXbrl] (@pCodiPers numeric(9,0))
AS
BEGIN
insert into dbax_defi_pers (codi_pers) values (@pCodiPers)
END
GO
/****** Objeto:  UserDefinedFunction [dbo].[dbax_bi_getConcepto]    Fecha de la secuencia de comandos: 09/23/2013 12:13:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter function [dbo].[dbax_bi_getConcepto](@p_codi_info varchar(256), @p_codi_conc varchar(256)) returns varchar(256)
as
begin
  if (@p_codi_conc is null or @p_codi_conc = '')
  begin
	return ''
  end
  else if (@p_codi_conc = @p_codi_info)
  begin
    return @p_codi_info
  end
  else
  begin
    return @p_codi_info + '_' + replace(replace(replace(@p_codi_conc,'Abstract',''),'ifrs-cor_2011-03-25.xsd#ifrs_',''),'cl-cs_cor_2012-10-05.xsd#cl-cs_','')
  end
  return ''
end
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_UpdaCntxInst]    Fecha de la secuencia de comandos: 09/23/2013 12:13:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_AX_UpdaCntxInst] (@pFiniCntx varchar(10),@pFfinCntx varchar(10)='0' ,@pCodiPers numeric(9,0),@pCorrInst numeric(10,0), @pVersInst numeric(5,0),@pCodiCntx varchar(256))
AS
BEGIN

	if(@pFfinCntx='0')
	begin
		update dbax_inst_cntx set fini_cntx =@pFiniCntx where codi_pers =@pCodiPers and corr_inst=@pCorrInst and vers_inst=@pVersInst and codi_cntx =@pCodiCntx
	end
	else
	begin
		update dbax_inst_cntx set fini_cntx =@pFiniCntx, ffin_cntx =@pFfinCntx where codi_pers =@pCodiPers and corr_inst=@pCorrInst and vers_inst=@pVersInst and codi_cntx =@pCodiCntx
	end
END
GO
/****** Objeto:  UserDefinedFunction [dbo].[dbax_bi_getContexto]    Fecha de la secuencia de comandos: 09/23/2013 12:13:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER function [dbo].[dbax_bi_getContexto](@p_fech_inic varchar(10), @p_fech_fina varchar(10)) returns varchar(256)
as
begin
  if (@p_fech_fina is null or @p_fech_fina = '')
  begin
	return @p_fech_inic
  end
  else
  begin
	if substring(@p_fech_fina,6,2) = '06' or substring(@p_fech_fina,6,2) = '09'
	begin
      return substring(@p_fech_inic,1,8) + '01' + '/' + substring(@p_fech_fina,1,8) + '30'
	end
	else
	begin
      return substring(@p_fech_inic,1,8) + '01' + '/' + substring(@p_fech_fina,1,8) + '31'
	end
  end
  return ''
end
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_prueba]    Fecha de la secuencia de comandos: 09/23/2013 12:13:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_AX_prueba]
 (@CODI_PERS varchar(50),
  @PERIODO varchar(50))
AS

BEGIN

insert into PRUEBA (CODI_PERS, PERIODO)
        values (@CODI_PERS, @PERIODO)



END
GO
/****** Objeto:  UserDefinedFunction [dbo].[dbax_bi_getPeriodo]    Fecha de la secuencia de comandos: 09/23/2013 12:13:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter function [dbo].[dbax_bi_getPeriodo](@p_fech_inic varchar(10), @p_fech_fina varchar(10)) returns varchar(256)
as
begin
  if (@p_fech_fina is null or @p_fech_fina = '')
  begin
	return substring(@p_fech_inic,1,7)
  end
  else
  begin
    return substring(isnull(@p_fech_fina, @p_fech_inic),1,7)
  end
  return ''
end
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getIndicadores]    Fecha de la secuencia de comandos: 09/23/2013 12:13:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getIndicadores](
	@pCodi_emex varchar(30),
	@pCodi_empr  numeric(9,0)) as
BEGIN
	select codi_indi, tipo_conc, desc_indi, form_indi from dbax_form_enca where codi_emex = @pCodi_emex and codi_empr = @pCodi_empr
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_insInstConc]    Fecha de la secuencia de comandos: 09/23/2013 12:13:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_AX_insInstConc] (
@pCodiPers numeric(9,0),
@pCorrInst numeric(10,0),
 @pVersInst numeric(5,0),
@pPrefConc varchar(50),
@pCodiConc varchar(256),
@pCodiCntx varchar(256),
@pValoCntx varchar(5000),
@pCodiUnit varchar(50))
AS
BEGIN
insert into dbax_inst_conc (codi_pers, corr_inst, vers_inst, pref_conc, codi_conc, codi_cntx, valo_cntx, codi_unit) values (@pCodiPers,@pCorrInst,@pVersInst,@pPrefConc,@pCodiConc,@pCodiCntx,@pValoCntx,@pCodiUnit) 
END
GO
/****** Objeto:  UserDefinedFunction [dbo].[FU_AX_getValidaUsua]    Fecha de la secuencia de comandos: 09/23/2013 12:13:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Lorena Bezares>
-- alter date: <27-09-2012>
-- Description:	<valida si usuario y contraseña son validos>
-- =============================================
ALTER FUNCTION [dbo].[FU_AX_getValidaUsua] 
(@usua varchar(30), @pass varchar(30))
RETURNS VARCHAR(1)
AS

BEGIN
	declare @valida VARCHAR(1)

    set @valida = 'N'

	select @valida = 'S'
    from dbne_usua
	where pass_usua = master.dbo.fn_varbintohexstr(HASHBYTES('md5',@pass))
    and codi_usua = @usua

	-- Return the result of the function
	RETURN @valida

END
GO
/****** Objeto:  UserDefinedFunction [dbo].[AXgetValor]    Fecha de la secuencia de comandos: 09/23/2013 12:13:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER function [dbo].[AXgetValor](
			@p_codi_pers numeric(10), 
			@p_corr_inst numeric(5), 
			@p_vers_inst numeric(5), 
			@p_pref_conc varchar(256), 
			@p_codi_conc varchar(256), 
            @v_codi_cntx varchar(512),
            @v_codi_cntx2 varchar(512)
            ) 
            returns varchar(4000)
begin
	declare @v_valor varchar(4000)

	--select @v_valor = CONVERT(VarChar(50), cast( isnull(max(valo_cntx),'') as money ), 1)
	select	@v_valor =isnull(max(valo_cntx),'')
    from	dbax_inst_conc 
	where	codi_pers = @p_codi_pers 
	and		corr_inst = @p_corr_inst 
	and		vers_inst = @p_vers_inst 
	and		pref_conc = @p_pref_conc 
	and		codi_conc = @p_codi_conc 
	and		codi_cntx = @v_codi_cntx

	if(@v_valor = '')
	begin
        --select @v_valor = CONVERT(VarChar(50), cast( isnull(max(valo_cntx),'') as money ), 1)
	    select @v_valor =isnull(max(valo_cntx),'')
		from dbax_inst_conc 
		where codi_pers = @p_codi_pers 
		and corr_inst = @p_corr_inst 
		and vers_inst = @p_vers_inst 
		and pref_conc = @p_pref_conc 
		and codi_conc = @p_codi_conc 
		and codi_cntx = @v_codi_cntx2
	end

	return @v_valor
end
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_GetValoPara]    Fecha de la secuencia de comandos: 09/23/2013 12:13:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_GetValoPara](
	@pCodiPara varchar(30)='')
as
BEGIN
	if(len(@pCodiPara)>0)
	begin
		select	PARAM_VALUE
		from	sys_param
		where	PARAM_NAME = @pCodiPara
	end
	begin
		select	PARAM_DESC, PARAM_VALUE
		from	sys_param
	end
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_InsertarNuevoInforme]    Fecha de la secuencia de comandos: 09/23/2013 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_AX_InsertarNuevoInforme]
 (@pInforme varchar(50),
  @pCodiEmpr varchar(20))
AS
declare
@codi_informe varchar(100)
BEGIN
 set @codi_informe = (select replace(@pInforme,' ',''))

insert into dbax_info_defi (codi_empr, codi_info)
        values (@pCodiEmpr, @codi_informe)

insert into dbax_desc_info (codi_empr, codi_info, codi_lang, desc_info )
        values (@pCodiEmpr,@codi_informe  ,'es_ES',@pInforme)

END
GO
/****** Objeto:  UserDefinedFunction [dbo].[AXgetCntx]    Fecha de la secuencia de comandos: 09/23/2013 12:13:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER function [dbo].[AXgetCntx](
			@p_codi_empr numeric(10), 
			@p_fini_cntx varchar(50),
			@p_ffin_cntx varchar(50)) returns varchar(4000)
begin
	declare @v_codi_cntx varchar(512)

	select @v_codi_cntx = codi_cntx
	from dbax_inst_cntx ic 
	where ic.codi_pers = @p_codi_empr
	and ic.corr_inst = @p_codi_empr
	and ic.vers_inst = 1 
	and	ic.fini_cntx = @p_fini_cntx
	and	isnull(ic.ffin_cntx,'') = isnull(@p_ffin_cntx,'')
	and ic.codi_cntx not in (
			select di.codi_cntx 
			from dbax_inst_dicx di 
			where di.codi_pers = @p_codi_empr
			and di.corr_inst = @p_codi_empr
			and di.vers_inst = 1)

	return @v_codi_cntx
end
GO
/****** Objeto:  UserDefinedFunction [dbo].[lastday]    Fecha de la secuencia de comandos: 09/23/2013 12:13:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter function [dbo].[lastday](@pPeriodo varchar(6)) returns datetime
begin
  return cast(convert(char(11), DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,convert(datetime,convert(datetime, @pPeriodo + '01', 112), 112))+1,0)),112) as datetime)
end
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_GetRutaXBRL]    Fecha de la secuencia de comandos: 09/23/2013 12:13:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter procedure [dbo].[SP_AX_GetRutaXBRL]
as
BEGIN
	select PARAM_VALUE
	from sys_param
	where PARAM_NAME='DBAX_XBRL_PATH'

END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_list_dyn]    Fecha de la secuencia de comandos: 09/23/2013 12:12:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Hector Parra
-- alter date: 2012-10-01
-- Description:	Permite Ejecutar Procedimientos del Listador
-- =============================================
ALTER PROCEDURE [dbo].[prc_list_dyn] (
	@tsSql varchar(8000), 
	@tnPagina as integer,	
	@tnRegPag as integer)
AS
	declare @lsSql as varchar(8000)
	declare @lnSql as nvarchar(4000)
	declare @lsPagina as varchar(15)
	declare @lsRegPag as varchar(15)
BEGIN
	set @lsPagina = convert(varchar(15), @tnPagina)
	set @lsRegPag = convert(varchar(15), @tnRegPag)
	set @lsSql = 	'SELECT top ' + @lsRegPag + ' (SELECT MAX(REG) FROM (' + @tsSql + ') REG_TMP ) TOT_REG, (SELECT CONVERT(INTEGER, MAX(REG/' + @lsRegPag + '))  FROM (' + @tsSql + ') REG_TMP) PAG_MAX, * FROM (' + @tsSql + ') REPO WHERE REPO.REG BETWEEN ' + str((@tnPagina -1 ) * @tnRegPag + 1) + ' AND ' + str(@tnPagina * @tnRegPag )+''
	
	set @lsSql = REPLACE(@lsSql,CHAR(9)+ CHAR(9),CHAR(9))
	set @lsSql = REPLACE(@lsSql,CHAR(9)+ CHAR(9),CHAR(9))
	set @lsSql = REPLACE(@lsSql,CHAR(9)+ CHAR(9),CHAR(9))
	set @lsSql = REPLACE(@lsSql,CHAR(9)+ CHAR(9),CHAR(9))
	set @lsSql = REPLACE(@lsSql,CHAR(9)+ CHAR(9),CHAR(9))
	set @lsSql = REPLACE(@lsSql,'  ',' ')
	set @lsSql = REPLACE(@lsSql,'  ',' ')
	set @lsSql = REPLACE(@lsSql,'  ',' ')
	set @lsSql = REPLACE(@lsSql,'  ',' ')
	set @lsSql = REPLACE(@lsSql,'  ',' ')
	set @lsSql = REPLACE(@lsSql,CHAR(10)+ CHAR(9),CHAR(9))
	set @lsSql = REPLACE(@lsSql,CHAR(13)+ CHAR(9),CHAR(9))
	set @lsSql = REPLACE(@lsSql,CHAR(9)+ CHAR(10),CHAR(9))
	set @lsSql = REPLACE(@lsSql,CHAR(9)+ CHAR(13),CHAR(9))
	
	set @lnSql = @lsSql

	execute sp_executesql @lnSql
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_ejem]    Fecha de la secuencia de comandos: 09/23/2013 12:13:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_ejem](
	@p_CodiConc  varchar(100)) as
BEGIN
	select codi_conc from dbax_defi_conc	where codi_conc like '%' + @p_CodiConc + '%'
END
GO
/****** Objeto:  UserDefinedFunction [dbo].[rpad]    Fecha de la secuencia de comandos: 09/23/2013 12:13:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter function [dbo].[rpad]
(
	@pad_value varchar(500),
	@pad_length int,
	@pad_with varchar(10)
)
returns varchar(5000)
as
BEGIN
	declare @valueResult varchar(5000)
	select  @valueResult=@pad_value+replace(replace(str(@pad_value,@pad_length),' ',@pad_with),@pad_value,'')
	return  @valueResult
END
GO
/****** Objeto:  UserDefinedFunction [dbo].[lpad]    Fecha de la secuencia de comandos: 09/23/2013 12:13:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter function [dbo].[lpad]
(
	@pad_value varchar(500),
	@pad_length int,
	@pad_with varchar(10)
)
returns varchar(5000)
as
BEGIN
	Declare @value_result varchar(5000)
	select  @value_result= replace(str(@pad_value,@pad_length),' ',@pad_with) 
	return  @value_result
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_sys_relation_alter_menu]    Fecha de la secuencia de comandos: 09/23/2013 12:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas
-- alter date: 30-01-2013
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_sys_relation_alter_menu](
	@P_NOMB_MENU VARCHAR(30),
	@P_CODI_MODU VARCHAR(30),
	@P_NOMB_ROUS VARCHAR(30)
	)
AS
BEGIN
	insert into sys_relation(number_key, source_mand, source_card, source_dele,target_mand, target_card, relation_type, key1, key2, key3, key4,target_type, target_desc, target_object, source_object, source_desc,   source_type)
                select 1, 'N', 'M', 'M','S', 'U', 'F', 'S', 'S', 'S', 'S','L','#ROUS1#',@P_NOMB_ROUS,object_name, object_brief,object_type from sys_object where object_type!='L' and codi_modu = @P_CODI_MODU and object_code is not null
                and object_name=@P_NOMB_MENU;
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_sys_relation_delete]    Fecha de la secuencia de comandos: 09/23/2013 12:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 12-07-2013
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_sys_relation_delete](
	@P_CODI_MODU VARCHAR(30),
	@P_CODI_ROUS VARCHAR(30)
)
AS
BEGIN
	delete 
		from 	sys_relation 
		where 	target_object 	like '%' +@P_CODI_MODU +'%' 
		and 	target_object =		@P_CODI_ROUS;
END
GO
/****** Objeto:  UserDefinedFunction [dbo].[FU_AX_getFechas]    Fecha de la secuencia de comandos: 09/23/2013 12:13:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER function [dbo].[FU_AX_getFechas](
			@p_CorrInst numeric(10,0), 
			@p_DiaMes varchar(256),
			@p_Ano varchar(256)
			) returns varchar(4000)
begin
	declare @v_Valor varchar(256)
	declare @vMesActual varchar(2)
	declare @vAnoActual varchar(4)
	declare @vMes varchar(10)
	declare @vAno varchar(4)
	declare @vUltiDiaMes varchar(4)
	declare @vUltiDiaAno varchar(10)
	declare @vFechaActual varchar(15)
	declare @vFinTrimestreAnt varchar(4)
	declare @vPrimerDiaAno varchar(10)
	declare @vAnoAnterior varchar(10)
	declare @vAnoPrevioAnt varchar(10)

	select @vAnoActual=substring(convert(varchar,@p_CorrInst),1,4)
	select @vMesActual=substring(convert(varchar,@p_CorrInst),5,2)

	set @vFechaActual = @vAnoActual + @vMesActual + '01'
	set @vUltiDiaMes = substring(replace(convert(varchar, DATEADD(dd, -DAY(DATEADD(m,1,@vFechaActual)), DATEADD(m,1,@vFechaActual)), 111),'/',''),5,4)
	set @vFinTrimestreAnt = substring(replace(convert(varchar, DATEADD(dd, -DAY(DATEADD(m,-2,@vFechaActual)), DATEADD(m,-2,@vFechaActual)), 111),'/',''),5,4)
	set @vUltiDiaAno = '1231'
	set @vPrimerDiaAno = '0101'
	set @vAnoAnterior = @vAnoActual - 1
	set @vAnoPrevioAnt = @vAnoActual - 2

	if(@p_Ano = 'anoactual')
		set @vAno = @vAnoActual
	else if(@p_Ano = 'anoanterior')
		set @vAno = @vAnoAnterior
	else if(@p_Ano = 'anoprevioanterior')
		set @vAno = @vAnoPrevioAnt

	if(@p_DiaMes = 'finano')
		set @vMes = @vUltiDiaAno
	else if(@p_DiaMes = 'inicioano')
		set @vMes = @vPrimerDiaAno
	else if(@p_DiaMes = 'iniciotrimestreactual')
		set @vMes = @vFinTrimestreAnt
	else if(@p_DiaMes = 'ultimodiatrimestreactual')
		set @vMes = @vUltiDiaMes
	
	return @vAno + '-' +  substring(@vMes,1,2) + '-' + substring(@vMes,3,2)
end
GO
/****** Objeto:  StoredProcedure [dbo].[prc_rous_menu_relation_alter]    Fecha de la secuencia de comandos: 09/23/2013 12:12:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas
-- alter date: 30-01-2013
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_rous_menu_relation_alter](
	@P_NOMB_MENU VARCHAR(30),
	@P_CODI_MODU VARCHAR(30),
	@P_NOMB_ROUS VARCHAR(30)
	)
AS
BEGIN
	insert  sys_relation(number_key, source_mand, source_card, source_dele,target_mand, target_card, relation_type, key1, key2, key3, key4,target_type, target_desc, target_object, source_object, source_desc,   source_type)
                select 1, 'N', 'M', 'M','S', 'U', 'F', 'S', 'S', 'S', 'S','L','#ROUS1#',@P_NOMB_ROUS,object_name, object_brief,object_type from sys_object where object_type!='L' and codi_modu = @P_CODI_MODU and object_code is not null
                and object_name=@P_NOMB_MENU;
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_Get_Ingreso]    Fecha de la secuencia de comandos: 09/23/2013 12:13:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_Get_Ingreso](
	@p_CodiEmpr numeric(9,0),
    @p_CodiEmex varchar(30))
as
BEGIN
	SELECT COUNT(*) as contador
    FROM dbax_pers_grup 
    WHERE codi_empr = @p_CodiEmpr and codi_emex = @p_CodiEmex
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_Del_grupo]    Fecha de la secuencia de comandos: 09/23/2013 12:13:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_AX_Del_grupo] (
@pCodiEmpr numeric(9,0),
@pCodiEmex varchar(30)
)
AS
BEGIN
delete dbax_pers_grup 
where codi_empr = @pCodiEmpr 
and codi_emex = @pCodiEmex
END
GO
/****** Objeto:  UserDefinedFunction [dbo].[esNumero]    Fecha de la secuencia de comandos: 09/23/2013 12:13:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER function [dbo].[esNumero](@p_valor varchar(200)) returns varchar(1)
begin
	declare @i int
	declare @l numeric
	declare @r varchar(1)

	set @i = 1
	set @r = 'S'
	set @l = len(@p_valor)
	
	if(@l = 1 AND @p_valor in ('-', '.', ',', ' '))
		return 'N'

	while (@i <= len(@p_valor) AND @r = 'S')
	begin
		if (@i = 1 AND substring(@p_valor,@i,1) not in ('0','1','2','3','4','5','6','7','8','9','.','-'))
		begin
			set @r = 'N'
		end
		else if (@i > 1 AND substring(@p_valor,@i,1) not in ('0','1','2','3','4','5','6','7','8','9','.'))
		begin
			set @r = 'N'
		end
		set @i = @i + 1
	end

    return @r
end
GO
/****** Objeto:  StoredProcedure [dbo].[prc_mens_erro]    Fecha de la secuencia de comandos: 09/23/2013 12:12:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas
-- alter date: 05-06-2013
-- Description:	Procedimiento que inserta los errores de SQL en la BD
-- =============================================
ALTER PROCEDURE [dbo].[prc_mens_erro] 
	(
		@p_codi_erro int,
		@p_mens_erro varchar(4000),
		@p_line_erro varchar(256), 
		@p_prcc_erro varchar(256),
		@p_corr_sess int
	)
AS	
BEGIN
	INSERT INTO dbn_mens_erro(codi_erro, mens_erro, line_erro, prcc_erro, corr_sess)
	VALUES(@p_codi_erro, @p_mens_erro,@p_line_erro,@p_prcc_erro, @p_corr_sess);
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getEmpresa]    Fecha de la secuencia de comandos: 09/23/2013 12:13:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getEmpresa](
@pCodiPers varchar(100)
)
as
BEGIN
	select isnull(max(1),0) from dbax_defi_pers where codi_pers = @pCodiPers
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_dbn_defi_mone_update]    Fecha de la secuencia de comandos: 09/23/2013 12:11:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 12-04-2013
-- Description:	<Description,,>
-- =============================================
alter  procedure [dbo].[prc_dbn_defi_mone_update]
            @P_CODI_MONE VARCHAR(3), 
            @P_NOMB_MONE VARCHAR(50), 
            @P_CODI_PAIS VARCHAR(2), 
            @P_ROUN_MONE numeric(2, 0) 
 AS
 BEGIN
        UPDATE dbn_defi_mone
             SET codi_mone = @P_CODI_MONE, 
                 nomb_mone = @P_NOMB_MONE, 
                 codi_pais = @P_CODI_PAIS, 
                 roun_mone = @P_ROUN_MONE
             WHERE codi_mone = @P_CODI_MONE 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_dbn_defi_mone_read]    Fecha de la secuencia de comandos: 09/23/2013 12:11:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 12-04-2013
-- Description:	<Description,,>
-- =============================================
alter  procedure [dbo].[prc_dbn_defi_mone_read] (
 @tsTipo as VARCHAR(4),
 @tnPagina as INTEGER,
 @tnRegPag as INTEGER,
 @tsCondicion as VARCHAR(2048),
 @tsPar1 as VARCHAR(256), @tsPar2 as VARCHAR(256),
 @tsPar3 as VARCHAR(256), @tsPar4 as VARCHAR(256), @tsPar5 as VARCHAR(256),
 @p_codi_usua VARCHAR(30), @p_codi_empr INTEGER, @p_codi_emex VARCHAR(30))
AS 
    /*
     Procedimiento para rescatar datos de la tabla DBN_DEFI_MONE
     CON EL 
     Parametros
        @tsTipo 
            S: Query utilizada para el mantenedor 
            L: Query utilizada para el listador 
            LV: Query utilizada para las listas de valor 
        @tnPagina	: Numero de pagina a rescatar 
        @tnRegPag	: Numero de registros por pagina
        @tsCondicion : Condicion, clausula Where
        @tsPar1		: Parametro 1 - 
        @tsPar2		: Parametro 2 - 
        @tsPar3		: Parametro 3 - 
        @tsPar4		: Parametro 4 - 
        @tsPar5		: Parametro 5 - 
        @p_codi_usua    : Usuario
        @p_codi_empr    : Empresa
        @p_codi_emex    : Emex
     */
     declare @sql_dyn as INTEGER
     declare @sql as nVARCHAR(4000)
BEGIN
  IF (@tsTipo = 'S')
  BEGIN
    SELECT codi_mone, 
           nomb_mone, 
           codi_pais, 
           roun_mone
  FROM dbn_defi_mone
  WHERE codi_mone = @tspar1
 END
 ELSE IF (@tsTipo = 'L')
 BEGIN
   SET @sql = 'SELECT ROW_NUMBER() OVER(ORDER BY codi_mone ASC) AS REG, 
                codi_mone, nomb_mone, codi_pais, 
                roun_mone
               FROM dbn_defi_mone
               WHERE 1 = 1 '
 
   SET @sql = @sql + isnull(@tsCondicion,'')
   EXECUTE prc_list_dyn @sql, @tnPagina, @tnRegPag 
 END
 ELSE IF(@tsTipo = 'LV')
 BEGIN
	SELECT codi_mone AS CODIGO,
			nomb_mone as VALOR
	FROM dbn_defi_mone
	ORDER BY codi_mone asc;
 END
END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_dbn_defi_mone_delete]    Fecha de la secuencia de comandos: 09/23/2013 12:11:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 12-04-2013
-- Description:	<Description,,>
-- =============================================
alter  procedure [dbo].[prc_dbn_defi_mone_delete]
            @P_CODI_MONE VARCHAR(3) 
 AS
 BEGIN
        DELETE dbn_defi_mone
        WHERE codi_mone = @P_CODI_MONE 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_dbn_defi_mone_alter]    Fecha de la secuencia de comandos: 09/23/2013 12:11:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 12-04-2013
-- Description:	<Description,,>
-- =============================================
alter  procedure [dbo].[prc_dbn_defi_mone_alter]
            @P_CODI_MONE VARCHAR(3), 
            @P_NOMB_MONE VARCHAR(50), 
            @P_CODI_PAIS VARCHAR(2), 
            @P_ROUN_MONE numeric(2, 0) 
 AS
 BEGIN
        INSERT INTO dbn_defi_mone(
            codi_mone, 
            nomb_mone, 
            codi_pais, 
            roun_mone
        )
        VALUES
        (
             @P_CODI_MONE, 
             @P_NOMB_MONE, 
             @P_CODI_PAIS, 
             @P_ROUN_MONE
        );
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_dbn_camb_mone_delete]    Fecha de la secuencia de comandos: 09/23/2013 12:11:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 12-04-2013
-- Description:	<Description,,>
-- =============================================
alter  procedure [dbo].[prc_dbn_camb_mone_delete]
            @P_CODI_MONE VARCHAR(3) 
 AS
 BEGIN
        DELETE dbn_camb_mone
        WHERE codi_mone = @P_CODI_MONE 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_dbn_camb_mone_alter]    Fecha de la secuencia de comandos: 09/23/2013 12:11:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 12-04-2013
-- Description:	<Description,,>
-- =============================================
alter  procedure [dbo].[prc_dbn_camb_mone_alter]
            @P_CODI_MONE VARCHAR(3), 
            @P_CODI_MONE1 VARCHAR(3), 
            @P_FECH_CAMO datetime, 
            @P_VALO_CAMO numeric(18, 4), 
            @P_CODI_EMEX VARCHAR(30) 
 AS
 BEGIN
        INSERT INTO dbn_camb_mone(
            codi_mone, 
            codi_mone1, 
            fech_camo, 
            valo_camo, 
            codi_emex
        )
        VALUES
        (
             @P_CODI_MONE, 
             @P_CODI_MONE1, 
             @P_FECH_CAMO, 
             @P_VALO_CAMO, 
             @P_CODI_EMEX
        );
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_read_dbax_homo_conc]    Fecha de la secuencia de comandos: 09/23/2013 12:12:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  procedure [dbo].[prc_read_dbax_homo_conc] (
 @tsTipo as Varchar(2),
 @tnPagina as integer,
 @tnRegPag as integer,
 @tsCondicion as Varchar(2048),
 @tsPar1 as Varchar(30), @tsPar2 as Varchar(30),
 @tsPar3 as Varchar(30), @tsPar4 as Varchar(30), @tsPar5 as Varchar(30),
 @p_codi_usua varchar(30), @p_codi_empr int, @p_codi_emex varchar(30))
AS 
    /*
     Procedimiento para rescatar datos de la tabla DBAX_HOMO_CONC
     CON EL 
     Parametros
        @tsTipo 
            S: Query utilizada para el mantenedor 
            L: Query utilizada para el listador 
            LV: Query utilizada para las listas de valor 
        @tnPagina	: Numero de pagina a rescatar 
        @tnRegPag	: Numero de registros por pagina
        @tsCondicion : Condicion, clausula Where
        @tsPar1		: Parametro 1 - codi_hoco
        @tsPar2		: Parametro 2 - 
        @tsPar3		: Parametro 3 - 
        @tsPar4		: Parametro 4 - 
        @tsPar5		: Parametro 5 - 
        @p_codi_usua    : Usuario
        @p_codi_empr    : Empresa
        @p_codi_emex    : Emex
     */
     declare @sql_dyn as integer
     declare @sql as nvarchar(4000)
BEGIN
  IF (@tsTipo = 'S')
  BEGIN
    SELECT codi_hoco, 
           tipo_taxo, 
           pref_conc, 
           vers_taxo, 
           vers_taxo_dest, 
           fech_hoco,
		   fini_homo,
		   ffin_homo
  FROM dbax_homo_conc
  WHERE codi_hoco = @tsPar1
 END
 ELSE IF (@tsTipo = 'L')
 BEGIN
   SET @sql = 'SELECT ROW_NUMBER() OVER(ORDER BY codi_hoco ASC) AS REG, 
                codi_hoco, tipo_taxo, pref_conc, 
                vers_taxo, vers_taxo_dest, SUBSTRING(CONVERT(varchar(30),fech_hoco,105),0,11) fech_hoco,
				CONVERT(varchar(30),fini_homo,120) fini_homo,
				CONVERT(varchar(30),ffin_homo,120) ffin_homo
               FROM dbax_homo_conc
               WHERE 1 = 1 '
 
   SET @sql = @sql + isnull(@tsCondicion,'')
   EXECUTE dbo.prc_list_dyn @sql, @tnPagina, @tnRegPag 
 END
END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_alter_dbax_homo_conc]    Fecha de la secuencia de comandos: 09/23/2013 12:11:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 19-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_alter_dbax_homo_conc] 
            @P_TIPO_TAXO varchar(10), 
            @P_PREF_CONC varchar(50), 
            @P_VERS_TAXO varchar(256), 
            @P_VERS_TAXO_DEST varchar(256)
 AS
 BEGIN
        INSERT INTO dbax_homo_conc(
            tipo_taxo, 
            pref_conc, 
            vers_taxo, 
            vers_taxo_dest, 
            fech_hoco
        )
        VALUES
        (
             @P_TIPO_TAXO, 
             @P_PREF_CONC, 
             @P_VERS_TAXO, 
             @P_VERS_TAXO_DEST, 
             GETDATE()
        );
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_delete_dbax_homo_conc]    Fecha de la secuencia de comandos: 09/23/2013 12:11:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 19-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_delete_dbax_homo_conc]
            @P_CODI_HOCO numeric(22, 0) 
 AS
 BEGIN
        DELETE dbax_homo_conc
        WHERE codi_hoco = @P_CODI_HOCO 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_update_dbax_homo_conc]    Fecha de la secuencia de comandos: 09/23/2013 12:12:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 18-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_update_dbax_homo_conc]
            @P_CODI_HOCO numeric(22, 0), 
            @P_TIPO_TAXO varchar(10), 
            @P_PREF_CONC varchar(50), 
            @P_VERS_TAXO varchar(256), 
            @P_VERS_TAXO_DEST varchar(256)
 AS
 BEGIN
        UPDATE dbax_homo_conc
             SET tipo_taxo = @P_TIPO_TAXO, 
                 pref_conc = @P_PREF_CONC, 
                 vers_taxo = @P_VERS_TAXO, 
                 vers_taxo_dest = @P_VERS_TAXO_DEST
             WHERE codi_hoco = @P_CODI_HOCO 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_dbax_proc_homo]    Fecha de la secuencia de comandos: 09/23/2013 12:11:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[prc_dbax_proc_homo]
(
	@p_tipo_taxo varchar(10),
	@p_pref_conc varchar(10),
	@p_fein_proc datetime,
	@p_erro varchar(30) output,
	@p_mens varchar(250) output
)
AS
DECLARE @p_donde VARCHAR(200)
DECLARE	@c_codi_hoco VARCHAR(22), 
		@c_tipo_taxo VARCHAR(10), 
		@c_pref_conc VARCHAR(50),
		@c_vers_taxo VARCHAR(256), 
		@c_vers_taxo_dest VARCHAR(256), 
		@c_fech_hoco datetime

BEGIN TRY
	SET @p_donde = 'Declare'
	DECLARE  hc CURSOR FOR
		SELECT codi_hoco, tipo_taxo, pref_conc, vers_taxo, vers_taxo_dest, fech_hoco  
		FROM   dbax_homo_conc
		WHERE tipo_taxo = @p_tipo_taxo
		and   pref_conc = @p_pref_conc
		and   fech_hoco = @p_fein_proc
		order by fech_hoco;

	SET @p_donde = 'Inicio'
	OPEN hc
		FETCH NEXT FROM hc
		INTO @c_codi_hoco, @c_tipo_taxo, @c_pref_conc, @c_vers_taxo, @c_vers_taxo_dest, @c_fech_hoco
		WHILE(@@FETCH_STATUS = 0)
				BEGIN
				SET @p_donde = 'Homologando Conceptos: homologación '+ @c_codi_hoco
				
				update dbax_homo_conc 
				set fini_homo = getdate(),
					ffin_homo = null
				WHERE codi_hoco = @c_codi_hoco
				
				update dbax_inst_conc
				set	  pref_conc1 = c.pref_conc,
				      codi_conc1 = c.codi_conc
				from  dbax_inst_conc c,
					  dbax_homo_deta d
				where d.codi_hoco = @c_codi_hoco
				and	  d.codi_conc = c.codi_conc
				and	  d.pref_conc = c.pref_conc
				and   c.pref_conc1 is null
				and   c.codi_conc1 is null;

				/*select c.pref_conc1, c.pref_conc, c.codi_conc1, c.codi_conc
				from  dbax_inst_conc c,
					  dbax_homo_deta d
				where d.codi_hoco = @c_codi_hoco
				and	  d.codi_conc = c.codi_conc
				and	  d.pref_conc = c.pref_conc
				and   c.pref_conc1 is null
				and   c.codi_conc1 is null;*/
				
				
				update dbax_inst_conc
				set   pref_conc = d.pref_conc1,
				      codi_conc = d.codi_conc1
				from  dbax_inst_conc c,
					  dbax_homo_deta d
				where d.codi_hoco = @c_codi_hoco
				and	  d.pref_conc = c.pref_conc1
				and	  d.codi_conc = c.codi_conc1
				
				
				/*select c.pref_conc, d.pref_conc1, c.codi_conc, d.codi_conc1
				from  dbax_inst_conc c,
					  dbax_homo_deta d
				where d.codi_hoco = @c_codi_hoco
				and	  d.pref_conc = c.pref_conc1
				and	  d.codi_conc = c.codi_conc1*/

				update dbax_homo_conc 
				set ffin_homo = getdate() 
				WHERE codi_hoco = @c_codi_hoco

				FETCH NEXT FROM hc
				INTO @c_codi_hoco, @c_tipo_taxo, @c_pref_conc, @c_vers_taxo, @c_vers_taxo_dest, @c_fech_hoco
			END
	CLOSE hc;
	DEALLOCATE hc;
END TRY
BEGIN CATCH
	CLOSE hc;
	DEALLOCATE hc;
	
	set @p_erro = 'S'
	set @p_mens = 'Error: dbax_proc_homo'+' '+@p_donde+' - '+SUBSTRING(ERROR_MESSAGE(),0,200)
END CATCH
GO
/****** Objeto:  StoredProcedure [dbo].[prc_dbax_inse_data_hira]    Fecha de la secuencia de comandos: 09/23/2013 12:11:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[prc_dbax_inse_data_hira]
(
	@p_codi_pers VARCHAR(16),
	@p_corr_inst NUMERIC(10),
	@p_vers_inst NUMERIC(5),
	@p_codi_emex VARCHAR(30),
	@p_codi_empr NUMERIC(16)
)
AS
BEGIN

delete dbax_data_hira
where  peri_conc = @p_corr_inst
and    codi_pers = @p_codi_pers

insert dbax_data_hira
select  distinct 
		'1'				codi_emex,
		ic.codi_pers,
		'svs-cs-2011'	vers_taxo,
		ic.corr_inst    peri_conc,
		''				codi_node,
		''				pref_conc,        
		cc.codi_conc	codi_conc,
		ir.codi_ramo	codi_ramo,
		0	            valo_conc,
		ic.valo_cntx    valo_base,
		replace(ic.valo_refe,',','.') valo_refe,
		replace(ic.valo_inte,',','.') valo_extr,
		ir.codi_subr	sub_ramo,
		'' codi_ramoo,
		'' ramo_orig
from    dbax_dime_diax dd,
	    dbax_dime_conc dc,
	    dbax_inst_conc ic,
	    dbax_inst_ramo ir,
	    dbax_desc_conc cc
where	dd.codi_dein like '%cuadro%'
and     dc.codi_dime = dd.codi_dime
and     ic.codi_pers = @p_codi_pers
and		ic.corr_inst = @p_corr_inst
and		ic.vers_inst = @p_vers_inst
and     ic.codi_conc = dc.codi_conc
and     ic.valo_cntx != '0'
and     ir.codi_pers = ic.codi_pers
and		ir.corr_inst = ic.corr_inst
and		ir.vers_inst = ic.vers_inst
and     ir.codi_cntx = ic.codi_cntx
and     replace(substring(isnull(ir.ffin_cntx,ir.fini_cntx),1,7),'-','') = ic.corr_inst
and     cc.pref_conc = ic.pref_conc
and     cc.codi_conc = ic.codi_conc

--select  distinct 
--		'1'				codi_emex,
--		ic.codi_pers,
--		'svs-cs-2011'	vers_taxo,
--		ic.corr_inst    peri_conc,
--		''				codi_node,
--		''				pref_conc,        
--		cc.codi_conc	codi_conc,
--		id.desc_memb	codi_ramo,
--		0	            valo_conc,
--		ic.valo_cntx    valo_base,
--		0				valo_refe,
--		0				valo_extr
--from    dbax_inst_dicx id,
--	    dbax_dime_diax dd,
--	    dbax_dime_conc dc,
--	    dbax_inst_conc ic,
--	    dbax_inst_cntx ct,
--	    dbax_desc_conc cc
--where	id.codi_pers = @p_codi_pers
--and		id.corr_inst = @p_corr_inst
--and		id.vers_inst = @p_vers_inst
--and     dc.codi_dein like '%cuadro%'
--and     dc.codi_dime = dd.codi_dime
--and     ic.codi_pers = id.codi_pers
--and     ic.corr_inst = id.corr_inst
--and     ic.vers_inst = id.vers_inst
--and     ic.codi_conc = dc.codi_conc
--and     ic.codi_cntx = id.codi_cntx
--and     ct.codi_pers = ic.codi_pers
--and     ct.corr_inst = ic.corr_inst
--and     ct.vers_inst = ic.vers_inst
--and     ct.codi_cntx = ic.codi_cntx
--and     replace(substring(isnull(ct.ffin_cntx,ct.fini_cntx),1,7),'-','') = ic.corr_inst
--and     ic.valo_cntx != '0'
--and     cc.pref_conc = ic.pref_conc
--and     cc.codi_conc = ic.codi_conc

END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getInfoDimensionDescConc]    Fecha de la secuencia de comandos: 09/23/2013 12:13:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getInfoDimensionDescConc]
	@p_CodiInfo varchar(256),
	@p_dimension varchar(256),
	@p_tipo_taxo varchar (30)
as
BEGIN
-- obtenciòn de los conceptos  de la dimension
--if(@p_tipo_taxo = 'SEGUROS')
--	begin
--		select distinct  cc.desc_conc
--				,dc.orde_conc
--				, cc.codi_conc
--				,cc.pref_conc
--		from    dbax_dime_diax dd,
--				dbax_dime_conc dc,
--				dbax_desc_conc cc,
--				dbax_desc_conc cc1
--		where	dd.codi_dein like '%cuadro%'
--		and		dd.codi_dein = @p_CodiInfo
--		and		dc.codi_dime = @p_dimension
--		and     dc.codi_dein = dd.codi_dein
--		and     dc.codi_dime = dd.codi_dime
--		and     cc.pref_conc = dc.pref_conc
--		and     cc.codi_conc = dc.codi_conc
--		and     cc1.pref_conc = dc.pref_dime
--		and     cc1.codi_conc = dc.codi_dime
--		order by dc.orde_conc
--	end
--else if (@p_tipo_taxo = 'COME_INDU')
--	begin
		select distinct  
				cc.desc_conc
				,cc.codi_conc
				,cc.pref_conc
				,dc.orde_conc
				,dc.sald_ini
		from    dbax_dime_diax dd,
				dbax_dime_conc dc,
				dbax_desc_conc cc,
				dbax_desc_conc cc1
		where	dd.codi_dein = @p_CodiInfo
		and		dc.codi_dime = @p_dimension
		and     dc.codi_dein = dd.codi_dein
		and     dc.codi_dime = dd.codi_dime
		and     cc.pref_conc = dc.pref_conc
		and     cc.codi_conc = dc.codi_conc
		and     cc1.pref_conc = dc.pref_dime
		and     cc1.codi_conc = dc.codi_dime
		order by dc.orde_conc
	--end
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getMiembrosDimension ]    Fecha de la secuencia de comandos: 09/23/2013 12:13:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getMiembrosDimension ]
	@p_codi_pers varchar(30),
	@p_corr_inst varchar(10),
	@p_vers_inst varchar(2),
	@p_codi_info varchar(256),
	@p_dimension varchar(256),
	@p_tipo_taxo varchar(10),
	@p_codi_conc varchar(256), 
	@p_pref_conc varchar(30)
as
BEGIN
	declare @v_ejeMin varchar(256)
	declare @v_datos numeric(10,0)
	
	-- obtenciòn de eje por dimension
	declare @v_eje varchar(256)
	set @v_eje =(select max(dd.codi_axis)
				 from	dbax_dime_diax dd
				 where  dd.codi_dein = @p_codi_info
				 and    dd.codi_dime = @p_dimension)

	-- Obtenciòn de tipo de periodo
	declare @v_tipo_peri varchar(30)
	select @v_tipo_peri = tipo_peri
	from   dbax_defi_conc
	where  pref_conc = @p_pref_conc
	and    codi_conc = @p_codi_conc

	-- Obtenciòn de tipo de miembro
	declare @v_tipo_memb varchar(30)
	select @v_tipo_memb = max(tipo_memb)
	from   dbax_dime_diax dd, dbax_dime_memb dm
	where  dd.codi_dein = @p_codi_info
	and	   dd.codi_dime = @p_dimension
	and	   dd.codi_axis = @v_eje
	and	   dm.pref_axis = dd.pref_dime
	and	   dm.codi_axis = dd.codi_axis

--	select @v_eje, @v_tipo_peri, @v_tipo_memb

	select  -- dd.pref_dime as pref_memb
			--,dm.tipo_memb as tipo_memb
			--,
			 dd.codi_axis as codi_axis
			,dm.pref_memb as pref_memb
			,dm.orde_memb as orde_memb
			,''			  as codi_cntx
			,dm.codi_memb as codi_memb
			, case dx.desc_memb	when '' then cast(replace(max(desc_conc),'[miembro]','') as varchar(256)) collate Latin1_General_CS_AS else dx.desc_memb end desc_conc
			,isnull(id.ffin_cntx,id.fini_cntx) as fini_cntx
	from	 dbax_dime_diax dd
			,dbax_dime_memb dm
			,dbax_inst_dicx dx
			,dbax_inst_cntx id
			,dbax_desc_conc dc
	where	dd.codi_dein = @p_codi_info
	and		dd.codi_dime = @p_dimension
	and		dd.codi_axis = @v_eje
	and		dm.pref_axis = dd.pref_dime
	and		dm.codi_axis = dd.codi_axis
	and		id.codi_pers = @p_codi_pers
	and		id.corr_inst = @p_corr_inst
	and		id.vers_inst = @p_vers_inst
	and     id.corr_inst = replace(substring(isnull(id.ffin_cntx,id.fini_cntx),1,7),'-','')
	and	    dx.codi_pers = id.codi_pers
	and     dx.corr_inst = id.corr_inst
	and     dx.vers_inst = id.vers_inst
	and     dx.codi_cntx = id.codi_cntx
	and     dx.codi_axis = dd.pref_dime + ':' + dd.codi_axis
	and     ((dm.tipo_memb = 'dimension-default' and dm.tipo_memb = @v_tipo_memb) or 
             (dm.tipo_memb = 'domain-member'	 and dm.tipo_memb = @v_tipo_memb and dx.codi_memb = dm.pref_memb + ':' + dm.codi_memb))
/*	and     exists (select  1
					from	dbax_dime_conc dc,
							dbax_inst_conc dx
					where   dc.codi_dein = dd.codi_dein
					and		dc.pref_dime = dd.pref_dime
					and		dc.codi_dime = dd.codi_dime
					and		dx.codi_pers = id.codi_pers
					and     dx.corr_inst = id.corr_inst
					and     dx.vers_inst = id.vers_inst
					and     dx.codi_cntx = id.codi_cntx
					and     dx.pref_conc = dc.pref_conc
					and     dx.codi_conc = dc.codi_conc)	*/
	and	   dc.pref_conc = dm.pref_memb 
	and    dc.codi_conc = dm.codi_memb
	group by dm.orde_memb, dd.codi_axis, dd.pref_dime, dm.tipo_memb, dm.pref_memb, dm.codi_memb, dx.desc_memb, isnull(id.ffin_cntx,id.fini_cntx), dc.desc_conc,dx.desc_memb
	order by dm.orde_memb
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_read_dbax_conceptos]    Fecha de la secuencia de comandos: 09/23/2013 12:12:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas
-- alter date: 20-05-2013
-- Description:	Procedimiento almacenado para la obtencion de los conceptos de un informe de cuadros con una dimensión o eje
-- =============================================
ALTER PROCEDURE [dbo].[prc_read_dbax_conceptos]
(
	@p_codi_dein varchar(128),
	@p_codi_dime varchar(64)
)
AS
BEGIN
	select distinct  cc.desc_conc, cc.codi_conc, dc.orde_conc
	from    dbax_dime_diax dd,
			dbax_dime_conc dc,
			dbax_desc_conc cc,
			dbax_desc_conc cc1
	where	dd.codi_dein like '%'+@p_codi_dein+'%'
	and		dc.codi_dime like '%'+@p_codi_dime+'%'
	and     dc.codi_dein = dd.codi_dein
	and     dc.codi_dime = dd.codi_dime
	and     cc.pref_conc = dc.pref_conc
	and     cc.codi_conc = dc.codi_conc
	and     cc1.pref_conc = dc.pref_dime
	and     cc1.codi_conc = dc.codi_dime
	order by dc.orde_conc
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getCounDimeEjes]    Fecha de la secuencia de comandos: 09/23/2013 12:13:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter procedure [dbo].[SP_AX_getCounDimeEjes]
	@p_CodiInfo varchar(256),
	@p_CodiDime varchar(256)
as
BEGIN
	select  count(codi_axis)
	from	dbax_dime_diax
    where	codi_dein = @p_CodiInfo
    and		codi_dime = @p_CodiDime
    group by codi_dein,codi_dime

END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_read_dbax_ejes]    Fecha de la secuencia de comandos: 09/23/2013 12:12:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[prc_read_dbax_ejes] 
	@P_CODI_DEIN VARCHAR(128),
	@P_CODI_DIME VARCHAR(128)
AS
BEGIN
	select  dd.codi_dime,pref_axis,codi_axis,orde_axis
	from	dbax_dime_diax dd
	where	dd.codi_dein = @P_CODI_DEIN
	and     dd.codi_dime = @P_CODI_DIME
	order by dd.orde_axis
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getEmpresaConFiltro]    Fecha de la secuencia de comandos: 09/23/2013 12:13:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getEmpresaConFiltro](
@pCodiEmex varchar(30),
@pCodiEmpr numeric (9,0),
@pDescripcion varchar(100),
@pGrupo varchar(100),
@pTipoDesc varchar(100) = 'P'
)
as
BEGIN
	/*	
		@pTipoDesc = 'D' se devuelve descripcion "por defecto", 
		@pTipoDesc = 'P' devuelve descripcion por defecto y personalizada
		@pTipoDesc  = 'EM' SE DEVUELVE SOLO LAS DE MAS DE UNA VERSIÓN
	*/
	if(@pTipoDesc = 'P') -- TODAS LAS EMPRESAS PARA COMBOBOX
		begin
         if ( @pGrupo = '')
            begin
				select distinct dp.codi_pers as codi_pers,
								'[' + convert(varchar,dp.codi_pers) + '] ' + isnull(dp.desc_pers,'') as desc_pers,
								dh.desc_empr as desc_peho,
								dg.desc_grup as desc_grup,
								dp.codi_grup as codi_grup,
								ds.desc_segm as desc_segm,
								dp.codi_segm as codi_segm
				from	dbax_defi_pers dp 
					left join dbax_defi_peho dh 
					on	dh.codi_emex = @pCodiEmex 
					and	dh.codi_empr = @pCodiEmpr 
					and	dp.codi_pers = dh.codi_pers
						left join dbax_defi_grup dg
						on	dg.codi_grup = dp.codi_grup
							left join dbax_defi_segm ds
							on	ds.codi_segm = dp.codi_segm
				where	(dp.codi_pers like '%' + @pDescripcion + '%' 
						or dh.desc_empr like '%' + @pDescripcion + '%' 
						or dp.desc_pers like '%' + @pDescripcion + '%')
		    end
          else
            begin
				select distinct dp.codi_pers as codi_pers,
								'[' + convert(varchar,dp.codi_pers) + '] ' + isnull(dp.desc_pers,'') as desc_pers,
								dh.desc_empr as desc_peho,
								dg.desc_grup as desc_grup,
								dp.codi_grup as codi_grup,
								ds.desc_segm as desc_segm,
								dp.codi_segm as codi_segm
				from	dbax_defi_pers dp 
					left join dbax_defi_peho dh 
					on	dh.codi_emex = @pCodiEmex 
					and	dh.codi_empr = @pCodiEmpr 
					and	dp.codi_pers = dh.codi_pers
						left join dbax_defi_grup dg
						on	dg.codi_grup = dp.codi_grup
							left join dbax_defi_segm ds
							on	ds.codi_segm = dp.codi_segm
				where	(dp.codi_pers like '%' + @pDescripcion + '%' 
						or dh.desc_empr like '%' + @pDescripcion + '%' 
						or dp.desc_pers like '%' + @pDescripcion + '%')
				and		dp.codi_grup = dg.codi_grup
				and		dp.codi_grup = @pGrupo
            end
		end
	else

	if(@pTipoDesc = 'EM') --TODAS LAS EMPRESAS PARA GRILLA
		begin
		if ( @pGrupo = '')
            begin
				select distinct dp.codi_pers as codi_pers,
							'[' + convert(varchar,dp.codi_pers) + '] ' + dp.desc_pers as desc_pers,
							dh.desc_empr as desc_peho 
				from dbax_defi_pers dp 
				left join dbax_defi_peho dh 
					on dh.codi_emex = @pCodiEmex 
					and dh.codi_empr = @pCodiEmpr 
					and dp.codi_pers = dh.codi_pers 
				where dp.codi_pers like '%' + @pDescripcion + '%'
				union
				select distinct dp.codi_pers as codi_pers, '[' + convert(varchar,dp.codi_pers) + '] ' + dp.desc_pers as desc_pers,
								dh.desc_empr as desc_peho 
				from dbax_defi_pers dp left join dbax_defi_peho dh on dh.codi_emex = @pCodiEmex 
				and dh.codi_empr = @pCodiEmpr 
				and dp.codi_pers = dh.codi_pers 
				where dp.desc_pers like '%' + @pDescripcion + '%' or dh.desc_empr like '%' + @pDescripcion + '%'
			end
        else
            begin
				select distinct dp.codi_pers as codi_pers,
								'[' + convert(varchar,dp.codi_pers) + '] ' + dp.desc_pers as desc_pers,
								dh.desc_empr as desc_peho 
				from	dbax_defi_pers dp 
					left join dbax_defi_peho dh 
					on	dh.codi_emex = @pCodiEmex 
					and	dh.codi_empr = @pCodiEmpr 
					and	dp.codi_pers = dh.codi_pers 
				where	dp.codi_pers like '%' + @pDescripcion + '%'
				and		dp.codi_pers in (select codi_pers from dbax_grup_pers where codi_grup = @pGrupo )
				union
				select distinct dp.codi_pers as codi_pers, '[' + convert(varchar,dp.codi_pers) + '] ' + dp.desc_pers as desc_pers,
								dh.desc_empr as desc_peho 
				from	dbax_defi_pers dp 
					left join dbax_defi_peho dh 
					on	dh.codi_emex = @pCodiEmex 
					and	dh.codi_empr = @pCodiEmpr 
					and	dp.codi_pers = dh.codi_pers 
				where dp.codi_pers in (select codi_pers from dbax_grup_pers where codi_grup = @pGrupo )
				and dp.desc_pers like '%' + @pDescripcion + '%' or dh.desc_empr like '%' + @pDescripcion + '%'			
            end
		end
    else
		begin  --TODAS LAS EMPRESAS CON MAS  DE UNA VERSIÓN
          if ( @pGrupo = '')
            begin
				select distinct dp.codi_pers as codi_pers,
				'[' + convert(varchar,dp.codi_pers) + '] ' + dp.desc_pers as desc_pers,
				dh.desc_empr as desc_peho 
				from dbax_defi_pers dp 
					left join dbax_defi_peho dh 
					on	dh.codi_emex = @pCodiEmex 
					and dh.codi_empr = @pCodiEmpr 
					and dp.codi_pers = dh.codi_pers 
				where dp.codi_pers like '%' + @pDescripcion + '%'
				and dp.codi_pers in (select distinct a.codi_pers from dbax_inst_info a where  a.vers_inst > '1')
				union
				select distinct dp.codi_pers as codi_pers, '[' + convert(varchar,dp.codi_pers) + '] ' + dp.desc_pers as desc_pers,
				dh.desc_empr as desc_peho 
				from	dbax_defi_pers dp 
					left join dbax_defi_peho dh 
					on	dh.codi_emex = @pCodiEmex 
					and	dh.codi_empr = @pCodiEmpr 
					and	dp.codi_pers = dh.codi_pers 
				where	dp.codi_pers in (select distinct a.codi_pers from dbax_inst_info a where  a.vers_inst > '1') 
				and		dp.desc_pers like '%' + @pDescripcion + '%' or dh.desc_empr like '%' + @pDescripcion + '%'
            end
          else
            begin
				select distinct dp.codi_pers as codi_pers,
				'[' + convert(varchar,dp.codi_pers) + '] ' + dp.desc_pers as desc_pers,
				dh.desc_empr as desc_peho 
				from dbax_defi_pers dp 
					left join dbax_defi_peho dh 
					on	dh.codi_emex = @pCodiEmex 
					and dh.codi_empr = @pCodiEmpr 
					and dp.codi_pers = dh.codi_pers 
				where	dp.codi_pers like '%' + @pDescripcion + '%'
				and		dp.codi_pers in (select distinct a.codi_pers from dbax_inst_info a where  a.vers_inst > '1')
				and		dp.codi_pers in (select codi_pers from dbax_grup_pers where codi_grup = @pGrupo )
				union
				select distinct dp.codi_pers as codi_pers, '[' + convert(varchar,dp.codi_pers) + '] ' + dp.desc_pers as desc_pers,
								dh.desc_empr as desc_peho 
				from	dbax_defi_pers dp left join dbax_defi_peho dh on dh.codi_emex = @pCodiEmex 
				and		dh.codi_empr = @pCodiEmpr 
				and		dp.codi_pers = dh.codi_pers 
				where	dp.codi_pers in (select codi_pers from dbax_grup_pers where codi_grup = @pGrupo )
				and		dp.codi_pers in (select distinct a.codi_pers from dbax_inst_info a where  a.vers_inst > '1') 
				and		dp.desc_pers like '%' + @pDescripcion + '%' or dh.desc_empr like '%' + @pDescripcion + '%'
            end 
		end
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getEmpresaPorGrupoSegmento]    Fecha de la secuencia de comandos: 09/23/2013 12:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getEmpresaPorGrupoSegmento](
	@pCodiEmex varchar(30),
	@pCodiEmpr numeric (9,0),
	@pCorrInst varchar(10),
	@pDescripcion varchar(100),
	@pGrupo varchar(50),
	@pSegmento varchar(50),
	@pTipo varchar(10),
	@pTipoDesc varchar(100) = 'P'
	)
as
BEGIN
	/*	
		@pTipoDesc = 'P' devuelve descripcion por defecto y personalizada
		@pTipoDesc  = 'C' SE DEVUELVE SOLO LAS DE MAS DE UNA VERSIÓN
	*/

	set @pDescripcion = upper(@pDescripcion)

	declare @vComodinGrup varchar(1)
	declare @vComodinSegm varchar(1)
	declare @vComodinTipo varchar(1)
	declare @vComodinCorr varchar(1)

	set @vComodinGrup = '%'
	set @vComodinSegm = '%'
	set @vComodinTipo = '%'
	set @vComodinCorr = '%'

	if ( @pGrupo != '')
	begin
		set @vComodinGrup = ''
	end

	if ( @pSegmento != '')
	begin
		set @vComodinSegm = ''
	end

	if ( @pTipo != '')
	begin
		set @vComodinTipo = ''
	end

	if (@pCorrInst != '')
	begin
		set @vComodinCorr = ''
	end

	if(@pTipoDesc = 'P') -- TODAS LAS EMPRESAS
	begin
		if(@pCorrInst = '')
		BEGIN
			select	v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, desc_tipo
			from	(select distinct dp.codi_pers as codi_pers,
									dp.desc_pers as desc_pers,
									isnull(dh.desc_empr,dp.desc_pers) as desc_peho,
									dg.desc_grup as desc_grup,
									dp.codi_grup as codi_grup,
									dp.codi_segm as codi_segm,
									dp.tipo_taxo as tipo_taxo
					from	dbax_defi_pers dp 
								left join dbax_defi_peho dh 
								on	dh.codi_emex = @pCodiEmex 
								and	dh.codi_empr = @pCodiEmpr 
								and	dp.codi_pers = dh.codi_pers
									left join dbax_defi_grup dg
									on	dg.codi_grup = dp.codi_grup,
							dbax_inst_docu id
					where	(dp.codi_pers like '%' + @pDescripcion + '%' 
							or upper(dh.desc_empr) like '%' + @pDescripcion + '%' 
							or upper(dp.desc_pers) like '%' + @pDescripcion + '%')
					and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
					and		dp.codi_pers = id.codi_pers
					and		dp.empr_vige = 'SI') v
			left join dbax_defi_segm ds
				on v.codi_segm = ds.codi_segm
			left join dbax_tipo_taxo tt
				on v.tipo_taxo = tt.tipo_taxo
			where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
			and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo
			order by v.desc_pers asc
		END
		ELSE
		BEGIN
			select	v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, desc_tipo, v.vers_inst, @pCorrInst corr_inst
			from	(select distinct dp.codi_pers as codi_pers,
									dp.desc_pers as desc_pers,
									isnull(dh.desc_empr,dp.desc_pers) as desc_peho,
									dg.desc_grup as desc_grup,
									dp.codi_grup as codi_grup,
									dp.codi_segm as codi_segm,
									dp.tipo_taxo as tipo_taxo,
									(select max(vi.vers_inst) from dbax_inst_vers vi where vi.corr_inst = isnull(@pCorrInst,0) and vi.codi_pers = dp.codi_pers) as vers_inst
					from	dbax_defi_pers dp 
								left join dbax_defi_peho dh 
								on	dh.codi_emex = @pCodiEmex 
								and	dh.codi_empr = @pCodiEmpr 
								and	dp.codi_pers = dh.codi_pers
									left join dbax_defi_grup dg
									on	dg.codi_grup = dp.codi_grup,
							dbax_inst_docu id
					where	(dp.codi_pers like '%' + @pDescripcion + '%' 
							or upper(dh.desc_empr) like '%' + @pDescripcion + '%' 
							or upper(dp.desc_pers) like '%' + @pDescripcion + '%')
					and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
					and		dp.codi_pers = id.codi_pers
					and		dp.empr_vige = 'SI') v
			left join dbax_defi_segm ds
				on v.codi_segm = ds.codi_segm
			left join dbax_tipo_taxo tt
				on v.tipo_taxo = tt.tipo_taxo
			where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
			and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo
			order by v.desc_pers asc
		END
	end

	if(@pTipoDesc = 'C') -- SE DEVUELVE SOLO LAS DE MAS DE UNA VERSIÓN (para grilla de diferencias)
	begin
		select	distinct v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, desc_tipo, vt.vers_inst
		from	(select distinct dp.codi_pers as codi_pers,
								dp.desc_pers as desc_pers,
								isnull(dh.desc_empr,dp.desc_pers) as desc_peho,
								dg.desc_grup as desc_grup,
								dp.codi_grup as codi_grup,
								dp.codi_segm as codi_segm,
								dp.tipo_taxo as tipo_taxo
				from	dbax_defi_pers dp 
							left join dbax_defi_peho dh 
							on	dh.codi_emex = @pCodiEmex 
							and	dh.codi_empr = @pCodiEmpr 
							and	dp.codi_pers = dh.codi_pers
								left join dbax_defi_grup dg
								on	dg.codi_grup = dp.codi_grup,
						dbax_inst_docu id
				where	(dp.codi_pers like '%' + @pDescripcion + '%' 
						or upper(dh.desc_empr) like '%' + @pDescripcion + '%' 
						or upper(dp.desc_pers) like '%' + @pDescripcion + '%')
				and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
				and		dp.codi_pers = id.codi_pers
				and		id.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
				and		dp.empr_vige = 'SI') v
		left join dbax_defi_segm ds
			on v.codi_segm = ds.codi_segm
		left join dbax_tipo_taxo tt
			on v.tipo_taxo = tt.tipo_taxo,
		dbax_inst_vers vt
		where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
		and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo
		and	vt.codi_pers = v.codi_pers
		and	vt.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
		and	vt.vers_inst > 1
		order by v.desc_pers asc
	end

	if(@pTipoDesc = 'E') -- TODAS LAS EMPRESAS CON PERIODO CREADO CORR_INST
	begin
		select	v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, desc_tipo
		from	(select distinct dp.codi_pers as codi_pers,
								dp.desc_pers as desc_pers,
								isnull(dh.desc_empr,dp.desc_pers) as desc_peho,
								dg.desc_grup as desc_grup,
								dp.codi_grup as codi_grup,
								dp.codi_segm as codi_segm,
								dp.tipo_taxo as tipo_taxo
				from	dbax_defi_pers dp 
							left join dbax_defi_peho dh 
							on	dh.codi_emex = @pCodiEmex 
							and	dh.codi_empr = @pCodiEmpr 
							and	dp.codi_pers = dh.codi_pers
								left join dbax_defi_grup dg
								on	dg.codi_grup = dp.codi_grup,
						dbax_inst_docu id
				where	(dp.codi_pers like '%' + @pDescripcion + '%' 
						or upper(dh.desc_empr) like '%' + @pDescripcion + '%' 
						or upper(dp.desc_pers) like '%' + @pDescripcion + '%')
				and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
				and		dp.codi_pers = id.codi_pers
				and		id.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
				and		dp.empr_vige = 'SI') v
		left join dbax_defi_segm ds
			on v.codi_segm = ds.codi_segm
		left join dbax_tipo_taxo tt
			on v.tipo_taxo = tt.tipo_taxo
		where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
		and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo
		order by v.desc_pers asc
	end
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getGrupos]    Fecha de la secuencia de comandos: 09/23/2013 12:13:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getGrupos] 
as
BEGIN
	select '' as codi_grup, '' as desc_grup, '1'
	union
	select codi_grup, desc_grup, 'n' from dbax_defi_grup order by 3, 2
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_update_dbax_defi_grup]    Fecha de la secuencia de comandos: 09/23/2013 12:12:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 18-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_update_dbax_defi_grup]
            @P_CODI_GRUP varchar(50), 
            @P_DESC_GRUP varchar(100) 
 AS
 BEGIN
        UPDATE dbax_defi_grup
             SET desc_grup = @P_DESC_GRUP 
             WHERE codi_grup = @P_CODI_GRUP 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_read_grupos_ax]    Fecha de la secuencia de comandos: 09/23/2013 12:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 27-03-2013
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[prc_read_grupos_ax] 
(
	 @tsTipo as Varchar(2),
	 @tnPagina as integer,
	 @tnRegPag as integer,
	 @tsCondicion as Varchar(2048),
	 @tsPar1 as Varchar(30), @tsPar2 as Varchar(30),
	 @tsPar3 as Varchar(30), @tsPar4 as Varchar(30), @tsPar5 as Varchar(30),
	 @p_codi_usua varchar(30), @p_codi_empr int, @p_codi_emex varchar(30)
 )
AS
BEGIN
	select '' as codi_grup, '' as desc_grup, '1'
	union
	select codi_grup, desc_grup, 'n' from dbax_defi_grup order by 3, 2
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_alter_dbax_defi_grup]    Fecha de la secuencia de comandos: 09/23/2013 12:11:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 18-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_alter_dbax_defi_grup]
            @P_CODI_GRUP varchar(50), 
            @P_DESC_GRUP varchar(100) 
 AS
 BEGIN
        INSERT INTO dbax_defi_grup(
            codi_grup, 
            desc_grup
        )
        VALUES
        (
             @P_CODI_GRUP, 
             @P_DESC_GRUP
        );
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_read_dbax_defi_grup]    Fecha de la secuencia de comandos: 09/23/2013 12:12:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 18-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_read_dbax_defi_grup]
(
@tsTipo as Varchar(2),
 @tnPagina as integer,
 @tnRegPag as integer,
 @tsCondicion as Varchar(2048),
 @tsPar1 as Varchar(30), @tsPar2 as Varchar(30),
 @tsPar3 as Varchar(30), @tsPar4 as Varchar(30), @tsPar5 as Varchar(30),
 @p_codi_usua varchar(30), @p_codi_empr int, @p_codi_emex varchar(30))
AS 
    /*
     Procedimiento para rescatar datos de la tabla DBAX_DEFI_GRUP
     CON EL 
     Parametros
        @tsTipo 
            S: Query utilizada para el mantenedor 
            L: Query utilizada para el listador 
            LV: Query utilizada para las listas de valor 
        @tnPagina	: Numero de pagina a rescatar 
        @tnRegPag	: Numero de registros por pagina
        @tsCondicion : Condicion, clausula Where
        @tsPar1		: Parametro 1 - codi_grup
        @tsPar2		: Parametro 2 - 
        @tsPar3		: Parametro 3 - 
        @tsPar4		: Parametro 4 - 
        @tsPar5		: Parametro 5 - 
        @p_codi_usua    : Usuario
        @p_codi_empr    : Empresa
        @p_codi_emex    : Emex
     */
     declare @sql_dyn as integer
     declare @sql as nvarchar(4000)
BEGIN
  IF (@tsTipo = 'S')
  BEGIN
    SELECT codi_grup, 
           desc_grup
  FROM dbax_defi_grup
  WHERE codi_grup = @tsPar1
 END
 ELSE IF (@tsTipo = 'L')
 BEGIN
   SET @sql = 'SELECT ROW_NUMBER() OVER(ORDER BY codi_grup ASC) AS REG, 
                codi_grup, 
                desc_grup
               FROM dbax_defi_grup
               WHERE 1 = 1 '
 
   SET @sql = @sql + isnull(@tsCondicion,'')
   EXECUTE dbo.prc_list_dyn @sql, @tnPagina, @tnRegPag 
 END
 ELSE IF(@tsTipo = 'LV')
 BEGIN
	select '' as CODIGO, 'Seleccione' as VALOR, '1'
	union
	select codi_grup, desc_grup, 'n' from dbax_defi_grup order by 3, 2;
 END
END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_read_dbax_defi_segm]    Fecha de la secuencia de comandos: 09/23/2013 12:12:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 18-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_read_dbax_defi_segm] (
 @tsTipo as Varchar(2),
 @tnPagina as integer,
 @tnRegPag as integer,
 @tsCondicion as Varchar(2048),
 @tsPar1 as Varchar(30), @tsPar2 as Varchar(30),
 @tsPar3 as Varchar(30), @tsPar4 as Varchar(30), @tsPar5 as Varchar(30),
 @p_codi_usua varchar(30), @p_codi_empr int, @p_codi_emex varchar(30))
AS 
    /*
     Procedimiento para rescatar datos de la tabla DBAX_DEFI_SEGM
     CON EL 
     Parametros
        @tsTipo 
            S: Query utilizada para el mantenedor 
            L: Query utilizada para el listador 
            LV: Query utilizada para las listas de valor 
        @tnPagina	: Numero de pagina a rescatar 
        @tnRegPag	: Numero de registros por pagina
        @tsCondicion : Condicion, clausula Where
        @tsPar1		: Parametro 1 - codi_segm
        @tsPar2		: Parametro 2 - 
        @tsPar3		: Parametro 3 - 
        @tsPar4		: Parametro 4 - 
        @tsPar5		: Parametro 5 - 
        @p_codi_usua    : Usuario
        @p_codi_empr    : Empresa
        @p_codi_emex    : Emex
     */
     declare @sql_dyn as integer
     declare @sql as nvarchar(4000)
BEGIN
  IF (@tsTipo = 'S')
  BEGIN
    SELECT codi_segm, 
           desc_segm
  FROM dbax_defi_segm
  WHERE codi_segm = @tsPar1
 END
 ELSE IF (@tsTipo = 'L')
 BEGIN
   SET @sql = 'SELECT ROW_NUMBER() OVER(ORDER BY dbds.codi_segm ASC) AS REG, 
                dbds.codi_segm, 
                dbds.desc_segm
               FROM dbax_defi_segm dbds
               WHERE 1 = 1 '
 
   SET @sql = @sql + isnull(@tsCondicion,'')
   EXECUTE dbo.prc_list_dyn @sql, @tnPagina, @tnRegPag 
 END
 ELSE IF(@tsTipo = 'LV')
 BEGIN
	select '' as CODIGO, 'Seleccione' as VALOR
	union
	select codi_segm, desc_segm from dbax_defi_segm 
	order by 1, 2;
 END
END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_delete_dbax_defi_segm]    Fecha de la secuencia de comandos: 09/23/2013 12:11:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 18-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_delete_dbax_defi_segm]
            @P_CODI_SEGM varchar(50) 
 AS
 BEGIN
        DELETE dbax_defi_segm
        WHERE codi_segm = @P_CODI_SEGM 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_alter_dbax_defi_segm]    Fecha de la secuencia de comandos: 09/23/2013 12:11:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 18-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_alter_dbax_defi_segm]
            @P_CODI_SEGM varchar(50), 
            @P_DESC_SEGM varchar(100) 
 AS
 BEGIN
        INSERT INTO dbax_defi_segm(
            codi_segm, 
            desc_segm
        )
        VALUES
        (
             @P_CODI_SEGM, 
             @P_DESC_SEGM
        );
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_update_dbax_defi_segm]    Fecha de la secuencia de comandos: 09/23/2013 12:12:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 18-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_update_dbax_defi_segm]
            @P_CODI_SEGM varchar(50), 
            @P_DESC_SEGM varchar(100) 
 AS
 BEGIN
        UPDATE dbax_defi_segm
             SET desc_segm = @P_DESC_SEGM 
             WHERE codi_segm = @P_CODI_SEGM 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getSegmentos]    Fecha de la secuencia de comandos: 09/23/2013 12:13:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getSegmentos] 
as
BEGIN
	select '' as codi_segm, '' as desc_segm, '1'
	union
	select codi_segm, desc_segm, 'n' from dbax_defi_segm order by 3, 2
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getMiembrosDimensionEmpresaPeriodoVersion]    Fecha de la secuencia de comandos: 09/23/2013 12:13:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getMiembrosDimensionEmpresaPeriodoVersion]
	@pCodiPers	 varchar(16),
	@pCorrInst	 numeric(10,0),
	@pVersInst	 numeric(5,0),
	@p_codi_info varchar(256),
	@p_pref_axis varchar(50),
	@p_codi_axis varchar(256)
as
BEGIN
	select distinct dm.pref_memb + ':' + dm.codi_memb COLLATE Modern_Spanish_CS_AS codi_memb, dc.desc_conc COLLATE Modern_Spanish_CS_AS desc_memb, dm.tipo_memb, dm.orde_memb
	from	dbax_dime_memb dm,
			dbax_desc_conc dc
	where	dm.pref_axis = @p_pref_axis
	and		dm.codi_axis = @p_codi_axis
	and		dm.pref_memb = dc.pref_conc
	and		dm.codi_memb = dc.codi_conc
	and		dc.codi_lang = 'es_ES'
	union
	select	im.codi_memb, im.desc_memb, 'domain-member', id.orde_memb
	from	dbax_inst_memb im,
			dbax_inst_dime id
	where	1=1
	and		im.codi_pers = @pCodiPers
	and		im.corr_inst = @pCorrInst
	and		im.vers_inst = @pVersInst
	and		id.codi_pers = im.codi_pers
	and		id.corr_inst = im.corr_inst
	and		id.vers_inst = im.vers_inst
	and		id.codi_dein like '%' + @p_codi_info + '%'
	and		id.pref_axis = @p_pref_axis
	and		id.codi_axis = @p_codi_axis
	and		id.codi_memb = im.codi_memb
	group by im.codi_memb, im.desc_memb, id.orde_memb
	order by 4,1
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_GetEncaIndi]    Fecha de la secuencia de comandos: 09/23/2013 12:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_GetEncaIndi](
	@p_CodiEmex varchar(30),
	@p_CodiEmpr numeric(9,0),
	@p_CodiIndi varchar(100)) as
BEGIN
	select	fe.tipo_conc, fe.desc_indi, fe.form_indi, fe.tipo_taxo, tt.desc_tipo
	from	dbax_form_enca fe,
			dbax_tipo_taxo tt
	where	fe.codi_emex = @p_CodiEmex
	and		fe.codi_empr = @p_CodiEmpr
	and		fe.codi_indi = @p_CodiIndi
	and		fe.tipo_taxo = tt.tipo_taxo

END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_InsEncaIndi]    Fecha de la secuencia de comandos: 09/23/2013 12:13:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_InsEncaIndi](
	@p_codi_modo  varchar(2),
	@p_codi_emex  varchar(30),
	@p_codi_empr  numeric(9,0),
	@p_codi_indi  varchar(100),
	@p_tipo_indi  varchar(20),
	@p_desc_indi  varchar(256),
	@p_form_indi  varchar(100),
	@p_tipo_taxo varchar(30)) as
BEGIN
	if(@p_codi_modo = 'CI')
	begin
		insert into dbax_form_enca (codi_emex, codi_empr, codi_indi, tipo_conc, desc_indi, form_indi,tipo_taxo)
		values					   (@p_codi_emex, @p_codi_empr, @p_codi_indi, @p_tipo_indi, @p_desc_indi, @p_form_indi,@p_tipo_taxo)
	end
	else
	begin
		/*select	@p_tipo_indi as tipo_indi, 
				@p_desc_indi as desc_indi, 
				@p_form_indi as form_indi, 
				@p_codi_emex as codi_emex, 
				@p_codi_empr as codi_empr, 
				@p_codi_indi as codi_indi*/

		update	dbax_form_enca 
		set		tipo_conc = @p_tipo_indi, 
				desc_indi = @p_desc_indi, 
				form_indi = @p_form_indi 
		where	codi_emex = @p_codi_emex
		and		codi_empr = @p_codi_empr
		and		codi_indi = @p_codi_indi
	end
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_GetListaIndicadoresEmpresa]    Fecha de la secuencia de comandos: 09/23/2013 12:13:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_GetListaIndicadoresEmpresa](
	@p_CodiEmex varchar(30),
	@p_CodiEmpr numeric(9,0),
    @p_Codi_indi varchar(100),
    @p_TipoTaxo varchar(30)) as
BEGIN
if(  @p_Codi_indi = '')
	begin
		select	codi_indi as Nombre, 
				tipo_conc as Tipo, 
				desc_indi as Descripción, 
				form_indi as Fórmula
		from	dbax_form_enca
		where	codi_emex = @p_CodiEmex
		and		codi_empr = @p_CodiEmpr
		and     tipo_taxo like '%'+isnull(@p_TipoTaxo,'')+'%'
		and     (tipo_conc like 'indLi%' or tipo_conc like 'indEnd%')
	end
else
	begin
		select	codi_indi as Nombre, 
				tipo_conc as Tipo, 
				desc_indi as Descripción, 
				form_indi as Fórmula
		from	dbax_form_enca
		where	codi_emex = @p_CodiEmex
		and		codi_empr = @p_CodiEmpr
		and     tipo_taxo like '%'+isnull(@p_TipoTaxo,'')+'%'
		and     codi_indi = @p_Codi_indi
	end
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_InseUsuaSys]    Fecha de la secuencia de comandos: 09/23/2013 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Lorena Bezares>
-- alter date: <27-09-2012>
-- Description:	<inserta usuarios con pass encriptada>
-- =============================================
ALTER PROCEDURE [dbo].[SP_AX_InseUsuaSys]  
	(@usua varchar(30), @pass varchar(30))
	
AS
declare @password varchar(34)

set @password = master.dbo.fn_varbintohexstr(HASHBYTES('md5',@pass))
BEGIN
	insert into dbne_usua (codi_usua, pass_usua, fech_usua) values (@usua, @password, getdate())
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_read_dbax_homo_deta]    Fecha de la secuencia de comandos: 09/23/2013 12:12:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 19-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_read_dbax_homo_deta] (
 @tsTipo as Varchar(2),
 @tnPagina as integer,
 @tnRegPag as integer,
 @tsCondicion as Varchar(2048),
 @tspar1 as Varchar(30), @tsPar2 as Varchar(30),
 @tsPar3 as Varchar(30), @tspar4 as Varchar(30), @tsPar5 as Varchar(30),
 @p_codi_usua varchar(30), @p_codi_empr int, @p_codi_emex varchar(30))
AS 
    /*
     Procedimiento para rescatar datos de la tabla DBAX_HOMO_DETA
     CON EL 
     Parametros
        @tsTipo 
            S: Query utilizada para el mantenedor 
            L: Query utilizada para el listador 
            LV: Query utilizada para las listas de valor 
        @tnPagina	: Numero de pagina a rescatar 
        @tnRegPag	: Numero de registros por pagina
        @tsCondicion : Condicion, clausula Where
        @tsPar1		: Parametro 1 - codi_hoco
        @tsPar2		: Parametro 2 - pref_conc
        @tsPar3		: Parametro 3 - codi_conc
        @tsPar4		: Parametro 4 - pref_conc1
        @tsPar5		: Parametro 5 - codi-conc1
        @p_codi_usua    : Usuario
        @p_codi_empr    : Empresa
        @p_codi_emex    : Emex
     */
     declare @sql_dyn as integer
     declare @sql as nvarchar(4000)
BEGIN
  IF (@tsTipo = 'S')
  BEGIN
    SELECT codi_hoco, 
           pref_conc, 
           codi_conc, 
           pref_conc1, 
           codi_conc1
  FROM dbax_homo_deta
  WHERE codi_hoco = @tspar1
  AND   pref_conc = @tsPar2
  AND   codi_conc = @tsPar3
  AND pref_conc1 = @tspar4
  AND codi_conc1 = @tsPar5
 END
 ELSE IF (@tsTipo = 'L')
 BEGIN
   SET @sql = 'SELECT ROW_NUMBER() OVER(ORDER BY hd.codi_hoco ASC) AS REG, 
                hd.codi_hoco, hd.pref_conc, codi_conc, 
                pref_conc1, codi_conc1, hc.vers_taxo, hc.vers_taxo_dest
               FROM dbax_homo_deta hd, dbax_homo_conc hc
               WHERE hd.codi_hoco = '+@tspar1+'
               AND hd.codi_hoco = hc.codi_hoco '
 
   SET @sql = @sql + isnull(@tsCondicion,'')
   EXECUTE dbo.prc_list_dyn @sql, @tnPagina, @tnRegPag 
 END
END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_alter_dbax_homo_deta]    Fecha de la secuencia de comandos: 09/23/2013 12:11:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 19-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_alter_dbax_homo_deta]
            @P_CODI_HOCO numeric(22, 0), 
            @P_PREF_CONC varchar(50), 
            @P_CODI_CONC varchar(256), 
            @P_PREF_CONC1 varchar(50), 
            @P_CODI_CONC1 varchar(256) 
 AS
 BEGIN
        INSERT INTO dbax_homo_deta(
            codi_hoco, 
            pref_conc, 
            codi_conc, 
            pref_conc1, 
            codi_conc1
        )
        VALUES
        (
             @P_CODI_HOCO, 
             @P_PREF_CONC, 
             @P_CODI_CONC, 
             @P_PREF_CONC1, 
             @P_CODI_CONC1
        );
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_delete_dbax_homo_deta]    Fecha de la secuencia de comandos: 09/23/2013 12:11:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 19-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_delete_dbax_homo_deta]
            @P_CODI_HOCO numeric(22, 0), 
            @P_PREF_CONC varchar(50), 
            @P_CODI_CONC varchar(256),  
            @P_PREF_CONC1 varchar(50), 
            @P_CODI_CONC1 varchar(256)
 AS
 BEGIN
        DELETE dbax_homo_deta
        WHERE codi_hoco = @P_CODI_HOCO 
        AND   pref_conc = @P_PREF_CONC 
        AND   codi_conc = @P_CODI_CONC
        AND	  pref_conc1 = @P_PREF_CONC1
        AND   codi_conc1 = @P_CODI_CONC1
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_update_dbax_homo_deta]    Fecha de la secuencia de comandos: 09/23/2013 12:12:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 18-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_update_dbax_homo_deta]
            @P_CODI_HOCO numeric(22, 0), 
            @P_PREF_CONC varchar(50), 
            @P_CODI_CONC varchar(256), 
            @P_PREF_CONC1 varchar(50), 
            @P_CODI_CONC1 varchar(256) 
 AS
 BEGIN
        UPDATE dbax_homo_deta
             SET pref_conc1 = @P_PREF_CONC1, 
                 codi_conc1 = @P_CODI_CONC1
             WHERE codi_hoco = @P_CODI_HOCO 
             AND   pref_conc = @P_PREF_CONC 
             AND   codi_conc = @P_CODI_CONC 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_delete_sys_object]    Fecha de la secuencia de comandos: 09/23/2013 12:11:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_delete_sys_object]
            @P_OBJECT_NAME varchar(30) 
 AS
 BEGIN
        DELETE sys_object
        WHERE object_name = @P_OBJECT_NAME 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_alter_rous_menu_furo]    Fecha de la secuencia de comandos: 09/23/2013 12:11:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 30-01-2013
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_alter_rous_menu_furo](
	@P_NOMB_ROUS VARCHAR(30),
	@P_CODI_MODU VARCHAR(30),
	@P_NOMB_MENU VARCHAR(30))
AS
BEGIN
	insert into sys_furo(codi_rous, form_type,  object_name, object_type, object_brief,  object_desc, object_code, object_single, object_rela, rol0, rol1, rol2, rol3, rol4, rol5, rol6, rol7, rol8, rol9, object_prog, object_priv, object_order, object_state, codi_modu, object_orun, object_level, par0, val0, par1, val1, par2, val2)
	select @P_NOMB_ROUS  ,'A' ,object_name, object_type, object_brief,  object_desc, object_code, object_single, object_rela, rol0, rol1, rol2, rol3, rol4, rol5, rol6, rol7, rol8, rol9, object_prog, object_priv, object_order, object_state, codi_modu, object_orun, object_level, par0, val0, par1, val1, par2, val2 
	from sys_object 
	where object_type!='L' and codi_modu = @P_CODI_MODU and object_name=@P_NOMB_MENU;
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_sys_object_delete]    Fecha de la secuencia de comandos: 09/23/2013 12:12:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_sys_object_delete]
            @P_OBJECT_NAME VARCHAR(30) 
 AS
 BEGIN
        DELETE 	sys_object
        WHERE 	object_name = @P_OBJECT_NAME 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_sys_object_read]    Fecha de la secuencia de comandos: 09/23/2013 12:12:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_sys_object_read] (
 @tsTipo as VARCHAR(4),
 @tnPagina as INTEGER,
 @tnRegPag as INTEGER,
 @tsCondicion as VARCHAR(2048),
 @tsPar1 as VARCHAR(256), @tsPar2 as VARCHAR(256),
 @tsPar3 as VARCHAR(256), @tsPar4 as VARCHAR(256), @tsPar5 as VARCHAR(256),
 @p_codi_usua VARCHAR(30), @p_codi_empr INTEGER, @p_codi_emex VARCHAR(30))
AS 
    /*
     Procedimiento para rescatar datos de la tabla SYS_OBJECT
     CON EL 
     Parametros
        @tsTipo 
            S: Query utilizada para el mantenedor 
            L: Query utilizada para el listador 
            LV: Query utilizada para las listas de valor 
        @tnPagina	: Numero de pagina a rescatar 
        @tnRegPag	: Numero de registros por pagina
        @tsCondicion : Condicion, clausula Where
        @tsPar1		: Parametro 1 - object_name
        @tsPar2		: Parametro 2 - 
        @tsPar3		: Parametro 3 - 
        @tsPar4		: Parametro 4 - 
        @tsPar5		: Parametro 5 - 
        @p_codi_usua    : Usuario
        @p_codi_empr    : Empresa
        @p_codi_emex    : Emex
     */
     declare @sql_dyn as INTEGER
     declare @sql as nVARCHAR(4000)
BEGIN
  IF (@tsTipo = 'S')
  BEGIN
    SELECT object_name, 		object_type, 		object_brief, 		table_name, 
            table_type, 		appname, 			form_type, 			report_name, 
            report_type, 		query_clause,   	order_key, 			object_desc, 
            alter_key, 			object_code, 		object_single, 		object_rela, 
            rol0, 				rol1, 				rol2, 				rol3, 
            rol4, 				rol5, 				rol6, 				rol7, 
            rol8, 				rol9, 				object_prog, 		object_priv, 
            object_order, 		object_sex, 		object_state, 		object_date, 
            object_pname, 		object_shell, 		codi_modu, 			par0, 
            par1, 				par2, 				par3, 				par4, 
            par5, 				par6, 				par7, 				par8, 
            par9, 				val0, 				val1, 				val2, 
            val3, 				val4, 				val5, 				val6, 
            val7, 				val8, 				val9, 				object_orun, 
            object_level, 		object_freq, 		codi_acti, 			object_empr
  FROM sys_object
  WHERE 1 = 1
  AND   object_name = @tsPar1
 END
 ELSE IF (@tsTipo = 'L')
 BEGIN
   SET @sql = 'SELECT ROW_NUMBER() OVER(ORDER BY object_name ASC) AS REG, 
                object_name, 		object_type, 		object_brief, 		table_name, 
				table_type, 		appname, 			form_type, 			report_name, 
				report_type, 		query_clause,   	order_key, 			object_desc, 
				alter_key, 			object_code, 		object_single, 		object_rela, 
				rol0, 				rol1, 				rol2, 				rol3, 
				rol4, 				rol5, 				rol6, 				rol7, 
				rol8, 				rol9, 				object_prog, 		object_priv, 
				object_order, 		object_sex, 		object_state, 		object_date, 
				object_pname, 		object_shell, 		codi_modu, 			par0, 
				par1, 				par2, 				par3, 				par4, 
				par5, 				par6, 				par7, 				par8, 
				par9, 				val0, 				val1, 				val2, 
				val3, 				val4, 				val5, 				val6, 
				val7, 				val8, 				val9, 				object_orun, 
				object_level, 		object_freq, 		codi_acti, 			object_empr 
               FROM sys_object
               WHERE 1 = 1 '

   SET @sql = @sql + isnull(@tsCondicion,'')
   EXECUTE prc_list_dyn @sql, @tnPagina, @tnRegPag 
 END
END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_sys_object_update]    Fecha de la secuencia de comandos: 09/23/2013 12:12:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_sys_object_update]
            @P_OBJECT_NAME VARCHAR(30), 
            @P_OBJECT_TYPE VARCHAR(1), 
            @P_OBJECT_BRIEF VARCHAR(100), 
            @P_TABLE_NAME VARCHAR(30), 
            @P_TABLE_TYPE VARCHAR(1), 
            @P_APPNAME VARCHAR(100), 
            @P_FORM_TYPE VARCHAR(1), 
            @P_REPORT_NAME VARCHAR(30), 
            @P_REPORT_TYPE VARCHAR(1), 
            @P_QUERY_CLAUSE VARCHAR(2000), 
            @P_ORDER_KEY numeric(3, 0), 
            @P_OBJECT_DESC VARCHAR(200), 
            @P_ALTER_KEY numeric(3, 0), 
            @P_OBJECT_CODE VARCHAR(30), 
            @P_OBJECT_SINGLE VARCHAR(30), 
            @P_OBJECT_RELA VARCHAR(30), 
            @P_ROL0 VARCHAR(1), 
            @P_ROL1 VARCHAR(1), 
            @P_ROL2 VARCHAR(1), 
            @P_ROL3 VARCHAR(1), 
            @P_ROL4 VARCHAR(1), 
            @P_ROL5 VARCHAR(1), 
            @P_ROL6 VARCHAR(1), 
            @P_ROL7 VARCHAR(1), 
            @P_ROL8 VARCHAR(1), 
            @P_ROL9 VARCHAR(1), 
            @P_OBJECT_PROG VARCHAR(30), 
            @P_OBJECT_PRIV VARCHAR(1), 
            @P_OBJECT_ORDER VARCHAR(30), 
            @P_OBJECT_SEX VARCHAR(1), 
            @P_OBJECT_STATE VARCHAR(30), 
            @P_OBJECT_DATE datetime, 
            @P_OBJECT_PNAME VARCHAR(30), 
            @P_OBJECT_SHELL VARCHAR(30), 
            @P_CODI_MODU VARCHAR(30), 
            @P_PAR0 VARCHAR(30), 
            @P_PAR1 VARCHAR(30), 
            @P_PAR2 VARCHAR(30), 
            @P_PAR3 VARCHAR(30), 
            @P_PAR4 VARCHAR(30), 
            @P_PAR5 VARCHAR(30), 
            @P_PAR6 VARCHAR(30), 
            @P_PAR7 VARCHAR(30), 
            @P_PAR8 VARCHAR(30), 
            @P_PAR9 VARCHAR(30), 
            @P_VAL0 VARCHAR(30), 
            @P_VAL1 VARCHAR(30), 
            @P_VAL2 VARCHAR(30), 
            @P_VAL3 VARCHAR(30), 
            @P_VAL4 VARCHAR(30), 
            @P_VAL5 VARCHAR(30), 
            @P_VAL6 VARCHAR(30), 
            @P_VAL7 VARCHAR(30), 
            @P_VAL8 VARCHAR(30), 
            @P_VAL9 VARCHAR(30), 
            @P_OBJECT_ORUN VARCHAR(60), 
            @P_OBJECT_LEVEL numeric(22, 0), 
            @P_OBJECT_FREQ VARCHAR(1), 
            @P_CODI_ACTI numeric(22, 0), 
            @P_OBJECT_EMPR VARCHAR(1) 
 AS
 BEGIN
        UPDATE sys_object
             SET object_type = @P_OBJECT_TYPE, 
                 object_brief = @P_OBJECT_BRIEF, 
                 table_name = @P_TABLE_NAME, 
                 table_type = @P_TABLE_TYPE, 
                 appname = @P_APPNAME, 
                 form_type = @P_FORM_TYPE, 
                 report_name = @P_REPORT_NAME, 
                 report_type = @P_REPORT_TYPE, 
                 query_clause = @P_QUERY_CLAUSE, 
                 order_key = @P_ORDER_KEY, 
                 object_desc = @P_OBJECT_DESC, 
                 alter_key = @P_ALTER_KEY, 
                 object_code = @P_OBJECT_CODE, 
                 object_single = @P_OBJECT_SINGLE, 
                 object_rela = @P_OBJECT_RELA, 
                 rol0 = @P_ROL0, 
                 rol1 = @P_ROL1, 
                 rol2 = @P_ROL2, 
                 rol3 = @P_ROL3, 
                 rol4 = @P_ROL4, 
                 rol5 = @P_ROL5, 
                 rol6 = @P_ROL6, 
                 rol7 = @P_ROL7, 
                 rol8 = @P_ROL8, 
                 rol9 = @P_ROL9, 
                 object_prog = @P_OBJECT_PROG, 
                 object_priv = @P_OBJECT_PRIV, 
                 object_order = @P_OBJECT_ORDER, 
                 object_sex = @P_OBJECT_SEX, 
                 object_state = @P_OBJECT_STATE, 
                 object_date = @P_OBJECT_DATE, 
                 object_pname = @P_OBJECT_PNAME, 
                 object_shell = @P_OBJECT_SHELL, 
                 codi_modu = @P_CODI_MODU, 
                 par0 = @P_PAR0, 
                 par1 = @P_PAR1, 
                 par2 = @P_PAR2, 
                 par3 = @P_PAR3, 
                 par4 = @P_PAR4, 
                 par5 = @P_PAR5, 
                 par6 = @P_PAR6, 
                 par7 = @P_PAR7, 
                 par8 = @P_PAR8, 
                 par9 = @P_PAR9, 
                 val0 = @P_VAL0, 
                 val1 = @P_VAL1, 
                 val2 = @P_VAL2, 
                 val3 = @P_VAL3, 
                 val4 = @P_VAL4, 
                 val5 = @P_VAL5, 
                 val6 = @P_VAL6, 
                 val7 = @P_VAL7, 
                 val8 = @P_VAL8, 
                 val9 = @P_VAL9, 
                 object_orun = @P_OBJECT_ORUN, 
                 object_level = @P_OBJECT_LEVEL, 
                 object_freq = @P_OBJECT_FREQ, 
                 codi_acti = @P_CODI_ACTI, 
                 object_empr = @P_OBJECT_EMPR
             WHERE object_name = @P_OBJECT_NAME 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_dbn_repo_rous_read_busq]    Fecha de la secuencia de comandos: 09/23/2013 12:11:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 06-06-2013
-- Description:	Metodo que obtiene todos los listadores disponibles con el titulo, descripcion y url de el reporte
-- =============================================
ALTER PROCEDURE [dbo].[prc_dbn_repo_rous_read_busq]
(
	@p_codi_rous varchar(30),
	@p_codi_repo varchar(30)
)
AS
BEGIN
	select 	object_brief, 	object_desc, 
			object_prog, 	par0,
			val0,			par1,
			val1, 			object_type
	from 	sys_object 
	where 	object_type in ('B','W')
	and		codi_modu = @p_codi_rous
	and		UPPER(object_desc) like '%'+UPPER(@p_codi_repo)+'%'
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_rous_menu_categoria_read]    Fecha de la secuencia de comandos: 09/23/2013 12:12:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 30-01-2013
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_rous_menu_categoria_read](
	@P_CODI_ROUS VARCHAR(30),
	@P_CODI_MODU VARCHAR(30),
	@P_CODI_CATE VARCHAR(30))
AS
BEGIN
		select s.object_name, s.object_brief, f.codi_rous
                 from sys_object s left join sys_furo f
                 on s.object_name = f.object_name
                 and f.codi_rous = @P_CODI_ROUS
                 where s.codi_modu=@P_CODI_MODU
                 and s.OBJECT_TYPE!='L'
                 and   s.OBJECT_TYPE!='O' 
                 and s.object_orun is not null
                 and s.object_rela = @P_CODI_CATE
                 order by s.object_orun 
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_rous_menu_furo_alter]    Fecha de la secuencia de comandos: 09/23/2013 12:12:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 30-01-2013
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_rous_menu_furo_alter](
	@P_NOMB_ROUS VARCHAR(30),
	@P_CODI_MODU VARCHAR(30),
	@P_NOMB_MENU VARCHAR(30))
AS
BEGIN
	insert  sys_furo(codi_rous, form_type,  object_name, object_type, object_brief,  object_desc, object_code, object_single, object_rela, rol0, rol1, rol2, rol3, rol4, rol5, rol6, rol7, rol8, rol9, object_prog, object_priv, object_order, object_state, codi_modu, object_orun, object_level, par0, val0, par1, val1, par2, val2)
            select @P_NOMB_ROUS  ,'A' ,object_name, object_type, object_brief,  object_desc, object_code, object_single, object_rela, rol0, rol1, rol2, rol3, rol4, rol5, rol6, rol7, rol8, rol9, object_prog, object_priv, object_order, object_state, codi_modu, object_orun, object_level, par0, val0, par1, val1, par2, val2 from sys_object 
            where object_type!='L' and codi_modu = @P_CODI_MODU and object_name=@P_NOMB_MENU;
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_rous_menu_read]    Fecha de la secuencia de comandos: 09/23/2013 12:12:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 30-01-2013
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_rous_menu_read](
	@P_CODI_MODU VARCHAR(30),
	@P_CODI_ROUS VARCHAR(30)
)
AS
BEGIN
	select object_name , sum(comp) comp, object_orun , object_level , object_brief , object_type
				from (
                select object_name , 0 comp , object_orun , object_level , object_brief , object_type from sys_object
                where codi_modu= @P_CODI_MODU
                and OBJECT_TYPE!='L'
                and object_orun is not null 
                and object_level is not null
                union 
                select  object_name , 1 comp , object_orun , object_level , object_brief , object_type from sys_furo 
                where codi_modu=@P_CODI_MODU 
                and   codi_rous=@P_CODI_ROUS
                and object_level is not null 
                )
                t 
                group by object_name , object_orun , object_level , object_brief , object_type 
                order by object_orun 
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_sys_object_alter]    Fecha de la secuencia de comandos: 09/23/2013 12:12:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_sys_object_alter]
            @P_OBJECT_NAME VARCHAR(30), 
            @P_OBJECT_TYPE VARCHAR(1), 
            @P_OBJECT_BRIEF VARCHAR(100), 
            @P_TABLE_NAME VARCHAR(30), 
            @P_TABLE_TYPE VARCHAR(1), 
            @P_APPNAME VARCHAR(100), 
            @P_FORM_TYPE VARCHAR(1), 
            @P_REPORT_NAME VARCHAR(30), 
            @P_REPORT_TYPE VARCHAR(1), 
            @P_QUERY_CLAUSE VARCHAR(2000), 
            @P_ORDER_KEY numeric(3, 0), 
            @P_OBJECT_DESC VARCHAR(200), 
            @P_ALTER_KEY numeric(3, 0), 
            @P_OBJECT_CODE VARCHAR(30), 
            @P_OBJECT_SINGLE VARCHAR(30), 
            @P_OBJECT_RELA VARCHAR(30), 
            @P_ROL0 VARCHAR(1), 
            @P_ROL1 VARCHAR(1), 
            @P_ROL2 VARCHAR(1), 
            @P_ROL3 VARCHAR(1), 
            @P_ROL4 VARCHAR(1), 
            @P_ROL5 VARCHAR(1), 
            @P_ROL6 VARCHAR(1), 
            @P_ROL7 VARCHAR(1), 
            @P_ROL8 VARCHAR(1), 
            @P_ROL9 VARCHAR(1), 
            @P_OBJECT_PROG VARCHAR(30), 
            @P_OBJECT_PRIV VARCHAR(1), 
            @P_OBJECT_ORDER VARCHAR(30), 
            @P_OBJECT_SEX VARCHAR(1), 
            @P_OBJECT_STATE VARCHAR(30), 
            @P_OBJECT_DATE datetime, 
            @P_OBJECT_PNAME VARCHAR(30), 
            @P_OBJECT_SHELL VARCHAR(30), 
            @P_CODI_MODU VARCHAR(30), 
            @P_PAR0 VARCHAR(30), 
            @P_PAR1 VARCHAR(30), 
            @P_PAR2 VARCHAR(30), 
            @P_PAR3 VARCHAR(30), 
            @P_PAR4 VARCHAR(30), 
            @P_PAR5 VARCHAR(30), 
            @P_PAR6 VARCHAR(30), 
            @P_PAR7 VARCHAR(30), 
            @P_PAR8 VARCHAR(30), 
            @P_PAR9 VARCHAR(30), 
            @P_VAL0 VARCHAR(30), 
            @P_VAL1 VARCHAR(30), 
            @P_VAL2 VARCHAR(30), 
            @P_VAL3 VARCHAR(30), 
            @P_VAL4 VARCHAR(30), 
            @P_VAL5 VARCHAR(30), 
            @P_VAL6 VARCHAR(30), 
            @P_VAL7 VARCHAR(30), 
            @P_VAL8 VARCHAR(30), 
            @P_VAL9 VARCHAR(30), 
            @P_OBJECT_ORUN VARCHAR(60), 
            @P_OBJECT_LEVEL numeric(22, 0), 
            @P_OBJECT_FREQ VARCHAR(1), 
            @P_CODI_ACTI numeric(22, 0), 
            @P_OBJECT_EMPR VARCHAR(1) 
 AS
 BEGIN
        INSERT INTO sys_object(
            object_name, 		object_type, 		object_brief, 		table_name, 
            table_type, 		appname, 			form_type, 			report_name, 
            report_type, 		query_clause,   	order_key, 			object_desc, 
            alter_key, 			object_code, 		object_single, 		object_rela, 
            rol0, 				rol1, 				rol2, 				rol3, 
            rol4, 				rol5, 				rol6, 				rol7, 
            rol8, 				rol9, 				object_prog, 		object_priv, 
            object_order, 		object_sex, 		object_state, 		object_date, 
            object_pname, 		object_shell, 		codi_modu, 			par0, 
            par1, 				par2, 				par3, 				par4, 
            par5, 				par6, 				par7, 				par8, 
            par9, 				val0, 				val1, 				val2, 
            val3, 				val4, 				val5, 				val6, 
            val7, 				val8, 				val9, 				object_orun, 
            object_level, 		object_freq, 		codi_acti, 			object_empr
        )
		VALUES
        (
             @P_OBJECT_NAME, 	@P_OBJECT_TYPE, 	@P_OBJECT_BRIEF, 	@P_TABLE_NAME, 
             @P_TABLE_TYPE, 	@P_APPNAME, 		@P_FORM_TYPE, 		@P_REPORT_NAME, 
             @P_REPORT_TYPE, 	@P_QUERY_CLAUSE, 	@P_ORDER_KEY, 		@P_OBJECT_DESC, 
             @P_ALTER_KEY, 		@P_OBJECT_CODE, 	@P_OBJECT_SINGLE, 	@P_OBJECT_RELA, 
             @P_ROL0, 			@P_ROL1, 			@P_ROL2, 			@P_ROL3, 
             @P_ROL4, 	        @P_ROL5, 			@P_ROL6, 			@P_ROL7, 
             @P_ROL8, 			@P_ROL9, 			@P_OBJECT_PROG, 	@P_OBJECT_PRIV, 
             @P_OBJECT_ORDER, 	@P_OBJECT_SEX, 		@P_OBJECT_STATE, 	@P_OBJECT_DATE, 
             @P_OBJECT_PNAME, 	@P_OBJECT_SHELL, 	@P_CODI_MODU, 		@P_PAR0, 
             @P_PAR1, 			@P_PAR2, 			@P_PAR3, 			@P_PAR4, 
             @P_PAR5, 			@P_PAR6, 			@P_PAR7, 			@P_PAR8, 
             @P_PAR9, 			@P_VAL0, 			@P_VAL1, 			@P_VAL2, 
             @P_VAL3, 			@P_VAL4, 			@P_VAL5, 			@P_VAL6, 
             @P_VAL7, 			@P_VAL8, 			@P_VAL9, 			@P_OBJECT_ORUN, 
             @P_OBJECT_LEVEL, 	@P_OBJECT_FREQ, 	@P_CODI_ACTI, 		@P_OBJECT_EMPR
        );
END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_get_modulo_read]    Fecha de la secuencia de comandos: 09/23/2013 12:12:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---=============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 27-11-2012
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_get_modulo_read]
@P_OBJECT_NAME VARCHAR(30)	
AS
BEGIN
	select codi_modu from sys_object where object_type = 'L' and object_name = @P_OBJECT_NAME;		
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_InsDetaIndi]    Fecha de la secuencia de comandos: 09/23/2013 12:13:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_InsDetaIndi](
	@p_codi_emex  varchar(30),
	@p_codi_empr  numeric(9,0),
	@p_codi_indi  varchar(100),
	@p_letr_vari  varchar(20),
	@p_pref_conc  varchar(256),
	@p_codi_conc  varchar(100),
	@p_codi_cntx  varchar(50)) as
BEGIN
	insert into dbax_form_deta (codi_emex, codi_empr, codi_indi, letr_vari, pref_conc, codi_conc, codi_cntx)
	values					   (@p_codi_emex, @p_codi_empr, @p_codi_indi, @p_letr_vari, @p_pref_conc, @p_codi_conc,@p_codi_cntx)
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_GetDetaIndicadores]    Fecha de la secuencia de comandos: 09/23/2013 12:13:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_GetDetaIndicadores](
	@p_CodiEmex varchar(30),
	@p_CodiEmpr varchar(16),
	@p_CodiIndi varchar(100)) as
BEGIN


select  de.letr_vari,de.pref_conc, de.codi_conc, de.codi_cntx, ct.desc_cntx, ct.diai_cntx, ct.anoi_cntx, ct.diat_cntx, ct.anot_cntx
from dbax_form_deta de, dbax_defi_cntx ct  
where 
de.codi_cntx =ct.codi_cntx
and de.codi_emex = @p_CodiEmex 
and de.codi_empr = @p_CodiEmpr  
and de.codi_indi = @p_CodiIndi 

END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_GetDetaIndi]    Fecha de la secuencia de comandos: 09/23/2013 12:13:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_GetDetaIndi](
	@p_CodiEmex varchar(30),
	@p_CodiEmpr numeric(9,0),
	@p_CodiIndi varchar(100),
	@p_LetrVari varchar(1)) as
BEGIN
	select	fd.pref_conc, fd.codi_conc, dc.desc_conc, fd.codi_cntx
	from	dbax_form_deta fd,
			dbax_desc_conc dc
	where	fd.codi_emex = @p_CodiEmex
	and		fd.codi_empr = @p_CodiEmpr
	and		fd.codi_indi = @p_CodiIndi
	and		fd.letr_vari = @p_LetrVari
	and		fd.pref_conc = dc.pref_conc
	and		fd.codi_conc = dc.codi_conc
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getCodiFech]    Fecha de la secuencia de comandos: 09/23/2013 12:13:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getCodiFech] 
	@p_TipoFech  varchar(1)
as
BEGIN
	select '0' codi_fech, 'Seleccionar' desc_fech
	union
	select codi_fech as codi_fech, desc_fech as desc_fech 
	from dbax_codi_fech 
	where tipo_fech = @p_TipoFech
END
GO
/****** Objeto:  UserDefinedFunction [dbo].[FU_AX_getDescFech]    Fecha de la secuencia de comandos: 09/23/2013 12:13:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER function [dbo].[FU_AX_getDescFech](
			@p_CodiFech varchar(100)
            ) 
            returns varchar(4000)
begin
	declare @v_valor varchar(4000)

	select	@v_valor = desc_fech
	from	dbax_codi_fech
	where	codi_fech = @p_CodiFech

	return @v_valor
end
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_insEmpresaParaInforme]    Fecha de la secuencia de comandos: 09/23/2013 12:13:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_insEmpresaParaInforme](
	@pCodiEmpr numeric(9,0),
	@pDescEmpr varchar(200),
	@pCorrInst numeric(6,0)) as
BEGIN
	delete from dbax_tabl_temp where tipo_dato = 'IE'

	insert into dbax_tabl_temp (codi_colu1, codi_colu2, codi_colu3, tipo_dato)
	values					   (@pCodiEmpr, @pDescEmpr, @pCorrInst, 'IE')
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_alter_dbax_proc_even]    Fecha de la secuencia de comandos: 09/23/2013 12:11:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[prc_alter_dbax_proc_even]
					(@p_desc_proc varchar(500),
				     @p_borr_mens varchar(1),
					 @pCodiUsua varchar(25)='')
as
BEGIN
	if(@pCodiUsua!='')
	begin
		insert into dbax_proc_even
					(codi_usua, desc_proc, fech_even, borr_mens)
		values		('dbax', @p_desc_proc, GETDATE(), @p_borr_mens)
	end
	else
	begin
		insert into dbax_proc_even
					(codi_usua, desc_proc, fech_even, borr_mens)
		values		(@pCodiUsua, @p_desc_proc, GETDATE(), @p_borr_mens)
	end
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_read_dbax_proc_even]    Fecha de la secuencia de comandos: 09/23/2013 12:12:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[prc_read_dbax_proc_even] 
					(@pCodiUsua varchar(25)='')
as
BEGIN
	select	top 1 desc_proc  
	from	dbax_proc_even  
	where	codi_usua like '%%'  
	and		corr_proc = (select max(corr_proc) from dbax_proc_even where codi_usua like '%%')  
	and		(  
		   (datediff(s, fech_even, getdate()) < 5  
		   and	borr_mens = '1')  
	   OR (borr_mens = '0'))
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_alter_dbax_defi_ramo]    Fecha de la secuencia de comandos: 09/23/2013 12:11:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 19-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_alter_dbax_defi_ramo]
           @P_CODI_SEGM varchar(50), 
            @P_CODI_RAMO varchar(30), 
            @P_DESC_RAMO varchar(80), 
            @P_CODI_RAMO_SUPE varchar(30),
            @P_TIPO_RAMO varchar(1),
            @P_CODI_CONC varchar(64), 
            @P_NUME_RAMO varchar(10)
 AS
 BEGIN
        INSERT INTO dbax_defi_ramo(
            codi_segm, 
            codi_ramo, 
            desc_ramo, 
            codi_ramo_supe,
            tipo_ramo,
            codi_conc,
            nume_ramo
        )
        VALUES
        (
             @P_CODI_SEGM, 
             @P_CODI_RAMO, 
             @P_DESC_RAMO, 
             @P_CODI_RAMO_SUPE,
             @P_TIPO_RAMO,
             @P_CODI_CONC,
             @P_NUME_RAMO
        );
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_read_dbax_ramos]    Fecha de la secuencia de comandos: 09/23/2013 12:12:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas
-- alter date: 20-05-2013
-- Description:	Procedimiento almacenado para la obtencion de los ramos de los informes de cuadros tecnicos
-- =============================================
ALTER PROCEDURE [dbo].[prc_read_dbax_ramos]
(
	@p_codi_segm varchar(10)	
)
AS
BEGIN
	select r.codi_ramo + '.' + s.codi_ramo codi_ramo--, r.desc_ramo + ' '+ s.desc_ramo
	from   dbax_defi_ramo r, dbax_defi_ramo s
	where  r.codi_segm = @p_codi_segm
	and    r.tipo_ramo = 'R'
	and    s.codi_segm = r.codi_segm
	and    s.tipo_ramo = 'S'
	order by r.nume_ramo, s.nume_ramo
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_delete_dbax_defi_ramo]    Fecha de la secuencia de comandos: 09/23/2013 12:11:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 19-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_delete_dbax_defi_ramo]
            @P_CODI_SEGM varchar(50), 
            @P_CODI_RAMO varchar(30),
            @P_TIPO_RAMO varchar(1)
 AS
 BEGIN
        DELETE	dbax_defi_ramo
        WHERE	codi_segm = @P_CODI_SEGM 
        AND		codi_ramo = @P_CODI_RAMO 
        AND		tipo_ramo = @P_TIPO_RAMO
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_update_dbax_defi_ramo]    Fecha de la secuencia de comandos: 09/23/2013 12:12:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 18-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_update_dbax_defi_ramo]
            @P_CODI_SEGM varchar(50), 
            @P_CODI_RAMO varchar(30), 
            @P_DESC_RAMO varchar(80), 
            @P_CODI_RAMO_SUPE varchar(30),
            @P_TIPO_RAMO varchar(1),
            @P_CODI_CONC varchar(64), 
            @P_NUME_RAMO varchar(10)
 AS
 BEGIN
        UPDATE dbax_defi_ramo
             SET desc_ramo = @P_DESC_RAMO, 
                 codi_ramo_supe = @P_CODI_RAMO_SUPE,
                 codi_conc = @P_CODI_CONC,
                 nume_ramo = @P_NUME_RAMO
             WHERE codi_segm = @P_CODI_SEGM 
             AND   codi_ramo = @P_CODI_RAMO
             AND   tipo_ramo = @P_TIPO_RAMO
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_read_dbax_defi_ramo]    Fecha de la secuencia de comandos: 09/23/2013 12:12:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 19-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_read_dbax_defi_ramo] (
 @tsTipo as Varchar(2),
 @tnPagina as integer,
 @tnRegPag as integer,
 @tsCondicion as Varchar(2048),
 @tsPar1 as Varchar(30), @tsPar2 as Varchar(30),
 @tsPar3 as Varchar(30), @tsPar4 as Varchar(30), @tsPar5 as Varchar(30),
 @p_codi_usua varchar(30), @p_codi_empr int, @p_codi_emex varchar(30))
AS 
    /*
     Procedimiento para rescatar datos de la tabla DBAX_DEFI_RAMO
     CON EL 
     Parametros
        @tsTipo 
            S: Query utilizada para el mantenedor 
            L: Query utilizada para el listador 
            LV: Query utilizada para las listas de valor 
        @tnPagina	: Numero de pagina a rescatar 
        @tnRegPag	: Numero de registros por pagina
        @tsCondicion : Condicion, clausula Where
        @tsPar1		: Parametro 1 - codi_segm
        @tsPar2		: Parametro 2 - codi_ramo
        @tsPar3		: Parametro 3 - tipo_ramo
        @tsPar4		: Parametro 4 - 
        @tsPar5		: Parametro 5 - 
        @p_codi_usua    : Usuario
        @p_codi_empr    : Empresa
        @p_codi_emex    : Emex
     */
     declare @sql_dyn as integer
     declare @sql as nvarchar(4000)
BEGIN
  IF (@tsTipo = 'S')
  BEGIN
    SELECT CODI_SEGM, CODI_RAMO, 
           DESC_RAMO, CODI_RAMO_SUPE,
           TIPO_RAMO, CODI_CONC, NUME_RAMO
  FROM dbax_defi_ramo
  WHERE codi_segm = @tsPar1
  AND codi_ramo = @tsPar2
  AND tipo_ramo = @tsPar3
 END
 ELSE IF (@tsTipo = 'L')
 BEGIN
   SET @sql = 'SELECT ROW_NUMBER() OVER(ORDER BY dbdr.codi_segm ASC) AS REG, 
                dbdr.codi_segm, dbdr.codi_ramo, dbdr.desc_ramo, 
                dbdr.codi_ramo_supe, dbdr.tipo_ramo, dbdr.codi_conc, dbdr.nume_ramo
               FROM dbax_defi_ramo dbdr
               WHERE 1 = 1 '
 
   SET @sql = @sql + isnull(@tsCondicion,'')
   EXECUTE dbo.prc_list_dyn @sql, @tnPagina, @tnRegPag 
 END
 ELSE IF(@tsTipo = 'LV')
 BEGIN
	SELECT '' as CODIGO,
			'Seleccione' as VALOR
	union
	SELECT codi_ramo AS CODIGO,
			desc_ramo as VALOR
	FROM dbax_defi_ramo
 END
END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_read_ciudad]    Fecha de la secuencia de comandos: 09/23/2013 12:12:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas	
-- alter date: 21122012
-- Description:	Procedimiento para la obtencion  de las comunas
-- =============================================
ALTER PROCEDURE [dbo].[prc_read_ciudad] (
	@tsTipo as Varchar(2),	
	@tnPagina as integer,	
	@tnRegPag as integer, 
	@tsCondicion as Varchar(128),
	@tsPar1 as Varchar(30), @tsPar2 as Varchar(30), 
	@tsPar3 as Varchar(30), @tsPar4 as Varchar(30), @tsPar5 as Varchar(30),
	@p_codi_usua varchar(30), @p_codi_empr int, @p_codi_emex varchar(30))
AS
BEGIN
	IF(@tsTipo = 'LV')
	BEGIN
		SELECT	CODI_ARGE AS CODIGO,
				NOMB_ARGE AS VALOR
		FROM AREA_GEOG
		WHERE TIPO_ARGE = '04'
		ORDER BY NOMB_ARGE ASC;
	END
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_area_geog_read_comunas]    Fecha de la secuencia de comandos: 09/23/2013 12:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas	
-- alter date: 21122012
-- Description:	Procedimiento para la obtencion  de las comunas
-- =============================================
ALTER PROCEDURE [dbo].[prc_area_geog_read_comunas] (
	@tsTipo as VARCHAR(3),	
	@tnPagina as INTEGER,	
	@tnRegPag as INTEGER, 
	@tsCondicion as VARCHAR(2048),
	@tsPar1 as VARCHAR(256), @tsPar2 as VARCHAR(256), 
	@tsPar3 as VARCHAR(256), @tsPar4 as VARCHAR(256), @tsPar5 as VARCHAR(256),
	@p_codi_usua VARCHAR(30), @p_codi_empr INTEGER, @p_codi_emex VARCHAR(30))
AS
BEGIN
	IF(@tsTipo = 'LV')
	BEGIN
		SELECT	CODI_ARGE AS CODIGO,
				NOMB_ARGE AS VALOR
		FROM AREA_GEOG
		WHERE TIPO_ARGE = '05'
		ORDER BY NOMB_ARGE ASC;
	END
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_area_geog_read_pais]    Fecha de la secuencia de comandos: 09/23/2013 12:11:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 21122012	
-- Description:	Procedimiento para la obtencion de el pais
-- =============================================
ALTER PROCEDURE [dbo].[prc_area_geog_read_pais] (
	@tsTipo as VARCHAR(3),	
	@tnPagina as INTEGER,	
	@tnRegPag as INTEGER, 
	@tsCondicion as VARCHAR(2048),
	@tsPar1 as VARCHAR(256), @tsPar2 as VARCHAR(256), 
	@tsPar3 as VARCHAR(256), @tsPar4 as VARCHAR(256), @tsPar5 as VARCHAR(256),
	@p_codi_usua VARCHAR(30), @p_codi_empr INTEGER, @p_codi_emex VARCHAR(30))
AS
BEGIN
	IF(@tsTipo = 'LV')
	BEGIN
		SELECT	CODI_ARGE AS CODIGO,
				NOMB_ARGE AS VALOR
		FROM AREA_GEOG
		WHERE TIPO_ARGE = '01'
		ORDER BY NOMB_ARGE ASC;
	END
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_area_geog_read_ciudad]    Fecha de la secuencia de comandos: 09/23/2013 12:11:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas	
-- alter date: 21122012
-- Description:	Procedimiento para la obtencion  de las comunas
-- =============================================
ALTER PROCEDURE [dbo].[prc_area_geog_read_ciudad] (
	@tsTipo as VARCHAR(3),	
	@tnPagina as INTEGER,	
	@tnRegPag as INTEGER, 
	@tsCondicion as VARCHAR(2048),
	@tsPar1 as VARCHAR(256), @tsPar2 as VARCHAR(256), 
	@tsPar3 as VARCHAR(256), @tsPar4 as VARCHAR(256), @tsPar5 as VARCHAR(256),
	@p_codi_usua VARCHAR(30), @p_codi_empr INTEGER, @p_codi_emex VARCHAR(30))
AS
BEGIN
	IF(@tsTipo = 'LV')
	BEGIN
		SELECT	CODI_ARGE AS CODIGO,
				NOMB_ARGE AS VALOR
		FROM AREA_GEOG
		WHERE TIPO_ARGE = '04'
		ORDER BY NOMB_ARGE ASC;
	END
END
GO
/****** Objeto:  UserDefinedFunction [dbo].[addmonths]    Fecha de la secuencia de comandos: 09/23/2013 12:13:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER function [dbo].[addmonths](@pPeriodo varchar(6), @pMeses numeric(2)) returns datetime
begin
	return DATEADD(month, @pMeses , dbo.lastday(@pPeriodo));
end
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getArchivosXbrl]    Fecha de la secuencia de comandos: 09/23/2013 12:13:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getArchivosXbrl] 
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
        or substring(nomb_arch,charindex('.',nomb_arch), len(nomb_arch)) = '.pdf'
		or substring(nomb_arch,charindex('.',nomb_arch), len(nomb_arch)) = '.html'
		)
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
/****** Objeto:  StoredProcedure [dbo].[SP_AX_delInstDocu]    Fecha de la secuencia de comandos: 09/23/2013 12:13:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_AX_delInstDocu] (@pCodiPers numeric(9,0),@pCorrInst numeric(10,0))
AS
BEGIN
	delete from dbax_inst_conc where codi_pers = @pCodiPers  and corr_inst = @pCorrInst
	delete from dbax_inst_arch where codi_pers = @pCodiPers  and corr_inst = @pCorrInst
	delete from dbax_inst_unit where codi_pers = @pCodiPers  and corr_inst = @pCorrInst
	delete from dbax_inst_dicx where codi_pers = @pCodiPers  and corr_inst = @pCorrInst
	delete from dbax_inst_cntx where codi_pers = @pCodiPers  and corr_inst = @pCorrInst
	delete from dbax_inst_info where codi_pers = @pCodiPers  and corr_inst = @pCorrInst
	delete from dbax_inst_vers where codi_pers = @pCodiPers  and corr_inst = @pCorrInst
	delete from dbax_inst_docu where codi_pers = @pCodiPers  and corr_inst = @pCorrInst
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_InsBase64XBRL]    Fecha de la secuencia de comandos: 09/23/2013 12:13:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_InsBase64XBRL](
	@pCodi_pers numeric(9,0) ,
	@pCorr_inst varchar(10),
	@pVersInst numeric(5,0),
	@pCont_arch text,
	@pNomb_Arch varchar(256),
    @pTipo_mime varchar(50)) as
BEGIN 
	delete from dbax_inst_arch 
	where codi_pers = @pCodi_pers 
	and corr_inst = @pCorr_inst 
	and vers_inst =  @pVersInst 
	and nomb_arch = @pNomb_Arch
	
	insert into dbax_inst_arch (codi_pers,corr_inst,vers_inst,cont_arch,nomb_arch, tipo_mime) 
    values (@pCodi_pers,@pCorr_inst,@pVersInst,@pCont_arch,@pNomb_Arch,@pTipo_mime)
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_GetBase64XBRL]    Fecha de la secuencia de comandos: 09/23/2013 12:13:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_GetBase64XBRL](
	@pCodi_pers numeric(9,0) ,
	@pCorr_inst varchar(10),
	@pNomb_Arch varchar(256)) as
BEGIN
	select top 1 cont_arch 
	from dbax_inst_arch 
	where codi_pers = @pCodi_pers
    and   corr_inst = @pCorr_inst
	and   nomb_arch = @pNomb_Arch
	order by vers_inst desc
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_alter_cent_cost]    Fecha de la secuencia de comandos: 09/23/2013 12:11:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER procedure [dbo].[prc_alter_cent_cost]
            @P_CODI_EMEX varchar(30), 
            @P_CODI_EMPR numeric(9, 0), 
            @P_CODI_CECO varchar(16), 
            @P_NOMB_CECO varchar(80), 
            @P_CODI_CECO1 varchar(16), 
            @P_TIPO_CECO varchar(2), 
            @P_NUME_CECO numeric(6, 0), 
            @P_RESU_CECO varchar(12), 
            @P_RESU_CECO1 varchar(12), 
            @P_FLAG_RAMO varchar(1), 
            @P_LEVE_CECO numeric(2, 0), 
            @P_OPER_CUCO varchar(5), 
            @P_CODI_ZONA numeric(4, 0), 
            @P_CODI_OFIC varchar(3), 
            @P_ACTI_CECO varchar(1), 
            @P_FEIN_CECO datetime, 
            @P_FETE_CECO datetime, 
            @P_CODI_PERS varchar(16), 
            @P_NUME_CECO1 numeric(6, 0), 
            @P_CODI_CIUD varchar(8), 
            @P_CODI_UBIC varchar(3), 
            @P_CODI_EXEN varchar(1), 
            @P_TIAR_CECO varchar(2) 
 AS
 BEGIN
        INSERT INTO cent_cost(
            codi_emex, 
            codi_empr, 
            codi_ceco, 
            nomb_ceco, 
            codi_ceco1, 
            tipo_ceco, 
            nume_ceco, 
            resu_ceco, 
            resu_ceco1, 
            flag_ramo, 
            leve_ceco, 
            oper_cuco, 
            codi_zona, 
            codi_ofic, 
            acti_ceco, 
            fein_ceco, 
            fete_ceco, 
            codi_pers, 
            nume_ceco1, 
            codi_ciud, 
            codi_ubic, 
            codi_exen, 
            tiar_ceco
        )
        VALUES
        (
             @P_CODI_EMEX, 
             @P_CODI_EMPR, 
             @P_CODI_CECO, 
             @P_NOMB_CECO, 
             @P_CODI_CECO1, 
             @P_TIPO_CECO, 
             @P_NUME_CECO, 
             @P_RESU_CECO, 
             @P_RESU_CECO1, 
             @P_FLAG_RAMO, 
             @P_LEVE_CECO, 
             @P_OPER_CUCO, 
             @P_CODI_ZONA, 
             @P_CODI_OFIC, 
             @P_ACTI_CECO, 
             @P_FEIN_CECO, 
             @P_FETE_CECO, 
             @P_CODI_PERS, 
             @P_NUME_CECO1, 
             @P_CODI_CIUD, 
             @P_CODI_UBIC, 
             @P_CODI_EXEN, 
             @P_TIAR_CECO
        );
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_delete_cent_cost]    Fecha de la secuencia de comandos: 09/23/2013 12:11:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_delete_cent_cost]
            @P_CODI_EMEX varchar(30), 
            @P_CODI_EMPR numeric(9, 0), 
            @P_CODI_CECO varchar(16) 
 AS
 BEGIN
        DELETE cent_cost
        WHERE codi_emex = @P_CODI_EMEX 
        AND   codi_empr = @P_CODI_EMPR 
        AND   codi_ceco = @P_CODI_CECO 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_cent_cost_alter]    Fecha de la secuencia de comandos: 09/23/2013 12:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER procedure [dbo].[prc_cent_cost_alter]
            @P_CODI_EMEX VARCHAR(30), 
            @P_CODI_EMPR numeric(9, 0), 
            @P_CODI_CECO VARCHAR(16), 
            @P_NOMB_CECO VARCHAR(80), 
            @P_CODI_CECO1 VARCHAR(16), 
            @P_TIPO_CECO VARCHAR(2), 
            @P_NUME_CECO numeric(6, 0), 
            @P_RESU_CECO VARCHAR(12), 
            @P_RESU_CECO1 VARCHAR(12), 
            @P_FLAG_RAMO VARCHAR(1), 
            @P_LEVE_CECO numeric(2, 0), 
            @P_OPER_CUCO VARCHAR(5), 
            @P_CODI_ZONA numeric(4, 0), 
            @P_CODI_OFIC VARCHAR(3), 
            @P_ACTI_CECO VARCHAR(1), 
            @P_FEIN_CECO datetime, 
            @P_FETE_CECO datetime, 
            @P_CODI_PERS VARCHAR(16), 
            @P_NUME_CECO1 numeric(6, 0), 
            @P_CODI_CIUD VARCHAR(8), 
            @P_CODI_UBIC VARCHAR(3), 
            @P_CODI_EXEN VARCHAR(1), 
            @P_TIAR_CECO VARCHAR(2) 
 AS
 BEGIN
        INSERT INTO cent_cost(
            codi_emex, 		codi_empr, 		codi_ceco, 		nomb_ceco, 
            codi_ceco1, 	tipo_ceco, 		nume_ceco, 		resu_ceco, 
            resu_ceco1, 	flag_ramo, 		leve_ceco, 		oper_cuco, 
            codi_zona, 		codi_ofic, 		acti_ceco, 		fein_ceco, 
            fete_ceco, 		codi_pers, 		nume_ceco1, 	codi_ciud, 
            codi_ubic, 		codi_exen, 		tiar_ceco
        )
        VALUES
        (
             @P_CODI_EMEX, 	@P_CODI_EMPR, 	@P_CODI_CECO, 	@P_NOMB_CECO, 
             @P_CODI_CECO1, @P_TIPO_CECO, 	@P_NUME_CECO, 	@P_RESU_CECO, 
             @P_RESU_CECO1, @P_FLAG_RAMO, 	@P_LEVE_CECO, 	@P_OPER_CUCO, 
             @P_CODI_ZONA, 	@P_CODI_OFIC, 	@P_ACTI_CECO, 	@P_FEIN_CECO, 
             @P_FETE_CECO, 	@P_CODI_PERS, 	@P_NUME_CECO1, @P_CODI_CIUD, 
             @P_CODI_UBIC, 	@P_CODI_EXEN, 	@P_TIAR_CECO
        );
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_cent_cost_delete]    Fecha de la secuencia de comandos: 09/23/2013 12:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_cent_cost_delete]
            @P_CODI_EMEX VARCHAR(30), 
            @P_CODI_EMPR numeric(9, 0), 
            @P_CODI_CECO VARCHAR(16) 
 AS
 BEGIN
        DELETE cent_cost
        WHERE codi_emex = @P_CODI_EMEX 
        AND   codi_empr = convert(VARCHAR,@P_CODI_EMPR )
        AND   codi_ceco = @P_CODI_CECO 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_cent_cost_read]    Fecha de la secuencia de comandos: 09/23/2013 12:11:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_cent_cost_read] (
 @tsTipo as VARCHAR(3),
 @tnPagina as INTEGER,
 @tnRegPag as INTEGER,
 @tsCondicion as VARCHAR(2048),
 @tsPar1 as VARCHAR(256), @tsPar2 as VARCHAR(256),
 @tsPar3 as VARCHAR(256), @tsPar4 as VARCHAR(256), @tsPar5 as VARCHAR(256),
 @p_codi_usua VARCHAR(30), @p_codi_empr INTEGER, @p_codi_emex VARCHAR(30))
AS 
    /*
     Procedimiento para rescatar datos de la tabla CENT_COST
     CON EL 
     Parametros
        @tsTipo 
            S: Query utilizada para el mantenedor 
            L: Query utilizada para el listador 
            LV: Query utilizada para las listas de valor 
        @tnPagina	: Numero de pagina a rescatar 
        @tnRegPag	: Numero de registros por pagina
        @tsCondicion : Condicion, clausula Where
        @tsPar1		: Parametro 1 - codi_ceco
        @tsPar2		: Parametro 2 - 
        @tsPar3		: Parametro 3 - 
        @tsPar4		: Parametro 4 - 
        @tsPar5		: Parametro 5 - 
        @p_codi_usua    : Usuario
        @p_codi_empr    : Empresa
        @p_codi_emex    : Emex
     */
     declare @sql_dyn as INTEGER
     declare @sql as nVARCHAR(4000)
BEGIN
  IF (@tsTipo = 'S')
  BEGIN
    SELECT codi_emex, 	codi_empr, 	codi_ceco, 	nomb_ceco, 
           codi_ceco1, 	tipo_ceco, 	nume_ceco, 	resu_ceco, 
           resu_ceco1, 	flag_ramo, 	leve_ceco, 	oper_cuco, 
           codi_zona, 	codi_ofic, 	acti_ceco, 	fein_ceco, 
           fete_ceco, 	codi_pers, 	nume_ceco1, codi_ciud, 
           codi_ubic, 	codi_exen, 	tiar_ceco
  FROM cent_cost
  WHERE codi_emex = @p_codi_emex
  AND   codi_empr = @p_codi_empr
  AND   codi_ceco = @tsPar1
 END
 ELSE IF (@tsTipo = 'L')
 BEGIN
   SET @sql = 'SELECT ROW_NUMBER() OVER(ORDER BY codi_ceco ASC) AS REG, 
				   codi_emex, 	codi_empr, 	codi_ceco, 	nomb_ceco, 
				   codi_ceco1, 	tipo_ceco, 	nume_ceco, 	resu_ceco, 
				   resu_ceco1, 	flag_ramo, 	leve_ceco, 	oper_cuco, 
				   codi_zona, 	codi_ofic, 	acti_ceco, 	fein_ceco, 
				   fete_ceco, 	codi_pers, 	nume_ceco1, codi_ciud, 
				   codi_ubic, 	codi_exen, 	tiar_ceco
               FROM cent_cost
               WHERE codi_emex = ''' + @p_codi_emex + '''
               AND codi_empr = ''' + STR(@p_codi_empr)+ '''  '
 
   SET @sql = @sql + isnull(@tsCondicion,'')
   EXECUTE prc_list_dyn @sql, @tnPagina, @tnRegPag 
 END
 ELSE IF(@tsTipo = 'LV')
 BEGIN
	SELECT codi_ceco AS CODIGO,
				nomb_ceco AS VALOR
		FROM cent_cost
		ORDER BY nomb_ceco ASC;
 END
END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_cent_cost_update]    Fecha de la secuencia de comandos: 09/23/2013 12:11:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_cent_cost_update]
            @P_CODI_EMEX VARCHAR(30), 
            @P_CODI_EMPR numeric(9, 0), 
            @P_CODI_CECO VARCHAR(16), 
            @P_NOMB_CECO VARCHAR(80), 
            @P_CODI_CECO1 VARCHAR(16), 
            @P_TIPO_CECO VARCHAR(2), 
            @P_NUME_CECO numeric(6, 0), 
            @P_RESU_CECO VARCHAR(12), 
            @P_RESU_CECO1 VARCHAR(12), 
            @P_FLAG_RAMO VARCHAR(1), 
            @P_LEVE_CECO numeric(2, 0), 
            @P_OPER_CUCO VARCHAR(5), 
            @P_CODI_ZONA numeric(4, 0), 
            @P_CODI_OFIC VARCHAR(3), 
            @P_ACTI_CECO VARCHAR(1), 
            @P_FEIN_CECO datetime, 
            @P_FETE_CECO datetime, 
            @P_CODI_PERS VARCHAR(16), 
            @P_NUME_CECO1 numeric(6, 0), 
            @P_CODI_CIUD VARCHAR(8), 
            @P_CODI_UBIC VARCHAR(3), 
            @P_CODI_EXEN VARCHAR(1), 
            @P_TIAR_CECO VARCHAR(2) 
 AS
 BEGIN
        UPDATE cent_cost
             SET nomb_ceco = @P_NOMB_CECO, 
                 codi_ceco1 = @P_CODI_CECO1, 
                 tipo_ceco = @P_TIPO_CECO, 
                 nume_ceco = @P_NUME_CECO, 
                 resu_ceco = @P_RESU_CECO, 
                 resu_ceco1 = @P_RESU_CECO1, 
                 flag_ramo = @P_FLAG_RAMO, 
                 leve_ceco = @P_LEVE_CECO, 
                 oper_cuco = @P_OPER_CUCO, 
                 codi_zona = @P_CODI_ZONA, 
                 codi_ofic = @P_CODI_OFIC, 
                 acti_ceco = @P_ACTI_CECO, 
                 fein_ceco = @P_FEIN_CECO, 
                 fete_ceco = @P_FETE_CECO, 
                 codi_pers = @P_CODI_PERS, 
                 nume_ceco1 = @P_NUME_CECO1, 
                 codi_ciud = @P_CODI_CIUD, 
                 codi_ubic = @P_CODI_UBIC, 
                 codi_exen = @P_CODI_EXEN, 
                 tiar_ceco = @P_TIAR_CECO
             WHERE codi_emex = @P_CODI_EMEX 
             AND   codi_empr = @P_CODI_EMPR 
             AND   codi_ceco = @P_CODI_CECO 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_dbn_list_repo_read]    Fecha de la secuencia de comandos: 09/23/2013 12:11:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	<Author,,Aaron Rojas>
-- alter date: <alter Date,,2012-09-25>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_dbn_list_repo_read] (
	@tsTipo as Varchar(4),	
	@tnPagina as integer,	
	@tnRegPag as integer, 
	@tsCondicion as Varchar(128),
	@tsPar1 as Varchar(256), @tsPar2 as Varchar(256), 
	@tsPar3 as Varchar(256), @tsPar4 as Varchar(256), @tsPar5 as Varchar(256),
	@p_codi_usua varchar(30), @p_codi_empr int, @p_codi_emex varchar(30))
AS
BEGIN
	/*Tipo que se ocupa para los listadores*/
	IF(@tsTipo = 'C')
	BEGIN
		SELECT	CODI_REPO,			TITU_REPO, 
				DESC_REPO,			CODI_RESX, 
				PROC_REPO,			CODI_MODU,
				SCRP_SQLS,			SCRP_SQLO,
				FILT_CKBB,			PAGE_REPO,
				MODO,				CATE_LIST,
				TIPO_REPO,			SUBT_CNTX
				FROM DBN_LIST_REPO
				WHERE CODI_REPO = @tsPar1;
	END
	/*Tipo para las listas de valores*/
	ELSE IF(@tsTipo = 'LV')
	BEGIN
		SELECT '' as CODIGO,
				'Seleccione' as VALOR
		UNION
		SELECT	CODI_REPO as CODIGO,
				CODI_REPO +' - '+ TITU_REPO AS VALOR 
		FROM	DBN_LIST_REPO
		ORDER BY CODIGO,VALOR
	END
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_dbn_list_repo_update]    Fecha de la secuencia de comandos: 09/23/2013 12:11:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 24-10-2012
-- Description:	Procedimiento para Actualizar los Datos de la Tabla DbnListRepo
-- =============================================
ALTER PROCEDURE [dbo].[prc_dbn_list_repo_update] 
		@P_CODI_REPO VARCHAR(25),			@P_TITU_REPO VARCHAR(128), 
		@P_DESC_REPO VARCHAR(200),			@P_CODI_RESX VARCHAR(30),
		@P_PROC_REPO VARCHAR(30),			@P_CODI_MODU VARCHAR(30),
		@P_SCRP_SQLS TEXT,					@P_SCRP_SQLO TEXT,
		@P_FILT_CKBB VARCHAR(1),			@P_PAGE_REPO VARCHAR(128),
		@P_MODO VARCHAR(2),					@P_CATE_LIST VARCHAR(64),
		@P_TIPO_REPO VARCHAR(64),			@P_SUBT_CNTX VARCHAR(2048)
AS
BEGIN
	UPDATE dbn_list_repo 
	SET TITU_REPO = @P_TITU_REPO,
		DESC_REPO = @P_DESC_REPO,
		CODI_RESX = @P_CODI_RESX,
		CODI_MODU = @P_CODI_MODU,			
		PROC_REPO = @P_PROC_REPO,
		SCRP_SQLS = @P_SCRP_SQLS,				
		SCRP_SQLO = @P_SCRP_SQLO,
		FILT_CKBB = @P_FILT_CKBB,
		PAGE_REPO = @P_PAGE_REPO,
		MODO = @P_MODO,
		CATE_LIST = @P_CATE_LIST,
		TIPO_REPO = @P_TIPO_REPO,
		SUBT_CNTX = @P_SUBT_CNTX
		WHERE CODI_REPO = @P_CODI_REPO;			
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_dbn_list_repo_alter]    Fecha de la secuencia de comandos: 09/23/2013 12:11:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 24-10-2012
-- Description:	Procedimiento para el ingreso de reportes
-- =============================================
ALTER PROCEDURE [dbo].[prc_dbn_list_repo_alter] 
		@P_CODI_REPO VARCHAR(25),			@P_TITU_REPO VARCHAR(128), 
		@P_DESC_REPO VARCHAR(200),			@P_CODI_RESX VARCHAR(30),
		@P_PROC_REPO VARCHAR(30),			@P_CODI_MODU VARCHAR(30),
		@P_SCRP_SQLS TEXT,					@P_SCRP_SQLO TEXT,
		@P_FILT_CKBB VARCHAR(1),			@P_PAGE_REPO VARCHAR(128),
		@P_MODO VARCHAR(2),					@P_CATE_LIST VARCHAR(64),
		@P_TIPO_REPO VARCHAR(64),			@P_SUBT_CNTX VARCHAR(2048)
AS
BEGIN
	INSERT INTO dbn_list_repo(
				CODI_REPO				,TITU_REPO,
				DESC_REPO				,CODI_RESX,
				CODI_MODU				,PROC_REPO,
				SCRP_SQLS				,SCRP_SQLO,
				FILT_CKBB				,PAGE_REPO,
				MODO					,CATE_LIST,
				TIPO_REPO				,SUBT_CNTX)			
     VALUES(
				@P_CODI_REPO,			@P_TITU_REPO, 
				@P_DESC_REPO ,			@P_CODI_RESX,
				@P_PROC_REPO ,			@P_CODI_MODU ,
				@P_SCRP_SQLS ,			@P_SCRP_SQLO,
				@P_FILT_CKBB ,			@P_PAGE_REPO,
				@P_MODO,				@P_CATE_LIST,
				@P_TIPO_REPO,			@P_SUBT_CNTX);		
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_dbn_list_colu_alter_auto]    Fecha de la secuencia de comandos: 09/23/2013 12:11:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas
-- alter date: 26-07-2013
-- Description:	Procedimiento para Realizar la creación de columnas automaticas
-- =============================================
ALTER PROCEDURE [dbo].[prc_dbn_list_colu_alter_auto] 
		@P_CODI_REPO VARCHAR(35),			
		@P_CODI_COLU VARCHAR(15),
		@P_ORDE_COLU int
AS
BEGIN
		INSERT INTO DBN_LIST_COLU(
				CODI_REPO				,CODI_COLU,			NOMB_COLU				,DESC_COLU,
				CLAS_CSS				,TIPO_COLU,			ANCH_COLU				,ALIN_COLU, 
				INDI_VISI				,CODI_RESX,			ORDE_COLU				,INDI_BUSQ)			
		SELECT	@P_CODI_REPO,			@P_CODI_COLU,		@P_CODI_COLU ,			@P_CODI_COLU,
				'Bounfield' ,			'texto',			'100' ,					'L',
				'1',					@P_CODI_COLU,		@P_ORDE_COLU,			0
		FROM  DBN_LIST_REPO R
		WHERE CODI_REPO = @P_CODI_REPO
		AND   NOT EXISTS (SELECT 1 FROM DBN_LIST_COLU C
						  WHERE C.CODI_REPO = R.CODI_REPO
						  AND   C.CODI_COLU = @P_CODI_COLU)
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_dbn_list_repo_delete]    Fecha de la secuencia de comandos: 09/23/2013 12:11:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas
-- alter date: 12-07-2013
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_dbn_list_repo_delete]
@P_CODI_REPO varchar(20)
AS
BEGIN
	DELETE 
		FROM DBN_LIST_REPO 
		WHERE CODI_REPO = @P_CODI_REPO;
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_read_dbax_defi_peho]    Fecha de la secuencia de comandos: 09/23/2013 12:12:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Aaron Rojas
-- alter date: 19-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_read_dbax_defi_peho] (
 @tsTipo as Varchar(2),
 @tnPagina as integer,
 @tnRegPag as integer,
 @tsCondicion as Varchar(2048),
 @tsPar1 as Varchar(30), @tsPar2 as Varchar(30),
 @tsPar3 as Varchar(30), @tsPar4 as Varchar(30), @tsPar5 as Varchar(30),
 @p_codi_usua varchar(30), @p_codi_empr int, @p_codi_emex varchar(30))
AS 
    /*
     Procedimiento para rescatar datos de la tabla DBAX_DEFI_PEHO
     CON EL 
     Parametros
        @tsTipo 
            S: Query utilizada para el mantenedor 
            L: Query utilizada para el listador 
            LV: Query utilizada para las listas de valor 
        @tnPagina	: Numero de pagina a rescatar 
        @tnRegPag	: Numero de registros por pagina
        @tsCondicion : Condicion, clausula Where
        @tsPar1		: Parametro 1 - codi_pers
        @tsPar2		: Parametro 2 - 
        @tsPar3		: Parametro 3 - 
        @tsPar4		: Parametro 4 - 
        @tsPar5		: Parametro 5 - 
        @p_codi_usua    : Usuario
        @p_codi_empr    : Empresa
        @p_codi_emex    : Emex
     */
     declare @sql_dyn as integer
     declare @sql as nvarchar(4000)
BEGIN
  IF (@tsTipo = 'S')
  BEGIN
    SELECT codi_emex, 
           codi_empr, 
           codi_pers, 
           desc_empr
  FROM dbax_defi_peho
  WHERE codi_emex = @p_codi_emex
  AND   codi_empr = @p_codi_empr
  AND   codi_pers = @tsPar1
 END
 ELSE IF (@tsTipo = 'L')
 BEGIN
   SET @sql = 'SELECT ROW_NUMBER() OVER(ORDER BY codi_pers ASC) AS REG, 
                codi_emex, codi_empr, codi_pers, 
                desc_empr
               FROM dbax_defi_peho
               WHERE codi_emex = ''' + str(@p_codi_emex) + '''
               AND   codi_empr = ' + @p_codi_empr + '
               '
 
   SET @sql = @sql + isnull(@tsCondicion,'')
   EXECUTE dbo.prc_list_dyn @sql, @tnPagina, @tnRegPag 
 END
END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_list_repo]    Fecha de la secuencia de comandos: 09/23/2013 12:12:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	<Author,,Aaron Rojas>
-- alter date: <alter Date,,2012-10-01>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_list_repo] (
	@tsNombreProcedimiento VARCHAR(4000),
	@tsTipo as Varchar(2),	@tnPagina as integer,	@tnRegPag as integer, @tsCondicion as Varchar(2048),
	@tsPar1 as Varchar(256), @tsPar2 as Varchar(256), @tsPar3 as Varchar(256), @tsPar4 as Varchar(256), 
	@tsPar5 as Varchar(256), @p_codi_usua varchar(30), @p_codi_empr int, @p_codi_emex varchar(30))
AS
declare @sql as nvarchar(4000)
declare @lsPagina as varchar(15)
declare @lsRegPag as varchar(15)
BEGIN
	IF(LEN(@tsNombreProcedimiento) <= 25)
	BEGIN
		EXECUTE @tsNombreProcedimiento @tsTipo, @tnPagina, @tnRegPag, @tsCondicion, @tsPar1, @tsPar2, @tsPar3, @tsPar4, @tsPar5, @p_codi_usua, @p_codi_empr, @p_codi_emex;
	END
	ELSE
	BEGIN
		set @lsPagina = convert(varchar(15), @tnPagina)
		set @lsRegPag = convert(varchar(15), @tnRegPag)  
		
		SET @sql = @tsNombreProcedimiento +  isnull(@tsCondicion,'')
		if (@p_codi_emex is not null)
			SET @sql = replace(@sql,':P_CODI_EMEX',@p_codi_emex)
		if (@p_codi_empr is not null)
			SET @sql = replace(@sql,':P_CODI_EMPR',@p_codi_empr)
		if (@p_codi_usua is not null)
			SET @sql = replace(@sql,':P_CODI_USUA',@p_codi_usua)
		if (@tsPar1 is not null)
			SET @sql = replace(@sql,':P_PAR1',@tsPar1)
		if (@tsPar2 is not null)
			SET @sql = replace(@sql,':P_PAR2',@tsPar2)
		if (@tsPar3 is not null)
			SET @sql = replace(@sql,':P_PAR3',@tsPar3)
		if (@tsPar4 is not null)
			SET @sql = replace(@sql,':P_PAR4',@tsPar4)
		if (@tsPar5 is not null)
			SET @sql = replace(@sql,':P_PAR5',@tsPar5)

		EXECUTE prc_list_dyn @sql, @tnPagina, @tnRegPag
	END
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_read_dbax_defi_pers]    Fecha de la secuencia de comandos: 09/23/2013 12:12:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 19-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_read_dbax_defi_pers] (
 @tsTipo as Varchar(2),
 @tnPagina as integer,
 @tnRegPag as integer,
 @tsCondicion as Varchar(2048),
 @tsPar1 as Varchar(256), @tsPar2 as Varchar(256),
 @tsPar3 as Varchar(256), @tsPar4 as Varchar(256), @tsPar5 as Varchar(256),
 @p_codi_usua varchar(30), @p_codi_empr int, @p_codi_emex varchar(30))
AS 
    /*
     Procedimiento para rescatar datos de la tabla DBAX_DEFI_PERS
     CON EL 
     Parametros
        @tsTipo 
            S: Query utilizada para el mantenedor 
            L: Query utilizada para el listador 
            LV: Query utilizada para las listas de valor 
        @tnPagina	: Numero de pagina a rescatar 
        @tnRegPag	: Numero de registros por pagina
        @tsCondicion : Condicion, clausula Where
        @tsPar1		: Parametro 1 - codi_pers
        @tsPar2		: Parametro 2 - descripcion
        @tsPar3		: Parametro 3 - grupo
        @tsPar4		: Parametro 4 - segmento
        @tsPar5		: Parametro 5 - tipo
        @p_codi_usua    : Usuario
        @p_codi_empr    : Empresa
        @p_codi_emex    : Emex
     */
    declare @sql_dyn as integer
    declare @sql as nvarchar(4000)
	    
	declare @vComodinGrup varchar(3)
	declare @vComodinSegm varchar(3)
	declare @vComodinTipo varchar(3)
	declare @vComodinCorr varchar(3)
	declare @vPorcentaje varchar(3)

	set @vComodinGrup = '%'
	set @vComodinSegm = '%'
	set @vComodinCorr = '%'
	set @vComodinTipo = '%'
	set @vComodinCorr = '%'
	set @vPorcentaje = '%'
	
	if (@tsPar1 is not null) -- Correlativo de Instancia
	begin
		set @vComodinCorr = ''	
	end
	
	if (@tsPar2 is null) --descripcion
	begin
		set @tsPar2  = ''
	end
	
    if (@tsPar3 is not null) --grupo
	begin
		set @vComodinGrup = ''
	end
	
	if ( @tsPar4 is not null) --Codigo Segmento
	begin
		set @vComodinSegm = ''
	end
	
	if ( @tsPar5 is not null) --Tipo
	begin
		set @vComodinTipo = ''
	end

BEGIN
  IF (@tsTipo = 'S')
  BEGIN
	select 'S'
    SELECT codi_pers, 
           desc_pers, 
           codi_grup, 
           codi_segm, 
           tipo_taxo, 
           pres_burs, 
           emis_bono
  FROM dbax_defi_pers
  WHERE codi_pers = @tsPar1
  AND desc_pers = @tsPar2
 END
 ELSE IF (@tsTipo = 'L')
 BEGIN
--	SET @sql = 'SELECT ROW_NUMBER() OVER( ORDER BY convert(numeric(9,0),v.codi_pers) ASC) AS REG,
--				v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, pres_burs, emis_bono, desc_tipo
--				from	(select distinct dp.codi_pers as codi_pers, dp.desc_pers as desc_pers,
--						isnull(dh.desc_empr,dp.desc_pers) as desc_peho,
--						dg.desc_grup as desc_grup,
--						dp.codi_grup as codi_grup,
--						dp.codi_segm as codi_segm,
--						dp.tipo_taxo as tipo_taxo,
--						dp.pres_burs as pres_burs,
--						dp.emis_bono as emis_bono,
--						dp.empr_vige
--				from	dbax_defi_pers dp 
--					left join dbax_defi_peho dh 
--					on	dh.codi_emex = '''+ @p_codi_emex +''' 
--					and	dh.codi_empr = '''+ CONVERT(varchar(9),@p_codi_empr) +''' 
--					and	dp.codi_pers = dh.codi_pers
--						left join dbax_defi_grup dg
--						on	dg.codi_grup = dp.codi_grup,
--					dbax_inst_docu id
--				where	(dp.codi_pers like ''%'+ isnull(@tsPar2,'')+'%''
--					or dh.desc_empr like  ''%' + isnull(@tsPar2,'')+'%''
--					or dp.desc_pers like ''%'+isnull(@tsPar2,'')+'%'')
--				and		isnull(dp.codi_grup,'''+''+''')like'''+@vComodinGrup+isnull(@tsPar3, '')+@vComodinGrup +'''
--				and		dp.codi_pers = id.codi_pers) v
--					left join dbax_defi_segm ds
--						on v.codi_segm = ds.codi_segm
--					left join dbax_tipo_taxo tt
--						on v.tipo_taxo = tt.tipo_taxo
--					where isnull(v.codi_segm,'''') like '''+@vComodinSegm + isnull(@tsPar4, '') + @vComodinSegm +'''
--					and	isnull(v.tipo_taxo,'''') like '''+@vComodinTipo + isnull(@tspar5, '') + @vComodinTipo   +''' '

	SET @sql = 'SELECT ROW_NUMBER() OVER( ORDER BY v.desc_pers ASC) AS REG,
				v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, pres_burs, emis_bono, desc_tipo, v.empr_vige
				from	(select distinct dp.codi_pers as codi_pers, dp.desc_pers as desc_pers,
						isnull(dh.desc_empr,dp.desc_pers) as desc_peho,
						dg.desc_grup as desc_grup,
						dp.codi_grup as codi_grup,
						dp.codi_segm as codi_segm,
						dp.tipo_taxo as tipo_taxo,
						dp.pres_burs as pres_burs,
						dp.emis_bono as emis_bono,
						dp.empr_vige
				from	dbax_defi_pers dp 
					left join dbax_defi_peho dh 
					on	dh.codi_emex = '''+ @p_codi_emex +''' 
					and	dh.codi_empr = '''+ CONVERT(varchar(9),@p_codi_empr) +''' 
					and	dp.codi_pers = dh.codi_pers
						left join dbax_defi_grup dg
						on	dg.codi_grup = dp.codi_grup
				where	dp.codi_pers like ''%'+ isnull(@tsPar1,'')+'%''
				and		isnull(dp.codi_grup,'''+''+''')like'''+@vComodinGrup+isnull(@tsPar3, '')+@vComodinGrup +''') v
					left join dbax_defi_segm ds
						on v.codi_segm = ds.codi_segm
					left join dbax_tipo_taxo tt
						on v.tipo_taxo = tt.tipo_taxo
					where isnull(v.codi_segm,'''') like '''+@vComodinSegm + isnull(@tsPar4, '') + @vComodinSegm +'''
					and	isnull(v.tipo_taxo,'''') like '''+@vComodinTipo + isnull(@tsPar5, '') + @vComodinTipo   +''' '
   set @sql = @sql + isnull(@tsCondicion,'')
   EXECUTE dbo.prc_list_dyn @sql, @tnPagina, @tnRegPag
 END
END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_dbn_list_colu_read]    Fecha de la secuencia de comandos: 09/23/2013 12:11:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	<Author,,Aaron Rojas>
-- alter date: 2012-10-01
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_dbn_list_colu_read](
	@tsTipo as Varchar(4),	
	@tnPagina as integer,	
	@tnRegPag as integer, 
	@tsCondicion as Varchar(128),
	@tsPar1 as Varchar(256), @tsPar2 as Varchar(256), 
	@tsPar3 as Varchar(256), @tsPar4 as Varchar(256), @tsPar5 as Varchar(256),
	@p_codi_usua varchar(30), @p_codi_empr int, @p_codi_emex varchar(30))
AS
BEGIN
	declare @sql_dyn as integer
	declare @sql as nvarchar(2048)
	/*Obtiene todos las columnas de un reporte*/
	IF(@tsTipo = 'C')
		BEGIN
			SELECT CODI_REPO,		CODI_COLU,
				   NOMB_COLU,		DESC_COLU,
				   CODI_RESX,		CLAS_CSS, 
				   TIPO_COLU,		ANCH_COLU,
				   ALIN_COLU,		FORM_COLU,
				   INDI_VISI,		IMAG_COLU,
				   JQRY_COLU,		ORDE_COLU,
				   TIPO_BUSQ,		INDI_BUSQ,
				   COLU_BUSQ,		VERD_BUSQ,
				   FALS_BUSQ,		CODI_LIVA
				   FROM DBN_LIST_COLU 
				   WHERE CODI_REPO = @tsPar1
				   ORDER BY(ORDE_COLU);
		END
	/*Obtiene todos las */
	ELSE IF(@tsTipo ='L')
		BEGIN
			SET @sql = 	'SELECT	ROW_NUMBER() OVER(ORDER BY CONVERT(NUMERIC(2),ORDE_COLU) ASC) AS REG, 
								   CODI_REPO,		CODI_COLU,
								   NOMB_COLU,		DESC_COLU,
								   CODI_RESX,		CLAS_CSS, 
								   TIPO_COLU,		ANCH_COLU,
								   ALIN_COLU,		FORM_COLU,
								   INDI_VISI,		IMAG_COLU,
								   JQRY_COLU,		ORDE_COLU,
								   INDI_BUSQ,		TIPO_BUSQ,
								   COLU_BUSQ,		VERD_BUSQ,
								   FALS_BUSQ,		CODI_LIVA
								   FROM DBN_LIST_COLU 
								   WHERE CODI_REPO = '''+@tsPar1+''' '

			SET @sql = @sql 

			EXECUTE prc_list_dyn @sql, @tnPagina, @tnRegPag 
		END
	/*Obtiene una columna en espefico, esto es para la mantencion de botones*/
	ELSE IF(@tsTipo = 'M')
		BEGIN
			SELECT CODI_REPO,		CODI_COLU,
				   NOMB_COLU,		DESC_COLU,
				   CODI_RESX,		CLAS_CSS, 
				   TIPO_COLU,		ANCH_COLU,
				   ALIN_COLU,		FORM_COLU,
				   INDI_VISI,		IMAG_COLU,
				   JQRY_COLU,		ORDE_COLU,
				   TIPO_BUSQ,		INDI_BUSQ,
				   COLU_BUSQ,		VERD_BUSQ,
				   FALS_BUSQ,		CODI_LIVA
				   FROM DBN_LIST_COLU 
				   WHERE CODI_REPO = @tsPar1
				   AND CODI_COLU = @tsPar2
				   ORDER BY(CONVERT(NUMERIC(2),ORDE_COLU));
		END
	ELSE IF(@tsTipo = 'V')
		BEGIN
			SELECT COUNT(CODI_COLU) FROM DBN_LIST_COLU WHERE CODI_COLU = @tsPar1;
		END
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_read_dbax_taxo_vers]    Fecha de la secuencia de comandos: 09/23/2013 12:12:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 19-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_read_dbax_taxo_vers] (
 @tsTipo as Varchar(2),
 @tnPagina as integer,
 @tnRegPag as integer,
 @tsCondicion as Varchar(2048),
 @tsPar1 as Varchar(30), @tsPar2 as Varchar(30),
 @tsPar3 as Varchar(30), @tsPar4 as Varchar(30), @tsPar5 as Varchar(30),
 @p_codi_usua varchar(30), @p_codi_empr int, @p_codi_emex varchar(30))
AS 
    /*
     Procedimiento para rescatar datos de la tabla DBAX_TAXO_VERS
     CON EL 
     Parametros
        @tsTipo 
            S: Query utilizada para el mantenedor 
            L: Query utilizada para el listador 
            LV: Query utilizada para las listas de valor 
        @tnPagina	: Numero de pagina a rescatar 
        @tnRegPag	: Numero de registros por pagina
        @tsCondicion : Condicion, clausula Where
        @tsPar1		: Parametro 1 - vers_taxo
        @tsPar2		: Parametro 2 - 
        @tsPar3		: Parametro 3 - 
        @tsPar4		: Parametro 4 - 
        @tsPar5		: Parametro 5 - 
        @p_codi_usua    : Usuario
        @p_codi_empr    : Empresa
        @p_codi_emex    : Emex
     */
     declare @sql_dyn as integer
     declare @sql as nvarchar(4000)
BEGIN
  IF (@tsTipo = 'S')
  BEGIN
    SELECT vers_taxo, 
           ubic_taxo, 
           tipo_taxo
  FROM dbax_taxo_vers
  WHERE vers_taxo = @tsPar1
 END
 ELSE IF (@tsTipo = 'L')
 BEGIN
   SET @sql = 'SELECT ROW_NUMBER() OVER(ORDER BY vers_taxo ASC) AS REG, 
                vers_taxo, ubic_taxo, tipo_taxo
               FROM dbax_taxo_vers
               WHERE 1 = 1 '
 
   SET @sql = @sql + isnull(@tsCondicion,'')
   EXECUTE dbo.prc_list_dyn @sql, @tnPagina, @tnRegPag 
 END
 ELSE IF(@tsTipo = 'LV')
 BEGIN
	declare @Comodin varchar(1)
	select '' as CODIGO, 'Seleccione' as VALOR
	union
	SELECT vers_taxo as CODIGO, vers_taxo as VALOR
	FROM dbax_taxo_vers
	WHERE vers_taxo like '%' + ''+@tsPar1+'' + '%'
 END
END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_read_dbax_tipo_taxo]    Fecha de la secuencia de comandos: 09/23/2013 12:12:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 18-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_read_dbax_tipo_taxo] (
 @tsTipo as Varchar(2),
 @tnPagina as integer,
 @tnRegPag as integer,
 @tsCondicion as Varchar(2048),
 @tsPar1 as Varchar(30), @tsPar2 as Varchar(30),
 @tsPar3 as Varchar(30), @tsPar4 as Varchar(30), @tsPar5 as Varchar(30),
 @p_codi_usua varchar(30), @p_codi_empr int, @p_codi_emex varchar(30))
AS 
    /*
     Procedimiento para rescatar datos de la tabla DBAX_TIPO_TAXO
     CON EL 
     Parametros
        @tsTipo 
            S: Query utilizada para el mantenedor 
            L: Query utilizada para el listador 
            LV: Query utilizada para las listas de valor 
        @tnPagina	: Numero de pagina a rescatar 
        @tnRegPag	: Numero de registros por pagina
        @tsCondicion : Condicion, clausula Where
        @tsPar1		: Parametro 1 - tipo_taxo
        @tsPar2		: Parametro 2 - 
        @tsPar3		: Parametro 3 - 
        @tsPar4		: Parametro 4 - 
        @tsPar5		: Parametro 5 - 
        @p_codi_usua    : Usuario
        @p_codi_empr    : Empresa
        @p_codi_emex    : Emex
     */
     declare @sql_dyn as integer
     declare @sql as nvarchar(4000)
BEGIN
  IF (@tsTipo = 'S')
  BEGIN
    SELECT tipo_taxo, 
           desc_tipo
  FROM dbax_tipo_taxo
  WHERE tipo_taxo = @tsPar1
 END
 ELSE IF (@tsTipo = 'L')
 BEGIN
   SET @sql = 'SELECT ROW_NUMBER() OVER(ORDER BY tipo_taxo ASC) AS REG, 
                tipo_taxo, 
                desc_tipo
               FROM dbax_tipo_taxo
               WHERE tipo_taxo = @p_tipo_taxo
               '
 
   SET @sql = @sql + isnull(@tsCondicion,'')
   EXECUTE dbo.prc_list_dyn @sql, @tnPagina, @tnRegPag 
 END
 ELSE IF(@tsTipo = 'LV')
 BEGIN
	select '' as CODIGO, 'Seleccione' as VALOR, '1'
	union
	select tipo_taxo, desc_tipo, 'n' from dbax_tipo_taxo order by 3, 2
 END
END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_dbn_repo_rous_read]    Fecha de la secuencia de comandos: 09/23/2013 12:11:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26-10-2012
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_dbn_repo_rous_read] (
	@tsTipo as Varchar(4),	
	@tnPagina as integer,	
	@tnRegPag as integer, 
	@tsCondicion as Varchar(128),
	@tsPar1 as Varchar(256), @tsPar2 as Varchar(256), 
	@tsPar3 as Varchar(256), @tsPar4 as Varchar(256), @tsPar5 as Varchar(256),
	@p_codi_usua varchar(30), @p_codi_empr int, @p_codi_emex varchar(30))
AS
BEGIN
	declare @sql_dyn as integer
	declare @sql as nvarchar(2048)
	declare @p_codi_rous varchar(30)
	/*Obtiene los registros segun un codigo de rol*/
	IF(@tsTipo = 'C')
		BEGIN
			SELECT 	   	CODI_REPO,			CODI_MODU,
						CODI_ROUS
			FROM 		DBN_REPO_ROUS
			WHERE 		CODI_REPO = @tsPar1
			ORDER 		BY(CODI_MODU)
		END
	/*Muestra todos los registros de un codigo de reporte*/
	ELSE IF(@tsTipo = 'L')
		BEGIN
			SET @sql = 	'SELECT	ROW_NUMBER() OVER(ORDER BY rr.CODI_MODU ASC) AS REG, 
							rr.CODI_REPO,			rr.CODI_MODU,		rr.CODI_ROUS,
							lr.DESC_REPO,			lr.CATE_LIST
							FROM	DBN_REPO_ROUS rr,
									DBN_LIST_REPO lr
							WHERE	rr.CODI_REPO = lr.codi_repo
							and		rr.CODI_ROUS in (select codi_rous from sys_usro where codi_usua = ''' + @p_codi_usua + ''') 
							and		lr.TIPO_REPO = ''Maestro'''

			SET @sql = @sql 
			EXECUTE prc_list_dyn @sql, @tnPagina, @tnRegPag 
		END
	/*Obtiene un registro en especifico*/
	ELSE IF(@tsTipo = 'M')
		BEGIN
			SELECT 	   CODI_REPO,			CODI_MODU,
					   CODI_ROUS
					   FROM DBN_REPO_ROUS
					   WHERE CODI_REPO = @tsPar1
					   AND CODI_MODU = @tsPar2
					   ORDER BY(CODI_MODU)
		END
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_read_dbax_info_conc]    Fecha de la secuencia de comandos: 09/23/2013 12:12:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 19-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER procedure [dbo].[prc_read_dbax_info_conc] (
 @tsTipo as Varchar(2),
 @tnPagina as integer,
 @tnRegPag as integer,
 @tsCondicion as Varchar(2048),
 @tsPar1 as Varchar(30), @tsPar2 as Varchar(30),
 @tsPar3 as Varchar(30), @tsPar4 as Varchar(30), @tsPar5 as Varchar(30),
 @p_codi_usua varchar(30), @p_codi_empr int, @p_codi_emex varchar(30))
AS 
    /*
     Procedimiento para rescatar datos de la tabla DBAX_INFO_CONC
     CON EL 
     Parametros
        @tsTipo 
            S: Query utilizada para el mantenedor 
            L: Query utilizada para el listador 
            LV: Query utilizada para las listas de valor 
        @tnPagina	: Numero de pagina a rescatar 
        @tnRegPag	: Numero de registros por pagina
        @tsCondicion : Condicion, clausula Where
        @tsPar1		: Parametro 1 - codi_info
        @tsPar2		: Parametro 2 - pref_conc
        @tsPar3		: Parametro 3 - codi_conc
        @tsPar4		: Parametro 4 - orde_conc
        @tsPar5		: Parametro 5 - 
        @p_codi_usua    : Usuario
        @p_codi_empr    : Empresa
        @p_codi_emex    : Emex
     */
     declare @sql_dyn as integer
     declare @sql as nvarchar(4000)
BEGIN
  IF (@tsTipo = 'S')
  BEGIN
    SELECT codi_empr, 
           codi_emex, 
           codi_info, 
           pref_conc, 
           codi_conc, 
           orde_conc, 
           codi_conc1, 
           nive_conc, 
           negr_conc
  FROM dbax_info_conc
  WHERE codi_empr = @p_codi_empr
  AND   codi_emex = @p_codi_emex
  AND   codi_info = @tsPar1
  AND   pref_conc = @tsPar2
  AND   codi_conc = @tsPar3
  AND   orde_conc = @tsPar4
 END
 ELSE IF (@tsTipo = 'L')
 BEGIN
   SET @sql = 'SELECT ROW_NUMBER() OVER(ORDER BY codi_info ASC) AS REG, 
                codi_empr, codi_emex, codi_info, 
                pref_conc, codi_conc, orde_conc, 
                codi_conc1, nive_conc, negr_conc
               FROM dbax_info_conc
               WHERE codi_empr = ' + @p_codi_empr + '
               AND   codi_emex = ''' + str(@p_codi_emex) + '''
               '
 
   SET @sql = @sql + isnull(@tsCondicion,'')
   EXECUTE dbo.prc_list_dyn @sql, @tnPagina, @tnRegPag 
 END
 ELSE IF(@tsTipo = 'LV')
 BEGIN
	SELECT distinct codi_conc as CODIGO, codi_conc + ' - ' + pref_conc as VALOR
	FROM dbax_info_conc
	ORDER BY codi_conc ASC;
 END
END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_read_dbne_defi_lang]    Fecha de la secuencia de comandos: 09/23/2013 12:12:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas	
-- alter date: 10-04-2013
-- Description:	
-- =============================================
ALTER  procedure [dbo].[prc_read_dbne_defi_lang] (
 @tsTipo as Varchar(2),
 @tnPagina as integer,
 @tnRegPag as integer,
 @tsCondicion as Varchar(2048),
 @tsPar1 as Varchar(30), @tsPar2 as Varchar(30),
 @tsPar3 as Varchar(30), @tsPar4 as Varchar(30), @tsPar5 as Varchar(30),
 @p_codi_usua varchar(30), @p_codi_empr int, @p_codi_emex varchar(30))
AS 
    /*
     Procedimiento para rescatar datos de la tabla DBNE_DEFI_LANG
     CON EL 
     Parametros
        @tsTipo 
            S: Query utilizada para el mantenedor 
            L: Query utilizada para el listador 
            LV: Query utilizada para las listas de valor 
        @tnPagina	: Numero de pagina a rescatar 
        @tnRegPag	: Numero de registros por pagina
        @tsCondicion : Condicion, clausula Where
        @tsPar1		: Parametro 1 - codi_lang
        @tsPar2		: Parametro 2 - 
        @tsPar3		: Parametro 3 - 
        @tsPar4		: Parametro 4 - 
        @tsPar5		: Parametro 5 - 
        @p_codi_usua    : Usuario
        @p_codi_empr    : Empresa
        @p_codi_emex    : Emex
     */
     declare @sql_dyn as integer
     declare @sql as nvarchar(4000)
BEGIN
  IF (@tsTipo = 'S')
  BEGIN
    SELECT codi_lang, 
           desc_lang
  FROM dbne_defi_lang
  WHERE codi_lang = @tsPar1
 END
 ELSE IF (@tsTipo = 'L')
 BEGIN
   SET @sql = 'SELECT ROW_NUMBER() OVER(ORDER BY codi_lang ASC) AS REG, 
                codi_lang, 
                desc_lang
               FROM dbne_defi_lang
               WHERE 1 = 1 '
 
   SET @sql = @sql + isnull(@tsCondicion,'')
   EXECUTE dbo.prc_list_dyn @sql, @tnPagina, @tnRegPag 
 END
 ELSE IF(@tsTipo = 'LV')
 BEGIN
	SELECT codi_lang as CODIGO,
			desc_lang as VALOR
	from dbne_defi_lang
	ORDER BY codi_lang ASC;
 END
END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_mant_list_read]    Fecha de la secuencia de comandos: 09/23/2013 12:12:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_mant_list_read]  (
	@tsTipo as Varchar(4),	
	@tnPagina as integer,	
	@tnRegPag as integer, 
	@tsCondicion as Varchar(128),
	@tsPar1 as Varchar(30), @tsPar2 as Varchar(30), 
	@tsPar3 as Varchar(30), @tsPar4 as Varchar(30), @tsPar5 as Varchar(30),
	@p_codi_usua varchar(30), @p_codi_empr int, @p_codi_emex varchar(30))
AS 
	/*
	 Procedimiento para rescatar datos de la tabla SYS_PARAM 
	 con los Parametros
		@tsTipo 
			S: Query utilizada para el mantenedor
			L: Query utilizada para el listador
			LV: Query utilizada para las listas de valor
		@tnPagina	: Numero de pagina a rescatar
		@tnRegPag	: Numero de registros por pagina
		@tsCondicion : Condicion, clausula Where
		@tsPar1		: Parametro 1 - PARAM_NAME
		@tsPar2		: Parametro 2
		@tsPar3		: Parametro 3
		@tsPar4		: Parametro 4
		@tsPar5		: Parametro 5
	 */
	declare @sql_dyn as integer
	declare @sql as nvarchar(2048)
BEGIN
	IF (@tsTipo = 'L')
	BEGIN
		SET @sql = 	'	SELECT	ROW_NUMBER() OVER(ORDER BY CODI_REPO ASC) AS REG, 
						LR.CODI_REPO		,LR.TITU_REPO		,LR.CODI_MODU		,LR.SCRP_SQLS,
						LR.DESC_REPO		,LR.CODI_RESX		,LR.PROC_REPO		,LR.SCRP_SQLO,
						LR.FILT_CKBB		,LR.PAGE_REPO		,LR.MODO			,syc.code_desc as CATE_LIST
						FROM DBN_LIST_REPO LR left join sys_code syc on LR.cate_list = syc.code
						WHERE 1 = 1 '

		SET @sql = @sql + isnull(@tsCondicion,'')

		EXECUTE prc_list_dyn @sql, @tnPagina, @tnRegPag 
	END
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_read_dbax_desc_conc]    Fecha de la secuencia de comandos: 09/23/2013 12:12:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 09-04-2013
-- Description:	
-- =============================================
ALTER  procedure [dbo].[prc_read_dbax_desc_conc] (
 @tsTipo as Varchar(2),
 @tnPagina as integer,
 @tnRegPag as integer,
 @tsCondicion as Varchar(2048),
 @tsPar1 as Varchar(256), @tsPar2 as Varchar(256),
 @tsPar3 as Varchar(256), @tsPar4 as Varchar(256), @tsPar5 as Varchar(256),
 @p_codi_usua varchar(30), @p_codi_empr int, @p_codi_emex varchar(30))
AS 
    /*
     Procedimiento para rescatar datos de la tabla DBAX_DESC_CONC
     CON EL 
     Parametros
        @tsTipo 
            S: Query utilizada para el mantenedor 
            L: Query utilizada para el listador 
            LV: Query utilizada para las listas de valor 
        @tnPagina	: Numero de pagina a rescatar 
        @tnRegPag	: Numero de registros por pagina
        @tsCondicion : Condicion, clausula Where
        @tsPar1		: Parametro 1 - codi_conc
        @tsPar2		: Parametro 2 - pref_conc
        @tsPar3		: Parametro 3 - 
        @tsPar4		: Parametro 4 - 
        @tsPar5		: Parametro 5 - 
        @p_codi_usua    : Usuario
        @p_codi_empr    : Empresa
        @p_codi_emex    : Emex
     */
     declare @sql_dyn as integer
     declare @sql as nvarchar(4000)
BEGIN
  IF (@tsTipo = 'S')
  BEGIN
    SELECT pref_conc, 
           codi_conc, 
           codi_lang, 
           desc_conc
  FROM dbax_desc_conc
  WHERE codi_conc = @tsPar1
  AND   pref_conc = @tsPar2
  AND	codi_lang = @tsPar3
 END
 ELSE IF (@tsTipo = 'L')
 BEGIN
   SET @sql = 'SELECT ROW_NUMBER() OVER(ORDER BY codi_conc ASC) AS REG, 
                pref_conc, codi_conc, codi_lang, desc_conc
               FROM dbax_desc_conc
               WHERE pref_conc = '''+CONVERT(varchar(256),@tsPar2)+''' 
			   and	 codi_conc = '''+CONVERT(varchar(256),@tsPar1)+'''
			   and   codi_lang = '''+convert(varchar(256),@tsPar3)+''' '
 
   SET @sql = @sql + isnull(@tsCondicion,'')
   EXECUTE dbo.prc_list_dyn @sql, @tnPagina, @tnRegPag 
 END
END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_dbn_list_boto_read]    Fecha de la secuencia de comandos: 09/23/2013 12:11:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_dbn_list_boto_read](
	@tsTipo as Varchar(4),	
	@tnPagina as integer,	
	@tnRegPag as integer, 
	@tsCondicion as Varchar(128),
	@tsPar1 as Varchar(256), @tsPar2 as Varchar(256), 
	@tsPar3 as Varchar(256), @tsPar4 as Varchar(256), @tsPar5 as Varchar(256),
	@p_codi_usua varchar(30), @p_codi_empr int, @p_codi_emex varchar(30))
AS
/*
     Procedimiento para rescatar datos de la tabla USUA_EMPR
     CON EL 
     Parametros
        @tsTipo 
            C1: Parametro utilizado para cargar los botones en las grillas, segun el modo se le pase a la grilla
            C: Parametro Utilizado para mostrar los botones en la pagina de mantencion  del listador
            L: Query utilizada para el listador 
            M: Parametro Utilizado en la mantención del boton
        @tnPagina	: Numero de pagina a rescatar 
        @tnRegPag	: Numero de registros por pagina
        @tsCondicion : Condicion, clausula Where
        @tsPar1		: Parametro 1 - CODI_REPO
        @tsPar2		: Parametro 2 - CODI_BOTO
        @tsPar3		: Parametro 3 - MODO_BOTO
        @tsPar4		: Parametro 4 - 
        @tsPar5		: Parametro 5 - 
        @p_codi_usua    : Usuario
        @p_codi_empr    : Empresa
        @p_codi_emex    : Emex
     */

BEGIN
	declare @sql_dyn as integer
	declare @sql as nvarchar(2048)
	/*Este es para obtener los botones segun el modo al cual ingresan a listador*/
	IF(@tsTipo = 'C1')
		BEGIN
			SELECT 		CODI_REPO,			CODI_BOTO,				NOMB_BOTO,			DESC_BOTO,
						TIPO_BOTO,			CODI_RESX,				CLAS_CSS,			PAGE_BOTO,
						PROC_BOTO,			CODI_PAR1,				CODI_PAR2,			CODI_PAR3,			
						CODI_PAR4,			CODI_PAR5,				IMAG_BOTO,			ORDE_BOTO,
						INDI_VISI,			MODO_BOTO,				LIST_DETA
						FROM DBN_LIST_BOTO
						WHERE CODI_REPO = @tsPar1
						AND MODO_BOTO LIKE '%(' + @tsPar3 + ')%'
						ORDER BY(CONVERT(NUMERIC(2),ORDE_BOTO))
		END
	/*Es para obtener todos los botones de un reporte especifico*/
	ELSE IF(@tsTipo = 'C')
		BEGIN
			SELECT 		CODI_REPO,			CODI_BOTO,				NOMB_BOTO,			DESC_BOTO,
						TIPO_BOTO,			CODI_RESX,				CLAS_CSS,			PAGE_BOTO,
						PROC_BOTO,			CODI_PAR1,				CODI_PAR2,			CODI_PAR3,			
						CODI_PAR4,			CODI_PAR5,				IMAG_BOTO,			ORDE_BOTO,
						INDI_VISI,			MODO_BOTO,				LIST_DETA
						FROM DBN_LIST_BOTO
						WHERE CODI_REPO = @tsPar1
						ORDER BY ORDE_BOTO
		END
	/*Es para obtener el listador de un Reporte especifico*/
	ELSE IF(@tsTipo = 'L')
		BEGIN
			SET @sql = 	'SELECT	ROW_NUMBER() OVER(ORDER BY CONVERT(NUMERIC(2),ORDE_BOTO) ASC) AS REG, 
							CODI_REPO,			CODI_BOTO,				NOMB_BOTO,			DESC_BOTO,
							TIPO_BOTO,			CODI_RESX,				CLAS_CSS,			PAGE_BOTO,
							PROC_BOTO,			CODI_PAR1,				CODI_PAR2,			CODI_PAR3,			
							CODI_PAR4,			CODI_PAR5,				IMAG_BOTO,			ORDE_BOTO,
							INDI_VISI,			MODO_BOTO,				LIST_DETA
							FROM DBN_LIST_BOTO 
							WHERE CODI_REPO = '''+@tsPar1+''' '

			SET @sql = @sql 
			EXECUTE prc_list_dyn @sql, @tnPagina, @tnRegPag 
		END
	/*Es para obtener un boton en especifico*/
	ELSE IF(@tsTipo = 'M')
		BEGIN
			SELECT 	   CODI_REPO,			CODI_BOTO,			NOMB_BOTO,			DESC_BOTO,
					   TIPO_BOTO,			CODI_RESX,			CLAS_CSS,			PAGE_BOTO,
					   PROC_BOTO,			CODI_PAR1,			CODI_PAR2,			CODI_PAR3,			
					   CODI_PAR4,			CODI_PAR5,			IMAG_BOTO,			ORDE_BOTO,
					   INDI_VISI,			MODO_BOTO,			LIST_DETA
					   FROM DBN_LIST_BOTO
					   WHERE CODI_REPO = @tsPar1
					   AND	 CODI_BOTO = @tsPar2
					   ORDER BY ORDE_BOTO
		END
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_read_dbax_tipo_conc]    Fecha de la secuencia de comandos: 09/23/2013 12:12:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 08/04/2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_read_dbax_tipo_conc] (
 @tsTipo as Varchar(2),
 @tnPagina as integer,
 @tnRegPag as integer,
 @tsCondicion as Varchar(2048),
 @tsPar1 as Varchar(30), @tsPar2 as Varchar(30),
 @tsPar3 as Varchar(30), @tsPar4 as Varchar(30), @tsPar5 as Varchar(30),
 @p_codi_usua varchar(30), @p_codi_empr int, @p_codi_emex varchar(30))
AS 
    /*
     Procedimiento para rescatar datos de la tabla DBAX_TIPO_CONC
     CON EL 
     Parametros
        @tsTipo 
            S: Query utilizada para el mantenedor 
            L: Query utilizada para el listador 
            LV: Query utilizada para las listas de valor 
        @tnPagina	: Numero de pagina a rescatar 
        @tnRegPag	: Numero de registros por pagina
        @tsCondicion : Condicion, clausula Where
        @tsPar1		: Parametro 1 - tipo_conc
        @tsPar2		: Parametro 2 - 
        @tsPar3		: Parametro 3 - 
        @tsPar4		: Parametro 4 - 
        @tsPar5		: Parametro 5 - 
        @p_codi_usua    : Usuario
        @p_codi_empr    : Empresa
        @p_codi_emex    : Emex
     */
     declare @sql_dyn as integer
     declare @sql as nvarchar(4000)
BEGIN
  IF (@tsTipo = 'S')
  BEGIN
    SELECT tipo_conc, 
           desc_conc, 
           tipo_elem
  FROM dbax_tipo_conc
  WHERE tipo_conc = @tsPar1
 END
 ELSE IF (@tsTipo = 'L')
 BEGIN
   SET @sql = 'SELECT ROW_NUMBER() OVER(ORDER BY tipo_conc ASC) AS REG, 
                tipo_conc, desc_conc, tipo_elem, 
               FROM dbax_tipo_conc
               WHERE 1 = 1 '
 
   SET @sql = @sql + isnull(@tsCondicion,'')
   EXECUTE dbo.prc_list_dyn @sql, @tnPagina, @tnRegPag 
 END
 ELSE IF(@tsTipo = 'LV')
 BEGIN
	SELECT	tipo_conc as CODIGO,
			desc_conc as VALOR
	FROM dbax_tipo_conc
	ORDER BY tipo_conc ASC;
 END
END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_read_dbax_defi_conc]    Fecha de la secuencia de comandos: 09/23/2013 12:12:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 08-04-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_read_dbax_defi_conc] (
 @tsTipo as Varchar(2),
 @tnPagina as integer,
 @tnRegPag as integer,
 @tsCondicion as Varchar(2048),
 @tsPar1 as Varchar(256), @tsPar2 as Varchar(256),
 @tsPar3 as Varchar(256), @tsPar4 as Varchar(256), @tsPar5 as Varchar(256),
 @p_codi_usua varchar(30), @p_codi_empr int, @p_codi_emex varchar(30))
AS 
    /*
     Procedimiento para rescatar datos de la tabla DBAX_DEFI_CONC
     CON EL 
     Parametros
        @tsTipo 
            S: Query utilizada para el mantenedor 
            L: Query utilizada para el listador 
            LV: Query utilizada para las listas de valor 
        @tnPagina	: Numero de pagina a rescatar 
        @tnRegPag	: Numero de registros por pagina
        @tsCondicion : Se Ocupa para el codi_conc
        @tsPar1		: Parametro 1 - 
        @tsPar2		: Parametro 2 - pref_conc
        @tsPar3		: Parametro 3 - 
        @tsPar4		: Parametro 4 - 
        @tsPar5		: Parametro 5 - 
        @p_codi_usua    : Usuario
        @p_codi_empr    : Empresa
        @p_codi_emex    : Emex
     */
     declare @sql_dyn as integer
     declare @sql as nvarchar(4000)
BEGIN
  IF (@tsTipo = 'S')
  BEGIN
    SELECT pref_conc, 
           codi_conc, 
           tipo_conc, 
           tipo_peri, 
           tipo_valo, 
           tipo_cuen, 
           codi_nume, 
           tipo_taxo
  FROM dbax_defi_conc
  WHERE codi_conc = @tsCondicion
  AND   pref_conc = @tsPar2
  select @tsPar1
 END
 ELSE IF (@tsTipo = 'L')
 BEGIN
   SET @sql = 'SELECT ROW_NUMBER() OVER(ORDER BY decn.codi_conc ASC) AS REG, 
                decn.pref_conc as pref_conc, decn.codi_conc as codi_conc, decn.tipo_conc as tipo_conc, 
                decn.tipo_peri, decn.tipo_valo, decn.tipo_cuen, 
                decn.codi_nume, decn.tipo_taxo, dsc.codi_lang
               FROM dbax_defi_conc decn,
					dbax_desc_conc dsc
               WHERE decn.codi_conc = dsc.codi_conc '
 
   SET @sql = @sql + isnull(@tsCondicion,'')
   EXECUTE dbo.prc_list_dyn @sql, @tnPagina, @tnRegPag 
 END
 ELSE IF(@tsTipo = 'LV')
 BEGIN
		SELECT pref_conc as VALOR,
				codi_conc as CODIGO
		FROM dbax_defi_conc
		ORDER BY codi_conc ASC;
	
 END
END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_personas_read]    Fecha de la secuencia de comandos: 09/23/2013 12:12:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_personas_read] (
 @tsTipo as VARCHAR(3),
 @tnPagina as INTEGER,
 @tnRegPag as INTEGER,
 @tsCondicion as VARCHAR(2048),
 @tsPar1 as VARCHAR(256), @tsPar2 as VARCHAR(256),
 @tsPar3 as VARCHAR(256), @tsPar4 as VARCHAR(256), @tsPar5 as VARCHAR(256),
 @p_codi_usua VARCHAR(30), @p_codi_empr INTEGER, @p_codi_emex VARCHAR(30))
AS 
    /*
     Procedimiento para rescatar datos de la tabla PERSONAS
     CON EL 
     Parametros
        @tsTipo 
            S: Query utilizada para el mantenedor 
            L: Query utilizada para el listador 
            LV: Query utilizada para las listas de valor 
        @tnPagina	: Numero de pagina a rescatar 
        @tnRegPag	: Numero de registros por pagina
        @tsCondicion : Condicion, clausula Where
        @tsPar1		: Parametro 1 - codi_pers
        @tsPar2		: Parametro 2 - 
        @tsPar3		: Parametro 3 - 
        @tsPar4		: Parametro 4 - 
        @tsPar5		: Parametro 5 - 
        @p_codi_usua    : Usuario
        @p_codi_empr    : Empresa
        @p_codi_emex    : Emex
     */
     declare @sql_dyn as INTEGER
     declare @sql as nVARCHAR(4000)
BEGIN
  IF (@tsTipo = 'S')
  BEGIN
    SELECT 	codi_emex, 			codi_pers, 			nomb_pers, 			rutt_pers, 
            dgto_pers, 			dire_pers, 			codi_comu, 			fono_pers, 
            clie_pers, 			prov_pers, 			comp_pers, 			empl_pers, 
            codi_pers1, 		pers_sele, 			empr_pers, 			pref_pers, 
            func_pers, 			codi_ramo, 			fech_pers, 			come_pers, 
            codi_pais, 			codi_ceco, 			codi_mail, 			nfan_pers, 
            codi_eciv, 			codi_prof, 			sexo_pers, 			orig_pers, 
            acci_pers, 			tipo_desc, 			codi_mail1, 		codi_mail2, 
            codi_mail3, 		codi_mail4, 		auto_cesi, 			asun_fact_pers, 
            text_fact_pers, 	modi_docu, 			codi_ofic,			codi_empr
  FROM personas
  WHERE codi_emex = @p_codi_emex
  and	codi_empr = @p_codi_empr
  AND   codi_pers = @tsPar1
 END
 ELSE IF (@tsTipo = 'L')
 BEGIN
   SET @sql = 'SELECT ROW_NUMBER() OVER(ORDER BY codi_pers ASC) AS REG, 
                codi_emex, 			codi_pers, 			nomb_pers, 			rutt_pers, 
				dgto_pers, 			dire_pers, 			codi_comu, 			fono_pers, 
				clie_pers, 			prov_pers, 			comp_pers, 			empl_pers, 
				codi_pers1, 		pers_sele, 			empr_pers, 			pref_pers, 
				func_pers, 			codi_ramo, 			fech_pers, 			come_pers, 
				codi_pais, 			codi_ceco, 			codi_mail, 			nfan_pers, 
				codi_eciv, 			codi_prof, 			sexo_pers, 			orig_pers, 
				acci_pers, 			tipo_desc, 			codi_mail1, 		codi_mail2, 
				codi_mail3, 		codi_mail4, 		auto_cesi, 			asun_fact_pers, 
				text_fact_pers, 	modi_docu, 			codi_ofic,			codi_empr
               FROM personas
               WHERE	codi_emex = ''' + @p_codi_emex + '''
               and		codi_empr = '''+convert(VARCHAR,@p_codi_empr)+''' '
 
   SET @sql = @sql + isnull(@tsCondicion,'')
   EXECUTE prc_list_dyn @sql, @tnPagina, @tnRegPag 
 END
	ELSE IF (@tsTipo = 'LV')
		BEGIN
			 SELECT CODI_PERS AS CODIGO, 
				NOMB_PERS AS VALOR
			 FROM	PERSONAS
			 WHERE EMPL_PERS = 'S'
			 and	codi_emex = @p_codi_emex
			 and	codi_empr = @p_codi_empr
			 ORDER BY NOMB_PERS
		END
END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_empr_read]    Fecha de la secuencia de comandos: 09/23/2013 12:11:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	<Author,,Aaron Rojas>
-- alter date: <alter Date,,2012-10-01>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_empr_read]  (
	@tsTipo as VARCHAR(4),	
	@tnPagina as INTEGER,	
	@tnRegPag as INTEGER, 
	@tsCondicion as VARCHAR(2048),
	@tsPar1 as VARCHAR(256), @tsPar2 as VARCHAR(256), 
	@tsPar3 as VARCHAR(256), @tsPar4 as VARCHAR(256), @tsPar5 as VARCHAR(256),
	@p_codi_usua VARCHAR(30), @p_codi_empr INTEGER, @p_codi_emex VARCHAR(30))
AS 
	/*
	 Procedimiento para rescatar datos de la tabla SYS_PARAM
     CON EL 
	 Parametros
		@tsTipo 
			S: Query utilizada para el mantenedor
			L: Query utilizada para el listador
			LV: Query utilizada para las listas de valor
		@tnPagina	: Numero de pagina a rescatar
		@tnRegPag	: Numero de registros por pagina
		@tsCondicion : Condicion, clausula Where
		@tsPar1		: Parametro 1 - PARAM_NAME
		@tsPar2		: Parametro 2
		@tsPar3		: Parametro 3
		@tsPar4		: Parametro 4
		@tsPar5		: Parametro 5
	 */
	declare @sql_dyn as INTEGER
	declare @sql as nVARCHAR(2048)
BEGIN
	IF (@tsTipo = 'S')
		BEGIN
			 SELECT		codi_empr		,nomb_empr,
						giro_empr		,dire_empr,
						codi_comu		,codi_ciud,
						rutt_empr		,digi_empr,
						codi_ramo		,nfan_empr,
						codi_pers		,empr_codg,
						empr_nomb		,fono_empr,
						rutt_repl		,dgto_repl,
						nomb_repl		,caca_empr,
						mutu_empr		,pomu_empr,
						poca_empr		,feca_empr,
						femu_empr		,cine_empr,
						cuen_empr		,caja_empr,
						color_empr		,logo_empr,
						clav_encr		,ASUN_FACT_EMPR,
						TEXT_FACT_EMPR	,codi_emex
			 FROM  EMPR
			 WHERE CODI_EMPR = @tsPar1
			 and	codi_emex = @p_codi_emex
		END
	ELSE IF (@tsTipo = 'L')
		BEGIN
			SET @sql = 	'SELECT	ROW_NUMBER() OVER(ORDER BY codi_empr ASC) AS REG, 
						codi_empr		,nomb_empr,
						dire_empr		,codi_comu,		
						codi_ciud		,dgto_repl,
						rutt_empr		,digi_empr,
						codi_ramo		,nfan_empr,
						codi_pers		,empr_codg,
						empr_nomb		,fono_empr,
						nomb_repl		,caca_empr,
						mutu_empr		,pomu_empr,
						poca_empr		,feca_empr,
						femu_empr		,cine_empr,
						cuen_empr		,caja_empr,
						color_empr		,logo_empr
						FROM EMPR 
						WHERE codi_emex = '''+@p_codi_emex+''' '

			SET @sql = @sql + isnull(@tsCondicion,'')

			EXECUTE prc_list_dyn @sql, @tnPagina, @tnRegPag 
		END
	ELSE IF (@tsTipo = 'LV')
		BEGIN
			 SELECT	CODI_EMPR AS CODIGO, 
					NOMB_EMPR AS VALOR
			 FROM	EMPR
			 where codi_emex = @p_codi_emex
			 ORDER BY NOMB_EMPR
		END
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_empr_exte_read]    Fecha de la secuencia de comandos: 09/23/2013 12:11:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_empr_exte_read] (
 @tsTipo as VARCHAR(4),
 @tnPagina as INTEGER,
 @tnRegPag as INTEGER,
 @tsCondicion as VARCHAR(2048),
 @tsPar1 as VARCHAR(256), @tsPar2 as VARCHAR(256),
 @tsPar3 as VARCHAR(256), @tsPar4 as VARCHAR(256), @tsPar5 as VARCHAR(256),
 @p_codi_usua VARCHAR(30), @p_codi_empr INTEGER, @p_codi_emex VARCHAR(30))
AS 
    /*
     Procedimiento para rescatar datos de la tabla EMPR_EXTE
     CON EL 
     Parametros
        @tsTipo 
            S: Query utilizada para el mantenedor 
            L: Query utilizada para el listador 
            LV: Query utilizada para las listas de valor 
        @tnPagina	: Numero de pagina a rescatar 
        @tnRegPag	: Numero de registros por pagina
        @tsCondicion : Condicion, clausula Where
        @tsPar1		: Parametro 1 - codi_emex
        @tsPar2		: Parametro 2 - 
        @tsPar3		: Parametro 3 - 
        @tsPar4		: Parametro 4 - 
        @tsPar5		: Parametro 5 - 
        @p_codi_usua    : Usuario
        @p_codi_empr    : Empresa
        @p_codi_emex    : Emex
     */
     declare @sql_dyn as INTEGER
     declare @sql as nVARCHAR(4000)
BEGIN
  IF (@tsTipo = 'S')
  BEGIN
    SELECT codi_emex,		nomb_emex,		stat_emex,		fein_emex, 
           fete_emex,		owne_emex,		pass_emex,		path_emex,
           head_emex,		side_emex,		back_emex,		spla_emex,
           logo_emex,		sweb_emex,		bann_emex,		urba_emex,
           gint_emex,		intr_emex,		codi_empr,		pagi_inic,
           stri_conn,		habi_siti,		colo_emex,		come_emex,
           form_emex,		serv_sweb,		ipws_emex,		ptws_emex,
           usua_dbss,		usua_web,		pass_usua_web,	usua_eul,
           pass_usua_eul,	repo_emex
  FROM empr_exte
  WHERE codi_emex = @tsPar1
 END
 ELSE IF (@tsTipo = 'L')
 BEGIN
   SET @sql = 'SELECT ROW_NUMBER() OVER(ORDER BY codi_emex ASC) AS REG, 
               codi_emex,		nomb_emex,		stat_emex,		fein_emex, 
			   fete_emex,		owne_emex,		pass_emex,		path_emex,
			   head_emex,		side_emex,		back_emex,		spla_emex,
			   logo_emex,		sweb_emex,		bann_emex,		urba_emex,
			   gint_emex,		intr_emex,		codi_empr,		pagi_inic,
			   stri_conn,		habi_siti,		colo_emex,		come_emex,
			   form_emex,		serv_sweb,		ipws_emex,		ptws_emex,
			   usua_dbss,		usua_web,		pass_usua_web,	usua_eul,
			   pass_usua_eul,	repo_emex
               FROM empr_exte
               WHERE 1 = 1 '
 
   SET @sql = @sql + isnull(@tsCondicion,'')
   EXECUTE prc_list_dyn @sql, @tnPagina, @tnRegPag 
 END
 ELSE IF(@tsTipo = 'LV')
 BEGIN
	SELECT '' as CODIGO,
			'Seleccione' as VALOR
	union
	SELECT codi_emex as CODIGO, 
			nomb_emex as VALOR
	FROM empr_exte;
 END
END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_ofic_empr_read]    Fecha de la secuencia de comandos: 09/23/2013 12:12:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 28-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_ofic_empr_read] (
 @tsTipo as VARCHAR(3),
 @tnPagina as INTEGER,
 @tnRegPag as INTEGER,
 @tsCondicion as VARCHAR(2048),
 @tsPar1 as VARCHAR(256), @tsPar2 as VARCHAR(256),
 @tsPar3 as VARCHAR(256), @tsPar4 as VARCHAR(256), @tsPar5 as VARCHAR(256),
 @p_codi_usua VARCHAR(30), @p_codi_empr INTEGER, @p_codi_emex VARCHAR(30))
AS 
    /*
     Procedimiento para rescatar datos de la tabla OFIC_EMPR
     CON EL 
     Parametros
        @tsTipo 
            S: Query utilizada para el mantenedor 
            L: Query utilizada para el listador 
            LV: Query utilizada para las listas de valor 
        @tnPagina	: Numero de pagina a rescatar 
        @tnRegPag	: Numero de registros por pagina
        @tsCondicion : Condicion, clausula Where
        @tsPar1		: Parametro 1 - codi_ofic
        @tsPar2		: Parametro 2 - 
        @tsPar3		: Parametro 3 - 
        @tsPar4		: Parametro 4 - 
        @tsPar5		: Parametro 5 - 
        @p_codi_usua    : Usuario
        @p_codi_empr    : Empresa
        @p_codi_emex    : Emex
     */
     declare @sql_dyn as INTEGER
     declare @sql as nVARCHAR(4000)
BEGIN
  IF (@tsTipo = 'S')
  BEGIN
    SELECT codi_emex, 
           codi_empr, 
           codi_ofic, 
           desc_ofic, 
           codi_ceco, 
           codi_sii, 
           dire_ofic, 
           codi_ciud, 
           codi_comu, 
           codi_pais, 
           fono_ofic, 
           faxx_ofic, 
           telx_ofic
  FROM ofic_empr
  WHERE codi_emex = @p_codi_emex
  AND   codi_empr = @p_codi_empr
  AND   codi_ofic = @tsPar1
 END
 ELSE IF (@tsTipo = 'L')
 BEGIN
   SET @sql = 'SELECT ROW_NUMBER() OVER(ORDER BY codi_ofic ASC) AS REG, 
                codi_emex, codi_empr, codi_ofic, 
                desc_ofic, codi_ceco, codi_sii, 
                dire_ofic, codi_ciud, codi_comu, 
                codi_pais, fono_ofic, faxx_ofic, 
                telx_ofic
               FROM ofic_empr
               WHERE codi_emex = ''' + @p_codi_emex + '''
               AND   codi_empr = '''+ convert(VARCHAR,@p_codi_empr) +''' '
   SET @sql = @sql + isnull(@tsCondicion,'')
   EXECUTE prc_list_dyn @sql, @tnPagina, @tnRegPag 
 END
	ELSE IF (@tsTipo = 'LV')
	BEGIN
			 SELECT codi_ofic AS CODIGO, 
				      desc_ofic AS VALOR
			 FROM	 ofic_empr
       WHERE codi_emex = @p_codi_emex
       AND   codi_empr = @p_codi_empr
			 ORDER BY codi_ofic
	END
END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_para_empr_read]    Fecha de la secuencia de comandos: 09/23/2013 12:12:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_para_empr_read] (
 @tsTipo as VARCHAR(4),
 @tnPagina as INTEGER,
 @tnRegPag as INTEGER,
 @tsCondicion as VARCHAR(256),
 @tsPar1 as VARCHAR(256), @tsPar2 as VARCHAR(256),
 @tsPar3 as VARCHAR(256), @tsPar4 as VARCHAR(256), @tsPar5 as VARCHAR(256),
 @p_codi_usua VARCHAR(30), @p_codi_empr INTEGER, @p_codi_emex VARCHAR(30))
AS 
    /*
     Procedimiento para rescatar datos de la tabla PARA_EMPR
     CON EL 
     Parametros
        @tsTipo 
            S: Query utilizada para el mantenedor 
            L: Query utilizada para el listador 
            LV: Query utilizada para las listas de valor 
        @tnPagina	: Numero de pagina a rescatar 
        @tnRegPag	: Numero de registros por pagina
        @tsCondicion : Condicion, clausula Where
        @tsPar1		: Parametro 1 - tipo_como
        @tsPar2		: Parametro 2 - codi_paem
        @tsPar3		: Parametro 3 - 
        @tsPar4		: Parametro 4 - 
        @tsPar5		: Parametro 5 - 
        @p_codi_usua    : Usuario
        @p_codi_empr    : Empresa
        @p_codi_emex    : Emex
     */
     declare @sql_dyn as INTEGER
     declare @sql as nVARCHAR(2048)
BEGIN
  IF (@tsTipo = 'S')
  BEGIN
    SELECT codi_empr, 
           codi_paem, 
           tipo_como, 
           desc_paem, 
           valo_paem, 
           obli_paem, 
           cons_codi,
           codi_emex
  FROM para_empr
  WHERE codi_empr = @p_codi_empr
  AND   tipo_como = @tsPar1
  AND   codi_paem = @tsPar2
  AND	codi_emex = @p_codi_emex
 END
 ELSE IF (@tsTipo = 'L')
 BEGIN
   SET @sql = 'SELECT ROW_NUMBER() OVER(ORDER BY tipo_como ASC) AS REG, 
                      codi_empr,	codi_paem, 
                      tipo_como,	desc_paem, 
                      valo_paem,	obli_paem, 
                      cons_codi,	codi_emex
               FROM para_empr
               WHERE codi_empr = ''' + str(@p_codi_empr) + '''
               and codi_emex = '''+@p_codi_emex+''' '
 
   SET @sql = @sql + isnull(@tsCondicion,'')
   EXECUTE prc_list_dyn @sql, @tnPagina, @tnRegPag 
 END
END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_usua_sist_read]    Fecha de la secuencia de comandos: 09/23/2013 12:13:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	<Author,,Aaron Rojas>
-- alter date: <alter Date,,2012-10-01>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_usua_sist_read]  (
	@tsTipo as VARCHAR(3),	
	@tnPagina as INTEGER,	
	@tnRegPag as INTEGER, 
	@tsCondicion as VARCHAR(2048),
	@tsPar1 as VARCHAR(256), @tsPar2 as VARCHAR(256), 
	@tsPar3 as VARCHAR(256), @tsPar4 as VARCHAR(256), @tsPar5 as VARCHAR(256),
	@p_codi_usua VARCHAR(30), @p_codi_empr INTEGER, @p_codi_emex VARCHAR(30))
AS 
	/*
	 Procedimiento para rescatar datos de la tabla USUA_SIST
     CON EL 
	 Parametros
		@tsTipo 
			S: Query utilizada para el mantenedor
			L: Query utilizada para el listador
			LV: Query utilizada para las listas de valor
		@tnPagina	: Numero de pagina a rescatar
		@tnRegPag	: Numero de registros por pagina
		@tsCondicion : Condicion, clausula Where
		@tsPar1		: Parametro 1 - CODI_USUA
		@tsPar2		: Parametro 2
		@tsPar3		: Parametro 3
		@tsPar4		: Parametro 4
		@tsPar5		: Parametro 5
	 */
	declare @sql_dyn as INTEGER
	declare @sql as nVARCHAR(2048)
BEGIN
	IF (@tsTipo = 'S')
	BEGIN
	 SELECT codi_usua, 		nomb_usua, 		codi_pers, 		codi_rous, 
            codi_empr, 		fech_usua, 		codi_impr, 		codi_ofic, 
            codi_ceco, 		codi_zona, 		codi_menu, 		nive_usua, 
            noco_usua, 		pass_usua, 		tipo_usua, 		codi_ramo, 
            fono_usua, 		luga_usua, 		digi_usua, 		codi_dbst, 
            fete_usua, 		mail_usua, 		codi_emex, 		tipo_fold, 
            codi_cult, 		usua_acdi, 		usua_esta, 		fech_vige, 
            usua_cadu, 		erro_logi, 		usua_noca, 		usua_filt
  FROM usua_sist
  WHERE codi_usua = @tsPar1
  and	codi_emex = @p_codi_emex
  and	codi_empr = @p_codi_empr
	END
	ELSE IF (@tsTipo = 'L')
	BEGIN
		SET @sql = 	'SELECT	ROW_NUMBER() OVER(ORDER BY CODI_USUA ASC) AS REG, 
						codi_usua, 		nomb_usua, 		codi_pers, 		codi_rous, 
						codi_empr, 		fech_usua, 		codi_impr, 		codi_ofic, 
						codi_ceco, 		codi_zona, 		codi_menu, 		nive_usua, 
						noco_usua, 		pass_usua, 		tipo_usua, 		codi_ramo, 
						fono_usua, 		luga_usua, 		digi_usua, 		codi_dbst, 
						fete_usua, 		mail_usua, 		codi_emex, 		tipo_fold, 
						codi_cult, 		usua_acdi, 		usua_esta, 		fech_vige, 
						usua_cadu, 		erro_logi, 		usua_noca, 		usua_filt
						FROM usua_sist
						WHERE codi_emex = '''+@p_codi_emex+'''
						and codi_empr = '''+convert(VARCHAR,@p_codi_empr)+''' '

		SET @sql = @sql + isnull(@tsCondicion,'')

		EXECUTE prc_list_dyn @sql, @tnPagina, @tnRegPag 
	END
	ELSE IF (@tsTipo = 'LV')
	BEGIN
		 SELECT		CODI_USUA AS CODIGO,
					NOMB_USUA AS VALOR
		 FROM		USUA_SIST
		 where		codi_emex = @p_codi_emex
		 and		codi_empr = @p_codi_empr
		 ORDER BY	NOMB_USUA
	END
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_sys_usro_read]    Fecha de la secuencia de comandos: 09/23/2013 12:12:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter  procedure [dbo].[prc_sys_usro_read]  (
	@tsTipo as VARCHAR(4),	
	@tnPagina as INTEGER,	
	@tnRegPag as INTEGER, 
	@tsCondicion as VARCHAR(2048),
	@tsPar1 as VARCHAR(256), @tsPar2 as VARCHAR(256), 
	@tsPar3 as VARCHAR(256), @tsPar4 as VARCHAR(256), @tsPar5 as VARCHAR(256),
	@p_codi_usua VARCHAR(30), @p_codi_empr INTEGER, @p_codi_emex VARCHAR(30))
AS 
    /*
     Procedimiento para rescatar datos de la tabla SYS_USRO
     CON EL 
     Parametros
        @tsTipo 
            S: Query utilizada para el mantenedor 
            L: Query utilizada para el listador 
            LV: Query utilizada para las listas de valor 
        @tnPagina	: Numero de pagina a rescatar 
        @tnRegPag	: Numero de registros por pagina
        @tsCondicion : Condicion, clausula Where
        @tsPar1		: Parametro 1 - codi_usua
        @tsPar2		: Parametro 2 - codi_modu
        @tsPar3		: Parametro 3 - 
        @tsPar4		: Parametro 4 - 
        @tsPar5		: Parametro 5 - 
        @p_codi_usua    : Usuario
        @p_codi_empr    : Empresa
        @p_codi_emex    : Emex
     */
     declare @sql_dyn as INTEGER
     declare @sql as nVARCHAR(4000)
BEGIN
  IF (@tsTipo = 'S')
  BEGIN
    SELECT codi_rous, 
           codi_usua, 
           codi_modu
  FROM sys_usro
  WHERE codi_rous = @tsPar1
  AND   codi_usua = @tsPar2
  AND   codi_modu = @tsPar3
 END
 ELSE IF (@tsTipo = 'L')
 BEGIN
   SET @sql = 'SELECT ROW_NUMBER() OVER(ORDER BY codi_usua ASC) AS REG, 
                codi_rous, codi_usua, codi_modu
               FROM sys_usro
               WHERE 1 = 1 '
 
   SET @sql = @sql + isnull(@tsCondicion,'')
   EXECUTE prc_list_dyn @sql, @tnPagina, @tnRegPag 
 END
END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_sys_code_read]    Fecha de la secuencia de comandos: 09/23/2013 12:12:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 31-01-2013
-- Description:	<Description,,>
-- =============================================
alter  procedure [dbo].[prc_sys_code_read] (
 @tsTipo as VARCHAR(4),
 @tnPagina as INTEGER,
 @tnRegPag as INTEGER,
 @tsCondicion as VARCHAR(2048),
 @tsPar1 as VARCHAR(256), @tsPar2 as VARCHAR(256),
 @tsPar3 as VARCHAR(256), @tsPar4 as VARCHAR(256), @tsPar5 as VARCHAR(256),
 @p_codi_usua VARCHAR(30), @p_codi_empr INTEGER, @p_codi_emex VARCHAR(30))
AS 
    /*
     Procedimiento para rescatar datos de la tabla SYS_CODE
     CON EL 
     Parametros
        @tsTipo 
            S: Query utilizada para el mantenedor 
            L: Query utilizada para el listador 
            LV: Query utilizada para las listas de valor 
        @tnPagina	: Numero de pagina a rescatar 
        @tnRegPag	: Numero de registros por pagina
        @tsCondicion : Condicion, clausula Where
        @tsPar1		: Parametro 1 - domain_code
        @tsPar2		: Parametro 2 - code
        @tsPar3		: Parametro 3 - 
        @tsPar4		: Parametro 4 - 
        @tsPar5		: Parametro 5 - 
        @p_codi_usua    : Usuario
        @p_codi_empr    : Empresa
        @p_codi_emex    : Emex
     */
     declare @sql_dyn as INTEGER
     declare @sql as nVARCHAR(4000)
BEGIN
  IF (@tsTipo = 'S')
  BEGIN
    SELECT code, 
           code_desc, 
           domain_code, 
           code_aux, 
           code_dele
  FROM 	sys_code
  WHERE domain_code = @tsPar1
  AND   code = @tsPar2
 END
 ELSE IF (@tsTipo = 'L')
 BEGIN
   SET @sql = 'SELECT ROW_NUMBER() OVER(ORDER BY domain_code ASC) AS REG, 
                code, code_desc, domain_code, 
                code_aux, 
                code_dele
               FROM sys_code
               WHERE code = '''+@tsPar1+''' '
 
   SET @sql = @sql + isnull(@tsCondicion,'')
   EXECUTE prc_list_dyn @sql, @tnPagina, @tnRegPag 
 END
 else if(@tsTipo = 'LV')
 BEGIN
	select code as CODIGO, code_desc as VALOR
	from sys_code 
	where domain_code = 12
	
 END
END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_sys_domain_read]    Fecha de la secuencia de comandos: 09/23/2013 12:12:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 31-01-2013
-- Description:	<Description,,>
-- =============================================
 ALTER  PROCEDURE [dbo].[prc_sys_domain_read] (
 @tsTipo as VARCHAR(4),
 @tnPagina as INTEGER,
 @tnRegPag as INTEGER,
 @tsCondicion as VARCHAR(2048),
 @tsPar1 as VARCHAR(30), @tsPar2 as VARCHAR(30),
 @tsPar3 as VARCHAR(30), @tsPar4 as VARCHAR(30), @tsPar5 as VARCHAR(30),
 @p_codi_usua VARCHAR(30), @p_codi_empr INTEGER, @p_codi_emex VARCHAR(30))
AS 
    /*
     Procedimiento para rescatar datos de la tabla SYS_DOMAIN
     CON EL 
     Parametros
        @tsTipo 
            S: Query utilizada para el mantenedor 
            L: Query utilizada para el listador 
            LV: Query utilizada para las listas de valor 
        @tnPagina	: Numero de pagina a rescatar 
        @tnRegPag	: Numero de registros por pagina
        @tsCondicion : Condicion, clausula Where
        @tsPar1		: Parametro 1 - domain_code
        @tsPar2		: Parametro 2 - 
        @tsPar3		: Parametro 3 - 
        @tsPar4		: Parametro 4 - 
        @tsPar5		: Parametro 5 - 
        @p_codi_usua    : Usuario
        @p_codi_empr    : Empresa
        @p_codi_emex    : Emex
     */
     declare @sql_dyn as INTEGER
     declare @sql as nVARCHAR(4000)
BEGIN
  IF (@tsTipo = 'S')
  BEGIN
    SELECT domain_code, 
           domain_name, 
           domain_length, 
           domain_type, 
           domain_show, 
           domain_class, 
           domain_low, 
           domain_hight, 
           domain_view, 
           domain_sclass, 
           domain_query, 
           domain_aux, 
           domain_auxlabel
  FROM sys_domain
  WHERE domain_code = @tsPar1
 END
 ELSE IF (@tsTipo = 'L')
 BEGIN
   SET @sql = 'SELECT ROW_NUMBER() OVER(ORDER BY domain_code ASC) AS REG, 
                domain_code, domain_name, domain_length, 
                domain_type, domain_show, domain_class, 
                domain_low, domain_hight, domain_view, 
                domain_sclass, domain_query, domain_aux, 
                domain_auxlabel
               FROM sys_domain
               WHERE 1 = 1 '
 
   SET @sql = @sql + isnull(@tsCondicion,'')
   EXECUTE prc_list_dyn @sql, @tnPagina, @tnRegPag 
 END
END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_read_lista_lndi_emp]    Fecha de la secuencia de comandos: 09/23/2013 12:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas 
-- alter date: 04-04-2013
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_read_lista_lndi_emp] (
	@tsTipo as Varchar(2),	
	@tnPagina as integer,	
	@tnRegPag as integer, 
	@tsCondicion as Varchar(128),
	@tsPar1 as Varchar(30), @tsPar2 as Varchar(30), 
	@tsPar3 as Varchar(30), @tsPar4 as Varchar(30), @tsPar5 as Varchar(30),
	@p_codi_usua varchar(30), @p_codi_empr int, @p_codi_emex varchar(30))
AS
	/*
	 Procedimiento para rescatar datos de la tabla SYS_PARAM
     CON EL 
	 Parametros
		@tsTipo 
			S: Query utilizada para el mantenedor
			L: Query utilizada para el listador
			LV: Query utilizada para las listas de valor
		@tnPagina	: Numero de pagina a rescatar
		@tnRegPag	: Numero de registros por pagina
		@tsCondicion : Condicion, clausula Where
		@tsPar1		: Parametro 1 - codi_indi
		@tsPar2		: Parametro 2
		@tsPar3		: Parametro 3
		@tsPar4		: Parametro 4
		@tsPar5		: Parametro 5
	 */
	declare @sql_dyn as integer
	declare @sql as nvarchar(4000)
	 
BEGIN
	IF(@tsTipo = 'L')
	BEGIN
		if(@tsPar1 is null)
		begin
			set @sql = 'SELECT ROW_NUMBER() OVER(ORDER BY dbfe.codi_indi ASC) AS REG, dbfe.codi_indi , dbfe.tipo_conc , dbfe.desc_indi , dbfe.form_indi from dbax_form_enca dbfe where dbfe.codi_emex = '''+@p_codi_emex+''' '
		end
		else
		begin
			set @sql = 'SELECT ROW_NUMBER() OVER(ORDER BY dbfe.codi_indi ASC) AS REG, dbfe.codi_indi , dbfe.tipo_conc , dbfe.desc_indi , dbfe.form_indi from dbax_form_enca dbfe where dbfe.codi_emex = '''+@p_codi_emex+''' and codi_indi = '''+ISNULL(@tsPar1,'')+''' '
		end
		
		SET @sql = @sql + isnull(@tsCondicion,'')
		EXECUTE dbo.prc_list_dyn @sql, @tnPagina, @tnRegPag 
	END
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_usua_empr_read]    Fecha de la secuencia de comandos: 09/23/2013 12:13:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_usua_empr_read] (
 @tsTipo as VARCHAR(4),
 @tnPagina as INTEGER,
 @tnRegPag as INTEGER,
 @tsCondicion as VARCHAR(2048),
 @tsPar1 as VARCHAR(256), @tsPar2 as VARCHAR(256),
 @tsPar3 as VARCHAR(256), @tsPar4 as VARCHAR(256), @tsPar5 as VARCHAR(256),
 @p_codi_usua VARCHAR(30), @p_codi_empr INTEGER, @p_codi_emex VARCHAR(30))
AS 
    /*
     Procedimiento para rescatar datos de la tabla USUA_EMPR
     CON EL 
     Parametros
        @tsTipo 
            S: Query utilizada para el mantenedor 
            L: Query utilizada para el listador 
            LV: Query utilizada para las listas de valor 
        @tnPagina	: Numero de pagina a rescatar 
        @tnRegPag	: Numero de registros por pagina
        @tsCondicion : Condicion, clausula Where
        @tsPar1		: Parametro 1 - codi_usua
        @tsPar2		: Parametro 2 - 
        @tsPar3		: Parametro 3 - 
        @tsPar4		: Parametro 4 - 
        @tsPar5		: Parametro 5 - 
        @p_codi_usua    : Usuario
        @p_codi_empr    : Empresa
        @p_codi_emex    : Emex
     */
     declare @sql_dyn as INTEGER
     declare @sql as nVARCHAR(4000)
BEGIN
  IF (@tsTipo = 'S')
  BEGIN
    SELECT codi_usua, 
           codi_empr, 
           codi_ofic
  FROM usua_empr
  WHERE codi_empr = @tsPar2
  AND   codi_usua = @tsPar1
 END
 ELSE IF (@tsTipo = 'L')
 BEGIN
   SET @sql = 'SELECT ROW_NUMBER() OVER(ORDER BY codi_usua ASC) AS REG, 
                codi_usua, codi_empr, codi_ofic
               FROM usua_empr 
               WHERE 1 = 1'
 
   SET @sql = @sql + isnull(@tsCondicion,'')
   EXECUTE prc_list_dyn @sql, @tnPagina, @tnRegPag 
 END
END;
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_delCntx]    Fecha de la secuencia de comandos: 09/23/2013 12:13:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_delCntx] 
	@p_CodiEmex varchar(30),
	@p_CodiEmpr numeric(9,0),
	@p_CodiCntx varchar(100)
 as
BEGIN
	delete dbax_defi_cntx 
	where codi_emex = @p_CodiEmex 
	and codi_empr  = @p_CodiEmpr
	and codi_cntx = @p_CodiCntx 
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getFechaContexto]    Fecha de la secuencia de comandos: 09/23/2013 12:13:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getFechaContexto]
	@CodiEmex varchar(30),
	@CodiEmpr numeric(9,0),
	@CorrInst numeric(6,0),
	@CodiCntx varchar(50)
as
BEGIN
	select	codi_cntx, 
			dbo.FU_AX_getFechas(@CorrInst, dc.diai_cntx, dc.anoi_cntx) fini_cntx, 
			dbo.FU_AX_getFechas(@CorrInst, dc.diat_cntx, dc.anot_cntx) ffin_cntx 
	from	dbax_defi_cntx dc
	where	codi_emex = @CodiEmex
	and		codi_empr = @CodiEmpr
	and		codi_cntx = @CodiCntx
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getContextosInforme]    Fecha de la secuencia de comandos: 09/23/2013 12:13:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getContextosInforme](
@p_codi_informe varchar(100))
as
BEGIN
	select	ic.codi_inct, 
			ic.orde_cntx, 
			ic.codi_cntx, 
			ic.codi_info,
			dc.desc_cntx
	from	dbax_info_cntx ic,
			dbax_defi_cntx dc
	where	ic.codi_info = @p_codi_informe
	and		ic.codi_cntx = dc.codi_cntx
	ORDER BY ic.orde_cntx
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_insCntx]    Fecha de la secuencia de comandos: 09/23/2013 12:13:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_insCntx] (
	@p_CodiEmex varchar(30),
	@p_CodiEmpr numeric(9,0),
	@p_CodiCntx varchar(100),
	@p_DescCntx varchar(100),
	@p_DiaiCntx varchar(100),
	@p_AnoiCntx varchar(100),
	@p_DiatCntx varchar(100),
	@p_AnotCntx varchar(100)
	)as
BEGIN
	insert dbax_defi_cntx (codi_emex, codi_empr, codi_cntx, desc_cntx, diai_cntx, anoi_cntx, diat_cntx, anot_cntx) 
	values (@p_CodiEmex, @p_CodiEmpr, @p_CodiCntx, @p_DescCntx,@p_DiaiCntx,@p_AnoiCntx,@p_DiatCntx,@p_AnotCntx)
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_UpdContexto]    Fecha de la secuencia de comandos: 09/23/2013 12:13:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_AX_UpdContexto] (
	@pCodiEmex varchar(30),
	@pCodiEmpr numeric(9,0),
	@pCodiCntx varchar(50),
	@pDescCntx varchar(100),
	@pDiaiCntx varchar(100),
	@pAnoiCntx varchar(100),
	@pDiatCntx varchar(100),
	@pAnotCntx varchar(100)
	)
AS
BEGIN
	update	dbax_defi_cntx 
	set		desc_cntx = @pDescCntx,
			diai_cntx = @pDiaiCntx,
			anoi_cntx = @pAnoiCntx,
			diat_cntx = @pDiatCntx,
			anot_cntx = @pAnotCntx
	where	codi_emex = @pCodiEmex
	and		codi_empr = @pCodiEmpr 
	and		codi_cntx = @pCodiCntx
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getInformesContextos ]    Fecha de la secuencia de comandos: 09/23/2013 12:13:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getInformesContextos ]
	@p_CodiEmex varchar(30),
	@p_CodiEmpr varchar(100),
	@p_CorrInst numeric(10,0),
	@p_CodiInfo varchar(50)
as
BEGIN
	select	dc.codi_cntx, 
			dc.diai_cntx, dc.anoi_cntx,
			dc.diat_cntx, dc.anot_cntx,
			dbo.FU_AX_getFechas(@p_CorrInst, dc.diai_cntx, dc.anoi_cntx) fini_cntx, 
			dbo.FU_AX_getFechas(@p_CorrInst, dc.diat_cntx, dc.anot_cntx) ffin_cntx,
			dc.desc_cntx,
			ic.orde_cntx
	from	dbax_defi_cntx dc,
			dbax_info_cntx ic
	where	dc.codi_emex = @p_CodiEmex
	and		dc.codi_empr = @p_CodiEmpr
	and		ic.codi_emex = dc.codi_emex
	and		ic.codi_empr = dc.codi_empr
	and		ic.codi_info = @p_CodiInfo
	and		ic.codi_cntx = dc.codi_cntx
	order by ic.orde_cntx
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_dbn_list_boto_delete]    Fecha de la secuencia de comandos: 09/23/2013 12:11:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 12-07-2013
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_dbn_list_boto_delete]
(@P_CODI_REPO varchar(30),
@P_CODI_BOTO varchar(30))
AS
BEGIN
	IF(@P_CODI_BOTO IS NULL)
	BEGIN
		DELETE 
			FROM DBN_LIST_BOTO 
			WHERE CODI_REPO = @P_CODI_REPO;
	END
	ELSE
	BEGIN
		DELETE 
			FROM DBN_LIST_BOTO 
			WHERE CODI_REPO = @P_CODI_REPO 
			AND CODI_BOTO = @P_CODI_BOTO;
	END
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_dbn_list_boto_alter]    Fecha de la secuencia de comandos: 09/23/2013 12:11:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 12-07-2013
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_dbn_list_boto_alter] 
	@P_CODI_REPO VARCHAR(25),			@P_CODI_BOTO VARCHAR(15),
	@P_NOMB_BOTO VARCHAR(30),			@P_DESC_BOTO VARCHAR(128),
	@P_TIPO_BOTO VARCHAR(1),			@P_CODI_RESX VARCHAR(30),
	@P_CLAS_CSS VARCHAR(30),			@P_PAGE_BOTO VARCHAR(128),
	@P_PROC_BOTO VARCHAR(30),			@P_CODI_PAR1 VARCHAR(30),
	@P_CODI_PAR2 VARCHAR(30),			@P_CODI_PAR3 VARCHAR(30),			
	@P_CODI_PAR4 VARCHAR(30),			@P_CODI_PAR5 VARCHAR(30),			
	@P_IMAG_BOTO VARCHAR(40),			@P_ORDE_BOTO INT,
	@P_INDI_VISI VARCHAR(1),			@P_MODO_BOTO VARCHAR(30),
	@P_LIST_DETA varchar(35)
AS
BEGIN
		insert into DBN_LIST_BOTO (
							CODI_REPO,			CODI_BOTO,
							NOMB_BOTO,			DESC_BOTO,
							TIPO_BOTO,			CODI_RESX,
							CLAS_CSS,			PAGE_BOTO,
							PROC_BOTO,			CODI_PAR1,
							CODI_PAR2,			CODI_PAR3,			
							CODI_PAR4,			CODI_PAR5,			
							IMAG_BOTO,			ORDE_BOTO,
							INDI_VISI,			MODO_BOTO,
							LIST_DETA)
		VALUES(
							@P_CODI_REPO,		@P_CODI_BOTO,
							@P_NOMB_BOTO,		@P_DESC_BOTO,
							@P_TIPO_BOTO,		@P_CODI_RESX,
							@P_CLAS_CSS,		@P_PAGE_BOTO,
							@P_PROC_BOTO,		@P_CODI_PAR1,
							@P_CODI_PAR2,		@P_CODI_PAR3,
							@P_CODI_PAR4,		@P_CODI_PAR5,
							@P_IMAG_BOTO,		@P_ORDE_BOTO,
							@P_INDI_VISI,		@P_MODO_BOTO,
							@P_LIST_DETA);
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_dbn_list_boto_update]    Fecha de la secuencia de comandos: 09/23/2013 12:11:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 12-07-2013
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_dbn_list_boto_update]
			@P_CODI_REPO VARCHAR(25),			
			@P_CODI_BOTO VARCHAR(15),
			@P_NOMB_BOTO VARCHAR(30),			
			@P_DESC_BOTO VARCHAR(128),
			@P_TIPO_BOTO VARCHAR(1),			
			@P_CODI_RESX VARCHAR(30),
			@P_CLAS_CSS VARCHAR(30),			
			@P_PAGE_BOTO VARCHAR(128),
			@P_PROC_BOTO VARCHAR(30),			
			@P_CODI_PAR1 VARCHAR(30),
			@P_CODI_PAR2 VARCHAR(30),			
			@P_CODI_PAR3 VARCHAR(30),			
			@P_CODI_PAR4 VARCHAR(30),			
			@P_CODI_PAR5 VARCHAR(30),			
			@P_IMAG_BOTO VARCHAR(40),
			@P_ORDE_BOTO VARCHAR(2),
			@P_INDI_VISI VARCHAR(1),
			@P_MODO_BOTO VARCHAR(30),
			@P_LIST_DETA varchar(35)
	
AS
BEGIN
	UPDATE DBN_LIST_BOTO SET
		   NOMB_BOTO = @P_NOMB_BOTO,			
		   DESC_BOTO = @P_DESC_BOTO,
		   TIPO_BOTO = @P_TIPO_BOTO,			
		   CODI_RESX = @P_CODI_RESX,
		   CLAS_CSS = @P_CLAS_CSS,			
		   PAGE_BOTO = @P_PAGE_BOTO,
		   PROC_BOTO = @P_PROC_BOTO,			
		   CODI_PAR1 = @P_CODI_PAR1,
		   CODI_PAR2 = @P_CODI_PAR2,			
		   CODI_PAR3 = @P_CODI_PAR3,			
		   CODI_PAR4 = @P_CODI_PAR4,			
		   CODI_PAR5 = @P_CODI_PAR5,			
		   IMAG_BOTO = @P_IMAG_BOTO,			
		   ORDE_BOTO = @P_ORDE_BOTO,
		   INDI_VISI = @P_INDI_VISI,
		   MODO_BOTO = @P_MODO_BOTO,
		   LIST_DETA = @P_LIST_DETA
		   WHERE CODI_REPO = @P_CODI_REPO
			AND	CODI_BOTO = @P_CODI_BOTO;
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_dbn_list_colu_delete]    Fecha de la secuencia de comandos: 09/23/2013 12:11:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 12-07-2013
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_dbn_list_colu_delete]
(@P_CODI_REPO varchar(20),
@P_CODI_COLU varchar(20))
AS
BEGIN
	IF(@P_CODI_COLU IS NULL)
	BEGIN
		DELETE 
			FROM DBN_LIST_COLU 
			WHERE CODI_REPO = @P_CODI_REPO;
	END
	ELSE
	BEGIN
		DELETE 
			FROM DBN_LIST_COLU 
			WHERE CODI_REPO = @P_CODI_REPO 
			AND CODI_COLU = @P_CODI_COLU;	
	END
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_dbn_list_colu_alter]    Fecha de la secuencia de comandos: 09/23/2013 12:11:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 12-07-2013
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_dbn_list_colu_alter] 
		@P_CODI_REPO VARCHAR(25),			
		@P_CODI_COLU VARCHAR(15), 
		@P_NOMB_COLU VARCHAR(30),			
		@P_DESC_COLU VARCHAR(128),
		@P_CODI_RESX VARCHAR(30),
		@P_CLAS_CSS VARCHAR(30),				
		@P_TIPO_COLU varchar(30),
		@P_ANCH_COLU VARCHAR(4),			
		@P_ALIN_COLU varchar(1),
		@P_FORM_COLU VARCHAR(20),			
		@P_INDI_VISI VARCHAR(1),
		@P_IMAG_COLU VARCHAR(30),			
		@P_JQRY_COLU VARCHAR(30),
		@P_ORDE_COLU VARCHAR(2),
		@P_TIPO_BUSQ VARCHAR(2),
		@P_INDI_BUSQ VARCHAR(1),
		@P_COLU_BUSQ VARCHAR(64),
		@P_VERD_BUSQ VARCHAR(1),
		@P_FALS_BUSQ VARCHAR(1),
		@P_CODI_LIVA VARCHAR(64)
AS
BEGIN
	INSERT INTO dbn_list_colu(
			CODI_REPO				,CODI_COLU,
			NOMB_COLU				,DESC_COLU,
			CLAS_CSS				,TIPO_COLU,
			ANCH_COLU				,ALIN_COLU,
			FORM_COLU				,INDI_VISI,
			IMAG_COLU				,JQRY_COLU,
			ORDE_COLU				,TIPO_BUSQ,
			INDI_BUSQ				,COLU_BUSQ,
			VERD_BUSQ				,FALS_BUSQ,
			CODI_LIVA				,CODI_RESX
			)			
     VALUES
			(@P_CODI_REPO,			@P_CODI_COLU, 
			@P_NOMB_COLU ,			@P_DESC_COLU,
			@P_CLAS_CSS ,			@P_TIPO_COLU ,
			@P_ANCH_COLU ,			@P_ALIN_COLU ,
			@P_FORM_COLU ,			@P_INDI_VISI ,
			@P_IMAG_COLU ,			@P_JQRY_COLU ,
			@P_ORDE_COLU ,			@P_TIPO_BUSQ ,
			@P_INDI_BUSQ ,			@P_COLU_BUSQ,
			@P_VERD_BUSQ			,@P_FALS_BUSQ,
			@P_CODI_LIVA,			@P_CODI_RESX);		
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_dbn_list_colu_update]    Fecha de la secuencia de comandos: 09/23/2013 12:11:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas 
-- alter date: 24-10-2012
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_dbn_list_colu_update] 
		@P_CODI_REPO VARCHAR(25),			
		@P_CODI_COLU VARCHAR(15), 
		@P_NOMB_COLU VARCHAR(30),			
		@P_DESC_COLU VARCHAR(128),
		@P_CODI_RESX VARCHAR(30),
		@P_CLAS_CSS VARCHAR(30),				
		@P_TIPO_COLU varchar(30),
		@P_ANCH_COLU VARCHAR(4),			
		@P_ALIN_COLU varchar(1),
		@P_FORM_COLU VARCHAR(20),			
		@P_INDI_VISI VARCHAR(1),
		@P_IMAG_COLU VARCHAR(30),			
		@P_JQRY_COLU VARCHAR(30),
		@P_ORDE_COLU VARCHAR(2),
		@P_TIPO_BUSQ VARCHAR(2),
		@P_INDI_BUSQ VARCHAR(1),
		@P_COLU_BUSQ VARCHAR(64),
		@P_VERD_BUSQ VARCHAR(1),
		@P_FALS_BUSQ VARCHAR(1),
		@P_CODI_LIVA VARCHAR(64)
AS
BEGIN

    UPDATE DBN_LIST_COLU SET
		NOMB_COLU =	@P_NOMB_COLU,
		DESC_COLU =	@P_DESC_COLU,
		CODI_RESX =	@P_CODI_RESX,
		CLAS_CSS  = @P_CLAS_CSS, 
		TIPO_COLU =	@P_TIPO_COLU,
		ANCH_COLU =	@P_ANCH_COLU,
		ALIN_COLU =	@P_ALIN_COLU,
		FORM_COLU =	@P_FORM_COLU,
		INDI_VISI =	@P_INDI_VISI,
		IMAG_COLU =	@P_IMAG_COLU,
		JQRY_COLU =	@P_JQRY_COLU,
		ORDE_COLU =	@P_ORDE_COLU,
		TIPO_BUSQ = @P_TIPO_BUSQ,
		INDI_BUSQ =	@P_INDI_BUSQ,
		COLU_BUSQ =	@P_COLU_BUSQ,
		VERD_BUSQ = @P_VERD_BUSQ,
		FALS_BUSQ = @P_FALS_BUSQ,
		CODI_LIVA = @P_CODI_LIVA
		WHERE	CODI_REPO =	@P_CODI_REPO
		AND		CODI_COLU = @P_CODI_COLU
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getDimensionesUsables]    Fecha de la secuencia de comandos: 09/23/2013 12:13:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getDimensionesUsables]
	@p_CodiInfo varchar(256)
as
BEGIN
	select distinct dd.pref_dime + ':' + dd.codi_dime codi_dime, dc1.desc_conc desc_conc
	--select distinct dd.codi_dime codi_dime, dc1.desc_conc desc_conc	
	from	dbax_dime_defi dd,
			dbax_defi_conc dc,
			dbax_desc_conc dc1
    where	dd.codi_dein = @p_CodiInfo
    and		dd.codi_dime = dc.codi_conc 
	and		dc.codi_conc = dc1.codi_conc
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getInformesDimension]    Fecha de la secuencia de comandos: 09/23/2013 12:13:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getInformesDimension] 
	@p_tipo_info varchar(1),
	@p_codi_pers varchar(30),
	@p_corr_inst varchar(30),
	@p_tipo_taxo varchar(10) = 'SEGUROS'
AS
BEGIN
	if(@p_tipo_info = 'R') --R= Reportado, o sea, se detectó en el XBRL
	BEGIN
		select ii.codi_info, ti.desc_info
		from	dbax_inst_info ii,
				dbax_taxo_info ti
		where	ii.codi_pers = @p_codi_pers
		and		ii.corr_inst  = @p_corr_inst
		and		ii.codi_info = ti.codi_info
	END
	else
	BEGIN	--Trae todos los informes, cargados y no
		select distinct codi_dein, ti.desc_info
		from	dbax_dime_defi dd,
				dbax_taxo_info ti
		where dd.codi_dein = ti.codi_info
		and	  dd.tipo_taxo = @p_tipo_taxo
	END
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_read_dbax_cuadros]    Fecha de la secuencia de comandos: 09/23/2013 12:12:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 20-05-2013
-- Description:	procedimiento almacenado para la obtencion de los informes que son solo cuadros tecnicos
-- =============================================
ALTER PROCEDURE [dbo].[prc_read_dbax_cuadros]
AS
BEGIN
	select	distinct dd.codi_dein, substring(ti.desc_info,charindex(']',ti.desc_info)+1,len(ti.desc_info)) as desc_info
	from	dbax_dime_defi dd,
			dbax_taxo_info ti
	where	dd.codi_dein = ti.codi_info
	and dd.codi_dein like '%cuadro%';
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_read_dbax_dimensiones]    Fecha de la secuencia de comandos: 09/23/2013 12:12:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas
-- alter date: 20-05-2013
-- Description:	Procedimiento almacenado para la obtencion de todas las dimensiones o ejes de los informes de cuadros tecnicos
-- =============================================
ALTER PROCEDURE [dbo].[prc_read_dbax_dimensiones] 
	@P_CODI_DEIN VARCHAR(128)
AS
BEGIN
	select distinct dd.codi_dime, dd.codi_dime as desc_dime
	from	dbax_dime_defi dd,
			dbax_defi_conc dc
	where	dd.codi_dein like '%pre_cl-cs_cuadro-%'
	and    dd.codi_dime = dc.codi_conc
	and		dd.codi_dein like '%'+@P_CODI_DEIN+'%'
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_dbn_repo_rous_alter]    Fecha de la secuencia de comandos: 09/23/2013 12:11:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_dbn_repo_rous_alter]

@P_CODI_REPO VARCHAR(20),
@P_CODI_ROUS VARCHAR(30),
@P_CODI_MODU VARCHAR(30)
AS
BEGIN
	INSERT INTO DBN_REPO_ROUS(CODI_MODU,CODI_REPO,CODI_ROUS) 
	VALUES (@P_CODI_MODU,@P_CODI_REPO,@P_CODI_ROUS);
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_dbn_repo_rous_delete]    Fecha de la secuencia de comandos: 09/23/2013 12:11:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 12-07-2013
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_dbn_repo_rous_delete]
@P_CODI_REPO varchar(30),
@P_CODI_MODU varchar(30),
@P_CODI_ROUS VARCHAR(30)
AS
BEGIN
	IF (@P_CODI_MODU is NULL)
	BEGIN
		DELETE 
			FROM DBN_REPO_ROUS 
			WHERE CODI_REPO = @P_CODI_REPO;
	END
	ELSE IF(@P_CODI_MODU IS NOT NULL)
	BEGIN 
		DELETE 
			FROM DBN_REPO_ROUS 
			WHERE CODI_REPO = @P_CODI_REPO 
			AND CODI_MODU = @P_CODI_MODU 
			AND CODI_ROUS = @P_CODI_ROUS;
	END
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_insInstDocu]    Fecha de la secuencia de comandos: 09/23/2013 12:13:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_AX_insInstDocu] (@pCodiPers numeric(9,0),@pCorrInst numeric(10,0),@CodiEsta varchar(3))
AS
BEGIN
	if((select count(1) from dbax_inst_docu where codi_pers = @pCodiPers and corr_inst = @pCorrInst)=0)
	begin
		insert into	dbax_inst_docu (codi_pers, corr_inst, codi_esta) 
		values		(@pCodiPers,@pCorrInst,@CodiEsta)
	end
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_delete_dbax_tipo_conc]    Fecha de la secuencia de comandos: 09/23/2013 12:11:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 08/04/2013
-- Description:	<Description,,>
-- =============================================
alter  procedure [dbo].[prc_delete_dbax_tipo_conc]
            @P_TIPO_CONC varchar(20) 
 AS
 BEGIN
        DELETE dbax_tipo_conc
        WHERE tipo_conc = @P_TIPO_CONC 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_alter_dbax_tipo_conc]    Fecha de la secuencia de comandos: 09/23/2013 12:11:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 08-04-2013
-- Description:	<Description,,>
-- =============================================
alter  procedure [dbo].[prc_alter_dbax_tipo_conc]
            @P_TIPO_CONC varchar(20), 
            @P_DESC_CONC varchar(100), 
            @P_TIPO_ELEM nchar 
 AS
 BEGIN
        INSERT INTO dbax_tipo_conc(
            tipo_conc, 
            desc_conc, 
            tipo_elem
        )
        VALUES
        (
             @P_TIPO_CONC, 
             @P_DESC_CONC, 
             @P_TIPO_ELEM
        );
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_GetConcPorNombreTipo]    Fecha de la secuencia de comandos: 09/23/2013 12:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_GetConcPorNombreTipo](
	@p_CodiEmex varchar(30),
	@p_CodiEmpr numeric(9,0),
	@p_CodiConc  varchar(100),
	@p_TipoElem varchar(1),
	@p_CodiConc2  varchar(100),
	@p_TipoConc varchar(4)='200') as
BEGIN
	if(@p_TipoElem='T')
	begin
		select	sc.desc_conc as desc_conc,
				dc.pref_conc as pref_conc, 
				dc.codi_conc as codi_conc 
		from	dbax_defi_conc dc, 
				dbax_desc_conc sc, 
				dbax_tipo_conc tc,
				sys_code s 
		where	dc.pref_conc = sc.pref_conc 
		and		dc.codi_conc = sc.codi_conc 
		and		dc.tipo_conc = tc.tipo_conc 
		and		tc.tipo_conc = 'concepto' 
		and		sc.desc_conc like '%' + @p_CodiConc + '%'
		and		s.domain_code = @p_TipoConc
		and		dc.tipo_valo = s.code
		order by desc_conc
	end
	else if(@p_TipoElem='P')
	begin
		select	sc.desc_conc as desc_conc,
				dc.pref_conc as pref_conc, 
				dc.codi_conc as codi_conc 
		from	dbax_defi_conc dc, 
				dbax_desc_conc sc, 
				dbax_form_enca fe
		where	fe.codi_emex = @p_CodiEmex
		and		fe.codi_empr = @p_CodiEmpr
		and		fe.codi_indi != @p_CodiConc2
		and		dc.pref_conc = 'indi'
		and		dc.codi_conc = fe.codi_indi
		and		dc.tipo_conc = fe.tipo_conc
		and		sc.pref_conc = dc.pref_conc
		and		sc.codi_conc = dc.codi_conc
		and		sc.desc_conc like '%' + @p_CodiConc + '%'
		order by desc_conc
	end
	else if(@p_TipoElem='')
	begin
		select	distinct sc.desc_conc as desc_conc,
				dc.pref_conc as pref_conc, 
				dc.codi_conc as codi_conc 
		from	dbax_defi_conc dc, 
				dbax_desc_conc sc, 
				dbax_tipo_conc tc,
				sys_code s
		where	dc.pref_conc = sc.pref_conc 
		and		dc.codi_conc = sc.codi_conc 
		and		dc.tipo_conc = tc.tipo_conc 
		and		tc.tipo_conc = 'concepto' 
		and		sc.desc_conc like '%' + @p_CodiConc + '%'
		and		s.domain_code = @p_TipoConc
		and		dc.tipo_valo = s.code
		union
		select	distinct isnull(sc.desc_conc,dc.codi_conc) as desc_conc,
				dc.pref_conc as pref_conc, 
				dc.codi_conc as codi_conc 
		from	dbax_defi_conc dc, 
				dbax_desc_conc sc, 
				dbax_form_enca fe
		where	fe.codi_emex = @p_CodiEmex
		and		fe.codi_empr = @p_CodiEmpr
		and		fe.codi_indi != @p_CodiConc2
		and		dc.pref_conc = 'indi'
		and		dc.codi_conc = fe.codi_indi
		and		dc.tipo_conc = fe.tipo_conc
		and		sc.pref_conc = dc.pref_conc
		and		sc.codi_conc = dc.codi_conc
		and		sc.desc_conc like '%' + @p_CodiConc + '%'
		order by desc_conc
	end
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_RescAgru]    Fecha de la secuencia de comandos: 09/23/2013 12:13:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_RescAgru] as
BEGIN
	select tipo_conc, desc_conc from dbax_tipo_conc where tipo_elem = 'I'
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_GetConcPorPrefConc]    Fecha de la secuencia de comandos: 09/23/2013 12:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DBAX
ALTER procedure [dbo].[SP_AX_GetConcPorPrefConc](
	@p_CodiEmex varchar(30),
	@p_CodiEmpr numeric(9,0),
	@p_TipoTaxo  varchar(50),
	@p_CodiConc  varchar(100),
	@p_TipoRepo varchar(30)) as
BEGIN
	if(@p_TipoRepo = 'Indicadores')
	BEGIN
		select	distinct
				--sc.desc_conc as desc_conc,
				sc.desc_conc + ' (' + cast(dc.pref_conc as varchar(12)) collate Modern_Spanish_CS_AS + ')' as desc_conc,
				dc.pref_conc as pref_conc, 
				dc.codi_conc as codi_conc 
		from	dbax_defi_conc dc, 
				dbax_desc_conc sc, 
				dbax_tipo_conc tc,
				sys_code s 
		where	dc.pref_conc = sc.pref_conc 
		and		dc.codi_conc = sc.codi_conc 
		and		dc.tipo_conc = tc.tipo_conc 
	--	and		tc.tipo_conc = 'concepto' 
		and		dc.tipo_taxo like '%' + @p_TipoTaxo + '%'
		--and		sc.desc_conc like '' + @p_CodiConc + '%'
		and		upper(sc.desc_conc  + ' (' + cast(dc.pref_conc as varchar(12)) collate Modern_Spanish_CS_AS + ')') like upper('%' + @p_CodiConc + '%')
		and		s.domain_code in ('200','210')
		and		dc.tipo_valo = s.code
		and		dc.pref_conc != 'indi'
		order by desc_conc ASC
	END
	ELSE if(@p_TipoRepo = 'RepoXBRL')
	BEGIN
		select	distinct sc.desc_conc as desc_conc,
				dc.pref_conc as pref_conc, 
				dc.codi_conc as codi_conc 
		from	dbax_defi_conc dc, 
				dbax_desc_conc sc, 
				dbax_tipo_conc tc,
				sys_code s 
		where	dc.pref_conc = sc.pref_conc 
		and		dc.codi_conc = sc.codi_conc 
		and		dc.tipo_conc = tc.tipo_conc 
	--	and		tc.tipo_conc = 'concepto' 
		and		dc.tipo_taxo like '%' + @p_TipoTaxo + '%'
		and		upper(sc.desc_conc) like upper('%' + @p_CodiConc + '%')
		and		s.domain_code in ('200','210')
		and		dc.tipo_valo = s.code
		order by desc_conc ASC
	END	
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_update_dbax_tipo_conc]    Fecha de la secuencia de comandos: 09/23/2013 12:12:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 08-04-2013
-- Description:	<Description,,>
-- =============================================
alter  procedure [dbo].[prc_update_dbax_tipo_conc]
            @P_TIPO_CONC varchar(20), 
            @P_DESC_CONC varchar(100), 
            @P_TIPO_ELEM nchar 
 AS
 BEGIN
        UPDATE dbax_tipo_conc
             SET desc_conc = @P_DESC_CONC, 
                 tipo_elem = @P_TIPO_ELEM
             WHERE tipo_conc = @P_TIPO_CONC 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getValoresPorInfoDimeCntx]    Fecha de la secuencia de comandos: 09/23/2013 12:13:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getValoresPorInfoDimeCntx]
	@pCodiPers	 varchar(16),
	@pCorrInst	 numeric(10,0),
	@pVersInst	 numeric(5,0),
	@pCodiCntx	 varchar(1000),
	@pCodiInfo   varchar(256),
	@pPrefDime varchar(50),
	@pCodiDime varchar(256)
as
BEGIN
	select	ic.valo_cntx, dc.orde_conc
	from	dbax_dime_conc dc left join
			dbax_inst_conc ic
			on	ic.codi_pers = @pCodiPers
			and	ic.corr_inst = @pCorrInst
			and	ic.vers_inst = @pVersInst
			and	ic.codi_cntx = @pCodiCntx
			and		dc.pref_conc = ic.pref_conc
			and		dc.codi_conc = ic.codi_conc
	where	dc.codi_dein = @pCodiInfo
	and		dc.pref_dime = @pPrefDime
	and		dc.codi_dime = @pCodiDime
	group by ic.corr_conc, ic.pref_conc, ic.codi_conc, dc.orde_conc, ic.valo_cntx
	order by orde_conc
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_alter_exec_bin]    Fecha de la secuencia de comandos: 09/23/2013 12:11:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas
-- alter date: 07-05-2013
-- Description:	Procedimiento para el ingreso de datos para la ejecucion de los binarios
-- =============================================
ALTER PROCEDURE [dbo].[prc_alter_exec_bin]
	@p_nomb_bin varchar(128),
	@p_corr_inst varchar(16),
	@p_codi_usua varchar(30),
	@p_codi_emex varchar(30),
	@p_codi_empr numeric(16,0),
	@p_codi_args varchar(512) 
AS
BEGIN
	IF(@p_codi_args = 'mone')
	BEGIN
		INSERT INTO dbax_dbne_proc(prog_proc, args_proc, fech_crea, esta_proc, codi_usua)
		VALUES (@p_nomb_bin,'"'+@p_codi_emex+'"'+' '+'"'+convert(varchar,@p_codi_empr)+'"'+' '+'"'+@p_corr_inst+'"'+' '+'""'+' '+'""'+' '+'""',GETDATE(),'I',@p_codi_usua);
	END
	ELSE IF(@p_codi_args = 'execCMD')
	BEGIN
		INSERT INTO dbax_dbne_proc(prog_proc, args_proc, fech_crea, esta_proc, codi_usua)
		VALUES (@p_nomb_bin,'',GETDATE(),'I',@p_codi_usua);
	END
	else
	INSERT INTO dbax_dbne_proc(prog_proc, args_proc, fech_crea, esta_proc, codi_usua)
		VALUES (@p_nomb_bin,@p_codi_args,GETDATE(),'I',@p_codi_usua);
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_inssSerivicio]    Fecha de la secuencia de comandos: 09/23/2013 12:13:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_inssSerivicio] as

BEGIN
declare @pRuta_bianrio varchar(256)
declare @pFecha_ini varchar(256)

  set @pRuta_bianrio = (select PARAM_VALUE from sys_param where PARAM_NAME = 'DBAX_XBRL_BINA')
  set @pFecha_ini  = (select getdate())

	insert dbax_dbne_proc(prog_proc,args_proc, fech_crea, fini_proc, esta_proc) 
	values (@pRuta_bianrio,'1', @pFecha_ini, @pFecha_ini, 'I')
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getProcesosPendientes]    Fecha de la secuencia de comandos: 09/23/2013 12:13:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_AX_getProcesosPendientes] 
AS
BEGIN
	select codi_proc,
    prog_proc, 
    args_proc 
    from   dbax_dbne_proc 
    where  esta_proc = 'I' 
    order by fech_crea
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_UpdEstadoservicio]    Fecha de la secuencia de comandos: 09/23/2013 12:13:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_UpdEstadoservicio] 
(@p_esta_proc varchar(50),
 @p_codi_proc varchar(50),
 @p_mens_proc varchar(50))
AS
BEGIN
	if(@p_esta_proc = 'P')
	begin
		update dbax_dbne_proc 
		set fini_proc=getdate(),
		esta_proc = @p_esta_proc,
		mens_proc = @p_mens_proc
		where codi_proc = @p_codi_proc
	end
	else if(@p_esta_proc = 'T')
	begin
		update dbax_dbne_proc 
		set ffin_proc=getdate(),
		esta_proc = @p_esta_proc,
		mens_proc = @p_mens_proc
		where codi_proc = @p_codi_proc
	end
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_COMPANIA]    Fecha de la secuencia de comandos: 09/23/2013 12:13:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_COMPANIA](@pTipoPers varchar(1), @pRuttPers varchar(16), @pNombPers varchar(100), @pNfanPers varchar(50)) as
begin
	declare @vExiste   numeric
	declare @vCodiPers varchar(16)
	declare @vTipoTaxo varchar(16)
	declare @vCodiSegm varchar(16)

	if (@pTipoPers = '0')
	begin
		set @vTipoTaxo = 'COME_INDU'
		set @vCodiSegm = ''
		set @vCodiPers = substring(@pRuttPers ,0,charindex('-',@pRuttPers))
	end
	if (@pTipoPers = '1')
	begin
		set @vTipoTaxo = 'SEGUROS'
		set @vCodiSegm = 'SEGUROGRAL'
		set @vCodiPers = substring(@pRuttPers ,0,charindex('-',@pRuttPers)) + @pTipoPers
	end
	if (@pTipoPers = '2')
	begin
		set @vTipoTaxo = 'SEGUROS'
		set @vCodiSegm = 'SEGUROVIDA'
		set @vCodiPers = substring(@pRuttPers ,0,charindex('-',@pRuttPers)) + @pTipoPers
	end

	select @vExiste = count(*)
	from   dbax_defi_pers
	where  codi_pers = @vCodiPers 

	if (@vExiste = 0 )
	begin
		insert into dbax_defi_pers (codi_pers, desc_pers, tipo_taxo, codi_segm, rutt_pers)
		values (@vCodiPers, @pNombPers, @vTipoTaxo , @vCodiSegm, @pRuttPers)
	end
	else
	begin
		update dbax_defi_pers 
		set    desc_pers = @pNombPers,
		       rutt_pers = @pRuttPers
		where  codi_pers = @vCodiPers
	end

	insert into dbax_defi_peho (codi_emex, codi_empr, codi_pers, desc_empr, nomb_cort )
	select codi_emex, codi_empr, p.codi_pers, p.desc_pers, @pNfanPers
	from   empr e,
		   dbax_defi_pers p
	where  not exists (select 1 from dbax_defi_peho h
					   where h.codi_emex = e.codi_emex
					   and   h.codi_empr = e.codi_empr
					   and   h.codi_pers = p.codi_pers)
	and    p.codi_pers = @vCodiPers
end
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_UpdDescEmpresa]    Fecha de la secuencia de comandos: 09/23/2013 12:13:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_AX_UpdDescEmpresa](
@pCodiEmex varchar(30),
@pCodiEmpr numeric(9,0),
@pCodiPers numeric(9,0),
@pDescEmpr varchar(200),
@pCodiGrup varchar(50),
@pCodiSegm varchar(50),
@pTipoTaxo varchar(10)
)
AS
BEGIN
	IF (@pDescEmpr = '')
	BEGIN
		SET @pDescEmpr =  NULL;
	END

	IF (@pCodiGrup = '')
	BEGIN
		SET @pCodiGrup =  NULL;
	END

	IF (@pCodiSegm = '')
	BEGIN
		SET @pCodiSegm =  NULL;
	END	

	IF (@pTipoTaxo = '')
	BEGIN
		SET @pTipoTaxo =  NULL;
	END	

    update	dbax_defi_peho
	set		desc_empr = @pDescEmpr
	where	codi_emex = @pCodiEmex
	and		codi_empr = @pCodiEmpr
	and		codi_pers = @pCodiPers
	
	update	dbax_defi_pers
	set		codi_grup = @pCodiGrup,
			codi_segm = @pCodiSegm,
			tipo_taxo = @pTipoTaxo
	where	codi_pers = @pCodiPers
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_update_dbax_defi_peho]    Fecha de la secuencia de comandos: 09/23/2013 12:12:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Aaron Rojas
-- alter date: 19-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_update_dbax_defi_peho]
            @P_CODI_EMEX varchar(30), 
            @P_CODI_EMPR numeric(9, 0), 
            @P_CODI_PERS numeric(9, 0), 
            @P_DESC_EMPR varchar(200) 
 AS
 BEGIN
        UPDATE dbax_defi_peho
             SET desc_empr = @P_DESC_EMPR 
             WHERE codi_pers = @P_CODI_PERS 
             AND   codi_emex = @P_CODI_EMEX 
             AND   codi_empr = @P_CODI_EMPR 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_alter_dbax_defi_peho]    Fecha de la secuencia de comandos: 09/23/2013 12:11:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Aaron Rojas
-- alter date: 19-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_alter_dbax_defi_peho]
            @P_CODI_EMEX varchar(30), 
            @P_CODI_EMPR numeric(9, 0), 
            @P_CODI_PERS varchar(16), 
            @P_DESC_EMPR varchar(200) 
 AS
 BEGIN
        INSERT INTO dbax_defi_peho(
            codi_emex, 
            codi_empr, 
            codi_pers, 
            desc_empr
        )
        VALUES
        (
             @P_CODI_EMEX, 
             @P_CODI_EMPR, 
             @P_CODI_PERS, 
             @P_DESC_EMPR
        );
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_delete_dbax_defi_peho]    Fecha de la secuencia de comandos: 09/23/2013 12:11:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Aaron Rojas
-- alter date: 19-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_delete_dbax_defi_peho]
            @P_CODI_PERS numeric(9, 0), 
            @P_CODI_EMEX varchar(30), 
            @P_CODI_EMPR numeric(9, 0) 
 AS
 BEGIN
        DELETE dbax_defi_peho
        WHERE codi_pers = @P_CODI_PERS 
        AND   codi_emex = @P_CODI_EMEX 
        AND   codi_empr = @P_CODI_EMPR 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_delete_dbne_defi_lang]    Fecha de la secuencia de comandos: 09/23/2013 12:11:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas	
-- alter date: 10-04-2013
-- Description:	
-- =============================================
alter  procedure [dbo].[prc_delete_dbne_defi_lang]
            @P_CODI_LANG varchar(50) 
 AS
 BEGIN
        DELETE dbne_defi_lang
        WHERE codi_lang = @P_CODI_LANG 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_alter_dbne_defi_lang]    Fecha de la secuencia de comandos: 09/23/2013 12:11:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas	
-- alter date: 10-04-2013
-- Description:	
-- =============================================
alter  procedure [dbo].[prc_alter_dbne_defi_lang]
            @P_CODI_LANG varchar(50), 
            @P_DESC_LANG varchar(100) 
 AS
 BEGIN
        INSERT INTO dbne_defi_lang(
            codi_lang, 
            desc_lang
        )
        VALUES
        (
             @P_CODI_LANG, 
             @P_DESC_LANG
        );
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_update_dbne_defi_lang]    Fecha de la secuencia de comandos: 09/23/2013 12:12:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas	
-- alter date: 10-04-2013
-- Description:	
-- =============================================
alter  procedure [dbo].[prc_update_dbne_defi_lang]
            @P_CODI_LANG varchar(50), 
            @P_DESC_LANG varchar(100) 
 AS
 BEGIN
        UPDATE dbne_defi_lang
             SET desc_lang = @P_DESC_LANG 
             WHERE codi_lang = @P_CODI_LANG 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_insInfoCntx]    Fecha de la secuencia de comandos: 09/23/2013 12:13:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_insInfoCntx] 
	@p_Codi_informe varchar(100),
	@p_Codi_cntx varchar(100),
	@p_Orden varchar(10),
	@p_codi_empr varchar(10)
 as
BEGIN
	insert dbax_info_cntx (codi_empr, codi_info, codi_cntx, orde_cntx) 
	values (@p_codi_empr, @p_Codi_informe, @p_Codi_cntx, @p_Orden)
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_UpdOrdenInforme]    Fecha de la secuencia de comandos: 09/23/2013 12:13:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter procedure [dbo].[SP_AX_UpdOrdenInforme] 
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
/****** Objeto:  StoredProcedure [dbo].[SP_AX_Valida_orde_info_cntx]    Fecha de la secuencia de comandos: 09/23/2013 12:13:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_Valida_orde_info_cntx](
	@codi_info varchar(100),
	@codi_empr varchar(10),
	@orden varchar(10)
) as
BEGIN
	select count(*) 
	from dbax_info_cntx 
	where orde_cntx = @orden  
	and codi_empr =  @codi_empr
	and codi_info = @codi_info 
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_delInfoCntx]    Fecha de la secuencia de comandos: 09/23/2013 12:13:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_delInfoCntx] 
	@CodiEmex varchar(30),
	@CodiEmpr numeric(9,0),
	@CodiInfo varchar(50),
	@CodiCntx varchar(50)
 as
BEGIN
	delete from dbax_info_cntx 
	where	codi_emex = @CodiEmex  
	and		codi_empr = @CodiEmpr
	and		codi_info = @CodiInfo
	and		codi_cntx = @CodiCntx
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getInformesUsables]    Fecha de la secuencia de comandos: 09/23/2013 12:13:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getInformesUsables] 
	@pCodiEmex varchar(30),
	@pCodiEmpr numeric(9,0),
	@pCodiPers numeric(9,0),
	@pCorrInst numeric(10,0),
	@pVersInst numeric(5,0),
	@pTipoInfo varchar(1)
AS
BEGIN
	if(@pTipoInfo='R') --Solo informes realmente reportados por la empresa
	begin
		select	id.codi_info, di.desc_info
		from	dbax_info_defi id,
				dbax_info_cntx ic,
				dbax_desc_info di,
				dbax_inst_info ii
		where	id.codi_emex = @pCodiEmex
		and		id.codi_empr = @pCodiEmpr
		and		ic.codi_emex = id.codi_emex
		and		ic.codi_empr = id.codi_empr
		and		ic.codi_info = id.codi_info
		and		di.codi_info = id.codi_info
		and		di.codi_lang = 'es_ES'
		and		ii.codi_pers = @pCodiPers
		and		ii.corr_inst = @pCorrInst
		and		ii.vers_inst = @pVersInst
		and		ii.codi_info = ic.codi_info
		group by id.codi_info, di.desc_info, id.orde_info
		order by id.orde_info
	end
	else
	begin
		select	id.codi_info, isnull(de.desc_info, id.codi_info) as desc_info
		from	dbax_defi_pers dp,
				dbax_info_defi id
			left join	dbax_desc_info de
			on id.codi_info = de.codi_info
		where	dp.codi_pers = @pCodiPers
		and		id.codi_emex = @pCodiEmex
		and		id.codi_empr = @pCodiEmpr
		and		id.tipo_taxo = dp.tipo_taxo
		order by id.orde_info
	end
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_GetMaxColum]    Fecha de la secuencia de comandos: 09/23/2013 12:13:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_GetMaxColum](
@pCodiInfo varchar(50),
@pCodiEmpr numeric (9,0),
@pCodiEmex varchar(30)
)
as
BEGIN

select isnull(max(orde_cntx),0)+ 1 as orde_conc
from dbax_info_cntx 
where codi_info  =@pCodiInfo
and codi_empr = @pCodiEmpr
and codi_emex = @pCodiEmex

END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_insInfoDefi]    Fecha de la secuencia de comandos: 09/23/2013 12:13:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_AX_insInfoDefi]
 (	@CodiEmex varchar(50),
	@CodiEmpr varchar(20),
	@CodiInfo varchar(50),
	@DescInfo varchar(50),
	@Tipotaxo varchar(10)
	)
AS
BEGIN
	insert into dbax_info_defi (codi_emex, codi_empr, codi_info, tipo_taxo)
			values (@CodiEmex, @CodiEmpr, @CodiInfo, @Tipotaxo)

	insert into dbax_desc_info (codi_emex, codi_empr, codi_info, codi_lang, desc_info)
			values (@CodiEmex,@CodiEmpr,@CodiInfo,'es_ES',@DescInfo)
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_delInfoDefi]    Fecha de la secuencia de comandos: 09/23/2013 12:13:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_delInfoDefi] 
	@CodiEmex varchar(30),
	@CodiEmpr numeric(9,0),
	@CodiInfo varchar(50)
 as
BEGIN
	delete from dbax_desc_info
	where	codi_emex = @CodiEmex  
	and		codi_empr = @CodiEmpr
	and		codi_info = @CodiInfo

	delete from dbax_info_defi
	where	codi_emex = @CodiEmex  
	and		codi_empr = @CodiEmpr
	and		codi_info = @CodiInfo
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_updInfoDefi]    Fecha de la secuencia de comandos: 09/23/2013 12:13:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_AX_updInfoDefi]
	(	
	@CodiEmex varchar(50),
	@CodiEmpr varchar(20),
	@CodiInfo varchar(50),
	@DescInfo varchar(50)
	)
AS
BEGIN
	select @CodiEmex, @CodiEmpr, @CodiInfo, @DescInfo
	update	dbax_desc_info 
	set desc_info = @DescInfo
	where	codi_emex =@CodiEmex 
	and		codi_empr = @CodiEmpr
	and		codi_info = @CodiInfo
	and		codi_lang = 'es_ES'

	select	* 
	from	dbax_desc_info 
	where	codi_emex =@CodiEmex 
	and		codi_empr = @CodiEmpr
	and		codi_info = @CodiInfo
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getInforme]    Fecha de la secuencia de comandos: 09/23/2013 12:13:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getInforme] 
	@p_CodiEmex varchar(30),
	@p_CodiEmpr numeric(9,0),
	@pCodiInfo varchar(50)
AS
BEGIN
	select	id.codi_info, 
			isnull(de.desc_info, id.codi_info) as desc_info, 
			id.tipo_taxo
	from	dbax_info_defi id 
		left join	dbax_desc_info de
		on id.codi_info = de.codi_info
	where	id.codi_emex = @p_CodiEmex
	and		id.codi_empr = @p_CodiEmpr
	and		id.codi_info = @pCodiInfo
	order by id.orde_info
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getInformes]    Fecha de la secuencia de comandos: 09/23/2013 12:13:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getInformes] 
	@p_CodiEmex varchar(30),
	@p_CodiEmpr numeric(9,0),
	@pTipo varchar(10)=''
AS
BEGIN
	declare @vComodinTipo varchar(1)
	
	set @vComodinTipo = '%'

	if ( @pTipo != '')
	begin
		set @vComodinTipo = ''
	end

	select	id.codi_info, 
			isnull(de.desc_info, id.codi_info) + case info_taxo when 'S' then '' else '' end as desc_info, 
			id.tipo_taxo,
			tt.desc_tipo
	from	dbax_info_defi id 
		left join	dbax_desc_info de
		on id.codi_info = de.codi_info,
		dbax_tipo_taxo tt
	where	id.codi_emex = @p_CodiEmex
	and		id.codi_empr = @p_CodiEmpr
	and		id.tipo_taxo = tt.tipo_taxo
	and		id.tipo_taxo like @vComodinTipo + @pTipo + @vComodinTipo
	order by id.orde_info
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_para_empr_delete]    Fecha de la secuencia de comandos: 09/23/2013 12:12:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_para_empr_delete]
            @P_CODI_EMPR numeric(9, 0), 
            @P_TIPO_COMO VARCHAR(3), 
            @P_CODI_PAEM VARCHAR(30),
            @P_CODI_EMEX VARCHAR(30)
 AS
 BEGIN
        DELETE para_empr
        WHERE codi_empr = @P_CODI_EMPR 
        AND   tipo_como = @P_TIPO_COMO 
        AND   codi_paem = @P_CODI_PAEM 
        AND codi_emex = @P_CODI_EMEX;
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_para_empr_alter]    Fecha de la secuencia de comandos: 09/23/2013 12:12:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_para_empr_alter]
            @P_CODI_EMPR numeric(9, 0), 
            @P_CODI_PAEM VARCHAR(30), 
            @P_TIPO_COMO VARCHAR(3), 
            @P_DESC_PAEM VARCHAR(200), 
            @P_VALO_PAEM VARCHAR(100), 
            @P_OBLI_PAEM VARCHAR(1), 
            @P_CONS_CODI VARCHAR(100),
            @P_CODI_EMEX VARCHAR(30)
 AS
 BEGIN
        INSERT INTO para_empr(
            codi_empr, 
            codi_paem, 
            tipo_como, 
            desc_paem, 
            valo_paem, 
            obli_paem, 
            cons_codi,
            codi_emex
        )
        VALUES
        (
             @P_CODI_EMPR, 
             @P_CODI_PAEM, 
             @P_TIPO_COMO, 
             @P_DESC_PAEM, 
             @P_VALO_PAEM, 
             @P_OBLI_PAEM, 
             @P_CONS_CODI,
             @P_CODI_EMEX
        );
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_para_empr_update]    Fecha de la secuencia de comandos: 09/23/2013 12:12:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_para_empr_update]
            @P_CODI_EMPR numeric(9, 0), 
            @P_CODI_PAEM VARCHAR(30), 
            @P_TIPO_COMO VARCHAR(3), 
            @P_DESC_PAEM VARCHAR(200), 
            @P_VALO_PAEM VARCHAR(100), 
            @P_OBLI_PAEM VARCHAR(1), 
            @P_CONS_CODI VARCHAR(100),
            @P_CODI_EMEX VARCHAR(30)
 AS
 BEGIN
        UPDATE para_empr
             SET desc_paem = @P_DESC_PAEM, 
                 valo_paem = @P_VALO_PAEM, 
                 obli_paem = @P_OBLI_PAEM, 
                 cons_codi = @P_CONS_CODI
             WHERE codi_empr = @P_CODI_EMPR 
             AND   tipo_como = @P_TIPO_COMO 
             AND   codi_paem = @P_CODI_PAEM
             AND	codi_emex = @P_CODI_EMEX
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_ofic_empr_delete]    Fecha de la secuencia de comandos: 09/23/2013 12:12:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_ofic_empr_delete]
            @P_CODI_EMEX VARCHAR(30), 
            @P_CODI_EMPR numeric(9, 0), 
            @P_CODI_OFIC VARCHAR(3) 
 AS
 BEGIN
        DELETE ofic_empr
        WHERE codi_emex = @P_CODI_EMEX 
        AND   codi_empr = @P_CODI_EMPR 
        AND   codi_ofic = @P_CODI_OFIC 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_ofic_empr_update]    Fecha de la secuencia de comandos: 09/23/2013 12:12:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_ofic_empr_update]
            @P_CODI_EMEX VARCHAR(30), 
            @P_CODI_EMPR numeric(9, 0), 
            @P_CODI_OFIC VARCHAR(3), 
            @P_DESC_OFIC VARCHAR(30), 
            @P_CODI_CECO VARCHAR(16), 
            @P_CODI_SII VARCHAR(10), 
            @P_DIRE_OFIC VARCHAR(80), 
            @P_CODI_CIUD VARCHAR(8), 
            @P_CODI_COMU VARCHAR(8), 
            @P_CODI_PAIS VARCHAR(2), 
            @P_FONO_OFIC VARCHAR(50), 
            @P_FAXX_OFIC VARCHAR(15), 
            @P_TELX_OFIC VARCHAR(15) 
 AS
 BEGIN
        UPDATE ofic_empr
             SET desc_ofic = @P_DESC_OFIC, 
                 codi_ceco = @P_CODI_CECO, 
                 codi_sii = @P_CODI_SII, 
                 dire_ofic = @P_DIRE_OFIC, 
                 codi_ciud = @P_CODI_CIUD, 
                 codi_comu = @P_CODI_COMU, 
                 codi_pais = @P_CODI_PAIS, 
                 fono_ofic = @P_FONO_OFIC, 
                 faxx_ofic = @P_FAXX_OFIC, 
                 telx_ofic = @P_TELX_OFIC
             WHERE codi_emex = @P_CODI_EMEX 
             AND   codi_empr = @P_CODI_EMPR 
             AND   codi_ofic = @P_CODI_OFIC 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_ofic_empr_alter]    Fecha de la secuencia de comandos: 09/23/2013 12:12:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_ofic_empr_alter]
            @P_CODI_EMEX VARCHAR(30), 
            @P_CODI_EMPR numeric(9, 0), 
            @P_CODI_OFIC VARCHAR(3), 
            @P_DESC_OFIC VARCHAR(30), 
            @P_CODI_CECO VARCHAR(16), 
            @P_CODI_SII VARCHAR(10), 
            @P_DIRE_OFIC VARCHAR(80), 
            @P_CODI_CIUD VARCHAR(8), 
            @P_CODI_COMU VARCHAR(8), 
            @P_CODI_PAIS VARCHAR(2), 
            @P_FONO_OFIC VARCHAR(50), 
            @P_FAXX_OFIC VARCHAR(15), 
            @P_TELX_OFIC VARCHAR(15) 
 AS
 BEGIN
        INSERT INTO ofic_empr(
            codi_emex, 		codi_empr, 		codi_ofic, 		desc_ofic, 
            codi_ceco, 		codi_sii, 		dire_ofic, 		codi_ciud, 
            codi_comu, 		codi_pais, 		fono_ofic, 		faxx_ofic, 
            telx_ofic
        )
        VALUES
        (
             @P_CODI_EMEX, 	@P_CODI_EMPR, 	@P_CODI_OFIC, 	@P_DESC_OFIC, 
             @P_CODI_CECO, 	@P_CODI_SII, 	@P_DIRE_OFIC, 	@P_CODI_CIUD, 
             @P_CODI_COMU, 	@P_CODI_PAIS, 	@P_FONO_OFIC, 	@P_FAXX_OFIC, 
             @P_TELX_OFIC
		 );
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_sys_usro_delete]    Fecha de la secuencia de comandos: 09/23/2013 12:12:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter  procedure [dbo].[prc_sys_usro_delete]
            @p_codi_usua VARCHAR(30), 
            @P_CODI_MODU VARCHAR(30),
            @P_CODI_ROUS VARCHAR(30)
 AS
 BEGIN
        DELETE sys_usro
        WHERE codi_usua = @p_codi_usua 
        AND   codi_modu = @P_CODI_MODU 
        and		codi_rous = @P_CODI_ROUS
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_sys_usro_alter]    Fecha de la secuencia de comandos: 09/23/2013 12:12:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter  procedure [dbo].[prc_sys_usro_alter]
            @P_CODI_ROUS VARCHAR(30), 
            @p_codi_usua VARCHAR(30), 
            @P_CODI_MODU VARCHAR(30) 
 AS
 BEGIN
        INSERT INTO sys_usro(
            codi_rous, 
            codi_usua, 
            codi_modu
        )
        VALUES
        (
             @P_CODI_ROUS, 
             @p_codi_usua, 
             @P_CODI_MODU
        );
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_sys_usro_update]    Fecha de la secuencia de comandos: 09/23/2013 12:12:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter  procedure [dbo].[prc_sys_usro_update]
            @P_CODI_ROUS VARCHAR(30), 
            @p_codi_usua VARCHAR(30), 
            @P_CODI_MODU VARCHAR(30) 
 AS
 BEGIN
        UPDATE sys_usro
             SET codi_rous = @P_CODI_ROUS 
             WHERE codi_usua = @p_codi_usua 
             AND   codi_modu = @P_CODI_MODU 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_get_rol_read]    Fecha de la secuencia de comandos: 09/23/2013 12:12:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 27-11-2012
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_get_rol_read] 
	@p_codi_usua VARCHAR(30)
AS
BEGIN
	select codi_rous 
	from sys_usro 
	where codi_modu in ('DBWEB','FACT','XBRL','DBAX','FLUJOE','BASE') 
	and codi_usua = @p_codi_usua;
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_read_codi_conc]    Fecha de la secuencia de comandos: 09/23/2013 12:12:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[prc_read_codi_conc]
(
	@tsTipo as Varchar(2),	
	@tnPagina as integer,	
	@tnRegPag as integer, 
	@tsCondicion as Varchar(128),
	@tsPar1 as Varchar(30), @tsPar2 as Varchar(30), 
	@tsPar3 as Varchar(30), @tsPar4 as Varchar(30), @tsPar5 as Varchar(30),
	@p_codi_usua varchar(30), @p_codi_empr int, @p_codi_emex varchar(30)
)
AS
/*
     Procedimiento para rescatar datos de la tabla CENT_COST
     CON EL 
     Parametros
        @tsTipo 
            S: Query utilizada para el mantenedor 
            L: Query utilizada para el listador 
            LV: Query utilizada para las listas de valor 
        @tnPagina	: Numero de pagina a rescatar 
        @tnRegPag	: Numero de registros por pagina
        @tsCondicion : Condicion, clausula Where
        @tsPar1		: Parametro 1 - Version Taxonomía
        @tsPar2		: Parametro 2 - Prefijo de Concepto
        @tsPar3		: Parametro 3 - 
        @tsPar4		: Parametro 4 - 
        @tsPar5		: Parametro 5 - 
        @p_codi_usua    : Usuario
        @p_codi_empr    : Empresa
        @p_codi_emex    : Emex
     */
     
BEGIN
	declare @vDescripcion varchar(100)
	set @vDescripcion = isnull(upper(@tsPar3),'')
	select '' as CODIGO, 'Seleccione' as VALOR, 1
	union
	select	distinct tc.codi_conc as CODIGO, dc.desc_conc VALOR,2 
	from	dbax_taxo_conc tc, dbax_desc_conc dc
	where	vers_taxo = @tsPar1
	and		dc.pref_conc = @tsPar2
	and		tc.pref_conc = dc.pref_conc
	and		tc.codi_conc = dc.codi_conc
	and     upper(dc.desc_conc) like '%' + @vDescripcion + '%' 
	order by 3,2;
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getInfoDescConc]    Fecha de la secuencia de comandos: 09/23/2013 12:13:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getInfoDescConc] 
	@p_CodiEmex  varchar(30),
	@p_CodiEmpr  numeric(9,0),
	@p_codi_info varchar(128)
	as
BEGIN	
	select	A.negr_conc,
			A.nive_conc,
            D.desc_conc
	from	dbax_info_conc A, 
			dbax_defi_conc B, 
			dbax_desc_conc D
	where	A.codi_emex = @p_CodiEmex
	AND		A.codi_empr = @p_CodiEmpr
	AND		A.codi_info = @p_codi_info
	AND A.pref_conc = B.pref_conc
	AND A.codi_conc = B.codi_conc
	AND	B.pref_conc = D.pref_conc
	AND B.codi_conc = D.codi_conc
	order by A.orde_conc
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_update_dbax_desc_conc]    Fecha de la secuencia de comandos: 09/23/2013 12:12:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 09-04-2013
-- Description:	
-- =============================================
alter  procedure [dbo].[prc_update_dbax_desc_conc]
            @P_PREF_CONC varchar(50), 
            @P_CODI_CONC varchar(256), 
            @P_CODI_LANG varchar(50), 
            @P_DESC_CONC varchar(512) 
 AS
 BEGIN
        UPDATE dbax_desc_conc
             SET desc_conc = @P_DESC_CONC 
             WHERE codi_conc = @P_CODI_CONC 
             AND   codi_lang = @P_CODI_LANG 
             AND   pref_conc = @P_PREF_CONC 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_delete_dbax_desc_conc]    Fecha de la secuencia de comandos: 09/23/2013 12:11:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 09-04-2013
-- Description:	
-- =============================================
alter  procedure [dbo].[prc_delete_dbax_desc_conc]
            @P_CODI_CONC varchar(256), 
            @P_CODI_LANG varchar(50), 
            @P_PREF_CONC varchar(50) 
 AS
 BEGIN
        DELETE dbax_desc_conc
        WHERE codi_conc = @P_CODI_CONC 
        AND   codi_lang = @P_CODI_LANG 
        AND   pref_conc = @P_PREF_CONC 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_alter_dbax_desc_conc]    Fecha de la secuencia de comandos: 09/23/2013 12:11:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 09-04-2013
-- Description:	
-- =============================================
alter  procedure [dbo].[prc_alter_dbax_desc_conc]
            @P_PREF_CONC varchar(50), 
            @P_CODI_CONC varchar(256), 
            @P_CODI_LANG varchar(50), 
            @P_DESC_CONC varchar(512) 
 AS
 BEGIN
        INSERT INTO dbax_desc_conc(
            pref_conc, 
            codi_conc, 
            codi_lang, 
            desc_conc
        )
        VALUES
        (
             @P_PREF_CONC, 
             @P_CODI_CONC, 
             @P_CODI_LANG, 
             @P_DESC_CONC
        );
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getConcepInfo]    Fecha de la secuencia de comandos: 09/23/2013 12:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getConcepInfo] 
	@p_CodiEmex varchar(30),
	@p_CodiEmpr varchar(9),
	@p_CodiInfo varchar(100)
as
BEGIN
   select	A.pref_conc,
			D.codi_conc,
			A.orde_conc,
			D.desc_conc,
			A.nive_conc,
			A.negr_conc,
			CASE 
				WHEN	D.pref_conc = 'indi' THEN '~/librerias/img/text_italic.png'
				WHEN	D.pref_conc != 'indi' THEN '~/librerias/img/Transparencia.png'
			END	as imagen                  
   from		dbax_info_conc A, 
			dbax_defi_conc B, 
			dbax_desc_conc D
	where	A.codi_emex = @p_CodiEmex
	and		A.codi_empr = @p_CodiEmpr
	and		A.codi_info = @p_CodiInfo
	AND		A.pref_conc = B.pref_conc
	AND		A.codi_conc = B.codi_conc
	AND		B.pref_conc = D.pref_conc
	AND		B.codi_conc = D.codi_conc
	order by A.orde_conc
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_UpdaInstUnit]    Fecha de la secuencia de comandos: 09/23/2013 12:13:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter PROCEDURE [dbo].[SP_AX_UpdaInstUnit] (@pDescUnit varchar(50),@pCodiPers numeric(9,0),@pCorrInst numeric(10,0), @pVersInst numeric(5,0),@pCodiUnit varchar(50))
AS
BEGIN
update dbax_inst_unit set desc_unit =@pDescUnit  where codi_pers =@pCodiPers and corr_inst=@pCorrInst and vers_inst=@pVersInst and codi_unit=@pCodiUnit
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_insInstUnit]    Fecha de la secuencia de comandos: 09/23/2013 12:13:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter PROCEDURE [dbo].[SP_AX_insInstUnit] (@pCodiPers numeric(9,0),@pCorrInst numeric(10,0), @pVersInst numeric(5,0),@pCodiUnit varchar(50))
AS
BEGIN
insert into dbax_inst_unit (codi_pers, corr_inst, vers_inst, codi_unit) values (@pCodiPers,@pCorrInst,@pVersInst,@pCodiUnit)
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_empr_exte_alter]    Fecha de la secuencia de comandos: 09/23/2013 12:11:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas
-- alter date: <27-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_empr_exte_alter]
            @P_CODI_EMEX VARCHAR(30), 
            @P_NOMB_EMEX VARCHAR(80), 
            @P_STAT_EMEX VARCHAR(1), 
            @P_FEIN_EMEX datetime, 
            @P_FETE_EMEX datetime, 
            @P_OWNE_EMEX VARCHAR(30), 
            @P_PASS_EMEX VARCHAR(60), 
            @P_PATH_EMEX VARCHAR(80), 
            @P_HEAD_EMEX VARCHAR(80), 
            @P_SIDE_EMEX VARCHAR(80), 
            @P_BACK_EMEX VARCHAR(80), 
            @P_SPLA_EMEX VARCHAR(80), 
            @P_LOGO_EMEX VARCHAR(80), 
            @P_SWEB_EMEX VARCHAR(80), 
            @P_BANN_EMEX VARCHAR(80), 
            @P_URBA_EMEX VARCHAR(80), 
            @P_GINT_EMEX VARCHAR(80), 
            @P_INTR_EMEX VARCHAR(80), 
            @P_CODI_EMPR numeric(9, 0), 
            @P_PAGI_INIC VARCHAR(80), 
            @P_STRI_CONN VARCHAR(80), 
            @P_HABI_SITI VARCHAR(1), 
            @P_COLO_EMEX VARCHAR(80), 
            @P_COME_EMEX VARCHAR(80),
            @P_FORM_EMEX VARCHAR(80), 
            @P_SERV_SWEB VARCHAR(80), 
            @P_SERV_SREP VARCHAR(80), 
            @P_SERV_SCGI VARCHAR(80), 
            @P_IPWS_EMEX VARCHAR(30), 
            @P_PTWS_EMEX VARCHAR(30), 
            @P_USUA_DBSS VARCHAR(30), 
            @P_USUA_WEB VARCHAR(30), 
            @P_PASS_USUA_WEB VARCHAR(30), 
            @P_USUA_EUL VARCHAR(30), 
            @P_PASS_USUA_EUL VARCHAR(30), 
            @P_REPO_EMEX VARCHAR(30) 
 AS
 BEGIN
        INSERT INTO empr_exte(
            codi_emex, 			nomb_emex, 			stat_emex, 			fein_emex, 
            fete_emex, 			owne_emex, 			pass_emex, 			path_emex, 
            head_emex, 			side_emex, 			back_emex, 			spla_emex, 
            logo_emex, 			sweb_emex, 			bann_emex, 			urba_emex, 
            gint_emex, 			intr_emex, 			codi_empr, 			pagi_inic, 
            stri_conn, 			habi_siti, 			colo_emex, 			come_emex, 
            form_emex, 			serv_sweb, 			serv_srep, 			serv_scgi, 
            ipws_emex, 			ptws_emex, 			usua_dbss, 			usua_web, 
            pass_usua_web, 		usua_eul, 			pass_usua_eul, 		repo_emex
        )
        VALUES
        (
             @P_CODI_EMEX, 		@P_NOMB_EMEX, 		'1', 				GETDATE(), 
             CONVERT(DATETIME,'01/1/2500'), 		@P_OWNE_EMEX, 	@P_PASS_EMEX, 		@P_PATH_EMEX, 
             @P_HEAD_EMEX, 		@P_SIDE_EMEX, 		@P_BACK_EMEX, 		@P_SPLA_EMEX, 
             @P_LOGO_EMEX, 		@P_SWEB_EMEX, 		@P_BANN_EMEX, 		@P_URBA_EMEX, 
             @P_GINT_EMEX, 		@P_INTR_EMEX, 		@P_CODI_EMPR, 		@P_PAGI_INIC, 
             @P_STRI_CONN, 		@P_HABI_SITI, 		@P_COLO_EMEX, 		@P_COME_EMEX, 
             @P_FORM_EMEX, 		@P_SERV_SWEB, 		@P_SERV_SREP, 		@P_SERV_SCGI, 
             @P_IPWS_EMEX, 		@P_PTWS_EMEX, 		@P_USUA_DBSS, 		@P_USUA_WEB, 
             @P_PASS_USUA_WEB, 	@P_USUA_EUL, 		@P_PASS_USUA_EUL, 	@P_REPO_EMEX
        );
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_empr_exte_delete]    Fecha de la secuencia de comandos: 09/23/2013 12:11:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_empr_exte_delete]
            @P_CODI_EMEX VARCHAR(30) 
 AS
 BEGIN
        DELETE empr_exte
        WHERE codi_emex = @P_CODI_EMEX 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_empr_exte_update]    Fecha de la secuencia de comandos: 09/23/2013 12:11:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_empr_exte_update]
@P_CODI_EMEX VARCHAR(30), 
            @P_NOMB_EMEX VARCHAR(80), 
            @P_STAT_EMEX VARCHAR(1), 
            @P_FEIN_EMEX datetime, 
            @P_FETE_EMEX datetime, 
            @P_OWNE_EMEX VARCHAR(30), 
            @P_PASS_EMEX VARCHAR(60), 
            @P_PATH_EMEX VARCHAR(80), 
            @P_HEAD_EMEX VARCHAR(80), 
            @P_SIDE_EMEX VARCHAR(80), 
            @P_BACK_EMEX VARCHAR(80), 
            @P_SPLA_EMEX VARCHAR(80), 
            @P_LOGO_EMEX VARCHAR(80), 
            @P_SWEB_EMEX VARCHAR(80), 
            @P_BANN_EMEX VARCHAR(80), 
            @P_URBA_EMEX VARCHAR(80), 
            @P_GINT_EMEX VARCHAR(80), 
            @P_INTR_EMEX VARCHAR(80), 
            @P_CODI_EMPR numeric(9, 0), 
            @P_PAGI_INIC VARCHAR(80), 
            @P_STRI_CONN VARCHAR(80), 
            @P_HABI_SITI VARCHAR(1), 
            @P_COLO_EMEX VARCHAR(80), 
            @P_COME_EMEX VARCHAR(80),
            @P_FORM_EMEX VARCHAR(80), 
            @P_SERV_SWEB VARCHAR(80), 
            @P_SERV_SREP VARCHAR(80), 
            @P_SERV_SCGI VARCHAR(80), 
            @P_IPWS_EMEX VARCHAR(30), 
            @P_PTWS_EMEX VARCHAR(30), 
            @P_USUA_DBSS VARCHAR(30), 
            @P_USUA_WEB VARCHAR(30), 
            @P_PASS_USUA_WEB VARCHAR(30), 
            @P_USUA_EUL VARCHAR(30), 
            @P_PASS_USUA_EUL VARCHAR(30), 
            @P_REPO_EMEX VARCHAR(30) 
 AS
 BEGIN
	UPDATE empr_exte
		 SET nomb_emex = @P_NOMB_EMEX, 
			 stat_emex = @P_STAT_EMEX, 
			 fein_emex = @P_FEIN_EMEX, 
			 fete_emex = @P_FETE_EMEX,
			 owne_emex = @P_OWNE_EMEX,
			 pass_emex = @P_PASS_EMEX,
			 path_emex = @P_PATH_EMEX,
			 head_emex = @P_HEAD_EMEX,
			 side_emex = @P_SIDE_EMEX,
			 back_emex = @P_BACK_EMEX,
			 spla_emex = @P_SPLA_EMEX,
			 logo_emex = @P_LOGO_EMEX,
			 sweb_emex = @P_LOGO_EMEX,
			 bann_emex = @P_BANN_EMEX,
			 urba_emex = @P_URBA_EMEX,
			 gint_emex = @P_GINT_EMEX,
			 intr_emex = @P_INTR_EMEX,
			 codi_empr = @P_CODI_EMPR,
			 pagi_inic = @P_PAGI_INIC,
			 stri_conn = @P_STRI_CONN,
			 habi_siti = @P_HABI_SITI,
			 colo_emex = @P_COLO_EMEX,
			 come_emex = @P_COME_EMEX,
			 form_emex = @P_FORM_EMEX,
			 serv_sweb = @P_SERV_SWEB,
			 serv_srep = @P_SERV_SREP,
			 serv_scgi =  @P_serv_scgi,
			 ipws_emex = @P_IPWS_EMEX,
			 ptws_emex = @P_PTWS_EMEX,
			 usua_dbss = @P_USUA_DBSS,
			 usua_web  = @P_USUA_WEB,
 			 pass_usua_web = @P_PASS_USUA_WEB, 
			 usua_eul  = @P_USUA_EUL,
			 pass_usua_eul = @P_PASS_USUA_EUL,
			 repo_emex = @P_REPO_EMEX 
		 WHERE codi_emex = @P_CODI_EMEX 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getPersCorrVersInst]    Fecha de la secuencia de comandos: 09/23/2013 12:13:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getPersCorrVersInst](
	@pCodiPers varchar(30),
	@pCorrInst numeric(10,0),
	@pTipo varchar(1)='T') as
BEGIN
	if(@pTipo='T')
	begin
		select distinct vers_inst, vers_inst
		from	dbax_inst_vers
		where	codi_pers = @pCodiPers
		and		corr_inst = @pCorrInst
		order by 1 desc
	end 
	else if(@pTipo='M')
	begin
		select distinct top 1  isnull(max(vers_inst),'0'), isnull(max(vers_inst),'0')
		from	dbax_inst_vers
		where	codi_pers = @pCodiPers
		and		corr_inst = @pCorrInst
		order by 1 desc
	end
	else if(@pTipo='S')
		begin
			select distinct top 1 isnull(max(vers_inst),0) + 1, isnull(max(vers_inst),0) + 1
			from	dbax_inst_vers
			where	codi_pers = @pCodiPers
			and		corr_inst = @pCorrInst
			order by 1 desc
		end
END
GO
/****** Objeto:  UserDefinedFunction [dbo].[FU_AX_getUltimaVersion]    Fecha de la secuencia de comandos: 09/23/2013 12:13:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER function [dbo].[FU_AX_getUltimaVersion](
			@p_codi_empr numeric(10), 
			@p_fini_cntx varchar(50)) returns numeric(5,0)
begin
	declare @vVersion numeric(5,0)

	select @vVersion = max(vers_inst) from dbax_inst_vers where codi_pers = @p_codi_empr and corr_inst = @p_fini_cntx

	return @vVersion
end
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getCodigosEmpresa]    Fecha de la secuencia de comandos: 09/23/2013 12:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas	
-- alter date: 06052013
-- Description:	Procedimiento que obtiene los codigos de las empresas segun un correlativo instancia
-- =============================================
ALTER PROCEDURE [dbo].[SP_AX_getCodigosEmpresa]
	@p_corr_inst varchar(16)
AS
BEGIN
	SELECT	df.codi_pers as codi_pers, iv.vers_inst as vers_inst
	FROM	dbax_defi_pers df, 
			dbax_inst_vers iv
	WHERE	df.codi_pers = iv.codi_pers
	and		iv.corr_inst = @p_corr_inst;
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_GetVersInst]    Fecha de la secuencia de comandos: 09/23/2013 12:13:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter PROCEDURE [dbo].[SP_AX_GetVersInst] (
	@pCodiPers numeric(9,0),
	@pCorrInst numeric(10,0),
	@tipo varchar(3) = 'S')
AS
BEGIN
	if(@tipo='S')
	begin
		select	(isnull(max(vers_inst),0) + 1) vers_inst 
		from	dbax_inst_vers 
		where	codi_pers = @pCodiPers 
		and		corr_inst= @pCorrInst
	end
	else
	begin
		select	max(vers_inst) vers_inst 
		from	dbax_inst_vers 
		where	codi_pers = @pCodiPers 
		and		corr_inst= @pCorrInst
	end
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_insVersInst]    Fecha de la secuencia de comandos: 09/23/2013 12:13:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter PROCEDURE [dbo].[SP_AX_insVersInst] (@pCodiPers numeric(9,0),@pCorrInst numeric(10,0), @pVersInst numeric(5,0),@pDescVers varchar(256),@pCodiEsta varchar(3))
AS
BEGIN
insert into dbax_inst_vers (codi_pers, corr_inst, vers_inst,fech_carg, desc_vers, codi_esta) 
values (@pCodiPers,@pCorrInst,@pVersInst, substring (convert (varchar,getdate()), 0, 20) ,@pDescVers,@pCodiEsta)
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_GetEmpresasIndicadores]    Fecha de la secuencia de comandos: 09/23/2013 12:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_GetEmpresasIndicadores]
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
/****** Objeto:  StoredProcedure [dbo].[dbnet_message]    Fecha de la secuencia de comandos: 09/23/2013 12:11:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[dbnet_message] 
@p_codi_mess  numeric(22) ,
@p_desc_mess  varchar(200) output,
@p_tipo_mess  varchar(30) output
 as 
begin
if dbo.dbnet_get_cult() is not null 
begin
	select @p_desc_mess = s.desc_mess,@p_tipo_mess = s.tipo_mess
      	from sys_mess_cult s
      	where s.codi_mess = @p_codi_mess
      	and s.codi_cult = dbo.dbnet_get_cult()
end
begin
	select @p_desc_mess=isnull(@p_desc_mess,s.desc_mess),
		@p_tipo_mess=isnull(@p_tipo_mess,s.tipo_mess)
      	from sys_message s
      	where codi_mess = @p_codi_mess
 	if @@rowcount=0 
  		begin
  		set @p_desc_mess='Mensaje no esta registrado'
     		set @p_tipo_mess='Error'	
                return
  		end
end
end
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_GetScheInfo]    Fecha de la secuencia de comandos: 09/23/2013 12:13:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_AX_GetScheInfo] (@pScheInfo varchar(256))
AS
BEGIN
set @pScheInfo = replace(replace(@pScheInfo,'//','/'),':/','://')
select codi_info from dbax_taxo_info where sche_info = @pScheInfo 
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_alter_dbax_tipo_taxo]    Fecha de la secuencia de comandos: 09/23/2013 12:11:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 18-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_alter_dbax_tipo_taxo]
            @P_TIPO_TAXO varchar(10), 
            @P_DESC_TIPO varchar(50) 
 AS
 BEGIN
        INSERT INTO dbax_tipo_taxo(
            tipo_taxo, 
            desc_tipo
        )
        VALUES
        (
             @P_TIPO_TAXO, 
             @P_DESC_TIPO
        );
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_delete_dbax_tipo_taxo]    Fecha de la secuencia de comandos: 09/23/2013 12:11:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 12-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_delete_dbax_tipo_taxo]
            @P_TIPO_TAXO varchar(10) 
 AS
 BEGIN
        DELETE dbax_tipo_taxo
        WHERE tipo_taxo = @P_TIPO_TAXO 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_update_dbax_tipo_taxo]    Fecha de la secuencia de comandos: 09/23/2013 12:12:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 18-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_update_dbax_tipo_taxo]
            @P_TIPO_TAXO varchar(10), 
            @P_DESC_TIPO varchar(50) 
 AS
 BEGIN
        UPDATE dbax_tipo_taxo
             SET desc_tipo = @P_DESC_TIPO 
             WHERE tipo_taxo = @P_TIPO_TAXO 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getTiposTaxonomia]    Fecha de la secuencia de comandos: 09/23/2013 12:13:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getTiposTaxonomia] 
as
BEGIN
	select '' as tipo_taxo, '' as desc_tipo, '1'
	union
	select tipo_taxo, desc_tipo, 'n' from dbax_tipo_taxo order by 3, 2
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_GetDatosGrupo]    Fecha de la secuencia de comandos: 09/23/2013 12:13:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_GetDatosGrupo](
@pCodi_empr numeric(9,0),
@pCodi_emex varchar(30),
@pCode varchar(100))
as 
BEGIN
	select  B.codi_pers, B.desc_pers
	from dbax_pers_grup A, dbax_defi_pers B
    where A.codi_pers = B.codi_pers
    AND A.codi_empr = @pCodi_empr
    AND A.codi_emex = @pCodi_emex
    AND A.code = @pCode
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_update_dbax_defi_pers]    Fecha de la secuencia de comandos: 09/23/2013 12:12:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 18-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_update_dbax_defi_pers]
            @P_CODI_PERS numeric(9, 0), 
            @P_DESC_PERS varchar(100), 
            @P_CODI_GRUP varchar(50), 
            @P_CODI_SEGM varchar(50), 
            @P_TIPO_TAXO varchar(10), 
            @P_PRES_BURS varchar(30), 
            @P_EMIS_BONO varchar(2),
            @P_EMPR_VIGE varchar(10)
 AS
 BEGIN
        UPDATE dbax_defi_pers
             SET desc_pers = @P_DESC_PERS, 
                 codi_grup = @P_CODI_GRUP, 
                 codi_segm = @P_CODI_SEGM, 
                 tipo_taxo = @P_TIPO_TAXO, 
                 pres_burs = @P_PRES_BURS, 
                 emis_bono = @P_EMIS_BONO,
                 empr_vige = @P_EMPR_VIGE
             WHERE codi_pers = @P_CODI_PERS 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_delete_dbax_defi_pers]    Fecha de la secuencia de comandos: 09/23/2013 12:11:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 19-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_delete_dbax_defi_pers]
            @P_CODI_PERS numeric(9, 0) 
 AS
 BEGIN
        DELETE dbax_defi_pers
        WHERE codi_pers = @P_CODI_PERS 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_read_dbax_empresa]    Fecha de la secuencia de comandos: 09/23/2013 12:12:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas
-- alter date: 23-05-2013
-- Description:	Procedimiento Almacenado que Obtiene las empresas segun un segmento
-- =============================================
ALTER PROCEDURE [dbo].[prc_read_dbax_empresa]
(
	@p_corr_inst varchar(10),
	@p_codi_segm varchar(30)
)
AS
BEGIN
	select	distinct p.codi_pers, p.desc_pers, dc.pref_conc
	from	dbax_defi_conc dc,
			dbax_defi_pers p 
				left join dbax_inst_ramo id 
				on		p.codi_pers = id.codi_pers 
				and		id.corr_inst = @p_corr_inst
	where	p.codi_segm = @p_codi_segm
	and		p.tipo_taxo = dc.tipo_taxo
	
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_alter_dbax_defi_pers]    Fecha de la secuencia de comandos: 09/23/2013 12:11:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 19-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_alter_dbax_defi_pers]
            @P_CODI_PERS varchar(16), 
            @P_DESC_PERS varchar(100), 
            @P_CODI_GRUP varchar(50), 
            @P_CODI_SEGM varchar(50), 
            @P_TIPO_TAXO varchar(10), 
            @P_PRES_BURS varchar(30), 
            @P_EMIS_BONO varchar(2) ,
            @P_EMPR_VIGE VARCHAR(10)
 AS
 BEGIN
        INSERT INTO dbax_defi_pers(
            codi_pers, 
            desc_pers, 
            codi_grup, 
            codi_segm, 
            tipo_taxo, 
            pres_burs, 
            emis_bono,
            empr_vige
        )
        VALUES
        (
             @P_CODI_PERS, 
             @P_DESC_PERS, 
             @P_CODI_GRUP, 
             @P_CODI_SEGM, 
             @P_TIPO_TAXO, 
             @P_PRES_BURS, 
             @P_EMIS_BONO,
             @P_EMPR_VIGE
        );
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_GetFechaCntx]    Fecha de la secuencia de comandos: 09/23/2013 12:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_AX_GetFechaCntx](
@Codi_inst varchar(30),
@p_DiaMes varchar(50),
@p_Ano varchar(50))	
AS
BEGIN
	select dbo.FU_AX_getFechas(@Codi_inst , @p_DiaMes, @p_Ano) AS Fecha
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getInfoDefi]    Fecha de la secuencia de comandos: 09/23/2013 12:13:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 12-06-2013
-- Description:	procedimiento que retorna 1 informe seleccionado
-- =============================================
ALTER PROCEDURE [dbo].[SP_AX_getInfoDefi]
(
	@p_codi_emex varchar(30),
	@p_codi_empr numeric(9),
	@p_codi_info varchar(64)
)
AS
BEGIN
	SELECT codi_info, orde_info, tipo_taxo
	FROM dbax_info_defi
	where codi_emex = @p_codi_emex
	AND codi_empr = @p_codi_empr
	AND codi_info = @p_codi_info
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_list_valo]    Fecha de la secuencia de comandos: 09/23/2013 12:12:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 31-10-2012
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_list_valo](
@P_CODI_LV VARCHAR(10),
@P_CANT VARCHAR(2),
@P_CODI_PAR1 VARCHAR(64),
@P_CODI_PAR2 VARCHAR(64),
@P_CODI_PAR3 VARCHAR(64),
@P_CODI_PAR4 VARCHAR(64),
@P_CODI_PAR5 VARCHAR(64),
@p_codi_usua VARCHAR(30),
@P_CODI_EMPR INT,
@P_CODI_EMEX VARCHAR(30))
AS
BEGIN
	IF(@P_CODI_LV = 'PERS')
		BEGIN
			SELECT TOP(CONVERT(INT,@P_CANT)) CODI_PERS as CODIGO, NOMB_PERS as VALOR
			FROM PERSONAS
			WHERE 1 = 1
			AND NOMB_PERS LIKE '%' + @P_CODI_PAR1 + '%';
		END
	ELSE IF(@P_CODI_LV = 'USUA')
		BEGIN
		SELECT TOP(CONVERT(INT,@P_CANT)) CODI_USUA as CODIGO, NOMB_USUA as VALOR
			FROM USUA_SIST
			WHERE 1 = 1
			AND NOMB_USUA LIKE '%' + @P_CODI_PAR1 +  '%';
		END
	ELSE IF(@P_CODI_LV = 'EMPR')
		BEGIN
			SELECT TOP(CONVERT(INT,@P_CANT)) CODI_EMPR as CODIGO, NOMB_EMPR as VALOR
			FROM EMPR
			WHERE 1 = 1
			AND NOMB_EMPR LIKE '%' + @P_CODI_PAR1 +  '%';
		END
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_usua_sist_alter]    Fecha de la secuencia de comandos: 09/23/2013 12:13:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	<Author,,Aaron Rojas>
-- alter date: <alter Date,,2012-10-01>
-- Description:	Procedimiento para Insertar Nuevos Usuarios de Sistema
-- =============================================
ALTER  procedure [dbo].[prc_usua_sist_alter]
            @p_codi_usua VARCHAR(30), 
            @P_NOMB_USUA VARCHAR(80), 
            @P_CODI_PERS VARCHAR(16), 
            @P_CODI_ROUS VARCHAR(30), 
            @P_CODI_EMPR numeric(9, 0), 
            @P_FECH_USUA datetime, 
            @P_CODI_IMPR VARCHAR(25), 
            @P_CODI_OFIC VARCHAR(3), 
            @P_CODI_CECO VARCHAR(16), 
            @P_CODI_ZONA numeric(3, 0), 
            @P_CODI_MENU VARCHAR(30), 
            @P_NIVE_USUA VARCHAR(1), 
            @P_NOCO_USUA VARCHAR(30), 
            @P_PASS_USUA VARCHAR(30), 
            @P_TIPO_USUA VARCHAR(1), 
            @P_CODI_RAMO VARCHAR(12), 
            @P_FONO_USUA VARCHAR(30), 
            @P_LUGA_USUA VARCHAR(30), 
            @P_DIGI_USUA VARCHAR(1), 
            @P_CODI_DBST VARCHAR(30), 
            @P_FETE_USUA datetime, 
            @P_MAIL_USUA VARCHAR(80), 
            @P_CODI_EMEX VARCHAR(30), 
            @P_TIPO_FOLD VARCHAR(30), 
            @P_CODI_CULT VARCHAR(30), 
            @P_USUA_ACDI VARCHAR(30), 
            @P_USUA_ESTA VARCHAR(1),
            @P_USUA_CADU VARCHAR(1), 
            @P_ERRO_LOGI numeric(1, 0), 
            @P_USUA_NOCA VARCHAR(1), 
            @P_USUA_FILT VARCHAR(1) 
 AS
 BEGIN
        INSERT INTO usua_sist(
            codi_usua, 		nomb_usua, 		codi_pers, 		codi_rous, 
            codi_empr, 		fech_usua, 		codi_impr, 		codi_ofic, 
            codi_ceco, 		codi_zona, 		codi_menu, 		nive_usua, 
            noco_usua, 		pass_usua, 		tipo_usua, 		codi_ramo, 
            fono_usua, 		luga_usua, 		digi_usua, 		codi_dbst, 
            fete_usua, 		mail_usua, 		codi_emex, 		tipo_fold, 
            codi_cult, 		usua_acdi, 		usua_esta, 		fech_vige, 
            usua_cadu, 		erro_logi, 		usua_noca, 		usua_filt
        )
        VALUES
        (
             @p_codi_usua, 	@P_NOMB_USUA, 	@P_CODI_PERS, 	@P_CODI_ROUS, 
             @P_CODI_EMPR, 	@P_FECH_USUA, 	@P_CODI_IMPR, 	@P_CODI_OFIC, 
             @P_CODI_CECO, 	@P_CODI_ZONA, 	@P_CODI_MENU, 	@P_NIVE_USUA, 
             @P_NOCO_USUA, 	@P_PASS_USUA, 	@P_TIPO_USUA, 	@P_CODI_RAMO, 
             @P_FONO_USUA, 	@P_LUGA_USUA, 	@P_DIGI_USUA, 	@P_CODI_DBST, 
             @P_FETE_USUA, 	@P_MAIL_USUA, 	@P_CODI_EMEX, 	@P_TIPO_FOLD, 
             @P_CODI_CULT, 	@P_USUA_ACDI, 	@P_USUA_ESTA, 	GETDATE(), 
             @P_USUA_CADU, 	@P_ERRO_LOGI, 	@P_USUA_NOCA, 	@P_USUA_FILT
        );
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_usua_cadu_update]    Fecha de la secuencia de comandos: 09/23/2013 12:12:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 04-12-2012	
-- Description:	Procedimiento que caduca el estado de un usuario
-- =============================================
ALTER PROCEDURE [dbo].[prc_usua_cadu_update]
@p_codi_usua VARCHAR(30),
@P_USUA_CADU VARCHAR(30)
AS
BEGIN

	UPDATE usua_sist  
	SET		erro_logi = 0, 
			usua_cadu = @P_USUA_CADU 
	WHERE  codi_usua=@p_codi_usua;
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_vali_usua_read]    Fecha de la secuencia de comandos: 09/23/2013 12:13:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 27-11-2012
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_vali_usua_read]
@p_codi_usua VARCHAR(30)
AS
BEGIN
	SELECT COUNT(CODI_USUA) P_VALUE FROM USUA_SIST WHERE CODI_USUA = @p_codi_usua;
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_usua_sist_delete]    Fecha de la secuencia de comandos: 09/23/2013 12:13:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	<Author,,Aaron Rojas>
-- alter date: <alter Date,,2012-10-01>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_usua_sist_delete]
(
@p_codi_usua VARCHAR(30),
@P_CODI_EMEX VARCHAR(30),
@P_CODI_EMPR numeric(9,0)
)AS
BEGIN
	DELETE FROM usua_sist 
	WHERE codi_usua = @p_codi_usua
	and codi_emex = @P_CODI_EMEX
	and codi_empr = @P_CODI_EMPR;
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_usua_sist_update]    Fecha de la secuencia de comandos: 09/23/2013 12:13:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	<Author,,Aaron Rojas>
-- alter date: <alter Date,,2012-10-01>
-- Description:	<Description,,>
-- =============================================
ALTER procedure [dbo].[prc_usua_sist_update]
            @p_codi_usua VARCHAR(30), 
            @P_NOMB_USUA VARCHAR(80), 
            @P_CODI_PERS VARCHAR(16), 
            @P_CODI_ROUS VARCHAR(30), 
            @P_CODI_EMPR numeric(9, 0), 
            @P_FECH_USUA datetime, 
            @P_CODI_IMPR VARCHAR(25), 
            @P_CODI_OFIC VARCHAR(3), 
            @P_CODI_CECO VARCHAR(16), 
            @P_CODI_ZONA numeric(3, 0), 
            @P_CODI_MENU VARCHAR(30), 
            @P_NIVE_USUA VARCHAR(1), 
            @P_NOCO_USUA VARCHAR(30), 
            @P_PASS_USUA VARCHAR(30), 
            @P_TIPO_USUA VARCHAR(1), 
            @P_CODI_RAMO VARCHAR(12), 
            @P_FONO_USUA VARCHAR(30), 
            @P_LUGA_USUA VARCHAR(30), 
            @P_DIGI_USUA VARCHAR(1), 
            @P_CODI_DBST VARCHAR(30), 
            @P_FETE_USUA datetime, 
            @P_MAIL_USUA VARCHAR(80), 
            @P_CODI_EMEX VARCHAR(30), 
            @P_TIPO_FOLD VARCHAR(30), 
            @P_CODI_CULT VARCHAR(30), 
            @P_USUA_FILT VARCHAR(1), 
            @P_USUA_ESTA VARCHAR(1), 
            @P_FECH_VIGE VARCHAR(20), 
            @P_USUA_CADU VARCHAR(1), 
            @P_ERRO_LOGI numeric(2, 0), 
            @P_USUA_ACDI VARCHAR(30), 
            @P_USUA_NOCA VARCHAR(1) 
 AS
 BEGIN
        UPDATE usua_sist
             SET nomb_usua = @P_NOMB_USUA, 
                 codi_pers = @P_CODI_PERS, 
                 codi_rous = @P_CODI_ROUS, 
                 codi_empr = @P_CODI_EMPR, 
                 fech_usua = @P_FECH_USUA, 
                 codi_impr = @P_CODI_IMPR, 
                 codi_ofic = @P_CODI_OFIC, 
                 codi_ceco = @P_CODI_CECO, 
                 codi_zona = @P_CODI_ZONA, 
                 codi_menu = @P_CODI_MENU, 
                 nive_usua = @P_NIVE_USUA, 
                 noco_usua = @P_NOCO_USUA, 
                 pass_usua = @P_PASS_USUA, 
                 tipo_usua = @P_TIPO_USUA, 
                 codi_ramo = @P_CODI_RAMO, 
                 fono_usua = @P_FONO_USUA, 
                 luga_usua = @P_LUGA_USUA, 
                 digi_usua = @P_DIGI_USUA, 
                 codi_dbst = @P_CODI_DBST, 
                 fete_usua = @P_FETE_USUA, 
                 mail_usua = @P_MAIL_USUA, 
                 codi_emex = @P_CODI_EMEX, 
                 tipo_fold = @P_TIPO_FOLD, 
                 codi_cult = @P_CODI_CULT, 
                 usua_filt = @P_USUA_FILT, 
                 usua_esta = @P_USUA_ESTA, 
                 fech_vige = @P_FECH_VIGE, 
                 usua_cadu = @P_USUA_CADU, 
                 erro_logi = @P_ERRO_LOGI, 
                 usua_acdi = @P_USUA_ACDI, 
                 usua_noca = @P_USUA_NOCA
             WHERE codi_usua = @p_codi_usua 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_erro_logi_update]    Fecha de la secuencia de comandos: 09/23/2013 12:11:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 27-11-2012
-- Description:	Procedimiento que se ejecuta cuando el usuario se conecta sin problemas
-- =============================================
ALTER PROCEDURE [dbo].[prc_erro_logi_update]
@p_codi_usua VARCHAR(30)
AS
BEGIN
	update usua_sist set erro_logi = 0 where codi_usua = @p_codi_usua;
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_cambiaPassDemo]    Fecha de la secuencia de comandos: 09/23/2013 12:13:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_AX_cambiaPassDemo]
(
	@pPassEnc varchar(100) = 'nopfCGGNK1'
)
AS
	--'nopfCGGNK1' = dbax1860
BEGIN TRY
	update usua_sist set pass_usua = @pPassEnc where codi_usua like 'demo[1,2,3,4,5]'
END TRY
BEGIN CATCH
	select 'Error'
END CATCH
GO
/****** Objeto:  StoredProcedure [dbo].[prc_erro_logi_read]    Fecha de la secuencia de comandos: 09/23/2013 12:11:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas
-- alter date: 28-11-2012
-- Description:	procedimiento Almacenado que retorna cuantas veces se a INTEGERentado loguear un usuario con la contraseña incorrecta
-- =============================================
ALTER PROCEDURE [dbo].[prc_erro_logi_read]
@p_codi_usua VARCHAR(30)
AS
BEGIN
	SELECT isnull(max(erro_logi),0) + 1  ERRO_LOGI FROM usua_sist where codi_usua = @p_codi_usua;
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_fech_vige_usua_read]    Fecha de la secuencia de comandos: 09/23/2013 12:12:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 28-11-2012
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_fech_vige_usua_read]
@p_codi_usua VARCHAR(30)
AS
BEGIN
	select	datediff(day, getdate(), fech_vige) fech_vige from	usua_sist where	codi_usua = @p_codi_usua;
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_erro_logi2_update]    Fecha de la secuencia de comandos: 09/23/2013 12:11:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 28-11-2012
-- Description:	Procedimiento que se Ejecuta cuando el Usuario a INTEGERentado con claves erroneas loguearse
-- =============================================
ALTER PROCEDURE [dbo].[prc_erro_logi2_update]
@p_codi_usua VARCHAR(30)
AS
BEGIN
	update usua_sist set erro_logi = erro_logi + 1 where codi_usua = @p_codi_usua;
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_fech_vige_read]    Fecha de la secuencia de comandos: 09/23/2013 12:11:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas
-- alter date: 27-11-2012
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_fech_vige_read]
@p_codi_usua VARCHAR(30)
AS
BEGIN
	select isnull(max(1),0) vige from usua_sist where codi_usua = @p_codi_usua and	fech_vige < getdate()
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_usua_esta_update]    Fecha de la secuencia de comandos: 09/23/2013 12:13:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 27-11-2012
-- Description:	Procedimiento que Modifica el Estado de un usuario cuando caduca su clave
-- =============================================
ALTER PROCEDURE [dbo].[prc_usua_esta_update]
@p_codi_usua VARCHAR(30),
@P_USUA_ESTA VARCHAR(1)
AS
BEGIN
	UPDATE USUA_SIST SET usua_esta = @P_USUA_ESTA WHERE CODI_USUA = @p_codi_usua;
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_pass_usua_update]    Fecha de la secuencia de comandos: 09/23/2013 12:12:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 03-12-2012
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_pass_usua_update]
(@p_codi_usua VARCHAR(30),
@P_DIAS_VIGE INT,
@P_PASS_USUA VARCHAR(128))
AS
BEGIN
	UPDATE USUA_SIST
	SET		PASS_USUA = @P_PASS_USUA,
			FECH_VIGE = DATEADD(day,@P_DIAS_VIGE,GETDATE()),
			USUA_CADU = 'N',
			ERRO_LOGI = 0
			WHERE CODI_USUA = @p_codi_usua;
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_usua_esta_read]    Fecha de la secuencia de comandos: 09/23/2013 12:13:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_usua_esta_read]
	@p_codi_usua VARCHAR(30)
AS
BEGIN
	SELECT usua_esta FROM usua_sist WHERE codi_usua = @p_codi_usua;
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_cate_repo_read]    Fecha de la secuencia de comandos: 09/23/2013 12:11:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas
-- alter date: 09072013
-- Description:	Procedimiento que obtiene las categorias para los listadores
-- =============================================
ALTER PROCEDURE [dbo].[prc_cate_repo_read]
AS
BEGIN
	SELECT '' as CODIGO, 'Seleccione' as VALOR
	union
	select code as CODIGO, code_desc as VALOR
	from sys_code
	where domain_code = '751'
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_sys_code_categoria]    Fecha de la secuencia de comandos: 09/23/2013 12:12:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas
-- alter date: 09072013
-- Description:	Procedimiento que obtiene las categorias para los listadores
-- =============================================
ALTER PROCEDURE [dbo].[prc_sys_code_categoria]
AS
BEGIN
	SELECT '' as CODIGO, 'Seleccione' as VALOR
	union
	select code as CODIGO, code_desc as VALOR
	from sys_code
	where domain_code = '751'
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_Ins_GrupoEmpr]    Fecha de la secuencia de comandos: 09/23/2013 12:13:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_AX_Ins_GrupoEmpr] (
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
/****** Objeto:  StoredProcedure [dbo].[SP_AX_Elimina_grilla_grupo]    Fecha de la secuencia de comandos: 09/23/2013 12:13:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_Elimina_grilla_grupo] 
@p_code_desc varchar(100)
 as
BEGIN

delete sys_code where code_desc = @p_code_desc 
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_sys_code_alter]    Fecha de la secuencia de comandos: 09/23/2013 12:12:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 31-01-2013
-- Description:	<Description,,>
-- =============================================
alter  procedure [dbo].[prc_sys_code_alter]
            @P_CODE VARCHAR(12), 
            @P_CODE_DESC VARCHAR(50), 
            @P_DOMAIN_CODE numeric(4, 0), 
            @P_CODE_AUX VARCHAR(30), 
            @P_CODE_DELE VARCHAR(1) 
 AS
 BEGIN
        INSERT INTO sys_code(
            code, 
            code_desc, 
            domain_code, 
            code_aux, 
            code_dele
        )
        VALUES
        (
             @P_CODE, 
             @P_CODE_DESC, 
             @P_DOMAIN_CODE, 
             @P_CODE_AUX, 
             @P_CODE_DELE
        );
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_sys_code_delete]    Fecha de la secuencia de comandos: 09/23/2013 12:12:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 31-01-2013
-- Description:	<Description,,>
-- =============================================
alter  procedure [dbo].[prc_sys_code_delete]
            @P_DOMAIN_CODE numeric(4, 0), 
            @P_CODE VARCHAR(12) 
 AS
 BEGIN
        DELETE sys_code
        WHERE domain_code = @P_DOMAIN_CODE 
        AND   code = @P_CODE 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_sys_code_update]    Fecha de la secuencia de comandos: 09/23/2013 12:12:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 31-01-2013
-- Description:	<Description,,>
-- =============================================
alter  procedure [dbo].[prc_sys_code_update]
            @P_CODE VARCHAR(12), 
            @P_CODE_DESC VARCHAR(50), 
            @P_DOMAIN_CODE numeric(4, 0), 
            @P_CODE_AUX VARCHAR(30), 
            @P_CODE_DELE VARCHAR(1) 
 AS
 BEGIN
        UPDATE sys_code
             SET code_desc = @P_CODE_DESC, 
                 code_aux = @P_CODE_AUX, 
                 code_dele = @P_CODE_DELE
             WHERE domain_code = @P_DOMAIN_CODE 
             AND   code = @P_CODE 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_InsertaGrupo]    Fecha de la secuencia de comandos: 09/23/2013 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_AX_InsertaGrupo] (
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
/****** Objeto:  StoredProcedure [dbo].[SP_AX_Upd_grupo_Empr]    Fecha de la secuencia de comandos: 09/23/2013 12:13:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_AX_Upd_grupo_Empr](
@pCodi_empr numeric(9,0),
@pCodi_Emex varchar(30),
@pDes_grup varchar(200),
@pCodi_grup varchar(200))
AS
BEGIN

update sys_code
set code_desc = @pDes_grup
where code = @pCodi_grup 

END
GO
/****** Objeto:  StoredProcedure [dbo].[BORRAR_SP_AX_getConceptos]    Fecha de la secuencia de comandos: 09/23/2013 12:11:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[BORRAR_SP_AX_getConceptos](
	@pFiltro_Concepto varchar(100),
	@pTipoConc varchar(4)='200')
as
BEGIN
	   select	D.codi_conc,
				D.desc_conc
	   from		dbax_defi_conc B, 
				dbax_desc_conc D,
				sys_code s
	   where	B.pref_conc = D.pref_conc
				AND B.codi_conc = D.codi_conc
				and desc_conc like '%'+ @pFiltro_Concepto  +'%'
				and s.domain_code = @pTipoConc
				and B.tipo_valo = s.code
       order by  D.desc_conc
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_usua_empr_alter]    Fecha de la secuencia de comandos: 09/23/2013 12:12:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
alter  procedure [dbo].[prc_usua_empr_alter]
            @p_codi_usua VARCHAR(30), 
            @P_CODI_EMPR numeric(9, 0), 
            @P_CODI_OFIC VARCHAR(3) 
 AS
 BEGIN
        INSERT INTO usua_empr(
            codi_usua, 
            codi_empr, 
            codi_ofic
        )
        VALUES
        (
             @p_codi_usua, 
             @P_CODI_EMPR, 
             @P_CODI_OFIC
        );
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_usua_empr_delete]    Fecha de la secuencia de comandos: 09/23/2013 12:12:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
alter  procedure [dbo].[prc_usua_empr_delete]
            @P_CODI_EMPR numeric(9, 0), 
            @p_codi_usua VARCHAR(30) 
 AS
 BEGIN
        DELETE usua_empr
        WHERE codi_empr = @P_CODI_EMPR 
        AND   codi_usua = @p_codi_usua 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_usua_empr_update]    Fecha de la secuencia de comandos: 09/23/2013 12:13:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
alter  procedure [dbo].[prc_usua_empr_update]
            @p_codi_usua VARCHAR(30), 
            @P_CODI_EMPR numeric(9, 0), 
            @P_CODI_OFIC VARCHAR(3) 
 AS
 BEGIN
        UPDATE usua_empr
             SET codi_ofic = @P_CODI_OFIC 
             WHERE codi_empr = @P_CODI_EMPR 
             AND   codi_usua = @p_codi_usua 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_sys_domain_alter]    Fecha de la secuencia de comandos: 09/23/2013 12:12:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 31-01-2013
-- Description:	<Description,,>
-- =============================================
ALTER  PROCEDURE [dbo].[prc_sys_domain_alter]
            @P_DOMAIN_CODE numeric(4, 0), 
            @P_DOMAIN_NAME VARCHAR(20), 
            @P_DOMAIN_LENGTH numeric(2, 0), 
            @P_DOMAIN_TYPE VARCHAR(1), 
            @P_DOMAIN_SHOW VARCHAR(1), 
            @P_DOMAIN_CLASS VARCHAR(1), 
            @P_DOMAIN_LOW VARCHAR(12), 
            @P_DOMAIN_HIGHT VARCHAR(12), 
            @P_DOMAIN_VIEW VARCHAR(30), 
            @P_DOMAIN_SCLASS VARCHAR(1), 
            @P_DOMAIN_QUERY VARCHAR(1), 
            @P_DOMAIN_AUX VARCHAR(1), 
            @P_DOMAIN_AUXLABEL VARCHAR(15) 
 AS
 BEGIN
        INSERT INTO sys_domain(
            domain_code, 		domain_name, 		domain_length, 		domain_type, 
            domain_show, 		domain_class, 		domain_low, 		domain_hight, 
            domain_view, 		domain_sclass, 		domain_query, 		domain_aux, 
            domain_auxlabel
        )
        VALUES
        (
             @P_DOMAIN_CODE, 	@P_DOMAIN_NAME, 	@P_DOMAIN_LENGTH, 	@P_DOMAIN_TYPE, 
             @P_DOMAIN_SHOW, 	@P_DOMAIN_CLASS, 	@P_DOMAIN_LOW, 		@P_DOMAIN_HIGHT, 
             @P_DOMAIN_VIEW, 	@P_DOMAIN_SCLASS, 	@P_DOMAIN_QUERY, 	@P_DOMAIN_AUX, 
             @P_DOMAIN_AUXLABEL
		 );
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_sys_domain_update]    Fecha de la secuencia de comandos: 09/23/2013 12:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 31-01-2013
-- Description:	<Description,,>
-- =============================================
ALTER  PROCEDURE [dbo].[prc_sys_domain_update]
            @P_DOMAIN_CODE numeric(4, 0), 
            @P_DOMAIN_NAME VARCHAR(20), 
            @P_DOMAIN_LENGTH numeric(2, 0), 
            @P_DOMAIN_TYPE VARCHAR(1), 
            @P_DOMAIN_SHOW VARCHAR(1), 
            @P_DOMAIN_CLASS VARCHAR(1), 
            @P_DOMAIN_LOW VARCHAR(12), 
            @P_DOMAIN_HIGHT VARCHAR(12), 
            @P_DOMAIN_VIEW VARCHAR(30), 
            @P_DOMAIN_SCLASS VARCHAR(1), 
            @P_DOMAIN_QUERY VARCHAR(1), 
            @P_DOMAIN_AUX VARCHAR(1), 
            @P_DOMAIN_AUXLABEL VARCHAR(15) 
 AS
 BEGIN
        UPDATE sys_domain
             SET domain_name = @P_DOMAIN_NAME, 
                 domain_length = @P_DOMAIN_LENGTH, 
                 domain_type = @P_DOMAIN_TYPE, 
                 domain_show = @P_DOMAIN_SHOW, 
                 domain_class = @P_DOMAIN_CLASS, 
                 domain_low = @P_DOMAIN_LOW, 
                 domain_hight = @P_DOMAIN_HIGHT, 
                 domain_view = @P_DOMAIN_VIEW, 
                 domain_sclass = @P_DOMAIN_SCLASS, 
                 domain_query = @P_DOMAIN_QUERY, 
                 domain_aux = @P_DOMAIN_AUX, 
                 domain_auxlabel = @P_DOMAIN_AUXLABEL
             WHERE domain_code = @P_DOMAIN_CODE 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_sys_domain_delete]    Fecha de la secuencia de comandos: 09/23/2013 12:12:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 31-01-2013
-- Description:	<Description,,>
-- =============================================
ALTER  PROCEDURE [dbo].[prc_sys_domain_delete]
            @P_DOMAIN_CODE numeric(4, 0) 
 AS
 BEGIN
        DELETE sys_domain
        WHERE domain_code = @P_DOMAIN_CODE 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_sys_furo_menu_rol]    Fecha de la secuencia de comandos: 09/23/2013 12:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 13-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_sys_furo_menu_rol]
(
	@P_CODI_MODU VARCHAR(16),
	@P_CODI_ROUS VARCHAR(16)
)
AS
BEGIN
	select	object_brief,	object_prog,	object_type,	object_level, 
			object_rela,	par0,			val0,			par1,
			val1,			par2,			val2    
	from	sys_furo 
	where	codi_modu = @P_CODI_MODU
	and		codi_rous = @P_CODI_ROUS
    order by object_orun;
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_sys_furo_delete]    Fecha de la secuencia de comandos: 09/23/2013 12:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 31-01-2013
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_sys_furo_delete] (
	@P_CODI_MODU VARCHAR(30),
	@P_CODI_ROUS VARCHAR(30)
)
AS
BEGIN
	delete from sys_furo where codi_modu = @P_CODI_MODU and codi_rous= @P_CODI_ROUS;
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getPrefConc ]    Fecha de la secuencia de comandos: 09/23/2013 12:13:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getPrefConc ]
@pTipoTaxo varchar(10) = ''
as
BEGIN
	declare @vComodinTipo varchar(1)

	set @vComodinTipo = '%'

	if ( @pTipoTaxo != '')
	begin
		set @vComodinTipo = ''
	end

	select distinct pref_conc,pref_conc 
	from dbax_defi_conc 
	where tipo_taxo like @vComodinTipo + @pTipoTaxo + @vComodinTipo
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getPrefConcPorCodiConc]    Fecha de la secuencia de comandos: 09/23/2013 12:13:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26-06-2013
-- Description:	Procedimiento que retorna el prefijo del concepto, codigo y tipo de taxonomía
-- =============================================
ALTER PROCEDURE [dbo].[SP_AX_getPrefConcPorCodiConc]
	@p_codi_conc varchar(256)
AS
BEGIN
	select pref_conc, codi_conc, tipo_taxo
	from dbax_defi_conc
	where codi_conc = @p_codi_conc
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_alter_dbax_defi_conc]    Fecha de la secuencia de comandos: 09/23/2013 12:11:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 08-04-2013
-- Description:	<Description,,>
-- =============================================
alter  procedure [dbo].[prc_alter_dbax_defi_conc]
            @P_PREF_CONC varchar(50), 
            @P_CODI_CONC varchar(256), 
            @P_TIPO_CONC varchar(20), 
            @P_TIPO_PERI varchar(15), 
            @P_TIPO_VALO varchar(256), 
            @P_TIPO_CUEN varchar(10), 
            @P_CODI_NUME varchar(25), 
            @P_TIPO_TAXO varchar(10) 
 AS
 BEGIN
        INSERT INTO dbax_defi_conc(
            pref_conc, 
            codi_conc, 
            tipo_conc, 
            tipo_peri, 
            tipo_valo, 
            tipo_cuen, 
            codi_nume, 
            tipo_taxo
        )
        VALUES
        (
             @P_PREF_CONC, 
             @P_CODI_CONC, 
             @P_TIPO_CONC, 
             @P_TIPO_PERI, 
             @P_TIPO_VALO, 
             @P_TIPO_CUEN, 
             @P_CODI_NUME, 
             @P_TIPO_TAXO
        );
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_delete_dbax_defi_conc]    Fecha de la secuencia de comandos: 09/23/2013 12:11:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 08-04-2013
-- Description:	<Description,,>
-- =============================================
alter  procedure [dbo].[prc_delete_dbax_defi_conc]
            @P_CODI_CONC varchar(256), 
            @P_PREF_CONC varchar(50) 
 AS
 BEGIN
        DELETE dbax_defi_conc
        WHERE codi_conc = @P_CODI_CONC 
        AND   pref_conc = @P_PREF_CONC 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_update_dbax_defi_conc]    Fecha de la secuencia de comandos: 09/23/2013 12:12:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 08-04-2013
-- Description:	<Description,,>
-- =============================================
alter  procedure [dbo].[prc_update_dbax_defi_conc]
            @P_PREF_CONC varchar(50), 
            @P_CODI_CONC varchar(256), 
            @P_TIPO_CONC varchar(20), 
            @P_TIPO_PERI varchar(15), 
            @P_TIPO_VALO varchar(256), 
            @P_TIPO_CUEN varchar(10), 
            @P_CODI_NUME varchar(25), 
            @P_TIPO_TAXO varchar(10) 
 AS
 BEGIN
        UPDATE dbax_defi_conc
             SET tipo_conc = @P_TIPO_CONC, 
                 tipo_peri = @P_TIPO_PERI, 
                 tipo_valo = @P_TIPO_VALO, 
                 tipo_cuen = @P_TIPO_CUEN, 
                 codi_nume = @P_CODI_NUME, 
                 tipo_taxo = @P_TIPO_TAXO
             WHERE codi_conc = @P_CODI_CONC 
             AND   pref_conc = @P_PREF_CONC 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_personas_alter]    Fecha de la secuencia de comandos: 09/23/2013 12:12:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_personas_alter]
            @P_CODI_EMEX VARCHAR(30), 
            @P_CODI_PERS VARCHAR(16), 
            @P_NOMB_PERS VARCHAR(80), 
            @P_RUTT_PERS numeric(9, 0), 
            @P_DGTO_PERS VARCHAR(1), 
            @P_DIRE_PERS VARCHAR(80), 
            @P_CODI_COMU VARCHAR(8), 
            @P_FONO_PERS VARCHAR(30), 
            @P_CLIE_PERS VARCHAR(1), 
            @P_PROV_PERS VARCHAR(1), 
            @P_COMP_PERS VARCHAR(1), 
            @P_EMPL_PERS VARCHAR(1), 
            @P_CODI_PERS1 VARCHAR(16), 
            @P_PERS_SELE VARCHAR(1), 
            @P_EMPR_PERS VARCHAR(1), 
            @P_PREF_PERS VARCHAR(6), 
            @P_FUNC_PERS VARCHAR(3), 
            @P_CODI_RAMO VARCHAR(12), 
            @P_FECH_PERS datetime, 
            @P_COME_PERS VARCHAR(1000), 
            @P_CODI_PAIS VARCHAR(2), 
            @P_CODI_CECO VARCHAR(16), 
            @P_CODI_MAIL VARCHAR(50), 
            @P_NFAN_PERS VARCHAR(40), 
            @P_CODI_ECIV VARCHAR(3), 
            @P_CODI_PROF VARCHAR(3), 
            @P_SEXO_PERS VARCHAR(1), 
            @P_ORIG_PERS VARCHAR(2), 
            @P_ACCI_PERS VARCHAR(1), 
            @P_TIPO_DESC VARCHAR(3), 
            @P_FIRM_PERS VARCHAR(1),
            @P_CODI_MAIL1 VARCHAR(50), 
            @P_CODI_MAIL2 VARCHAR(50), 
            @P_CODI_MAIL3 VARCHAR(50), 
            @P_CODI_MAIL4 VARCHAR(50), 
            @P_AUTO_CESI VARCHAR(1), 
            @P_ASUN_FACT_PERS VARCHAR(200), 
            @P_TEXT_FACT_PERS VARCHAR(2000), 
            @P_MODI_DOCU VARCHAR(1), 
            @P_CODI_OFIC VARCHAR(3),
            @P_CODI_EMPR INTEGER
 AS
 BEGIN
        INSERT INTO personas(
            codi_emex, 			codi_pers, 			nomb_pers, 			rutt_pers, 
            dgto_pers, 			dire_pers, 			codi_comu, 			fono_pers, 
            clie_pers, 			prov_pers, 			comp_pers, 			empl_pers, 
            codi_pers1, 		pers_sele, 			empr_pers, 			pref_pers, 
            func_pers, 			codi_ramo, 			fech_pers, 			come_pers, 
            codi_pais, 			codi_ceco, 			codi_mail, 			nfan_pers, 
            codi_eciv, 			codi_prof, 			sexo_pers, 			orig_pers, 
            acci_pers, 			tipo_desc, 			codi_mail1, 		codi_mail2, 
            codi_mail3, 		codi_mail4, 		auto_cesi, 			asun_fact_pers, 
            text_fact_pers, 	modi_docu, 			codi_ofic,			codi_empr
        )
		VALUES
        (
             @P_CODI_EMEX, 		@P_CODI_PERS, 		@P_NOMB_PERS, 		@P_RUTT_PERS, 
             @P_DGTO_PERS, 		@P_DIRE_PERS, 		@P_CODI_COMU, 		@P_FONO_PERS, 
             @P_CLIE_PERS, 		@P_PROV_PERS, 		@P_COMP_PERS, 		@P_EMPL_PERS, 
             @P_CODI_PERS1, 	@P_PERS_SELE, 		@P_EMPR_PERS, 		@P_PREF_PERS, 
             @P_FUNC_PERS, 		@P_CODI_RAMO, 		@P_FECH_PERS, 		@P_COME_PERS, 
             @P_CODI_PAIS, 		@P_CODI_CECO, 		@P_CODI_MAIL, 		@P_NFAN_PERS, 
             @P_CODI_ECIV, 		@P_CODI_PROF, 		@P_SEXO_PERS, 		@P_ORIG_PERS, 
             @P_ACCI_PERS, 		@P_TIPO_DESC, 		@P_CODI_MAIL1, 		@P_CODI_MAIL2, 
             @P_CODI_MAIL3, 	@P_CODI_MAIL4, 		@P_AUTO_CESI, 		@P_ASUN_FACT_PERS, 
             @P_TEXT_FACT_PERS, @P_MODI_DOCU, 		@P_CODI_OFIC,		@P_CODI_EMPR
        );
	END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_personas_update]    Fecha de la secuencia de comandos: 09/23/2013 12:12:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
alter procedure [dbo].[prc_personas_update]
            @P_CODI_EMEX VARCHAR(30), 
            @P_CODI_PERS VARCHAR(16), 
            @P_NOMB_PERS VARCHAR(80), 
            @P_RUTT_PERS numeric(9, 0), 
            @P_DGTO_PERS VARCHAR(1), 
            @P_DIRE_PERS VARCHAR(80), 
            @P_CODI_COMU VARCHAR(8), 
            @P_FONO_PERS VARCHAR(30), 
            @P_CLIE_PERS VARCHAR(1), 
            @P_PROV_PERS VARCHAR(1), 
            @P_COMP_PERS VARCHAR(1), 
            @P_EMPL_PERS VARCHAR(1), 
            @P_CODI_PERS1 VARCHAR(16), 
            @P_PERS_SELE VARCHAR(1), 
            @P_EMPR_PERS VARCHAR(1), 
            @P_PREF_PERS VARCHAR(6), 
            @P_FUNC_PERS VARCHAR(3), 
            @P_CODI_RAMO VARCHAR(12), 
            @P_FECH_PERS datetime, 
            @P_COME_PERS VARCHAR(1000), 
            @P_CODI_PAIS VARCHAR(2), 
            @P_CODI_CECO VARCHAR(16), 
            @P_CODI_MAIL VARCHAR(50), 
            @P_NFAN_PERS VARCHAR(40), 
            @P_CODI_ECIV VARCHAR(3), 
            @P_CODI_PROF VARCHAR(3), 
            @P_SEXO_PERS VARCHAR(1), 
            @P_ORIG_PERS VARCHAR(2), 
            @P_ACCI_PERS VARCHAR(1), 
            @P_TIPO_DESC VARCHAR(3), 
            @P_FIRM_PERS VARCHAR(1),
            @P_CODI_MAIL1 VARCHAR(50), 
            @P_CODI_MAIL2 VARCHAR(50), 
            @P_CODI_MAIL3 VARCHAR(50), 
            @P_CODI_MAIL4 VARCHAR(50), 
            @P_AUTO_CESI VARCHAR(1), 
            @P_ASUN_FACT_PERS VARCHAR(200), 
            @P_TEXT_FACT_PERS VARCHAR(2000), 
            @P_MODI_DOCU VARCHAR(1), 
            @P_CODI_OFIC VARCHAR(3),
            @P_CODI_EMPR INTEGER
 AS
 BEGIN
        UPDATE personas
             SET nomb_pers = @P_NOMB_PERS, 
                 rutt_pers = @P_RUTT_PERS, 
                 dgto_pers = @P_DGTO_PERS, 
                 dire_pers = @P_DIRE_PERS, 
                 codi_comu = @P_CODI_COMU, 
                 fono_pers = @P_FONO_PERS, 
                 clie_pers = @P_CLIE_PERS, 
                 codi_empr = @P_CODI_EMPR,
                 prov_pers = @P_PROV_PERS, 
                 comp_pers = @P_COMP_PERS, 
                 empl_pers = @P_EMPL_PERS, 
                 codi_pers1 = @P_CODI_PERS1, 
                 pers_sele = @P_PERS_SELE, 
                 empr_pers = @P_EMPR_PERS, 
                 pref_pers = @P_PREF_PERS, 
                 func_pers = @P_FUNC_PERS, 
                 codi_ramo = @P_CODI_RAMO, 
                 fech_pers = @P_FECH_PERS, 
                 come_pers = @P_COME_PERS, 
                 codi_pais = @P_CODI_PAIS, 
                 codi_ceco = @P_CODI_CECO, 
                 codi_mail = @P_CODI_MAIL, 
                 nfan_pers = @P_NFAN_PERS, 
                 codi_eciv = @P_CODI_ECIV, 
                 codi_prof = @P_CODI_PROF, 
                 sexo_pers = @P_SEXO_PERS, 
                 orig_pers = @P_ORIG_PERS, 
                 acci_pers = @P_ACCI_PERS, 
                 tipo_desc = @P_TIPO_DESC, 
                 codi_mail1 = @P_CODI_MAIL1, 
                 codi_mail2 = @P_CODI_MAIL2, 
                 codi_mail3 = @P_CODI_MAIL3, 
                 codi_mail4 = @P_CODI_MAIL4, 
                 auto_cesi = @P_AUTO_CESI, 
                 asun_fact_pers = @P_ASUN_FACT_PERS, 
                 text_fact_pers = @P_TEXT_FACT_PERS, 
                 modi_docu = @P_MODI_DOCU, 
                 codi_ofic = @P_CODI_OFIC
             WHERE codi_emex = @P_CODI_EMEX 
             AND   codi_pers = @P_CODI_PERS 
 END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_RescEmrInfor]    Fecha de la secuencia de comandos: 09/23/2013 12:13:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_RescEmrInfor] as
BEGIN
	select		codi_info, codi_pers, corr_inst, vers_inst 
	from		dbax_inst_info
	order by	codi_pers, corr_inst, vers_inst, codi_info
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_insInstInfo]    Fecha de la secuencia de comandos: 09/23/2013 12:13:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_AX_insInstInfo] (@pCodiPers numeric(9,0),@pCorrInst numeric(10,0), @pVersInst numeric(5,0),@pCodiInfo varchar(50))
AS
BEGIN
if ((select count(*) from dbax_inst_info where codi_pers=@pCodiPers and corr_inst=@pCorrInst and vers_inst=@pVersInst and codi_info=@pCodiInfo)=0)
insert into dbax_inst_info (codi_pers,corr_inst,vers_inst,codi_info)values(@pCodiPers,@pCorrInst,@pVersInst,@pCodiInfo)
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_read_pref_conc]    Fecha de la secuencia de comandos: 09/23/2013 12:12:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas
-- alter date: <20-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_read_pref_conc]
(
	 @tsTipo as Varchar(2),
	 @tnPagina as integer,
	 @tnRegPag as integer,
	 @tsCondicion as Varchar(2048),
	 @tsPar1 as Varchar(30), @tsPar2 as Varchar(30),
	 @tsPar3 as Varchar(30), @tsPar4 as Varchar(30), @tsPar5 as Varchar(30),
	 @p_codi_usua varchar(30), @p_codi_empr int, @p_codi_emex varchar(30)
 )
AS
BEGIN
	IF(@tsTipo ='LV')
	BEGIN
		declare @vComodinTipo varchar(1)
		select '' as CODIGO, '' as VALOR
		union
		select distinct pref_conc as CODIGO,pref_conc as VALOR
		from dbax_taxo_conc 
		where vers_taxo like isnull(@vComodinTipo,'%') + isnull(@tsPar1,'') + isnull(@vComodinTipo,'%')	
	END
END
GO
/****** Objeto:  UserDefinedFunction [dbo].[FU_AX_getValormiembroDimension]    Fecha de la secuencia de comandos: 09/23/2013 12:13:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER function [dbo].[FU_AX_getValormiembroDimension](
			@p_CodiPers numeric(10),  --código de la empresa
			@p_CorrInst numeric(10),  -- instancia (período a consultar)
			@p_VersInst numeric(10),  -- verción de la carga
			@p_PrefConc varchar(256), -- prefijo del conceto
			@p_CodiConc varchar(256), -- código del concepto
            @v_FechIni varchar(512),  -- período de inicio
            @v_FechFin varchar(512),  -- período final
            @v_codi_axis varchar(256),-- código de eje
            @v_codi_memb varchar(256),-- código del miembro
            @v_sald_ini varchar(10),  -- ver si es de ininio o no
            @v_tipo_peri varchar(50), -- tipo de período
            @V_periodo_InicioCambiado varchar(100) -- período cambiado  
            ) 
            returns varchar(4000)

begin
declare @valor_cntx varchar(100)
if (  @v_sald_ini = 'I')
	begin

--		set @valor_cntx = (select	top 1 valo_cntx
--		from	dbax_inst_conc ic,
--				dbax_inst_cntx ix,
--				dbax_inst_dicx id
--		where	ix.codi_pers = @p_CodiPers 
--		and		ix.corr_inst = @p_CorrInst 
--		and		ix.vers_inst = @p_VersInst
--		and		(ix.fini_cntx = @V_periodo_InicioCambiado -- <-- Fecha inicial de columna
--			     or ix.fini_cntx = @v_FechIni)
--		and		ix.ffin_cntx is null
--		and		ic.codi_pers = ix.codi_pers
--		and		ic.corr_inst = ix.corr_inst
--		and		ic.vers_inst = ix.vers_inst
--		and		ic.pref_conc = @p_PrefConc 
--		and		ic.codi_conc = @p_CodiConc 
--		and		ic.codi_cntx = ix.codi_cntx
--		--and		id.codi_pers = ix.codi_pers
--		--and		id.corr_inst = ix.corr_inst
--		--and		id.vers_inst = ix.vers_inst
--		--and		id.codi_cntx = ix.codi_cntx
--		and		isnull(id.codi_axis,'') = isnull(@v_codi_axis,'')
--		and		isnull(id.codi_memb,'') = isnull(@v_codi_memb,'')
--		order by ic.codi_conc, ix.fini_cntx asc)

		set @valor_cntx = (select	top 1 valo_cntx
		from	dbax_inst_conc ic,
				dbax_inst_cntx ix
				left join dbax_inst_dicx id
				on ix.codi_pers = id.codi_pers
				and	ix.corr_inst = id.corr_inst
				and ix.vers_inst = id.vers_inst
				and	ix.codi_cntx = id.codi_cntx
		where	ic.codi_pers = @p_CodiPers
		and		ic.corr_inst = @p_CorrInst 
		and		ic.vers_inst = @p_VersInst 
		and		ix.codi_pers = ic.codi_pers
		and		ix.corr_inst = ic.corr_inst
		and		ix.vers_inst = ic.vers_inst
		and		(ix.fini_cntx = @v_FechIni
					or ix.fini_cntx = @V_periodo_InicioCambiado )-- <-- Fecha inicial de columna
		and		ix.ffin_cntx is null
		and		ic.pref_conc = @p_PrefConc 
		and		ic.codi_conc = @p_CodiConc 
		and		ic.codi_cntx = ix.codi_cntx
		and		isnull(id.codi_axis,'') = isnull(@v_codi_axis,'')
		and		isnull(id.codi_cntx,'') = isnull(@v_codi_memb,'')
		order by ic.codi_conc, ix.fini_cntx asc)
	end
else
	begin
         if(@v_tipo_peri = 'duration')
            begin

				set @valor_cntx = (select	top 1 valo_cntx
				from	dbax_inst_conc ic,
						dbax_inst_cntx ix
						left join dbax_inst_dicx id
							on ix.codi_pers = id.codi_pers
							and	ix.corr_inst = id.corr_inst
							and ix.vers_inst = id.vers_inst
							and	ix.codi_cntx = id.codi_cntx
				where	ic.codi_pers = @p_CodiPers
				and		ic.corr_inst = @p_CorrInst 
				and		ic.vers_inst = @p_VersInst 
				and		ic.pref_conc = @p_PrefConc 
				and		ic.codi_conc = @p_CodiConc 
				and		ix.codi_cntx = id.codi_cntx
				and		ix.codi_pers = ic.codi_pers
				and		ix.corr_inst = ic.corr_inst
				and		ix.vers_inst = ic.vers_inst
				and		ix.fini_cntx = @v_FechIni
				and		ix.ffin_cntx = @v_FechFin
				--and		isnull(ix.ffin_cntx,'') = isnull(@v_FechFin,'')
				--and		ix.ffin_cntx is null
				and		isnull(id.codi_axis,'') = isnull(@v_codi_axis,'')
				and		isnull(id.codi_cntx,'') = isnull(@v_codi_memb,'')
				order by ic.codi_conc, ix.fini_cntx asc)

			end
        if(@v_tipo_peri = 'instant')
			begin

				set @valor_cntx = (select	top 1 valo_cntx
				from	dbax_inst_conc ic,
						dbax_inst_cntx ix
						left join dbax_inst_dicx id
						on ix.codi_pers = id.codi_pers
						and	ix.corr_inst = id.corr_inst
						and ix.vers_inst = id.vers_inst
						and	ix.codi_cntx = id.codi_cntx
				where	ic.codi_pers = @p_CodiPers
				and		ic.corr_inst = @p_CorrInst 
				and		ic.vers_inst = @p_VersInst 
				and		ix.codi_pers = ic.codi_pers
				and		ix.corr_inst = ic.corr_inst
				and		ix.vers_inst = ic.vers_inst
				and		ix.fini_cntx =  @v_FechFin -- <-- Final columna
				and		ix.ffin_cntx is null
				and		ic.pref_conc = @p_PrefConc 
				and		ic.codi_conc = @p_CodiConc 
				and		ic.codi_cntx = ix.codi_cntx
				and		isnull(id.codi_axis,'') = isnull(@v_codi_axis,'')
				and		isnull(id.codi_memb,'') = isnull(@v_codi_memb,'')
				order by ic.codi_conc, ix.fini_cntx asc)
			end 
	end 

return @valor_cntx

end -- fin función
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_insInstDicx]    Fecha de la secuencia de comandos: 09/23/2013 12:13:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_AX_insInstDicx] (
		@pCodiPers numeric(9,0),@pCorrInst numeric(10,0), 
		@pVersInst numeric(5,0),@pCodiCntx varchar(256),
		@pCodiAxis varchar(256),@pCodiMemb varchar(256),
		@pDescMemb varchar(256))
AS
BEGIN
	insert into dbax_inst_dicx (
			codi_pers, corr_inst, vers_inst, codi_cntx, 
			codi_axis, codi_memb, desc_memb)
	values (@pCodiPers,@pCorrInst,@pVersInst,@pCodiCntx,
			@pCodiAxis,@pCodiMemb, @pDescMemb)
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_read_pref_taxo]    Fecha de la secuencia de comandos: 09/23/2013 12:12:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas
-- alter date: 20-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_read_pref_taxo]
(
	@tsTipo as Varchar(2),
	 @tnPagina as integer,
	 @tnRegPag as integer,
	 @tsCondicion as Varchar(2048),
	 @tsPar1 as Varchar(30), @tsPar2 as Varchar(30),
	 @tsPar3 as Varchar(30), @tsPar4 as Varchar(30), @tsPar5 as Varchar(30),
	 @p_codi_usua varchar(30), @p_codi_empr int, @p_codi_emex varchar(30)
)
AS
BEGIN
	SELECT '' AS CODIGO, 'Selecciona' as VALOR
	UNION
	SELECT SUBSTRING(vers_taxo,0,CHARINDEX('-2',vers_taxo) + CHARINDEX('_2',vers_taxo)) AS CODIGO ,
	SUBSTRING(vers_taxo,0,CHARINDEX('-2',vers_taxo) + CHARINDEX('_2',vers_taxo)) AS VALOR
	from dbax_taxo_vers 
	WHERE tipo_taxo = @tsPar1;
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_update_dbax_taxo_vers]    Fecha de la secuencia de comandos: 09/23/2013 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 19-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_update_dbax_taxo_vers]
            @P_VERS_TAXO varchar(256), 
            @P_UBIC_TAXO varchar(256), 
            @P_TIPO_TAXO varchar(4) 
 AS
 BEGIN
        UPDATE dbax_taxo_vers
             SET ubic_taxo = @P_UBIC_TAXO, 
                 tipo_taxo = @P_TIPO_TAXO
             WHERE vers_taxo = @P_VERS_TAXO 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_alter_dbax_taxo_vers]    Fecha de la secuencia de comandos: 09/23/2013 12:11:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 19-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_alter_dbax_taxo_vers]
            @P_VERS_TAXO varchar(256), 
            @P_UBIC_TAXO varchar(256), 
            @P_TIPO_TAXO varchar(4) 
 AS
 BEGIN
        INSERT INTO dbax_taxo_vers(
            vers_taxo, 
            ubic_taxo, 
            tipo_taxo
        )
        VALUES
        (
             @P_VERS_TAXO, 
             @P_UBIC_TAXO, 
             @P_TIPO_TAXO
        );
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_delete_dbax_taxo_vers]    Fecha de la secuencia de comandos: 09/23/2013 12:11:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 19-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_delete_dbax_taxo_vers]
            @P_VERS_TAXO varchar(256) 
 AS
 BEGIN
        DELETE dbax_taxo_vers
        WHERE vers_taxo = @P_VERS_TAXO 
 END;
GO
/****** Objeto:  UserDefinedFunction [dbo].[dbnet_get_empr]    Fecha de la secuencia de comandos: 09/23/2013 12:13:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 27-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER function [dbo].[dbnet_get_empr]  () returns numeric(4) as
begin
  declare @p_codi_empr numeric(9)
   select @p_codi_empr=s.codi_empr
     from sys_session s, sys_connection c
     where s.corr_sess=c.corr_sess
           and corr_conn=@@SPID
   return (@p_codi_empr)
end
GO
/****** Objeto:  UserDefinedFunction [dbo].[dbnet_get_modu]    Fecha de la secuencia de comandos: 09/23/2013 12:13:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 27-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER function [dbo].[dbnet_get_modu] () returns varchar  as
begin
  declare @p_codi_modu varchar(30)
   select @p_codi_modu=s.codi_modu
     from sys_session s, sys_connection c
     where s.corr_sess=c.corr_sess
           and corr_conn=@@SPID
   return (@p_codi_modu)
end
GO
/****** Objeto:  UserDefinedFunction [dbo].[dbnet_get_emex]    Fecha de la secuencia de comandos: 09/23/2013 12:13:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 27-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER function [dbo].[dbnet_get_emex] ()  returns varchar(30)  as
begin
  declare @p_codi_emex varchar(30)
   select @p_codi_emex=s.codi_emex
     from sys_session s, sys_connection c
     where s.corr_sess=c.corr_sess
           and corr_conn=@@SPID
   return (@p_codi_emex)
end
GO
/****** Objeto:  UserDefinedFunction [dbo].[dbnet_get_cult]    Fecha de la secuencia de comandos: 09/23/2013 12:13:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 27-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER function [dbo].[dbnet_get_cult] () returns varchar  as
begin
  declare @p_codi_cult varchar(30)
   select @p_codi_cult = s.codi_cult
     from sys_session s, sys_connection c
     where s.corr_sess = c.corr_sess
           and corr_conn=@@SPID
   return (@p_codi_cult)
end
GO
/****** Objeto:  UserDefinedFunction [dbo].[dbnet_get_pers]    Fecha de la secuencia de comandos: 09/23/2013 12:13:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 27-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER function [dbo].[dbnet_get_pers] () returns varchar  as
begin
  declare @p_codi_pers varchar(30)
   select @p_codi_pers=s.codi_pers
     from sys_session s, sys_connection c
     where s.corr_sess=c.corr_sess
           and corr_conn=@@SPID
   return (@p_codi_pers)
end
GO
/****** Objeto:  UserDefinedFunction [dbo].[dbnet_get_rous]    Fecha de la secuencia de comandos: 09/23/2013 12:13:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 27-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER function [dbo].[dbnet_get_rous] () returns varchar  as
begin
  declare @p_codi_rous varchar(30)
   select @p_codi_rous=s.codi_rous
     from sys_session s, sys_connection c
     where s.corr_sess=c.corr_sess
           and corr_conn=@@SPID
   return (@p_codi_rous)
end
GO
/****** Objeto:  UserDefinedFunction [dbo].[dbnet_get_usua]    Fecha de la secuencia de comandos: 09/23/2013 12:13:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 27-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER function [dbo].[dbnet_get_usua] () returns varchar(30)  as
begin
  declare @p_codi_usua varchar(30)
   select @p_codi_usua=s.codi_usua
     from sys_session s, sys_connection c
     where s.corr_sess=c.corr_sess
           and corr_conn=@@SPID
   return isnull(@p_codi_usua,user)
end
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_GetConcDife]    Fecha de la secuencia de comandos: 09/23/2013 12:13:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_GetConcDife](
	@pCodi_pers numeric(9,0) ,
	@pCorr_inst varchar(10),
	@pVers_inst numeric(5,0)) 
as
declare @pVers_ante numeric (5,0)
BEGIN
set @pVers_ante = @pVers_inst - 1
	select  ic.codi_conc,/* ic.valo_cntx,*/x1.fini_cntx,isnull(x1.ffin_cntx,0)ffin_cntx
	from	dbax_inst_conc ic,
			dbax_inst_cntx x1 --,
	--		dbax_defi_conc c,
	--		dbax_info_defi i,
	--		dbax_desc_conc d
	where ic.codi_pers = @pCodi_pers
	and   ic.corr_inst = @pCorr_inst
	and   ic.vers_inst = @pVers_ante
	--and   c.pref_conc = ic.pref_conc
	--and   c.codi_conc = ic.codi_conc
	and   x1.codi_pers = ic.codi_pers
	and   x1.corr_inst = ic.corr_inst
	and   x1.codi_cntx = ic.codi_cntx
	--and   d.pref_conc  = c.pref_conc
	--and   d.codi_conc  = c.codi_conc    
	and   exists (select 1
				   from dbax_inst_conc v1,
						dbax_inst_cntx x2
				   where v1.codi_pers = ic.codi_pers
				   and   v1.corr_inst = ic.corr_inst
				   and   v1.vers_inst = @pVers_inst
				   and   v1.pref_conc = ic.pref_conc
				   and   v1.codi_conc = ic.codi_conc
				   and   v1.codi_cntx = ic.codi_cntx
				   and   x2.codi_pers = v1.codi_pers 
				   and   x2.corr_inst = v1.corr_inst
				   and   x2.vers_inst = v1.vers_inst
				   and   x2.fini_cntx = x1.fini_cntx
				   and   isnull(x2.ffin_cntx,'') = isnull(x1.ffin_cntx,'')
				   and   replace(v1.valo_cntx,'.00','') != replace(ic.valo_cntx,'.00',''))
	group by  ic.codi_conc, /*v.valo_cntx,*/x1.fini_cntx,x1.ffin_cntx
	union 
	select  ic.codi_conc,/* ic.valo_cntx,*/x1.fini_cntx,isnull(x1.ffin_cntx,0)ffin_cntx
	from	dbax_inst_conc ic,
			dbax_inst_cntx x1 --,
	--		dbax_defi_conc c,
	--		dbax_info_defi i,
	--		dbax_desc_conc d
	where ic.codi_pers = @pCodi_pers
	and   ic.corr_inst = @pCorr_inst
	and   ic.vers_inst = @pVers_ante
	--and   c.pref_conc = ic.pref_conc
	--and   c.codi_conc = ic.codi_conc
	and   x1.codi_pers = ic.codi_pers
	and   x1.corr_inst = ic.corr_inst
	and   x1.codi_cntx = ic.codi_cntx
	--and   d.pref_conc  = c.pref_conc
	--and   d.codi_conc  = c.codi_conc    
	and   exists (select 1
				   from dbax_inst_conc v1,
						dbax_inst_cntx x2
				   where v1.codi_pers = ic.codi_pers
				   and   v1.corr_inst = ic.corr_inst
				   and   v1.vers_inst = @pVers_inst
				   and   v1.pref_conc = ic.pref_conc
				   and   v1.codi_conc = ic.codi_conc
				   and   v1.codi_cntx = ic.codi_cntx
				   and   x2.codi_pers = v1.codi_pers 
				   and   x2.corr_inst = v1.corr_inst
				   and   x2.vers_inst = v1.vers_inst
				   and   x2.fini_cntx = x1.fini_cntx
				   and   isnull(x2.ffin_cntx,'') = isnull(x1.ffin_cntx,'')
				   and   replace(v1.valo_cntx,'.00','') != replace(ic.valo_cntx,'.00',''))
	group by  ic.codi_conc, /*v.valo_cntx,*/x1.fini_cntx,x1.ffin_cntx
	union
	select  ic.codi_conc,/* ic.valo_cntx,*/x1.fini_cntx,isnull(x1.ffin_cntx,0)ffin_cntx
	from	dbax_inst_conc ic,
			dbax_inst_cntx x1 --,
	--		dbax_defi_conc c,
	--		dbax_info_defi i,
	--		dbax_desc_conc d
	where ic.codi_pers = @pCodi_pers
	and   ic.corr_inst = @pCorr_inst
	and   ic.vers_inst = @pVers_ante
	--and   c.pref_conc = ic.pref_conc
	--and   c.codi_conc = ic.codi_conc
	and   x1.codi_pers = ic.codi_pers
	and   x1.corr_inst = ic.corr_inst
	and   x1.codi_cntx = ic.codi_cntx
	--and   d.pref_conc  = c.pref_conc
	--and   d.codi_conc  = c.codi_conc    
	and   exists (select 1
				   from dbax_inst_conc v1,
						dbax_inst_cntx x2
				   where v1.codi_pers = ic.codi_pers
				   and   v1.corr_inst = ic.corr_inst
				   and   v1.vers_inst = @pVers_inst
				   and   v1.pref_conc = ic.pref_conc
				   and   v1.codi_conc = ic.codi_conc
				   and   v1.codi_cntx = ic.codi_cntx
				   and   x2.codi_pers = v1.codi_pers 
				   and   x2.corr_inst = v1.corr_inst
				   and   x2.vers_inst = v1.vers_inst
				   and   x2.fini_cntx = x1.fini_cntx
				   and   isnull(x2.ffin_cntx,'') = isnull(x1.ffin_cntx,'')
				   and   replace(v1.valo_cntx,'.00','') != replace(ic.valo_cntx,'.00',''))
	group by  ic.codi_conc, /*v.valo_cntx,*/x1.fini_cntx,x1.ffin_cntx
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_GetPeriRang]    Fecha de la secuencia de comandos: 09/23/2013 12:13:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_GetPeriRang](
	@pPeriIni varchar(30),
    @pPeriFin varchar(30)) as
BEGIN
	select distinct corr_inst
	from	dbax_inst_cntx
	where corr_inst BETWEEN @pPeriIni and @pPeriFin
	order by 1 desc
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getPersCorrInst]    Fecha de la secuencia de comandos: 09/23/2013 12:13:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getPersCorrInst](
	@pCodiPers varchar(30),
	@pCorrInst numeric(6,0) = 0) as
BEGIN
	if(len(@pCodiPers) > 0)
	begin
		select distinct substring(convert(varchar,corr_inst),1,4)+'-'+substring(convert(varchar,corr_inst),5,6) as desc_inst, corr_inst 
		from	dbax_inst_cntx
		where	codi_pers = @pCodiPers
		and		corr_inst >= @pCorrInst
		order by 1 desc
	end
	else
	begin
		select distinct substring(convert(varchar,corr_inst),1,4)+'-'+substring(convert(varchar,corr_inst),5,6) as desc_inst, corr_inst 
		from	dbax_inst_cntx
		where	corr_inst >= @pCorrInst
		order by 1 desc
	end
END
GO
/****** Objeto:  UserDefinedFunction [dbo].[FU_AX_getValorPorFecha]    Fecha de la secuencia de comandos: 09/23/2013 12:13:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER function [dbo].[FU_AX_getValorPorFecha](
			@p_CodiPers numeric(10), 
			@p_CorrInst numeric(10), 
			@p_VersInst numeric(10), 
			@p_PrefConc varchar(256), 
			@p_CodiConc varchar(256), 
            @v_FechIni varchar(512),
            @v_FechFin varchar(512),
            @p_CodiMone varchar(30)
            ) 
            returns varchar(4000)
begin
/*
Devuelve un valor que este asociado a un contexto con las fechas entregadas
*/
	declare @v_valor varchar(4000)

	IF(@p_CodiMone = 'MONE_LOCA' or @p_CodiMone = '')
	BEGIN
		select	@v_valor =	isnull(max(valo_cntx),'')
		from	dbax_inst_conc ic,
				dbax_inst_cntx ix
		where	ix.codi_pers = @p_CodiPers 
		and		ix.corr_inst = @p_CorrInst 
		and		ix.vers_inst = @p_VersInst
		and		ix.fini_cntx = @v_FechIni
		and		ix.ffin_cntx = @v_FechFin
		and     ic.codi_pers = ix.codi_pers
		and		ic.corr_inst = ix.corr_inst
		and		ic.vers_inst = ix.vers_inst
		and		ic.pref_conc = @p_PrefConc 
		and		ic.codi_conc = @p_CodiConc 
		and		ic.codi_cntx = ix.codi_cntx
		
		if(len(@v_valor) = 0)
		begin
			select	@v_valor =	isnull(max(valo_cntx),'')
			from	dbax_inst_conc ic,
					dbax_inst_cntx ix
			where	ix.codi_pers = @p_CodiPers 
			and		ix.corr_inst = @p_CorrInst 
			and		ix.vers_inst = @p_VersInst
			and		ix.fini_cntx = @v_FechFin
			and		ix.ffin_cntx is null
			and     ic.codi_pers = ix.codi_pers
			and		ic.corr_inst = ix.corr_inst
			and		ic.vers_inst = ix.vers_inst
			and		ic.pref_conc = @p_PrefConc 
			and		ic.codi_conc = @p_CodiConc 
			and		ic.codi_cntx = ix.codi_cntx
		end
	
		--select	@v_valor =	isnull(max(valo_cntx),'')
		--from	dbax_inst_conc ic	--,
		--		dbax_view_cntx ix
		--where	ix.codi_pers = @p_CodiPers 
		--and		ix.corr_inst = @p_CorrInst 
		--and		ix.vers_inst = @p_VersInst 
		--and		ix.fini_cntx = @v_FechIni
		--and		isnull(ix.ffin_cntx,'') = isnull(@v_FechFin,'')
		--and		ic.codi_pers = ix.codi_pers
		--and		ic.corr_inst = ix.corr_inst
		--and		ic.vers_inst = ix.vers_inst
		--and		ic.pref_conc = @p_PrefConc 
		--and		ic.codi_conc = @p_CodiConc 
		--and		ic.codi_cntx = ix.codi_cntx
		
		--if(len(@v_valor) = 0)
		--begin
		--	select	@v_valor =	isnull(max(valo_cntx),'')
		--	from	dbax_inst_conc ic,
		--			dbax_view_cntx ix
		--	where	ix.codi_pers = @p_CodiPers 
		--	and		ix.corr_inst = @p_CorrInst 
		--	and		ix.vers_inst = @p_VersInst 
		--	and		(ix.fini_cntx = @v_FechIni or ix.fini_cntx = substring(convert(varchar,DATEADD(day,1,convert(datetime, @v_FechIni,20)),20),1,10))
		--	and		isnull(ix.fini_cntx,'') <= isnull(@v_FechFin,'')
		--	and		ic.codi_pers = ix.codi_pers
		--	and		ic.corr_inst = ix.corr_inst
		--	and		ic.vers_inst = ix.vers_inst
		--	and		ic.pref_conc = @p_PrefConc 
		--	and		ic.codi_conc = @p_CodiConc 
		--	and		ic.codi_cntx = ix.codi_cntx
		--end

		--if(len(@v_valor) = 0)
		--begin
		--	select	@v_valor =	isnull(max(valo_cntx),'')
		--	from	dbax_inst_conc ic,
		--			dbax_view_cntx ix
		--	where	ix.codi_pers = @p_CodiPers 
		--	and		ix.corr_inst = @p_CorrInst 
		--	and		ix.vers_inst = @p_VersInst 
		--	and		ix.fini_cntx >= @v_FechFin
		--	and		isnull(ix.fini_cntx,'') = isnull(@v_FechFin,'')
		--	and		ic.codi_pers = ix.codi_pers
		--	and		ic.corr_inst = ix.corr_inst
		--	and		ic.vers_inst = ix.vers_inst
		--	and		ic.pref_conc = @p_PrefConc 
		--	and		ic.codi_conc = @p_CodiConc 
		--	and		ic.codi_cntx = ix.codi_cntx
		--end
	END
	ELSE IF(@p_CodiMone = 'MONE_REFE')
	BEGIN
		select	@v_valor =	isnull(max(valo_refe),'')
		from	dbax_inst_conc ic,
				dbax_view_cntx ix
		where	ix.codi_pers = @p_CodiPers 
		and		ix.corr_inst = @p_CorrInst 
		and		ix.vers_inst = @p_VersInst 
		and		ix.fini_cntx = @v_FechIni
		and		isnull(ix.ffin_cntx,'') = isnull(@v_FechFin,'')
		and		ic.codi_pers = ix.codi_pers
		and		ic.corr_inst = ix.corr_inst
		and		ic.vers_inst = ix.vers_inst
		and		ic.pref_conc = @p_PrefConc 
		and		ic.codi_conc = @p_CodiConc 
		and		ic.codi_cntx = ix.codi_cntx
		
		if(len(@v_valor) = 0)
		begin
			select	@v_valor =	isnull(max(valo_refe),'')
			from	dbax_inst_conc ic,
					dbax_view_cntx ix
			where	ix.codi_pers = @p_CodiPers 
			and		ix.corr_inst = @p_CorrInst 
			and		ix.vers_inst = @p_VersInst 
			and		(ix.fini_cntx = @v_FechIni or ix.fini_cntx = substring(convert(varchar,DATEADD(day,1,convert(datetime, @v_FechIni,20)),20),1,10))
			and		isnull(ix.fini_cntx,'') <= isnull(@v_FechFin,'')
			and		ic.codi_pers = ix.codi_pers
			and		ic.corr_inst = ix.corr_inst
			and		ic.vers_inst = ix.vers_inst
			and		ic.pref_conc = @p_PrefConc 
			and		ic.codi_conc = @p_CodiConc 
			and		ic.codi_cntx = ix.codi_cntx
		end

		if(len(@v_valor) = 0)
		begin
			select	@v_valor =	isnull(max(valo_refe),'')
			from	dbax_inst_conc ic,
					dbax_view_cntx ix
			where	ix.codi_pers = @p_CodiPers 
			and		ix.corr_inst = @p_CorrInst 
			and		ix.vers_inst = @p_VersInst 
			and		ix.fini_cntx >= @v_FechFin
			and		isnull(ix.fini_cntx,'') = isnull(@v_FechFin,'')
			and		ic.codi_pers = ix.codi_pers
			and		ic.corr_inst = ix.corr_inst
			and		ic.vers_inst = ix.vers_inst
			and		ic.pref_conc = @p_PrefConc 
			and		ic.codi_conc = @p_CodiConc 
			and		ic.codi_cntx = ix.codi_cntx
		end
	END
	ELSE IF(@p_CodiMone = 'MONE_INTE')
	BEGIN
	select	@v_valor =	isnull(max(valo_inte),'')
		from	dbax_inst_conc ic,
				dbax_view_cntx ix
		where	ix.codi_pers = @p_CodiPers 
		and		ix.corr_inst = @p_CorrInst 
		and		ix.vers_inst = @p_VersInst 
		and		ix.fini_cntx = @v_FechIni
		and		isnull(ix.ffin_cntx,'') = isnull(@v_FechFin,'')
		and		ic.codi_pers = ix.codi_pers
		and		ic.corr_inst = ix.corr_inst
		and		ic.vers_inst = ix.vers_inst
		and		ic.pref_conc = @p_PrefConc 
		and		ic.codi_conc = @p_CodiConc 
		and		ic.codi_cntx = ix.codi_cntx
		
		if(len(@v_valor) = 0)
		begin
			select	@v_valor =	isnull(max(valo_inte),'')
			from	dbax_inst_conc ic,
					dbax_view_cntx ix
			where	ix.codi_pers = @p_CodiPers 
			and		ix.corr_inst = @p_CorrInst 
			and		ix.vers_inst = @p_VersInst 
			and		(ix.fini_cntx = @v_FechIni or ix.fini_cntx = substring(convert(varchar,DATEADD(day,1,convert(datetime, @v_FechIni,20)),20),1,10))
			and		isnull(ix.fini_cntx,'') <= isnull(@v_FechFin,'')
			and		ic.codi_pers = ix.codi_pers
			and		ic.corr_inst = ix.corr_inst
			and		ic.vers_inst = ix.vers_inst
			and		ic.pref_conc = @p_PrefConc 
			and		ic.codi_conc = @p_CodiConc 
			and		ic.codi_cntx = ix.codi_cntx
		end

		if(len(@v_valor) = 0)
		begin
			select	@v_valor =	isnull(max(valo_inte),'')
			from	dbax_inst_conc ic,
					dbax_view_cntx ix
			where	ix.codi_pers = @p_CodiPers 
			and		ix.corr_inst = @p_CorrInst 
			and		ix.vers_inst = @p_VersInst 
			and		ix.fini_cntx >= @v_FechFin
			and		isnull(ix.fini_cntx,'') = isnull(@v_FechFin,'')
			and		ic.codi_pers = ix.codi_pers
			and		ic.corr_inst = ix.corr_inst
			and		ic.vers_inst = ix.vers_inst
			and		ic.pref_conc = @p_PrefConc 
			and		ic.codi_conc = @p_CodiConc 
			and		ic.codi_cntx = ix.codi_cntx
		end
	END

	--if @v_valor = ''
	--	return '0'
	
	return @v_valor
end
GO
/****** Objeto:  StoredProcedure [dbo].[prc_sys_sesion_update_fete]    Fecha de la secuencia de comandos: 09/23/2013 12:12:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 05-06-2013
-- Description:	Procedimiento que ingresa la fecha en que cerro session el usuario
-- =============================================
ALTER PROCEDURE [dbo].[prc_sys_sesion_update_fete]
	@p_corr_sess int,
	@p_fete_sess datetime
AS
BEGIN
	UPDATE	sys_session
	SET		fete_sess = @p_fete_sess
	where	corr_sess = @p_corr_sess
END
GO
/****** Objeto:  UserDefinedFunction [dbo].[fnc_valida_privilegios]    Fecha de la secuencia de comandos: 09/23/2013 12:13:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas
-- alter date: 03-06-2013
-- Description:	Metodo que valida los usuarios
-- =============================================
ALTER FUNCTION [dbo].[fnc_valida_privilegios]
(	
	@p_corr_sess numeric(18,0)
)
RETURNS varchar(2)
AS
BEGIN
	declare @p_vali_usua int;
	declare @p_mens varchar(2);
	select @p_vali_usua = count(codi_usua)
	from sys_session
	where	fete_sess is null
	and		corr_sess = @p_corr_sess;
	
	if(@p_vali_usua = 1)
	BEGIN	
		--select corr_sess, codi_usua, codi_rous, codi_pers, codi_empr, codi_ceco, 
		--	codi_emex, codi_modu, codi_pers, fein_sess, fete_sess
		--from	sys_session
		--where	fete_sess is null
		--and		corr_sess = @p_corr_sess;
		
		set @p_mens = 'S';
	END
	return @p_mens;
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_delete_dbax_info_conc]    Fecha de la secuencia de comandos: 09/23/2013 12:11:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 19-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_delete_dbax_info_conc]
            @P_CODI_EMPR numeric(9, 0), 
            @P_CODI_EMEX varchar(30), 
            @P_CODI_INFO varchar(50), 
            @P_PREF_CONC varchar(50), 
            @P_CODI_CONC varchar(256), 
            @P_ORDE_CONC numeric(5, 0) 
 AS
 BEGIN
        DELETE dbax_info_conc
        WHERE codi_empr = @P_CODI_EMPR 
        AND   codi_emex = @P_CODI_EMEX 
        AND   codi_info = @P_CODI_INFO 
        AND   pref_conc = @P_PREF_CONC 
        AND   codi_conc = @P_CODI_CONC 
        AND   orde_conc = @P_ORDE_CONC 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_alter_dbax_info_conc]    Fecha de la secuencia de comandos: 09/23/2013 12:11:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 19-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_alter_dbax_info_conc]
            @P_CODI_EMPR numeric(9, 0), 
            @P_CODI_EMEX varchar(30), 
            @P_CODI_INFO varchar(50), 
            @P_PREF_CONC varchar(50), 
            @P_CODI_CONC varchar(256), 
            @P_ORDE_CONC numeric(5, 0), 
            @P_CODI_CONC1 varchar(256), 
            @P_NIVE_CONC numeric(5, 0), 
            @P_NEGR_CONC varchar(10) 
 AS
 BEGIN
        INSERT INTO dbax_info_conc(
            codi_empr, 
            codi_emex, 
            codi_info, 
            pref_conc, 
            codi_conc, 
            orde_conc, 
            codi_conc1, 
            nive_conc, 
            negr_conc
        )
        VALUES
        (
             @P_CODI_EMPR, 
             @P_CODI_EMEX, 
             @P_CODI_INFO, 
             @P_PREF_CONC, 
             @P_CODI_CONC, 
             @P_ORDE_CONC, 
             @P_CODI_CONC1, 
             @P_NIVE_CONC, 
             @P_NEGR_CONC
        );
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_update_dbax_info_conc]    Fecha de la secuencia de comandos: 09/23/2013 12:12:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 19-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_update_dbax_info_conc]
            @P_CODI_EMPR numeric(9, 0), 
            @P_CODI_EMEX varchar(30), 
            @P_CODI_INFO varchar(50), 
            @P_PREF_CONC varchar(50), 
            @P_CODI_CONC varchar(256), 
            @P_ORDE_CONC numeric(5, 0), 
            @P_CODI_CONC1 varchar(256), 
            @P_NIVE_CONC numeric(5, 0), 
            @P_NEGR_CONC varchar(10) 
 AS
 BEGIN
        UPDATE dbax_info_conc
             SET codi_conc1 = @P_CODI_CONC1, 
                 nive_conc = @P_NIVE_CONC, 
                 negr_conc = @P_NEGR_CONC
             WHERE codi_empr = @P_CODI_EMPR 
             AND   codi_emex = @P_CODI_EMEX 
             AND   codi_info = @P_CODI_INFO 
             AND   pref_conc = @P_PREF_CONC 
             AND   codi_conc = @P_CODI_CONC 
             AND   orde_conc = @P_ORDE_CONC 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getMaxOrdeConc]    Fecha de la secuencia de comandos: 09/23/2013 12:13:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getMaxOrdeConc](
@pCodiEmex varchar(30),
@pCodiEmpr numeric (9,0),
@pCodiInfo varchar(50)
)
as
BEGIN
	select isnull(max(orde_conc),0)+1 as orde_conc
	from	dbax_info_conc
	where	codi_emex = @pCodiEmex
	and		codi_empr = @pCodiEmpr
	and		codi_info = @pCodiInfo
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_delIndi]    Fecha de la secuencia de comandos: 09/23/2013 12:13:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_delIndi](
	@p_codi_emex  varchar(30),
	@p_codi_empr  numeric(9,0),
	@p_codi_indi  varchar(100)) as
BEGIN
delete from dbax_form_enca 
where codi_emex = @p_codi_emex 
and codi_empr = @p_codi_empr 
and codi_indi = @p_codi_indi

delete from dbax_info_conc
where codi_conc = @p_codi_indi
and pref_conc  ='indi'

delete from dbax_inst_conc
where codi_conc = @p_codi_indi
and pref_conc  ='INDI'
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_insInfoConc]    Fecha de la secuencia de comandos: 09/23/2013 12:13:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter procedure [dbo].[SP_AX_insInfoConc] 
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
/****** Objeto:  StoredProcedure [dbo].[SP_AX_delInfoConc]    Fecha de la secuencia de comandos: 09/23/2013 12:13:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_delInfoConc] 
@pCodiEmex varchar(50),
@pCodiEmpr varchar(9),
@pCodiInfo varchar(50),
@pPrefConc varchar(50),
@pCodiConc varchar(100),
@pOrdeConc varchar(50)
 as
BEGIN
	delete	dbax_info_conc 
	where	codi_emex = @pCodiEmex
	and		codi_empr = @pCodiEmpr
	and		codi_info = @pCodiInfo
	and		pref_conc = @pPrefConc
	and		codi_conc = @pCodiConc
	and		orde_conc = @pOrdeConc
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_updInfoConc]    Fecha de la secuencia de comandos: 09/23/2013 12:13:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_updInfoConc] 
	@pCodiEmex varchar(30),
	@pCodiEmpr varchar(9),
	@pCodiInfo varchar(100),
	@pPrefConc varchar(50),
	@p_Codi_conc varchar(100),
	@p_Orden_conc varchar(100),
	@p_Nivel varchar(100),
	@p_Negrita varchar(100)
as
BEGIN
	UPDATE	dbax_info_conc 
	set		orde_conc = @p_Orden_conc,
			nive_conc = @p_Nivel,
			negr_conc = @p_Negrita
	where	codi_emex = @pCodiEmex
	and		codi_empr = @pCodiEmpr
	AND		codi_info = @pCodiInfo
	and		pref_conc = @pPrefConc
	and		codi_conc = @p_Codi_conc 
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_pass_repe_read]    Fecha de la secuencia de comandos: 09/23/2013 12:12:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 03-12-2012
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_pass_repe_read]
(@P_PASS_ENCR VARCHAR(128),
@P_VNUM_PASS VARCHAR(128),
@p_codi_usua VARCHAR(128))
AS
BEGIN
	
	SELECT 1
	WHERE @P_PASS_ENCR in (
	SELECT TOP (CAST(@P_VNUM_PASS AS INT)) INFO_EVEN 
	FROM USUA_SIST_EVEN
	WHERE CODI_USUA = @p_codi_usua
	AND CODI_EVEN = 'CCLU'
	ORDER BY CORR_EVEN DESC);
	
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_usua_sist_event_inf_alter]    Fecha de la secuencia de comandos: 09/23/2013 12:13:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_usua_sist_event_inf_alter] 
	(@p_codi_usua VARCHAR(30),
	@P_CODI_EVEN VARCHAR(4),
	@P_FECH_EVEN DATETIME,
	@P_INFO_EVEN VARCHAR(128))
AS
BEGIN
	INSERT INTO USUA_SIST_EVEN (codi_usua,codi_even,fech_even,info_even) VALUES (@p_codi_usua,@P_CODI_EVEN,@P_FECH_EVEN, @P_INFO_EVEN);
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_usua_sist_event_cor_alter]    Fecha de la secuencia de comandos: 09/23/2013 12:13:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 27-11-2012
-- Description:	Procedimiento que registra la conexion a la aplicacion, correlativo de session, codigo_usuario, codigo de evento, fecha del evento
-- =============================================
ALTER PROCEDURE [dbo].[prc_usua_sist_event_cor_alter]
@p_corr_sess decimal,
@p_codi_usua VARCHAR(30),
@p_codi_even VARCHAR(30),
@p_fech_even VARCHAR(30)
AS
BEGIN
	INSERT INTO USUA_SIST_EVEN(corr_sess,codi_usua,codi_even,fech_even)
			VALUES(@p_corr_sess,@p_codi_usua,@p_codi_even,@p_fech_even);
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_usua_sist_event_alter]    Fecha de la secuencia de comandos: 09/23/2013 12:13:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 27-11-2012
-- Description:	Procedimiento que registra la conexion a la aplicacion, correlativo de session, codigo_usuario, codigo de evento, fecha del evento
-- =============================================
ALTER PROCEDURE [dbo].[prc_usua_sist_event_alter]
@p_codi_usua VARCHAR(30),
@p_codi_even VARCHAR(30),
@p_fech_even VARCHAR(30)
AS
BEGIN
	INSERT INTO USUA_SIST_EVEN(codi_usua,codi_even,fech_even)
			VALUES(@p_codi_usua,@p_codi_even,@p_fech_even);
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_usua_sist_event_alter_cor]    Fecha de la secuencia de comandos: 09/23/2013 12:13:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 27-11-2012
-- Description:	Procedimiento que registra la conexion a la aplicacion, correlativo de session, codigo_usuario, codigo de evento, fecha del evento
-- =============================================
ALTER PROCEDURE [dbo].[prc_usua_sist_event_alter_cor]
@p_corr_sess decimal,
@p_codi_usua VARCHAR(30),
@p_codi_even VARCHAR(30),
@p_fech_even VARCHAR(30)
AS
BEGIN
	INSERT INTO USUA_SIST_EVEN(corr_sess,codi_usua,codi_even,fech_even)
			VALUES(@p_corr_sess,@p_codi_usua,@p_codi_even,@p_fech_even);
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_usua_sist_event_alter_inf]    Fecha de la secuencia de comandos: 09/23/2013 12:13:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_usua_sist_event_alter_inf] 
	(@p_codi_usua VARCHAR(30),
	@P_CODI_EVEN VARCHAR(4),
	@P_FECH_EVEN DATETIME,
	@P_INFO_EVEN VARCHAR(128))
AS
BEGIN
	INSERT INTO USUA_SIST_EVEN (codi_usua,codi_even,fech_even,info_even) VALUES (@p_codi_usua,@P_CODI_EVEN,@P_FECH_EVEN, @P_INFO_EVEN);
END
GO
/****** Objeto:  UserDefinedFunction [dbo].[FU_AX_getMoneda]    Fecha de la secuencia de comandos: 09/23/2013 12:13:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER function [dbo].[FU_AX_getMoneda](
			@p_codi_pers numeric(10), 
			@p_corr_inst numeric(5), 
			@p_vers_inst numeric(5)
            ) 
            returns varchar(4000)
begin
	declare @vMoneda varchar(50)
	declare @vCantidad numeric(10,0)
	
	select	@vMoneda  = max(codi_unit), @vCantidad = count(codi_unit)
	from	dbax_inst_conc
	where	codi_pers = @p_codi_pers
	and		corr_inst = @p_corr_inst
	and		vers_inst = @p_vers_inst
	group by codi_unit
	order by 2 desc

	if(len(@vMoneda) = 0)
		return ''
	
	return @vMoneda
end
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_InsValoresIndicadores]    Fecha de la secuencia de comandos: 09/23/2013 12:13:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter procedure [dbo].[SP_AX_InsValoresIndicadores] (
	@p_codi_pers numeric(9,0),
	@p_corr_inst numeric(10,0),
	@p_vers_inst numeric(5,0),
	@p_codi_conc varchar(256),
	@p_codi_cntx varchar(1000),
	@p_valo_cntx varchar(1000),
    @p_Codi_unit varchar(50)
	)as
BEGIN
	delete from dbax_inst_conc 
	where codi_pers= @p_codi_pers 
	and corr_inst = @p_corr_inst 
	and vers_inst = @p_vers_inst
	and	pref_conc = 'indi'
	and	codi_conc = @p_codi_conc
	and	codi_cntx = @p_codi_cntx

	insert dbax_inst_conc (codi_pers, corr_inst, vers_inst,pref_conc, codi_conc, codi_cntx, valo_cntx, codi_unit) 
	values (@p_codi_pers, @p_corr_inst, @p_vers_inst,'indi',@p_codi_conc,@p_codi_cntx,@p_valo_cntx,@p_Codi_unit)
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getTipoMone]    Fecha de la secuencia de comandos: 09/23/2013 12:13:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 02-04-2013
-- Description:	Procedimiento Almacenado para traer el tipo de moneda con el que informaron
-- =============================================
ALTER PROCEDURE [dbo].[SP_AX_getTipoMone]
(
	@p_codi_pers varchar(30),
	@p_corr_inst varchar(30)
)
AS
BEGIN
	select max(codi_unit) as codi_mone
	from dbax_inst_conc 
	where codi_pers = @p_codi_pers 
	and corr_inst = @p_corr_inst 
	and codi_conc like '%Equity%'
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_empr_delete]    Fecha de la secuencia de comandos: 09/23/2013 12:11:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
ALTER procedure [dbo].[prc_empr_delete]
            @P_CODI_EMPR numeric 
 AS
 BEGIN
        DELETE empr
        WHERE codi_empr = @P_CODI_EMPR 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_mens_erro_alter]    Fecha de la secuencia de comandos: 09/23/2013 12:12:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas
-- alter date: 05-06-2013
-- Description:	Procedimiento que inserta los errores de SQL en la BD
-- =============================================
ALTER PROCEDURE [dbo].[prc_mens_erro_alter] 
	(
		@p_codi_erro INTEGER,
		@p_mens_erro VARCHAR(4000),
		@p_line_erro VARCHAR(256), 
		@p_prcc_erro VARCHAR(256),
		@p_corr_sess INTEGER
	)
AS	
BEGIN
	INSERT INTO dbn_mens_erro(codi_erro, mens_erro, line_erro, prcc_erro, corr_sess)
	VALUES(@p_codi_erro, @p_mens_erro,@p_line_erro,@p_prcc_erro, @p_corr_sess);
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_GetInstHTML]    Fecha de la secuencia de comandos: 09/23/2013 12:13:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_GetInstHTML](
@pCodiPers numeric(9,0),
@CorrInst numeric(10,0),
@VersInst numeric(5,0)
)
as
declare @vValo_html varchar(5000)
BEGIN
	select @vValo_html = valo_html 
	from dbax_dife_xbrl 
	where codi_pers=@pCodiPers 
	and corr_inst=@CorrInst 
	and vers_inst=@VersInst
	
	if(len(@vValo_html)>0)
	begin
		select @vValo_html
	end
	else
	begin
		select ''
	end
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_insConcDife]    Fecha de la secuencia de comandos: 09/23/2013 12:13:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter procedure [dbo].[SP_AX_insConcDife](
	@pCodi_pers numeric(9,0) ,
	@pCorr_inst varchar(10),
	@pVers_inst numeric(5,0),
	@pCodi_conc varchar(256),
	@pCodi_cntx varchar(256),
	@pValo_cntx varchar(256)) 
as
BEGIN
insert into dbax_dife_xbrl(codi_pers,corr_inst,vers_inst,codi_conc,codi_cntx,valo_cntx)
values (@pCodi_pers,@pCorr_inst,@pVers_inst,@pCodi_conc,@pCodi_cntx,@pValo_cntx)
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_insHtmlDife]    Fecha de la secuencia de comandos: 09/23/2013 12:13:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter procedure [dbo].[SP_AX_insHtmlDife](
	@pCodi_pers numeric(9,0) ,
	@pCorr_inst varchar(10),
	@pVers_inst numeric(5,0),
	@pValo_html varchar(5000)) 
as
BEGIN
	insert into dbax_dife_xbrl values(@pCodi_pers,@pCorr_inst,@pVers_inst,@pValo_html)
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_dbax_inst_conc_conv_mone]    Fecha de la secuencia de comandos: 09/23/2013 12:11:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[prc_dbax_inst_conc_conv_mone]
(
	@p_codi_pers VARCHAR(16),
	@p_corr_inst NUMERIC(10,0),
	@p_vers_inst NUMERIC(5,0),
	@p_codi_emex VARCHAR(30),
	@p_codi_empr NUMERIC(16)
)
AS
BEGIN

	DECLARE @l_mone_loca VARCHAR(3)
	DECLARE @l_mone_refe VARCHAR(3)
	DECLARE @l_mone_inte VARCHAR(3)

	DECLARE @v_valo_loca numeric(18,4)
	DECLARE @v_valo_refe numeric(18,4)
	DECLARE @v_valo_inte numeric(18,4)
	
	SELECT @l_mone_loca = valo_paem FROM para_empr WHERE codi_paem = 'mone_loca' AND codi_emex = @p_codi_emex and codi_empr = @p_codi_empr;
	SELECT @l_mone_refe = valo_paem FROM para_empr WHERE codi_paem = 'mone_refe' AND codi_emex = @p_codi_emex and codi_empr = @p_codi_empr;
	SELECT @l_mone_inte = valo_paem FROM para_empr WHERE codi_paem = 'mone_inte' AND codi_emex = @p_codi_emex and codi_empr = @p_codi_empr;
	
	--copia el valor de valo_cntx a valo_orig, si el campo valo_orig es nulo
	UPDATE	dbax_inst_conc
	SET		valo_orig = valo_cntx
	FROM	dbax_inst_conc i,
			dbax_inst_unit u,
--			dbn_camb_mone d,
			dbn_defi_mone dm
	WHERE	valo_orig is null
	AND		i.codi_pers		=	u.codi_pers
	AND		i.corr_inst		=	u.corr_inst
	AND		i.vers_inst		=	u.vers_inst
	AND		i.codi_unit		=	u.codi_unit
	AND		i.codi_unit		=	dm.codi_mone
	AND		i.codi_pers		=	@p_codi_pers
	AND		i.corr_inst		=	@p_corr_inst
	AND		i.vers_inst		=	@p_vers_inst
	AND		substring(u.desc_unit, charindex(':',u.desc_unit)+1,10) = dm.codi_mone;
	
	UPDATE	dbax_inst_conc
	SET		valo_cntx = valo_orig,
			valo_refe = valo_orig,
			valo_inte = valo_orig
	FROM	dbax_inst_conc i,
			dbax_inst_unit u,
--			dbn_camb_mone d,
			dbn_defi_mone dm
	WHERE	valo_orig is not null
	AND		i.codi_pers		=	u.codi_pers
	AND		i.corr_inst		=	u.corr_inst
	AND		i.vers_inst		=	u.vers_inst
	AND		i.codi_unit		=	u.codi_unit
	AND		i.codi_unit		=	dm.codi_mone
	AND		i.codi_pers		=	@p_codi_pers
	AND		i.corr_inst		=	@p_corr_inst
	AND		i.vers_inst		=	@p_vers_inst
	AND		substring(u.desc_unit, charindex(':',u.desc_unit)+1,10) = dm.codi_mone
	AND     exists (select 1 
					from dbax_defi_conc c 
					where c.pref_conc = i.pref_conc 
					and   c.codi_conc = i.codi_conc 
					and   c.tipo_valo != 'xbrli:monetaryItemType');
	
	print('fin copia valor original - ' + @p_codi_pers)
	--**CONVERTir valor en valo_cntx**-
	UPDATE	dbax_inst_conc
	SET		valo_cntx = convert(varchar(5000),replace(convert(numeric(38,0),convert(numeric(38,14),CAST(LTRIM(RTRIM(replace(valo_cntx,',','.')))AS FLOAT)) * d.valo_camo),'.',','))
	FROM	dbax_inst_conc i,
			dbax_inst_unit u,
			dbn_camb_mone d,
			dbn_defi_mone dm
	WHERE	valo_cntx = valo_orig
	AND		i.codi_pers		=	@p_codi_pers
	AND		i.corr_inst		=	@p_corr_inst
	AND		i.vers_inst		=	@p_vers_inst
	AND		i.codi_pers		=	u.codi_pers
	AND		i.corr_inst		=	u.corr_inst
	AND		i.vers_inst		=	u.vers_inst
	AND		i.codi_unit		=	u.codi_unit
	AND		i.corr_conc		=	i.corr_conc
	AND		i.codi_unit		=	d.codi_mone1
	AND		d.codi_mone		=	@l_mone_loca
	AND		substring(u.desc_unit, charindex(':',u.desc_unit)+1,10) = dm.codi_mone
	AND		d.fech_camo = dbo.lastday(i.corr_inst)
	AND     exists (select 1 
					from dbax_defi_conc c 
					where c.pref_conc = i.pref_conc 
					and   c.codi_conc = i.codi_conc 
					and   c.tipo_valo = 'xbrli:monetaryItemType');
	print('fin valo_cntx - ' + @p_codi_pers)
	
	--**Asignar valor a valo_refe**--
	UPDATE	dbax_inst_conc
	SET		valo_refe = convert(varchar(5000),replace(convert(numeric(38,14),CAST(LTRIM(RTRIM(replace(valo_cntx,',','.')))AS FLOAT) / d.valo_camo),'.',','))
	FROM	dbax_inst_conc i,
			dbax_inst_unit u,
			dbn_defi_mone dm,
			dbn_camb_mone d
	WHERE	i.valo_refe is null
	AND		dbo.esNumero(valo_cntx) = 'S'
	AND		i.codi_pers		=	@p_codi_pers
	AND		i.corr_inst		=	@p_corr_inst
	AND		i.vers_inst		=	@p_vers_inst
	AND		i.codi_pers		=	u.codi_pers
	AND		i.corr_inst		=	u.corr_inst
	AND		i.vers_inst		=	u.vers_inst
	AND		i.codi_unit		=	u.codi_unit
	AND		i.corr_conc		=	i.corr_conc
	AND		d.codi_mone		=	@l_mone_loca
	AND		d.codi_mone1	=	@l_mone_refe
	AND		substring(u.desc_unit, charindex(':',u.desc_unit)+1,10) = dm.codi_mone
	AND		d.fech_camo		=	dbo.lastday(i.corr_inst)
	AND     exists (select 1 
					from dbax_defi_conc c 
					where c.pref_conc = i.pref_conc 
					and   c.codi_conc = i.codi_conc 
					and   c.tipo_valo = 'xbrli:monetaryItemType');
	print('fin valor_refe - ' + @p_codi_pers)
	
	--**Asignar valor a valo_inte**--
	UPDATE	dbax_inst_conc
	SET		valo_inte =  convert(varchar(5000),replace(convert(numeric(38,4),CAST(LTRIM(RTRIM(replace(valo_cntx,',','.')))AS FLOAT) / d.valo_camo ),'.',','))
	FROM	dbax_inst_conc i,
			dbax_inst_unit u,
			dbn_defi_mone dm,
			dbn_camb_mone d
	WHERE	i.valo_inte is null
	AND		dbo.esNumero(valo_cntx) = 'S'
	AND		i.codi_pers		=	@p_codi_pers
	AND		i.corr_inst		=	@p_corr_inst
	AND		i.vers_inst		=	@p_vers_inst
	AND		i.codi_pers		=	u.codi_pers
	AND		i.corr_inst		=	u.corr_inst
	AND		i.vers_inst		=	u.vers_inst
	AND		i.codi_unit		=	u.codi_unit
	AND		i.corr_conc		=	i.corr_conc
	AND		d.codi_mone		=	@l_mone_loca
	AND		d.codi_mone1	=	@l_mone_inte
	AND		substring(u.desc_unit, charindex(':',u.desc_unit)+1,10) = dm.codi_mone
	AND		d.fech_camo		=	dbo.lastday(i.corr_inst)
	AND     exists (select 1 
					from dbax_defi_conc c 
					where c.pref_conc = i.pref_conc 
					and   c.codi_conc = i.codi_conc 
					and   c.tipo_valo = 'xbrli:monetaryItemType');
	
	print('fin valo_inte - ' + @p_codi_pers)
	
	--Ejecuta calculo para dbax_data_hira  aplica solo para AACH
	-- 2013 hacia arriba
	if (@p_corr_inst > 201301)
	begin
		exec prc_dbax_inse_data_hira @p_codi_pers, @p_corr_inst, @p_vers_inst, @p_codi_emex,@p_codi_empr
	end
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_dbax_calc_actu]    Fecha de la secuencia de comandos: 09/23/2013 12:11:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[prc_dbax_calc_actu]
(
	@p_codi_emex varchar(30),
	@p_codi_empr numeric(9),
	@p_codi_segm varchar(16),
	@p_peri_desd varchar(6),
	@p_peri_hast varchar(6),
	@p_peri_actu varchar(6)
) as
begin
	DECLARE @l_mone_loca VARCHAR(3)
	DECLARE @l_mone_actu VARCHAR(3)
	DECLARE @l_indi_ipc1 numeric(5,2)
	
	SELECT	@l_mone_loca = valo_paem FROM para_empr WHERE codi_emex = @p_codi_emex and codi_empr = @p_codi_empr and codi_paem = 'mone_loca';
  
	set @l_mone_actu = 'IPC';

	delete dbax_data_actu
	where  codi_emex = @p_codi_emex
	and    codi_empr = @p_codi_empr
	and    peri_actu = @p_peri_actu
--	and    codi_pers = @p_codi_pers

	declare @v_numero numeric(9)
	
	select @v_numero = count(*)
	from   dbax_data_acpe
	where  codi_emex = @p_codi_emex
	and    codi_empr = @p_codi_empr
	and    peri_actu = @p_peri_actu
	
	if @v_numero = 0
	begin
		insert into dbax_data_acpe (codi_emex, codi_empr, peri_actu)
		values (@p_codi_emex, @p_codi_empr, @p_peri_actu)
	end

	insert into dbax_data_actu (
			codi_emex, codi_empr, peri_actu, codi_pers, 
			peri_conc, pref_conc, codi_conc, valo_actu)
	SELECT 	@p_codi_emex, @p_codi_empr, @p_peri_actu, 
			i.codi_pers, i.corr_inst, i.pref_conc, 
			i.codi_conc, 
			cast(convert(numeric(30,4), replace(replace(i.valo_cntx,',','.'),' ','')) * d1.valo_camo / d2.valo_camo as numeric(30,4))
	FROM	dbax_inst_conc i,
			dbax_inst_unit u,
			dbn_defi_mone  d,
			dbn_camb_mone  d1,
			dbn_camb_mone  d2
	WHERE	i.codi_pers	in (select codi_pers
							from dbax_defi_pers w 
							where codi_segm = @p_codi_segm)
	AND		i.corr_inst	between	@p_peri_desd and @p_peri_hast
	AND		i.vers_inst		=	(select max(vers_inst) 
								 from	dbax_inst_vers v
								 where	v.codi_pers = i.codi_pers
								 and	v.corr_inst = i.corr_inst)
	AND		i.codi_cntx		=	(select codi_cntx 
								from  dbax_inst_cntx c 
								where c.codi_pers = i.codi_pers
								and   c.corr_inst = i.corr_inst
								and   c.vers_inst = i.vers_inst
								and   c.codi_cntx = i.codi_cntx
								and   (substring(replace(c.fini_cntx,'-',''),1,6) = convert(varchar(6),i.corr_inst)
									or substring(replace(c.ffin_cntx,'-',''),1,6) = convert(varchar(6),i.corr_inst)))
	AND     dbo.esnumero(i.valo_cntx) = 'S'
	AND		u.codi_pers		=	i.codi_pers
	AND		u.corr_inst		=	i.corr_inst
	AND		u.vers_inst		=	i.vers_inst
	AND		u.codi_unit		=	i.codi_unit
	AND     substring(u.desc_unit, charindex(':',u.desc_unit)+1,10) = d.codi_mone
	AND		d1.codi_mone   = @l_mone_loca
	AND		d1.codi_mone1  = @l_mone_actu
	and     d1.fech_camo   = dbo.addmonths(@p_peri_actu, -1)
	AND		d2.codi_mone   = @l_mone_loca
	AND		d2.codi_mone1  = @l_mone_actu
	and     d2.fech_camo   = dbo.addmonths(i.corr_inst, -1)

	insert into dbax_data_actu (codi_emex, codi_empr, peri_actu, codi_pers, peri_conc, pref_conc, codi_conc, codi_ramo, sub_ramo, valo_actu)
	SELECT 	@p_codi_emex,	@p_codi_empr,	@p_peri_actu, 
			i.codi_pers,	i.peri_conc,	i.pref_conc, 
			i.codi_conc,	i.codi_ramo,	i.sub_ramo, 
			cast(convert(numeric(30,4), replace(replace(i.valo_conc,',','.'),' ','')) * d1.valo_camo / d2.valo_camo as numeric(30,4))
	FROM	dbax_data_hira i,
			dbn_defi_mone  d,
			dbn_camb_mone  d1,
			dbn_camb_mone  d2
	WHERE	i.codi_emex	   = @p_codi_emex
	AND		i.codi_pers	in (select codi_pers
							from dbax_defi_pers w 
							where codi_segm = @p_codi_segm)
	AND		i.peri_conc	between	@p_peri_desd and @p_peri_hast
	AND     dbo.esnumero(i.valo_conc) = 'S'
	AND		d1.codi_mone   = @l_mone_loca
	AND		d1.codi_mone1  = @l_mone_actu
	and     d1.fech_camo   = dbo.addmonths(@p_peri_actu, -1)
	AND		d2.codi_mone   = @l_mone_loca
	AND		d2.codi_mone1  = @l_mone_actu
	and     d2.fech_camo   = dbo.addmonths(i.peri_conc, -1)
end
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getArchivosPorGrupoSegmento]    Fecha de la secuencia de comandos: 09/23/2013 12:13:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getArchivosPorGrupoSegmento](
@pCodiEmex varchar(30),
@pCodiEmpr numeric (9,0),
@pCorrInst varchar(10),
@pDescripcion varchar(100),
@pGrupo varchar(50),
@pSegmento varchar(50),
@pTipo varchar(10),
@pNombArch varchar(100)
)
as
BEGIN
	/*	
		@pTipoDesc = 'D' se devuelve descripcion "por defecto", 
		@pTipoDesc = 'P' devuelve descripcion por defecto y personalizada
		@pTipoDesc  = 'C' SE DEVUELVE SOLO LAS DE MAS DE UNA VERSIÓN
	*/
	declare @vComodinGrup varchar(1)
	declare @vComodinSegm varchar(1)
	declare @vComodinTipo varchar(1)
	set @vComodinGrup = '%'
	set @vComodinSegm = '%'
	set @vComodinTipo = '%'

	if ( @pGrupo != '')
	begin
		set @vComodinGrup = ''
	end

	if ( @pSegmento != '')
	begin
		set @vComodinSegm = ''
	end

	if ( @pTipo != '')
	begin
		set @vComodinTipo = ''
	end

	declare @vComodinCorr varchar(1)
	set @vComodinCorr = '%'

	if (@pCorrInst != '')
	begin
		set @vComodinCorr = ''
	end

	select t.codi_pers, t.corr_inst, ia.vers_inst, max(ia.nomb_arch) nomb_arch
	from (select	v.desc_pers, v.codi_pers, v.corr_inst
		 from	(select distinct dp.codi_pers as codi_pers,
								dg.desc_grup as desc_grup,
								dp.codi_grup as codi_grup,
								dp.codi_segm as codi_segm,
								id.corr_inst as corr_inst,
								dp.tipo_taxo as tipo_taxo,
								dp.desc_pers as desc_pers
				from	dbax_defi_pers dp 
							left join dbax_defi_peho dh 
							on	dh.codi_emex = @pCodiEmex 
							and	dh.codi_empr = @pCodiEmpr 
							and	dp.codi_pers = dh.codi_pers
								left join dbax_defi_grup dg
								on	dg.codi_grup = dp.codi_grup,
						dbax_inst_docu id
				where	(dp.codi_pers like '%' + @pDescripcion + '%' 
						or dh.desc_empr like '%' + @pDescripcion + '%' 
						or dp.desc_pers like '%' + @pDescripcion + '%')
				and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
				and		dp.codi_pers = id.codi_pers
				and		id.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
				) v
		left join dbax_defi_segm ds
			on v.codi_segm = ds.codi_segm
		left join dbax_tipo_taxo tt
			on v.tipo_taxo = tt.tipo_taxo
		where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
		and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo) t
	left join dbax_inst_arch ia
	on	t.codi_pers = ia.codi_pers
	and	t.corr_inst = ia.corr_inst
	and	ia.vers_inst = dbo.FU_AX_getUltimaVersion(ia.codi_pers, ia.corr_inst)
	and	ia.nomb_arch like '%' + @pNombArch + '%'
	group by t.desc_pers, t.codi_pers, t.corr_inst, ia.vers_inst
	order by t.desc_pers, t.codi_pers, t.corr_inst, ia.vers_inst
	--order by 1,2,3
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_sys_param_alter]    Fecha de la secuencia de comandos: 09/23/2013 12:12:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	<Author,,Aaron Rojas>
-- alter date: <alter Date,,2012-10-01>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_sys_param_alter] 
@P_PARAM_NAME VARCHAR(30),  
@P_PARAM_VALUE VARCHAR(100), 
@P_PARAM_DESC VARCHAR(200)
AS
BEGIN
	INSERT INTO DBO.SYS_PARAM 
	(PARAM_NAME,object_type,PARAM_VALUE, PARAM_DESC) 
	VALUES (@P_PARAM_NAME, 'O', @P_PARAM_VALUE, @P_PARAM_DESC);
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_sys_param_read]    Fecha de la secuencia de comandos: 09/23/2013 12:12:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	<Author,,Aaron Rojas>
-- alter date: <alter Date,,2012-10-01>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_sys_param_read]  (
	@tsTipo as VARCHAR(4),	
	@tnPagina as INTEGER,	
	@tnRegPag as INTEGER, 
	@tsCondicion as VARCHAR(2048),
	@tsPar1 as VARCHAR(256), @tsPar2 as VARCHAR(256), 
	@tsPar3 as VARCHAR(256), @tsPar4 as VARCHAR(256), @tsPar5 as VARCHAR(256),
	@p_codi_usua VARCHAR(30), @p_codi_empr INTEGER, @p_codi_emex VARCHAR(30))
AS 
	/*
	 Procedimiento para rescatar datos de la tabla SYS_PARAM
     CON EL 
	 Parametros
		@tsTipo 
			S: Query utilizada para el mantenedor
			L: Query utilizada para el listador
			LV: Query utilizada para las listas de valor
		@tnPagina	: Numero de pagina a rescatar
		@tnRegPag	: Numero de registros por pagina
		@tsCondicion : Condicion, clausula Where
		@tsPar1		: Parametro 1 - PARAM_NAME
		@tsPar2		: Parametro 2
		@tsPar3		: Parametro 3
		@tsPar4		: Parametro 4
		@tsPar5		: Parametro 5
	 */
	declare @sql_dyn as INTEGER
	declare @sql as nVARCHAR(2048)
BEGIN
	IF (@tsTipo = 'S')
	BEGIN
		 SELECT	PARAM_NAME, 
			PARAM_VALUE, 
			CODI_MODU, 
			PARAM_DESC, 
			CASE PARAM_TYPE
				WHEN 'S' THEN 1
				ELSE 0
				END AS PARAM_TYPE, 
			OBJECT_TYPE, 
			PARAM_ORDER
		 FROM  SYS_PARAM
		 WHERE PARAM_NAME = @tsPar1
	END
	ELSE IF (@tsTipo = 'L')
	BEGIN
		SET @sql = 	'SELECT	ROW_NUMBER() OVER(ORDER BY PARAM_NAME ASC) AS REG, 
							PARAM_NAME, 
							PARAM_VALUE, 
							CODI_MODU, 
							PARAM_DESC,
							OBJECT_TYPE,
							PARAM_ORDER
					 FROM SYS_PARAM
					 WHERE 1 = 1 '

		SET @sql = @sql + isnull(@tsCondicion,'')

		EXECUTE prc_list_dyn @sql, @tnPagina, @tnRegPag 
	END
	ELSE IF (@tsTipo = 'LO')
	BEGIN
		WITH REGISTROS AS (
			 SELECT	ROW_NUMBER() OVER(ORDER BY PARAM_NAME ASC) AS REG,
				PARAM_NAME, 
				PARAM_VALUE, 
				CODI_MODU, 
				PARAM_DESC, 
				CASE PARAM_TYPE
					WHEN 'S' THEN 1
					ELSE 0
					END AS PARAM_TYPE, 
				OBJECT_TYPE, 
				PARAM_ORDER
			 FROM  SYS_PARAM
			 WHERE PARAM_NAME like '%' + isnull(@tsCondicion,'') + '%'
		)
	 
		SELECT  top (@tnRegPag) (SELECT MAX(REG) FROM REGISTROS) TOT_REG,(((SELECT MAX(REG) FROM REGISTROS) / @tnRegPag) + 1) PAG_MAX, *      
		FROM	REGISTROS
		WHERE	REG > ((@tnPagina-1) * @tnRegPag)
	END
	ELSE IF (@tsTipo = 'LV')
	BEGIN
		 SELECT		PARAM_NAME AS CODIGO, 
					PARAM_VALUE AS VALOR
		 FROM	SYS_PARAM
		 ORDER BY PARAM_NAME
	END
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_sys_param_delete]    Fecha de la secuencia de comandos: 09/23/2013 12:12:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	<Author,,Aaron Rojas>
-- alter date: <alter Date,,2012-10-01>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_sys_param_delete] 
@p_param_name VARCHAR(30)
AS
BEGIN
	DELETE FROM sys_param WHERE param_name = @p_param_name;
END
GO
/****** Objeto:  UserDefinedFunction [dbo].[separaMiles]    Fecha de la secuencia de comandos: 09/23/2013 12:13:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER function [dbo].[separaMiles] (@p_valor varchar(8000)) returns varchar(8000)
as
begin
	declare	@v_entero varchar(8000)
	declare	@v_numero  varchar(8000)
	declare	@v_decimal varchar(30)
	declare	@subvalor varchar (3)
    declare @v_signo varchar(1)
	
	declare @pLargo	  integer
	select  @pLargo = param_value from sys_param where param_name = 'DBAX_LARG_DECI'
	set     @p_valor = replace(@p_valor,',','.')
	
	if(dbo.esNumero(@p_valor)='S' and @p_valor != '')
	begin
		set @p_valor = convert(varchar(256), convert(decimal(38,14),@p_valor))

		set @v_numero = ''
		set @v_signo = ''
		if(substring(@p_valor,1,1)='-')
		begin
			set @v_signo='-'
			set @p_valor=replace(@p_valor,'-','')
		end

		if (charindex('.', @p_valor)>0)
		begin
			set @v_entero  = substring(@p_valor,1,charindex('.', @p_valor)-1)
			set @v_decimal = substring(@p_valor,charindex('.', @p_valor)+1, 256)
			set @v_decimal = replace(round('0.' + @v_decimal, @pLargo),'0.','')
		end
		else
		begin
			set @v_entero  = @p_valor
		end

		while(len(@v_entero) > 3)
		begin
			set @subvalor = substring(@v_entero, len(@v_entero)-2, 3)
			set @v_numero = '.' + @subvalor +  @v_numero
			set @v_entero = substring(@v_entero, 1, len(@v_entero)-3)
		end

		if(@v_signo = '')
			set @v_numero = @v_entero + @v_numero
		else
			set @v_numero = @v_signo + @v_entero + @v_numero

		set @v_numero = @v_numero + ',' + dbo.rpad(@v_decimal,@pLargo,'0')
	end
	else
	begin
		set @v_numero = '<div>' + replace(replace(@p_valor,'<!--',''),'-->','') + '</div>'
	end
	
	return @v_numero 
end
GO
/****** Objeto:  StoredProcedure [dbo].[prc_sys_param_update]    Fecha de la secuencia de comandos: 09/23/2013 12:12:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	<Author,,Aaron Rojas>
-- alter date: <alter Date,,2012-10-01>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_sys_param_update] 
@P_PARAM_NAME VARCHAR(30),
@P_PARAM_VALUE VARCHAR(100), 
@P_PARAM_DESC VARCHAR(200)
AS
BEGIN
	UPDATE sys_param SET	
		param_value = @P_PARAM_VALUE, 
		param_desc = @P_PARAM_DESC
	WHERE PARAM_NAME = @P_PARAM_NAME;
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_InsDatosCalIndicadores]    Fecha de la secuencia de comandos: 09/23/2013 12:13:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_InsDatosCalIndicadores](
    @p_codi_emex  varchar(30),
	@p_codi_empr  numeric(9,0),
	@p_corr_inst varchar(6),
	@p_codi_grup varchar(50),
	@p_codi_segm varchar(50),
	@p_codi_indi  varchar(100),
	@p_tipo_taxo varchar(30)
) as
BEGIN
	declare @pRuta_binario varchar(256)
	declare @pFecha_ini varchar(256)

	set @pRuta_binario = (select PARAM_VALUE from sys_param where PARAM_NAME = 'DBAX_XBRL_BINA')
	set @pFecha_ini  = (select getdate())

	insert dbax_dbne_proc(prog_proc, args_proc, fech_crea, fini_proc, esta_proc) 
	values (@pRuta_binario + '\CalculoIndicadores.exe ', '"' + convert(varchar,@p_codi_emex) + '" "' + convert(varchar,@p_codi_empr) + '" "' + @p_corr_inst + '" "' + convert(varchar,@p_codi_grup) + '" "' + convert(varchar,@p_codi_segm) + '" "' + convert(varchar,@p_codi_indi) + '" "'+@p_tipo_taxo+'"', @pFecha_ini, @pFecha_ini, 'I')
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_priv_logi_read]    Fecha de la secuencia de comandos: 09/23/2013 12:12:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 22-11-2012
-- Description:	Procedimiento Almacenado para obtener el valor de los parametros de privilegios
-- =============================================
ALTER PROCEDURE [dbo].[prc_priv_logi_read]
@P_PARAM_NAME VARCHAR(25) 
AS
BEGIN
	SELECT PARAM_VALUE FROM SYS_PARAM WHERE PARAM_NAME = @P_PARAM_NAME;
END
GO
/****** Objeto:  UserDefinedFunction [dbo].[separaMilesMone]    Fecha de la secuencia de comandos: 09/23/2013 12:13:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER function [dbo].[separaMilesMone] (	@p_valo_loca varchar(8000), 
											@p_valo_refe varchar(8000), 
											@p_valo_inte varchar(8000), 
											@p_codi_mone varchar(16)) returns varchar(8000)
as
begin
	declare	@p_valor  varchar(8000)
	declare	@v_entero varchar(8000)
	declare	@v_numero varchar(8000)
	declare	@v_decimal varchar(30)
	declare	@subvalor varchar (3)
    declare @v_signo varchar(1)
	
	declare @pLargo	  integer
	select  @pLargo = param_value from sys_param where param_name = 'DBAX_LARG_DECI'
	if (@p_codi_mone='MONE_LOCA')
		set @p_valor = replace(@p_valo_loca,',','.')
	else if (@p_codi_mone='MONE_REFE')
		set @p_valor = replace(@p_valo_refe,',','.')
	else
		set @p_valor = replace(@p_valo_inte,',','.')
	
	if(dbo.esNumero(@p_valor)='S' and @p_valor != '')
	begin
		set @p_valor = convert(varchar(256), convert(decimal(38,14),@p_valor))

		set @v_numero = ''
		set @v_signo = ''
		if(substring(@p_valor,1,1)='-')
		begin
			set @v_signo='-'
			set @p_valor=replace(@p_valor,'-','')
		end

		if (charindex('.', @p_valor)>0)
		begin
			set @v_entero  = substring(@p_valor,1,charindex('.', @p_valor)-1)
			set @v_decimal = substring(@p_valor,charindex('.', @p_valor)+1, 256)
			set @v_decimal = replace(round('0.' + @v_decimal, @pLargo),'0.','')
		end
		else
		begin
			set @v_entero  = @p_valor
		end

		while(len(@v_entero) > 3)
		begin
			set @subvalor = substring(@v_entero, len(@v_entero)-2, 3)
			set @v_numero = '.' + @subvalor +  @v_numero
			set @v_entero = substring(@v_entero, 1, len(@v_entero)-3)
		end

		if(@v_signo = '')
			set @v_numero = @v_entero + @v_numero
		else
			set @v_numero = @v_signo + @v_entero + @v_numero

		set @v_numero = @v_numero + ',' + dbo.rpad(@v_decimal,@pLargo,'0')
	end
	else
	begin
		set @v_numero = '<div>' + replace(replace(@p_valor,'<!--',''),'-->','') + '</div>'
	end
	
	return @v_numero 
end
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_GetContextosIndicadorEmpresa]    Fecha de la secuencia de comandos: 09/23/2013 12:13:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter procedure [dbo].[SP_AX_GetContextosIndicadorEmpresa](
	@pCodi_pers varchar(16),
	@pCorr_inst varchar(10),
	@pVers_inst numeric(5),
	@pCodiIndi varchar(100))
as
	declare @pVers_ante numeric (5,0)
BEGIN
	select	distinct ic.codi_cntx as codi_cntx, 
			vc.fini_cntx as fini_cntx, 
			isnull(vc.ffin_cntx,'') as ffin_cntx
	from	dbax_inst_conc ic,
			dbax_form_deta fm,
			dbax_view_cntx vc
	where	ic.codi_pers = @pCodi_pers 
	and		ic.corr_inst = @pCorr_inst
	and		ic.vers_inst = @pVers_inst
	and		vc.codi_pers = ic.codi_pers
	and		vc.corr_inst = ic.corr_inst
	and		vc.vers_inst = ic.vers_inst
	and		vc.codi_cntx = ic.codi_cntx
	and		fm.codi_indi = @pCodiIndi
	and		ic.pref_conc = fm.pref_conc
	and		ic.codi_conc = fm.codi_conc
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_sys_rous_read]    Fecha de la secuencia de comandos: 09/23/2013 12:12:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	<Author,,Aaron Rojas>
-- alter date: <alter Date,,2012-10-01>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_sys_rous_read]  (
	@tsTipo as VARCHAR(4),	
	@tnPagina as INTEGER,	
	@tnRegPag as INTEGER, 
	@tsCondicion as VARCHAR(128),
	@tsPar1 as VARCHAR(256), @tsPar2 as VARCHAR(256), 
	@tsPar3 as VARCHAR(256), @tsPar4 as VARCHAR(256), @tsPar5 as VARCHAR(256),
	@p_codi_usua VARCHAR(30), @p_codi_empr INTEGER, @p_codi_emex VARCHAR(30))
AS 
	/*
	 Procedimiento para rescatar datos de la tabla SYS_PARAM
     CON EL 
	 Parametros
		@tsTipo 
			S: Query utilizada para el mantenedor
			L: Query utilizada para el listador
			LV: Query utilizada para las listas de valor
			LVA: Query utilizada para la Lista de valor del mantenedor de listador para privilegios
		@tnPagina	: Numero de pagina a rescatar
		@tnRegPag	: Numero de registros por pagina
		@tsCondicion : Condicion, clausula Where
		@tsPar1		: Parametro 1 - PARAM_NAME
		@tsPar2		: Parametro 2
		@tsPar3		: Parametro 3
		@tsPar4		: Parametro 4
		@tsPar5		: Parametro 5
	 */
	declare @sql_dyn as INTEGER
	declare @sql as nVARCHAR(2048)
	 
BEGIN
	IF (@tsTipo = 'S')
	BEGIN
		 SELECT		 codi_rous		,desc_rous,
					 sent_rous		,obje_type,
					 tabl_type		,codi_modu
		FROM  SYS_ROUS
		WHERE CODI_ROUS = @tsPar1
	END
	ELSE IF (@tsTipo = 'L')
	BEGIN
		SET @sql = 	'SELECT	ROW_NUMBER() OVER(ORDER BY codi_rous ASC) AS REG, 
							codi_rous,	desc_rous, 
							sent_rous,	obje_type, 
							tabl_type,	codi_modu
					 FROM SYS_ROUS
					 WHERE 1 = 1 '

		SET @sql = @sql + isnull(@tsCondicion,'')

		EXECUTE prc_list_dyn @sql, @tnPagina, @tnRegPag 
	END
	ELSE IF (@tsTipo = 'LO')
	BEGIN
		WITH REGISTROS AS (
			 SELECT	ROW_NUMBER() OVER(ORDER BY DESC_ROUS ASC) AS REG,
					 codi_rous		,desc_rous,
					 sent_rous		,obje_type,
					 tabl_type		,codi_modu
			 FROM  SYS_ROUS
			 WHERE CODI_ROUS like '%' + isnull(@tsCondicion,'') + '%'
		)
	 
		SELECT  top (@tnRegPag) (SELECT MAX(REG) FROM REGISTROS) TOT_REG, *      
		FROM	REGISTROS
		WHERE	REG > (@tnPagina * @tnRegPag) - @tnPagina
	END
	ELSE IF (@tsTipo = 'LV')
		BEGIN
			 SELECT	CODI_ROUS AS CODIGO, 
					DESC_ROUS AS VALOR
			 FROM	SYS_ROUS
			 ORDER BY DESC_ROUS
		END
	--Es para filtrar por modulo
	ELSE IF (@tsTipo = 'LVA')
		BEGIN
			 SELECT	CODI_ROUS AS CODIGO, 
					DESC_ROUS AS VALOR
			 FROM	SYS_ROUS
			 WHERE CODI_MODU = @tsPar1
			 ORDER BY DESC_ROUS
		END
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_sys_module_read]    Fecha de la secuencia de comandos: 09/23/2013 12:12:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas 27-03-2013
-- alter date: <alter Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[prc_sys_module_read] (
	@tsTipo as VARCHAR(4),	
	@tnPagina as INTEGER,	
	@tnRegPag as INTEGER, 
	@tsCondicion as VARCHAR(2048),
	@tsPar1 as VARCHAR(256), @tsPar2 as VARCHAR(256), 
	@tsPar3 as VARCHAR(256), @tsPar4 as VARCHAR(256), @tsPar5 as VARCHAR(256),
	@p_codi_usua VARCHAR(30), @p_codi_empr INTEGER, @p_codi_emex VARCHAR(30))
AS
	/*
	 Procedimiento para rescatar datos de la tabla SYS_PARAM
     CON EL 
	 Parametros
		@tsTipo 
			S: Query utilizada para el mantenedor
			L: Query utilizada para el listador
			LV: Query utilizada para las listas de valor
		@tnPagina	: Numero de pagina a rescatar
		@tnRegPag	: Numero de registros por pagina
		@tsCondicion : Condicion, clausula Where
		@tsPar1		: Parametro 1 - PARAM_NAME
		@tsPar2		: Parametro 2
		@tsPar3		: Parametro 3
		@tsPar4		: Parametro 4
		@tsPar5		: Parametro 5
	 */
	declare @sql_dyn as INTEGER
	declare @sql as nVARCHAR(2048)
	 
BEGIN
	IF(@tsTipo = 'S')
		BEGIN
			SELECT		 CODI_MODU		,TIPO_OBJE,
						 RESU_MODU		,DESC_MODU,
						 VERS_MODU		,CODE_MODU,
						 CODI_MODU1
			FROM  SYS_MODULE
			WHERE CODI_MODU = @tsPar1;
		END
	ELSE IF(@tsTipo = 'L')
		BEGIN
			SET @sql = 	'SELECT	ROW_NUMBER() OVER(ORDER BY CODI_MODU ASC) AS REG, 
						 CODI_MODU		,TIPO_OBJE,
						 RESU_MODU		,DESC_MODU,
						 VERS_MODU		,CODE_MODU,
						 CODI_MODU1
						 FROM  SYS_MODULE
						 WHERE 1 = 1 '

			SET @sql = @sql + isnull(@tsCondicion,'')

			EXECUTE prc_list_dyn @sql, @tnPagina, @tnRegPag 
		END
	ELSE IF(@tsTipo = 'LV')
		BEGIN
			SELECT		CODI_MODU AS CODIGO,
						DESC_MODU AS VALOR
			FROM  SYS_MODULE
			ORDER BY(CODI_MODU);
		END
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getContextos]    Fecha de la secuencia de comandos: 09/23/2013 12:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getContextos]
	@pCodiEmex varchar(30),
	@pCodiEmpr varchar(100),
	@pCorrInst numeric(6,0),
	@pCodiInfo varchar(50) = ''
as
BEGIN
	if(@pCorrInst = 0)
	begin
		select	distinct dc.codi_cntx,
				dc.desc_cntx,
				dc.diai_cntx as codi_diai, 
				dbo.FU_AX_getDescFech(diai_cntx) diai_cntx, 
				dc.anoi_cntx as codi_anoi,
				dbo.FU_AX_getDescFech(anoi_cntx) anoi_cntx,
				dc.diat_cntx as codi_diat,
				dbo.FU_AX_getDescFech(diat_cntx) diat_cntx,
				dc.anot_cntx as codi_anot,
				dbo.FU_AX_getDescFech(anot_cntx) anot_cntx,
				null fini_cntx,
				null ffin_cntx,
				isnull(ic.orde_cntx,9999) as 'orde_cntx',
				dc.orde_cntx as 'dc.orde_cntx'
		from	dbax_defi_cntx dc
				left join dbax_info_cntx ic
				on dc.codi_cntx = ic.codi_cntx
				and	ic.codi_info like @pCodiInfo
				and	ic.codi_emex = @pCodiEmex
				and ic.codi_empr = @pCodiEmpr
		where	dc.codi_emex = @pCodiEmex
		and		dc.codi_empr = @pCodiEmpr
		order by isnull(ic.orde_cntx,9999), dc.orde_cntx
	end
	else
	begin
		select	distinct dc.codi_cntx, 
				dc.desc_cntx,
				dc.diai_cntx as codi_diai, 
				dbo.FU_AX_getDescFech(diai_cntx) diai_cntx, 
				dc.anoi_cntx as codi_anoi,
				dbo.FU_AX_getDescFech(anoi_cntx) anoi_cntx,
				dc.diat_cntx as codi_diat,
				dbo.FU_AX_getDescFech(diat_cntx) diat_cntx,
				dc.anot_cntx as codi_anot,
				dbo.FU_AX_getDescFech(anot_cntx) anot_cntx,
				dbo.FU_AX_getFechas(@pCorrInst , diai_cntx, anoi_cntx) fini_cntx,
				dbo.FU_AX_getFechas(@pCorrInst , diat_cntx, anot_cntx) ffin_cntx,
				isnull(ic.orde_cntx,9999) as 'orde_cntx',
				dc.orde_cntx as 'dc.orde_cntx'
		from	dbax_defi_cntx dc
				left join dbax_info_cntx ic
				on dc.codi_cntx = ic.codi_cntx
				and	ic.codi_info like @pCodiInfo
				and	ic.codi_emex = @pCodiEmex
				and ic.codi_empr = @pCodiEmpr
		where	dc.codi_emex = @pCodiEmex
		and		dc.codi_empr = @pCodiEmpr
		order by isnull(ic.orde_cntx,9999), dc.orde_cntx
	end
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_calc_mone_all]    Fecha de la secuencia de comandos: 09/23/2013 12:11:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Galdamez
ALTER PROCEDURE [dbo].[prc_calc_mone_all]
	@p_corr_inst varchar(16)
AS
BEGIN
	--Declaramos una variable cursor
	DECLARE cursor_corrinst CURSOR FOR
	SELECT	df.codi_pers as codi_pers, max(iv.vers_inst) as vers_inst
	FROM	dbax_defi_pers df, 
			dbax_inst_vers iv
	WHERE	df.codi_pers = iv.codi_pers
	and		iv.corr_inst = @p_corr_inst
	group by df.codi_pers
	
	--declaramos las variables para asignarselas al cursor
	declare @p_codi_pers varchar(16)
	declare @p_vers_inst integer
	
	open cursor_corrinst
		--le asignamos los datos del cursor a las variables
		fetch next from cursor_corrinst
		into @p_codi_pers, @p_vers_inst
		
		--agregamos un ciclo para ejecutar un procedimiento almacenado
		while @@fetch_status = 0
		BEGIN
		
			exec prc_dbax_inse_data_hira @p_codi_pers, @p_corr_inst, @p_vers_inst, '1','1'
		
		--ejecutar nueva

			fetch next from cursor_corrinst
			into @p_codi_pers, @p_vers_inst
		END
	---cerramos el cursor
	close cursor_corrinst
	--liberamos la memoria que ocupo el cursor, y lo destruimos
	deallocate cursor_corrinst
	
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_GetValoCntx]    Fecha de la secuencia de comandos: 09/23/2013 12:13:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_GetValoCntx](
	@pCodi_pers	 varchar(16),
	@pCorr_inst  numeric(10,0),
	@pVers_inst  numeric(5,0),
	@pCodi_cntx  varchar(50),
    @pCodi_conc  varchar(256),
    @pFini_cntx  varchar(10),
    @pFfin_cntx  varchar(10)) as

BEGIN
	if(  @pFfin_cntx  = '')
		begin
				select	replace(conc.valo_cntx,',','.') as valo_cntx, 
						conc.codi_unit as codi_unit, 
						conc.codi_cntx as codi_cntx
				from	dbax_inst_conc conc, 
						dbax_view_cntx cntx
				where	conc.codi_pers = cntx.codi_pers
				and		conc.corr_inst = cntx.corr_inst
				and		conc.vers_inst = cntx.vers_inst
				and		conc.codi_cntx = cntx.codi_cntx
				and		conc.codi_pers = @pCodi_pers 
				and		conc.corr_inst = @pCorr_inst
				and		conc.vers_inst = @pVers_inst
				and		conc.codi_conc = @pCodi_conc
				and		cntx.fini_cntx = @pFini_cntx 
                and		cntx.ffin_cntx is null 
		end
	else
		begin
                select	replace(conc.valo_cntx,',','.') as valo_cntx, 
						conc.codi_unit as codi_unit,
						conc.codi_cntx as codi_cntx
				from	dbax_inst_conc conc, 
						dbax_view_cntx cntx
				where	conc.codi_pers = cntx.codi_pers
				and		conc.corr_inst = cntx.corr_inst
				and		conc.vers_inst = cntx.vers_inst
				and		conc.codi_cntx = cntx.codi_cntx
				and		conc.codi_pers = @pCodi_pers 
				and		conc.corr_inst = @pCorr_inst 
				and		conc.vers_inst = @pVers_inst
				and		conc.codi_conc = @pCodi_conc
				and		(cntx.fini_cntx = @pFini_cntx or cntx.fini_cntx = substring(convert(varchar,DATEADD(day,1,convert(datetime, @pFini_cntx,20)),20),1,10))
                and		cntx.ffin_cntx = @pFfin_cntx
		end
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_empr_update]    Fecha de la secuencia de comandos: 09/23/2013 12:11:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
ALTER procedure [dbo].[prc_empr_update]
            @P_CODI_EMPR numeric, 
            @P_NOMB_EMPR VARCHAR(40), 
            @P_GIRO_EMPR VARCHAR(3), 
            @P_DIRE_EMPR VARCHAR(50), 
            @P_CODI_COMU VARCHAR(8), 
            @P_CODI_CIUD VARCHAR(8), 
            @P_RUTT_EMPR numeric, 
            @P_DIGI_EMPR VARCHAR(1), 
            @P_CODI_RAMO VARCHAR(12), 
            @P_NFAN_EMPR VARCHAR(40), 
            @P_CODI_PERS VARCHAR(16), 
            @P_EMPR_CODG numeric, 
            @P_EMPR_NOMB VARCHAR(40), 
            @P_FONO_EMPR VARCHAR(20), 
            @P_RUTT_REPL numeric, 
            @P_DGTO_REPL VARCHAR(1), 
            @P_NOMB_REPL VARCHAR(35), 
            @P_CACA_EMPR VARCHAR(3), 
            @P_MUTU_EMPR VARCHAR(3), 
            @P_POMU_EMPR numeric, 
            @P_POCA_EMPR numeric, 
            @P_FECA_EMPR datetime, 
            @P_FEMU_EMPR datetime, 
            @P_CINE_EMPR VARCHAR(3), 
            @P_CUEN_EMPR VARCHAR(12), 
            @P_CAJA_EMPR VARCHAR(3), 
            @P_COLOR_EMPR VARCHAR(15), 
            @P_LOGO_EMPR VARCHAR(15), 
            @P_CLAV_ENCR VARCHAR(30), 
            @P_ASUN_FACT_EMPR VARCHAR(200), 
            @P_TEXT_FACT_EMPR VARCHAR(2000), 
            @P_CODI_EMEX VARCHAR(30) ,
			@P_CORR_SESS INTEGER,
			@P_CODI_ERRO VARCHAR(30) output,
			@P_MENS_ERRO VARCHAR(512) output
 AS
 BEGIN
 declare @p_vali_usua VARCHAR(2)
	declare @p_nume_erro INTEGER
	declare @p_mens_erro1 VARCHAR(4000)
	declare @p_line_erro VARCHAR(256)
	declare @p_prcc_erro VARCHAR(256)
	BEGIN TRY
		IF(@p_vali_usua = 'S')
		BEGIN
        UPDATE empr
             SET codi_empr = @P_CODI_EMPR, 
                 nomb_empr = @P_NOMB_EMPR, 
                 giro_empr = @P_GIRO_EMPR, 
                 dire_empr = @P_DIRE_EMPR, 
                 codi_comu = @P_CODI_COMU, 
                 codi_ciud = @P_CODI_CIUD, 
                 rutt_empr = @P_RUTT_EMPR, 
                 digi_empr = @P_DIGI_EMPR, 
                 codi_ramo = @P_CODI_RAMO, 
                 nfan_empr = @P_NFAN_EMPR, 
                 codi_pers = @P_CODI_PERS, 
                 empr_codg = @P_EMPR_CODG, 
                 empr_nomb = @P_EMPR_NOMB, 
                 fono_empr = @P_FONO_EMPR, 
                 rutt_repl = @P_RUTT_REPL, 
                 dgto_repl = @P_DGTO_REPL, 
                 nomb_repl = @P_NOMB_REPL, 
                 caca_empr = @P_CACA_EMPR, 
                 mutu_empr = @P_MUTU_EMPR, 
                 pomu_empr = @P_POMU_EMPR, 
                 poca_empr = @P_POCA_EMPR, 
                 feca_empr = @P_FECA_EMPR, 
                 femu_empr = @P_FEMU_EMPR, 
                 cine_empr = @P_CINE_EMPR, 
                 cuen_empr = @P_CUEN_EMPR, 
                 caja_empr = @P_CAJA_EMPR, 
                 color_empr = @P_COLOR_EMPR, 
                 logo_empr = @P_LOGO_EMPR, 
                 clav_encr = @P_CLAV_ENCR, 
                 asun_fact_empr = @P_ASUN_FACT_EMPR, 
                 text_fact_empr = @P_TEXT_FACT_EMPR, 
                 codi_emex = @P_CODI_EMEX
             WHERE codi_empr = @P_CODI_EMPR 
        END
		ELSE
		set @P_CODI_ERRO = '1';
		set @P_MENS_ERRO = 'Usted no cuenta con los privilegios para realizar esta acción';
		execute prc_mens_erro_alter @P_CODI_ERRO, @P_MENS_ERRO, @p_line_erro, @p_prcc_erro, @P_CORR_SESS
    END TRY
    BEGIN CATCH
		SELECT @P_CODI_ERRO = ERROR_NUMBER();		SELECT @p_mens_erro1 = ERROR_MESSAGE();
		SELECT @p_line_erro = ERROR_LINE();			SELECT @p_prcc_erro = ERROR_PROCEDURE();
		
		execute prc_mens_erro_alter @P_CODI_ERRO, @p_mens_erro1, @p_line_erro, @p_prcc_erro, @P_CORR_SESS
    END CATCH
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_empr_alter]    Fecha de la secuencia de comandos: 09/23/2013 12:11:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
ALTER procedure [dbo].[prc_empr_alter]
            (
				@P_CODI_EMPR numeric,				@P_NOMB_EMPR VARCHAR(40), 
				@P_GIRO_EMPR VARCHAR(3),			@P_DIRE_EMPR VARCHAR(50), 
				@P_CODI_COMU VARCHAR(8),			@P_CODI_CIUD VARCHAR(8), 
				@P_RUTT_EMPR numeric,				@P_DIGI_EMPR VARCHAR(1), 
				@P_CODI_RAMO VARCHAR(12),			@P_NFAN_EMPR VARCHAR(40), 
				@P_CODI_PERS VARCHAR(16),			@P_EMPR_CODG numeric, 
				@P_EMPR_NOMB VARCHAR(40),			@P_FONO_EMPR VARCHAR(20), 
				@P_RUTT_REPL numeric,				@P_DGTO_REPL VARCHAR(1), 
				@P_NOMB_REPL VARCHAR(35),			@P_CACA_EMPR VARCHAR(3), 
				@P_MUTU_EMPR VARCHAR(3),			@P_POMU_EMPR numeric, 
				@P_POCA_EMPR numeric,				@P_FECA_EMPR datetime, 
				@P_FEMU_EMPR datetime,				@P_CINE_EMPR VARCHAR(3), 
				@P_CUEN_EMPR VARCHAR(12),			@P_CAJA_EMPR VARCHAR(3), 
				@P_COLOR_EMPR VARCHAR(15),			@P_LOGO_EMPR VARCHAR(15), 
				@P_CLAV_ENCR VARCHAR(30),			@P_ASUN_FACT_EMPR VARCHAR(200), 
				@P_TEXT_FACT_EMPR VARCHAR(2000),	@P_CODI_EMEX VARCHAR(30),
				@P_CORR_SESS INTEGER,					@P_CODI_ERRO VARCHAR(30) output,
				@P_MENS_ERRO VARCHAR(512) output
            )
 AS
 BEGIN
	declare @p_vali_usua VARCHAR(30)
	set @p_vali_usua = dbo.fnc_valida_privilegios(@P_CORR_SESS);
	
	declare @p_nume_erro INTEGER
	declare @p_mens_erro1 VARCHAR(4000)
	declare @p_line_erro VARCHAR(256)
	declare @p_prcc_erro VARCHAR(256)
	
	BEGIN TRY
		if(@p_vali_usua = 'S')
		BEGIN
			INSERT INTO empr
			(
				codi_empr,	nomb_empr,	giro_empr,	dire_empr,	codi_comu,	codi_ciud,	rutt_empr,	digi_empr, 
				codi_ramo,	nfan_empr,	codi_pers,	empr_codg,	empr_nomb,	fono_empr,	rutt_repl,	dgto_repl, 
				nomb_repl,	caca_empr,	mutu_empr,	pomu_empr,	poca_empr,	feca_empr,	femu_empr,	cine_empr, 
				cuen_empr,	caja_empr,	color_empr,	logo_empr,	clav_encr,	codi_emex
			)
			VALUES
			(
				 @P_CODI_EMPR,	@P_NOMB_EMPR, @P_GIRO_EMPR,	@P_DIRE_EMPR,	@P_CODI_COMU,	@P_CODI_CIUD, 
				 @P_RUTT_EMPR,	@P_DIGI_EMPR, @P_CODI_RAMO,	@P_NFAN_EMPR,	@P_CODI_PERS,	@P_EMPR_CODG, 
				 @P_EMPR_NOMB,	@P_FONO_EMPR, @P_RUTT_REPL,	@P_DGTO_REPL,	@P_NOMB_REPL,	@P_CACA_EMPR, 
				 @P_MUTU_EMPR,	@P_POMU_EMPR, @P_POCA_EMPR,	@P_FECA_EMPR,	@P_FEMU_EMPR,	@P_CINE_EMPR, 
				 @P_CUEN_EMPR,	@P_CAJA_EMPR, @P_COLOR_EMPR, @P_LOGO_EMPR,	@P_CLAV_ENCR,	@P_CODI_EMEX
			);
		END
		ELSE
		set @P_CODI_ERRO = '1';
		set @P_MENS_ERRO = 'Usted no cuenta con los privilegios para realizar esta acción';
		execute prc_mens_erro_alter @P_CODI_ERRO, @P_MENS_ERRO, @p_line_erro, @p_prcc_erro, @P_CORR_SESS
    END TRY
    BEGIN CATCH
		SELECT @P_CODI_ERRO = ERROR_NUMBER();		SELECT @p_mens_erro1 = ERROR_MESSAGE();
		SELECT @p_line_erro = ERROR_LINE();			SELECT @p_prcc_erro = ERROR_PROCEDURE();
		execute prc_mens_erro_alter @P_CODI_ERRO, @p_mens_erro1, @p_line_erro, @p_prcc_erro, @P_CORR_SESS
		set @P_MENS_ERRO = '';
    END CATCH
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[dbnet_init_sess]    Fecha de la secuencia de comandos: 09/23/2013 12:11:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[dbnet_init_sess]
(@p_codi_usua varchar(30), @P_CORR_SESS numeric(22) output  )  
as
begin
declare
    @P_CODI_EMEX varchar(30),
    @P_CODI_PERS varchar(30),
    @P_CODI_MODU varchar(30),
    @P_CODI_ROUS varchar(30),
    @P_CODI_CECO varchar(30),
    @P_CODI_CULT varchar(30),
    @P_CODI_EMPR numeric(9)
 
	select  @P_CODI_EMPR = u.codi_empr,
			@P_CODI_EMEX = u.codi_emex,
			@P_CODI_CECO = u.codi_ceco,
			@P_CODI_PERS = u.codi_pers,
			@P_CODI_MODU = r.codi_modu,
			@P_CODI_CULT = u.codi_cult,
			@P_CODI_ROUS = r.codi_rous
	from	usua_sist u, sys_rous r
 	where	codi_usua = @p_codi_usua
			and r.codi_rous=u.codi_rous 
        
 insert into sys_session (	codi_usua,codi_empr,
							codi_emex,codi_ceco,codi_pers,
							codi_modu,codi_cult,codi_rous,fein_sess)
 values (	@p_codi_usua,@P_CODI_EMPR,
			@P_CODI_EMEX,@P_CODI_CECO,@P_CODI_PERS,
			@P_CODI_MODU,@P_CODI_CULT,@P_CODI_ROUS,GETDATE()) 
 set @P_CORR_SESS=@@IDENTITY  
 select  @P_CORR_SESS CORR_SESS,@P_CODI_EMPR CODI_EMPR,
	@P_CODI_EMEX CODI_EMEX,@P_CODI_CECO CODI_CECO,
	@P_CODI_PERS CODI_PERS ,@P_CODI_MODU CODI_MODU,
	@P_CODI_ROUS CODI_ROUS,@P_CODI_CULT CODI_CULT
 into #sys_session
 delete from sys_session 
 where codi_usua = @p_codi_usua
    and fein_sess<=GETDATE()-4 
end
GO
/****** Objeto:  StoredProcedure [dbo].[dbnet_context]    Fecha de la secuencia de comandos: 09/23/2013 12:11:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aaron Rojas
-- alter date: 27-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER procedure [dbo].[dbnet_context]
@p_codi_usua varchar(30) ,
@P_CODI_EMPR numeric(9) output,
@P_CODI_PERS  varchar(30) output,
@P_CODI_CECO  varchar(30) output,
@P_CODI_ROUS  varchar(30) output,
@P_CODI_CULT  varchar(30) output,
@P_CODI_MODU  varchar(30) output,
@P_CODI_EMEX  varchar(30) output,
@P_PASS_ENCR  varchar(30) output,
@P_NOMB_EMPR varchar(30) output,
@P_EXISTE  varchar(1) output,
@P_MENSAJE  varchar(200) output
 as 
declare @P_TIPO_MESS varchar(30),
 	 @P_CODI_MESS numeric(22)
begin
set @P_EXISTE='S'
  
    begin
      select @P_CODI_PERS = u.codi_pers,
		@P_CODI_EMPR = u.codi_empr, 
		@P_CODI_CECO = u.codi_ceco, 
		@P_CODI_CULT = u.codi_cult, 
		@P_CODI_ROUS = u.codi_rous,
		@P_CODI_MODU = r.codi_modu,
		@P_CODI_EMEX = u.codi_emex,
		@P_PASS_ENCR = u.pass_usua,
		@P_NOMB_EMPR = e.nomb_empr
      from usua_sist u, sys_rous r,empr e
      where codi_usua = @p_codi_usua
      and r.codi_rous = u.codi_rous
     if @@rowcount=0 
	begin
	set @P_EXISTE='N'
	set @P_CODI_MESS=1000001
	exec dbnet_message @P_CODI_MESS,@P_MENSAJE output ,@P_TIPO_MESS 
        return
        end
    end
end
GO
/****** Objeto:  StoredProcedure [dbo].[prc_sys_rous_update]    Fecha de la secuencia de comandos: 09/23/2013 12:12:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_sys_rous_update]
            @P_CODI_ROUS VARCHAR(30), 
            @P_DESC_ROUS VARCHAR(100), 
            @P_SENT_ROUS VARCHAR(2000),
            @P_CODI_MODU VARCHAR(30) 
 AS
 BEGIN
        UPDATE sys_rous
             SET codi_rous = @P_CODI_ROUS, 
                 desc_rous = @P_DESC_ROUS, 
                 sent_rous = @P_SENT_ROUS, 
                 obje_type = 'L', 
                 tabl_type = 'L', 
                 codi_modu = @P_CODI_MODU
             WHERE codi_rous = @P_CODI_ROUS 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_sys_rous_alter]    Fecha de la secuencia de comandos: 09/23/2013 12:12:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 26/10/2012
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_sys_rous_alter]
            @P_CODI_ROUS VARCHAR(30), 
            @P_DESC_ROUS VARCHAR(100), 
            @P_SENT_ROUS VARCHAR(2000),
            @P_CODI_MODU VARCHAR(30) 
 AS
 BEGIN
        INSERT INTO sys_rous(
            codi_rous, 
            desc_rous, 
            sent_rous, 
            obje_type, 
            tabl_type, 
            codi_modu
        )
        VALUES
        (
             @P_CODI_ROUS, 
             @P_DESC_ROUS, 
             @P_SENT_ROUS, 
             'L', 
             'L', 
             @P_CODI_MODU
        );
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[prc_sys_rous_delete]    Fecha de la secuencia de comandos: 09/23/2013 12:12:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas Martínez
-- alter date: 27-03-2013
-- Description:	<Description,,>
-- =============================================
ALTER  procedure [dbo].[prc_sys_rous_delete]
            @P_CODI_ROUS VARCHAR(30) 
 AS
 BEGIN
        DELETE sys_rous
        WHERE codi_rous = @P_CODI_ROUS 
 END;
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getInfoValoColuDimension]    Fecha de la secuencia de comandos: 09/23/2013 12:13:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getInfoValoColuDimension] 
	@p_CodiPers  varchar(16),
	@p_CorrInst  numeric(10,0),
	@p_VersInst  numeric(5,0),
	@p_codi_info varchar(256),
	@p_desc_miemb varchar(256),
	@p_dimension varchar(256),
    @p_tipo_memb varchar(256),
    @p_codi_mone varchar(30),
    @p_codi_conc varchar(256),
    @p_pref_conc varchar(30),
    @p_tipo_taxo varchar(30),
    @p_sald_ini varchar(2)
 as
BEGIN
	declare @v_peri_proc numeric(6)
	if (isnull(@p_sald_ini,'0')='I')
		set @v_peri_proc = (round(@p_CorrInst/100,0) - 1) * 100 + '12'
	else
		set @v_peri_proc = @p_CorrInst

	-- Obtenciòn de eje por dimension
	declare @V_eje varchar(256)
	set @V_eje =(	select max(dd.codi_axis)
					from   dbax_dime_diax dd
					where  dd.codi_dein = @p_codi_info
					and    dd.codi_dime = @p_dimension)

	-- Obtenciòn de tipo de periodo
	declare @v_tipo_peri varchar(30)
	select @v_tipo_peri = tipo_peri
	from   dbax_defi_conc
	where  pref_conc = @p_pref_conc
	and    codi_conc = @p_codi_conc

	-- Obtenciòn de tipo de miembro
	declare @v_tipo_memb varchar(30)
	select @v_tipo_memb = max(tipo_memb)
	from   dbax_dime_diax dd, dbax_dime_memb dm
	where  dd.codi_dein = @p_codi_info
	and	   dd.codi_dime = @p_dimension
	and	   dd.codi_axis = @v_eje
	and	   dm.pref_axis = dd.pref_dime
	and	   dm.codi_axis = dd.codi_axis

IF(@p_codi_mone = 'MONE_LOCA')
BEGIN
	select distinct		 dd.codi_axis as codi_axis
						,dd.pref_dime as pref_memb
						,dm.orde_memb as orde_memb
						,dm.tipo_memb as tipo_memb
						,dm.codi_memb as codi_memb
						,''			  as codi_cntx
						,dx.desc_memb as desc_conc
						,isnull(id.ffin_cntx,id.fini_cntx) as fini_cntx
--						,dbo.separaMilesMone(sum(convert(numeric,ic.valo_cntx)),
--											 sum(convert(numeric(40,4),ic.valo_refe)),
--											 sum(convert(numeric,ic.valo_inte)),
--											 @p_codi_mone)	   as valo_cntx
						,dbo.separaMiles(sum(convert(numeric,ic.valo_cntx))) 	   as valo_cntx
	from	 dbax_dime_diax dd
			,dbax_dime_memb dm
			,dbax_desc_conc dc
			,dbax_inst_dicx dx
			,dbax_inst_cntx id
			 left join dbax_inst_conc ic
							on	ic.codi_pers = id.codi_pers
							and	ic.corr_inst = id.corr_inst
							and ic.vers_inst = id.vers_inst
							and ic.codi_cntx = id.codi_cntx
							and ic.pref_conc = @p_pref_conc
							and ic.codi_conc = @p_codi_conc
	where	dd.codi_dein = @p_codi_info
	and		dd.codi_dime = @p_dimension
	and		dd.codi_axis = @v_eje
	and		dm.pref_axis = dd.pref_dime
	and		dm.codi_axis = dd.codi_axis
	and		id.codi_pers = @p_CodiPers
	and		id.corr_inst = @p_CorrInst
	and		id.vers_inst = @p_VersInst
	and     @v_peri_proc = replace(substring(isnull(id.ffin_cntx,id.fini_cntx),1,7),'-','')
	and	    dx.codi_pers = id.codi_pers
	and     dx.corr_inst = id.corr_inst
	and     dx.vers_inst = id.vers_inst
	and     dx.codi_cntx = id.codi_cntx
	and     dx.codi_axis = dd.pref_dime + ':' + dd.codi_axis
	and     ((dm.tipo_memb = 'dimension-default' and dm.tipo_memb = @v_tipo_memb) or 
             (dm.tipo_memb = 'domain-member'	 and dm.tipo_memb = @v_tipo_memb and dx.codi_memb = dm.pref_memb + ':' + dm.codi_memb))
	and     exists (select	1 
					from	dbax_dime_conc dc,
							dbax_inst_conc dx
					where   dc.codi_dein = dd.codi_dein
					and		dc.pref_dime = dd.pref_dime
					and		dc.codi_dime = dd.codi_dime
					and		dx.codi_pers = id.codi_pers
					and     dx.corr_inst = id.corr_inst
					and     dx.vers_inst = id.vers_inst
					and     dx.codi_cntx = id.codi_cntx
					and     dx.pref_conc = dc.pref_conc
					and     dx.codi_conc = dc.codi_conc)	
	and	   dc.pref_conc = dm.pref_memb 
	and    dc.codi_conc = dm.codi_memb
	group by dd.codi_axis, dd.pref_dime, dm.tipo_memb, dm.orde_memb, dm.codi_memb, dx.desc_memb, isnull(id.ffin_cntx,id.fini_cntx)
	order by dm.orde_memb
END
ELSE IF(@p_codi_mone = 'MONE_INTE')
BEGIN
	select distinct		 dd.codi_axis as codi_axis
						,dd.pref_dime as pref_memb
						,dm.orde_memb as orde_memb
						,dm.tipo_memb as tipo_memb
						,dm.codi_memb as codi_memb
						,''			  as codi_cntx
						,dx.desc_memb as desc_conc
						,isnull(id.ffin_cntx,id.fini_cntx) as fini_cntx
--						,dbo.separaMilesMone(sum(convert(numeric,ic.valo_cntx)),
--											 sum(convert(numeric(40,4),ic.valo_refe)),
--											 sum(convert(numeric,ic.valo_inte)),
--											 @p_codi_mone)	   as valo_cntx
						,dbo.separaMiles(sum(convert(numeric,ic.valo_inte))) 	   as valo_cntx
	from	 dbax_dime_diax dd
			,dbax_dime_memb dm
			,dbax_desc_conc dc
			,dbax_inst_dicx dx
			,dbax_inst_cntx id
			 left join dbax_inst_conc ic
							on	ic.codi_pers = id.codi_pers
							and	ic.corr_inst = id.corr_inst
							and ic.vers_inst = id.vers_inst
							and ic.codi_cntx = id.codi_cntx
							and ic.pref_conc = @p_pref_conc
							and ic.codi_conc = @p_codi_conc
	where	dd.codi_dein = @p_codi_info
	and		dd.codi_dime = @p_dimension
	and		dd.codi_axis = @v_eje
	and		dm.pref_axis = dd.pref_dime
	and		dm.codi_axis = dd.codi_axis
	and		id.codi_pers = @p_CodiPers
	and		id.corr_inst = @p_CorrInst
	and		id.vers_inst = @p_VersInst
	and     @v_peri_proc = replace(substring(isnull(id.ffin_cntx,id.fini_cntx),1,7),'-','')
	and	    dx.codi_pers = id.codi_pers
	and     dx.corr_inst = id.corr_inst
	and     dx.vers_inst = id.vers_inst
	and     dx.codi_cntx = id.codi_cntx
	and     dx.codi_axis = dd.pref_dime + ':' + dd.codi_axis
	and     ((dm.tipo_memb = 'dimension-default' and dm.tipo_memb = @v_tipo_memb) or 
             (dm.tipo_memb = 'domain-member'	 and dm.tipo_memb = @v_tipo_memb and dx.codi_memb = dm.pref_memb + ':' + dm.codi_memb))
	and     exists (select	1 
					from	dbax_dime_conc dc,
							dbax_inst_conc dx
					where   dc.codi_dein = dd.codi_dein
					and		dc.pref_dime = dd.pref_dime
					and		dc.codi_dime = dd.codi_dime
					and		dx.codi_pers = id.codi_pers
					and     dx.corr_inst = id.corr_inst
					and     dx.vers_inst = id.vers_inst
					and     dx.codi_cntx = id.codi_cntx
					and     dx.pref_conc = dc.pref_conc
					and     dx.codi_conc = dc.codi_conc)	
	and	   dc.pref_conc = dm.pref_memb 
	and    dc.codi_conc = dm.codi_memb
	group by dd.codi_axis, dd.pref_dime, dm.tipo_memb, dm.orde_memb, dm.codi_memb, dx.desc_memb, isnull(id.ffin_cntx,id.fini_cntx)
	order by dm.orde_memb	
END
ELSE IF(@p_codi_mone = 'VALO_REFE')
BEGIN
	select distinct		 dd.codi_axis as codi_axis
						,dd.pref_dime as pref_memb
						,dm.orde_memb as orde_memb
						,dm.tipo_memb as tipo_memb
						,dm.codi_memb as codi_memb
						,''			  as codi_cntx
						,dx.desc_memb as desc_conc
						,isnull(id.ffin_cntx,id.fini_cntx) as fini_cntx
--						,dbo.separaMilesMone(sum(convert(numeric,ic.valo_cntx)),
--											 sum(convert(numeric(40,4),ic.valo_refe)),
--											 sum(convert(numeric,ic.valo_inte)),
--											 @p_codi_mone)	   as valo_cntx
						,dbo.separaMiles(sum(convert(numeric,ic.valo_refe))) 	   as valo_cntx
	from	 dbax_dime_diax dd
			,dbax_dime_memb dm
			,dbax_desc_conc dc
			,dbax_inst_dicx dx
			,dbax_inst_cntx id
			 left join dbax_inst_conc ic
							on	ic.codi_pers = id.codi_pers
							and	ic.corr_inst = id.corr_inst
							and ic.vers_inst = id.vers_inst
							and ic.codi_cntx = id.codi_cntx
							and ic.pref_conc = @p_pref_conc
							and ic.codi_conc = @p_codi_conc
	where	dd.codi_dein = @p_codi_info
	and		dd.codi_dime = @p_dimension
	and		dd.codi_axis = @v_eje
	and		dm.pref_axis = dd.pref_dime
	and		dm.codi_axis = dd.codi_axis
	and		id.codi_pers = @p_CodiPers
	and		id.corr_inst = @p_CorrInst
	and		id.vers_inst = @p_VersInst
	and     @v_peri_proc = replace(substring(isnull(id.ffin_cntx,id.fini_cntx),1,7),'-','')
	and	    dx.codi_pers = id.codi_pers
	and     dx.corr_inst = id.corr_inst
	and     dx.vers_inst = id.vers_inst
	and     dx.codi_cntx = id.codi_cntx
	and     dx.codi_axis = dd.pref_dime + ':' + dd.codi_axis
	and     ((dm.tipo_memb = 'dimension-default' and dm.tipo_memb = @v_tipo_memb) or 
             (dm.tipo_memb = 'domain-member'	 and dm.tipo_memb = @v_tipo_memb and dx.codi_memb = dm.pref_memb + ':' + dm.codi_memb))
	and     exists (select	1 
					from	dbax_dime_conc dc,
							dbax_inst_conc dx
					where   dc.codi_dein = dd.codi_dein
					and		dc.pref_dime = dd.pref_dime
					and		dc.codi_dime = dd.codi_dime
					and		dx.codi_pers = id.codi_pers
					and     dx.corr_inst = id.corr_inst
					and     dx.vers_inst = id.vers_inst
					and     dx.codi_cntx = id.codi_cntx
					and     dx.pref_conc = dc.pref_conc
					and     dx.codi_conc = dc.codi_conc)	
	and	   dc.pref_conc = dm.pref_memb 
	and    dc.codi_conc = dm.codi_memb
	group by dd.codi_axis, dd.pref_dime, dm.tipo_memb, dm.orde_memb, dm.codi_memb, dx.desc_memb, isnull(id.ffin_cntx,id.fini_cntx)
	order by dm.orde_memb
END
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getValoConc]    Fecha de la secuencia de comandos: 09/23/2013 12:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getValoConc] 
	@p_CodiPers		numeric(9,0),
	@p_CorrInst		numeric(10,0),
	@p_VersInst		numeric(5,0),
	@p_PrefConc		varchar(50),
	@p_CodiConc		varchar(256),
	@p_finiCntx		varchar(15),
	@p_ffinCntx		varchar(15) as

BEGIN
	--Si version = 0, significa que debe calcularse la ultima version para la empresa/instancia
	if(@p_VersInst = 0)
	begin
		select @p_VersInst = max(vers_inst) from dbax_inst_vers where codi_pers = @p_CodiPers and corr_inst = @p_CorrInst
	end
	
	select	dbo.separaMiles(dbo.FU_AX_getValorPorFecha(@p_CodiPers,@p_CorrInst,@p_VersInst,@p_PrefConc,@p_CodiConc,@p_finiCntx,@p_ffinCntx,''))
END
GO
/****** Objeto:  StoredProcedure [dbo].[prc_read_dbax_getValorColumnaRamo]    Fecha de la secuencia de comandos: 09/23/2013 12:12:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aarón Rojas
-- alter date: 22-05-2013
-- Description:	Procedimiento Que Retorna el valor de un 
-- =============================================
ALTER PROCEDURE [dbo].[prc_read_dbax_getValorColumnaRamo]
(
	@p_codi_pers varchar(30),
	@p_corr_inst numeric(10,0),
	@p_vers_inst varchar(2), 
	@p_pref_conc varchar(6),
	@p_codi_conc varchar(30),
	@p_codi_mone varchar(30),
	@p_codi_segm varchar(30)
)
AS
BEGIN
	if(@p_codi_mone = 'MONE_LOCA' or @p_codi_mone = '' or @p_codi_mone is null)
	BEGIN
		select t1.codi_ramo, t1.codi_subr, dbo.separaMiles(t2.valo_cntx) as valo_cntx
		from (
		select r.codi_ramo, s.codi_conc codi_subr, r.nume_ramo, s.nume_ramo nume_subr
		from   dbax_defi_ramo r, dbax_defi_ramo s
		where  r.codi_segm = @p_codi_segm
		and    r.tipo_ramo = 'R'
		and    s.codi_segm = r.codi_segm
		and    s.tipo_ramo = 'S'
		) t1  left join (
		select	ir.codi_ramo, ir.codi_subr, ic.valo_cntx
		from	dbax_inst_conc ic,
				dbax_inst_ramo ir
		where	ic.codi_pers = @p_codi_pers
		and		ic.corr_inst = @p_corr_inst
		and		ic.vers_inst = @p_vers_inst
		and		ic.codi_conc = @p_codi_conc
		and		ic.codi_cntx = ir.codi_cntx
		and		ic.vers_inst = ir.vers_inst
		and		ic.codi_pers = ir.codi_pers
		and     ic.codi_cntx in (	select codi_cntx 
									from dbax_inst_cntx x 
									where x.codi_pers = ic.codi_pers 
									and x.corr_inst = '201303' 
									and  x.vers_inst = ic.vers_inst 
									and x.codi_cntx = ic.codi_cntx 
									and replace(substring(isnull(x.ffin_cntx,x.fini_cntx),1,7),'-','') = x.corr_inst)
		and		ic.pref_conc = @p_pref_conc)
		t2 on t1.codi_ramo = t2.codi_ramo and t1.codi_subr = t2.codi_subr
		order by t1.nume_ramo, t1.nume_subr
	END
	ELSE if(@p_codi_mone = 'MONE_REFE')
	BEGIN
		select t1.codi_ramo, t1.codi_subr, dbo.separaMiles(t2.valo_refe) as valo_cntx
		from (
		select r.codi_ramo, s.codi_conc codi_subr, r.nume_ramo, s.nume_ramo nume_subr
		from   dbax_defi_ramo r, dbax_defi_ramo s
		where  r.codi_segm = @p_codi_segm
		and    r.tipo_ramo = 'R'
		and    s.codi_segm = r.codi_segm
		and    s.tipo_ramo = 'S'
		) t1  left join (
		select	ir.codi_ramo, ir.codi_subr, ic.valo_refe
		from	dbax_inst_conc ic,
				dbax_inst_ramo ir
		where	ic.codi_pers = @p_codi_pers
		and		ic.corr_inst = @p_corr_inst
		and		ic.vers_inst = @p_vers_inst
		and		ic.codi_conc = @p_codi_conc
		and		ic.codi_cntx = ir.codi_cntx
		and		ic.vers_inst = ir.vers_inst
		and		ic.codi_pers = ir.codi_pers
		and     ic.codi_cntx in (select codi_cntx from dbax_inst_cntx x where x.codi_pers = ic.codi_pers and x.corr_inst = '201303' and  x.vers_inst = ic.vers_inst and x.codi_cntx = ic.codi_cntx and replace(substring(isnull(x.ffin_cntx,x.fini_cntx),1,7),'-','') = x.corr_inst )
		and		ic.pref_conc = @p_pref_conc)
		t2 on t1.codi_ramo = t2.codi_ramo and t1.codi_subr = t2.codi_subr
		order by t1.nume_ramo, t1.nume_subr
	END
	ELSE if(@p_codi_mone = 'MONE_INTE')
	BEGIN
		select t1.codi_ramo, t1.codi_subr, dbo.separaMiles(t2.valo_inte) as valo_cntx
		from (
		select r.codi_ramo, s.codi_conc codi_subr, r.nume_ramo, s.nume_ramo nume_subr
		from   dbax_defi_ramo r, dbax_defi_ramo s
		where  r.codi_segm = @p_codi_segm
		and    r.tipo_ramo = 'R'
		and    s.codi_segm = r.codi_segm
		and    s.tipo_ramo = 'S'
		) t1  left join (
		select	ir.codi_ramo, ir.codi_subr, ic.valo_inte
		from	dbax_inst_conc ic,
				dbax_inst_ramo ir
		where	ic.codi_pers = @p_codi_pers
		and		ic.corr_inst = @p_corr_inst
		and		ic.vers_inst = @p_vers_inst
		and		ic.codi_conc = @p_codi_conc
		and		ic.codi_cntx = ir.codi_cntx
		and		ic.vers_inst = ir.vers_inst
		and		ic.codi_pers = ir.codi_pers
		and     ic.codi_cntx in (select codi_cntx from dbax_inst_cntx x where x.codi_pers = ic.codi_pers and x.corr_inst = '201303' and  x.vers_inst = ic.vers_inst and x.codi_cntx = ic.codi_cntx and replace(substring(isnull(x.ffin_cntx,x.fini_cntx),1,7),'-','') = x.corr_inst )
		and		ic.pref_conc = @p_pref_conc)
		t2 on t1.codi_ramo = t2.codi_ramo and t1.codi_subr = t2.codi_subr
		order by t1.nume_ramo, t1.nume_subr
	END
END
GO
/****** Objeto:  StoredProcedure [dbo].[SP_AX_getInfoValoColu]    Fecha de la secuencia de comandos: 09/23/2013 12:13:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SP_AX_getInfoValoColu] 
	@p_CodiEmex  varchar(30),
	@p_CodiEmpr  numeric(9,0),
	@p_CodiPers  numeric(9,0),
	@p_CorrInst  numeric(10,0),
	@p_VersInst  numeric(5,0),
	@p_codi_info varchar(50),
	@p_finiCntx varchar(15),
	@p_ffinCntx varchar(15),
	@p_CodiMone varchar(16) as

BEGIN
	--Si version = 0, significa que debe calcularse la ultima version para la empresa/instancia
	if(@p_VersInst = 0)
	begin
		select	@p_VersInst = max(vers_inst) 
		from	dbax_inst_vers 
		where	codi_pers = @p_CodiPers 
		and		corr_inst = @p_CorrInst
	end
	--S elimino el gerValorPorFecha dado que toda la consulta de esa funcion esta aplicada en los left join
	--dbo.FU_AX_getValorPorFecha(	@p_CodiPers,
	--							@p_CorrInst,
	--							@p_VersInst,
	--							A.pref_conc,
	--							A.codi_conc,
	--							@p_finiCntx,
	--							@p_ffinCntx,
	--							@p_CodiMone)
			
if(@p_CodiMone = 'MONE_LOCA')
BEGIN
	select	dbo.separaMiles(max(ic.valo_cntx))
	from	dbax_info_conc A
			left join dbax_inst_cntx ix on ix.codi_pers = @p_CodiPers 
											and ix.corr_inst = @p_CorrInst 
											and ix.vers_inst = @p_VersInst
											and ((ix.fini_cntx = @p_finiCntx and ix.ffin_cntx = @p_ffinCntx) 
											or   (ix.fini_cntx = @p_finiCntx and ix.ffin_cntx is null)
											and not exists (select 1 
															from dbax_inst_dicx id 
															where id.codi_pers = ix.codi_pers
															and   id.corr_inst = ix.corr_inst
															and   id.vers_inst = ix.vers_inst
															and   id.codi_cntx = ix.codi_cntx))
			 left join dbax_inst_conc ic on ic.codi_pers = ix.codi_pers
											and ic.corr_inst = ix.corr_inst
											and ic.vers_inst = ix.vers_inst
											and ic.pref_conc = A.pref_conc
											and ic.codi_conc = A.codi_conc
											and ic.codi_cntx = ix.codi_cntx
											and not exists (select 1 
															from dbax_inst_dicx id 
															where id.codi_pers = ic.codi_pers
															and   id.corr_inst = ic.corr_inst
															and   id.vers_inst = ic.vers_inst
															and   id.codi_cntx = ic.codi_cntx)								
	where	A.codi_emex = @p_CodiEmex
	AND		A.codi_empr = @p_CodiEmpr
	AND		A.codi_info = @p_codi_info
	group by A.orde_conc
	order by A.orde_conc
END
ELSE IF(@p_CodiMone = 'MONE_INTE')
BEGIN
	select	dbo.separaMiles(max(ic.valo_inte))
	from	dbax_info_conc A
			left join dbax_inst_cntx ix on ix.codi_pers = @p_CodiPers 
											and ix.corr_inst = @p_CorrInst 
											and ix.vers_inst = @p_VersInst
											and ((ix.fini_cntx = @p_finiCntx and ix.ffin_cntx = @p_ffinCntx) 
											or   (ix.fini_cntx = @p_finiCntx and ix.ffin_cntx is null)
											and not exists (select 1 
															from dbax_inst_dicx id 
															where id.codi_pers = ix.codi_pers
															and   id.corr_inst = ix.corr_inst
															and   id.vers_inst = ix.vers_inst
															and   id.codi_cntx = ix.codi_cntx))
			 left join dbax_inst_conc ic on ic.codi_pers = ix.codi_pers
											and ic.corr_inst = ix.corr_inst
											and ic.vers_inst = ix.vers_inst
											and ic.pref_conc = A.pref_conc
											and ic.codi_conc = A.codi_conc
											and ic.codi_cntx = ix.codi_cntx
											and not exists (select 1 
															from dbax_inst_dicx id 
															where id.codi_pers = ic.codi_pers
															and   id.corr_inst = ic.corr_inst
															and   id.vers_inst = ic.vers_inst
															and   id.codi_cntx = ic.codi_cntx)								
	where	A.codi_emex = @p_CodiEmex
	AND		A.codi_empr = @p_CodiEmpr
	AND		A.codi_info = @p_codi_info
	group by A.orde_conc
	order by A.orde_conc
END
ELSE IF(@p_CodiMone = 'MONE_REFE')
BEGIN
	select	dbo.separaMiles(max(ic.valo_refe))
	from	dbax_info_conc A
			left join dbax_inst_cntx ix on ix.codi_pers = @p_CodiPers 
											and ix.corr_inst = @p_CorrInst 
											and ix.vers_inst = @p_VersInst
											and ((ix.fini_cntx = @p_finiCntx and ix.ffin_cntx = @p_ffinCntx) 
											or   (ix.fini_cntx = @p_finiCntx and ix.ffin_cntx is null)
											and not exists (select 1 
															from dbax_inst_dicx id 
															where id.codi_pers = ix.codi_pers
															and   id.corr_inst = ix.corr_inst
															and   id.vers_inst = ix.vers_inst
															and   id.codi_cntx = ix.codi_cntx))
			 left join dbax_inst_conc ic on ic.codi_pers = ix.codi_pers
											and ic.corr_inst = ix.corr_inst
											and ic.vers_inst = ix.vers_inst
											and ic.pref_conc = A.pref_conc
											and ic.codi_conc = A.codi_conc
											and ic.codi_cntx = ix.codi_cntx
											and not exists (select 1 
															from dbax_inst_dicx id 
															where id.codi_pers = ic.codi_pers
															and   id.corr_inst = ic.corr_inst
															and   id.vers_inst = ic.vers_inst
															and   id.codi_cntx = ic.codi_cntx)								
	where	A.codi_emex = @p_CodiEmex
	AND		A.codi_empr = @p_CodiEmpr
	AND		A.codi_info = @p_codi_info
	group by A.orde_conc
	order by A.orde_conc
END
END
GO