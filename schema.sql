-- Create tables in ex01 schema
CREATE TABLE ex01.Manufacturers (
    Code INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL
);

CREATE TABLE ex01.Products (
    Code INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Manufacturer INT NOT NULL,
    FOREIGN KEY (Manufacturer) REFERENCES ex01.Manufacturers(Code)
);

-- Insert data
INSERT INTO ex01.Manufacturers(Code, Name) VALUES (1,'Sony');
INSERT INTO ex01.Manufacturers(Code, Name) VALUES (2,'Creative Labs');
INSERT INTO ex01.Manufacturers(Code, Name) VALUES (3,'Hewlett-Packard');
INSERT INTO ex01.Manufacturers(Code, Name) VALUES (4,'Iomega');
INSERT INTO ex01.Manufacturers(Code, Name) VALUES (5,'Fujitsu');
INSERT INTO ex01.Manufacturers(Code, Name) VALUES (6,'Winchester');

INSERT INTO ex01.Products(Code, Name, Price, Manufacturer) VALUES (1,'Hard drive',240,5);
INSERT INTO ex01.Products(Code, Name, Price, Manufacturer) VALUES (2,'Memory',120,6);
INSERT INTO ex01.Products(Code, Name, Price, Manufacturer) VALUES (3,'ZIP drive',150,4);
INSERT INTO ex01.Products(Code, Name, Price, Manufacturer) VALUES (4,'Floppy disk',5,6);
INSERT INTO ex01.Products(Code, Name, Price, Manufacturer) VALUES (5,'Monitor',240,1);
INSERT INTO ex01.Products(Code, Name, Price, Manufacturer) VALUES (6,'DVD drive',180,2);
INSERT INTO ex01.Products(Code, Name, Price, Manufacturer) VALUES (7,'CD drive',90,2);
INSERT INTO ex01.Products(Code, Name, Price, Manufacturer) VALUES (8,'Printer',270,3);
INSERT INTO ex01.Products(Code, Name, Price, Manufacturer) VALUES (9,'Toner cartridge',66,3);
INSERT INTO ex01.Products(Code, Name, Price, Manufacturer) VALUES (10,'DVD burner',180,2);
