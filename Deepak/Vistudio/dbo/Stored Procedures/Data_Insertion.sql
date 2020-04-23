

Create procedure Data_Insertion as
Begin

Insert Into DimLocation(LocationID,Location,City,State,Country,[ZIP Postal Code],Latitude,Longitude)
select left (NEWID(),7) LocationID,* from(
select distinct Location,City,State,Left(country,3) Country,[ZIP Postal Code],cast(Latitude as nvarchar)Latitude,cast(Longitude as nvarchar)Longitude from FRMLOCATIO 
)Location

Insert Into Country(Country_ID,Country)
select distinct Left(country,3),Country from FRMLOCATIO where Country<>'' 

declare @StartDate datetime,@Enddate datetime
set @StartDate='01-01-1990'
set @Enddate='12-31-2030'
while @StartDate<=@Enddate
begin
insert into DimDate (DateID,[Date],[Day],[Weekday],[Week],[Month],[MonthName],[Year])
select cast(replace(convert(varchar,@StartDate,102),'.','') as nvarchar)ID,
@StartDate [Date],
day(@StartDate)[Day],
datename(weekday,@startdate)[Weekday],
datepart(week,@startdate)[Week],
month(@StartDate)[Month],
datename(month,@StartDate)[MonthName],
year(@StartDate)[Year] order by [Date]
set @StartDate=dateadd(day,1,@StartDate)
--print @startdate
end

insert into DimPersons
select left(newid(),6) Person_ID,Person from (
select distinct Owner person from FRMLOCATIO  
union
select distinct [Primary Contact] from FRMLOCATIO  
union
select distinct [Principal Operator] from FRMLOCATIO  
union
select distinct [Principal Owner] from FRMLOCATIO  
union
select distinct [Current C2I] from FRMLOCATIO 
)Person where person<>''

insert into DimFinanceType(FinanceType)
select distinct [Financing Type] from frmlocatio where [Financing Type]<>'' and [Financing Type] is not null

insert into DimLegalEntity(LegalEntityID,LegalEntity)
select left(newid(),7) legalentityid, legalentity from(
select distinct [Legal Entity] legalentity from frmlocatio where [Legal Entity]<>'' and [Legal Entity] is not null
)legalentity

insert into DimLocationType(LocationType)
select distinct [Location Type] LocationType from frmlocatio where [Location Type]<>''  and [Location Type] is not null

insert into DimOpenStatus(OpenStatus)
select distinct [Open Status] OpenStatus from frmlocatio where [Open Status]<>'' and [Open Status] is not null

insert into DimMarketType(MarketType)
select distinct [Market Type] MarketType from frmlocatio where [Market Type]<>'' and [Market Type] is not null

insert into DimOtherOperatingSystem(OtherOperatingSystem)
select distinct [Other Operating System] OtherOperatingSystem from frmlocatio where [Other Operating System]<>'' and [Other Operating System] is not null

insert into DimStage(Stage)
select distinct Stage Stage from frmlocatio where Stage<>'' and stage is not null

insert into DimActiveCMS(ActiveCMS)
select distinct [Active CMS] ActiveCMS from frmlocatio where [Active CMS]<>'' and [Active CMS] is not null

insert into DimBrand(Brand)
select distinct Brand Brand from frmlocatio where Brand<>'' and brand is not null

insert into DimCompany(CompanyID,Company)
select left(newid(),7) Companyid, Company from(
select distinct Company Company from frmlocatio where Company<>'' and company is not null
)Company

insert into DimRenewalStatus(RenewalStatus)
select distinct [Renewal Status] RenewalStatus from frmlocatio where [Renewal Status]<>'' and [Renewal Status] is not null

insert into DimStatus(Status)
select distinct Status Status from frmlocatio where Status<>'' and status is not null

insert into DimStatusReason(StatusReason)
select distinct [Status Reason] StatusReason from frmlocatio where [Status Reason]<>'' and [Status Reason] is not null

insert into DimDifferentiator(DifferentiatorID,Differentiator)
select left(newid(),7) Differentiatorid, Differentiator from(
select distinct Differentiator Differentiator from frmlocatio where Differentiator<>'' and Differentiator is not null
)Differentiator

