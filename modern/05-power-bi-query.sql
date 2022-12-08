declare @url nvarchar(4000) = N'https://api.powerbi.com/v1.0/myorg/datasets/.../executeQueries';
declare @payload nvarchar(max) = N'{
  "queries": [
    {
      "query": "' + string_escape('
        DEFINE VAR __DS0Core = 
        SUMMARIZECOLUMNS(
            ROLLUPADDISSUBTOTAL(''District''[District], "IsGrandTotalRowTotal"),
            "This_Year_Sales", ''Sales''[This Year Sales]
        )

        EVALUATE
        __DS0Core

        ORDER BY
        [IsGrandTotalRowTotal] DESC, ''District''[District]
        ', 'json') + '"
    }
  ],
  "serializerSettings": {
    "includeNulls": true
  }
}'


--select @headers, @payload
declare @ret int, @response nvarchar(max);

exec @ret = sys.sp_invoke_external_rest_endpoint 
	@method = 'POST',
	@url = @url,
	@payload = @payload,
	@credential = [https://api.powerbi.com/v1.0/myorg/datasets/.../executeQueries],
	@response = @response output;

select @response;

select * from openjson(@response,  '$.result.results[0].tables[0].rows') with
  (
    [District[District]]] nvarchar(100),
    [[IsGrandTotalRowTotal]]] bit,
    [[This_Year_Sales]]] numeric(18,9)
  )


