
Create table DimLocation(
LocationID nvarchar(7) not null primary key,
Location nvarchar(63),
City nvarchar(31),
State nvarchar(7),
Country nvarchar(3),
[ZIP Postal Code] nvarchar(15),
Latitude nvarchar(31),
Longitude nvarchar(31)
)