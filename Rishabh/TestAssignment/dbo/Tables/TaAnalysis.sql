CREATE TABLE [dbo].[TaAnalysis] (
    [CoColumnName]             VARCHAR (100)   NULL,
    [CoDefinition]             VARCHAR (100)   NULL,
    [CoUsed]                   BIT             NULL,
    [CoSendToBrian]            BIT             NULL,
    [CoUniquePkFk]             BIT             NULL,
    [CoFrequency]              VARCHAR (1000)  NULL,
    [CoSuggestedDataType]      VARCHAR (100)   NULL,
    [CoEmptyNullPercent]       NUMERIC (13, 2) NULL,
    [CoDistinctRecords]        BIGINT          NULL,
    [CoMaxLength]              INT             NULL,
    [CoRemarks]                VARCHAR (1000)  NULL,
    [CoAvgLength]              TINYINT         NULL,
    [CoSuggestedColumnSize]    INT             NULL,
    [CoMininum]                VARCHAR (1000)  NULL,
    [CoMaximum]                VARCHAR (1000)  NULL,
    [CoMean]                   NUMERIC (13, 2) NULL,
    [CoMedian]                 NUMERIC (13, 2) NULL,
    [CoMode]                   NUMERIC (13, 2) NULL,
    [CoFirstStandardDeviation] NUMERIC (13, 2) NULL
);

