-- DB: AzureDataConference

drop table if exists dbo.timesheet_test
select * into dbo.timesheet_test from dbo.timesheet
go

select * from dbo.timesheet_test where id = 6

declare @n int = 0;
begin tran

	delete from dbo.timesheet_test where id = 6

	select 1 / @n;

commit tran

select @@trancount
select * from dbo.timesheet_test where id = 6
go

-----

drop table if exists dbo.timesheet_test
select * into dbo.timesheet_test from dbo.timesheet
go

create or alter procedure dbo.stp_test_error
as
begin
	declare @n int = 0;
	begin tran

		delete from dbo.timesheet_test where id = 6;

		select 1 / @n;

	commit tran
end
go

exec dbo.stp_test_error
go

select @@trancount
select * from dbo.timesheet_test where id = 6
go

-----

drop table if exists dbo.timesheet_test
select * into dbo.timesheet_test from dbo.timesheet
go

create or alter procedure dbo.stp_test_error
as
begin
	set xact_abort on;
	declare @n int = 0;
	begin tran

		delete from dbo.timesheet_test where id = 6;

		select 1 / @n;

	commit tran
end
go

exec dbo.stp_test_error
go

select @@trancount
select * from dbo.timesheet_test where id = 6
go


-----

drop table if exists dbo.timesheet_test
select * into dbo.timesheet_test from dbo.timesheet
go

create or alter procedure dbo.stp_test_error
as
begin	
	declare @n int = 0;
	begin try
		begin tran
		delete from dbo.timesheet_test where id = 6;

		select 1 / @n;

		commit tran
	end try
	begin catch
		rollback
	end catch
end
go

exec dbo.stp_test_error
go

select @@trancount
select * from dbo.timesheet_test where id = 6
go

