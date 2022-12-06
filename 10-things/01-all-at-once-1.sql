-- DB: AzureDataConference

drop table if exists #demo1;
create table #demo1
(
    column_a int not null,
    column_b int not null
)
go

insert into #demo1 values
    (1, 2),
    (3, 4)
go

select * from #demo1;
go

update #demo1 set column_a = column_b, column_b = column_a;
go

select * from #demo1;
go