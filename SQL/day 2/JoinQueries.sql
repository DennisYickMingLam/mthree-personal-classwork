USE Trackit
GO
--pulling out records from all tables that have any 
--record related to WorkerID 1.
SELECT * FROM Worker WHERE WorkerId = 1;
SELECT * FROM ProjectWorker WHERE WorkerId = 1; 
SELECT * FROM Project WHERE ProjectID IN 
	(SELECT ProjectId FROM ProjectWorker WHERE WorkerId = 1);
SELECT * FROM Task WHERE WorkerId = 1;
SELECT * FROM TaskStatus WHERE TaskStatusId IN 
	(SELECT TaskStatusId FROM Task WHERE WorkerId = 1);
SELECT * FROM TaskType WHERE TaskTypeId IN 
	(SELECT TaskTypeId FROM Task WHERE WorkerId = 1);


--a list of tasks that are in a resolved status 
--using 2 queries and combining the results manually 
--we will just pretend that we combined the results in an EXCEL 
SELECT *
FROM TaskStatus
WHERE IsResolved = 1;
 
SELECT *
FROM Task
WHERE TaskStatusId IN (5, 6, 7, 8);

--If the TaskStatus changes then we need to modify our second query
--There must be a better way!!



/*
BLOCK COMMENTS GO BETWEEN /*........*/
--Syntax for join query
SELECT
    Table1.Column1,
    Table1.Column2,
    Table2.Column1,
    Table2.ColumnN
FROM Table1 
[Join Type] JOIN Table2 ON [Relationship Condition]
WHERE [Filter Condition];

Join Types can be:
   INNER             --common and is the default 
   LEFT OUTER JOIN   --very common join
   RIGHT OUTER JOIN  --kinda rare
   FULL OUTER JOIN
   CROSS JOIN
*/

--INNER JOIN - default
--will return records with matching rows in both tables...
--we are using aliases and prefixing our column names
SELECT 
    T.TaskId,
    T.Title,
    TS.[Name]
FROM 
	TaskStatus TS
INNER JOIN 
	Task T 
ON TS.TaskStatusId = T.TaskStatusId
WHERE 
	TS.IsResolved = 1;


--what happens when we don't preface our columns with table name or alias
SELECT 
    TaskId,
    Title,
    [Name]
FROM 
	TaskStatus
INNER JOIN 
	Task 
ON TaskStatus.TaskStatusId = Task.TaskStatusId
WHERE 
	IsResolved = 1;

--as long as there are no ambiguous names it will work, but 
--let's see what happens when we add a column that is in both tables
SELECT 
    TaskId,
    Title,
    [Name],
	TaskStatusId
FROM 
	TaskStatus
INNER JOIN 
	Task 
ON 
	TaskStatus.TaskStatusId = Task.TaskStatusId
WHERE 
	IsResolved = 1;



--Let's see who's working on the Who's a GOOD boy!? game project.
--we had to join Project & Worker with the 'bridge' table
--ProjectWorker even though it does not have a column in our 
--select list
SELECT * FROM Project WHERE ProjectId = 'game-goodboy';
SELECT * FROM ProjectWorker WHERE ProjectId = 'game-goodboy';
SELECT * FROM Worker WHERE WorkerId IN (SELECT WorkerId FROM ProjectWorker 
										WHERE ProjectId = 'game-goodboy');


SELECT
    P.[Name],
    W.FirstName,
    W.LastName
FROM 
	Project P
INNER JOIN 
	ProjectWorker PW 
ON P.ProjectId = PW.ProjectId
INNER JOIN 
	Worker W 
ON PW.WorkerId = W.WorkerId
WHERE 
	P.ProjectId = 'game-goodboy';


--If we want to see who's working on each task in the Who's a GOOD boy!?
--so we need to join a 4th table, Task
--project, we INNER JOIN the Task table and retrieve the task title.
SELECT
    P.Name,
    W.FirstName,
    W.LastName,
    T.Title
FROM 
	Project P
INNER JOIN 
	ProjectWorker PW 
ON P.ProjectId = PW.ProjectId
INNER JOIN 
	Worker W 
ON 
	PW.WorkerId = W.WorkerId
INNER JOIN 
	Task T 
ON PW.ProjectId = T.ProjectId AND PW.WorkerId = T.WorkerId  --comment out AND and after
WHERE 
	P.ProjectId = 'game-goodboy'
ORDER BY 
	W.LastName, T.Title;

--notice how the ON is using AND condition...  ON can be 
--as flexible as WHERE
--try commenting out the PW.WorkerID = T.WorkerID
--since we are no longer filtering by WorkerID, we are returning
--all the Tasks for each WorkerID 


--OUTER JOINS
SELECT * FROM Task;
--returns 543 rows

--now let's do an INNER JOIN
SELECT *
FROM Task T
INNER JOIN TaskStatus TS 
ON T.TaskStatusId = TS.TaskStatusId
ORDER BY T.TaskStatusId;

--only 532 rows, where did the 11 records go?
--also notice that since we are using * we return 
--all records from both tables

