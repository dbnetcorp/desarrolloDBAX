SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_dime_memb](
	[codi_axis] [varchar](256) NOT NULL,
	[pref_axis] [varchar](20) NOT NULL,
	[codi_memb] [varchar](256) NOT NULL,
	[pref_memb] [varchar](20) NOT NULL,
	[orde_memb] [int] NULL,
	[tipo_memb] [varchar](256) NULL,
 CONSTRAINT [PK_dbax_dime_memb] PRIMARY KEY CLUSTERED 
(
	[codi_axis] ASC,
	[pref_axis] ASC,
	[codi_memb] ASC,
	[pref_memb] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[dbax_dime_memb]  WITH CHECK ADD  CONSTRAINT [FK_dbax_dime_memb_dbax_dime_axis] FOREIGN KEY([codi_axis], [pref_axis])
REFERENCES [dbo].[dbax_dime_axis] ([codi_axis], [pref_axis])
GO
ALTER TABLE [dbo].[dbax_dime_memb] CHECK CONSTRAINT [FK_dbax_dime_memb_dbax_dime_axis]
GO
