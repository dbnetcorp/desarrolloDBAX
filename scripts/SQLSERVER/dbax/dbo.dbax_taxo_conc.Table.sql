SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_taxo_conc](
	[pref_conc] [varchar](50) NOT NULL,
	[codi_conc] [varchar](256) NOT NULL,
	[vers_taxo] [varchar](256) NOT NULL,
 CONSTRAINT [PK_xbrl_taxo_conc] PRIMARY KEY CLUSTERED 
(
	[pref_conc] ASC,
	[codi_conc] ASC,
	[vers_taxo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[dbax_taxo_conc]  WITH CHECK ADD  CONSTRAINT [FK_xbrl_taxo_conc_xbrl_defi_conc] FOREIGN KEY([codi_conc], [pref_conc])
REFERENCES [dbo].[dbax_defi_conc] ([codi_conc], [pref_conc])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dbax_taxo_conc] CHECK CONSTRAINT [FK_xbrl_taxo_conc_xbrl_defi_conc]
GO
ALTER TABLE [dbo].[dbax_taxo_conc]  WITH CHECK ADD  CONSTRAINT [FK_xbrl_taxo_conc_xbrl_taxo_vers] FOREIGN KEY([vers_taxo])
REFERENCES [dbo].[dbax_taxo_vers] ([vers_taxo])
GO
ALTER TABLE [dbo].[dbax_taxo_conc] CHECK CONSTRAINT [FK_xbrl_taxo_conc_xbrl_taxo_vers]
GO
