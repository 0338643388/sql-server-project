--Given a student ID and a department ID, check if the student belongs to that department (return true or false)
CREATE FUNCTION fn_check_student_belong_to_department(
	@studentID VARCHAR(10),
	@departmentID VARCHAR(10)
)
RETURNS VARCHAR(10)
AS
BEGIN
	DECLARE @result VARCHAR(5)
	SET @result = 'FALSE'

	IF (EXISTS (SELECT Student.StudentID
	FROM Student
	LEFT JOIN Class
	ON Student.ClassID = Class.ClassID
	LEFT JOIN Department
	ON Class.DepartmentID = Department.DepartmentID
	WHERE StudentID = @studentID
	  AND Department.DepartmentID = @departmentID))
	  SET @result = 'TRUE'
	
	RETURN @result
END

-- TESTING
SELECT dbo.fn_check_student_belong_to_department('ACC2001', 'AC')
SELECT dbo.fn_check_student_belong_to_department('IT2001', 'IT')

--Given a student ID and a subject ID, find the latest exam score of a student in a specific subject
CREATE FUNCTION fn_find_last_exam_score_of_student(
	@studentID VARCHAR(10), 
	@subjectID VARCHAR(10)
)
RETURNS FLOAT
AS
BEGIN
	DECLARE @result FLOAT
	SET @result = 0

	SELECT TOP 1 @result = Score
	FROM ExamResult
	WHERE StudentID = @studentID
	  AND SubjectID = @subjectID
	ORDER BY ExamAttempt DESC

	RETURN @result
END

-- TESTING
SELECT dbo.fn_find_last_exam_score_of_student('IT2001', 'DA01')
SELECT dbo.fn_find_last_exam_score_of_student('IT2002', 'AM01')

--Given a student ID, Calculate the average score of a student (note: the average score is based on the latest exam attempt),
--using the function written in requirement 2
CREATE FUNCTION fn_cal_avg_score_of_student(
	@studentID VARCHAR(10)
)
RETURNS FLOAT
AS
BEGIN
	DECLARE @result FLOAT

	SELECT @result = ROUND(AVG(score), 3)
	FROM (
		SELECT dbo.fn_find_last_exam_score_of_student(@studentID, SubjectID) AS	score
		FROM ExamResult
		WHERE StudentID = @studentID
		GROUP BY SubjectID
	) sub

	RETURN @result
END

-- TESTING
SELECT dbo.fn_cal_avg_score_of_student('IT2001')

--Input a student ID and a subject ID, return the exam scores of that student in the specified subject
CREATE FUNCTION fn_all_score_of_subject_of_student(
	@studentID VARCHAR(10),
	@subjectID VARCHAR(10)
)
RETURNS TABLE
RETURN 
	SELECT	
		ExamAttempt,
		Score
	FROM ExamResult
	WHERE StudentID = @studentID
	  AND SubjectID = @subjectID

--TESTING
SELECT * FROM dbo.fn_all_score_of_subject_of_student('IT2001', 'DA01')

--Input a student ID, return the list of subjects that the student needs to take
CREATE FUNCTION fn_list_subject_for_student(
	@studentID VARCHAR(10)
)
RETURNS TABLE
RETURN 
	SELECT SubjectName
	FROM Subject
	LEFT JOIN Class
	ON Subject.DepartmentID = Class.DepartmentID
	LEFT JOIN Student
	ON Class.ClassID = Student.ClassID
	WHERE StudentID = @studentID

-- TESTING
SELECT * FROM dbo.fn_list_subject_for_student('IT2002')

--Input class ID, Print the list of students in a class
CREATE PROC sp_list_student_of_class(
	@classID VARCHAR(10)
)
AS
BEGIN
	SELECT *
	FROM Student
	WHERE ClassID = @classID
END

EXEC sp_list_student_of_class 'ITK1/01'

--Input 2 students and a subject, determine which student has a higher score in their first attempt at that subject

