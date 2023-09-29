SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_inst_conc](
	[corr_conc] [numeric](10, 0) IDENTITY(1,1) NOT NULL,
	[codi_pers] [numeric](9, 0) NOT NULL,
	[corr_inst] [numeric](10, 0) NOT NULL,
	[vers_inst] [numeric](5, 0) NOT NULL,
	[pref_conc] [varchar](50) NOT NULL,
	[codi_conc] [varchar](256) NOT NULL,
	[codi_cntx] [varchar](256) NOT NULL,
	[valo_cntx] [varchar](5000) NOT NULL,
	[valo_seri] [varchar](100) NULL,
	[valo_nota] [varchar](3) NULL,
	[codi_unit] [varchar](50) NOT NULL,
 CONSTRAINT [PK_xbr_inst_conc] PRIMARY KEY CLUSTERED 
(
	[corr_conc] ASC,
	[codi_pers] ASC,
	[corr_inst] ASC,
	[vers_inst] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [_dta_index_dbax_inst_conc_5_526624919__K2_K4_K5_K6_K7_K8_K1_9] ON [dbo].[dbax_inst_conc] 
(
	[codi_pers] ASC,
	[corr_inst] ASC,
	[vers_inst] ASC,
	[pref_conc] ASC,
	[codi_conc] ASC,
	[codi_cntx] ASC,
	[corr_conc] ASC
)
INCLUDE ( [valo_cntx]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_dbax_inst_conc] ON [dbo].[dbax_inst_conc] 
(
	[codi_pers] ASC,
	[corr_inst] ASC,
	[vers_inst] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dbax_inst_conc]  WITH CHECK ADD  CONSTRAINT [FK_dbax_inst_conc_dbax_inst_vers] FOREIGN KEY([codi_pers], [corr_inst], [vers_inst])
REFERENCES [dbo].[dbax_inst_vers] ([codi_pers], [corr_inst], [vers_inst])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dbax_inst_conc] CHECK CONSTRAINT [FK_dbax_inst_conc_dbax_inst_vers]
GO
