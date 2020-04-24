
Create Table MastFRMLocation(
[Location ID] nvarchar(100) not null primary key,
[Actual Opening] nvarchar(15) FOREIGN KEY REFERENCES dimdate(dateid),     --F Key
[BOE Verified] nvarchar(15) FOREIGN KEY REFERENCES dimdate(dateid),       --F Key
[Close Date] nvarchar(15) FOREIGN KEY REFERENCES dimdate(dateid),         --F Key
[Competition] nvarchar(500),
[E-mail Address] nvarchar(500),
[Exchange Rate] nvarchar(500),
[Existing Sales Rep] nvarchar(500),
[Express Location] nvarchar(500),
[Financing Type] int FOREIGN KEY REFERENCES dimfinancetype(financetypeid),					--F Key
[Lack of marketing] nvarchar(500),
[Landlord Issues] nvarchar(500),
[Legal Entity] nvarchar(7) FOREIGN KEY REFERENCES dimlegalentity(legalentityid),					--F Key
[Location Type] int FOREIGN KEY REFERENCES dimlocationtype(locationtypeid),					--F Key
[Market Type] int FOREIGN KEY REFERENCES dimmarkettype(markettypeid),					--F Key
[Multi-Purpose Room] nvarchar(500),
[No Operating Capital] nvarchar(500),
[No Sales Revenue] nvarchar(500),
[Online Signup] nvarchar(500),
[Open Status] int FOREIGN KEY REFERENCES dimopenstatus(openstatusid),					--F Key
[Open Temporary Pending Relo] nvarchar(500),
[Opened On] nvarchar(15) FOREIGN KEY REFERENCES dimdate(dateid),						--F Key
[Original Franchisee Open Date] nvarchar(15) FOREIGN KEY REFERENCES dimdate(dateid),  --F Key
[Other] nvarchar(500),
[Other Equipment] nvarchar(500),
[Other Operating System] int FOREIGN KEY REFERENCES dimotheroperatingsystem(otheroperatingsystemid),         --F Key
[Owner] nvarchar(7) FOREIGN KEY REFERENCES dimpersons(personid),							--F Key
[Partnership Dispute] nvarchar(500),
[Personal Issues] nvarchar(500),
[Personal Training] nvarchar(500),
[Primary Contact] nvarchar(7) FOREIGN KEY REFERENCES dimpersons(personid),				--F Key
[Principal Operator] nvarchar(7) FOREIGN KEY REFERENCES dimpersons(personid),				--F Key
[Principal Owner] nvarchar(7) FOREIGN KEY REFERENCES dimpersons(personid),				--F Key
[Sale Date] nvarchar(15) FOREIGN KEY REFERENCES dimdate(dateid),						--F Key
[Satellite Club] nvarchar(500),
[Site] nvarchar(500),
[Stage] int FOREIGN KEY REFERENCES dimstage(stageid),							--F Key
[Team Workouts] nvarchar(500),
[Veteran] nvarchar(500),
[Virtual Coaching] nvarchar(500),
[Waxing Account#] nvarchar(500),
[Website] nvarchar(500),
[Active CMS] int FOREIGN KEY REFERENCES dimactivecms(activecmsid),						--F Key
[AFLP Auto Checklist] nvarchar(500),
[AFLP In-club Training Lead] nvarchar(500),
[AFLP last Post-Launch Drip email sent] nvarchar(500),
[AFLP Marketing] nvarchar(500),
[AFLP Notes] nvarchar(500),
[Agreement Renewal Date] nvarchar(15) FOREIGN KEY REFERENCES dimdate(dateid),			--F Key
[Agreement Signed] nvarchar(15) FOREIGN KEY REFERENCES dimdate(dateid),				--F Key
[Billing Account Number] nvarchar(500),
[Brand] int FOREIGN KEY REFERENCES dimbrand(brandid),							--F Key
[Club OS] nvarchar(500),
[Club Ready] nvarchar(500),
[Company] nvarchar(7) FOREIGN KEY REFERENCES dimcompany(companyid),						--F Key
[Created On] nvarchar(15) FOREIGN KEY REFERENCES dimdate(dateid),						--F Key
[Currency] nvarchar(500),
[Location] nvarchar(7) FOREIGN KEY REFERENCES dimlocation(locationid),						--F Key
[Location #] nvarchar(500),
[Main Phone] nvarchar(500),
[Modified On] nvarchar(15) FOREIGN KEY REFERENCES dimdate(dateid),					--F Key
[Renewal Status] int FOREIGN KEY REFERENCES dimrenewalstatus(renewaLstatusid),					--F Key
[Status] int FOREIGN KEY REFERENCES dimstatus(statusid),							--F Key
[Status Reason] int FOREIGN KEY REFERENCES dimstatusreason(statusreasonid),					--F Key
[Time Zone] nvarchar(500),
[Website URL] nvarchar(500),
[AFLP Agreement] nvarchar(500),
[Current C2I]  nvarchar(7) FOREIGN KEY REFERENCES dimpersons(personid),						--F Key
[Differentiator] nvarchar(7) FOREIGN KEY REFERENCES dimDifferentiator(DifferentiatorID))					--F Key