--Keith Meyer, Karan Gupta, Maliq Lee, and Jing Yang

CREATE DATABASE Guptak3
GO

USE Guptak3
GO

CREATE TABLE Users (
	UserID		INT			NOT NULL PRIMARY KEY IDENTITY,
	Username	varchar(30) NOT NULL	UNIQUE,
	FirstName	varchar(30) NOT NULL,
	LastName	varchar(30) NOT NULL,
	MiamiStudent	bit		NOT NULL
);

CREATE TABLE UserPreferences (
	UserID				INT			NOT NULL	FOREIGN KEY REFERENCES Users,
	FavoriteType		varchar(30) NOT NULL,
	LeastFavoriteType	varchar(30) NOT NULL
);

CREATE TABLE Facts (
	FactID		INT			NOT NULL PRIMARY KEY IDENTITY,
	VisibleId INT NOT NULL UNIQUE,
	Type		varchar(30) NOT NULL,
	Content		TEXT		NOT NULL,
	Longitude	DECIMAL(9,6),
	Latitude	DECIMAL(9,6),
	Date		DATE		NOT NULL,
);

CREATE TABLE SeenFacts (
	UserID INT NOT NULL		FOREIGN KEY REFERENCES Users,
	FactID INT NOT NULL		FOREIGN KEY REFERENCES Facts
);

CREATE TABLE Quizzes (
	QuizID				INT NOT NULL PRIMARY KEY IDENTITY,
	Name	varchar(30)	NOT NULL UNIQUE,
	Date	varchar(30)	NOT NULL,
	NumberOfQuestions	INT NOT NULL
);

CREATE TABLE CompletedQuizzes (
	QuizID	INT NOT NULL	FOREIGN KEY REFERENCES Quizzes,
	UserID	INT NOT NULL	FOREIGN KEY REFERENCES Users,	
	Score	INT NOT NULL
);

CREATE TABLE Questions (
	QuestionID INT NOT NULL PRIMARY KEY IDENTITY,
	VisibleId INT NOT NULL UNIQUE,
	QuizID INT NOT NULL		FOREIGN KEY References Quizzes,
	Content TEXT NOT NULL,
	CorrectAnswer varchar(50) NOT NULL,
	Incorrect1 varchar(50) NOT NULL,
	Incorrect2 varchar(50) NOT NULL,
	Incorrect3 varchar(50) NOT NULL
);

GO
--========================================================= Stored Procedures

--=====================================================Stored Procedure Create User (username, firstname, lastname, miamistudent)
CREATE PROCEDURE spCreateUser
	@Username varchar(30),
	@FirstName varchar(30),
	@LastName varchar(30),
	@MiamiStudent bit = 0
AS
BEGIN
	IF NOT EXISTS(
		SELECT Username
		FROM Users
		WHERE @Username = Username
	)
	BEGIN
		INSERT INTO Users (Username, FirstName, LastName, MiamiStudent)
		VALUES (@Username, @FirstName, @LastName, @MiamiStudent)
	END
END
GO
--=====================================================Stored Procedure Get User(username)
CREATE PROCEDURE spGetUser
	@Username varchar(30)
AS

SELECT *
FROM Users
WHERE Username = @Username

GO

--========================================================= Stored Procedure Set UserPref

CREATE PROCEDURE spSetUserPreference
	@userName varchar(30),
	@favoriteType varchar(30) = NULL,
	@leastFavorite varchar(30) = NULL
AS
BEGIN
	DECLARE @userId int
	SELECT @userId = UserID FROM Users WHERE Username = @userName

	IF EXISTS(SELECT * FROM UserPreferences WHERE UserID=@userId)	
			UPDATE	UserPreferences
			SET		FavoriteType=@favoriteType, LeastFavoriteType=@leastFavorite 
			WHERE	UserID=@userId
		
	ELSE
			INSERT INTO UserPreferences (UserID, FavoriteType, LeastFavoriteType)
			VALUES (
				@userId, @favoriteType, @leastFavorite
			)
	END

