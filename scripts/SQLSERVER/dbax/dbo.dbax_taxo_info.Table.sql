SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_taxo_info](
	[codi_info] [varchar](50) NOT NULL,
	[desc_info] [varchar](256) NULL,
	[orde_info] [varchar](50) NULL,
	[sche_info] [varchar](256) NULL,
 CONSTRAINT [PK_xbrl_taxo_info] PRIMARY KEY CLUSTERED 
(
	[codi_info] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
