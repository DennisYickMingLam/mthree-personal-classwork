USE TrackIt
GO

--COUNT()

--we want to count how many rows are in this table
SELECT * FROM Task;

-- Count TaskIds, 543 values
SELECT 
	COUNT(TaskId) NumberOfTaskIds
FROM 
	Task;

-- Count everything  *, 543 values
SELECT 
	COUNT(*) NumberOfRows
FROM 
	Task;

--let's count how any Tasks have a ParentTask - 416
SELECT 
	COUNT(ParentTaskId) NumberOfParentTaskIds
FROM 
	Task;

--counting resolved tasks  -  276
--we will need to join with the TaskStatus table so we can filter WHERE IsResolved
SELECT
    COUNT(t.TaskId)
FROM 
	Task t
INNER JOIN 
	TaskStatus s 
ON 
	t.TaskStatusId = s.TaskStatusId
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
--note the error
SELECT
	ProjectId,
	MIN(EstimatedHours) MinEstHours,
	MAX(EstimatedHours) MaxEstHours,
	AVG(EstimatedHours) AvgEstHours,
	SUM(EstimatedHours) SumEstHours
FROM
	Task
ORDER BY 
	ProjectId;


--When adding on fields in the select list,
--when using aggregates, you need to group by those fields
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
select * from Task

--If I want to see the TaskType too, I need to group by it also
SELECT
	T.ProjectId,
	TT.[Name] TaskType,
	MIN(T.EstimatedHours) MinEstHours,
	MAX(T.EstimatedHours) MaxEstHours,
	AVG(T.EstimatedHours) AvgEstHours
FROM
	Task T
INNER JOIN 
	TaskType TT
ON 
	T.TaskTypeId = TT.TaskTypeId
GROUP BY 
	T.ProjectId,
	TT.[Name]
ORDER BY
	ProjectId;

--but when we do add taskType we are now grouping by a composite value 
--because we are grouping by Projectid and taskType we have a lot more groupings



--GROUP BY 
--Group by's are almost always used with aggregate functions


--Let's count tasks per status.
--first let's see how many tasks we have and the status they are in
--without GROUP BY or the COUNT aggregate function
SELECT
    s.Name StatusName,
    t.TaskId
FROM 
	Task t
LEFT OUTER JOIN 
	TaskStatus s 
ON 
	t.TaskStatusId = s.TaskStatusId
ORDER BY 
	s.[Name]

--now a GROUP BY the StatusName and COUNT(aggregate) the Taskids
--we will group the NULLs under [None]
SELECT
    ISNULL(s.Name, '[None]') StatusName,
    COUNT(t.TaskId) TaskCount
FROM 
	Task t
LEFT OUTER JOIN 
	TaskStatus s 
ON 
	t.TaskStatusId = s.TaskStatusId
GROUP BY 
	s.[Name]
ORDER BY 
	s.[Name];

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
ON 
	t.TaskStatusId = s.TaskStatusId
GROUP BY 
	s.Name
ORDER BY 
	s.Name;

--oops!!
--Column 'TaskStatus.IsResolved' is invalid in the select list because it is not 
--contained in either an aggregate function or the GROUP BY clause.

--to avoid that error, we include IsResolved in the columns we are grouping by
SELECT
    ISNULL(s.Name, '[None]') StatusName,
    ISNULL(s.IsResolved, 0) IsResolved,
    COUNT(t.TaskId) TaskCount
FROM 
	Task t
LEFT OUTER JOIN 
	TaskStatus s 
ON 
	t.TaskStatusId = s.TaskStatusId
GROUP BY 
	s.[Name], 
	s.IsResolved -- IsResolved is now part of the GROUP.
ORDER BY 
	s.[Name];


--fetch the estimated hours in tasks assigned to workers, calculate a total 
--per worker, and find all workers with more than 100 total hours. 
--here is the data we need to group, aggregate and filter
SELECT
    w.LastName + ', ' + w.FirstName Worker,
	t.Title,
    t.EstimatedHours
FROM 
	Worker w
INNER JOIN 
	ProjectWorker pw 
ON 
	w.WorkerId = pw.WorkerId
