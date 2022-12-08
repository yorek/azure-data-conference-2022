/*
	Cognitive Services - Anomaly Detection

	Azure SQL DB calling the Anomaly Detection Cognitive Service to detect anomalies in monthly data 
*/

-- select * from dbo.[datapoints]
-- go

declare @payload nvarchar(max);

set @payload = (
	select
		series = json_query((	
			select 
				sample_date as [timestamp],
				sample_value as [value]
			from 
				dbo.[datapoints] as series for json path
		)),
		[T].[maxAnomalyRatio],
		[T].[sensitivity],
		[T].[granularity]
	from
		(values (0.25, 95, 'monthly')) T (maxAnomalyRatio, [sensitivity], granularity)
	for
		json path, without_array_wrapper
);

--select @payload;

declare @url nvarchar(4000) = 'https://xyz.cognitiveservices.azure.com/anomalydetector/v1.0/timeseries/entire/detect';
declare @headers nvarchar(4000) = '{"Ocp-Apim-Subscription-Key":"..."}'
declare @ret int
declare @response nvarchar(max);

exec @ret = sp_invoke_external_rest_endpoint 
	@url = @url,
	@headers  = @headers,
	@payload = @payload,
	@response = @response output;
	
select @ret as ReturnCode, @response as [Response];
--select * from openjson(@response, '$.response');
--select * from openjson(@response, '$.result');

with 
	cte1 as (select [key], [value] from openjson(@response, '$.result.expectedValues'))
, 	cte2 as (select [key], [value] from openjson(@response, '$.result.isAnomaly'))
select
	d.id
,	d.sample_date
,	d.sample_value
,	cast(cte1.[key] as int) as [key]
,	cast(cte1.[value] as numeric(18,6)) [expectedValues]
,	cast(cte2.[value] as bit) as isAnomaly
from
	dbo.[datapoints] as d
inner join
	cte1 on [cte1].[key] = [d].[id] - 1
inner join 
	cte2 on [cte2].[key] = [cte1].[key]
order by
	[d].[id]
