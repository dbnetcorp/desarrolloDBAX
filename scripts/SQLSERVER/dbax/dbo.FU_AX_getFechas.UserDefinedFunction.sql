SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[FU_AX_getFechas](
			@p_CorrInst numeric(10,0), 
			@p_DiaMes varchar(256),
			@p_Ano varchar(256)
			) returns varchar(4000)
begin
	declare @v_Valor varchar(256)
	declare @vMesActual varchar(2)
	declare @vAnoActual varchar(4)
	declare @vMes varchar(10)
	declare @vAno varchar(4)
	declare @vUltiDiaMes varchar(4)
	declare @vUltiDiaAno varchar(10)
	declare @vFechaActual varchar(15)
	declare @vFinTrimestreAnt varchar(4)
	declare @vPrimerDiaAno varchar(10)
	declare @vAnoAnterior varchar(10)
	declare @vAnoPrevioAnt varchar(10)

	select @vAnoActual=substring(convert(varchar,@p_CorrInst),1,4)
	select @vMesActual=substring(convert(varchar,@p_CorrInst),5,2)

	set @vFechaActual = @vAnoActual + @vMesActual + '01'
	set @vUltiDiaMes = substring(replace(convert(varchar, DATEADD(dd, -DAY(DATEADD(m,1,@vFechaActual)), DATEADD(m,1,@vFechaActual)), 111),'/',''),5,4)
	set @vFinTrimestreAnt = substring(replace(convert(varchar, DATEADD(dd, -DAY(DATEADD(m,-2,@vFechaActual)), DATEADD(m,-2,@vFechaActual)), 111),'/',''),5,4)
	set @vUltiDiaAno = '1231'
	set @vPrimerDiaAno = '0101'
	set @vAnoAnterior = @vAnoActual - 1
	set @vAnoPrevioAnt = @vAnoActual - 2

	if(@p_Ano = 'anoactual')
		set @vAno = @vAnoActual
	else if(@p_Ano = 'anoanterior')
		set @vAno = @vAnoAnterior
	else if(@p_Ano = 'anoprevioanterior')
		set @vAno = @vAnoPrevioAnt

	if(@p_DiaMes = 'finano')
		set @vMes = @vUltiDiaAno
	else if(@p_DiaMes = 'inicioano')
		set @vMes = @vPrimerDiaAno
	else if(@p_DiaMes = 'iniciotrimestreactual')
		set @vMes = @vFinTrimestreAnt
	else if(@p_DiaMes = 'ultimodiatrimestreactual')
		set @vMes = @vUltiDiaMes
	
	return @vAno + '-' +  substring(@vMes,1,2) + '-' + substring(@vMes,3,2)
end
GO