insert into tranFRMLOCATION ([Location ID],[1 mile pop],[3 mile pop],[5 mile pop],[AverageTerm],[Avg  monthly gross personal training revenue],[Gross Rent],[Hours of Operation],[Median income > $50000],[Members  Dues and PIF],[Monthly Fee Amt],[Multi-Purpose Sq Ft],[Number of Rooms],[Payroll],[Percent Owner 1],[Percent Owner 2],[Percent Owner 3],[Percent Owner 4],[Percent Owner 5],[Percent Owner 6],[Person  Training Revenue],[Personal Training Revenue],[Problem %],[Profit Loss],[Remit Amount Last Quarter],[Remit Amount Quarter Change],[Territory],[Total Contracts],[Transfer Fee],[Utilities],[Average Contract Value],[Average Member Value],[BOE],[Draft %],[Dues],[Exited Agreements],[Monthly Attrition],[NEW Agreements],[PIF %],[Remit Amount],[Renewal Fee],[Rolling 12 Month Attrition],[Sq Ft],[Total Rent])
select [Location ID],[1 mile pop] ,[3 mile pop] ,[5 mile pop] ,[AverageTerm] ,[Avg  monthly gross personal training revenue] ,[Gross Rent] ,[Hours of Operation] ,[Median income > $50000] ,[Members  Dues and PIF] ,[Monthly Fee Amt] ,[Multi-Purpose Sq Ft] ,[Number of Rooms] ,[Payroll] ,[Percent Owner 1] ,[Percent Owner 2] ,[Percent Owner 3] ,[Percent Owner 4] ,[Percent Owner 5] ,[Percent Owner 6] ,[Person  Training Revenue] ,[Personal Training Revenue] ,[Problem %] ,[Profit Loss] ,[Remit Amount Last Quarter] ,[Remit Amount Quarter Change] ,[Territory] ,[Total Contracts] ,[Transfer Fee] ,[Utilities] ,[Average Contract Value] ,[Average Member Value] ,[BOE] ,[Draft %] ,[Dues] ,[Exited Agreements] ,[Monthly Attrition] ,[NEW Agreements] ,[PIF %] ,[Remit Amount] ,[Renewal Fee] ,[Rolling 12 Month Attrition],[Sq Ft],[Total Rent] from FRMLOCATIO 



