

Create procedure [dbo].[Proc_Data_Analysis] (@TblName varchar(100)) as
begin
--declare @TblName varchar(100) set @TblName='FRMLOCATION'
declare @sql nvarchar(max),@id smallint,@Column varchar(100),@DistinctCount smallint,@count smallint,@datatype varchar(15),@datacount int,@null int,@notnull int,@mindataint int,
@maxlen int,@avglen int,@minmax varchar(500),@mean decimal(18,6),@median varchar(1000),@mode varchar(1000),@sd decimal(30,6)

set @sql=''

set nocount on

------Total count of all rows in the table
set @sql='
select @Count=count(1) from '+@TblName+''
exec sp_executesql @SQL, N'@Count int out', @Count out
--print @Count

if exists (select * from sysobjects where id=OBJECT_ID(N'Data_Analysis') and OBJECTPROPERTY(id,N'isusertable')=1)
drop table Data_Analysis

Create Table Data_Analysis(
ID int identity not null,
[Column Name] varchar(200),
[Definition/Significance] varchar(10),
Used varchar(10),
[Send to Brian] varchar(10),
[Unique PK/FK] varchar(7),
[Frequency Analysis] varchar(10),
[Suggested datatype] varchar(15),
[Empty/Null%] int,
[Distinct Records] int,
[Maximum Length] int,
Remarks varchar(500),
[Average Length] int,
[Suggested Column Size] varchar(15),
Minimum varchar(300),
Maximum varchar(300),
Mean int,
Median varchar(100),
Mode varchar(1000),
[1st SD] decimal(30,6)
)

declare Colum cursor for
select ORDINAL_POSITION,quotename(COLUMN_NAME) from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME=@TblName
open colum
fetch next from Colum into @id,@Column
while @@FETCH_STATUS=0
begin
print @Column


-----------------Inserting Column Names into table--------------------
set @sql='
insert into Data_Analysis( [Column Name]) values('''+@Column+''')'
--print (@SQL)
Exec sp_executesql @SQL
---------------------------------------------------------------------


set @DistinctCount=0
set @sql='
select @DistinctCount=count(distinct '+@Column+') from '+@TblName+' where '+@Column+' is not null'
--print @DistinctCount
exec sp_executesql @SQL, N'@DistinctCount int out', @DistinctCount out



--------Updating [Unique PK/FK] Column
update Data_Analysis set [Unique PK/FK]=case when @DistinctCount=@Count then 'Yes' else 'No' end where [Column Name]=@Column


