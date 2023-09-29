declare @codi_pers varchar(30), @corr_inst varchar(30)
declare c1 cursor
	for select codi_pers, corr_inst from dbax_inst_vers
	where corr_inst = 201703
	and   vers_inst < 30
	and   codi_pers in (select codi_pers from dbax_defi_pers where tipo_taxo = 'COME_INDU')

OPEN c1  
FETCH NEXT FROM c1 INTO @codi_pers, @corr_inst

	select count(*)
	from dbax_inst_vers
	where corr_inst = 201703
	and   vers_inst < 30
	and   codi_pers in (select codi_pers from dbax_defi_pers where tipo_taxo = 'COME_INDU')

WHILE @@FETCH_STATUS = 0  
BEGIN  
	--select * from dbax_inst_vers where codi_pers = @codi_pers and corr_inst = @corr_inst and vers_inst < 30
	print('Ejecutando : ' + @codi_pers)
	
	--EXEC [dbo].[SP_AX_delInstDocu] @pCodiPers = @codi_pers, @pCorrInst = @corr_inst, @pVersInst = 0
	FETCH NEXT FROM c1 INTO @codi_pers, @corr_inst
END
CLOSE c1;  
DEALLOCATE c1;
