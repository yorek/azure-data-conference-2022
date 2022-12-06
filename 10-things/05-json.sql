-- DB: AzureDataConference

select 
	* 
from 
	dbo.timesheet 
where
	id between 100 and 110
for json auto
go


-- 

declare @json nvarchar(max) = '[{"firstName": "John", "lastName": "Doe", "age": 25},{"firstName": "Jane", "lastName": "Dean", "age": 27}]';
select * from openjson(@json) with (
	first_name nvarchar(50) '$.firstName',
	last_name nvarchar(50) '$.lastName',
	age int
)
go

-- 

select json_array('a', 1, 'b', NULL) as [array]

select json_object('name':'davide', 'session_ids':json_object(12, 32)) as [object]