--------Updating [Suggested datatype] Column
set @sql='
select @datacount=count(1) from(
select distinct case when ISNUMERIC('+@Column+')=0 and ISDATE('+@Column+')=1 then ''datetime'' when ISNUMERIC('+@Column+')=1 and ISNUMERIC(Replace(Replace('+@Column+',''+'',''A''),''-'',''A'') + ''.0e0'')=1 then ''int'' else case when  ISNUMERIC('+@Column+')=1 and ISNUMERIC(Replace(Replace('+@Column+',''+'',''A''),''-'',''A'') + ''.0e0'')=0  then ''decimal'' else ''varchar'' end end datatype
FROM '+@TblName+' where ('+@Column+' is not null and cast('+@Column+' as varchar)<>''''))datacount'
exec sp_executesql @SQL, N'@datacount int out', @datacount out
--print @datacount
--print @sql
set @datatype=''
if @datacount=1
begin
set @sql='
select distinct @datatype=@datatype+case when ISNUMERIC('+@Column+')=0 and ISDATE('+@Column+')=1 then ''datetime'' when ISNUMERIC('+@Column+')=1 and ISNUMERIC(Replace(Replace('+@Column+',''+'',''A''),''-'',''A'') + ''.0e0'')=1 then ''int'' else case when  ISNUMERIC('+@Column+')=1 and ISNUMERIC(Replace(Replace('+@Column+',''+'',''A''),''-'',''A'') + ''.0e0'')=0  then ''decimal'' else ''varchar'' end end
FROM '+@TblName+' where ('+@Column+' is not null and cast('+@Column+' as varchar)<>'''')'
exec sp_executesql @SQL, N'@datatype varchar(15) out', @datatype out
--print @sql
--print @datatype
end
else
begin
set @datatype='varchar'
end
update Data_Analysis set [Suggested datatype]=@datatype where [Column Name]=@Column


--------updating [Empty/Null%] column
set @null=0
set @sql='
select @null=count(1) FROM '+@TblName+' where isnull(cast('+@Column+' as varchar),'''')='''' and ('+@Column+' is null or cast('+@Column+' as varchar)='''')'
exec sp_executesql @SQL, N'@null int out', @null out
--print @sql
--print @null
update Data_Analysis set [Empty/Null%]=@null*100/@count where [Column Name]=@Column


--------updating [Distinct Records] column
update Data_Analysis set [Distinct Records]=@DistinctCount where [Column Name]=@Column


--------updating [Maximum Length] column
set @maxlen=0
set @sql='
SELECT @maxlen=max(LEN(isnull(cast('+@Column+' as varchar(500)),''''))) FROM '+@TblName+''
exec sp_executesql @SQL, N'@maxlen int out', @maxlen out
--print @maxlen
update Data_Analysis set [Maximum Length]=@maxlen where [Column Name]=@Column


--------updating [Average Length] column
set @avglen=0
set @sql='
SELECT @avglen=avg(LEN(isnull(cast('+@Column+' as varchar(500)),''''))) FROM '+@TblName+''
exec sp_executesql @SQL, N'@avglen int out', @avglen out
--print @avglen
update Data_Analysis set [Average Length]=@avglen where [Column Name]=@Column


--------updating [Suggested Column Size] column
set @mindataint=0
while power(2,@mindataint)-1<=@maxlen
begin
set @mindataint=@mindataint+1
end
--print @mindataint
update Data_Analysis set [Suggested Column Size]=case when @datatype='varchar' then 'varchar('+cast(power(2,@mindataint)-1 as varchar)+')' when @datatype='decimal' then 'decimal(18,6)' else '' end where [Column Name]=@Column


--------updating Minimum column
set @minmax=''
set @sql='
SELECT @minmax=min('+@Column+') FROM '+@TblName+''
exec sp_executesql @SQL, N'@minmax varchar(1000) out', @minmax out
--print @sql
--print @minmax
update Data_Analysis set Minimum=@minmax where [Column Name]=@Column


--------updating Maximum column
set @sql='
SELECT @minmax=max('+@Column+') FROM '+@TblName+''
exec sp_executesql @SQL, N'@minmax varchar(1000) out', @minmax out
--print @sql
--print @minmax
update Data_Analysis set Maximum=@minmax where [Column Name]=@Column


--------updating Mean column
set @mean=0
if @datatype in ('int','decimal')
begin
set @sql='
SELECT @mean=avg(cast('+@Column+' as decimal(18,6))) FROM '+@TblName+''
exec sp_executesql @SQL, N'@mean int out', @mean out
--print @sql
--print @mean
update Data_Analysis set Mean=@mean where [Column Name]=@Column
end
else
begin
update Data_Analysis set Mean=0 where [Column Name]=@Column
end


----------updating Median column
set @median=''
set @notnull=0
declare @cte as table (id int, columns varchar(500))
set @notnull=@count-@null
--print @notnull
--print (@notnull-1)/2+1
--print @notnull%2.0
set @sql='
select row_number() over(order by '+@column+') id,'+@column+' from '+@TblName+' where '+@column+' is not  null'
--print @sql
INSERT INTO @cte
EXEC(@sql)
if @notnull%2.0>0
begin
select @median=@median+cast(columns as varchar(100)) from @cte where id=(@notnull-1)/2+1
--select @id=id from @cte where id=case when (@notnull-1)/2+1 <0 then 0 else (@notnull-1)/2+1 end print cast(@id as varchar)+'--id'
end
else
begin
select @median=@median+','+cast(columns as varchar(100)) from @cte where id in (case when (@notnull/2-1)<0 then 0 else (@notnull/2-1) end,(@notnull/2+1))
--select @id=id from @cte where id in (case when (@notnull/2-1)<0 then 0 else (@notnull/2-1) end,(@notnull/2+1)) print cast(@id as varchar)+'--id'
set @median=right(@median,case when len(@median)=0 then 0 else len(@median)-1 end)
end
--print @median+'--median'
delete from @cte
update Data_Analysis set Median=@median where [Column Name]=@Column


----------updating Mode column
set @mode=''
set @sql='
select row_number() over (partition by '+@column+' order by '+@column+') id,'+@column+' from '+@TblName+' where '+@column+' is not  null'
--print @sql
INSERT INTO @cte
EXEC(@sql)
select @mode=@mode+','+cast(columns as varchar(100)) from @cte where id>1 and id=(select max(id) from @cte) 
set @mode=right(@mode,case when len(@mode)=0 then 0 else len(@mode)-1 end)
--print @mode
delete from @cte
update Data_Analysis set Mode=@mode where [Column Name]=@Column


--------updating [1st SD] column
set @sd=0
declare @sdv as table (id int, columns decimal(30,6))
if @datatype in ('int','decimal')
begin
set @sql='
select row_number() over(order by '+@column+') id,(cast('+@column+' as decimal(18,6))-('+cast(@mean as varchar)+'))  from '+@TblName+' where '+@column+' is not  null'
--print @sql
INSERT INTO @sdv
EXEC(@sql)
select @sd=sqrt(avg(power(columns,2))) from @sdv
--print @sd
delete from @sdv
update Data_Analysis set [1st SD]=@sd where [Column Name]=@Column
End
else
begin
update Data_Analysis set [1st SD]=0 where [Column Name]=@Column
end


fetch next from colum into @id,@column
end
close colum
deallocate colum

END

--Proc_Data_Analysis 'FRMLOCATION'
