--List of students in the "Information Technology" department for the academic year 2002-2006.
SELECT Student.*
FROM Student
LEFT JOIN Class
ON Student.ClassID = Class.ClassID
LEFT JOIN Department
ON Class.DepartmentID = Department.DepartmentID
LEFT JOIN AcademicYear
ON Class.AcademicYearID = AcademicYear.AcademicYearID
WHERE DepartmentName = 'Information Technology'
  AND StartYear = 2002
  AND EndYear = 2006

select * from Class
--Information (Student ID, Name, Year of Birth) of students who started studying earlier than the regulated age 
--(students must be at least 18 years old at the start of the academic year).
SELECT 
	StudentID,
	StudentName,
	BirthYear
FROM Student
LEFT JOIN Class
ON Student.ClassID = Class.ClassID
LEFT JOIN AcademicYear 
ON Class.AcademicYearID = AcademicYear.AcademicYearID
WHERE StartYear - BirthYear < 18

--Students in the IT department for the academic year 2002-2006 who have not taken the "Data Structures" course.
SELECT Student.*
FROM Student
LEFT JOIN Class
ON Student.ClassID = Class.ClassID
LEFT JOIN Department
ON Class.DepartmentID = Department.DepartmentID
LEFT JOIN AcademicYear
ON Class.AcademicYearID = AcademicYear.AcademicYearID
WHERE StartYear = 2002
  AND EndYear = 2006
  AND DepartmentName = 'Information Technology'
  AND StudentID NOT IN (
						SELECT Student.StudentID
						FROM Student 
						LEFT JOIN ExamResult
						ON Student.StudentID = ExamResult.StudentID
						LEFT JOIN Subject
						ON ExamResult.SubjectID = Subject.SubjectID
						WHERE SubjectName = 'Data Structures'
						)

--Students who failed (Score <5) the "Data Structures" course but have not retaken the exam.
SELECT Student.*
FROM Student 
LEFT JOIN ExamResult
ON Student.StudentID = ExamResult.StudentID
LEFT JOIN Subject
ON ExamResult.SubjectID = Subject.SubjectID
WHERE SubjectName = 'Data Structures'
  AND Score < 5
  AND Student.StudentID NOT IN (
								SELECT Student.StudentID
								FROM Student 
								LEFT JOIN ExamResult
								ON Student.StudentID = ExamResult.StudentID
								LEFT JOIN Subject
								ON ExamResult.SubjectID = Subject.SubjectID
								WHERE SubjectName = 'Data Structures'
								  AND ExamAttempt > 1
								)
--For each class in the IT department, provide the class ID, academic year ID, program name, and the number of students in that class.
SELECT 
	Class.ClassID,
	AcademicYearID,
	ProgramName,
	COUNT(StudentID) AS Quantity_of_class
FROM Class 
LEFT JOIN Department
ON Class.DepartmentID = Department.DepartmentID
LEFT JOIN Student
ON Class.ClassID = Student.ClassID
LEFT JOIN Program
ON Class.ProgramID = Program.ProgramID
WHERE DepartmentName = 'Information Technology'
GROUP BY Class.ClassID,
		AcademicYearID,
		ProgramName

--The average score of the student with the ID IT2001 (average score calculated based on the latest exam attempt).
SELECT ROUND(AVG(kq.Score), 2) AS AverageScore
FROM ExamResult kq
JOIN (
    SELECT 
		StudentID, 
		SubjectID, 
		MAX(ExamAttempt) AS LatestAttempt
    FROM ExamResult
    WHERE StudentID = 'IT2003'
    GROUP BY StudentID, SubjectID
) latest_attempts 
ON kq.StudentID = latest_attempts.StudentID 
AND kq.SubjectID = latest_attempts.SubjectID
AND kq.ExamAttempt = latest_attempts.LatestAttempt

--The average score of each student(average score calculated based on the latest exam attempt).

SELECT 
	kq.StudentID, 
	ROUND(AVG(kq.Score), 2) AS AverageScore
FROM ExamResult kq
JOIN (
    SELECT 
		StudentID, 
		SubjectID, 
		MAX(ExamAttempt) AS LatestAttempt
    FROM ExamResult
    GROUP BY StudentID, SubjectID
) latest_attempts 
ON kq.StudentID = latest_attempts.StudentID 
AND kq.SubjectID = latest_attempts.SubjectID
AND kq.ExamAttempt = latest_attempts.LatestAttempt
GROUP BY kq.StudentID

--List the top 3 students with the highest average scores across all subjects in the IT department
SELECT 
	TOP 3 StudentName,
	AVG(Score) AS AverageScore
FROM ExamResult
LEFT JOIN Student
ON ExamResult.StudentID = Student.StudentID
LEFT JOIN Class
ON Class.ClassID = Student.ClassID
LEFT JOIN Department
ON Class.DepartmentID = Department.DepartmentID
WHERE DepartmentName = 'Information Technology'
GROUP BY StudentName
ORDER BY AverageScore DESC
