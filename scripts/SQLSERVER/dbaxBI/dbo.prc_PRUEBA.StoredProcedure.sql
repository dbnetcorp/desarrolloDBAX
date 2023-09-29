USE [dbaxBI]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[prc_PRUEBA] 
	
as

SET NOCOUNT ON

BEGIN

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='PF_2_06_Periodos') 
	BEGIN
			CREATE TABLE [dbo].[PF_2_06_Periodos](
				[CodigoPeriodo] [varchar](256) COLLATE Modern_Spanish_CI_AS NULL,
				[Periodo] [varchar](7) COLLATE Modern_Spanish_CI_AS NOT NULL,
			CONSTRAINT [PK2_Periodos] PRIMARY KEY CLUSTERED 
			(
				[Periodo] DESC
			)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
			) ON [PRIMARY]

	END
ELSE
	BEGIN

	INSERT INTO PF_2_06_Periodos 
	select	distinct
			codi_cntx			as CodigoPeriodo, 
			desc_cntx			as Periodo
	from BI_SG_Periodos A
	where   not exists (select	1 
						from 	PF_2_06_Periodos B 
						where codi_cntx = CodigoPeriodo
						and   desc_cntx = Periodo
						)
	order by codi_cntx
	END
END
GO
