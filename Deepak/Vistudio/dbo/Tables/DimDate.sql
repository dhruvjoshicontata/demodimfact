
Create table DimDate(
DateID nvarchar(15) not null primary key,
[Date] datetime not null,
[Day] int,
[Weekday] nvarchar(15),
[Week] int,
[Month] int,
[MonthName] nvarchar(15),
[Year] int
)