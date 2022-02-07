USE PersonalTrainer
GO

-- Select all columns from ExerciseCategory and Exercise.
-- The tables should be joined on ExerciseCategoryId.
-- This query returns all Exercises and their associated ExerciseCategory.
-- 64 rows
--------------------
SELECT *
FROM ExerciseCategory
INNER JOIN Exercise ON Exercise.ExerciseCategoryId = ExerciseCategory.ExerciseCategoryId;

-- Select ExerciseCategory.Name and Exercise.Name
-- where the ExerciseCategory does not have a ParentCategoryId (it is null).
-- Again, join the tables on their shared key (ExerciseCategoryId).
-- 9 rows
--------------------
SELECT ExerciseCategory.Name, Exercise.Name
FROM Exercise
INNER JOIN ExerciseCategory ON Exercise.ExerciseCategoryId = ExerciseCategory.ExerciseCategoryId
WHERE ExerciseCategory.ParentCategoryId IS NULL;

-- The query above is a little confusing. At first glance, it's hard to tell
-- which Name belongs to ExerciseCategory and which belongs to Exercise.
-- Rewrite the query using an aliases. 
-- Alias ExerciseCategory.Name as 'CategoryName'.
-- Alias Exercise.Name as 'ExerciseName'.
-- 9 rows
--------------------
SELECT ExerciseCategory.Name as ExerciseCategory, Exercise.Name as Exercise
FROM Exercise
INNER JOIN ExerciseCategory ON Exercise.ExerciseCategoryId = ExerciseCategory.ExerciseCategoryId
WHERE ExerciseCategory.ParentCategoryId IS NULL;

-- Select FirstName, LastName, and BirthDate from Client
-- and EmailAddress from Login 
-- where Client.BirthDate is in the 1990s.
-- Join the tables by their key relationship. 
-- What is the primary-foreign key relationship?
-- 35 rows
--------------------
Select Client.FirstName, Client.LastName, Client.BirthDate, Login.EmailAddress
from Client
INNER JOIN Login ON Client.ClientId = Login.ClientId
where Client.BirthDate like'199%'

-- Select Workout.Name, Client.FirstName, and Client.LastName
-- for Clients with LastNames starting with 'C'?
-- How are Clients and Workouts related?
-- 25 rows
--------------------
Select Workout.Name, Client.FirstName, Client.LastName
from Client
INNER JOIN ClientWorkout ON Client.ClientId = ClientWorkout.ClientId
INNER JOIN Workout ON ClientWorkout.WorkoutId = Workout.WorkoutId
where Client.LastName like'C%'

-- Select Names from Workouts and their Goals.
-- This is a many-to-many relationship with a bridge table.
-- Use aliases appropriately to avoid ambiguous columns in the result.
--------------------
select Workout.Name as Workout_Name, Goal.Name as Goal_Name
from Workout
INNER JOIN WorkoutGoal ON Workout.WorkoutId = WorkoutGoal.WorkoutId
INNER JOIN Goal ON WorkoutGoal.GoalId = Goal.GoalId

-- Select FirstName and LastName from Client.
-- Select ClientId and EmailAddress from Login.
-- Join the tables, but make Login optional.
-- 500 rows
--------------------
select Client.FirstName, Client.LastName, Login.ClientId, Login.EmailAddress
from Client
LEFT OUTER join Login on Client.ClientId = Login.ClientId

-- Using the query above as a foundation, select Clients
-- who do _not_ have a Login.
-- 200 rows
--------------------
select Client.FirstName, Client.LastName, Login.ClientId, Login.EmailAddress
from Client
left OUTER join Login on Client.ClientId = Login.ClientId
where login.EmailAddress is null

