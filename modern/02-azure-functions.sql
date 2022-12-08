-- NOTE: Replace "xyz.azurewebsites.net/api/something"
-- with the address of an HTTP REST endpoint you created and that returns JSON payload
-- Super basic

declare @ret int
declare @response nvarchar(max);

exec @ret = sp_invoke_external_rest_endpoint 
	@url = N'https://xyz.azurewebsites.net/api/something',
	@headers = N'{"header1":"value1", "header2":"value2", "header1":"another1", "dummy": 2.4}',
	@payload = N'{"id":1, "firstname":"john👻", "lastname":"doe", "dummy": 1.3}',
	@response = @response output;
	
select @ret as ReturnCode, @response as Response;
go


-- Easy and Simple

declare @payload nvarchar(max) = N'{"id":1, "firstname":"john👻", "lastname":"doe", "dummy": 1.3}'
declare @url nvarchar(4000) = N'https://xyz.azurewebsites.net/api/something';
declare @headers nvarchar(4000) = N'{"header1":"value1", "header2":"value2", "header1":"another1", "dummy": 1.3}'
declare @ret int
declare @response nvarchar(max);

exec @ret = sp_invoke_external_rest_endpoint 
	@url = @url,
	@headers = @headers,
	@payload = @payload,
	@response = @response output;
	
select @ret as ReturnCode, @response as Response;
go

-- Query a GraphQL service

if not exists(select * from sys.symmetric_keys where [name] = '##MS_DatabaseMasterKey##') begin
    create master key encryption by password = 'LONg_Pa$$_w0rd!'
end
go

if exists(select * from sys.database_scoped_credentials where [name] = 'https://xyz.azurewebsites.net/api/graphql')
begin
	drop database scoped credential [https://xyz.azurewebsites.net/api/graphql];
end
go

create database scoped credential [https://xyz.azurewebsites.net/api/graphql]
with identity = 'HTTPEndpointHeaders', secret = '{"Authorization":"Bearer ..."}';
go

declare @graphql nvarchar(max) = N'{
	search(term:"thai", location:"Las Vegas", limit:5)
	{
		business {
			name
			rating
			location {
				address1
			}
		}
	}
}'

declare @payload as nvarchar(max) = N'{"query":"' + string_escape(@graphql,'json') + '"}'
declare @url nvarchar(4000) = N'xyz.azurewebsites.net/api/graphql';
declare @ret int
declare @response nvarchar(max);

exec @ret = sp_invoke_external_rest_endpoint 
	@url = @url,
	@credential = [https://dm-reviews.azurewebsites.net],
	@payload = @payload,
	@response = @response output;
	
select @ret as ReturnCode, @response as Response;
select * from openjson(@response, '$.result.data.search.business') with (
	[name] nvarchar(100),
	[rating] decimal(6,3),
	[location] nvarchar(max) as json
) 
order by rating desc;
go

-- SignalR 

declare @payload nvarchar(max) = json_object('target':'order','data':json_object('label':'July', 'data':50))
declare @url nvarchar(4000) = N'https://xyz.azurestaticapps.net/api/broadcast';
declare @ret int
declare @response nvarchar(max);

exec @ret = sp_invoke_external_rest_endpoint 
	@url = @url,
	@payload = @payload,
	@response = @response output;
	
select @ret as ReturnCode, @response as Response;
go
