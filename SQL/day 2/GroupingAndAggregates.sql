USE TrackIt
GO

--COUNT()

--we want to count how many rows are in this table
SELECT * FROM Task;

-- Count TaskIds, 543 values
SELECT COUNT(TaskId)
FROM Task;

-- Count everything  *, 543 values
SELECT COUNT(*)
FROM Task;

--let's count how any Tasks have a ParentTask - 416
SELECT COUNT(ParentTaskId)
FROM Task;

--counting resolved tasks  -  276
SELECT
    COUNT(t.TaskId)
FROM 
	Task t
INNER JOIN 
	TaskStatus s 
ON t.TaskStatusId = s.TaskStatusId
WHERE 
	s.IsResolved = 1;



--More aggregates, returns scalar value
SELECT
	MIN(EstimatedHours) MinEstHours,
	MAX(EstimatedHours) MaxEstHours,
	AVG(EstimatedHours) AvgEstHours,
	SUM(EstimatedHours) SumEstHours
FROM
	Task;


--what if I want the Max, Min and Avg of each ProjectId?
--let's group by Projectid
SELECT
	ProjectId,
	MIN(EstimatedHours) MinEstHours,
	MAX(EstimatedHours) MaxEstHours,
	AVG(EstimatedHours) AvgEstHours,
	SUM(EstimatedHours) SumEstHours
FROM
	Task
GROUP BY 
	ProjectId
ORDER BY
	ProjectId;

--what if I want to see the DueDate too
SELECT
	ProjectId,
	DueDate,
	MIN(EstimatedHours) MinEstHours,
	MAX(EstimatedHours) MaxEstHours,
	AVG(EstimatedHours) AvgEstHours
FROM
	Task
GROUP BY 
	ProjectId
	,DueDate;

--but when we do add DueDate we are now grouping by a composite value 
--because we are grouping by Projectid and DueDate and have a lot more groupings

--GROUP BY

--Let's count tasks per status.
--first let's see without GROUP BY or the COUNT
SELECT
    s.Name StatusName,
    t.TaskId
FROM 
	Task t
LEFT OUTER JOIN 
	TaskStatus s 
ON t.TaskStatusId = s.TaskStatusId
ORDER BY 
	s.Name


--now a GROUP BY the statusName and COUNT the Taskids
--we will group the NULLs under [None]
SELECT
    ISNULL(s.Name, '[None]') StatusName,
    COUNT(t.TaskId) TaskCount
FROM 
	Task t
LEFT OUTER JOIN 
	TaskStatus s 
ON t.TaskStatusId = s.TaskStatusId
GROUP BY 
	s.Name
ORDER BY 
	s.Name;

--Aggregate functions work with GROUP BY


--now let's add a field to our select list, IsResolved
SELECT
    ISNULL(s.Name, '[None]') StatusName,
    s.IsResolved,
    COUNT(t.TaskId) TaskCount
FROM 
	Task t
LEFT OUTER JOIN 
	TaskStatus s 
ON t.TaskStatusId = s.TaskStatusId
GROUP BY 
	s.Name
ORDER BY 
	s.Name;

--oops!!
--Column 'TaskStatus.IsResolved' is invalid in the select list because it is not 
--contained in either an aggregate function or the GROUP BY clause.

--to avoid that error, we include IsResolved in the columumns we are grouping by
SELECT
    ISNULL(s.Name, '[None]') StatusName,
    ISNULL(s.IsResolved, 0) IsResolved,
    COUNT(t.TaskId) TaskCount
FROM 
	Task t
LEFT OUTER JOIN 
	TaskStatus s 
ON t.TaskStatusId = s.TaskStatusId
GROUP BY 
	s.Name, 
	s.IsResolved -- IsResolved is now part of the GROUP.
ORDER BY 
	s.Name;


--fetch the estimated hours in tasks assigned to workers, calculate a total 
--per worker, and find all workers with more than 100 total hours. We need three 
--tables: Worker, ProjectWorker, and Task. We can use INNER JOINs in all relationships
SELECT
    w.FirstName + ' ' + w.LastName WorkerName,
    SUM(t.EstimatedHours) TotalHours
