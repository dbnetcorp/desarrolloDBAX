SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_pers_grup](
	[codi_empr] [numeric](9, 0) NOT NULL,
	[codi_pers] [numeric](9, 0) NOT NULL,
	[codi_emex] [varchar](30) NOT NULL CONSTRAINT [DF_dbax_pers_grup_codi_emex]  DEFAULT ((1)),
	[code] [varchar](100) NOT NULL,
	[fech_inic] [datetime] NULL,
	[fech_term] [datetime] NULL,
	[domain_code] [numeric](4, 0) NOT NULL,
 CONSTRAINT [PK_dbax_pers_grup] PRIMARY KEY CLUSTERED 
(
	[codi_empr] ASC,
	[codi_pers] ASC,
	[codi_emex] ASC,
	[code] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[dbax_pers_grup]  WITH CHECK ADD  CONSTRAINT [FK_dbax_pers_grup_dbax_defi_pers] FOREIGN KEY([codi_pers])
REFERENCES [dbo].[dbax_defi_pers] ([codi_pers])
GO
ALTER TABLE [dbo].[dbax_pers_grup] CHECK CONSTRAINT [FK_dbax_pers_grup_dbax_defi_pers]
GO
ALTER TABLE [dbo].[dbax_pers_grup]  WITH CHECK ADD  CONSTRAINT [FK_dbax_pers_grup_sys_code] FOREIGN KEY([code], [domain_code])
REFERENCES [dbo].[sys_code] ([code], [domain_code])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dbax_pers_grup] CHECK CONSTRAINT [FK_dbax_pers_grup_sys_code]
GO
