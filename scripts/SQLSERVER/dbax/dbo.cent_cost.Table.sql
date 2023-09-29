SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cent_cost](
	[codi_emex] [varchar](30) NOT NULL,
	[codi_ceco] [varchar](16) NOT NULL,
	[nomb_ceco] [varchar](80) NULL,
	[codi_ceco1] [varchar](16) NULL,
	[tipo_ceco] [varchar](2) NULL,
	[codi_empr] [numeric](9, 0) NOT NULL,
	[nume_ceco] [numeric](6, 0) NULL,
	[resu_ceco] [varchar](12) NULL,
	[resu_ceco1] [varchar](12) NULL,
	[flag_ramo] [varchar](1) NULL,
	[leve_ceco] [numeric](2, 0) NULL,
	[oper_cuco] [varchar](5) NULL,
	[codi_zona] [numeric](4, 0) NULL,
	[codi_ofic] [varchar](3) NULL,
	[acti_ceco] [varchar](1) NULL,
	[fein_ceco] [datetime] NULL,
	[fete_ceco] [datetime] NULL,
	[codi_pers] [varchar](16) NULL,
	[nume_ceco1] [numeric](6, 0) NULL,
	[codi_ciud] [varchar](8) NULL,
	[codi_ubic] [varchar](3) NULL,
	[codi_exen] [varchar](1) NULL,
	[tiar_ceco] [varchar](2) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