GO

--=====================================================Stored Procedure Get UserPref(username)
CREATE PROCEDURE spGetUserPreference
	@username varchar(30)
AS
	SELECT u.UserID, u.Username, up.FavoriteType, up.LeastFavoriteType
	FROM Users u
		JOIN UserPreferences up
			ON u.UserID=up.UserID
	WHERE u.Username=@username

GO
--=========================================================StoredProcedure Create Quiz
CREATE PROCEDURE spCreateQuiz
	@quizName varchar(30),
	@date DATE,
	@numberOfQuestions int
AS
BEGIN
	IF NOT EXISTS(Select * FROM Quizzes WHERE Name = @quizName)
	INSERT INTO Quizzes ([Name], [Date], NumberOfQuestions)
	VALUES (@quizName, @date, @numberOfQuestions)
END
GO

--=========================================================StoredProcedure Set Completed
CREATE PROCEDURE spSetCompleted
	@quizName varchar(30),
	@username varchar(30),
	@score int = 0
AS
BEGIN
	DECLARE @quizId int
	SELECT @quizId = QuizID FROM Quizzes WHERE @quizName = Name

	DECLARE @userId int
	SELECT @userId = UserID FROM Users WHERE Username = @userName
	IF NOT EXISTS(Select * FROM CompletedQuizzes WHERE QuizID=@quizId AND UserID=@userId)
		INSERT INTO CompletedQuizzes(QuizId, UserId, Score)
		VALUES (@quizId, @userId, @score)
	END
GO

--========================================================= Stored Procedure Update Quiz Score
CREATE PROCEDURE spUpdateQuizScore
	@quizName varchar(30),
	@username varchar(30),
	@score int = 0
AS
BEGIN

	DECLARE @quizId int
	SELECT @quizId = QuizID FROM Quizzes WHERE @quizName = Name

	DECLARE @userId int
	SELECT @userId = UserID FROM Users WHERE Username = @userName

	IF EXISTS(Select * FROM CompletedQuizzes WHERE QuizID=@quizId AND UserID=@userId)
		UPDATE CompletedQuizzes
		SET	Score=@score
		WHERE QuizID=@quizId AND UserID=@userId
	ELSE
		INSERT INTO CompletedQuizzes (QuizID, UserID, Score)
		VALUES (@quizId, @userId, @score)
END

GO

--========================================================= Stored Procedures Get Quiz
CREATE PROCEDURE spGetQuiz
	@quizName varchar(30)
AS

	SELECT *
	FROM Quizzes
	WHERE Name = @quizName
GO

--========================================================= Stored Procedures Get Completed
CREATE PROCEDURE spGetCompleted
	@username varchar(30)
AS
	SELECT *
	FROM Users u
		JOIN CompletedQuizzes cq
			ON u.UserID=cq.UserID
	WHERE u.Username=@username

GO

--========================================================= Stored Procedures Create Question
CREATE PROCEDURE spCreateQuestion
	@questionId INT,
	@quizName varchar(30),
	@content text,
	@correct varchar(50),
	@incorrectOne	varchar(50),
	@incorrectTwo	varchar(50),
	@incorrectThree varchar(50)
AS	
BEGIN
	DECLARE @quizId int
	SELECT @quizId = QuizID FROM Quizzes WHERE @quizName = Name

	If EXISTS (SELECT * FROM Questions WHERE VisibleID = @questionId)
		UPDATE Questions
		SET Content=@content, CorrectAnswer=@correct, Incorrect1=@incorrectOne, Incorrect2=@incorrectTwo, Incorrect3=@incorrectThree
		WHERE VisibleId=@questionId
	ELSE

		INSERT INTO Questions (QuizID, VisibleId, Content, CorrectAnswer, Incorrect1, Incorrect2, Incorrect3)
	
		VALUES (@quizId,
			@questionId,
			@content,
			@correct,
			@incorrectOne,	
			@incorrectTwo,	
			@incorrectThree)
