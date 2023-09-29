SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_dime_diax](
	[codi_dime] [varchar](256) NOT NULL,
	[pref_dime] [varchar](20) NOT NULL,
	[codi_axis] [varchar](256) NOT NULL,
	[pref_axis] [varchar](20) NOT NULL,
	[orde_axis] [numeric](1, 0) NOT NULL CONSTRAINT [DF_xbrl_dime_diax_orde_axis]  DEFAULT ((1)),
	[codi_dein] [varchar](50) NOT NULL,
 CONSTRAINT [PK_dbax_dime_diax] PRIMARY KEY CLUSTERED 
(
	[codi_dime] ASC,
	[pref_dime] ASC,
	[codi_axis] ASC,
	[pref_axis] ASC,
	[codi_dein] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[dbax_dime_diax]  WITH CHECK ADD  CONSTRAINT [FK_dbax_dime_diax_dbax_dime_axis] FOREIGN KEY([codi_axis], [pref_axis])
REFERENCES [dbo].[dbax_dime_axis] ([codi_axis], [pref_axis])
GO
ALTER TABLE [dbo].[dbax_dime_diax] CHECK CONSTRAINT [FK_dbax_dime_diax_dbax_dime_axis]
GO
ALTER TABLE [dbo].[dbax_dime_diax]  WITH CHECK ADD  CONSTRAINT [FK_dbax_dime_diax_dbax_dime_defi] FOREIGN KEY([codi_dein], [codi_dime], [pref_dime])
REFERENCES [dbo].[dbax_dime_defi] ([codi_dein], [codi_dime], [pref_dime])
GO
ALTER TABLE [dbo].[dbax_dime_diax] CHECK CONSTRAINT [FK_dbax_dime_diax_dbax_dime_defi]
GO
