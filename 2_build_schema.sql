-- Make sure schema exists
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'ex02')
    EXEC('CREATE SCHEMA ex02');

-- Drop tables safely
IF OBJECT_ID('ex02.Employees', 'U') IS NOT NULL DROP TABLE ex02.Employees;
IF OBJECT_ID('ex02.Departments', 'U') IS NOT NULL DROP TABLE ex02.Departments;
GO

-- Create Departments table
CREATE TABLE ex02.Departments (
    DeptID INT IDENTITY(1,1) PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL,
    Budget DECIMAL(10,2) NOT NULL
);
GO

-- Create Employees table
CREATE TABLE ex02.Employees (
    EmpID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DeptID INT NOT NULL FOREIGN KEY REFERENCES ex02.Departments(DeptID),
    Salary DECIMAL(10,2) NOT NULL,
    HireDate DATE NOT NULL
);
GO

-- Merge Departments
MERGE ex02.Departments AS target
USING (VALUES
    ('Sales', 50000),
    ('IT', 75000),
    ('HR', 30000),
    ('Finance', 60000),
    ('Marketing', 40000)
) AS source(DeptName, Budget)
ON target.DeptName = source.DeptName
WHEN MATCHED THEN
    UPDATE SET target.Budget = source.Budget
WHEN NOT MATCHED THEN
    INSERT (DeptName, Budget) VALUES (source.DeptName, source.Budget);
GO

-- Merge Employees
MERGE ex02.Employees AS target
USING (VALUES
    ('John','Doe',1,4000,'2021-01-15'),
    ('Jane','Smith',2,5000,'2020-03-20'),
    ('Alice','Johnson',3,3500,'2019-07-12'),
    ('Bob','Brown',1,4200,'2022-05-05'),
    ('Carol','Davis',2,4800,'2021-09-01'),
    ('Eve','Wilson',4,5500,'2018-11-30'),
    ('Frank','Miller',5,3900,'2020-06-17')
) AS source(FirstName, LastName, DeptID, Salary, HireDate)
ON target.FirstName = source.FirstName
   AND target.LastName = source.LastName
   AND target.DeptID = source.DeptID
WHEN MATCHED THEN 
    UPDATE SET target.Salary = source.Salary, target.HireDate = source.HireDate
WHEN NOT MATCHED THEN
    INSERT (FirstName, LastName, DeptID, Salary, HireDate)
    VALUES (source.FirstName, source.LastName, source.DeptID, source.Salary, source.HireDate);
GO
