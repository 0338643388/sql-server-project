CREATE DATABASE Student_management

USE Student_management
GO

CREATE TABLE Department(
    DepartmentID VARCHAR(10) PRIMARY KEY,
    DepartmentName VARCHAR(30),
    EstablishedYear INT
)

CREATE TABLE Subject(
    SubjectID VARCHAR(10) PRIMARY KEY,
    DepartmentID VARCHAR(10) NOT NULL,
    SubjectName VARCHAR(100),
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
)

CREATE TABLE Program(
    ProgramID VARCHAR(10) PRIMARY KEY,
    ProgramName VARCHAR(100)
)

CREATE TABLE AcademicYear(
    AcademicYearID VARCHAR(10) PRIMARY KEY,
    StartYear INT,
    EndYear INT
)

CREATE TABLE Class(
    ClassID VARCHAR(10) PRIMARY KEY,
    DepartmentID VARCHAR(10) NOT NULL,
    AcademicYearID VARCHAR(10) NOT NULL,
    ProgramID VARCHAR(10) NOT NULL,
    SerialNo INT,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    FOREIGN KEY (AcademicYearID) REFERENCES AcademicYear(AcademicYearID),
    FOREIGN KEY (ProgramID) REFERENCES Program(ProgramID)
)

CREATE TABLE Student(
    StudentID VARCHAR(10) PRIMARY KEY,
    ClassID VARCHAR(10) NOT NULL,
    StudentName NVARCHAR(100),
    BirthYear INT,
    Ethnicity NVARCHAR(30),
    FOREIGN KEY (ClassID) REFERENCES Class(ClassID)
)

CREATE TABLE ExamResult(
    StudentID VARCHAR(10) NOT NULL,
    SubjectID VARCHAR(10) NOT NULL,
    ExamAttempt INT,
    Score FLOAT,
    PRIMARY KEY (StudentID, SubjectID, ExamAttempt),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (SubjectID) REFERENCES Subject(SubjectID)
)

CREATE TABLE Teaching(
    ProgramID VARCHAR(10) NOT NULL,
    DepartmentID VARCHAR(10) NOT NULL,
    SubjectID VARCHAR(10) NOT NULL,
    AcademicYear INT,
    Semester INT,
    TheoryHours INT,
    PracticalHours INT,
    Credits INT,
    PRIMARY KEY (ProgramID, DepartmentID, SubjectID),
    FOREIGN KEY (ProgramID) REFERENCES Program(ProgramID),
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    FOREIGN KEY (SubjectID) REFERENCES Subject(SubjectID)
)
