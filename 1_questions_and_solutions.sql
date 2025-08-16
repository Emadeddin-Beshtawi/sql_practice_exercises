-- ============================================================
-- RESET TABLES TO ORIGINAL STATE
-- ============================================================
PRINT '--- Resetting tables ---';

-- Drop tables if they exist
IF OBJECT_ID('Products', 'U') IS NOT NULL DROP TABLE Products;
IF OBJECT_ID('Manufacturers', 'U') IS NOT NULL DROP TABLE Manufacturers;

-- Recreate Manufacturers table
CREATE TABLE Manufacturers (
    Code INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(50) NOT NULL
);

-- Recreate Products table
CREATE TABLE Products (
    Code INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Manufacturer INT NOT NULL FOREIGN KEY REFERENCES Manufacturers(Code)
);

-- Insert original manufacturers
INSERT INTO Manufacturers (Name) VALUES
('Sony'),
('Creative Labs'),
('Hewlett-Packard'),
('Iomega'),
('Fujitsu'),
('Winchester');

-- Insert original products
INSERT INTO Products (Name, Price, Manufacturer) VALUES
('Hard drive',240,5),
('Memory',120,6),
('ZIP drive',150,4),
('Floppy disk',5,6),
('Monitor',240,1),
('DVD drive',180,2),
('CD drive',90,2),
('Printer',270,3),
('Toner cartridge',66,3),
('DVD burner',180,2);

PRINT '--- Tables reset complete ---';

-- ============================================================
-- QUESTIONS & SOLUTIONS
-- ============================================================

PRINT '1.1 Names of all products';
SELECT Name FROM Products;

PRINT '1.2 Names and prices';
SELECT Name, Price FROM Products;

PRINT '1.3 Products with price <= 200';
SELECT Name FROM Products WHERE Price <= 200;

PRINT '1.4 Products with price between 60 and 120';
SELECT * FROM Products WHERE Price BETWEEN 60 AND 120;

PRINT '1.5 Name and price in cents';
SELECT Name, Price * 100 AS PriceInCents FROM Products;

PRINT '1.6 Average price of all products';
SELECT AVG(Price) AS AvgPrice FROM Products;

PRINT '1.7 Average price where Manufacturer = 2';
SELECT AVG(Price) AS AvgPrice FROM Products WHERE Manufacturer = 2;

PRINT '1.8 Count of products with price >= 180';
SELECT COUNT(*) AS CountHighPrice FROM Products WHERE Price >= 180;

PRINT '1.9 Products price >= 180 sorted by price desc, name asc';
SELECT Name, Price FROM Products 
WHERE Price >= 180 
ORDER BY Price DESC, Name ASC;

PRINT '1.10 Products with manufacturer info';
SELECT p.*, m.Name AS ManufacturerName
FROM Products p
JOIN Manufacturers m ON p.Manufacturer = m.Code;

PRINT '1.11 Product name, price, and manufacturer name';
SELECT p.Name, p.Price, m.Name AS ManufacturerName
FROM Products p
JOIN Manufacturers m ON p.Manufacturer = m.Code;

PRINT '1.12 Average price per manufacturer code';
SELECT Manufacturer, AVG(Price) AS AvgPrice
FROM Products
GROUP BY Manufacturer;

PRINT '1.13 Average price per manufacturer name';
SELECT m.Name AS ManufacturerName, AVG(p.Price) AS AvgPrice
FROM Products p
JOIN Manufacturers m ON p.Manufacturer = m.Code
GROUP BY m.Name;

PRINT '1.14 Manufacturers with avg product price >= 150';
SELECT m.Name AS ManufacturerName, AVG(p.Price) AS AvgPrice
FROM Products p
JOIN Manufacturers m ON p.Manufacturer = m.Code
GROUP BY m.Name
HAVING AVG(p.Price) >= 150;

PRINT '1.15 Cheapest product';
SELECT TOP 1 Name, Price FROM Products ORDER BY Price ASC;

PRINT '1.16 Most expensive product per manufacturer';
WITH MaxPrice AS (
    SELECT Manufacturer, MAX(Price) AS MaxPrice
    FROM Products
    GROUP BY Manufacturer
)
SELECT m.Name AS ManufacturerName, p.Name AS ProductName, p.Price
FROM Products p
JOIN Manufacturers m ON p.Manufacturer = m.Code
JOIN MaxPrice mp ON p.Manufacturer = mp.Manufacturer AND p.Price = mp.MaxPrice;

PRINT '1.17 Insert new product: Loudspeakers, $70, manufacturer 2';
INSERT INTO Products(Name, Price, Manufacturer) VALUES ('Loudspeakers', 70, 2);

PRINT '1.18 Update product 8 name to Laser Printer';
UPDATE Products SET Name='Laser Printer' WHERE Code=8;

PRINT '1.19 Apply 10% discount to all products';
UPDATE Products SET Price = Price * 0.9;

PRINT '1.20 Apply 10% discount to products with price >= 120';
UPDATE Products SET Price = Price * 0.9 WHERE Price >= 120;

-- ============================================================
-- RESET IDENTITY (optional, for clean reruns)
-- ============================================================
-- Get max codes
DECLARE @MaxProductCode INT, @MaxManufacturerCode INT;

SELECT @MaxProductCode = ISNULL(MAX(Code), 0) FROM Products;
SELECT @MaxManufacturerCode = ISNULL(MAX(Code), 0) FROM Manufacturers;

-- Reseed identities
DBCC CHECKIDENT ('Products', RESEED, @MaxProductCode);
DBCC CHECKIDENT ('Manufacturers', RESEED, @MaxManufacturerCode);


PRINT '--- Identity reseed complete ---';
