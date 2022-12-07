--drop user azure_data_conf_user;
--go
create user azure_data_conf_user with password = 'iods1d-HJK2s.12d9MNG';
go
alter role db_owner add member azure_data_conf_user
go

drop table if exists dbo.todos;
create table dbo.todos
(
    [id] uniqueidentifier not null primary key nonclustered default(newid()),
    [order] int null,
    [title] nvarchar(1000) not null,
    [url]  nvarchar(1000) not null,
    [completed] bit not null default(0)
)
go

select * from sys.change_tracking_databases
go

alter database lab
set change_tracking = on
(change_retention = 2 days, auto_cleanup = on);
go

select object_name(object_id), * from sys.change_tracking_tables
go

alter table dbo.todos
enable change_tracking;
go

select * from sys.schemas
go

select * from sys.objects where schema_id = schema_id('az_func') and type = 'U'
go

select * from az_func.GlobalState
go

select * from az_func.Leases_9a3bc680173d0ce6_1490820373
go


insert into dbo.todos 
    (title, [url], completed)
values
    ('My first todo', 'http://localhost/todo/1', 0)
go


insert into dbo.todos 
    (title, [url], completed)
values
    ('Another one', 'http://todo/', 0),
    ('And even more!', 'http://todo/', 1)
go

select * from dbo.todos
go

update dbo.todos set [order] = 1, url = 'http://todo/4ff0b801-cdfd-45ff-a44b-823f87a58f96' where id = '4ff0b801-cdfd-45ff-a44b-823f87a58f96'
go

begin tran
delete from dbo.todos where [order] is null

commit tran


