CREATE TABLE [dbo].[TaLocationDate] (
    [TLD_Location_ID]               NVARCHAR (63) NOT NULL,
    [Actual_Opening]                DATETIME      NULL,
    [BOE_Verified]                  DATETIME      NULL,
    [Close_Date]                    DATETIME      NULL,
    [Opened_On]                     DATETIME      NULL,
    [Original_Franchisee_Open_Date] DATETIME      NULL,
    [Sale_Date]                     DATETIME      NULL,
    [Agreement_Renewal_Date]        DATETIME      NULL,
    [Agreement_Signed]              DATETIME      NULL,
    [Created_On]                    DATETIME      NULL,
    [Modified_On]                   DATETIME      NULL,
    CONSTRAINT [PK_TaLocationDate] PRIMARY KEY CLUSTERED ([TLD_Location_ID] ASC)
);