--here's our 11 records, but since the Task table did not 
--have a matching row for TaskStatusID they did not return 
--with our INNER JOIN
SELECT * 
FROM Task
WHERE TaskStatusId IS NULL;


--LEFT OUTER JOIN
SELECT *
FROM Task T
LEFT OUTER JOIN TaskStatus TS 
ON T.TaskStatusId = TS.TaskStatusId
ORDER BY T.TaskStatusID;

--LEFT OUTER JOIN will return all records from the table on the 
--left of the JOIN keyword, so we will get all Tasks even if
--there is no matching TaskStatusID

--RIGHT OUTER JOIN
--LEFT and RIGHT are literal, this will return the same as above 
--because we are using a RIGHT join and the Task table is now on the right
SELECT *
FROM TaskStatus TS
RIGHT OUTER JOIN Task T 
ON T.TaskStatusId = TS.TaskStatusId
ORDER BY T.TaskStatusID;



--When using outer joins, we will be returning NULLs
SELECT
    T.TaskId,
    T.Title,
    T.TaskStatusId,
    TS.Name
FROM Task T
LEFT OUTER JOIN TaskStatus TS 
    ON T.TaskStatusId = TS.TaskStatusId
ORDER BY
	T.TaskStatusId;


--we use ISNULL to handle the NULLs
SELECT
    T.TaskId,
    T.Title,
    ISNULL(T.TaskStatusId, 0) TaskStatusId,
    ISNULL(TS.Name, 'None') StatusName
FROM Task T
LEFT OUTER JOIN TaskStatus TS 
    ON T.TaskStatusId = TS.TaskStatusId
ORDER BY
	T.TaskStatusId;


--projects without workers and projects with Workers
--We want them all!!
--we want all of the Projects, even if they are not in 
--the ProjectWorker table
SELECT * FROM Project;
SELECT * FROM ProjectWorker;

--this will return all Projects even if there is no 
--worker
SELECT
    P.Name ProjectName, -- An alias makes this more clear.
    W.FirstName,
    W.LastName
FROM Project P
LEFT OUTER JOIN 
	ProjectWorker PW 
ON P.ProjectId = PW.ProjectId
LEFT OUTER JOIN
--INNER JOIN 
	Worker W 
ON PW.WorkerId = W.WorkerId

--166 rows...  did you find the project with no Worker?
--NOTE: once you need an OUTER JOIN, you likely always need an OUTER JOIN
--try running above query with the second join being an INNER...


--we only want the project that does not have a worker assigned to it
--so we will use the above query and filter to bring 
--back the record that had a NULL Worker
--so we will filter bringing back only records that have a NULL WorkerId
SELECT
    P.Name ProjectName,
    W.FirstName,
    W.LastName
FROM Project P
LEFT OUTER JOIN 
	ProjectWorker PW 
ON P.ProjectId = PW.ProjectId
LEFT OUTER JOIN
	Worker W 
ON PW.WorkerId = W.WorkerId
WHERE 
	PW.WorkerId IS NULL; 


--if we don't care about returning the workers name or other info, we can leave out 
--the Worker table
-- Projects without workers, we only need the bridge table to confirm.
SELECT
    P.[Name] ProjectName
FROM 
	Project P
LEFT OUTER JOIN 
	ProjectWorker PW 
ON P.ProjectId = PW.ProjectId
WHERE 
	PW.WorkerId IS NULL;

--let's see how we can return Workers with no Projects now
--by simply using the same query, but making the join RIGHT
--this time it will return all the records from the Worker
--table even if there is no matching row in the ProjectWorker
--table, etc.... And then filter for rows where the ProjectId is NULL  
SELECT
    P.Name ProjectName,
    W.FirstName,
    W.LastName
FROM Project P
RIGHT OUTER JOIN 
	ProjectWorker PW 
ON P.ProjectId = PW.ProjectId
RIGHT OUTER JOIN
	Worker W 
ON PW.WorkerId = W.WorkerId
WHERE 
	PW.ProjectId IS NULL;


--Again, we can simplify by omitting Project.
-- Workers without a project
SELECT
    W.FirstName,
    W.LastName
FROM 
	ProjectWorker PW
RIGHT OUTER JOIN 
	Worker W
ON PW.WorkerId = W.WorkerId
WHERE 
	PW.ProjectId IS NULL;


--Any RIGHT OUTER JOIN can be rewritten as a LEFT and it's often 
--easier to visualize relationships in one direction. Consider transforming 
--RIGHTs to LEFTs for consistency.
--so switch those table and make it a LEFT JOIN?
--what happened to the OUTER keyword?
SELECT
    W.FirstName,
    W.LastName
FROM 
	Worker W
LEFT JOIN 
	ProjectWorker PW 
ON W.WorkerId = PW.WorkerId
WHERE 
	PW.WorkerId IS NULL;

--NOTE: You might see a LEFT JOIN without the OUTER keyword and it will work



--we want to see all the records where the Task has a ParentTask 
--Can we JOIN a table to itself? Let's try it.
--first let's see the raw data
SELECT * FROM Task;
--let's see it not 'as raw'
SELECT 
	TaskId,
	Title,
	ParentTaskId,
	'' ParentTaskTitle
