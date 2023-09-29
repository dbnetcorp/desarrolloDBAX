DECLARE @v_nomb_tecn varchar(100)
/*En la siguiente linea debe ingresar nombre de persona que ejecuta script, por ejemplo: SET @v_nomb_tecn = 'John Smith' */
SET		@v_nomb_tecn = '' 

DECLARE @v_vers_requ varchar(14)
DECLARE @v_vers_actu varchar(14)
SET        @v_vers_requ = '1.0.1'
SET        @v_vers_actu = '1.0.2'

DECLARE @v_vers_mayo varchar(4)
DECLARE @v_vers_men1 varchar(4)
DECLARE @v_vers_men2 varchar(4)
DECLARE @v_corr_scpt numeric(4,0)

SELECT  @v_corr_scpt = MAX(isnull(corr_scpt,0)) + 1
FROM            vers_modu
		

SELECT   TOP 1  @v_vers_mayo = isnull(vers_mayo,'0'),
                @v_vers_men1 = isnull(vers_men1,'0'),
                @v_vers_men2 = isnull(vers_men2,'0')
FROM            vers_modu
WHERE			TIPO_VERS = 0
ORDER BY        corr_scpt DESC

declare @vFlag bit
set @vFlag = 0

if(@v_nomb_tecn!='')
begin
	if(((@v_vers_mayo + '.' + @v_vers_men1 + '.' + @v_vers_men2) != @v_vers_requ))
	BEGIN
		   Select 'Advertencia: Este script (' + @v_vers_actu + ') esta diseñado para ser ejecutado en una version distinta de DBNeT GX a la instalada actualmente (' + @v_vers_mayo + '.' + @v_vers_men1 + '.' + @v_vers_men2 + ')'
		   print  'Advertencia: Este script (' + @v_vers_actu + ') esta diseñado para ser ejecutado en una version distinta de DBNeT GX a la instalada actualmente (' + @v_vers_mayo + '.' + @v_vers_men1 + '.' + @v_vers_men2 + ')'
	END
	else
	begin
		   INSERT INTO	vers_modu
						(corr_scpt, vers_mayo, vers_men1, vers_men2, fech_ejec, nomb_tecn,tipo_vers)
		   VALUES       (	@v_corr_scpt,
							substring(@v_vers_actu, 1, charindex('.', @v_vers_actu) - 1),
							substring(@v_vers_actu, charindex('.', @v_vers_actu)+1, charindex('.', @v_vers_actu, charindex('.', @v_vers_actu) + 1 ) - (charindex('.', @v_vers_actu) - 1) - 2),
							substring(@v_vers_actu, charindex('.', @v_vers_actu, charindex('.', @v_vers_actu) + 1 ) + 1,10),
							getdate(),
							@v_nomb_tecn,0)
	end
end
else
begin
	Select 'Advertencia: Debe ingresar el nombre de quien ejecuta la actualización (' + @v_vers_actu + ')'
	print  'Advertencia: Debe ingresar el nombre de quien ejecuta la actualización (' + @v_vers_actu + ')'
end
Go

ALTER procedure [dbo].[SP_AX_getEmpresaEstadoCargExte](
	@p_CodiEmex varchar(30),
	@p_CodiEmpr numeric(9,0),
	@pCodiUsua varchar (30)
	)
as
BEGIN

	select distinct dp.codi_pers as codi_pers,
					corr_inst,
					vers_inst,
					dbo.FU_AX_getEstado(esta_carg) esta_carg,
					dbo.FU_AX_getEstado(esta_gene) esta_gene,
					isnull(dh.desc_empr,dp.desc_pers) as desc_pers,
					iv.usua_carg as usua_carg,
					iv.fech_carg as fech_carg
	from	dbax_inst_vers iv ,dbax_defi_pers dp 
				left join dbax_defi_peho dh 
				on		dh.codi_emex = @p_CodiEmex
				and		dh.codi_empr = @p_CodiEmpr
				and		dp.codi_pers = dh.codi_pers
	where	iv.usua_carg=@pCodiUsua
	and		dp.codi_pers=iv.codi_pers
	and		vers_inst>29
	order by fech_carg desc, codi_pers
END
GO

