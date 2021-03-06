﻿CREATE TABLE [dbo].[TaLocationPersonalInformation] (
    [TLPI_Location_ID]                     NVARCHAR (63)   NOT NULL,
    [Competition]                          NVARCHAR (3)    NULL,
    [Email_Address]                        NVARCHAR (63)   NULL,
    [Exchange_Rate]                        BIT             NULL,
    [Existing_Sales_Rep]                   NVARCHAR (100)  NULL,
    [Express_Location]                     NVARCHAR (3)    NULL,
    [Financing_Type]                       NVARCHAR (15)   NULL,
    [Lack_of_marketing]                    NVARCHAR (3)    NULL,
    [Landlord_Issues]                      NVARCHAR (3)    NULL,
    [Legal_Entity]                         NVARCHAR (127)  NULL,
    [Market_Type]                          NVARCHAR (31)   NULL,
    [MultiPurpose_Room]                    NVARCHAR (3)    NULL,
    [No_Operating_Capital]                 NVARCHAR (3)    NULL,
    [No_Sales_Revenue]                     NVARCHAR (3)    NULL,
    [Online_Signup]                        NVARCHAR (3)    NULL,
    [Open_Status]                          NVARCHAR (15)   NULL,
    [Open_Temporary_Pending_Relo]          NVARCHAR (3)    NULL,
    [Other]                                NVARCHAR (511)  NULL,
    [Other_Equipment]                      NVARCHAR (127)  NULL,
    [Other_Operating_System]               NVARCHAR (63)   NULL,
    [Owner]                                NVARCHAR (31)   NULL,
    [Partnership_Dispute]                  NVARCHAR (3)    NULL,
    [Personal_Issues]                      NVARCHAR (3)    NULL,
    [Personal_Training]                    NVARCHAR (3)    NULL,
    [Primary_Contact]                      NVARCHAR (63)   NULL,
    [Principal_Operator]                   NVARCHAR (63)   NULL,
    [Principal_Owner]                      NVARCHAR (63)   NULL,
    [Satellite_Club]                       NVARCHAR (3)    NULL,
    [Site]                                 NVARCHAR (3)    NULL,
    [Stage]                                NVARCHAR (31)   NULL,
    [Team_Workouts]                        NVARCHAR (3)    NULL,
    [Veteran]                              NVARCHAR (3)    NULL,
    [Virtual_Coaching]                     NVARCHAR (3)    NULL,
    [Waxing_Account]                       BIGINT          NULL,
    [Website]                              NVARCHAR (127)  NULL,
    [Active_CMS]                           NVARCHAR (15)   NULL,
    [AFLP_Auto_Checklist]                  NVARCHAR (3)    NULL,
    [AFLP_Inclub_Training_Lead]            NVARCHAR (3)    NULL,
    [AFLP_last_PostLaunch_Drip_email_sent] NVARCHAR (7)    NULL,
    [AFLP_Marketing]                       NVARCHAR (3)    NULL,
    [AFLP_Notes]                           NVARCHAR (511)  NULL,
    [Billing_Account_Number]               NVARCHAR (15)   NULL,
    [Brand]                                NVARCHAR (15)   NULL,
    [Club_OS]                              NVARCHAR (3)    NULL,
    [Club_Ready]                           NVARCHAR (3)    NULL,
    [Company]                              NVARCHAR (127)  NULL,
    [Currency]                             NVARCHAR (15)   NULL,
    [Main_Phone]                           NVARCHAR (63)   NULL,
    [Renewal_Status]                       NVARCHAR (31)   NULL,
    [Status]                               NVARCHAR (15)   NULL,
    [Status_Reason]                        NVARCHAR (15)   NULL,
    [Website_URL]                          NVARCHAR (2000) NULL,
    [AFLP_Agreement]                       NVARCHAR (3)    NULL,
    [Current_C2I]                          NVARCHAR (31)   NULL,
    CONSTRAINT [PK_TaLocationPersonalInformation] PRIMARY KEY CLUSTERED ([TLPI_Location_ID] ASC)
);

