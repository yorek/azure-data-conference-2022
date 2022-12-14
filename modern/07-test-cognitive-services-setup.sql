/*
  Sample from https://docs.microsoft.com/en-us/azure/cognitive-services/anomaly-detector/quickstarts/client-libraries?pivots=rest-api&tabs=linux
*/
declare @s nvarchar(max) = N'{ 
  "series": [
  {
    "timestamp": "1972-01-01T00:00:00Z",
    "value": 826
  },
  {
    "timestamp": "1972-02-01T00:00:00Z",
    "value": 799
  },
  {
    "timestamp": "1972-03-01T00:00:00Z",
    "value": 890
  },
  {
    "timestamp": "1972-04-01T00:00:00Z",
    "value": 900
  },
  {
    "timestamp": "1972-05-01T00:00:00Z",
    "value": 961
  },
  {
    "timestamp": "1972-06-01T00:00:00Z",
    "value": 935
  },
  {
    "timestamp": "1972-07-01T00:00:00Z",
    "value": 894
  },
  {
    "timestamp": "1972-08-01T00:00:00Z",
    "value": 855
  },
  {
    "timestamp": "1972-09-01T00:00:00Z",
    "value": 809
  },
  {
    "timestamp": "1972-10-01T00:00:00Z",
    "value": 810
  },
  {
    "timestamp": "1972-11-01T00:00:00Z",
    "value": 766
  },
  {
    "timestamp": "1972-12-01T00:00:00Z",
    "value": 805
  },
  {
    "timestamp": "1973-01-01T00:00:00Z",
    "value": 821
  },
  {
    "timestamp": "1973-02-01T00:00:00Z",
    "value": 773
  },
  {
    "timestamp": "1973-03-01T00:00:00Z",
    "value": 883
  },
  {
    "timestamp": "1973-04-01T00:00:00Z",
    "value": 898
  },
  {
    "timestamp": "1973-05-01T00:00:00Z",
    "value": 957
  },
  {
    "timestamp": "1973-06-01T00:00:00Z",
    "value": 924
  },
  {
    "timestamp": "1973-07-01T00:00:00Z",
    "value": 881
  },
  {
    "timestamp": "1973-08-01T00:00:00Z",
    "value": 837
  },
  {
    "timestamp": "1973-09-01T00:00:00Z",
    "value": 784
  },
  {
    "timestamp": "1973-10-01T00:00:00Z",
    "value": 791
  },
  {
    "timestamp": "1973-11-01T00:00:00Z",
    "value": 760
  },
  {
    "timestamp": "1973-12-01T00:00:00Z",
    "value": 802
  },
  {
    "timestamp": "1974-01-01T00:00:00Z",
    "value": 828
  },
  {
    "timestamp": "1974-02-01T00:00:00Z",
    "value": 1030
  },
  {
    "timestamp": "1974-03-01T00:00:00Z",
    "value": 889
  },
  {
    "timestamp": "1974-04-01T00:00:00Z",
    "value": 902
  },
  {
    "timestamp": "1974-05-01T00:00:00Z",
    "value": 969
  },
  {
    "timestamp": "1974-06-01T00:00:00Z",
    "value": 947
  },
  {
    "timestamp": "1974-07-01T00:00:00Z",
    "value": 908
  },
  {
    "timestamp": "1974-08-01T00:00:00Z",
    "value": 867
  },
  {
    "timestamp": "1974-09-01T00:00:00Z",
    "value": 815
  },
  {
    "timestamp": "1974-10-01T00:00:00Z",
    "value": 812
  },
  {
    "timestamp": "1974-11-01T00:00:00Z",
    "value": 773
  },
  {
    "timestamp": "1974-12-01T00:00:00Z",
    "value": 813
  },
  {
    "timestamp": "1975-01-01T00:00:00Z",
    "value": 834
  },
  {
    "timestamp": "1975-02-01T00:00:00Z",
    "value": 782
  },
  {
    "timestamp": "1975-03-01T00:00:00Z",
    "value": 892
  },
  {
    "timestamp": "1975-04-01T00:00:00Z",
    "value": 903
  },
  {
    "timestamp": "1975-05-01T00:00:00Z",
    "value": 966
  },
  {
    "timestamp": "1975-06-01T00:00:00Z",
    "value": 937
  },
  {
    "timestamp": "1975-07-01T00:00:00Z",
    "value": 896
  },
  {
    "timestamp": "1975-08-01T00:00:00Z",
    "value": 858
  },
  {
    "timestamp": "1975-09-01T00:00:00Z",
    "value": 817
  },
  {
    "timestamp": "1975-10-01T00:00:00Z",
    "value": 827
  },
  {
    "timestamp": "1975-11-01T00:00:00Z",
    "value": 797
  },
  {
    "timestamp": "1975-12-01T00:00:00Z",
    "value": 843
  }
  ],
 "maxAnomalyRatio": 0.25,
 "sensitivity": 95,
 "granularity": "monthly"
}';

drop table if exists dbo.datapoints;
create table dbo.datapoints 
(
	id int not null identity primary key nonclustered,
	sample_date datetime2 not null,
	sample_value numeric(18,3) not null
)	
;

insert into 
	dbo.datapoints ([sample_date], [sample_value])
select 
	sample_date,
	sample_value
from openjson(@s, '$.series') with 
	(
		[sample_date] datetime2 '$.timestamp',
		[sample_value] numeric(18,3) '$.value'
	)
;

update [dbo].[datapoints] set [sample_date] = dateadd(year, 46, [sample_date]);

select * from dbo.[datapoints]
