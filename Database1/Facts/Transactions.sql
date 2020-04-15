﻿CREATE TABLE [dbo].[Transactions]
(
	[Id] INT NOT NULL PRIMARY KEY, 
    [Person1ID] INT NULL,
	[Person2ID] INT NULL,
	amount MONEY NOT NULL, 
    [statusId] INT NOT NULL,
	CONSTRAINT P1ID FOREIGN KEY (Person1ID) REFERENCES DimPerson(PersonID),
    CONSTRAINT P2ID FOREIGN KEY (Person2ID) REFERENCES DimPerson(PersonID), 
    CONSTRAINT [FK_Transactions_ToTable] FOREIGN KEY (StatusID) REFERENCES DimStatus(Id)
)
