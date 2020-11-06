ALTER PROCEDURE SP_ProfilData
@tablename NVARCHAR(255)
AS
BEGIN
TRUNCATE TABLE ProfileData
DECLARE @sql NVARCHAR(MAX)
DECLARE @columnname NVARCHAR(MAX)
DECLARE @datatype NVARCHAR(MAX)
DECLARE @mindatavalue NVARCHAR(MAX)
DECLARE @maxdatavalue NVARCHAR(MAX)
DECLARE @distinctrecord NVARCHAR(MAX)
DECLARE @nullrecord INT
DECLARE @mindatalength NVARCHAR(MAX)
DECLARE @maxdatalength NVARCHAR(MAX)
DECLARE @avgdatalength NVARCHAR(MAX)
DECLARE @percentnull DECIMAL(19,6)
DECLARE @mode INT
DECLARE @c_count INT
DECLARE @i INT=1
DECLARE @trecord DECIMAL(19,6)

SET @sql=(N'SELECT @trecord=COUNT(*) FROM '+@tablename)
EXEC sp_executesql @sql,N'@trecord DECIMAL(19,6) out', @trecord out



SET @c_count=(SELECT COUNT (COLUMN_NAME) FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = @tablename)

WHILE (@i<=@c_count)
BEGIN



	SET @columnname=(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @tablename AND ORDINAL_POSITION=@i)

	SET @sql=(N'SELECT @mindatalength=(min(len('+QUOTENAME(@columnname)+'))) FROM '+@tablename+'')
	EXEC sp_executesql @sql,N'@mindatalength NVARCHAR(MAX) out',@mindatalength out

	SET @sql=(N'SELECT @maxdatalength=(max(len('+QUOTENAME(@columnname)+'))) FROM '+@tablename+'')
	EXEC sp_executesql @sql,N'@maxdatalength NVARCHAR(MAX) out',@maxdatalength out

	SET @sql=(N'SELECT @avgdatalength=(avg(len('+QUOTENAME(@columnname)+'))) FROM '+@tablename+'')
	EXEC sp_executesql @sql,N'@avgdatalength NVARCHAR(MAX) out',@avgdatalength out

	SET @sql=N'SELECT @nullrecord=(COUNT(*)) FROM '+@tablename+' WHERE '+QUOTENAME(@columnname)+' IS NULL'
	EXEC sp_executesql @sql,N'@nullrecord NVARCHAR(MAX) out',@nullrecord out
	
	SET @percentnull=(@nullrecord/@trecord)*100

	SET @sql=(N'SELECT @mindatavalue=(MIN('+QUOTENAME(@columnname)+')) FROM '+@tablename+'')
	EXEC sp_executesql @sql,N'@mindatavalue NVARCHAR(MAX) out',@mindatavalue out

	SET @sql=(N'SELECT @maxdatavalue=(MAX('+QUOTENAME(@columnname)+')) FROM '+@tablename+'')
	EXEC sp_executesql @sql,N'@maxdatavalue NVARCHAR(MAX) out',@maxdatavalue out
	
	SET @sql=(N'SELECT TOP 1  @mode=(COUNT('+QUOTENAME(@columnname)+'))  FROM '+@tablename+' GROUP BY '+QUOTENAME(@columnname)+' ORDER BY COUNT('+QUOTENAME(@columnname)+') DESC')
	EXEC sp_executesql @sql,N'@mode NVARCHAR(MAX) out',@mode out
	
	SET @sql=(N'SELECT @distinctrecord=COUNT(Distinct '+QUOTENAME(@columnname)+')  FROM '+@tablename+'')
	EXEC sp_executesql @sql,N'@distinctrecord NVARCHAR(MAX) out',@distinctrecord out
	
	
	INSERT INTO ProfileData
	(COLUMN_NAME,MinDataLength,MaxDataLength,AvgDataLength,NullRecords,PercentageNulls,MinDataValue,MaxDataValue,DistinctRecords,Mode)VALUES
	(@columnname,@mindatalength,@maxdatalength,@avgdatalength,@nullrecord,@percentnull,@mindatavalue,@maxdatavalue,@distinctrecord,@mode)


	SET @i=@i + 1

-----while loop end
END

-----SP end
END

EXEC SP_ProfilData FRMLCopoy

-----Profile Table
SELECT * FROM ProfileData

----Profile table Schema

CREATE TABLE ProfileData
(
COLUMN_NAME NVARCHAR(MAX)
,DataType VARCHAR(MAX)
,MinDataLength VARCHAR(MAX)
,MaxDataLength VARCHAR(MAX)
,AvgDataLength VARCHAR(MAX)
,DistinctRecords VARCHAR(MAX)
,NullRecords INT
,PercentageNulls DECIMAL(19,6)
,MinDataValue VARCHAR(MAX)
,MaxDataValue VARCHAR(MAX)
,Mode INT

)