insert into MastFRMLocation([Location ID],[Actual Opening],[BOE Verified],[Close Date],[Competition],[E-mail Address],[Exchange Rate],[Existing Sales Rep],[Express Location],[Financing Type],[Lack of marketing],[Landlord Issues],[Legal Entity],[Location Type],[Market Type],[Multi-Purpose Room],[No Operating Capital],[No Sales Revenue],[Online Signup],[Open Status],[Open Temporary Pending Relo],[Opened On],[Original Franchisee Open Date],[Other],[Other Equipment],[Other Operating System],[Owner],[Partnership Dispute],[Personal Issues],[Personal Training],[Primary Contact],[Principal Operator],[Principal Owner],[Sale Date],[Satellite Club],[Site],[Stage],[Team Workouts],[Veteran],[Virtual Coaching],[Waxing Account#],[Website],[Active CMS],[AFLP Auto Checklist],[AFLP In-club Training Lead],[AFLP last Post-Launch Drip email sent],[AFLP Marketing],[AFLP Notes],[Agreement Renewal Date],[Agreement Signed],[Billing Account Number],[Brand],[Club OS],[Club Ready],[Company],[Created On],[Currency],[Location],[Location #],[Main Phone],[Modified On],[Renewal Status],[Status],[Status Reason],[Time Zone],[Website URL],[AFLP Agreement],[Current C2I],[Differentiator])
select [Location ID],
(select DateID from DimDate where DateID=left(replace(isnull([Actual Opening],''),'-',''),8))[Actual Opening],
(select DateID from DimDate where DateID=left(replace(isnull([BOE Verified],''),'-',''),8))[BOE Verified],
(select DateID from DimDate where DateID=left(replace(isnull([Close Date],''),'-',''),8))[Close Date],
[Competition],
[E-mail Address],
[Exchange Rate],
[Existing Sales Rep],
[Express Location],
(select FinanceTypeID from DimFinanceType where FinanceType=isnull([Financing Type],''))[Financing Type],
[Lack of marketing],
[Landlord Issues],
(select LegalEntityID from DimLegalEntity where LegalEntity=isnull([Legal Entity],''))[Legal Entity],
(select LocationTypeID from DimLocationType where LocationType=isnull([Location Type],''))[Location Type],
(select MarketTypeID from DimMarketType where marketType=isnull([Market Type],''))[Market Type],
[Multi-Purpose Room],
[No Operating Capital],
[No Sales Revenue],
[Online Signup],
(select OpenStatusID from DimOpenStatus where OpenStatus=isnull([Open Status],''))[Open Status],
[Open Temporary Pending Relo],
(select DateID from DimDate where DateID=left(replace(isnull([Opened On],''),'-',''),8))[Opened On],
(select DateID from DimDate where DateID=left(replace(isnull([Original Franchisee Open Date],''),'-',''),8))[Original Franchisee Open Date],
[Other],
[Other Equipment],
(select OtherOperatingSystemID from DimOtherOperatingSystem where OtherOperatingSystem=isnull([Other Operating System],''))[Other Operating System],
(select PersonID from DimPersons where Person=Owner)[Owner],
[Partnership Dispute],
[Personal Issues],
[Personal Training],
(select PersonID from DimPersons where Person=isnull([Primary Contact],''))[Primary Contact],
(select PersonID from DimPersons where Person=isnull([Principal Operator],''))[Principal Operator],
(select PersonID from DimPersons where Person=isnull([Principal Owner],''))[Principal Owner],
(select DateID from DimDate where DateID=left(replace(isnull([Sale Date],''),'-',''),8))[Sale Date],
[Satellite Club],
[Site],
(select StageID from DimStage where Stage=isnull(FRMLOCATIO.[Stage],''))[Stage],
[Team Workouts],
[Veteran],
[Virtual Coaching],
[Waxing Account#],
[Website],
(select ActiveCMSID from DimActiveCMS where ActiveCMS=isnull([Active CMS],''))[Active CMS],
[AFLP Auto Checklist],
[AFLP In-club Training Lead],
[AFLP last Post-Launch Drip email sent],
[AFLP Marketing],
[AFLP Notes],
(select DateID from DimDate where DateID=left(replace(isnull([Agreement Renewal Date],''),'-',''),8))[Agreement Renewal Date],
(select DateID from DimDate where DateID=left(replace(isnull([Agreement Signed],''),'-',''),8))[Agreement Signed],
[Billing Account Number],
(select BrandID from DimBrand where Brand=isnull(FRMLOCATIO.[Brand],''))[Brand],
[Club OS],
[Club Ready],
(select CompanyID from DimCompany where company=isnull(FRMLOCATIO.Company,''))[Company],
(select DateID from DimDate where DateID=left(replace(isnull([Created On],''),'-',''),8))[Created On],
[Currency],
(select LocationID from DimLocation where Location=FRMLOCATIO.Location and city=FRMLOCATIO.city and state=FRMLOCATIO.state and left(country,3)=FRMLOCATIO.country and [ZIP Postal Code]=FRMLOCATIO.[ZIP Postal Code] and Latitude=FRMLOCATIO.Latitude	and Longitude=FRMLOCATIO.Longitude)[Location],
[Location #],
[Main Phone],
(select DateID from DimDate where DateID=left(replace(isnull([Modified On],''),'-',''),8))[Modified On],
(select RenewalStatusID from DimRenewalStatus where RenewalStatus=isnull([Renewal Status],''))[Renewal Status],
(select StatusID from DimStatus where Status=isnull(FRMLOCATIO.[Status],''))[Status],
(select StatusReasonID from DimStatusReason where StatusReason=isnull([Status Reason],''))[Status Reason],
[Time Zone],
[Website URL],
[AFLP Agreement],
(select PersonID from DimPersons where Person=isnull([Current C2I],''))[Current C2I],
(select DifferentiatorID from DimDifferentiator where Differentiator=isnull(FRMLOCATIO.[Differentiator],''))[Differentiator] from FRMLOCATIO


End
