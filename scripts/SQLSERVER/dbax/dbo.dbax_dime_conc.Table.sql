SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_dime_conc](
	[codi_dein] [varchar](50) NOT NULL,
	[codi_conc] [varchar](256) NOT NULL,
	[pref_conc] [varchar](20) NOT NULL,
	[orde_conc] [numeric](5, 0) NOT NULL,
	[codi_dime] [varchar](256) NOT NULL,
	[pref_dime] [varchar](20) NOT NULL,
	[sald_ini] [varchar](5) NULL,
 CONSTRAINT [PK_dbax_dime_conc] PRIMARY KEY CLUSTERED 
(
	[codi_dein] ASC,
	[codi_conc] ASC,
	[pref_conc] ASC,
	[orde_conc] ASC,
	[codi_dime] ASC,
	[pref_dime] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[dbax_dime_conc]  WITH CHECK ADD  CONSTRAINT [FK_dbax_dime_conc_dbax_dime_defi] FOREIGN KEY([codi_dein], [codi_dime], [pref_dime])
REFERENCES [dbo].[dbax_dime_defi] ([codi_dein], [codi_dime], [pref_dime])
GO
ALTER TABLE [dbo].[dbax_dime_conc] CHECK CONSTRAINT [FK_dbax_dime_conc_dbax_dime_defi]
GO
