--3 tables Project, Worker and a bridge table ProjectWorker
--We can have projects without workers and workers with no projects
--Using joins we can find out which projects and workers are not being used
SELECT * FROM Project;
SELECT * FROM ProjectWorker;
SELECT * FROM Worker;

--INNER JOIN
--Return only matching records in both tables
--Only Projects that have workers - 165 
SELECT 
	P.ProjectId,
	P.[Name] Project,
	W.LastName + ', ' + W.FirstName Worker
FROM
	Project P
INNER JOIN 
	ProjectWorker PW  
ON 
	P.ProjectId = PW.ProjectId
INNER JOIN 
	Worker W
ON 
	PW.WorkerId = W.WorkerId
ORDER BY 
	P.[Name],
	W.LastName


--What if we want to see all projects even if they have no worker assigned?
--LEFT OUTER JOIN
--This will return all of the records in the Projects table
--166 records - 1 project that does not have a worker, 'game-smell' - row 26
SELECT 
	P.ProjectId,
	P.[Name] Project,
	W.LastName + ', ' + W.FirstName Worker
FROM
	Project P  --This is the table to the left
LEFT OUTER JOIN 
	ProjectWorker PW  
ON 
	P.ProjectId = PW.ProjectId
LEFT OUTER JOIN 
	Worker W
ON 
	PW.WorkerId = W.WorkerId
ORDER BY 
	P.[Name],
	W.LastName


--RIGHT OUTER JOINS are rarely used 
--But here is an example


--What if we want to see all workers even if they have no project assigned to them?
--RIGHT OUTER JOIN
--This will return all of the records in the Workers table 
--177 Records - 12 workers with no project
SELECT 
	P.ProjectId,
	P.[Name] Project,
	W.LastName + ', ' + W.FirstName Worker
FROM
	Project P  
RIGHT OUTER JOIN 
	ProjectWorker PW  
ON 
	P.ProjectId = PW.ProjectId
RIGHT OUTER JOIN 
	Worker W -- this is the table to the right
ON 
	PW.WorkerId = W.WorkerId
ORDER BY 
	P.[Name],
	W.LastName


--normally the Worker and Project table would switch and a LEFT JOIN used
--this time we will also handle the NULL
--LEFT OUTER JOIN
SELECT 
	ISNULL(P.ProjectId, 'off-line') ProjectId,
	ISNULL(P.[Name], '') Project,
	W.LastName + ', ' + W.FirstName Worker
FROM
	Worker W  --This is the table to the left
LEFT OUTER JOIN 
	ProjectWorker PW  
ON 
	W.WorkerId = PW.WorkerId
LEFT OUTER JOIN 
	Project P
ON 
	PW.ProjectId = P.ProjectId
ORDER BY 
	P.[Name],
	W.LastName

--What if we want to see all projects even with no worker assigned and all workers
--even if they are assigned no project

--FULL OUTER JOIN 
--will bring back all records from both tables
--178 records - 165 matching | 1 project no worker | 12 workers no project
SELECT 
	ISNULL(P.ProjectId, 'off-line') ProjectId,
	ISNULL(P.[Name], '') Project,
	W.LastName + ', ' + W.FirstName Worker
FROM
	Worker W  --This is the table to the left
FULL OUTER JOIN 
	ProjectWorker PW  
ON 
	W.WorkerId = PW.WorkerId
FULL OUTER JOIN 
	Project P
ON 
	PW.ProjectId = P.ProjectId
ORDER BY 
	P.[Name],
	W.LastName




