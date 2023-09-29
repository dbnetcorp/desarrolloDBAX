SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[usua_sist](
	[codi_emex] [varchar](30) NOT NULL,
	[codi_usua] [varchar](30) NOT NULL,
	[nomb_usua] [varchar](80) NULL,
	[codi_pers] [varchar](16) NULL,
	[codi_rous] [varchar](30) NULL,
	[codi_empr] [numeric](9, 0) NULL,
	[fech_usua] [datetime] NULL,
	[codi_impr] [varchar](25) NULL,
	[codi_ofic] [varchar](3) NULL,
	[codi_ceco] [varchar](16) NULL,
	[codi_zona] [numeric](3, 0) NULL,
	[codi_menu] [varchar](30) NULL,
	[nive_usua] [varchar](1) NULL,
	[noco_usua] [varchar](30) NULL,
	[pass_usua] [varchar](30) NULL,
	[tipo_usua] [varchar](1) NULL,
	[codi_ramo] [varchar](12) NULL,
	[fono_usua] [varchar](30) NULL,
	[luga_usua] [varchar](30) NULL,
	[digi_usua] [varchar](1) NULL,
	[codi_dbst] [varchar](30) NULL,
	[fete_usua] [datetime] NULL,
	[mail_usua] [varchar](80) NULL,
	[tipo_fold] [varchar](30) NULL,
	[codi_cult] [varchar](30) NULL,
	[usua_acdi] [varchar](30) NULL,
	[usua_esta] [varchar](1) NULL,
	[fech_vige] [datetime] NULL,
	[usua_cadu] [varchar](1) NULL,
	[erro_logi] [numeric](1, 0) NULL,
	[usua_noca] [varchar](1) NULL,
	[usua_filt] [varchar](1) NULL,
 CONSTRAINT [usua_pk] PRIMARY KEY CLUSTERED 
(
	[codi_usua] ASC,
	[codi_emex] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
