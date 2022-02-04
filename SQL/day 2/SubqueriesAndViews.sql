USE TrackIt
GO


--Using a subquery with the IN operator
--return the Workers that have a project
SELECT * FROM Worker;
--so we want only the Workers that have a record in the ProjectWorker table
SELECT DISTINCT WorkerId FROM ProjectWorker;

--we will use a subquery in the WHERE
SELECT *
FROM Worker
WHERE WorkerId IN (
    SELECT WorkerId 
	FROM ProjectWorker
);


--we want both a project and the first task added to it. 
--We can GROUP BY ProjectId and SELECT MIN(TaskId). That identifies the first task added, 
--but then we're stuck. There's no way to fetch the first task's fields. 
-- This doesn't do what we want.
SELECT
    p.Name ProjectName,
    MIN(t.TaskId) MinTaskId
    -- t.Title is what we want, but the SQL Engine 
    -- doesn't know which Task we're talking about!
    -- t.Title is not part of a group and there's 
    -- no aggregate guaranteed to grab the Title from the MinTaskId.
FROM 
	Project p
INNER JOIN 
	Task t 
ON p.ProjectId = t.ProjectId
GROUP BY 
	p.ProjectId, p.Name;


--so here is the Task table
SELECT TaskId, Title FROM Task

--and we need to join it with this result set
SELECT
	p.Name ProjectName,
    MIN(t.TaskId) MinTaskId
FROM 
	Project p
INNER JOIN 
	Task t 
ON p.ProjectId = t.ProjectId
GROUP BY 
	p.ProjectId, 
	p.Name


--A subquery solves the problem.
--we will join the result set of the subquery to
--Task like it is another table
--Create table #temp


SELECT
    g.ProjectName,
    g.MinTaskId,
    t.Title MinTaskTitle
FROM 
	Task t
INNER JOIN
	(SELECT
        p.Name ProjectName,
        MIN(t.TaskId) MinTaskId
    FROM Project p
    INNER JOIN Task t ON p.ProjectId = t.ProjectId
    GROUP BY p.ProjectId, p.Name) g 
ON t.TaskId = g.MinTaskId;



--Any field or calculated value can be replaced by a subquery. 
--In effect, the subquery becomes the calculation.
--This query fetches workers and counts their assigned projects.
SELECT
    w.FirstName,
    w.LastName,
    (SELECT COUNT(*) FROM ProjectWorker 
		WHERE WorkerId = w.WorkerId) ProjectCount  
FROM 
	Worker w;

--WorkerId = w.WorkerId correlates the subquery to the main query

--We could even solve our project/min task problem another way.
SELECT
    p.Name ProjectName,
    MIN(t.TaskId) MinTaskId,
    (SELECT Title FROM Task 
		WHERE TaskId = MIN(t.TaskId)) MinTaskTitle
FROM 
	Project p
INNER JOIN 
	Task t 
ON p.ProjectId = t.ProjectId
GROUP BY 
	p.ProjectId, 
	p.Name;


--VIEWS
--A named query that is stored in the database
GO
CREATE VIEW ProjectNameWithMinTaskId
AS
SELECT
    p.Name ProjectName,
    MIN(t.TaskId) MinTaskId
FROM 
	Project p
INNER JOIN 
	Task t 
ON p.ProjectId = t.ProjectId
GROUP BY 
	p.ProjectId, 
	p.Name;
GO

--now we query the view like a table
--views hide complexity
SELECT * FROM ProjectNameWithMinTaskId


--we can even join with a view like a table
SELECT
    pt.ProjectName,
    pt.MinTaskId TaskId,
    t.Title
FROM 
	Task t
INNER JOIN 
	ProjectNameWithMinTaskId pt 
ON t.TaskId = pt.MinTaskId;