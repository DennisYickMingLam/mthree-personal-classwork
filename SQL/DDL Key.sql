CREATE database MovieCatalogue;

USE MovieCatalogue;
GO

CREATE TABLE Movie (
	MovieID VARCHAR Primary Key identity,
	GenreID VARCHAR Foreign Key references Genre(GenreID) NOT NULL,
	DirectorID VARCHAR Foreign Key references Table(DirectorID),
	RatingID VARCHAR Foreign Key references [Rating Table](RatingID),
	Title VARCHAR(128) NOT NULL,
	[Release Date] DATE
)
CREATE TABLE Genre (
	GenreID VARCHAR Primary Key identity,
	GenreName VARCHAR(30) NOT NULL
)
CREATE TABLE Director (
	DirectorID VARCHAR Primary Key identity,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	BirthDate DATE
)
CREATE TABLE Rating (
	RatingID VARCHAR Primary Key identity,
	RatingName VARCHAR(5) NOT NULL
)
CREATE TABLE Actor (
	ActorID VARCHAR Primary Key identity,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30),
	BirthDate DATE
)
CREATE TABLE CastMembers (
	CastMemberID VARCHAR Primary Key identity,
	ActorID VARCHAR Foreign Key references Actor(ActorID) NOT NULL,
	MovieID VARCHAR Foreign Key references Movie(MovieID) NOT NULL,
	[Role] VARCHAR(50) NOT NULL
)