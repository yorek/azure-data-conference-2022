
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

alter database AzureDataConference
set change_tracking = on
(change_retention = 2 days, auto_cleanup = on);
go

select object_name(object_id), * from sys.change_tracking_tables
go

alter table dbo.todos
enable change_tracking;
go

-- Now execute the Azure Function

select * from sys.schemas
go

select * from sys.objects where schema_id = schema_id('az_func') and type = 'U'
go

select * from az_func.GlobalState
go

select * from az_func.Leases_d7dbe9175bb7188b_274100017
go


insert into dbo.todos 
    (id, title, [url], completed)
values
    ('f2203402-095e-4a91-b33c-f48c9d317859', 'My first todo', '/todo/0c1982b4-2223-48be-abce-de4161af92a3', 0)
go

insert into dbo.todos 
    (id, title, [url], completed)
values
    ('c20728e1-8287-4080-8980-f49ba38f6665', 'Another one', '/todo/c20728e1-8287-4080-8980-f49ba38f6665', 0),
    ('67ff211e-bfe5-4c2a-8070-415971bc0d30', 'And even more!', '/todo/67ff211e-bfe5-4c2a-8070-415971bc0d30', 1)
go

select * from dbo.todos
go

update dbo.todos set [order] = 1 where id = 'f2203402-095e-4a91-b33c-f48c9d317859'
go

begin tran

delete from dbo.todos where [order] is null

commit tran


