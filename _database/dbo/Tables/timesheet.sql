CREATE TABLE [dbo].[timesheet] (
    [id]            INT           NOT NULL,
    [first_name]    NVARCHAR (50) NOT NULL,
    [last_name]     NVARCHAR (50) NOT NULL,
    [birthday]      DATE          NOT NULL,
    [project]       NVARCHAR (50) NOT NULL,
    [reported_on]   DATE          NOT NULL,
    [reported_year] AS            (datepart(year,[reported_on])) PERSISTED,
    [hours_worked]  INT           NOT NULL,
    CONSTRAINT [pk__timesheet] PRIMARY KEY NONCLUSTERED ([id] ASC)
);


GO

CREATE CLUSTERED INDEX [ixc]
    ON [dbo].[timesheet]([project] ASC, [reported_on] ASC);


GO

