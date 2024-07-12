--Program must only be 'REG', 'JC', or 'MAS'
ALTER TABLE Program
ADD CONSTRAINT CHK_Program_ProgramID
CHECK (ProgramID IN ('REG', 'JC', 'MAS'))

INSERT INTO Program(ProgramID, ProgramName) 
VALUES 
    ('JC', 'Junior College'),
	('MAS', 'Master')


--There can only be 2 semesters, 'S1' and 'S2'
ALTER TABLE Teaching
ALTER COLUMN Semester varchar(2)

UPDATE Teaching
SET Semester = 'S1'
WHERE Semester = '1'

UPDATE Teaching
SET Semester = 'S2'
WHERE Semester = '2'

ALTER TABLE Teaching
ADD CONSTRAINT CHK_Teaching_Semester
CHECK (Semester IN ('S1', 'S2'))

--The maximum number of theoretical hours is 120

ALTER TABLE Teaching
ADD CONSTRAINT CHK_Teaching_TheoryHours
CHECK (TheoryHours <= 120)

--The maximum number of practical hours is 60
ALTER TABLE Teaching
ADD CONSTRAINT CHK_Teaching_PracticalHours
CHECK (PracticalHours <= 60)

--The maximum number of credits for a subject is 6
ALTER TABLE Teaching
ADD CONSTRAINT CHK_Teaching_Credits
CHECK (Credits <= 6)

--Exam scores (ExamResult.Score) are graded on a scale of 10 and precise to 0.5 
--(do this in two ways: validate and raise an error if not compliant; 
--automatically round if not compliant with the precision requirement)
ALTER TABLE ExamResult
ADD CONSTRAINT CHK_ExamResult_Score
CHECK(Score >=0 AND Score <= 10)

--Rounding convention to 0.5:
--Below 0.25, round down to .0
--From 0.25 to 0.75, round to 0.5
--From 0.75, round up to 1

CREATE FUNCTION fn_round_score(
	@score FLOAT
)
RETURNS FLOAT
AS
BEGIN
	DECLARE @temp INT
	
	SET @temp = FLOOR(@score)

	IF(@score - @temp < 0.25)
		SET @score = @temp
	ELSE
		IF(@score - @temp > 0.75)
			SET @score = @temp + 1
		ELSE 
			SET @score = @temp + 0.5

	RETURN @temp

END

CREATE TRIGGER trg_score
ON ExamResult
FOR UPDATE, INSERT
AS
BEGIN
	UPDATE ExamResult
	SET Score = dbo.fn_round_score(i.Score)
	FROM ExamResult e
	JOIN inserted i
	ON e.StudentID = i.StudentID
	AND e.SubjectID = i.SubjectID
	AND e.ExamAttempt = i.ExamAttempt
END

--The end year of the course must be greater than or equal to the start year
ALTER TABLE AcademicYear
ADD CONSTRAINT CHK_AcademicYear_ValidPeriod
CHECK (EndYear >= StartYear)

CREATE TRIGGER trg_ValidPeriod
ON AcademicYear
FOR UPDATE, INSERT
AS
BEGIN
	IF(EXISTS (SELECT *
				FROM inserted
				WHERE EndYear < StartYear))
		BEGIN
			RAISERROR('YEAR IS INVALID', 16, 1)
			ROLLBACK
		END
END

--The number of theoretical hours for each teaching schedule should not be less than the number of practical hours
ALTER TABLE Teaching
ADD CONSTRAINT CHK_Teaching_Hours
CHECK (TheoryHours >= PracticalHours)

--Program names must be unique
ALTER TABLE Program
ADD CONSTRAINT UQ_Program_ProgramName UNIQUE(ProgramName)

--Department names must be unique
ALTER TABLE Department
ADD CONSTRAINT UQ_Department_DepartmentName UNIQUE(DepartmentName)

--A student can take an exam in a subject a maximum of 2 times
ALTER TABLE ExamResult
ADD CONSTRAINT CHK_ExamResult_MaxAttempts
CHECK (ExamAttempt <= 2)

-- The start year of the course for a class cannot be earlier than the establishment year of the department managing the class
CREATE TRIGGER trg_class
ON Class
FOR UPDATE, INSERT
AS
BEGIN
	IF(EXISTS (
				SELECT *
				FROM inserted
				LEFT JOIN AcademicYear
				ON inserted.AcademicYearID = AcademicYear.AcademicYearID
				LEFT JOIN Department
				ON inserted.DepartmentID = Department.DepartmentID
				WHERE AcademicYear.StartYear < Department.EstablishedYear))
		ROLLBACK
END

CREATE TRIGGER trg_AcademicYear
ON AcademicYear
FOR UPDATE, INSERT
AS
BEGIN
	IF(EXISTS (
				SELECT *
				FROM inserted
				LEFT JOIN Class
				ON inserted.AcademicYearID = Class.AcademicYearID
				LEFT JOIN Department
				ON Class.DepartmentID = Department.DepartmentID
				WHERE inserted.StartYear < Department.EstablishedYear))
		ROLLBACK
END

CREATE TRIGGER trg_Department
ON Department
FOR UPDATE, INSERT
AS
BEGIN
	IF(EXISTS (
				SELECT *
				FROM inserted
				LEFT JOIN Class
				ON inserted.DepartmentID = Class.DepartmentID
				LEFT JOIN AcademicYear
				ON Class.AcademicYearID = AcademicYear.AcademicYearID
				WHERE AcademicYear.StartYear< inserted.EstablishedYear))
		ROLLBACK
END


--Add an attribute ClassSize to the Class table and ensure the class size matches the number of students currently enrolled in the class
ALTER TABLE Class
ADD ClassSize INT

CREATE FUNCTION fn_class_size(
	@classID VARCHAR(10)
)
RETURNS INT
AS
BEGIN
	DECLARE @size INT
	SELECT @size = COUNT(*)
	FROM Student
	WHERE ClassID = @classID

	RETURN @size
END

CREATE TRIGGER trg_class_size
ON Student 
FOR UPDATE, INSERT
AS
BEGIN
	DECLARE @size INT
	DECLARE @classID VARCHAR(10)

	SELECT @classID = ClassID
	FROM inserted

	SELECT @size = COUNT(*)
	FROM Student
	WHERE ClassID = @classID

	UPDATE Class
	SET ClassSize = @size
	WHERE ClassID = @classID

END

CREATE TRIGGER trg_class_size_del
ON Student 
FOR DELETE
AS
BEGIN
	DECLARE @size INT
	DECLARE @classID VARCHAR(10)

	SELECT @classID = ClassID
	FROM deleted

	SELECT @size = COUNT(*)
	FROM Student
	WHERE ClassID = @classID

	UPDATE Class
	SET ClassSize = @size
	WHERE ClassID = @classID

END

UPDATE Class
SET ClassSize = dbo.fn_class_size(ClassID)