END
GO

--========================================================= Stored Procedures Update Question
CREATE PROCEDURE spUpdateQuestion
	@questionId INT,
	@quizName varchar(30),
	@content text,
	@correct varchar(50),
	@incorrectOne	varchar(50),
	@incorrectTwo	varchar(50),
	@incorrectThree varchar(50)
AS	
BEGIN

	DECLARE @quizId int
	SELECT @quizId = QuizID FROM Quizzes WHERE @quizName = Name

	If EXISTS (SELECT * FROM Questions WHERE VisibleID = @questionId)
		UPDATE Questions
		SET Content=@content, CorrectAnswer=@correct, Incorrect1=@incorrectOne, Incorrect2=@incorrectTwo, Incorrect3=@incorrectThree
		WHERE VisibleId=@questionId
	END
GO

--========================================================= Stored Procedures Get Question
CREATE PROCEDURE spGetQuestion
	@questionId INT
AS

	SELECT *
	FROM Questions
	WHERE VisibleId = @questionId

GO

--========================================================= Stored Procedures Get Quiz Question
CREATE PROCEDURE spGetQuizQuestion
	@quizName varchar(30)
AS
	DECLARE @quizId int
	SELECT @quizId = QuizID FROM Quizzes WHERE @quizName = Name

	SELECT *
	FROM Questions
	WHERE QuizID=@quizId

GO

--========================================================= Stored Procedures Set Fact
CREATE PROCEDURE spSetFact
	@FactId INT,
	@Type varchar(30) = NULL,
	@Content text = NULL,
	@Longitude decimal(9,6),
	@Latitude decimal (9,6),
	@Date date
AS
BEGIN 
	If EXISTS (SELECT * FROM Facts WHERE VisibleID = @FactID)
	UPDATE	Facts
	SET		Type=@Type, Content=@Content,
	Longitude=@Longitude, Latitude=@Latitude,
	date=@Date
	WHERE FactID=@FactID

ELSE 
	INSERT INTO Facts (VisibleID, Type, Content, Longitude, Latitude, Date)
		VALUES (
		@FactID, @Type, @Content, @Longitude, 
		@Latitude, @date)
END

GO

--========================================================= Stored Procedures Get Facts
CREATE PROCEDURE spGetFacts
	@amount int,
	@page int,
	@date date = null,
	@longitude decimal(9,6) = null,
	@latitude decimal(9,6) = null
AS
BEGIN
	If @date IS NULL AND @longitude IS NULL AND @latitude IS NULL
	SELECT *
	FROM Facts
	ORDER BY Type, Date
	OFFSET ((@page-1) * @amount) ROWS
	FETCH NEXT @amount ROWS ONLY

	ELSE
	SELECT *
	FROM Facts
	WHERE Date=@date
		AND Longitude=@longitude
		AND Latitude=@latitude
	ORDER BY Type, Date
	OFFSET ((@page-1) * @amount) ROWS
	FETCH NEXT @amount ROWS ONLY
END
GO

--========================================================= Stored Procedures Get Facts By Username
CREATE PROCEDURE spGetFactsByUser
	@username varchar(30),
	@amount int,
	@page int
AS

	
	DECLARE @userId int
	SELECT @userId = UserID FROM Users WHERE Username = @userName

	SELECT *
	FROM Facts f
		JOIN UserPreferences up
			ON @userId=up.UserID
	WHERE f.Type != up.LeastFavoriteType AND f.FactID NOT IN (
		SELECT sf.FactID FROM SeenFacts sf
		)
	ORDER BY f.Type, f.Date
	OFFSET ((@page-1) * @amount) ROWS
	FETCH NEXT @amount ROWS ONLY

GO	

--========================================================= Stored Procedures Set Seen
CREATE PROCEDURE spSetSeen
	@FactId INT,
	@Username varchar(30)
