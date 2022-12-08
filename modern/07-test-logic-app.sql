/*
	Logic App
*/

declare @payload nvarchar(max) = N'{"id":1, "firstname":"john👻", "lastname":"doe"}'
declare @url nvarchar(4000) = 'https://xyz.azurewebsites.net:443/api/Test/triggers/manual/invoke?api-version=2020-05-01-preview&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=...';
declare @ret int
declare @response nvarchar(max);

exec @ret = sp_invoke_external_rest_endpoint 
	@url = @url,
	@payload = @payload,
	@response = @response output;
	
select @ret as ReturnCode;
select * from openjson(@response);
go