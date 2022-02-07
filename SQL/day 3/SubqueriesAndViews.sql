USE TrackIt
GO


--Using a subquery with the IN operator
--return the Workers that have a project
SELECT * FROM Worker;
--so we want only the Workers that have a record in the ProjectWorker table
SELECT DISTINCT WorkerId FROM ProjectWorker;

--we will use a subquery in the WHERE
SELECT 
	*
FROM 
	Worker
WHERE 
	WorkerId IN (SELECT WorkerId FROM ProjectWorker);


--Retrieve ProjectName and the first Task added to the project
--We can GROUP BY ProjectName and aggregate MIN(TaskId) to get the first task added
--But now we're stuck. How do we get the task title that matches the MIN TaskId?  
--This doesn't do what we want.
SELECT TaskId, Title FROM Task WHERE TaskId IN (108,78,133,457)
--This is not pulling out the right Title
SELECT
    p.[Name] ProjectName,
    MIN(t.TaskId) FirstTaskId,
	MIN(t.title) TaskTitle  
FROM 
	Project p
INNER JOIN 
	Task t 
ON 
	p.ProjectId = t.ProjectId
GROUP BY 
	p.ProjectId, 
	p.[Name];



--RUN these together
--so here is the Task table
SELECT 
	TaskId, Title 
FROM 
	Task
--and we need to join it with this result set
SELECT
	p.[Name] ProjectName,
    MIN(t.TaskId) MinTaskId
FROM 
	Project p
INNER JOIN 
	Task t 
ON 
	p.ProjectId = t.ProjectId
GROUP BY 
	p.ProjectId, 
	p.[Name]
ORDER BY 
	MIN(t.TaskId)
------------------------


--Now we have ProjectName and the first Task added to the project
--Use subquery to solve the problem. 
--We will join a sub-query to the Task table like it is another table 
SELECT
    subquery.ProjectName,
    subquery.FirstTaskId,
    t.Title FirstTaskTitle
FROM 
	Task t
INNER JOIN
	(SELECT
        p.[Name] ProjectName,
        MIN(t.TaskId) FirstTaskId
    FROM 
		Project p
    INNER JOIN 
		Task t 
	ON 
		p.ProjectId = t.ProjectId
    GROUP BY 
		p.ProjectId, p.[Name]) AS subquery 
ON 
	t.TaskId = subquery.FirstTaskId
ORDER BY 
	subquery.ProjectName;



--correlated subquery
--In effect, the subquery becomes the calculation.
--This query fetches workers and counts their assigned projects.
SELECT
    w.FirstName,
    w.LastName,
    (SELECT COUNT(*) 
	 FROM ProjectWorker 
	 WHERE WorkerId = w.WorkerId) AS ProjectCount  
FROM 
	Worker w
ORDER BY 
	w.LastName;

--WorkerId = w.WorkerId correlates the subquery of the ProjectWorker table 
--to the main query of the Worker table on the WorkerId column


--Our query that returns ProjectName and the first Task added to the project
--can use a correlated subquery instead of a joined subquery
SELECT
    p.[Name] ProjectName,
    MIN(t.TaskId) FirstTaskId,
    (SELECT Title 
	 FROM Task 
	 WHERE TaskId = MIN(t.TaskId)) AS FirstTaskTitle
FROM 
	Project p
INNER JOIN 
	Task t 
ON 
	p.ProjectId = t.ProjectId
GROUP BY 
	p.ProjectId, 
	p.[Name]
ORDER BY 
	ProjectName;


GO
--VIEWS
--A named query that is stored in the database
--NOTE:  CREATE statement must be in seperate batch- Use GO


--we can use a view to help us retrieve
--ProjectName and the first Task added to the project
--start by returning the Projectname and MIN(TaskId) as a view

CREATE VIEW ProjectNameWithFirstTaskId
AS
SELECT
    p.[Name] ProjectName,
    MIN(t.TaskId) FirstTaskId
FROM 
	Project p
INNER JOIN 
	Task t 
ON 
	p.ProjectId = t.ProjectId
GROUP BY 
	p.ProjectId, 
	p.[Name]
GO

--now we query the view like a table
--views hide complexity
SELECT 
	ProjectName,
	FirstTaskId
FROM 
	ProjectNameWithFirstTaskId
ORDER BY
	ProjectName


--we can even join with a view like a table and now 
--retrieve ProjectName and the first Task added to the project
SELECT
    pt.ProjectName,
    pt.FirstTaskId TaskId,
    t.Title
FROM 
	Task t
INNER JOIN 
	ProjectNameWithFirstTaskId pt 
ON 
	t.TaskId = pt.FirstTaskId;