AS

	DECLARE @RealFactId int
	SELECT @RealFactId = FactID FROM Facts WHERE @FactId = VisibleId

	DECLARE @userId int
	SELECT @userId = UserID FROM Users WHERE Username = @userName

	INSERT INTO SeenFacts (UserID, FactID)
		VALUES (@RealFactID, @Username)

GO

--========================================================= Stored Procedures Get Seen
CREATE PROCEDURE spGetSeen
	@username varchar(30),
	@amount int,
	@page int
AS
	SELECT u.UserID, u.Username, f.*
	FROM Facts f
		JOIN SeenFacts sf
			ON f.FactID=sf.FactID
		JOIN Users u
			ON u.UserID=sf.UserID
	WHERE u.Username = @username
	ORDER BY f.Type, f.Date
	OFFSET ((@page-1) * @amount) ROWS
	FETCH NEXT @amount ROWS ONLY

GO	



--============================================================ Indexes
--========================================================= Indexes 
CREATE INDEX idxUsernames
ON Users (Username)



--=========================================================== Inserts

INSERT INTO Quizzes(Name,	Date,	NumberOfQuestions)
VALUES	('Trivia 1',	'05/11/2019',	13),
		('Trivia 2',	'05/10/2019',	12)

INSERT INTO Questions (VisibleId, QuizID,Content,CorrectAnswer,Incorrect1,Incorrect2,Incorrect3)                               
VALUES (1,1,'The beaver is the national emblem of which country?','Canada','Australia','England', 'Japan'),
(2,1,'In which movie did Humphrey Bogart play Charlie Allnut?','African Queen','Nigerian Queen','Hamlet', 'Merchant Of Venice'),
(3,1,'Which singer?s real name is Stefani Joanne Angelina Germanotta?','Lady Gaga','Nicki Minaj','Cardi B', 'Ariana Grande'),
(4,1,'How many players are there in a baseball team?','Nine','11','7','9'),
(5,1,'Which TV character said, ?Live long and prosper?','Mr Spock from Star Trek','Apu', 'Mr. Burns', 'Homer Simpson')

INSERT INTO Facts (VisibleId, [Type],	Content,	Longitude,	Latitude,	Date)
VALUES
(22,'Sports',	'A professional basketball game is 48 minutes long, not including breaks, timeouts, fouls, etc.',	1.2,	3.2,	'04/16/2018'),
(23,'Trivia',	'The original formula for Mountain Dew was invented in 1940',	2.0,	6.9,	'06/06/2018'),
(24,'Trivia',	'Camels are called "The ship of the desert"',	7.2,	1.3,	'09/12/2018'),
(25,'History',	'The Great of Fire London started on Sunday, 2 September 1666 in a bakers shop',	3.7,	4.5,	'01/02/1998'),
(26,'Video Games',	'Mario was named after the landlord of Nintendos first warehoue Mr. Mario Segale',	1.7,	2.5,	'02/19/2019'),
(27,'Video Games',	'3,333,360 points i the max score you can get in Pac-Man',	9.4,	6.1,	'02/19/2018'),
(28,'Video Games',	'Playstation 2 and Nintndo D are the best selling game consoles with about 155 million units each',	5.5,	5.5,	'04/02/2012'),
(29,'Video Games',	'The highest number human can press a controller button in a second is 16 times',	6.1,	6.3,	'10/09/2015'),
(30,'History',	'The last time the US Constitution was amended was in 1992 with the Twenty-seventh Amendment',	4.9,	3.5,	'11/09/2018'),
(31,'Trivia',	'The scientific term for brain freeze is "sphenopalatine ganglioneuralgia"',	1.1,	7.1,	'05/01/2019'),
(32,'Trivia',	'Back when dinosaurs existed, there used to be volcanoes that were erupting on the moon',	3.9,	5.9,	'08/10/2011')