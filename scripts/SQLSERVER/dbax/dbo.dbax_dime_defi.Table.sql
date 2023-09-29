SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_dime_defi](
	[codi_dein] [varchar](50) NOT NULL,
	[codi_dime] [varchar](256) NOT NULL,
	[pref_dime] [varchar](20) NOT NULL,
	[codi_fcdi] [varchar](20) NULL,
	[letr_dime] [varchar](1) NULL,
 CONSTRAINT [PK_dbax_dime_defi] PRIMARY KEY CLUSTERED 
(
	[codi_dein] ASC,
	[codi_dime] ASC,
	[pref_dime] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[dbax_dime_defi]  WITH CHECK ADD  CONSTRAINT [FK_dbax_dime_defi_dbax_dime_cntx] FOREIGN KEY([codi_fcdi])
REFERENCES [dbo].[dbax_dime_cntx] ([codi_fcdi])
GO
ALTER TABLE [dbo].[dbax_dime_defi] CHECK CONSTRAINT [FK_dbax_dime_defi_dbax_dime_cntx]
GO
