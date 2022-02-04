-- This approach destroys the existing database and starts from scratch each time you run it.
-- It's good for new development, but won't work for existing
-- databases that must be altered but left intact.
USE [master]
GO

if exists (select * from sys.databases where name = N'TrackIt')
begin
	EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'TrackIt';
	ALTER DATABASE TrackIt SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE TrackIt;
end

CREATE DATABASE Trackit;
GO

-- Make sure we're in the correct database before we add schema.
USE TrackIt;
GO

CREATE TABLE Project (
    ProjectId CHAR(50) PRIMARY KEY,
    [Name] VARCHAR(100) NOT NULL,
    Summary VARCHAR(2000) NULL,
    DueDate DATE NOT NULL,
    IsActive BIT NOT NULL DEFAULT(1)
);

CREATE TABLE Worker (
    WorkerId INT PRIMARY KEY IDENTITY(1, 1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL
);

CREATE TABLE ProjectWorker (
    ProjectId CHAR(50) NOT NULL,
    WorkerId INT NOT NULL,
    CONSTRAINT pk_ProjectWorker PRIMARY KEY (ProjectId, WorkerId),
    CONSTRAINT fk_ProjectWorker_Project FOREIGN KEY (ProjectId)
        REFERENCES Project(ProjectId),
    CONSTRAINT fk_ProjectWorker_Worker FOREIGN KEY (WorkerId)
        REFERENCES Worker(WorkerId)
);

CREATE TABLE Task (
    TaskId INT PRIMARY KEY IDENTITY(1, 1),
    Title VARCHAR(100) NOT NULL,
    Details TEXT NULL,
    DueDate DATE NOT NULL,
    EstimatedHours DECIMAL(5, 2) NULL,
    ProjectId CHAR(50) NOT NULL,
    WorkerId INT NOT NULL,
    CONSTRAINT fk_Task_ProjectWorker FOREIGN KEY (ProjectId, WorkerId)
        REFERENCES ProjectWorker(ProjectId, WorkerId)
);



INSERT INTO Worker (FirstName, LastName)
    VALUES ('Rosemonde', 'Featherbie');

SELECT * FROM Worker;

INSERT INTO Worker (FirstName, LastName)
    VALUES ('Kingsly', 'Besantie');

INSERT INTO Worker (FirstName, LastName) VALUES
    ('Goldi','Pilipets'),
    ('Dorey','Rulf'),
    ('Panchito','Ashtonhurst');


--notice that we are not inserting WorkerId, that is from 
--the Identity column
SELECT * FROM Worker;


--let's try to insert the id
INSERT INTO Worker (WorkerId, FirstName, LastName)
    VALUES (50, 'Valentino', 'Newvill');


--we have to turn IDENTITY_INSERT on
SET IDENTITY_INSERT Worker ON;

INSERT INTO Worker (WorkerId, FirstName, LastName)
    VALUES (50, 'Valentino', 'Newvill');

--and DON'T forget to turn it off
SET IDENTITY_INSERT Worker OFF;

SELECT * FROM Worker;

--now inserting values with FK's
--and maintaining  referential integrity. 
INSERT INTO Project (ProjectId, [Name], DueDate)
    VALUES ('db-milestone', 'Database Material', '2018-12-31');

	select * from Project;
--FK violation
INSERT INTO ProjectWorker (ProjectId, WorkerId)
    VALUES ('db-milestone', 75)

SELECT * FROM Project;
SELECT * FROM Worker;
SELECT * FROM ProjectWorker;
select * from Task;


--let's try this again!!
INSERT INTO Project (ProjectId, [Name], DueDate)
	VALUES ('kitchen', 'Kitchen Remodel', '2025-07-15'); 
    
INSERT INTO ProjectWorker (ProjectId, WorkerId) VALUES 
    ('db-milestone', 1), -- Rosemonde, Database
    ('kitchen', 2),      -- Kingsly, Kitchen
    ('db-milestone', 3), -- Goldi, Database
    ('db-milestone', 4); -- Dorey, Database


SELECT * FROM Project;
SELECT * FROM Worker;
SELECT * FROM ProjectWorker;
select * from Task;

--UPDATES and DELETES
--The WHERE clause is important. Without it, you impact the whole table 
-- every record. Databases do not have an "undo" command, so if you forget 
-- the WHERE on a query that updates a million records, you are going to 
-- have a very uncomfortable issue

-- Provide a Project Summary and change the DueDate.
UPDATE 
	Project 
SET
    Summary = 'All lessons and exercises for the relational database milestone.',
    DueDate = '2018-10-15'
WHERE 
	ProjectId = 'db-milestone';

-- Change Kingsly's LastName to 'Oaks'.
UPDATE 
	Worker 
SET
    LastName = 'Oaks'
WHERE WorkerId = 2;


SELECT * FROM Project;
SELECT * FROM Worker;
SELECT * FROM ProjectWorker;
select * from Task;

--updating more than one column
--we just don't have any rows that meet this condition  lol
UPDATE 
	Project 
SET
    IsActive = 0
WHERE 
	DueDate BETWEEN '2017-01-01' AND '2017-12-31'
	AND IsActive = 1;

-- Delete our out-of-order WorkerId.
DELETE FROM 
	Worker
WHERE 
	WorkerId = 50;


SELECT * FROM Worker;



--FK violation
DELETE FROM 
	Worker
WHERE 
	FirstName = 'Kingsly';



insert into Task (Title, Details, DueDate, EstimatedHours, ProjectId, WorkerId)
values 
('', NULL, '08/29/2021', NULL, 'kitchen', 2),
('', NULL, '08/28/2021', NULL, 'kitchen', 2),
('', NULL, '08/27/2021', NULL, 'db-milestone', 4);


--let's try this over again!!
SELECT * FROM Task;
SELECT * FROM Worker;
SELECT * FROM Project;
SELECT * FROM ProjectWorker;


--How to delete with a FK
--we want to delete Kingsley from Worker table
DELETE Worker
WHERE Firstname = 'Kingsly';  --his WorkerID = 2

--oops FK issue
SELECT * FROM Worker;
SELECT * FROM ProjectWorker;


--FK Violation
--we need to delete all of references of 'Kingsly' from other table
--so let's delete Kingsly from the ProjectWorker table
DELETE ProjectWorker
WHERE WorkerID = 2

--oops, not again
SELECT * FROM ProjectWorker;
SELECT * FROM Task;



--so we need to delete from Tasks
-- Delete Tasks first since Task references ProjectWorker.
DELETE FROM 
	Task
WHERE 
	WorkerId = 2;

-- Then Delete ProjectWorker
-- That removes Kingsly from all Projects.
DELETE FROM 
	ProjectWorker
WHERE 
	WorkerId = 2;

-- Finally, remove Kingsly.
DELETE FROM 
	Worker
WHERE 
	WorkerId = 2;


SELECT * FROM Task;
SELECT * FROM ProjectWorker;
SELECT * FROM Worker;
SELECT * FROM Project;

