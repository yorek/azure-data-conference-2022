create   view dbo.project_totals
as
select
    project,
    reported_year,
    sum(hours_worked) as hours_worked
from
    dbo.timesheet
group by
    reported_year,
    project

GO

