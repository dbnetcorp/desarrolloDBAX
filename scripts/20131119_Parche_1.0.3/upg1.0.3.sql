IF  NOT EXISTS (SELECT column_name FROM INFORMATION_SCHEMA.columns WHERE table_name = 'empr_exte' and column_name = 'emex_from')
  ALTER TABLE empr_exte ADD emex_from VARCHAR(80) NULL
Go
IF NOT EXISTS (SELECT column_name FROM INFORMATION_SCHEMA.columns WHERE table_name = 'dbax_form_enca' and column_name = 'refe_mini')
BEGIN
  ALTER TABLE dbax_form_enca ADD refe_mini NUMERIC(18,0) NULL
  ALTER TABLE dbax_form_enca ADD refe_maxi NUMERIC(18,0) NULL
  ALTER TABLE dbax_form_enca ADD visu_indi VARCHAR(1) NULL 
  ALTER TABLE dbax_form_enca ADD apli_hold VARCHAR(1) NULL
  ALTER TABLE [dbo].[dbax_form_enca] ADD  CONSTRAINT [DF_dbax_form_enca_visu_indi]  DEFAULT ('S') FOR [visu_indi]
END
Go

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_dbax_indi_anom_cont_envi]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[dbax_indi_anom] DROP CONSTRAINT [DF_dbax_indi_anom_cont_envi]
END

GO