ALTER procedure [dbo].[SP_AX_insCopiaInfoConc] 
@pCodiEmexO varchar(30),
@pCodiEmprO numeric(9,0),
@pCodi_infoO varchar(100),
@pCodiEmexF varchar(30),
@pCodiEmprF numeric(9,0),
@pCodi_infoF varchar(100)
as
BEGIN
	insert into dbax_info_conc (codi_emex, codi_empr, codi_info, pref_conc, codi_conc, orde_conc, codi_conc1, nive_conc, negr_conc, tipo_info, conc_sini)
	select	@pCodiEmexF, @pCodiEmprF, @pCodi_infoF, pref_conc, codi_conc, orde_conc, codi_conc1, nive_conc, negr_conc, tipo_info, conc_sini
	from	dbax_info_conc
	where	codi_emex = @pCodiEmexO
	and		codi_empr = @pCodiEmprO
	and		codi_info = @pCodi_infoO
	
	insert into dbax_info_cntx (codi_emex, codi_empr, codi_info, codi_cntx, orde_cntx, tipo_info, emex_cntx, empr_cntx)
	select	@pCodiEmexF, @pCodiEmprF, @pCodi_infoF, codi_cntx, orde_cntx, tipo_info, codi_emex, codi_empr
	from	dbax_info_cntx
	where	codi_emex = @pCodiEmexO
	and		codi_empr = @pCodiEmprO
	and		codi_info = @pCodi_infoO
END
GO

ALTER procedure [dbo].[SP_AX_getRepoProb] (
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
            LV: Query corrutilizada para las listas de valor 
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
 
   SET @sql = 'SELECT ROW_NUMBER() OVER(ORDER BY corr_prob DESC) AS REG, 
                corr_inst, hora_carg, tipo_prob, desc_prob
               FROM dbax_repo_prob'

	Set @sql =  'SELECT ROW_NUMBER() OVER(ORDER BY corr_inst desc, codi_erro desc, codi_pers, vers_envi asc) AS REG, 
					corr_inst, codi_pers, dbo.FU_AX_getDescEmpr('+ '1' + ',' + '1' + ',codi_pers) desc_pers, dbo.FU_AX_getDescTipoTaxo(dbo.FU_AX_getTipoPers(codi_pers)) as desc_taxo, dbo.FU_AX_getTipoPers(codi_pers) as tipo_taxo, vers_envi, fech_svs, fech_xbrl, fech_desc, fech_carg, codi_erro, dbo.[FU_AX_getDescErro](codi_erro) desc_erro
				from dbax_arch_pend
				where 1=1'
 
   SET @sql = @sql + isnull(@tsCondicion,'')
   EXECUTE dbo.prc_list_dyn @sql, @tnPagina, @tnRegPag 
END;
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FU_AX_getTipoPers]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[FU_AX_getTipoPers]
GO

CREATE function [dbo].[FU_AX_getTipoPers](
	@p_CodiPers varchar(256)) returns varchar(256)
as
begin
	declare @vTipoPers varchar(10)

	select @vTipoPers = isnull(max(tipo_taxo),'')
	from dbax_defi_pers
	where codi_pers = @p_CodiPers

	return @vTipoPers
end
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FU_AX_getDescTipoTaxo]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[FU_AX_getDescTipoTaxo]
GO

CREATE function [dbo].[FU_AX_getDescTipoTaxo](
	@pTipoTaxo varchar(10)) returns varchar(50)
as
begin
	declare @vDescTaxo varchar(50)

	select @vDescTaxo = isnull(max(desc_tipo),'') from dbax_tipo_taxo where tipo_taxo = @pTipoTaxo

	return @vDescTaxo
end
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
	and     tipo_info = 'C'
	
	delete from dbax_info_tita
	where	codi_emex = @CodiEmex  
	and		codi_empr = @CodiEmpr
	and		codi_info = @CodiInfo
	and     tipo_info = 'C'
	
	delete from dbax_info_cntx
	where	codi_emex = @CodiEmex  
	and		codi_empr = @CodiEmpr
	and		codi_info = @CodiInfo
	and     tipo_info = 'C'
	
	delete from dbax_info_conc
	where	codi_emex = @CodiEmex  
	and		codi_empr = @CodiEmpr
	and		codi_info = @CodiInfo
	and     tipo_info = 'C'

	delete from dbax_info_defi
	where	codi_emex = @CodiEmex  
	and		codi_empr = @CodiEmpr
	and		codi_info = @CodiInfo
	and     tipo_info = 'C'
END
GO