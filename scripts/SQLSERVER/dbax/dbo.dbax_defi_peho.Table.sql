SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_defi_peho](
	[codi_emex] [varchar](30) NOT NULL CONSTRAINT [DF_dbax_defi_peho_codi_emex]  DEFAULT ((1)),
	[codi_empr] [numeric](9, 0) NOT NULL,
	[codi_pers] [numeric](9, 0) NOT NULL,
	[desc_empr] [varchar](200) NULL,
	[nomb_cort] [varchar](50) NULL,
 CONSTRAINT [PK_dbax_defi_peho] PRIMARY KEY CLUSTERED 
(
	[codi_pers] ASC,
	[codi_emex] ASC,
	[codi_empr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[dbax_defi_peho]  WITH CHECK ADD  CONSTRAINT [FK_dbax_defi_peho_dbax_defi_pers] FOREIGN KEY([codi_pers])
REFERENCES [dbo].[dbax_defi_pers] ([codi_pers])
GO
ALTER TABLE [dbo].[dbax_defi_peho] CHECK CONSTRAINT [FK_dbax_defi_peho_dbax_defi_pers]
GO
