-- DB: AzureDataConference

select * from dbo.timesheet
go


with cte as
(
	select
		project,
		year(reported_on) as project_year,
		sum(hours_worked) as project_hours_per_year    
	from
		dbo.timesheet
	group by
		project, year(reported_on)
)
select
    *,
    lag(project_hours_per_year) over (partition by project order by project_year) as project_prev_year
from
    dbo.project_per_year
-- where	
--     project = 'Bravo'
go

select count(*) from dbo.timesheet where project = 'Bravo'
go

-- Should you *always* use a CTE?
-- Keep in mind that
-- 1) data distribution may be really skewed
-- 2) query optimizer works with statistics, which have inherent errors 
--    that accumulate if there are many CTEs
-- try using a temp table (materializing the intermediate result) 
-- to check if it give better performances