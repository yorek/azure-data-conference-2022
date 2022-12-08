/*
	Call random number generator -- https://csrng.net/ -- https://csrng.net/csrng/csrng.php?min=0&max=100
*/
declare @url nvarchar(1000) = N'https://xyz.azure-api.net/random?min=0&max=100'
declare @response nvarchar(max) = null
declare @headers nvarchar(4000) = N'{"Ocp-Apim-Subscription-Key":"..."}'
declare @ret int
exec @ret = sp_invoke_external_rest_endpoint 
	@method='GET', 
	@headers=@headers, 
	@url=@url, 
	@response=@response OUTPUT
select @ret as ReturnCode;
select * from openjson(@response, '$.result[0]');
go

