INSERT INTO Actor (FirstName,	LastName,	BirthDate)
VALUES ('Dan',	'Aykroyd',	'7/1/1952'),
('John',	'Candy',	'10/31/1950'),		
('Steve',	'Martin',	NULL),
('Sylvester',	'Stallone',	NULL);
SELECT *
FROM Actor

INSERT INTO Director (FirstName,	LastName,	BirthDate)
VALUES ('Ivan',	'Reitman',	'10/27/1946'),
('Ted',	'Kotcheff',	NULL);
SELECT *
FROM Director

INSERT INTO Rating (RatingName)
VALUES ('G'),('PG'),('PG-13'),('R');
SELECT *
FROM Rating

INSERT INTO Genre  (GenreName)
VALUES ('Action'),('Comedy'),('Drama'),('Horror');
SELECT *
FROM Genre

INSERT INTO Movie  (GenreID,	DirectorID,	RatingID, Title, ReleaseDate)
VALUES ('1',	'2',	'4',	'Rambo: First Blood',	'10/22/1982'),
('2',	NULL,	'4',	'Planes, Trains & Automobiles',	'11/25/1987'),
('2',	'1',	'2',	'Ghostbusters',	NULL),
('2',	NULL,	'2',	'The Great Outdoors',	'6/17/1988');
SELECT *
FROM Movie

INSERT INTO CastMember   (ActorID,	MovieID,	[Role])
VALUES ('5',	'1',	'John Rambo'),
('4',	'2',	'Neil Page'),
('3',	'2',	'Del Griffith'),
('1',	'3',	'Dr. Peter Venkman'),
('2',	'3',	'Dr. Raymond Stanz'),
('2',	'4',	'Roman Craig'),
('3',	'4',	'Chet Ripley');
SELECT *
FROM CastMember

UPDATE Movie SET
	Title = 'Ghostbusters (1984)'
WHERE Title='Ghostbusters'
SELECT *
FROM Movie

UPDATE Genre SET
	GenreName = 'Action/Adventure'
WHERE GenreName = 'Action'
SELECT *
FROM Genre

DELETE FROM CastMember 
WHERE MovieID = 1
DELETE FROM Movie
WHERE MovieID = 1
SELECT *
FROM Movie

ALTER TABLE Actor
ADD DateOfDeath VARCHAR

ALTER TABLE Actor
ALTER COLUMN DateOfDeath DATE

UPDATE Actor SET
	DateOfDeath = '3/4/1994'
WHERE	FirstName = 'John' AND
		LastName = 'Candy'

SELECT *
FROM Actor