FROM
	Task T

--we need a join to populate the ParentTaskId column

--we want to join the table to itself and join up the TaskId to
--the ParentTaskId
SELECT *
FROM Task
INNER JOIN Task ON Task.TaskId = Task.ParentTaskId;
	
--oops
--let's try this again using aliases
SELECT
    parent.TaskId ParentTaskId,
    child.TaskId ChildTaskId, 
	parent.Title ParentTitle,
	child.Title ChildTitle,
    parent.Title + ': ' + child.Title Title
FROM 
	Task parent --instance named parent
INNER JOIN 
	Task child --instance named child
ON parent.TaskId = child.ParentTaskId;



--CROSS JOIN does not use an ON clause because it does not match on a condition. 
--Instead, CROSS JOIN creates a cartesian product, with every possible combination 
--of rows between the joined tables included in the results

SELECT
   w.FirstName + ' ' + w.LastName WorkerName,
   p.Name ProjectName
FROM 
	Worker w
CROSS JOIN 
	Project p
WHERE 
	w.WorkerId = 1
	AND p.ProjectId NOT LIKE 'game-%';

--Inez Fanthome, WorkerId 1, combined with every non-game project. 
--The results don't show actual relationships, they just show every 
--possible combination


--SORTING
--ascending
SELECT
*
FROM
	Worker
ORDER BY 
	LastName


--descending
SELECT
*
FROM
	Worker
ORDER BY 
	LastName DESC

--sorting with a join
SELECT
    w.FirstName,
    w.LastName,
    p.Name ProjectName
FROM 
	Worker w
INNER JOIN 
	ProjectWorker pw 
ON w.WorkerId = pw.WorkerId
INNER JOIN 
	Project p 
ON pw.ProjectId = p.ProjectId
ORDER BY 
	w.LastName ASC;


--sorting by more than one column
SELECT
    w.FirstName,
    w.LastName,
    p.Name ProjectName
FROM 
	Worker w
INNER JOIN 
	ProjectWorker pw 
ON w.WorkerId = pw.WorkerId
INNER JOIN 
	Project p 
ON pw.ProjectId = p.ProjectId
ORDER BY 
	w.LastName, 
	p.Name;


--changing direction of sort
SELECT
    w.FirstName,
    w.LastName,
    p.Name ProjectName
FROM 
	Worker w
INNER JOIN 
	ProjectWorker pw 
ON w.WorkerId = pw.WorkerId
INNER JOIN 
	Project p 
ON pw.ProjectId = p.ProjectId
ORDER BY 
	w.LastName DESC,  --this changes the direction to highest to lowest
	p.Name ASC;


--Handling NULL
--notice how if we sort ascending, all the NULLs
--are at the top
SELECT
    t.Title,
    s.Name StatusName
FROM 
	Task t
LEFT OUTER JOIN 
	TaskStatus s 
ON t.TaskStatusId = s.TaskStatusId
ORDER BY 
	s.Name ASC;


-- Results are sorted non-null (0) to null (1), then by TaskStatus.Name.
-- That puts NULL values last.
SELECT
    t.Title,
    s.Name StatusName
FROM 
	Task t
LEFT OUTER JOIN 
	TaskStatus s 
ON t.TaskStatusId = s.TaskStatusId
ORDER BY 
	CASE WHEN s.Name IS NULL THEN 1 ELSE 0 END, 
	s.Name ASC;

--the CASE statement is like a mini if...else
--IF (s.Name is NULL){ return 1} else {return 0} 


-- another solution using ISNULL instead of CASE
-- Results are sorted ISNULL(s.Name, 'ZZZZZ'), then by TaskStatus.Name.
-- That puts NULL values last unless there's a TaskState.Name 'ZZZZZZZZ'?!
SELECT
    t.Title,
    s.Name StatusName
FROM 
	Task t
LEFT OUTER JOIN 
	TaskStatus s 
ON t.TaskStatusId = s.TaskStatusId
ORDER BY 
	ISNULL(s.Name, 'ZZZZZ'), --note we are ordering by this, not returning it
	s.Name ASC;


--FETCH & OFFSET
SELECT *
FROM Worker
ORDER BY 
	LastName DESC
	OFFSET 0 ROWS 
	FETCH NEXT 10 ROWS ONLY;

--OFFSET - which row to start the retrieval
--FETCH - how many rows to retrieve

--if OFFSET does not exist we do not get an error
--just no rows are returned
SELECT *
FROM Worker
ORDER BY 
	LastName DESC
	OFFSET 200 ROWS 
	FETCH NEXT 10 ROWS ONLY;


-- Skip the first 100 records and show the next 25.
SELECT
    w.FirstName,
    w.LastName,
    p.Name ProjectName
FROM 
	Worker w
INNER JOIN 
	ProjectWorker pw 
ON w.WorkerId = pw.WorkerId
INNER JOIN 
	Project p 
ON pw.ProjectId = p.ProjectId
ORDER BY 
	w.LastName DESC, p.Name ASC
	OFFSET 100 ROWS
	FETCH NEXT 25 ROWS ONLY;



