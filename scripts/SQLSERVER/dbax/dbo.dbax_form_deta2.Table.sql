SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_form_deta2](
	[codi_indi] [varchar](100) NOT NULL,
	[letr_vari] [varchar](2) NOT NULL,
	[pref_conc] [varchar](50) NULL,
	[codi_conc] [varchar](256) NULL,
 CONSTRAINT [PK_dbax_form_deta2] PRIMARY KEY CLUSTERED 
(
	[codi_indi] ASC,
	[letr_vari] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[dbax_form_deta2]  WITH CHECK ADD  CONSTRAINT [FK_dbax_form_deta2_dbax_defi_conc] FOREIGN KEY([codi_conc], [pref_conc])
REFERENCES [dbo].[dbax_defi_conc] ([codi_conc], [pref_conc])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dbax_form_deta2] CHECK CONSTRAINT [FK_dbax_form_deta2_dbax_defi_conc]
GO
ALTER TABLE [dbo].[dbax_form_deta2]  WITH CHECK ADD  CONSTRAINT [FK_dbax_form_deta2_dbax_form_enca2] FOREIGN KEY([codi_indi])
REFERENCES [dbo].[dbax_form_enca2] ([codi_indi])
GO
ALTER TABLE [dbo].[dbax_form_deta2] CHECK CONSTRAINT [FK_dbax_form_deta2_dbax_form_enca2]
GO
