SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_desc_conc](
	[pref_conc] [varchar](50) NOT NULL,
	[codi_conc] [varchar](256) NOT NULL,
	[codi_lang] [varchar](50) NOT NULL,
	[desc_conc] [varchar](512) NOT NULL,
 CONSTRAINT [PK_xbrl_desc_conc] PRIMARY KEY CLUSTERED 
(
	[codi_conc] ASC,
	[codi_lang] ASC,
	[pref_conc] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [_dta_index_dbax_desc_conc_5_498100815__K1_K2] ON [dbo].[dbax_desc_conc] 
(
	[pref_conc] ASC,
	[codi_conc] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dbax_desc_conc]  WITH CHECK ADD  CONSTRAINT [FK_xbrl_desc_conc_dbne_defi_lang] FOREIGN KEY([codi_lang])
REFERENCES [dbo].[dbne_defi_lang] ([codi_lang])
GO
ALTER TABLE [dbo].[dbax_desc_conc] CHECK CONSTRAINT [FK_xbrl_desc_conc_dbne_defi_lang]
GO
ALTER TABLE [dbo].[dbax_desc_conc]  WITH CHECK ADD  CONSTRAINT [FK_xbrl_desc_conc_xbrl_defi_conc] FOREIGN KEY([codi_conc], [pref_conc])
REFERENCES [dbo].[dbax_defi_conc] ([codi_conc], [pref_conc])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dbax_desc_conc] CHECK CONSTRAINT [FK_xbrl_desc_conc_xbrl_defi_conc]
GO
