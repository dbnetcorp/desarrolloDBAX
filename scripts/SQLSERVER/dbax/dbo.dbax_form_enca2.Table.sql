SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_form_enca2](
	[codi_indi] [varchar](100) NOT NULL,
	[tipo_conc] [varchar](20) NULL,
	[desc_indi] [varchar](256) NULL,
	[form_indi] [varchar](100) NULL,
 CONSTRAINT [PK_dbax_form_enca2] PRIMARY KEY CLUSTERED 
(
	[codi_indi] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[dbax_form_enca2]  WITH CHECK ADD  CONSTRAINT [FK_dbax_form_enca2_dbax_tipo_conc] FOREIGN KEY([tipo_conc])
REFERENCES [dbo].[dbax_tipo_conc] ([tipo_conc])
GO
ALTER TABLE [dbo].[dbax_form_enca2] CHECK CONSTRAINT [FK_dbax_form_enca2_dbax_tipo_conc]
GO
