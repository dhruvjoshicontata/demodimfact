-- =============================================      
-- Description: <Description,,>      
-- exec [usp_DataAnalysis] @TABLE_NAME='TaLocation'    
-- =============================================    
CREATE PROCEDURE [usp_DataAnalysis]    
@TABLE_NAME VARCHAR(100)=''    
AS    
BEGIN    
SET NOCOUNT ON   
DELETE FROM TaAnalysis  
IF(@TABLE_NAME='')    
BEGIN    
PRINT('No Table Name Was given')    
END    
ELSE IF((SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME=@TABLE_NAME AND TABLE_TYPE='BASE TABLE') IS NULL)    
BEGIN    
PRINT('Table '+@TABLE_NAME+' Does not exist')    
END    
ELSE    
BEGIN    
DECLARE @COLUMN_NAME VARCHAR(100)    
DECLARE @SQL VARCHAR(MAX)    
    
DECLARE CUR CURSOR FOR SELECT     
--TOP 2    
'['+COLUMN_NAME+']' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME=@TABLE_NAME    
--AND COLUMN_NAME='1_mile_pop'     
OPEN CUR    
FETCH NEXT FROM CUR INTO @COLUMN_NAME    
WHILE @@FETCH_STATUS=0    
BEGIN    
SET @SQL='    
INSERT INTO [TaAnalysis]    
(    
[CoColumnName],    
[CoDefinition],    
[CoUsed],    
[CoSendToBrian],    
[CoUniquePkFk],    
[CoFrequency],    
[CoSuggestedDataType],    
[CoEmptyNullPercent],    
[CoDistinctRecords],    
[CoMaxLength],    
[CoRemarks],    
[CoAvgLength],    
[CoSuggestedColumnSize],    
[CoMininum],    
[CoMaximum],    
[CoMean],    
[CoMedian],    
[CoMode],    
[CoFirstStandardDeviation]    
)    
SELECT    
'''+@COLUMN_NAME+''' AS [CoColumnName],    
'''' AS [CoDefinition],    
0 AS [CoUsed],    
0 AS [CoSendToBrian],    
CASE     
WHEN (SELECT COUNT(REPLACE(REPLACE(ISNULL('+@COLUMN_NAME+',''0''),'','',''''),''$'','''')) FROM '+@TABLE_NAME+' WITH(NOLOCK))    
=(SELECT COUNT(DISTINCT REPLACE(REPLACE(ISNULL('+@COLUMN_NAME+',''0''),'','',''''),''$'','''')) FROM '+@TABLE_NAME+' WITH(NOLOCK))    
THEN 1    
ELSE 0    
END AS [CoUniquePkFk],    
'''' AS [CoFrequency],    
CASE     
WHEN (SELECT COUNT(REPLACE(REPLACE(ISNULL('+@COLUMN_NAME+',''0''),'','',''''),''$'','''')) FROM '+@TABLE_NAME+' WITH(NOLOCK))=    
(SELECT COUNT(REPLACE(REPLACE(ISNULL('+@COLUMN_NAME+',''0''),'','',''''),''$'','''')) FROM '+@TABLE_NAME+' WITH(NOLOCK) WHERE '+@COLUMN_NAME+' IS NULL)    
THEN ''N/A''    
WHEN (SELECT COUNT(TRY_CONVERT(DATETIME,REPLACE(REPLACE(ISNULL('+@COLUMN_NAME+',GETDATE()),'','',''''),''$'',''''),105)) FROM '+@TABLE_NAME+' WITH(NOLOCK)    
WHERE TRY_CONVERT(DATETIME,REPLACE(REPLACE(ISNULL('+@COLUMN_NAME+',GETDATE()),'','',''''),''$'',''''),105) IS NOT NULL)    
=(SELECT COUNT(REPLACE(REPLACE(ISNULL('+@COLUMN_NAME+',GETDATE()),'','',''''),''$'','''')) FROM '+@TABLE_NAME+' WITH(NOLOCK))    
THEN ''DATETIME''    
WHEN (SELECT COUNT(REPLACE(REPLACE(ISNULL('+@COLUMN_NAME+',''0''),'','',''''),''$'','''')) FROM '+@TABLE_NAME+' WITH(NOLOCK) WHERE     
ISNULL('+@COLUMN_NAME+',''0'') NOT IN (''0'',''1''))=0 THEN ''BIT''    
WHEN ISNULL((SELECT TOP 1 ISNUMERIC(REPLACE(REPLACE(ISNULL('+@COLUMN_NAME+',''0''),'','',''''),''$'','''')) FROM '+@TABLE_NAME+' WITH(NOLOCK)    
WHERE ISNUMERIC(REPLACE(REPLACE(ISNULL('+@COLUMN_NAME+',''0''),'','',''''),''$'',''''))=0),''1'')=0    
THEN     
CASE    
WHEN (SELECT COUNT(DISTINCT LEN(REPLACE(REPLACE(ISNULL('+@COLUMN_NAME+',''0''),'','',''''),''$'',''''))) FROM '+@TABLE_NAME+' WITH(NOLOCK))=1    
THEN ''CHAR''    
ELSE ''VARCHAR''    
END    
WHEN ISNULL((SELECT TOP 1 ISNUMERIC(REPLACE(REPLACE(ISNULL('+@COLUMN_NAME+',''0''),'','',''''),''$'','''')) FROM '+@TABLE_NAME+' WITH(NOLOCK)    
WHERE ISNUMERIC(REPLACE(REPLACE(ISNULL('+@COLUMN_NAME+',''0''),'','',''''),''$'',''''))=0),''1'')=1    
THEN     
CASE    
WHEN (SELECT TOP 1 REPLACE(REPLACE(ISNULL('+@COLUMN_NAME+',''0''),'','',''''),''$'','''') FROM '+@TABLE_NAME+' WITH(NOLOCK)    
WHERE REPLACE(REPLACE(ISNULL('+@COLUMN_NAME+',''0''),'','',''''),''$'','''') LIKE ''%.%''    
) LIKE ''%.%''    
THEN ''NUMERIC''    
ELSE ''INTEGER''    
END    
ELSE ''N/D''    
END    
AS [CoSuggestedDataType],    
CONVERT(NUMERIC(13,2),(SELECT COUNT(REPLACE(REPLACE(ISNULL('+@COLUMN_NAME+',''''),'','',''''),''$'','''')) FROM '+@TABLE_NAME+' WITH(NOLOCK)     
WHERE REPLACE(REPLACE(ISNULL('+@COLUMN_NAME+',''''),'','',''''),''$'','''')=''''))/    
CONVERT(NUMERIC(13,2),(SELECT COUNT(REPLACE(REPLACE(ISNULL('+@COLUMN_NAME+',''''),'','',''''),''$'','''')) FROM '+@TABLE_NAME+' WITH(NOLOCK)))*100    
AS [CoEmptyNullPercent],    
(SELECT COUNT(DISTINCT REPLACE(REPLACE(ISNULL('+@COLUMN_NAME+',''0''),'','',''''),''$'','''')) FROM '+@TABLE_NAME+' WITH(NOLOCK)) AS [CoDistinctRecords],    
(SELECT MAX(LEN(ISNULL('+@COLUMN_NAME+',''0''))) FROM '+@TABLE_NAME+' WITH(NOLOCK)) AS [CoMaxLength],    
'''' AS [CoRemarks],    
(SELECT AVG(LEN(ISNULL('+@COLUMN_NAME+',''0''))) FROM '+@TABLE_NAME+' WITH(NOLOCK)) AS [CoAvgLength],    
0 AS [CoSuggestedColumnSize],    
(SELECT MIN(ISNULL('+@COLUMN_NAME+',''0'')) FROM '+@TABLE_NAME+' WITH(NOLOCK)) AS [CoMininum],    
(SELECT MAX(ISNULL('+@COLUMN_NAME+',''0'')) FROM '+@TABLE_NAME+' WITH(NOLOCK)) AS [CoMaximum],    
0 AS [CoMean],    
0 AS [CoMedian],    
0 AS [CoMode],    
0 AS [CoFirstStandardDeviation]    
'    
SET @SQL=@SQL    
+    
'    
;WITH Count_Median AS    
(    
SELECT COUNT(ISNULL(REPLACE(REPLACE('+@COLUMN_NAME+','','',''''),''$'',''''),0))/2 AS Counted FROM '+@TABLE_NAME+' WITH(NOLOCK)    
)    
UPDATE TaAnalysis     
SET    
CoMedian=    
(    
SELECT    
CASE WHEN (SELECT Counted FROM Count_Median)%2=0 THEN    
(    
SELECT SUM(Median)/2 FROM    
(    
SELECT ISNULL(TRY_CONVERT(NUMERIC(13,2),REPLACE(REPLACE('+@COLUMN_NAME+','','',''''),''$'','''')),0) AS Median    
FROM '+@TABLE_NAME+' WITH(NOLOCK)    
ORDER BY Median    
OFFSET (SELECT COUNTED-1 FROM Count_Median) ROWS FETCH NEXT 2 ROWS ONLY    
) AS HH    
)    
ELSE (    
SELECT ISNULL(TRY_CONVERT(NUMERIC(13,2),REPLACE(REPLACE('+@COLUMN_NAME+','','',''''),''$'','''')),0) AS Median    
FROM '+@TABLE_NAME+' WITH(NOLOCK)    
ORDER BY Median    
OFFSET (SELECT COUNTED FROM Count_Median) ROWS FETCH NEXT 1 ROWS ONLY    
)    
END    
)    
,    
CoMode=    
(    
SELECT TOP 1    
ISNULL(TRY_CONVERT(BIGINT,REPLACE(REPLACE('+@COLUMN_NAME+','','',''''),''$'','''')),0) AS HighestMode    
FROM '+@TABLE_NAME+' WITH(NOLOCK)    
WHERE ISNULL(TRY_CONVERT(BIGINT,REPLACE(REPLACE('+@COLUMN_NAME+','','',''''),''$'','''')),0)<>0    
GROUP BY ISNULL(TRY_CONVERT(BIGINT,REPLACE(REPLACE('+@COLUMN_NAME+','','',''''),''$'','''')),0)    
ORDER BY COUNT(ISNULL(TRY_CONVERT(BIGINT,REPLACE(REPLACE('+@COLUMN_NAME+','','',''''),''$'','''')),0)) DESC,    
HighestMode    
),    
CoFirstStandardDeviation=1    
WHERE CoColumnName='''+@COLUMN_NAME+'''    
AND CoSuggestedDataType IN (''INTEGER'')    
AND CoUniquePkFk<>1    
'    
SET @SQL=@SQL    
+    
'    
UPDATE TaAnalysis     
SET CoMean=(    
(SELECT     
SUM(ISNULL(TRY_CONVERT(NUMERIC(13,2),REPLACE(REPLACE('+@COLUMN_NAME+','','',''''),''$'','''')),0)) FROM '+@TABLE_NAME+' WITH(NOLOCK))/    
(SELECT COUNT(ISNULL(REPLACE(REPLACE('+@COLUMN_NAME+','','',''''),''$'',''''),0)) FROM '+@TABLE_NAME+' WITH(NOLOCK))    
)    
WHERE CoColumnName='''+@COLUMN_NAME+'''    
AND CoSuggestedDataType IN (''INTEGER'',''NUMERIC'')    
AND CoUniquePkFk<>1    
'    
SET @SQL=@SQL    
+    
'    
UPDATE TaAnalysis     
SET CoFirstStandardDeviation=(    
SELECT SQRT(SUM(CoSum)/COUNT(CoSum))    
FROM(    
SELECT     
SQUARE(ISNULL(TRY_CONVERT(NUMERIC(13,2),REPLACE(REPLACE('+@COLUMN_NAME+','','',''''),''$'','''')),0)-ISNULL(CoMean,0)) AS CoSum FROM '+@TABLE_NAME+' WITH(NOLOCK))    
AS HH    
)    
WHERE CoColumnName='''+@COLUMN_NAME+'''    
AND CoSuggestedDataType IN (''INTEGER'',''NUMERIC'')    
AND CoUniquePkFk<>1    
'    
SET @SQL=@SQL    
+    
'    
UPDATE TaAnalysis     
SET CoFirstStandardDeviation=(    
SELECT SQRT(SUM(CoSum)/COUNT(CoSum))    
FROM(    
SELECT     
SQUARE(ISNULL(TRY_CONVERT(NUMERIC(13,2),REPLACE(REPLACE('+@COLUMN_NAME+','','',''''),''$'','''')),0)-ISNULL(CoMean,0)) AS CoSum FROM '+@TABLE_NAME+' WITH(NOLOCK))    
AS HH    
)    
WHERE CoColumnName='''+@COLUMN_NAME+'''    
AND CoSuggestedDataType IN (''INTEGER'',''NUMERIC'')    
AND CoUniquePkFk<>1    
'    
SET @SQL=@SQL    
+    
'    
;WITH cte_numbers(n)     
AS (    
SELECT     
1 AS n    
UNION ALL    
SELECT        
n + 1    
FROM        
cte_numbers    
WHERE n<12    
)    
UPDATE TaAnalysis     
SET CoSuggestedColumnSize=(    
CASE     
WHEN CoMaxLength < 4096 THEN CONVERT(VARCHAR,(SELECT TOP 1 POWER(2,n)-1 FROM cte_numbers WHERE POWER(2,n)>CoMaxLength))    
WHEN CoMaxLength >= 4096 AND CoMaxLength <=8000 THEN ''8000''    
ELSE ''MAX''    
END    
)    
WHERE CoColumnName='''+@COLUMN_NAME+'''    
AND CoSuggestedDataType IN (''VARCHAR'')    
'    
BEGIN TRY    
EXEC(@SQL)    
UPDATE TaAnalysis SET CoColumnName=REPLACE(REPLACE(CoColumnName,'[',''),']','')    
END TRY    
BEGIN CATCH    
SELECT @COLUMN_NAME AS [Column],ERROR_MESSAGE() AS Error    
PRINT(@SQL)    
END CATCH    
FETCH NEXT FROM CUR INTO @COLUMN_NAME    
END    
CLOSE CUR    
DEALLOCATE CUR    
END    
END 
-- =============================================      