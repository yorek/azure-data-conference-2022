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

select * from dbo.timesheet
go

exec sp_helpindex 'dbo.timesheet'
go

exec sp_help 'dbo.timesheet'
go

create nonclustered index ixnc1 on dbo.timesheet(birthday)

select * from dbo.timesheet where datepart(month, birthday) = 8

select * from dbo.timesheet where datepart(year, birthday) = 2000

-----

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

select * from dbo.timesheet_test where last_name = 'Something'
go

select * from dbo.timesheet_test where last_name = N'Something'
go

drop table dbo.timesheet_test
go