FROM 
	Worker w
INNER JOIN 
	ProjectWorker pw 
ON w.WorkerId = pw.WorkerId
INNER JOIN 
	Task t 
ON pw.WorkerId = t.WorkerId
    AND pw.ProjectId = t.ProjectId
GROUP BY 
	w.WorkerId, 
	w.FirstName, 
	w.LastName
ORDER BY 
	w.FirstName, 
	w.LastName




--this brings back all of our workers grouped together 
--with an aggregate sum of Hours
--but we only want to return Workers with more than 100 hours
SELECT
    w.FirstName + ' ' + w.LastName WorkerName,
    SUM(t.EstimatedHours) TotalHours
FROM 
	Worker w
INNER JOIN 
	ProjectWorker pw 
ON w.WorkerId = pw.WorkerId
INNER JOIN 
	Task t 
ON pw.WorkerId = t.WorkerId
    AND pw.ProjectId = t.ProjectId
GROUP BY 
	w.WorkerId, 
	w.FirstName, 
	w.LastName
HAVING 
	SUM(t.EstimatedHours) >= 100
ORDER BY 
	SUM(t.EstimatedHours)

--we can't use the alias name of TotalHours, we must use the
--aggregate expression


--using a MIN aggregate function
--MIN works on any data type that can be compared and ranked. It definitely 
--works for numbers, but also works with dates, times, and strings.
--let's return Projects that have a Min DueDate after '01/01/2002'
SELECT
    p.Name ProjectName,
    MIN(t.DueDate) MinTaskDueDate
FROM 
	Project p
INNER JOIN 
	Task t 
ON p.ProjectId = t.ProjectId
WHERE 
	p.ProjectId LIKE 'game-%'
    AND t.ParentTaskId IS NOT NULL
GROUP BY 
	p.ProjectId, 
	p.Name
HAVING
	MIN(t.DueDate) > '01/01/2002'
ORDER BY 
	p.Name;


--we want an overview of each project: 
--	first and last task due date, 
--	total estimated hours, 
--	total number of tasks, 
--	average task estimate

SELECT
    p.Name ProjectName,
    MIN(t.DueDate) MinTaskDueDate,
    MAX(t.DueDate) MaxTaskDueDate,
    SUM(t.EstimatedHours) TotalHours,
    AVG(t.EstimatedHours) AverageTaskHours,
    COUNT(t.TaskId) TaskCount
FROM 
	Project p
INNER JOIN 
	Task t 
ON p.ProjectId = t.ProjectId
WHERE 
	t.ParentTaskId IS NOT NULL
GROUP BY 
	p.ProjectId, 
	p.Name
HAVING 
	COUNT(t.TaskId) >= 10
ORDER BY 
	COUNT(t.TaskId) DESC, 
	p.Name;

--group by query with 5 aggregate columns!!
--can we add the ProjectId to the SELECT list?


--DISTINCT

--this query returns alot of dupes
SELECT
    p.ProjectId,
    p.Name ProjectName
FROM 
	Project p
INNER JOIN 
	Task t 
ON p.ProjectId = t.ProjectId
WHERE 
	t.TaskTypeId = 1
ORDER BY 
	p.Name;

--let's get rid of he dupes with DISTINCT!!
SELECT DISTINCT
    p.ProjectId,
    p.Name ProjectName
FROM 
	Project p
INNER JOIN 
	Task t 
ON p.ProjectId = t.ProjectId
WHERE 
	t.TaskTypeId = 1
ORDER BY 
	p.Name;


--using GROUP BY to get rid of dupes
SELECT
    p.ProjectId,
    p.Name ProjectName
FROM 
	Project p
INNER JOIN 
	Task t 
ON p.ProjectId = t.ProjectId
WHERE 
	t.TaskTypeId = 1
GROUP BY
	p.ProjectId,
	p.Name
ORDER BY 
	p.Name;