INNER JOIN 
	Task t 
ON 
	pw.WorkerId = t.WorkerId
    AND pw.ProjectId = t.ProjectId
ORDER BY 
	w.LastName, 
	w.FirstName

--3 tables: Worker, ProjectWorker, and Task. 
--Remove the 't.Title' column from select list
--Aggregate, SUM, the EstimatedHours
--group by the worker name
--
SELECT
    w.FirstName + ' ' + w.LastName Worker,
    SUM(t.EstimatedHours) TotalHours
FROM 
	Worker w
INNER JOIN 
	ProjectWorker pw 
ON 
	w.WorkerId = pw.WorkerId
INNER JOIN 
	Task t 
ON 
	pw.WorkerId = t.WorkerId
    AND pw.ProjectId = t.ProjectId
GROUP BY
	w.FirstName, 
	w.LastName
ORDER BY 
	w.FirstName, 
	w.LastName

--Now we want to filter out the TotalHours >= 100
--The SUM of the estimated hours is an aggregate
--Instead of WHERE for filtering aggregates use HAVING
SELECT
    w.FirstName + ' ' + w.LastName WorkerName,
    SUM(t.EstimatedHours) TotalHours
FROM 
	Worker w
INNER JOIN 
	ProjectWorker pw 
ON 
	w.WorkerId = pw.WorkerId
INNER JOIN 
	Task t 
ON 
	pw.WorkerId = t.WorkerId
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


--using MIN aggregate function
--MIN works on any data type that can be compared and ranked
--Works for numbers, dates, times, and strings.
--Return Projects HAVING a MIN DueDate(oldest date) after '01/01/2002'
--WHERE the ProjectId LIKE 'game-%' 
SELECT
    p.[Name] ProjectName,
    MIN(t.DueDate) MinTaskDueDate
FROM 
	Project p
INNER JOIN 
	Task t 
ON 
	p.ProjectId = t.ProjectId
WHERE 
	p.ProjectId LIKE 'game-%'
GROUP BY 
	p.ProjectId, 
	p.[Name]
HAVING
	MIN(t.DueDate) > '01/01/2002'
ORDER BY 
	p.[Name];


--we want an overview of each project:
--  Project Name
--	MIN/first and MAX/last task due date 
--	SUM/total estimated hours
--	AVG/average estimated hours
--  COUNT/tasks with 10 or more tasks

SELECT
    p.[Name] ProjectName,
    MIN(t.DueDate) MinTaskDueDate,
    MAX(t.DueDate) MaxTaskDueDate,
    SUM(t.EstimatedHours) TotalHours,
    AVG(t.EstimatedHours) AverageTaskHours,
    COUNT(t.TaskId) TaskCount
FROM 
	Project p
INNER JOIN 
	Task t 
ON 
	p.ProjectId = t.ProjectId
GROUP BY
	p.[Name]
HAVING 
	COUNT(t.TaskId) >= 10
ORDER BY 
	COUNT(t.TaskId) DESC, 
	p.[Name];

--group by query with 5 aggregate columns!!



--DISTINCT

--this query returns alot of dupes
SELECT
    p.ProjectId,
    p.[Name] ProjectName
FROM 
	Project p
INNER JOIN 
	Task t 
ON 
	p.ProjectId = t.ProjectId
WHERE 
	t.TaskTypeId = 1
ORDER BY 
	p.[Name];

--let's get rid of he dupes with DISTINCT!!
SELECT DISTINCT
    p.ProjectId,
    p.[Name] ProjectName
FROM 
	Project p
INNER JOIN 
	Task t 
ON 
	p.ProjectId = t.ProjectId
WHERE 
	t.TaskTypeId = 1
ORDER BY 
	p.[Name];


--using GROUP BY all columns in select list without an aggregate  
--to get rid of dupes
SELECT
    p.ProjectId,
    p.[Name] ProjectName
FROM 
	Project p
INNER JOIN 
	Task t 
ON p.ProjectId = t.ProjectId
WHERE 
	t.TaskTypeId = 1
GROUP BY
	p.ProjectId,
	p.[Name]
ORDER BY 
	p.[Name];