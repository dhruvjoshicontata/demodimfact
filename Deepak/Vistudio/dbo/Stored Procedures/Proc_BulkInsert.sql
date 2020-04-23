Create Procedure BulkInsert as
Begin


	if exists (select * from sysobjects where id=OBJECT_ID(N'[FRMLocatio]') and OBJECTPROPERTY(OBJECT_ID(N'[FRMLocatio]'),N'isusertable')=1)
	truncate table [FRMLocatio]

	  bulk insert dbo.[FRMLocatio] from 'D:\Deepak\Deepak_Contata_Tasks\FRMLocation20200227-083014.csv'
	  with(fieldterminator='|', rowterminator='\n',FIRSTROW=2);

	  
	declare @id int,@idmax int,@sql varchar(max),@column varchar(2000)
	declare Colum cursor for
	select ordinal_position,quotename([COLUMN_NAME]) from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='FRMLOCATIO'
	open colum
	fetch next from Colum into @id,@Column
	while @@FETCH_STATUS=0
	begin
	--print @Column
	set @sql='
	update [FRMLOCATIO] set '+@column+'=replace(ltrim(Rtrim(replace('+@column+',''"'',''''))),''$'','''')'
		--print @sql
		exec (@sql)
		set @sql='
	update [FRMLOCATIO] set '+@column+'=NULL where '+@column+'='''''
		--print @sql
		exec (@sql)

		set @sql='
	update [FRMLOCATIO] set '+@column+'=replace('+@column+',''  '','' '') where '+@column+' like ''%  %'''
		--print @sql
		exec (@sql)
	


fetch next from colum into @id,@column
end
close colum
deallocate colum

select * from dbo.[FRMLocatio]

End