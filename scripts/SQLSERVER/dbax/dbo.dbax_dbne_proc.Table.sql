SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_dbne_proc](
	[codi_proc] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[prog_proc] [varchar](128) NOT NULL,
	[args_proc] [varchar](1024) NOT NULL,
	[fech_crea] [datetime] NOT NULL DEFAULT (getdate()),
	[fini_proc] [datetime] NULL,
	[ffin_proc] [datetime] NULL,
	[codi_usua] [varchar](16) NULL,
	[esta_proc] [varchar](1) NOT NULL DEFAULT ('I'),
	[mens_proc] [varchar](1024) NULL,
 CONSTRAINT [pk_dbnet_proc] PRIMARY KEY CLUSTERED 
(
	[codi_proc] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
