drop database scoped credential [https://api.powerbi.com/v1.0/myorg/datasets/.../executeQueries]
go

create database scoped credential [https://api.powerbi.com/v1.0/myorg/datasets/.../executeQueries]
with identity = 'HTTPEndpointHeaders', secret = N'{"Authorization": "Bearer "}';
go
