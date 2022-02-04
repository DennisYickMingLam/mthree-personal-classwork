-- Execute in the context of the SQL Server master database.
USE [master];
GO

-- If the database already exists:
-- delete backups
-- terminate existing database connections
-- drop it so we can start over
if exists (select * from sys.databases where name = N'TrackIt')
begin
	EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'TrackIt';
	ALTER DATABASE TrackIt SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE TrackIt;
end

-- Here's our CREATE.
CREATE DATABASE TrackIt;
GO

-- Note the USE! It's important.
USE TrackIt;
GO

CREATE TABLE Task 
(
    TaskId INT PRIMARY KEY IDENTITY(1, 1),
    Title VARCHAR(100) NOT NULL,
    Details VARCHAR(MAX) NULL,
    DueDate DATE NOT NULL,
    EstimatedHours DECIMAL(5, 2) NULL
);
GO


CREATE TABLE Project 
(
    ProjectId CHAR(50) PRIMARY KEY,
    [Name] VARCHAR(100) NOT NULL,
    Summary VARCHAR(2000) NULL,
    DueDate DATE NOT NULL,
    IsActive BIT NOT NULL DEFAULT(1)
);
GO

ALTER TABLE Task
    ADD ProjectId CHAR(50) NOT NULL
    CONSTRAINT fk_Task_Project
        FOREIGN KEY (ProjectId) 
        REFERENCES Project(ProjectId);
GO


CREATE TABLE Worker 
(
    WorkerId INT PRIMARY KEY IDENTITY(1, 1),
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    ProjectId CHAR(50) NOT NULL,
    CONSTRAINT fk_Worker_Project FOREIGN KEY (ProjectId)
        REFERENCES Project(ProjectId)
);
GO

--There are three big, over-arching DDL actions: 
--CREATE builds schema from scratch, 
--ALTER edits existing schema, and 
--DROP deletes schema. We want to DROP the ProjectId column from Worker.

--Unfortunately, it would fail if we tried. Worker's ProjectId is part 
--of a FOREIGN KEY constraint. The SQL engine sees the dependency and prevents 
--the DROP. If we want to DROP ProjectId, we must first DROP the constraint.


ALTER TABLE Worker DROP
	COLUMN ProjectId;
	GO

ALTER TABLE Worker DROP 
    CONSTRAINT fk_Worker_Project,
    COLUMN ProjectId;
GO

ALTER TABLE Worker 
	ALTER COLUMN FirstName VARCHAR(50) NOT NULL;
ALTER TABLE Worker 
	ALTER COLUMN LastName VARCHAR(50) NOT NULL;


--now we will create a bridge table, also called an associative entity. 
--A bridge table includes a foreign key from each table it bridges or 
--associates. By including a key from two or more tables, the bridge table 
--models a relationship between concepts versus a concept that stands 
--on its own.
CREATE TABLE ProjectWorker (
    ProjectId CHAR(50) NOT NULL,
    WorkerId INT NOT NULL,
    CONSTRAINT pk_ProjectWorker PRIMARY KEY (ProjectId, WorkerId),
    CONSTRAINT fk_ProjectWorker_Project FOREIGN KEY (ProjectId)
        REFERENCES Project(ProjectId),
    CONSTRAINT fk_ProjectWorker_Worker FOREIGN KEY (WorkerId)
        REFERENCES Worker(WorkerId)
);


-- This approach destroys the existing database and starts from scratch each time you run it.
-- It's good for new development, but won't work for existing
-- databases that must be altered but left intact.
USE [master];
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