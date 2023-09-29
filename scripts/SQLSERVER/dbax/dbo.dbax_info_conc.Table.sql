SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_info_conc](
	[codi_empr] [numeric](9, 0) NOT NULL,
	[codi_emex] [varchar](30) NOT NULL CONSTRAINT [DF_dbax_info_conc_codi_emex]  DEFAULT ((1)),
	[codi_info] [varchar](50) NOT NULL,
	[pref_conc] [varchar](50) NOT NULL,
	[codi_conc] [varchar](256) NOT NULL,
	[orde_conc] [numeric](5, 0) NOT NULL,
	[codi_conc1] [varchar](256) NULL,
	[nive_conc] [numeric](5, 0) NULL,
	[negr_conc] [varchar](10) NULL,
 CONSTRAINT [PK_xbrl_info_conc] PRIMARY KEY CLUSTERED 
(
	[codi_empr] ASC,
	[codi_emex] ASC,
	[codi_info] ASC,
	[pref_conc] ASC,
	[codi_conc] ASC,
	[orde_conc] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idx_dbax_info_conc] ON [dbo].[dbax_info_conc] 
(
	[codi_info] ASC,
	[pref_conc] ASC,
	[codi_conc] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dbax_info_conc]  WITH CHECK ADD  CONSTRAINT [FK_dbax_info_conc_dbax_info_defi] FOREIGN KEY([codi_empr], [codi_emex], [codi_info])
REFERENCES [dbo].[dbax_info_defi] ([codi_empr], [codi_emex], [codi_info])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dbax_info_conc] CHECK CONSTRAINT [FK_dbax_info_conc_dbax_info_defi]
GO
