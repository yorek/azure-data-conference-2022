if not exists(select * from sys.symmetric_keys where [name] = '##MS_DatabaseMasterKey##')
begin
    create master key encryption by password = 'LONg_Pa$$_w0rd!'
end
go

if not exists(select * from sys.database_scoped_credentials where [name] = 'https://xyz.servicebus.windows.net')
begin
    create database scoped credential [https://xyz.servicebus.windows.net]
    with identity = 'HTTPEndpointHeaders', 
    secret = '{"Authorization": "SharedAccessSignature ..."}';
end
go

declare @Id uniqueidentifier = newid();
declare @payload nvarchar(max) = (
	select 
        * 
    from 
        (values (@Id, 'John', 'Doe', 'Hello world from Las Vegas!')) as UserTable(UserId, FirstName, LastName, [Message]) 
    for json auto, without_array_wrapper
)
declare @url nvarchar(4000) = 'https://xyz.servicebus.windows.net/from-sql/messages';
declare @headers nvarchar(4000) = N'{"BrokerProperties": "'+ string_escape('{"PartitionKey": "' + cast(@Id as nvarchar(36))+ '"}', 'json') +'"}'
declare @ret int, @response nvarchar(max)

exec @ret = sp_invoke_external_rest_endpoint 
        @url = @url,
        @headers = @headers,
        @payload = @payload,
		@credential = [https://dm-test.servicebus.windows.net],
        @response = @response output;

select @response;

