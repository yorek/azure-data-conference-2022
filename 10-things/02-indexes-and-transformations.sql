-- DB: AzureDataConference

/*
create table [dbo].[timesheet]
(
	[id] [int] not null,
	[first_name] [nvarchar](50) not null,
	[last_name] [nvarchar](50) not null,
	[birthday] [date] not null,
	[project] [nvarchar](50) not null,
	[reported_on] [date] not null,
	[reported_year]  as (datepart(year,[reported_on])) persisted,
	[hours_worked] [int] not null,
	constraint [pk__timesheet] primary key nonclustered 
	(
		[id] asc
	)
)
go
*/

-- Explicit transformations / conversions

select * from dbo.timesheet
go

exec sp_helpindex 'dbo.timesheet'
go

exec sp_help 'dbo.timesheet'
go

create nonclustered index ixnc1 on dbo.timesheet(birthday)

select * from dbo.timesheet where datepart(month, birthday) = 4

select * from dbo.timesheet where birthday >= '2000-04-01' and birthday < '2000-05-01' 
-- Hint: always specify the date in the  ISO 8601 format yyyy-mm-dd
-- to avoid issues for different formats
-- https://learn.microsoft.com/sql/t-sql/data-types/datetime-transact-sql?view=sql-server-ver16#_datetime

drop index ixnc1 on dbo.timesheet

-- Implicit transformations / conversions

drop table if exists dbo.timesheet_test;
select * into dbo.timesheet_test from dbo.timesheet
go

alter table dbo.timesheet_test
alter column last_name varchar(100)
go

exec sp_helpindex 'dbo.timesheet_test'
go

exec sp_help 'dbo.timesheet_test'
go

create nonclustered index ixc1 on dbo.timesheet_test (last_name)
go

select * from dbo.timesheet_test where last_name = 'Hovert'
go

select * from dbo.timesheet_test where last_name = N'Hovert'
go

drop table dbo.timesheet_test
go


