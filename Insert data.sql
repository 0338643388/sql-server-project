
INSERT INTO Department(DepartmentID, DepartmentName, EstablishedYear) 
VALUES
    ('IT', 'Information Technology', 1995),
    ('PHY', 'Physics', 1970),
	('AC', 'Accounting', 1980)

INSERT INTO AcademicYear(AcademicYearID, StartYear, EndYear) 
VALUES
    ('K1', 2002, 2006),
    ('K2', 2003, 2007),
    ('K3', 2004, 2008)

INSERT INTO Subject(SubjectID, DepartmentID, SubjectName) 
VALUES 
    ('AM01', 'IT', 'Advanced Mathematics'),
    ('DA01', 'IT', 'Database'),
    ('DM01', 'IT', 'Discrete Mathematics'),
    ('DS01', 'IT', 'Data Structures'),
    ('OS01', 'IT', 'Operating Systems'),
	('AP01', 'AC', 'Accounting Principles'),
	('ST01', 'AC', 'Statistical Ttheory'),
	('TM01', 'PHY', 'Technical Mathematics')


INSERT INTO Program(ProgramID, ProgramName) 
VALUES 
    ('REG', 'Regular Program')

INSERT INTO Class(ClassID, DepartmentID, AcademicYearID, ProgramID, SerialNo) 
VALUES
    ('ITK1/01', 'IT', 'K1', 'REG', 1),
    ('ITK1/02', 'IT', 'K1', 'REG', 2),
    ('ITK2/01', 'IT', 'K2', 'REG', 1),
    ('ITK2/02', 'IT', 'K2', 'REG', 2),
    ('ACCK1/01', 'AC', 'K1', 'REG', 1),
    ('ACCK2/01', 'AC', 'K2', 'REG', 1),
    ('PHYK1/01', 'PHY', 'K1', 'REG', 1),
    ('PHYK2/01', 'PHY', 'K2', 'REG', 1)


INSERT INTO Student(StudentID, StudentName, BirthYear, Ethnicity, ClassID)
VALUES
    ('IT2001', N'Đinh Hồng Hạnh', 1984, N'Kinh', 'ITK1/01'),
    ('IT2002', N'Dương Thúy Hòa', 1985, N'Tày', 'ITK1/01'),
    ('IT2003', N'Nguyễn Huy Hoàng', 1984, N'Nùng', 'ITK1/02'),
    ('IT2004', N'Lê Minh Cương', 1983, N'Kinh', 'ITK2/01'),
    ('ACC2001', N'Nguyễn Thị Huyền Dịu', 1985, N'Kinh', 'ACCK1/01'),
    ('ACC2002', N'Trương Thị Cẩm Vân', 1984, N'Giao', 'ACCK2/01'),
    ('PHY2001', N'Nguyễn Tùng Lâm', 1985, N'Kinh', 'PHYK1/01'),
    ('PHY2002', N'Phạm Minh Triết', 1984, N'Kinh', 'PHYK2/01')

INSERT INTO ExamResult
VALUES
    ('IT2001', 'AM01', 1, 8.0),
    ('IT2001', 'DA01', 1, 3.0),
	('IT2001', 'DA01', 2, 7.5),
    ('IT2002', 'AM01', 1, 6.5),
    ('IT2002', 'DM01', 1, 8.0),
    ('IT2003', 'DS01', 1, 4.0),
    ('IT2003', 'OS01', 1, 2.0),
	('IT2003', 'OS01', 2, 7.5),
    ('IT2004', 'AM01', 1, 8.5),
    ('IT2004', 'DA01', 1, 7.5),
	('ACC2001', 'AP01', 1, 1.0),
    ('ACC2001', 'AP01', 2, 9.0),
    ('ACC2001', 'ST01', 1, 8.5),
    ('ACC2002', 'AP01', 1, 7.5),
    ('ACC2002', 'ST01', 1, 6.5),
    ('PHY2001', 'TM01', 1, 4.0),
	('PHY2001', 'TM01', 2, 7.5),
    ('PHY2001', 'AM01', 1, 8.0),
    ('PHY2002', 'TM01', 1, 6.5),
    ('PHY2002', 'AM01', 1, 7.0)

INSERT INTO Teaching
VALUES
    ('REG', 'IT', 'AM01', 2003, 1, 60, 30, 5),
    ('REG', 'IT', 'DA01', 2003, 2, 45, 30, 4),
    ('REG', 'IT', 'DM01', 2004, 1, 45, 30, 4),
    ('REG', 'IT', 'DS01', 2004, 2, 50, 25, 4),
    ('REG', 'IT', 'OS01', 2004, 1, 40, 20, 3),
    ('REG', 'AC', 'AP01', 2003, 1, 60, 30, 5),
    ('REG', 'AC', 'ST01', 2003, 2, 50, 30, 4),
    ('REG', 'PHY', 'TM01', 2003, 1, 70, 40, 5)
