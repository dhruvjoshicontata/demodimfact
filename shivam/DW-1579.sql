  
  
CREATE PROCEDURE Franchise.InsertContract  
(  
 @MaxCreatedDate      DATETIME,  
 @DataLoadDateTime     DATETIME,  
 @logTaskControlFlowKeyContract  BIGINT  
)  
AS  
BEGIN  
  
 DECLARE @todayDate DATETIME  = GETUTCDATE()  
   ,@rowsFromSource INT = 0  
  
 DECLARE @ErrorMessage NVARCHAR(1023) = N''  
  
 BEGIN TRY  

  
  SELECT DISTINCT   
   C.ContractId  
   ,C.ClubID  
   ,C.[Status]  
   ,C.[Type]  
   ,C.Number  
   ,CASE WHEN YEAR(C.StartDate) > 2099 THEN '2099-12-31'  
     WHEN YEAR(C.StartDate) < 1800 THEN '1800-01-01'  
     ELSE C.StartDate  
   END AS StartDate  
   ,CASE WHEN YEAR(C.EndDate) > 2099 THEN '2099-12-31'  
     WHEN YEAR(C.EndDate) < 1800 THEN '1800-01-01'  
     ELSE C.EndDate  
   END AS EndDate  
   ,C.Term  
   ,CASE WHEN YEAR(C.DateSigned) > 2099 THEN '2099-12-31'  
     WHEN YEAR(C.DateSigned) < 1800 THEN '1800-01-01'  
     ELSE C.DateSigned  
   END AS DateSigned  
   ,C.Downpayment  
   ,C.MonthlyPayment  
   ,C.SalesPersonID  
   ,C.IsChanged  
   ,C.AgreementID  
   ,CASE WHEN YEAR(C.FirstPaymentDate) > 2099 THEN '2099-12-31'  
     WHEN YEAR(C.FirstPaymentDate) < 1800 THEN '1800-01-01'  
     ELSE C.FirstPaymentDate  
   END AS FirstPaymentDate  
   ,C.Frequency  
   ,CASE WHEN YEAR(C.Created) > 2099 THEN '2099-12-31'  
     WHEN YEAR(C.Created) < 1800 THEN '1800-01-01'  
     ELSE C.Created  
   END AS Created  
   ,CASE WHEN YEAR(C.Updated) > 2030 THEN '2030-12-31'  
     WHEN YEAR(C.Updated) < 1900 THEN '1800-01-01'  
     ELSE C.Updated  
   END AS Updated  
   ,CASE WHEN A.Color = 1 THEN 'G'   
      WHEN A.Color = 2 THEN 'Y'   
      WHEN A.Color = 3 THEN 'R'   
      WHEN A.Color = 4 THEN 'B'   
      ELSE 'Other'   
   END AS Color  
   ,CASE WHEN A.FreezeType = 1 THEN 'FreezeTime'   
      WHEN A.FreezeType = 2 THEN 'FreezeBilling'   
      ELSE 'Other'   
   END AS FreezeType  
   ,CM.MemberId  
   ,ModifiedBy = -1   
   ,ModifiedDate = @todayDate  
  INTO #Contract  
  FROM franchisesourcesync.Contracts(NOLOCK) C   
  INNER JOIN franchisesourcesync.Agreements(NOLOCK) A ON A.AgreementId = C.AgreementId   
  INNER JOIN franchisesourcesync.ContractMember(NOLOCK) CM ON CM.ContractID = C.ContractID   
  --WHERE CAST(COALESCE(C.Updated, C.Created) AS DATE) >= '@{activity('LKA_GetMaxDateAgreement').output.firstRow.MaxAgreementDate}' AND COALESCE(C.Updated, C.Created) <= '@{pipeline().parameters.DataLoadDateTime}'  
  WHERE ((CAST(C.Updated AS DATE) BETWEEN @MaxCreatedDate AND  @DataLoadDateTime) OR (CAST(C.Created AS DATE) BETWEEN @MaxCreatedDate AND  @DataLoadDateTime))  
  UNION ALL   
  SELECT -1 ContractId, NULL ClubID, NULL [Status], NULL [Type], NULL Number, NULL StartDate, NULL EndDate, NULL Term, NULL DateSigned, NULL Downpayment, NULL MonthlyPayment, NULL SalesPersonID, NULL IsChanged, NULL AgreementID, NULL FirstPaymentDate, NULL
 Frequency, NULL Created, NULL Updated, NULL , NULL , NULL MemberId, NULL , NULL   
  
 --To Delete Duplicates  
 ;WITH CTE AS(  
     SELECT  ContractId,   
       Updated,  
       RowNumber=ROW_NUMBER() OVER (PARTITION BY ContractId ORDER BY Updated DESC)  
     FROM #Contract  
    )  
 DELETE FROM CTE WHERE RowNumber>1  
  
  
  SELECT @rowsFromSource = COUNT(1) FROM #Contract  
    
  BEGIN TRAN  
  
   --TRUNCATE TABLE Franchise.Contracts  
  
     INSERT INTO Franchise.ContractsRaw  
   (  
    ContractID    
    ,ClubID      
    ,[Status]     
    ,[Type]    
    ,[Number]  
    ,StartDate    
    ,EndDate     
    ,Term     
    ,DateSigned    
    ,Downpayment    
    ,MonthlyPayment    
    ,SalesPersonID   
    ,IsChanged    
    ,AgreementID   
    ,FirstPaymentDate    
    ,Frequency    
    ,Created     
    ,Updated   
    ,Color  
    ,FreezeType  
    ,MemberId  
    ,ModifiedBy   
    ,ModifiedDate  
    ,GoodToImport  
   )  
   SELECT   
    ContractID    
    ,ClubID      
    ,[Status]     
    ,[Type]    
    ,[Number]  
    ,StartDate    
    ,EndDate     
    ,Term     
    ,DateSigned    
    ,Downpayment    
    ,MonthlyPayment    
    ,SalesPersonID   
    ,IsChanged    
    ,AgreementID   
    ,FirstPaymentDate    
    ,Frequency    
    ,Created     
    ,Updated  
    ,Color  
    ,FreezeType  
    ,MemberId  
    ,@logTaskControlFlowKeyContract  
    ,@todayDate  
    ,1  
   FROM #Contract  
   WHERE ModifiedBy IS NOT NULL  
  
   /***  
   Cleanup rules  
   ***/  
  
   --DELETE M  
   --FROM Franchise.MemberRaw (NOLOCK) M  
   --LEFT JOIN Franchise.Agreements(NOLOCK) A  
   -- ON M.AgreementId = A.AgreementId  
   --WHERE A.AgreementId IS NULL  
  
   --DELETE M   
   --FROM Franchise.MemberRaw (NOLOCK) M  
   --LEFT JOIN Franchise.Clubs (NOLOCK) C  
   -- ON M.ClubId = C.ClubId  
   --WHERE C.ClubId IS NULL  
  
  COMMIT TRAN  
   
 END TRY  
  
 BEGIN CATCH  
    
  IF @@TRANCOUNT>=1  
  ROLLBACK TRAN  
  
  SET @ErrorMessage=ISNULL(ERROR_MESSAGE(), '')  
  
  INSERT INTO Process.LogError  
  (  
   ErrorNumber  
   ,ErrorSeverity  
   ,ErrorState  
   ,ErrorProcedure  
   ,ErrorLine  
   ,ErrorMessage  
  )  
  SELECT   
   ERROR_NUMBER()  AS ErrorNumber  
      ,ERROR_SEVERITY() AS ErrorSeverity  
      ,ERROR_STATE()  AS ErrorState  
      ,ERROR_PROCEDURE() AS ErrorProcedure  
      ,ERROR_LINE()  AS ErrorLine  
      ,N'For LogTaskControlFlowKey: ' + CAST(@logTaskControlFlowKeyContract AS NVARCHAR(15))+ N' - ' +  
   @ErrorMessage  AS ErrorMessage  
  
 END CATCH  
  
 UPDATE process.LogTaskControlFlow   
 SET TotalRowsFromSource = ISNULL(TotalRowsFromSource,0)+ @rowsFromSource  
 ,ErrorMessage=CONCAT(ErrorMessage,'|',@ErrorMessage)  
 WHERE LogTaskControlFlowKey = @logTaskControlFlowKeyContract  
  
END