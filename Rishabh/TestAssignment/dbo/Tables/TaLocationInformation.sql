CREATE TABLE [dbo].[TaLocationInformation] (
    [TLI_Location_ID] NVARCHAR (63)   NOT NULL,
    [Location_Type]   NVARCHAR (31)   NULL,
    [Territory]       NVARCHAR (2000) NULL,
    [City]            NVARCHAR (31)   NULL,
    [Country]         NVARCHAR (7)    NULL,
    [Latitude]        NUMERIC (18, 6) NULL,
    [Location]        NVARCHAR (63)   NULL,
    [Location_]       NVARCHAR (15)   NULL,
    [Longitude]       NUMERIC (18, 6) NULL,
    [State]           NVARCHAR (3)    NULL,
    [Time_Zone]       BIGINT          NULL,
    [ZIP_Postal_Code] NVARCHAR (15)   NULL,
    [Differentiator]  NVARCHAR (63)   NULL,
    CONSTRAINT [PK_TaLocationInformation] PRIMARY KEY CLUSTERED ([TLI_Location_ID] ASC)
);

