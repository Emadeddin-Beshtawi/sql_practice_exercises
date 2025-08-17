-- ============================================================
-- 2_questions_and_solution.sql – Self-contained & rerunnable
-- ============================================================

PRINT '--- Rebuilding ex02 schema ---';

-- Drop child tables first to avoid FK conflicts
IF OBJECT_ID('ex02.Employees', 'U') IS NOT NULL DROP TABLE ex02.Employees;
IF OBJECT_ID('ex02.Departments', 'U') IS NOT NULL DROP TABLE ex02.Departments;

-- Create Departments table
CREATE TABLE ex02.Departments (
    DeptID INT IDENTITY(1,1) PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL,
    Budget DECIMAL(10,2) NOT NULL
);

-- Create Employees table
CREATE TABLE ex02.Employees (
    EmpID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DeptID INT NOT NULL FOREIGN KEY REFERENCES ex02.Departments(DeptID),
    Salary DECIMAL(10,2) NOT NULL,
    HireDate DATE NOT NULL
);

-- Seed Departments using MERGE for rerunnability
MERGE ex02.Departments AS target
USING (VALUES
    ('Sales', 50000),
    ('IT', 75000),
    ('HR', 30000),
    ('Finance', 60000),
    ('Marketing', 40000)
) AS source(DeptName, Budget)
ON target.DeptName = source.DeptName
WHEN MATCHED THEN UPDATE SET Budget = source.Budget
WHEN NOT MATCHED THEN INSERT (DeptName, Budget) VALUES (source.DeptName, source.Budget);

-- Seed Employees using MERGE
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
WHEN MATCHED THEN UPDATE SET Salary = source.Salary, HireDate = source.HireDate
WHEN NOT MATCHED THEN INSERT (FirstName, LastName, DeptID, Salary, HireDate)
VALUES (source.FirstName, source.LastName, source.DeptID, source.Salary, source.HireDate);

PRINT '--- ex02 schema seeded ---';

-- ============================================================
-- 2.1 - 2.21 Solution Queries
-- ============================================================

-- 2.1 Last name of all employees
SELECT LastName FROM ex02.Employees;

-- 2.2 Last name of all employees without duplicates
SELECT DISTINCT LastName FROM ex02.Employees;

-- 2.3 Employees whose last name is 'Smith'
SELECT * FROM ex02.Employees WHERE LastName = 'Smith';

-- 2.4 Employees whose last name is 'Smith' or 'Doe'
SELECT * FROM ex02.Employees WHERE LastName IN ('Smith','Doe');

-- 2.5 Employees in department 4
SELECT * FROM ex02.Employees WHERE DeptID = 4;

-- 2.6 Employees in department 1 or 2
SELECT * FROM ex02.Employees WHERE DeptID IN (1, 2);

-- 2.7 Employees whose last name begins with 'S'
SELECT * FROM ex02.Employees WHERE LastName LIKE 'S%';

-- 2.8 Sum of all departments' budgets
SELECT SUM(Budget) AS TotalBudget FROM ex02.Departments;

-- 2.9 Number of employees in each department
SELECT DeptID, COUNT(*) AS NumEmployees
FROM ex02.Employees
GROUP BY DeptID;

-- 2.10 All employees with department data
SELECT e.*, d.*
FROM ex02.Employees e
JOIN ex02.Departments d ON e.DeptID = d.DeptID;

-- 2.11 Employee names with department name and budget
SELECT e.FirstName, e.LastName, d.DeptName, d.Budget
FROM ex02.Employees e
JOIN ex02.Departments d ON e.DeptID = d.DeptID;

-- 2.12 Employees in departments with budget > 60000
SELECT e.FirstName, e.LastName
FROM ex02.Employees e
JOIN ex02.Departments d ON e.DeptID = d.DeptID
WHERE d.Budget > 60000;

-- 2.13 Departments with budget larger than average
SELECT * FROM ex02.Departments
WHERE Budget > (SELECT AVG(Budget) FROM ex02.Departments);

-- 2.14 Names of departments with more than or equal to 2 employees
SELECT d.DeptName
FROM ex02.Employees e
JOIN ex02.Departments d ON e.DeptID = d.DeptID
GROUP BY d.DeptName
HAVING COUNT(*) >= 2;

-- 2.15 Employees in department with second lowest budget
;WITH RankedDepts AS (
    SELECT DeptID, DeptName, Budget,
           DENSE_RANK() OVER (ORDER BY Budget ASC) AS BudgetRank
    FROM ex02.Departments
)
SELECT e.FirstName, e.LastName
FROM ex02.Employees e
JOIN RankedDepts r ON e.DeptID = r.DeptID
WHERE r.BudgetRank = 2;

-- 2.16 Add "Quality Assurance" department and Mary Moore
MERGE ex02.Departments AS target
USING (VALUES ('Quality Assurance', 40000)) AS source(DeptName, Budget)
ON target.DeptName = source.DeptName
WHEN NOT MATCHED THEN INSERT (DeptName, Budget) VALUES (source.DeptName, source.Budget);
SELECT * FROM ex02.Departments WHERE DeptName = 'Quality Assurance';

MERGE ex02.Employees AS target
USING (VALUES ('Mary','Moore', (SELECT DeptID FROM ex02.Departments WHERE DeptName='Quality Assurance'), 0,'2025-01-01')) 
      AS source(FirstName, LastName, DeptID, Salary, HireDate)
ON target.FirstName = source.FirstName AND target.LastName = source.LastName
WHEN NOT MATCHED THEN INSERT (FirstName, LastName, DeptID, Salary, HireDate)
VALUES (source.FirstName, source.LastName, source.DeptID, source.Salary, source.HireDate);

-- 2.17 Reduce all department budgets by 10%
UPDATE ex02.Departments SET Budget = Budget * 0.9;
SELECT * FROM ex02.Departments;

-- 2.18 Reassign employees from Research (77) to IT (14)
UPDATE ex02.Employees SET DeptID = 14 WHERE DeptID = 77;

-- 2.19 Delete employees in IT (14)
DELETE FROM ex02.Employees WHERE DeptID = 14;

-- 2.20 Delete employees in departments with budget >= 60000
DELETE e
FROM ex02.Employees e
JOIN ex02.Departments d ON e.DeptID = d.DeptID
WHERE d.Budget >= 60000;

-- 2.21 Delete all employees
DELETE FROM ex02.Employees;
SELECT * FROM ex02.Employees;

PRINT '--- 2_questions_and_solution.sql executed successfully ---';
