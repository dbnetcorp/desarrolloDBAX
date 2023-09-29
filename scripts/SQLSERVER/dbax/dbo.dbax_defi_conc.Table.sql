SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_defi_conc](
	[pref_conc] [varchar](50) NOT NULL,
	[codi_conc] [varchar](256) NOT NULL,
	[tipo_conc] [varchar](20) NOT NULL,
	[tipo_peri] [varchar](15) NULL,
	[tipo_valo] [varchar](256) NULL,
	[tipo_cuen] [varchar](10) NULL,
	[codi_nume] [varchar](25) NULL,
	[tipo_taxo] [varchar](10) NULL,
 CONSTRAINT [PK_xbrl_defi_conc] PRIMARY KEY CLUSTERED 
(
	[codi_conc] ASC,
	[pref_conc] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idx_defi_conc1] ON [dbo].[dbax_defi_conc] 
(
	[pref_conc] ASC,
	[codi_conc] ASC,
	[tipo_conc] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dbax_defi_conc]  WITH CHECK ADD  CONSTRAINT [FK_dbax_defi_conc_dbax_tipo_taxo] FOREIGN KEY([tipo_taxo])
REFERENCES [dbo].[dbax_tipo_taxo] ([tipo_taxo])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dbax_defi_conc] CHECK CONSTRAINT [FK_dbax_defi_conc_dbax_tipo_taxo]
GO
ALTER TABLE [dbo].[dbax_defi_conc]  WITH CHECK ADD  CONSTRAINT [FK_xbrl_defi_conc_xbrl_tipo_conc] FOREIGN KEY([tipo_conc])
REFERENCES [dbo].[dbax_tipo_conc] ([tipo_conc])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dbax_defi_conc] CHECK CONSTRAINT [FK_xbrl_defi_conc_xbrl_tipo_conc]
GO