CREATE FUNCTION fn_first_time_score(
	@studentID VARCHAR(10),
	@subjectID VARCHAR(10)
)
RETURNS FLOAT
AS
BEGIN
	DECLARE @result VARCHAR(10)

	SELECT @result = Score
	FROM ExamResult
	WHERE ExamAttempt = 1
	  AND StudentID = @studentID
	  AND SubjectID = @subjectID

	RETURN @result
END

CREATE PROC sp_compare_first_score_of_two_student(
	@student1ID VARCHAR(10), 
	@student2ID VARCHAR(10),
	@subjectID VARCHAR(10)
)
AS
BEGIN
	DECLARE @rs1 FLOAT
	DECLARE @rs2 FLOAT
	SET @rs1 = dbo.fn_first_time_score(@student1ID, @subjectID)
	SET @rs2 = dbo.fn_first_time_score(@student2ID, @subjectID)

	IF(@rs1 > @rs2)
		PRINT @student1ID
	ELSE 
		PRINT @student2ID
END

--TESTING
EXEC sp_compare_first_score_of_two_student 'IT2001', 'IT2004', 'AM01'

--Input a subject ID and a student ID, check if the student passed the subject in their first attempt. If passed, output "Passed", otherwise output "Failed"
CREATE PROC sp_check_student_pass_first_exam_attempt(
	@studentID VARCHAR(10),
	@subjectID VARCHAR(10)
)
AS
BEGIN
	DECLARE @result VARCHAR(10)

	SELECT @result = Score
	FROM ExamResult
	WHERE SubjectID = @subjectID
	  AND StudentID = @studentID
	  AND ExamAttempt = 1

	IF(@result > 5)
		PRINT 'PASSED'
	ELSE 
		PRINT 'FAILED'
END	

--TESTING
EXEC sp_check_student_pass_first_exam_attempt 'IT2001', 'DA01'
EXEC sp_check_student_pass_first_exam_attempt 'IT2001', 'AM01'

--Input a department ID, print the list of students (student ID, name, birth year) in that department
ALTER PROC sp_list_student_of_department(
	@departmentID VARCHAR(10)
)
AS
BEGIN
	SELECT Student.*
	FROM Student
	LEFT JOIN Class
	ON Student.ClassID = Class.ClassID
	LEFT JOIN Department
	ON Class.DepartmentID = Department.DepartmentID
	WHERE Department.DepartmentID = @departmentID
END	

--TESTING
EXEC sp_list_student_of_department 'IT'

--Input a student ID and a subject ID, print the exam scores of that student for each attempt of the subject
CREATE PROC sp_all_score_of_subject_of_student(
	@studentID VARCHAR(10),
	@subjectID VARCHAR(10)
)
AS
BEGIN
	SELECT 
		ExamAttempt,
		Score
	FROM ExamResult
	WHERE StudentID = @studentID
	  AND SubjectID = @subjectID
END
--TESTING
EXEC sp_all_score_of_subject_of_student 'IT2001', 'DA01'

--Input a student ID, print the list of subjects that the student needs to take
CREATE PROC sp_list_subject_need_to_take_of_student(
	@studentID VARCHAR(10)
)
AS
BEGIN
	SELECT SubjectName
	FROM Subject
	LEFT JOIN Department
	ON Subject.DepartmentID = Department.DepartmentID
	LEFT JOIN Class
	ON Department.DepartmentID = Class.DepartmentID
	LEFT JOIN Student
	ON Class.ClassID = Student.ClassID
	WHERE StudentID = @studentID
END
--TESTING
EXEC sp_list_subject_need_to_take_of_student 'IT2001'

--Input a subject, print the list of students who passed the subject in their first attempt
CREATE PROC sp_list_student_pass_first_examattempt(
	@subjectID VARCHAR(10)
)
AS
BEGIN
	SELECT Student.*
	FROM Student
	LEFT JOIN ExamResult
	ON Student.StudentID = ExamResult.StudentID
	WHERE Score > 4
	  AND ExamAttempt = 1
	  AND SubjectID = @subjectID