/****** Object:  Table [dbo].[dbax_indi_anom]    Script Date: 11/19/2013 11:05:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dbax_indi_anom]') AND type in (N'U'))
DROP TABLE [dbo].[dbax_indi_anom]
GO


CREATE TABLE [dbo].[dbax_indi_anom](
	[codi_pers] [varchar](16) NOT NULL,
	[corr_inst] [numeric](10, 0) NOT NULL,
	[vers_inst] [numeric](5, 0) NOT NULL,
	[codi_indi] [varchar](100) NOT NULL,
	[codi_cntx] [varchar](256) NOT NULL,
	[esta_actu] [varchar](10) NULL,
	[esta_ante] [varchar](10) NULL,
	[cont_envi] [int] NULL,
 CONSTRAINT [PK_dbax_indi_anom] PRIMARY KEY CLUSTERED 
(
	[codi_pers] ASC,
	[corr_inst] ASC,
	[vers_inst] ASC,
	[codi_indi] ASC,
	[codi_cntx] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[dbax_indi_anom] ADD  CONSTRAINT [DF_dbax_indi_anom_cont_envi]  DEFAULT ((0)) FOR [cont_envi]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__mtod__mtod_errno__0D2FE9C3]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[mtod] DROP CONSTRAINT [DF__mtod__mtod_errno__0D2FE9C3]
END
GO

/****** Object:  Table [dbo].[mtod]    Script Date: 11/19/2013 11:52:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[mtod]') AND type in (N'U'))
DROP TABLE [dbo].[mtod]
GO


CREATE TABLE [dbo].[mtod](
	[mtod_id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[mtod_stat] [varchar](1) NOT NULL,
	[mtod_from] [varchar](400) NOT NULL,
	[mtod_to] [varchar](400) NOT NULL,
	[mtod_cc] [varchar](400) NULL,
	[mtod_subject] [varchar](2000) NULL,
	[mtod_text] [varchar](2000) NULL,
	[mtod_envio] [datetime] NULL,
	[mtod_errno] [numeric](18, 0) NULL,
	[mtod_errtxt] [varchar](2000) NULL,
 CONSTRAINT [mtod_pk] PRIMARY KEY CLUSTERED 
(
	[mtod_id] ASC,
	[mtod_stat] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[mtod] ADD  CONSTRAINT [DF__mtod__mtod_errno__0D2FE9C3]  DEFAULT ((0)) FOR [mtod_errno]
GO

/****** Object:  Table [dbo].[sys_alar]    Script Date: 11/19/2013 12:14:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sys_alar]') AND type in (N'U'))
DROP TABLE [dbo].[sys_alar]
GO

CREATE TABLE [dbo].[sys_alar](
	[codi_alar] [varchar](30) NOT NULL,
	[desc_alar] [varchar](80) NOT NULL,
	[tipo_alar] [varchar](10) NULL,
	[frec_alar] [varchar](10) NOT NULL,
	[esta_alar] [varchar](12) NULL,
	[prio_alar] [numeric](3, 0) NULL,
	[indi_alar] [numeric](22, 0) NOT NULL,
	[comp_alar] [varchar](10) NOT NULL,
	[valo_alar] [numeric](22, 0) NULL,
	[fech_alar] [datetime] NULL,
	[fesi_alar] [datetime] NULL,
	[diav_alar] [numeric](9, 0) NULL,
	[feav_alar] [datetime] NULL,
	[feas_alar] [datetime] NULL,
	[stat_alar] [varchar](10) NULL,
	[erro_alar] [varchar](300) NULL,
	[acci_alar] [varchar](200) NULL,
	[object_name1] [varchar](30) NULL,
	[codi_modu] [varchar](30) NULL,
	[object_name] [varchar](30) NULL,
	[codi_usua] [varchar](30) NULL,
	[sqlc_alar] [varchar](2000) NOT NULL,
	[sqli_alar] [varchar](2000) NULL,
	[par1] [varchar](30) NULL,
	[par2] [varchar](30) NULL,
	[par3] [varchar](30) NULL,
	[par4] [varchar](30) NULL,
	[par5] [varchar](30) NULL,
	[par6] [varchar](30) NULL,
	[des1] [varchar](30) NULL,
	[des2] [varchar](30) NULL,
	[des3] [varchar](30) NULL,
	[des4] [varchar](30) NULL,
	[des5] [varchar](30) NULL,
	[des6] [varchar](30) NULL,
	[sql2_alar] [varchar](2000) NULL,
	[mail_info] [varchar](300) NULL,
 CONSTRAINT [sys_alar_pk] PRIMARY KEY CLUSTERED 
(
	[codi_alar] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [alar_uk] UNIQUE NONCLUSTERED 
(
	[desc_alar] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[sys_alar_emex_fk_coal]') AND parent_object_id = OBJECT_ID(N'[dbo].[sys_alar_emex]'))
ALTER TABLE [dbo].[sys_alar_emex] DROP CONSTRAINT [sys_alar_emex_fk_coal]
GO

/****** Object:  Table [dbo].[sys_alar_emex]    Script Date: 11/19/2013 12:17:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sys_alar_emex]') AND type in (N'U'))
DROP TABLE [dbo].[sys_alar_emex]
GO

CREATE TABLE [dbo].[sys_alar_emex](
	[codi_emex] [varchar](30) NOT NULL,
	[codi_alar] [varchar](30) NOT NULL,
	[tipo_alar] [varchar](10) NULL,
	[frec_alar] [varchar](10) NOT NULL,
	[esta_alar] [varchar](12) NULL,
	[prio_alar] [numeric](3, 0) NULL,
	[indi_alar] [numeric](22, 0) NOT NULL,
	[comp_alar] [varchar](10) NOT NULL,
	[valo_alar] [numeric](22, 0) NULL,
	[fech_alar] [datetime] NULL,
	[fesi_alar] [datetime] NULL,
	[diav_alar] [numeric](9, 0) NULL,
	[feav_alar] [datetime] NULL,
	[feas_alar] [datetime] NULL,
	[stat_alar] [varchar](10) NULL,
	[erro_alar] [varchar](300) NULL,
	[sql2_alar] [varchar](2000) NOT NULL,
	[mail_info] [varchar](300) NOT NULL,
	[mail_cccc] [varchar](300) NOT NULL,
 CONSTRAINT [sys_alar_emex_pk] PRIMARY KEY CLUSTERED 
(
	[codi_emex] ASC,
	[codi_alar] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[sys_alar_emex]  WITH CHECK ADD  CONSTRAINT [sys_alar_emex_fk_coal] FOREIGN KEY([codi_alar])
REFERENCES [dbo].[sys_alar] ([codi_alar])
GO

ALTER TABLE [dbo].[sys_alar_emex] CHECK CONSTRAINT [sys_alar_emex_fk_coal]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[sys_alar_empr_fk_coal]') AND parent_object_id = OBJECT_ID(N'[dbo].[sys_alar_empr]'))
ALTER TABLE [dbo].[sys_alar_empr] DROP CONSTRAINT [sys_alar_empr_fk_coal]
GO
/****** Object:  Table [dbo].[sys_alar_empr]    Script Date: 11/19/2013 12:18:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sys_alar_empr]') AND type in (N'U'))
DROP TABLE [dbo].[sys_alar_empr]
GO

CREATE TABLE [dbo].[sys_alar_empr](
	[codi_emex] [varchar](30) NOT NULL,
	[codi_empr] [numeric](9, 0) NOT NULL,
	[codi_alar] [varchar](30) NOT NULL,
	[tipo_alar] [varchar](10) NULL,
	[frec_alar] [varchar](10) NOT NULL,
	[esta_alar] [varchar](12) NULL,
	[prio_alar] [numeric](3, 0) NULL,
	[indi_alar] [numeric](22, 0) NOT NULL,
	[comp_alar] [varchar](10) NOT NULL,
	[valo_alar] [numeric](22, 0) NULL,
	[fech_alar] [datetime] NULL,
	[fesi_alar] [datetime] NULL,
	[diav_alar] [numeric](9, 0) NULL,
	[feav_alar] [datetime] NULL,
	[feas_alar] [datetime] NULL,
	[stat_alar] [varchar](10) NULL,
	[erro_alar] [varchar](300) NULL,
	[sql2_alar] [varchar](2000) NOT NULL,
	[mail_info] [varchar](300) NOT NULL,
	[mail_cccc] [varchar](300) NOT NULL,
 CONSTRAINT [sys_alar_empr_pk] PRIMARY KEY CLUSTERED 
(
	[codi_emex] ASC,
	[codi_empr] ASC,
	[codi_alar] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[sys_alar_empr]  WITH CHECK ADD  CONSTRAINT [sys_alar_empr_fk_coal] FOREIGN KEY([codi_alar])
REFERENCES [dbo].[sys_alar] ([codi_alar])
GO

ALTER TABLE [dbo].[sys_alar_empr] CHECK CONSTRAINT [sys_alar_empr_fk_coal]
GO
/****** Object:  StoredProcedure [dbo].[alar_fech_sigu]    Script Date: 11/19/2013 12:20:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[alar_fech_sigu]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[alar_fech_sigu]
GO
create procedure [dbo].[alar_fech_sigu] 
						@p_fech_alar	datetime,
						@p_frec_alar	varchar(30),
						@p_fesi_alar	datetime output,
						@existe				varchar(30) output,
						@mensaje			varchar(30) output
as

BEGIN

	if @p_frec_alar = 'DIARIA'
	begin
		set @p_fesi_alar = dateadd(day,1,@p_fech_alar);
	end
	else if @p_frec_alar='PERMANENTE'
	begin
		set @p_fesi_alar = @p_fech_alar;
	end
	else if @p_frec_alar='SEMANAL'
	begin
		set @p_fesi_alar = dateadd(day,7,@p_fech_alar);
	end
	else if @p_frec_alar='QUINCENAL'
	begin
		set @p_fesi_alar = dateadd(day,15,@p_fech_alar);
	end
	else if @p_frec_alar='MENSUAL'
	begin
		set @p_fesi_alar = dateadd(month,1,@p_fech_alar);
	end
	else if @p_frec_alar='TRIMESTRAL'
	begin
		set @p_fesi_alar = dateadd(month,3,@p_fech_alar);
	end
	else if @p_frec_alar='ANUAL'
	begin
		set @p_fesi_alar = dateadd(month,12,@p_fech_alar);
	end

	if @@error <> 0
	begin
		set @mensaje = 'Error Proc : alar_fech_sigu'
	end

END

GO
/****** Object:  StoredProcedure [dbo].[alar_sql_dyn]    Script Date: 11/19/2013 12:21:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[alar_sql_dyn]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[alar_sql_dyn]
GO

CREATE  procedure [dbo].[alar_sql_dyn] 
	@p_sql  varchar(4000),
	@p_nro  int output,
	@p_stat varchar(10) output,
	@p_msg  varchar(100) output
as
declare
  @sql     nvarchar(4000),
  @sql_dyn int,
  @verror  nvarchar(4000)
begin
  begin
    set @p_stat = 'S'
    set @p_msg  = ''

		if(upper(substring(@p_sql,1,1)) = 'S')
		begin
			SELECT  @sql     = N'SELECT @p_nro = (' + @p_sql + ')'
	    execute @sql_dyn = sp_executesql @sql, N'@p_nro int output', @p_nro output
	    set     @verror  = convert(varchar, @@ERROR);
		end
		else
		begin
			SELECT  @sql     = @p_sql
			set @sql = @sql+' set @p_nro = @@rowcount'
	    execute @sql_dyn = sp_executesql @sql, N'@p_nro int output', @p_nro output
	    set     @verror  = convert(varchar, @@ERROR);
		end

  end
  if @verror <> 0 or @sql_dyn = 1
  begin
    set @p_stat = 'N'
    set @p_msg  = 'Error:' + @verror
  end
end


GO
/****** Object:  StoredProcedure [dbo].[put_email]    Script Date: 11/19/2013 12:22:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[put_email]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[put_email]
GO
CREATE   procedure [dbo].[put_email] @P_MTOD_FROM  VARCHAR(400),
        @P_MTOD_TO  VARCHAR(400), @P_MTOD_CC VARCHAR(400),
        @P_MTOD_SUBJECT VARCHAR(2000),
        @P_MTOD_TEXT  VARCHAR(2000), @P_MTOD_ID numeric(18) output
   AS
begin
    insert into MTOD (  MTOD_FROM, MTOD_TO, MTOD_CC, 
            MTOD_SUBJECT,MTOD_TEXT, MTOD_ENVIO, MTOD_STAT)
    values (@P_MTOD_FROM, @P_MTOD_TO, @P_MTOD_CC,
            @P_MTOD_SUBJECT,@P_MTOD_TEXT, GETDATE(), 'P')
    SELECT @P_MTOD_ID=IDENT_CURRENT('mtod')
end

GO
/****** Object:  StoredProcedure [dbo].[dbnet_set_emex]    Script Date: 11/19/2013 12:24:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dbnet_set_emex]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[dbnet_set_emex]
GO
create    procedure [dbo].[dbnet_set_emex] @p_codi_emex  varchar(30)   as
begin
  declare @p_corr_sess numeric(22)

  update sys_session 
  set   codi_emex=@p_codi_emex
  where corr_sess =(select max(corr_sess)
		    from sys_connection 
		    where corr_conn=@@SPID)

  if @@rowcount = 0
    exec dbnet_init_sess @p_codi_emex, @p_corr_sess output
     
end
Go
/****** Object:  StoredProcedure [dbo].[alar_ejec_holding]    Script Date: 11/19/2013 12:25:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[alar_ejec_holding]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[alar_ejec_holding]
GO
CREATE PROCEDURE [dbo].[alar_ejec_holding]
		(@p_fech_alar datetime, @p_erro varchar(1) OUTPUT, @p_mens varchar(200) OUTPUT)
AS
BEGIN

declare 
	@p_valo_alar	numeric(22,0),
	@p_valo_alar1	numeric(22),
	@p_erro_alar	varchar(300),
	@p_erro_alar1	varchar(300),
	@p_stat		varchar(1),
	@p_mensaje_id	numeric(18),
	@p_fesi_alar	datetime,
	@p_sql		varchar(200),
	@p_sql2		varchar(200),
	@p_stat_alar	varchar(12),
	@p_mensaje	varchar(2000),
	@p_origen	varchar(80),
	@p_asunto	varchar(100),
	@p_destino	varchar(80),
	@p_destinoCc	varchar(80),
	@p_nume_regi	integer,
	@existe		varchar(1),
	@mensaje	varchar(200),
	@CODI_EMEX  varchar(30),
	@CODI_ALAR	varchar(30),
	@DESC_ALAR	varchar(80),
	@SQLC_ALAR	varchar(2000),
	@SQLI_ALAR	varchar(2000),
	@FREC_ALAR	varchar(10),
	@INDI_ALAR	numeric(22),
	@COMP_ALAR	varchar(10),
	@VALO_ALAR	numeric(22),
	@FECH_ALAR	datetime,
	@STAT_ALAR	varchar(10),
	@ERRO_ALAR	varchar(300),
	@MAIL_INFO	varchar(300),
	@MAIL_CCCC  varchar(300),
	@ESTA_ALAR	varchar(12),
	@FESI_ALAR 	datetime,
	@CODI_EMPR  varchar(30),
	@CODI_USUA  varchar(30)



--select @p_fech_alar = convert(datetime,
--	     dbo.lpad(convert(varchar,datepart(day,@p_fech_alar)),2,'0') + '-' +
--	     dbo.lpad(convert(varchar,datepart(month,@p_fech_alar)),2,'0')+ '-' +
--	     dbo.lpad(convert(varchar,datepart(year,@p_fech_alar)),4,'0'),105)





DECLARE alarmas_activas_por_holding CURSOR FOR
select a.CODI_EMEX, a.CODI_ALAR, b.sqlc_alar, b.sqli_alar,
	   a.frec_alar, a.indi_alar, a.comp_alar, a.valo_alar,
	   a.fech_alar, a.stat_alar, a.erro_alar, a.mail_info, 
	   a.mail_cccc, b.desc_alar
from sys_alar_emex a, sys_alar b
WHERE a.esta_alar='ACTIVADA'
  and a.codi_alar= b.codi_alar
  and @p_fech_alar >=isnull(a.fesi_alar,@p_fech_alar)


OPEN alarmas_activas_por_holding
	FETCH NEXT FROM alarmas_activas_por_holding INTO
		@CODI_EMEX,	@CODI_ALAR,	@SQLC_ALAR,
		@SQLI_ALAR,	@FREC_ALAR,	@INDI_ALAR,
		@COMP_ALAR,	@VALO_ALAR,	@FECH_ALAR,
		@STAT_ALAR, @ERRO_ALAR,	@MAIL_INFO,
	    @MAIL_CCCC, @DESC_ALAR

	WHILE @@FETCH_STATUS = 0
	begin /*inicio Cursor OK*/
		set @p_stat='S';
		set @p_erro_alar='N';
		set @p_erro_alar1='';

		/*CALCULO DE LA ALARMA SQLC*/
		exec dbnet_set_emex  @CODI_EMEX
		
			set @SQLC_ALAR = @SQLC_ALAR + ' and a.codi_emex = '''+ @CODI_EMEX +'''';
		
		--select count(*) from dbax_indi_anom where esta_actu='Anormal'
		execute alar_sql_dyn @SQLC_ALAR, @p_valo_alar output, @p_stat output, @p_erro_alar output
		if @p_stat='S' /*si sqlc esta ok  p_valo_alar es el count del sqlc*/ 
		  begin
			/*reviso si alarma NORMAL o ANORMAL*/	
--print @FECH_ALAR;
--print @FREC_ALAR;
--print @p_fesi_alar;
			execute alar_fech_sigu @FECH_ALAR, @FREC_ALAR, @p_fesi_alar output, @existe output, @mensaje output
			
--print @p_fesi_alar;
			set @p_sql = 'select count(*) where '; /*count > 0 si la condicion cumple p_valo_alar1*/
			set @p_sql = @p_sql + convert(varchar,@p_valo_alar) + @COMP_ALAR + convert(varchar, @INDI_ALAR);
			execute alar_sql_dyn @p_sql, @p_valo_alar1 output, @p_stat output, @p_erro_alar output

--print @SQLC_ALAR;
--print @p_valo_alar;
--print @COMP_ALAR;
--print @INDI_ALAR
--print @p_valo_alar1;
			if @p_valo_alar1='0'
				set @p_stat_alar = 'NORMAL';

			else
			begin
				set @p_stat_alar = 'ANORMAL';
     --print @p_stat_alar;
				if @SQLI_ALAR IS NOT NULL
				begin /* si la alarma está anormal y tengo un sql para solucionar el problema lo ejecuto */
					set @p_stat = 'S';
					set @p_erro_alar1 = '';
					set @CODI_EMPR='';
					SET @CODI_USUA='*';

					SELECT @SQLI_ALAR = replace(@SQLI_ALAR, 'holding', @CODI_EMEX);
					SELECT @SQLI_ALAR = replace(@SQLI_ALAR, 'empresa', @CODI_EMPR);
					SELECT @SQLI_ALAR = replace(@SQLI_ALAR, 'usuario', @CODI_USUA);
     --print @SQLI_ALAR;
					execute alar_sql_dyn @SQLI_ALAR, @p_nume_regi output, @p_stat output, @p_erro_alar output
										
				end
			end

		UPDATE SYS_ALAR_EMEX SET
				valo_alar = @p_valo_alar,
				fesi_alar = @p_fesi_alar,
				fech_alar = @p_fech_alar,
				stat_alar = @p_stat_alar,
				erro_alar = @p_erro_alar1
		WHERE  codi_alar =	@CODI_ALAR 
          AND  codi_emex = 	@CODI_EMEX

		end /*fin Cursor Ok*/
		else /*IF P_STAT='N'*/
		begin
			/* algo salió mal, mando un mensaje de error para la alarma */
			UPDATE SYS_ALAR_EMEX SET
				erro_alar = @p_erro_alar
			WHERE  codi_alar = @CODI_ALAR
    		  and  codi_emex = @CODI_EMEX
			end
			/* envio de email */
    		if @p_valo_alar1!='0' /*SI SE INSERTO EN LA SYS_ALIN*/
    		begin
    			/*RESCATO EMAIL DE ENVIO*/
				select @p_origen=emex_from
			        from empr_exte
			       where codi_emex=@CODI_EMEX
			        
        
			IF (@p_origen IS NULL) /*SI OCURRE ALGUN ERROR AL RESCATAR EMAIL DE ENVIO ASIGNO UNO*/
			begin
			      set @p_origen='correo@dbnet.cl';

			end
 
			/*ENVIO EMAIL*/
			set @p_mensaje = ''
			
			set @p_mensaje = @p_mensaje + ' ' + @DESC_ALAR + char(10) + '. Revisar Indicadores Anormales';
		    	 		
			set @p_asunto = 'Alarma de Prisma Financiero - ' + @DESC_ALAR ;
			
			set @p_destino = @MAIL_INFO;
			set @p_destinoCc = @MAIL_CCCC;
			/*Y EL MAIL CC COMO LO INSERTA EN EL PUT_MAIL*/
			
			execute put_email @p_origen, @p_destino, @p_destinoCc, @p_asunto, @p_mensaje, @p_mensaje_id output
		end
		FETCH NEXT FROM alarmas_activas_por_holding INTO
				@CODI_EMEX,	@CODI_ALAR,	@SQLC_ALAR,
				@SQLI_ALAR,	@FREC_ALAR,	@INDI_ALAR,
				@COMP_ALAR,	@VALO_ALAR,	@FECH_ALAR,
				@STAT_ALAR, @ERRO_ALAR,	@MAIL_INFO,
				@MAIL_CCCC,@DESC_ALAR

		
	  end  /*fin while alarmas_activas_por_proceso*/

	CLOSE alarmas_activas_por_holding
	DEALLOCATE alarmas_activas_por_holding
END
Go
/****** Object:  StoredProcedure [dbo].[alar_ejec_empresa]    Script Date: 11/19/2013 12:23:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[alar_ejec_empresa]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[alar_ejec_empresa]
GO
CREATE PROCEDURE [dbo].[alar_ejec_empresa]
		(@p_fech_alar datetime, @p_erro varchar(1) OUTPUT, @p_mens varchar(200) OUTPUT)
AS
BEGIN

declare 
	
	@p_valo_alar	numeric(22,0),
	@p_valo_alar1	numeric(22),
	@p_erro_alar	varchar(300),
	@p_erro_alar1	varchar(300),
	@p_stat		varchar(1),
	@p_mensaje_id	numeric(18),
	@p_fesi_alar	datetime,
	@p_sql		varchar(200),
	@p_stat_alar	varchar(12),
	@p_mensaje	varchar(2000),
	@p_origen	varchar(80),
	@p_asunto	varchar(100),
	@p_destino	varchar(80),
	@p_nume_regi	integer,
	@existe		varchar(1),
	@mensaje	varchar(200),
	
	@CODI_EMEX  varchar(30),
	@CODI_ALAR	varchar(30),
	@DESC_ALAR	varchar(80),
	@SQLC_ALAR	varchar(2000),
	@SQLI_ALAR	varchar(2000),
	@FREC_ALAR	varchar(10),
	@INDI_ALAR	numeric(22),
	@COMP_ALAR	varchar(10),
	@VALO_ALAR	numeric(22),
	@FECH_ALAR	datetime,
	@STAT_ALAR	varchar(10),
	@ERRO_ALAR	varchar(300),
	@MAIL_INFO	varchar(300),
	@MAIL_CCCC  varchar(300),
	@ESTA_ALAR	varchar(12),
	@FESI_ALAR 	datetime,
	@CODI_EMPR  varchar(30),
	@CODI_USUA  varchar(30)



select @p_fech_alar = convert(datetime,
	     dbo.lpad(convert(varchar,datepart(day,@p_fech_alar)),2,'0') + '-' +
         dbo.lpad(convert(varchar,datepart(month,@p_fech_alar)),2,'0')+ '-' +
         dbo.lpad(convert(varchar,datepart(year,@p_fech_alar)),4,'0'),105)

--print @p_fech_alar;

DECLARE alarmas_activas_por_empresa CURSOR FOR
select a.CODI_EMEX, a.CODI_EMPR, a.CODI_ALAR, b.sqlc_alar, b.sqli_alar,
	   a.frec_alar, a.indi_alar, a.comp_alar, a.valo_alar,
	   a.fech_alar, a.stat_alar, a.erro_alar, a.mail_info, 
	   a.mail_cccc, b.desc_alar
from sys_alar_empr a, sys_alar b
WHERE a.esta_alar='ACTIVADA'
  and a.codi_alar= b.codi_alar
  and substring (convert(varchar,getdate(),120),0,11) >= isnull(substring (convert(varchar,a.fesi_alar,120),0,11),substring (convert(varchar,getdate(),120),0,11))
  --and @p_fech_alar >=isnull(a.fesi_alar,@p_fech_alar)



OPEN alarmas_activas_por_empresa
	FETCH NEXT FROM alarmas_activas_por_empresa INTO
		@CODI_EMEX,	@CODI_EMPR, @CODI_ALAR,	@SQLC_ALAR,
		@SQLI_ALAR,	@FREC_ALAR,	@INDI_ALAR,
		@COMP_ALAR,	@VALO_ALAR,	@FECH_ALAR,
		@STAT_ALAR, @ERRO_ALAR,	@MAIL_INFO,
	    @MAIL_CCCC, @DESC_ALAR

	WHILE @@FETCH_STATUS = 0
	begin /*inicio Cursor OK*/
		set @p_stat='S';
		set @p_erro_alar='N';
		set @p_erro_alar1='';
		
--print @SQLC_ALAR;
--print @CODI_EMEX;
--print @CODI_EMPR;
--print @CODI_ALAR;
--print @MAIL_CCCC;
		/*CALCULO DE LA ALARMA SQLC*/
		exec dbnet_set_emex  @CODI_EMEX
		
		set @SQLC_ALAR = @SQLC_ALAR + ' AND a.codi_empr =' + @CODI_EMPR;
		
--print @SQLC_ALAR;
		execute alar_sql_dyn @SQLC_ALAR, @p_valo_alar output, @p_stat output, @p_erro_alar output
		if @p_stat='S' /*si sqlc esta ok  p_valo_alar es el count del sqlc*/ 
		  begin
			/*reviso si alarma NORMAL o ANORMAL*/	
--print @SQLC_ALAR;
print @p_valo_alar;
print @COMP_ALAR;
print @INDI_ALAR;
print @p_valo_alar1;
			
			execute alar_fech_sigu @FECH_ALAR, @FREC_ALAR, @p_fesi_alar output, @existe output, @mensaje output
			
--print 'fecha_siguiente' + @p_fesi_alar;
			
			set @p_sql = 'select count(*) from dual where '; /*count > 0 si la condicion cumple p_valo_alar1*/
			set @p_sql = @p_sql + convert(varchar,@p_valo_alar) + @COMP_ALAR + convert(varchar, @INDI_ALAR);
print @p_sql;
			execute alar_sql_dyn @p_sql, @p_valo_alar1 output, @p_stat output, @p_erro_alar output
			
--print @SQLC_ALAR;
--print @p_valo_alar;
--print @COMP_ALAR;
--print @INDI_ALAR
print @p_valo_alar1;
			if @p_valo_alar1='0'
				set @p_stat_alar = 'NORMAL';

			else
			begin
				set @p_stat_alar = 'ANORMAL';

				if @SQLI_ALAR IS NOT NULL
				begin /* si la alarma está anormal y tengo un sql para solucionar el problema lo ejecuto */
					set @p_stat = 'S';
					set @p_erro_alar1 = '';
					--set @CODI_EMPR='';
					SET @CODI_USUA='*';
					--print @CODI_EMPR;
					SELECT @SQLI_ALAR = replace(@SQLI_ALAR, 'holding', @CODI_EMEX);
					SELECT @SQLI_ALAR = replace(@SQLI_ALAR, 1010, @CODI_EMPR);
					SELECT @SQLI_ALAR = replace(@SQLI_ALAR, 'usuario', @CODI_USUA);
					--print @SQLI_ALAR;

execute alar_sql_dyn @SQLI_ALAR, @p_nume_regi output, @p_stat output, @p_erro_alar output
										
				end
			end

		UPDATE SYS_ALAR_EMPR SET
				valo_alar = @p_valo_alar,
				fesi_alar = @p_fesi_alar,
				fech_alar = @p_fech_alar,
				stat_alar = @p_stat_alar,
				erro_alar = @p_erro_alar1
		WHERE  codi_alar =	@CODI_ALAR 
          AND  codi_emex = 	@CODI_EMEX

		end /*fin Cursor Ok*/
		else /*IF P_STAT='N'*/
		begin
			/* algo salió mal, mando un mensaje de error para la alarma */
			UPDATE SYS_ALAR_EMPR SET
				erro_alar = @p_erro_alar
			WHERE  codi_alar = @CODI_ALAR
    		  and  codi_emex = @CODI_EMEX
			end
			/* envio de email */
    		if @p_valo_alar1!='0' /*SI SE INSERTO EN LA SYS_ALIN*/
    		begin
    			/*RESCATO EMAIL DE ENVIO*/
				select @p_origen=VALO_PAEM
			        from PARA_EMPR
			       where CODI_EMPR=1
			        AND CODI_PAEM='EGME'

			IF (@p_origen IS NULL) /*SI OCURRE ALGUN ERROR AL RESCATAR EMAIL DE ENVIO ASIGNO UNO*/
			begin
			      set @p_origen='correo@dbnet.cl'
			end

			/*ENVIO EMAIL*/
			set @p_mensaje = ''
			
			set @p_mensaje = @p_mensaje + ' ' + @DESC_ALAR + char(10) + '. Revisar Alarma en Suite Electronica';
		    	 		
			set @p_asunto = 'Alarma de Suite - ' + @DESC_ALAR ;
			
			set @p_destino = @MAIL_INFO;
			/*Y EL MAIL CC COMO LO INSERTA EN EL PUT_MAIL*/
			
			execute put_email @p_origen, @p_destino, @MAIL_CCCC, @p_asunto, @p_mensaje, @p_mensaje_id output
		end
		FETCH NEXT FROM alarmas_activas_por_empresa INTO
				@CODI_EMEX,	@CODI_EMPR, @CODI_ALAR,	@SQLC_ALAR,
				@SQLI_ALAR,	@FREC_ALAR,	@INDI_ALAR,
				@COMP_ALAR,	@VALO_ALAR,	@FECH_ALAR,
				@STAT_ALAR, @ERRO_ALAR,	@MAIL_INFO,
				@MAIL_CCCC,@DESC_ALAR

		
	  end  /*fin while alarmas_activas_por_proceso*/

	CLOSE alarmas_activas_por_empresa
	DEALLOCATE alarmas_activas_por_empresa
END
Go
/****** Object:  StoredProcedure [dbo].[start_alarma]    Script Date: 11/19/2013 12:29:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[start_alarma]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[start_alarma]
GO
CREATE procedure [dbo].[start_alarma] 
as
BEGIN

	declare
		@fecha datetime,
		@p_erro			varchar(1),
		@p_mens			varchar(200);

	set @p_erro='S';

	begin tran

	select @fecha=getdate()
	
	
	execute alar_ejec_holding @fecha, @p_erro output, @p_mens output

	execute alar_ejec_empresa @fecha, @p_erro output, @p_mens output

	if @p_erro = 'S'
	begin
		commit tran;
	end
	else
	begin
		rollback tran;
	end

END
GO
/****** Object:  UserDefinedFunction [dbo].[FU_AX_getUltiInstIndi]    Script Date: 11/19/2013 12:50:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FU_AX_getUltiInstIndi]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[FU_AX_getUltiInstIndi]
GO

CREATE function [dbo].[FU_AX_getUltiInstIndi]()
returns numeric(10,0)
begin
	declare @vInstDocu numeric(10,0)

	select @vInstDocu = max(corr_inst) from dbax_indi_anom 

	return @vInstDocu
end
GO
/****** Object:  StoredProcedure [dbo].[SP_AX_UpdEstadoServicioMail]    Script Date: 11/19/2013 11:58:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_AX_UpdEstadoServicioMail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_AX_UpdEstadoServicioMail]
GO
create procedure [dbo].[SP_AX_UpdEstadoServicioMail] 
(@p_esta_proc varchar(50),
 @p_mtod_id varchar(50))
AS
BEGIN
	if(@p_esta_proc = 'I')
	begin
		update mtod 
		set mtod_stat=@p_esta_proc
		where mtod_id = @p_mtod_id
	end
	else if(@p_esta_proc = 'T')
	begin
		update mtod 
		set mtod_stat=@p_esta_proc
		where mtod_id = @p_mtod_id
	end
END
GO
/****** Object:  StoredProcedure [dbo].[SP_AX_InsEncaIndi]    Script Date: 11/19/2013 14:31:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_AX_InsEncaIndi]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_AX_InsEncaIndi]
GO

CREATE procedure [dbo].[SP_AX_InsEncaIndi](
	@p_codi_modo  varchar(2),
	@p_codi_emex  varchar(30),
	@p_codi_empr  numeric(9,0),
	@p_codi_indi  varchar(100),
	@p_tipo_indi  varchar(20),
	@p_desc_indi  varchar(256),
	@p_form_indi  varchar(100),
	@p_tipo_taxo varchar(30),
	@p_refe_mini numeric(18,0),
	@p_refe_maxi numeric(18,0),
	@p_visu_indi varchar(1),
	@p_apli_hold varchar(1)) as
BEGIN
	if(@p_codi_modo = 'CI')
	begin
		insert into dbax_form_enca (codi_emex, codi_empr, codi_indi, tipo_conc, desc_indi, form_indi,tipo_taxo,refe_mini,refe_maxi,visu_indi,apli_hold)
		values					   (@p_codi_emex, @p_codi_empr, @p_codi_indi, @p_tipo_indi, @p_desc_indi, @p_form_indi,@p_tipo_taxo,@p_refe_mini,@p_refe_maxi,@p_visu_indi,@p_apli_hold)
	end
	else
	begin
		update	dbax_form_enca 
		set		tipo_conc = @p_tipo_indi, 
				desc_indi = @p_desc_indi, 
				form_indi = @p_form_indi,
				refe_mini = @p_refe_mini,
				refe_maxi = @p_refe_maxi,
				visu_indi = @p_visu_indi,
				apli_hold = @p_apli_hold
		where	codi_emex = @p_codi_emex
		and		codi_empr = @p_codi_empr
		and		codi_indi = @p_codi_indi
	end
END

GO
/****** Object:  StoredProcedure [dbo].[SP_AX_InsAnomaliasIndicadores]    Script Date: 11/19/2013 14:28:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_AX_InsAnomaliasIndicadores]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_AX_InsAnomaliasIndicadores]
GO

CREATE procedure [dbo].[SP_AX_InsAnomaliasIndicadores] (
	@p_codi_pers numeric(9,0),
	@p_corr_inst numeric(10,0),
	@p_vers_inst numeric(5,0),
	@p_codi_conc varchar(256),
	@p_codi_cntx varchar(1000),
	@p_valo_cntx varchar(1000),
    @p_refe_mini numeric(18,0),
    @p_refe_maxi numeric(18,0)
	)as
declare @v_esta_ante varchar(10)
set @v_esta_ante=''
BEGIN
		delete from dbax_indi_anom 
	where codi_pers= @p_codi_pers 
	and corr_inst = @p_corr_inst 
	and vers_inst = @p_vers_inst
	and	codi_indi = @p_codi_conc
	and	codi_cntx = @p_codi_cntx

	
	if((convert(numeric(18,0),@p_valo_cntx) < isnull(@p_refe_mini,@p_valo_cntx)) or (convert(numeric(18,0),@p_valo_cntx) > isnull(@p_refe_maxi,@p_valo_cntx)))
	Begin
		if(@p_vers_inst > 1 )
		Begin
			select @v_esta_ante = esta_ante
			from  dbax_indi_anom
			where codi_pers = @p_codi_pers
			and corr_inst = @p_corr_inst
			and vers_inst = @p_vers_inst - 1
			and codi_indi = @p_codi_conc
			insert dbax_indi_anom (codi_pers,corr_inst,vers_inst,codi_indi,codi_cntx,esta_actu,esta_ante)
			values (@p_codi_pers,@p_corr_inst,@p_vers_inst,@p_codi_conc,@p_codi_cntx,'Anormal',@v_esta_ante)
		End
		else
		Begin
			insert dbax_indi_anom (codi_pers,corr_inst,vers_inst,codi_indi,codi_cntx,esta_actu,esta_ante)
			values (@p_codi_pers,@p_corr_inst,@p_vers_inst,@p_codi_conc,@p_codi_cntx,'Anormal',@v_esta_ante)
		End
	End
	else
	Begin
		if(@p_vers_inst > 1 )
		Begin
			select @v_esta_ante = esta_ante
			from  dbax_indi_anom
			where codi_pers = @p_codi_pers
			and corr_inst = @p_corr_inst
			and vers_inst = @p_vers_inst - 1
			and codi_indi = @p_codi_conc
			insert dbax_indi_anom (codi_pers,corr_inst,vers_inst,codi_indi,codi_cntx,esta_actu,esta_ante)
			values (@p_codi_pers,@p_corr_inst,@p_vers_inst,@p_codi_conc,@p_codi_cntx,'Normal',@v_esta_ante)
		End
		else
		Begin
			insert dbax_indi_anom (codi_pers,corr_inst,vers_inst,codi_indi,codi_cntx,esta_actu,esta_ante)
			values (@p_codi_pers,@p_corr_inst,@p_vers_inst,@p_codi_conc,@p_codi_cntx,'Normal',@v_esta_ante)
		End
	End
END
GO
/****** Object:  StoredProcedure [dbo].[SP_AX_getPrefConcPorCodiConc]    Script Date: 11/19/2013 14:24:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_AX_getPrefConcPorCodiConc]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_AX_getPrefConcPorCodiConc]
GO

CREATE PROCEDURE [dbo].[SP_AX_getPrefConcPorCodiConc]
	@p_codi_conc varchar(256)
AS
BEGIN
	select dc.pref_conc, dc.codi_conc, ct.tipo_taxo
	from dbax_defi_conc dc, dbax_conc_tita ct
	where dc.pref_conc = ct.pref_conc 
	and   dc.codi_conc = ct.codi_conc
	and   dc.codi_conc = @p_codi_conc
END
GO

/****** Object:  StoredProcedure [dbo].[SP_AX_getMailPendientes]    Script Date: 11/19/2013 11:57:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_AX_getMailPendientes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_AX_getMailPendientes]
GO

create PROCEDURE [dbo].[SP_AX_getMailPendientes]
AS
BEGIN
	Select mtod_id,mtod_stat,mtod_from,mtod_to,mtod_cc,mtod_subject,mtod_text,mtod_envio,mtod_errno,mtod_errtxt 
	from mtod 
	where mtod_stat='P' 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_AX_GetListaIndicadoresEmpresa]    Script Date: 11/19/2013 14:21:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_AX_GetListaIndicadoresEmpresa]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_AX_GetListaIndicadoresEmpresa]
GO

CREATE procedure [dbo].[SP_AX_GetListaIndicadoresEmpresa](
	@p_CodiEmex varchar(30),
	@p_CodiEmpr numeric(9,0),
	@p_TipoTaxo varchar(10),
	@p_Codi_indi varchar(100),
	@p_VisuIndi varchar(1) = 'N') as
BEGIN

declare @vComoTipo varchar(1)

if(len(@p_TipoTaxo)=0)
begin
	set @vComoTipo = '%'
end
else
begin
	set @vComoTipo = ''
end
if(@p_VisuIndi = 'S')
	begin
		select	codi_emex as codi_emex,
				codi_empr as codi_empr,
				codi_indi as Nombre, 
				tipo_conc as Tipo, 
				desc_indi as Descripción, 
				form_indi as Fórmula,
				refe_mini as refe_mini,
				refe_maxi as refe_maxi
		from	dbax_form_enca
		where	((codi_emex = '0' and codi_empr = 0) or 
				 (codi_emex = @p_CodiEmex and codi_empr = @p_CodiEmpr)or 
				 (codi_emex = @p_CodiEmex and apli_hold='S'))
		--and     tipo_taxo like '%'+isnull(@p_TipoTaxo,'')+'%'
		--and     (tipo_conc like 'indLi%' or tipo_conc like 'indEnd%')
		and     visu_indi = @p_VisuIndi
		and		tipo_taxo like @vComoTipo + @p_TipoTaxo + @vComoTipo
	end
else if(  @p_Codi_indi = '')
	begin
		select	codi_emex as codi_emex,
				codi_empr as codi_empr,
				codi_indi as Nombre, 
				tipo_conc as Tipo, 
				desc_indi as Descripción, 
				form_indi as Fórmula,
				refe_mini as refe_mini,
				refe_maxi as refe_maxi
		from	dbax_form_enca
		where	((codi_emex = '0' and codi_empr = 0) or 
				 (codi_emex = @p_CodiEmex and codi_empr = @p_CodiEmpr) or 
				 (codi_emex = @p_CodiEmex and apli_hold='S'))
		--and     tipo_taxo like '%'+isnull(@p_TipoTaxo,'')+'%'
		--and     (tipo_conc like 'indLi%' or tipo_conc like 'indEnd%')
		and		tipo_taxo like @vComoTipo + @p_TipoTaxo + @vComoTipo
	end
else
	begin
		select	codi_emex as codi_emex,
				codi_empr as codi_empr,
				codi_indi as Nombre, 
				tipo_conc as Tipo, 
				desc_indi as Descripción, 
				form_indi as Fórmula,
				refe_mini as refe_mini,
				refe_maxi as refe_maxi
		from	dbax_form_enca
		where	((codi_emex = '0' and codi_empr = 0) or 
				 (codi_emex = @p_CodiEmex and codi_empr = @p_CodiEmpr) Or 
				 (codi_emex = @p_CodiEmex and apli_hold='S'))
		--and     tipo_taxo like '%'+isnull(@p_TipoTaxo,'')+'%'
		and     codi_indi = @p_Codi_indi
		and		tipo_taxo like @vComoTipo + @p_TipoTaxo + @vComoTipo
	end
END
GO
/****** Object:  StoredProcedure [dbo].[SP_AX_GetEncaIndi]    Script Date: 11/19/2013 14:20:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_AX_GetEncaIndi]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_AX_GetEncaIndi]
GO
CREATE procedure [dbo].[SP_AX_GetEncaIndi](
	@p_CodiEmex varchar(30),
	@p_CodiEmpr numeric(9,0),
	@p_CodiIndi varchar(100)) as
BEGIN
	select	fe.tipo_conc, 
			fe.desc_indi, 
			fe.form_indi, 
			fe.tipo_taxo, 
			tt.desc_tipo,
			fe.codi_emex,
			fe.codi_empr,
			fe.refe_mini,
			fe.refe_maxi,
			fe.visu_indi,
			fe.apli_hold
	from	dbax_form_enca fe,
			dbax_tipo_taxo tt
	where	((fe.codi_emex = '0' and fe.codi_empr = 0) or (fe.codi_emex = @p_CodiEmex and		fe.codi_empr = @p_CodiEmpr))
	and		fe.codi_indi = @p_CodiIndi
	and		fe.tipo_taxo = tt.tipo_taxo
END
GO
/****** Object:  StoredProcedure [dbo].[SP_AX_GetDetaIndi]    Script Date: 11/19/2013 14:17:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_AX_GetDetaIndi]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_AX_GetDetaIndi]
GO

CREATE procedure [dbo].[SP_AX_GetDetaIndi](
	@p_CodiEmex varchar(30),
	@p_CodiEmpr numeric(9,0),
	@p_CodiIndi varchar(100),
	@p_LetrVari varchar(1)) as
BEGIN
	select	fd.pref_conc, fd.codi_conc, dc.desc_conc, fd.codi_cntx,ct.codi_emex,ct.codi_empr
	from	dbax_form_deta fd,
			dbax_desc_conc dc,
			dbax_defi_cntx ct
	where	((fd.codi_emex = '0' and fd.codi_empr = 0) or (fd.codi_emex = @p_CodiEmex and	fd.codi_empr = @p_CodiEmpr))
	and		fd.codi_indi = @p_CodiIndi
	and		fd.letr_vari = @p_LetrVari
	and		fd.pref_conc = dc.pref_conc
	and		fd.codi_conc = dc.codi_conc
	and		fd.emex_cntx = ct.codi_emex
	and		fd.empr_cntx = ct.codi_empr
	and		fd.codi_cntx = ct.codi_cntx
END
GO
/****** Object:  StoredProcedure [dbo].[prc_read_inst_peri]    Script Date: 11/19/2013 14:15:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_read_inst_peri]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prc_read_inst_peri]
GO
CREATE PROCEDURE [dbo].[prc_read_inst_peri] (
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
		@tsPar1		: Parametro 1 
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
		
		set @sql = 'SELECT  ROW_NUMBER() OVER(ORDER BY corr_inst DESC) AS REG, 
				   substring(convert(varchar,corr_inst),0,len(corr_inst)-1) Anio,
				   substring(convert(varchar,corr_inst),len(corr_inst)-1,len(corr_inst))Mes,
				   corr_inst corr_inst
				   from dbax_inst_docu
				   group by corr_inst'

		
		SET @sql = @sql + isnull(@tsCondicion,'')
		EXECUTE dbo.prc_list_dyn @sql, @tnPagina, @tnRegPag 
	END
END
GO
/****** Object:  StoredProcedure [dbo].[prc_read_indi_anom]    Script Date: 11/19/2013 12:52:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_read_indi_anom]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prc_read_indi_anom]
GO

CREATE PROCEDURE [dbo].[prc_read_indi_anom] (
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
		
		set @sql = 'SELECT ROW_NUMBER() OVER(ORDER BY dbfe.codi_indi ASC) AS REG, 
				    dbdp.codi_pers,dbdp.desc_pers,dbia.corr_inst,dbia.vers_inst,dbfe.codi_indi , dbfe.tipo_conc , 
				    dbfe.desc_indi , dbfe.form_indi,dbic.valo_cntx,dbfe.refe_mini,dbfe.refe_maxi, dbia.esta_actu,dbia.esta_ante
		            from dbax_form_enca dbfe, dbax_indi_anom dbia, dbax_defi_pers dbdp, dbax_inst_conc dbic 
		            where ((dbfe.codi_emex = 0 and dbfe.codi_empr = 0) 
		            or (dbfe.codi_emex =1 and dbfe.codi_empr = 1))
		            and dbfe.codi_indi=dbia.codi_indi
		            and dbia.codi_pers=dbdp.codi_pers
		            and dbic.codi_pers=dbia.codi_pers
		            and dbic.corr_inst=dbia.corr_inst
		            and dbic.vers_inst=dbia.vers_inst
		            and dbic.codi_conc=dbia.codi_indi
		            and dbic.codi_cntx=dbia.codi_cntx
		            and dbic.pref_conc=''indi''
		            and dbia.corr_inst= ' + @tsPar1 + '
		            and dbia.esta_actu=''Anormal''
		            and dbia.vers_inst = dbo.FU_AX_getUltimaVersion(dbia.codi_pers,dbo.FU_AX_getUltiInstIndi())'
		
		SET @sql = @sql + isnull(@tsCondicion,'')
		EXECUTE dbo.prc_list_dyn @sql, @tnPagina, @tnRegPag 
	END
END
GO
delete from dbn_list_colu where codi_repo = 'L_INST_PERI';
delete from dbn_list_boto where codi_repo = 'L_INST_PERI';
delete from dbn_repo_rous where codi_repo = 'L_INST_PERI';
delete from dbn_list_repo where codi_repo = 'L_INST_PERI';

INSERT INTO DBN_LIST_REPO (CODI_REPO, TITU_REPO, DESC_REPO, CODI_RESX, PROC_REPO, CODI_MODU, SCRP_SQLS, SCRP_SQLO, FILT_CKBB, PAGE_REPO, MODO, CATE_LIST, TIPO_REPO, SUBT_CNTX) VALUES ( 'L_INST_PERI','Periodos informados','','','prc_read_inst_peri','prc_read_inst_peri','','','0','', 'M', '','Maestro','' );

INSERT INTO DBN_LIST_COLU (CODI_REPO, CODI_COLU, NOMB_COLU, DESC_COLU, CODI_RESX, CLAS_CSS, TIPO_COLU, ANCH_COLU, ALIN_COLU, FORM_COLU, INDI_VISI, IMAG_COLU, JQRY_COLU, ORDE_COLU, TIPO_BUSQ, INDI_BUSQ, COLU_BUSQ, VERD_BUSQ, FALS_BUSQ, CODI_LIVA) VALUES ('L_INST_PERI','REG','Lin','Muestra el número de registro almacenado','REG','Bounfield','texto','30','L','','1','','','0','','0','','','','');
INSERT INTO DBN_LIST_COLU (CODI_REPO, CODI_COLU, NOMB_COLU, DESC_COLU, CODI_RESX, CLAS_CSS, TIPO_COLU, ANCH_COLU, ALIN_COLU, FORM_COLU, INDI_VISI, IMAG_COLU, JQRY_COLU, ORDE_COLU, TIPO_BUSQ, INDI_BUSQ, COLU_BUSQ, VERD_BUSQ, FALS_BUSQ, CODI_LIVA) VALUES ('L_INST_PERI','Anio','Año','Año','Anio','Bounfield','texto','4','L','','1','','','1','','0','','','','');
INSERT INTO DBN_LIST_COLU (CODI_REPO, CODI_COLU, NOMB_COLU, DESC_COLU, CODI_RESX, CLAS_CSS, TIPO_COLU, ANCH_COLU, ALIN_COLU, FORM_COLU, INDI_VISI, IMAG_COLU, JQRY_COLU, ORDE_COLU, TIPO_BUSQ, INDI_BUSQ, COLU_BUSQ, VERD_BUSQ, FALS_BUSQ, CODI_LIVA) VALUES ('L_INST_PERI','Mes','Mes','Mes','Mes','Bounfield','texto','2','L','','1','','','2','','0','','','','');
INSERT INTO DBN_LIST_COLU (CODI_REPO, CODI_COLU, NOMB_COLU, DESC_COLU, CODI_RESX, CLAS_CSS, TIPO_COLU, ANCH_COLU, ALIN_COLU, FORM_COLU, INDI_VISI, IMAG_COLU, JQRY_COLU, ORDE_COLU, TIPO_BUSQ, INDI_BUSQ, COLU_BUSQ, VERD_BUSQ, FALS_BUSQ, CODI_LIVA) VALUES ('L_INST_PERI','corr_inst','corr_inst','','corr_inst','Bounfield','texto','100','L','','0','','','3','','0','','','','');
INSERT INTO DBN_LIST_BOTO (CODI_REPO, CODI_BOTO, NOMB_BOTO, DESC_BOTO, TIPO_BOTO, CODI_RESX, CLAS_CSS, PAGE_BOTO, PROC_BOTO, CODI_PAR1, CODI_PAR2, CODI_PAR3, CODI_PAR4, CODI_PAR5, IMAG_BOTO, ORDE_BOTO, INDI_VISI,MODO_BOTO,LIST_DETA) VALUES ('L_INST_PERI','B_DETA','btnDetalle','Muestra los indicadores con anomalías','','','ButtonField','~/dbnFw5/dbnFw5Listador.aspx','','corr_inst','','','','','deta.png','0','1','(M)','L_INDI_ANOM');
Go
delete from dbn_list_colu where codi_repo = 'L_INDI_ANOM';
delete from dbn_list_boto where codi_repo = 'L_INDI_ANOM';
delete from dbn_repo_rous where codi_repo = 'L_INDI_ANOM';
delete from dbn_list_repo where codi_repo = 'L_INDI_ANOM';

INSERT INTO DBN_LIST_REPO (CODI_REPO, TITU_REPO, DESC_REPO, CODI_RESX, PROC_REPO, CODI_MODU, SCRP_SQLS, SCRP_SQLO, FILT_CKBB, PAGE_REPO, MODO, CATE_LIST, TIPO_REPO, SUBT_CNTX) VALUES ( 'L_INDI_ANOM','Indicadores con Anomalías','','','prc_read_indi_anom','','','','1','', 'M', '','Maestro','' );

INSERT INTO DBN_LIST_COLU (CODI_REPO, CODI_COLU, NOMB_COLU, DESC_COLU, CODI_RESX, CLAS_CSS, TIPO_COLU, ANCH_COLU, ALIN_COLU, FORM_COLU, INDI_VISI, IMAG_COLU, JQRY_COLU, ORDE_COLU, TIPO_BUSQ, INDI_BUSQ, COLU_BUSQ, VERD_BUSQ, FALS_BUSQ, CODI_LIVA) VALUES ('L_INDI_ANOM','REG','Lin','Muestra el número de registro almacenado','REG','Bounfield','texto','15','L','','1','','','0','','0','','','','');
INSERT INTO DBN_LIST_COLU (CODI_REPO, CODI_COLU, NOMB_COLU, DESC_COLU, CODI_RESX, CLAS_CSS, TIPO_COLU, ANCH_COLU, ALIN_COLU, FORM_COLU, INDI_VISI, IMAG_COLU, JQRY_COLU, ORDE_COLU, TIPO_BUSQ, INDI_BUSQ, COLU_BUSQ, VERD_BUSQ, FALS_BUSQ, CODI_LIVA) VALUES ('L_INDI_ANOM','codi_pers','RUT Empresa','','codi_pers','Bounfield','texto','20','L','','1','','','1','','0','','','','');
INSERT INTO DBN_LIST_COLU (CODI_REPO, CODI_COLU, NOMB_COLU, DESC_COLU, CODI_RESX, CLAS_CSS, TIPO_COLU, ANCH_COLU, ALIN_COLU, FORM_COLU, INDI_VISI, IMAG_COLU, JQRY_COLU, ORDE_COLU, TIPO_BUSQ, INDI_BUSQ, COLU_BUSQ, VERD_BUSQ, FALS_BUSQ, CODI_LIVA) VALUES ('L_INDI_ANOM','desc_pers','Empresa','','desc_pers','Bounfield','texto','100','L','','1','','','2','S','1','desc_pers','','','');
INSERT INTO DBN_LIST_COLU (CODI_REPO, CODI_COLU, NOMB_COLU, DESC_COLU, CODI_RESX, CLAS_CSS, TIPO_COLU, ANCH_COLU, ALIN_COLU, FORM_COLU, INDI_VISI, IMAG_COLU, JQRY_COLU, ORDE_COLU, TIPO_BUSQ, INDI_BUSQ, COLU_BUSQ, VERD_BUSQ, FALS_BUSQ, CODI_LIVA) VALUES ('L_INDI_ANOM','corr_inst','Periodo','','corr_inst','Bounfield','texto','10','L','','1','','','3','','0','','','','');
INSERT INTO DBN_LIST_COLU (CODI_REPO, CODI_COLU, NOMB_COLU, DESC_COLU, CODI_RESX, CLAS_CSS, TIPO_COLU, ANCH_COLU, ALIN_COLU, FORM_COLU, INDI_VISI, IMAG_COLU, JQRY_COLU, ORDE_COLU, TIPO_BUSQ, INDI_BUSQ, COLU_BUSQ, VERD_BUSQ, FALS_BUSQ, CODI_LIVA) VALUES ('L_INDI_ANOM','vers_inst','Versión','','vers_inst','Bounfield','texto','5','L','{0:N0}','1','','','4','','0','','','','');
INSERT INTO DBN_LIST_COLU (CODI_REPO, CODI_COLU, NOMB_COLU, DESC_COLU, CODI_RESX, CLAS_CSS, TIPO_COLU, ANCH_COLU, ALIN_COLU, FORM_COLU, INDI_VISI, IMAG_COLU, JQRY_COLU, ORDE_COLU, TIPO_BUSQ, INDI_BUSQ, COLU_BUSQ, VERD_BUSQ, FALS_BUSQ, CODI_LIVA) VALUES ('L_INDI_ANOM','desc_indi','Descripción','','desc_indi','Bounfield','texto','256','L','','1','','','5','','0','','','','');
INSERT INTO DBN_LIST_COLU (CODI_REPO, CODI_COLU, NOMB_COLU, DESC_COLU, CODI_RESX, CLAS_CSS, TIPO_COLU, ANCH_COLU, ALIN_COLU, FORM_COLU, INDI_VISI, IMAG_COLU, JQRY_COLU, ORDE_COLU, TIPO_BUSQ, INDI_BUSQ, COLU_BUSQ, VERD_BUSQ, FALS_BUSQ, CODI_LIVA) VALUES ('L_INDI_ANOM','tipo_conc','Tipo','','tipo_conc','Bounfield','texto','100','L','','1','','','6','','0','','','','');
INSERT INTO DBN_LIST_COLU (CODI_REPO, CODI_COLU, NOMB_COLU, DESC_COLU, CODI_RESX, CLAS_CSS, TIPO_COLU, ANCH_COLU, ALIN_COLU, FORM_COLU, INDI_VISI, IMAG_COLU, JQRY_COLU, ORDE_COLU, TIPO_BUSQ, INDI_BUSQ, COLU_BUSQ, VERD_BUSQ, FALS_BUSQ, CODI_LIVA) VALUES ('L_INDI_ANOM','codi_indi','Nombre','','codi_indi','Bounfield','texto','100','L','','0','','','7','','0','','','','');
INSERT INTO DBN_LIST_COLU (CODI_REPO, CODI_COLU, NOMB_COLU, DESC_COLU, CODI_RESX, CLAS_CSS, TIPO_COLU, ANCH_COLU, ALIN_COLU, FORM_COLU, INDI_VISI, IMAG_COLU, JQRY_COLU, ORDE_COLU, TIPO_BUSQ, INDI_BUSQ, COLU_BUSQ, VERD_BUSQ, FALS_BUSQ, CODI_LIVA) VALUES ('L_INDI_ANOM','form_indi','Fórmula','','form_indi','Bounfield','texto','100','L','','0','','','8','','0','','','','');
INSERT INTO DBN_LIST_COLU (CODI_REPO, CODI_COLU, NOMB_COLU, DESC_COLU, CODI_RESX, CLAS_CSS, TIPO_COLU, ANCH_COLU, ALIN_COLU, FORM_COLU, INDI_VISI, IMAG_COLU, JQRY_COLU, ORDE_COLU, TIPO_BUSQ, INDI_BUSQ, COLU_BUSQ, VERD_BUSQ, FALS_BUSQ, CODI_LIVA) VALUES ('L_INDI_ANOM','valo_cntx','Valor','','valo_cntx','Bounfield','texto','30','L','{0:N1}','1','','','9','','0','','','','');
INSERT INTO DBN_LIST_COLU (CODI_REPO, CODI_COLU, NOMB_COLU, DESC_COLU, CODI_RESX, CLAS_CSS, TIPO_COLU, ANCH_COLU, ALIN_COLU, FORM_COLU, INDI_VISI, IMAG_COLU, JQRY_COLU, ORDE_COLU, TIPO_BUSQ, INDI_BUSQ, COLU_BUSQ, VERD_BUSQ, FALS_BUSQ, CODI_LIVA) VALUES ('L_INDI_ANOM','refe_mini','Referencia mínima','Valor de referencia mínino','refe_mini','Bounfield','texto','30','L','{0:N1}','1','','','91','','0','','','','');
INSERT INTO DBN_LIST_COLU (CODI_REPO, CODI_COLU, NOMB_COLU, DESC_COLU, CODI_RESX, CLAS_CSS, TIPO_COLU, ANCH_COLU, ALIN_COLU, FORM_COLU, INDI_VISI, IMAG_COLU, JQRY_COLU, ORDE_COLU, TIPO_BUSQ, INDI_BUSQ, COLU_BUSQ, VERD_BUSQ, FALS_BUSQ, CODI_LIVA) VALUES ('L_INDI_ANOM','refe_maxi','Referencia máxima','Valore de referencia máximo','refe_maxi','Bounfield','texto','30','L','{0:N1}','1','','','92','','0','','','','');
INSERT INTO DBN_LIST_COLU (CODI_REPO, CODI_COLU, NOMB_COLU, DESC_COLU, CODI_RESX, CLAS_CSS, TIPO_COLU, ANCH_COLU, ALIN_COLU, FORM_COLU, INDI_VISI, IMAG_COLU, JQRY_COLU, ORDE_COLU, TIPO_BUSQ, INDI_BUSQ, COLU_BUSQ, VERD_BUSQ, FALS_BUSQ, CODI_LIVA) VALUES ('L_INDI_ANOM','esta_actu','Estado actual','','esta_actu','Bounfield','texto','10','L','','1','','','93','','0','','','','');
INSERT INTO DBN_LIST_COLU (CODI_REPO, CODI_COLU, NOMB_COLU, DESC_COLU, CODI_RESX, CLAS_CSS, TIPO_COLU, ANCH_COLU, ALIN_COLU, FORM_COLU, INDI_VISI, IMAG_COLU, JQRY_COLU, ORDE_COLU, TIPO_BUSQ, INDI_BUSQ, COLU_BUSQ, VERD_BUSQ, FALS_BUSQ, CODI_LIVA) VALUES ('L_INDI_ANOM','esta_ante','Estado anterior','','esta_ante','Bounfield','texto','10','L','','1','','','94','','0','','','','');
INSERT INTO DBN_LIST_BOTO (CODI_REPO, CODI_BOTO, NOMB_BOTO, DESC_BOTO, TIPO_BOTO, CODI_RESX, CLAS_CSS, PAGE_BOTO, PROC_BOTO, CODI_PAR1, CODI_PAR2, CODI_PAR3, CODI_PAR4, CODI_PAR5, IMAG_BOTO, ORDE_BOTO, INDI_VISI,MODO_BOTO,LIST_DETA) VALUES ('L_INDI_ANOM','bt_deta','btnDetalle','','','','ButtonField','~/dbnet.dbax/Indicadores.aspx','','codi_indi','','','','','deta.png','0','1','(CE)(M)','');






























