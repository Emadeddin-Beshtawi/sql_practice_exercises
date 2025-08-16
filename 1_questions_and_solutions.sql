-- ============================================================
-- RESET TABLES TO ORIGINAL STATE
-- ============================================================
PRINT '--- Resetting tables ---';

-- Delete all products
DELETE FROM Products;
DBCC CHECKIDENT ('Products', RESEED, 0); -- reset identity if Code is identity

-- Delete all manufacturers
DELETE FROM Manufacturers;
DBCC CHECKIDENT ('Manufacturers', RESEED, 0); -- reset identity if Code is identity

-- Re-insert original manufacturers
INSERT INTO Manufacturers (Code, Name) VALUES
(1,'Sony'),
(2,'Creative Labs'),
(3,'Hewlett-Packard'),
(4,'Iomega'),
(5,'Fujitsu'),
(6,'Winchester');

-- Re-insert original products
INSERT INTO Products (Code, Name, Price, Manufacturer) VALUES
(1,'Hard drive',240,5),
(2,'Memory',120,6),
(3,'ZIP drive',150,4),
(4,'Floppy disk',5,6),
(5,'Monitor',240,1),
(6,'DVD drive',180,2),
(7,'CD drive',90,2),
(8,'Printer',270,3),
(9,'Toner cartridge',66,3),
(10,'DVD burner',180,2);

PRINT '--- Tables reset complete ---';
GO

-- ============================================================
-- QUESTIONS & SOLUTIONS
-- ============================================================

-- 1.1 Select the names of all the products in the store.
PRINT '--- 1.1 Names of all products ---';
SELECT Name FROM Products;
GO

-- 1.2 Select the names and the prices of all the products in the store.
PRINT '--- 1.2 Names and prices of all products ---';
SELECT Name, Price FROM Products;
GO

-- 1.3 Select the name of the products with a price <= $200
PRINT '--- 1.3 Products with price <= 200 ---';
SELECT Name FROM Products WHERE Price <= 200;
GO

-- 1.4 Select all the products with price between $60 and $120
PRINT '--- 1.4 Products with price between 60 and 120 ---';
SELECT * FROM Products WHERE Price BETWEEN 60 AND 120;
GO

-- 1.5 Select name and price in cents
PRINT '--- 1.5 Name and price in cents ---';
SELECT Name, Price*100 AS PriceInCents FROM Products;
GO

-- 1.6 Compute the average price of all products
PRINT '--- 1.6 Average price ---';
SELECT AVG(Price) AS AvgPrice FROM Products;
GO

-- 1.7 Average price of products with Manufacturer = 2
PRINT '--- 1.7 Avg price where Manufacturer = 2 ---';
SELECT AVG(Price) AS AvgPrice FROM Products WHERE Manufacturer = 2;
GO

-- 1.8 Number of products with price >= 180
PRINT '--- 1.8 Count products with price >= 180 ---';
SELECT COUNT(*) AS CountHighPrice FROM Products WHERE Price >= 180;
GO

-- 1.9 Products with price >= 180 sorted by price desc, name asc
PRINT '--- 1.9 Products price >= 180 sorted ---';
SELECT Name, Price FROM Products WHERE Price >= 180 ORDER BY Price DESC, Name ASC;
GO

-- 1.10 Select all data including manufacturer data
PRINT '--- 1.10 Products with manufacturer info ---';
SELECT p.*, m.Name AS ManufacturerName
FROM Products p
JOIN Manufacturers m ON p.Manufacturer = m.Code;
GO

-- 1.11 Product name, price, and manufacturer name
PRINT '--- 1.11 Product name, price, manufacturer name ---';
SELECT p.Name, p.Price, m.Name AS ManufacturerName
FROM Products p
JOIN Manufacturers m ON p.Manufacturer = m.Code;
GO

-- 1.12 Average price per manufacturer code
PRINT '--- 1.12 Avg price per manufacturer code ---';
SELECT AVG(Price) AS AvgPrice, Manufacturer
FROM Products
GROUP BY Manufacturer;
GO

-- 1.13 Average price per manufacturer name
PRINT '--- 1.13 Avg price per manufacturer name ---';
SELECT AVG(p.Price) AS AvgPrice, m.Name AS ManufacturerName
FROM Products p
JOIN Manufacturers m ON p.Manufacturer = m.Code
GROUP BY m.Name;
GO

-- 1.14 Manufacturers with avg product price >= 150
PRINT '--- 1.14 Manufacturers with avg price >= 150 ---';
SELECT m.Name AS ManufacturerName, AVG(p.Price) AS AvgPrice
FROM Products p
JOIN Manufacturers m ON p.Manufacturer = m.Code
GROUP BY m.Name
HAVING AVG(p.Price) >= 150;
GO

-- 1.15 Cheapest product
PRINT '--- 1.15 Cheapest product ---';
SELECT TOP 1 Name, Price FROM Products ORDER BY Price ASC;
GO

-- 1.16 Most expensive product per manufacturer
PRINT '--- 1.16 Most expensive product per manufacturer ---';
WITH MaxPrice AS (
    SELECT Manufacturer, MAX(Price) AS MaxPrice
    FROM Products
    GROUP BY Manufacturer
)
SELECT m.Name AS ManufacturerName, p.Name AS ProductName, p.Price
FROM Products p
JOIN Manufacturers m ON p.Manufacturer = m.Code
JOIN MaxPrice mp ON p.Manufacturer = mp.Manufacturer AND p.Price = mp.MaxPrice;
GO

-- 1.17 Add a new product: Loudspeakers, $70, manufacturer 2
PRINT '--- 1.17 Insert Loudspeakers ---';
INSERT INTO Products(Code, Name, Price, Manufacturer) VALUES (11,'Loudspeakers',70,2);
GO

-- 1.18 Update product 8 name to Laser Printer
PRINT '--- 1.18 Update product 8 name ---';
UPDATE Products SET Name='Laser Printer' WHERE Code=8;
GO

-- 1.19 Apply 10% discount to all products
PRINT '--- 1.19 Apply 10% discount ---';
UPDATE Products SET Price = Price * 0.9;
GO

-- 1.20 Apply 10% discount to products with price >= 120
PRINT '--- 1.20 Apply 10% discount for price >= 120 ---';
UPDATE Products SET Price = Price * 0.9 WHERE Price >= 120;
GO
