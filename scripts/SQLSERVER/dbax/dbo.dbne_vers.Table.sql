SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbne_vers](
	[codi_prod] [varchar](20) NOT NULL,
	[vers_mayo] [varchar](4) NOT NULL,
	[vers_men1] [varchar](4) NOT NULL,
	[vers_men2] [varchar](4) NOT NULL,
	[fech_ejec] [timestamp] NULL,
	[nomb_tecn] [varchar](100) NULL,
 CONSTRAINT [PK_dbne_vers] PRIMARY KEY CLUSTERED 
(
	[codi_prod] ASC,
	[vers_mayo] ASC,
	[vers_men1] ASC,
	[vers_men2] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