END
--TESTING
EXEC sp_list_student_pass_first_examattempt 'AM01'

--Print the scores of the subjects for the student with the given student ID, considering only the latest attempt for each subject
CREATE PROC sp_score_of_subjects_of_student(
	@studentID VARCHAR(10)
)
AS
BEGIN
	SELECT *
	FROM ExamResult e1
	WHERE StudentID = @studentID
	  AND ExamAttempt = (SELECT MAX(ExamAttempt)
						 FROM ExamResult e2
						 WHERE e1.StudentID = e2.StudentID
						   AND e1.SubjectID = e2.SubjectID)
END

--TESTING
EXEC sp_score_of_subjects_of_student 'IT2001'

--Regulation: The result of a student is "Pass" if their average score (only considering subjects with scores) is greater than or equal to 5 
--and they have no more than 2 subjects with scores below 4. 
--Otherwise, the result is "Fail". Enter data into the classification table. 

--For students with a "Pass" result, the academic performance is classified as follows:

--Average score >= 8: Academic performance is "Excellent"
--7 <= Average score < 8: Academic performance is "Good"
--Otherwise: Academic performance is "Average"

CREATE FUNCTION fn_check_conditional(
	@studentID VARCHAR(10)
)
RETURNS VARCHAR(10)
AS
BEGIN
	DECLARE @result VARCHAR(10)
	DECLARE @avg FLOAT 
	DECLARE @cnt INT

	SET @avg = (SELECT dbo.fn_cal_avg_score_of_student(@studentID))

	SELECT @cnt = COUNT(*)
	FROM (
		SELECT 
			StudentID,
			SubjectID
		FROM ExamResult
		WHERE StudentID = @studentID
		  AND dbo.fn_find_last_exam_score_of_student(StudentID, SubjectID) <= 4
		GROUP BY StudentID, SubjectID) sub

	IF(@avg = NULL)
		SET @result = NULL 
	IF(@avg >= 5 AND @cnt <= 2)
		SET @result = 'PASS'
	ELSE 
		SET @result = 'FAIL'

	RETURN @result
END

CREATE FUNCTION fn_rating_of_student(
	@studentID VARCHAR(10)
)
RETURNS VARCHAR(10)
AS
BEGIN
	DECLARE @result VARCHAR(10)

	IF(dbo.fn_check_conditional(@studentID) = 'PASS')
		BEGIN
			IF(dbo.fn_cal_avg_score_of_student(@studentID) >= 8)
				SET @result = 'Excellent'
				ELSE
					IF(dbo.fn_cal_avg_score_of_student(@studentID) >= 7)
						SET @result = 'Good'
					ELSE 
						SET @result = 'Average'
		END
	ELSE 
		SET @result = NULL

	RETURN @result
END

-- USE VIEW
CREATE VIEW vw_rating
AS
	SELECT 
		StudentName,
		dbo.fn_cal_avg_score_of_student(StudentID) AS [average score],
		dbo.fn_check_conditional(StudentID) AS result,
		dbo.fn_rating_of_student(StudentID) AS rating
	FROM Student

SELECT * FROM vw_rating

-- UPDATE A NEW TABLE
CREATE TABLE Classification(
	StudentID VARCHAR(10),
	AverageScore FLOAT,
	Result VARCHAR(10),
	Rating VARCHAR(10)

	FOREIGN KEY (StudentID) REFERENCES Student(StudentID)
)

INSERT Classification(StudentID)
SELECT StudentID FROM Student

SELECT * FROM Classification

UPDATE Classification
SET AverageScore = dbo.fn_cal_avg_score_of_student(StudentID)

UPDATE Classification
SET Result = dbo.fn_check_conditional(StudentID)

UPDATE Classification
SET Rating = dbo.fn_rating_of_student(StudentID)
