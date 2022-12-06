
create   view dbo.project_per_year
as
select
    project,
    year(reported_on) as project_year,
    sum(hours_worked) as project_hours_per_year    
from
    dbo.timesheet
group by
    project, year(reported_on)

GO

