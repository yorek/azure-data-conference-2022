-- DB: AzureDataConference

-- Create JSON from a table

select 
	* 
from 
	dbo.timesheet 
where
	id between 100 and 110
for json auto
go

-- Turn JSON into a table

declare @json nvarchar(max) = '[{"firstName": "John", "lastName": "Doe", "age": 25},{"firstName": "Jane", "lastName": "Dean", "age": 27}]';
select * from openjson(@json) with (
	first_name nvarchar(50) '$.firstName',
	last_name nvarchar(50) '$.lastName',
	age int
)
go

-- New functions available in SQL Sever 2022 and Azure SQL

select json_array('a', 1, 'b', NULL) as [array]

select json_object('name':'davide', 'session_ids':json_array(12, 32)) as [object]
