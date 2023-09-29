SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_dife_xbrl](
	[codi_pers] [numeric](9, 0) NOT NULL,
	[corr_inst] [numeric](10, 0) NOT NULL,
	[vers_inst] [numeric](5, 0) NOT NULL,
	[valo_html] [varchar](5000) NULL,
 CONSTRAINT [PK_dbax_dife_xbrl_1] PRIMARY KEY CLUSTERED 
(
	[codi_pers] ASC,
	[corr_inst] ASC,
	[vers_inst] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[dbax_dife_xbrl]  WITH CHECK ADD  CONSTRAINT [FK_dbax_dife_xbrl_dbax_inst_vers] FOREIGN KEY([codi_pers], [corr_inst], [vers_inst])
REFERENCES [dbo].[dbax_inst_vers] ([codi_pers], [corr_inst], [vers_inst])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dbax_dife_xbrl] CHECK CONSTRAINT [FK_dbax_dife_xbrl_dbax_inst_vers]
GO
