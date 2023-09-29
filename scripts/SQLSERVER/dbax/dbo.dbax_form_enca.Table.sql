SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_form_enca](
	[codi_emex] [varchar](30) NOT NULL CONSTRAINT [DF_dbaxl_form_enca_codi_emex]  DEFAULT ((1)),
	[codi_indi] [varchar](100) NOT NULL,
	[tipo_conc] [varchar](20) NOT NULL,
	[desc_indi] [varchar](256) NULL,
	[form_indi] [varchar](100) NOT NULL,
	[codi_empr] [numeric](9, 0) NOT NULL,
	[tipo_taxo] [varchar](10) NULL,
 CONSTRAINT [PK_xbrl_form_defi] PRIMARY KEY CLUSTERED 
(
	[codi_emex] ASC,
	[codi_indi] ASC,
	[codi_empr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[dbax_form_enca]  WITH CHECK ADD  CONSTRAINT [FK_dbax_form_enca_dbax_tipo_taxo1] FOREIGN KEY([tipo_taxo])
REFERENCES [dbo].[dbax_tipo_taxo] ([tipo_taxo])
GO
ALTER TABLE [dbo].[dbax_form_enca] CHECK CONSTRAINT [FK_dbax_form_enca_dbax_tipo_taxo1]
GO
ALTER TABLE [dbo].[dbax_form_enca]  WITH CHECK ADD  CONSTRAINT [FK_xbrl_form_defi_xbrl_tipo_conc] FOREIGN KEY([tipo_conc])
REFERENCES [dbo].[dbax_tipo_conc] ([tipo_conc])
GO
ALTER TABLE [dbo].[dbax_form_enca] CHECK CONSTRAINT [FK_xbrl_form_defi_xbrl_tipo_conc]
GO
ALTER TABLE [dbo].[dbax_form_enca]  WITH CHECK ADD  CONSTRAINT [FK_xbrl_form_enca_empr] FOREIGN KEY([codi_empr], [codi_emex])
REFERENCES [dbo].[empr] ([codi_empr], [codi_emex])
GO
ALTER TABLE [dbo].[dbax_form_enca] CHECK CONSTRAINT [FK_xbrl_form_enca_empr]
GO
