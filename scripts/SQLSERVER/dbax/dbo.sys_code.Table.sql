SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[sys_code](
	[code] [varchar](100) NOT NULL,
	[code_desc] [varchar](50) NULL,
	[domain_code] [numeric](4, 0) NOT NULL,
	[code_aux] [varchar](30) NULL,
	[code_dele] [varchar](1) NULL,
 CONSTRAINT [PK_sys_code] PRIMARY KEY CLUSTERED 
(
	[code] ASC,
	[domain_code] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[sys_code]  WITH CHECK ADD  CONSTRAINT [FK_sys_code_sys_domain] FOREIGN KEY([domain_code])
REFERENCES [dbo].[sys_domain] ([domain_code])
GO
ALTER TABLE [dbo].[sys_code] CHECK CONSTRAINT [FK_sys_code_sys_domain]
GO