-- Does the Client, Romeo Seaward, have a Login?
-- Decide using a single query.
-- nope :(
--------------------
select Client.FirstName + ' ' + Client.LastName as Client_Name, login.EmailAddress
from Client
left join login on Client.ClientId = Login.ClientId
where	Client.FirstName = 'Romeo' AND
		Client.LastName = 'Seaward'

-- Select ExerciseCategory.Name and its parent ExerciseCategory's Name.
-- This requires a self-join.
-- 12 rows
--------------------
select child.Name as child, parent.Name as parent
from ExerciseCategory parent
inner join ExerciseCategory child on parent.ParentCategoryId = child.ExerciseCategoryId
    
-- Rewrite the query above so that every ExerciseCategory.Name is
-- included, even if it doesn't have a parent.
-- 16 rows
--------------------
select child.Name as child, parent.Name as parent
from ExerciseCategory parent
right join ExerciseCategory child on parent.ParentCategoryId = child.ExerciseCategoryId  

-- Are there Clients who are not signed up for a Workout?
-- 50 rows
--------------------
select Client.FirstName, Client.LastName
from Client
left join ClientWorkout on ClientWorkout.ClientId = Client.ClientId
where ClientWorkout.ClientId is null

-- Which Beginner-Level Workouts satisfy at least one of Shell Creane's Goals?
-- Goals are associated to Clients through ClientGoal.
-- Goals are associated to Workouts through WorkoutGoal.
-- 6 rows, 4 unique rows
--------------------
select Workout.Name
from Client
inner join ClientGoal on Client.ClientId = ClientGoal.ClientId
inner join Goal on Goal.GoalId = ClientGoal.GoalId
inner join WorkoutGoal on Goal.GoalId = WorkoutGoal.GoalId
inner join Workout on WorkoutGoal.WorkoutId = Workout.WorkoutId
inner join Level on Level.LevelId = Workout.LevelId
where Client.FirstName = 'Shell' and Client.LastName = 'Creane'
and level.name = 'Beginner'

-- Select all Workouts. 
-- Join to the Goal, 'Core Strength', but make it optional.
-- You may have to look up the GoalId before writing the main query.
-- If you filter on Goal.Name in a WHERE clause, Workouts will be excluded.
-- Why?
-- 26 Workouts, 3 Goals
--------------------
select Workout.Name
from Workout
inner join WorkoutGoal on Workout.WorkoutId = WorkoutGoal.WorkoutId
inner join Goal  on WorkoutGoal.GoalId = Goal.GoalId
group by Workout.Name

-- The relationship between Workouts and Exercises is... complicated.
-- Workout links to WorkoutDay (one day in a Workout routine)
-- which links to WorkoutDayExerciseInstance 
-- (Exercises can be repeated in a day so a bridge table is required) 
-- which links to ExerciseInstance 
-- (Exercises can be done with different weights, repetions,
-- laps, etc...) 
-- which finally links to Exercise.
-- Select Workout.Name and Exercise.Name for related Workouts and Exercises.
--------------------
select workout.Name as workout_name, Exercise.Name as exercise_name
from workout
inner join WorkoutDay on WorkoutDay.WorkoutId = workout.WorkoutId
inner join WorkoutDayExerciseInstance on WorkoutDay.WorkoutDayId = WorkoutDayExerciseInstance.WorkoutDayId
inner join ExerciseInstance on ExerciseInstance.ExerciseInstanceId = WorkoutDayExerciseInstance.ExerciseInstanceId
inner join Exercise on Exercise.ExerciseId = ExerciseInstance.ExerciseId;
   
-- An ExerciseInstance is configured with ExerciseInstanceUnitValue.
-- It contains a Value and UnitId that links to Unit.
-- Example Unit/Value combos include 10 laps, 15 minutes, 200 pounds.
-- Select Exercise.Name, ExerciseInstanceUnitValue.Value, and Unit.Name
-- for the 'Plank' exercise. 
-- How many Planks are configured, which Units apply, and what 
-- are the configured Values?
-- 4 rows, 1 Unit, and 4 distinct Values
--------------------
Select Exercise.Name as Exercise_Name, ExerciseInstanceUnitValue.Value as ExerciseInstanceUnitValue_Value, Unit.Name as Unit_Name
from unit
inner join ExerciseInstanceUnitValue on ExerciseInstanceUnitValue.UnitId = Unit.UnitId
inner join ExerciseInstance on ExerciseInstance.ExerciseInstanceId = ExerciseInstanceUnitValue.ExerciseInstanceId
inner join Exercise on Exercise.ExerciseId = ExerciseInstance.ExerciseId
where Exercise.Name = 'Plank'