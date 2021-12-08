--*************************************************************************--
-- Title: Assignment04
-- Author: ShrutiKakati
-- Desc: This file demonstrates how to process data in a database
-- Change Log: 11/07/2021,Shruti Kakati
-- Listings:
--1. Added data to Categories, Products, Inventories table
--2. Updated Categories
--3. Performed Delete operation on Categories, Products, Inventories

--**************************************************************************--
Use Master;
go

If Exists(Select Name from SysDatabases Where Name = 'Assignment04DB_ShrutiKakati')
 Begin
  Alter Database [Assignment04DB_ShrutiKakati] set Single_user With Rollback Immediate;
  Drop Database Assignment04DB_ShrutiKakati;
 End
go

Create Database Assignment04DB_ShrutiKakati;
go

Use Assignment04DB_ShrutiKakati;
go

-- Create Tables (Module 01)--
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL
,[ProductName] [nvarchar](100) NOT NULL
,[CategoryID] [int] NULL
,[UnitPrice] [money] NOT NULL
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) --
Alter Table Categories
 Add Constraint pkCategories
  Primary Key (CategoryId);
go

Alter Table Categories
 Add Constraint ukCategories
  Unique (CategoryName);
go

Alter Table Products
 Add Constraint pkProducts
  Primary Key (ProductId);
go

Alter Table Products
 Add Constraint ukProducts
  Unique (ProductName);
go

Alter Table Products
 Add Constraint fkProductsToCategories
  Foreign Key (CategoryId) References Categories(CategoryId);
go

Alter Table Products
 Add Constraint ckProductUnitPriceZeroOrHigher
  Check (UnitPrice >= 0);
go

Alter Table Inventories
 Add Constraint pkInventories
  Primary Key (InventoryId);
go

Alter Table Inventories
 Add Constraint dfInventoryDate
  Default GetDate() For InventoryDate;
go

Alter Table Inventories
 Add Constraint fkInventoriesToProducts
  Foreign Key (ProductId) References Products(ProductId);
go

Alter Table Inventories
 Add Constraint ckInventoryCountZeroOrHigher
  Check ([Count] >= 0);
go

/********************************* TASKS *********************************/

-- Add the following data to this database.
-- All answers must include the Begin Tran, Commit Tran, and Rollback Tran transaction statements.
-- All answers must include the Try/Catch blocks around your transaction processing code.
-- Display the Error message if the catch block is invoked.

/* Add the following data to this database:
Beverages	Chai	18.00	2017-01-01	61
Beverages	Chang	19.00	2017-01-01	87
Condiments	Aniseed Syrup	10.00	2017-01-01	19
Condiments	Chef Anton's Cajun Seasoning	22.00	2017-01-01	81
Beverages	Chai	18.00	2017-02-01	13
Beverages	Chang	19.00	2017-02-01	2
Condiments	Aniseed Syrup	10.00	2017-02-01	1
Condiments	Chef Anton's Cajun Seasoning	22.00	2017-02-01	79
Beverages	Chai	18.00	2017-03-02	18
Beverages	Chang	19.00	2017-03-02	12
Condiments	Aniseed Syrup	10.00	2017-03-02	84
Condiments	Chef Anton's Cajun Seasoning	22.00	2017-03-02	72
*/

-- Task 1 (20 pts): Add data to the Categories table
BEGIN TRY
BEGIN TRAN
INSERT INTO Categories
(
    CategoryName
)
VALUES
        ('Beverages'),
        ('Condiments')
COMMIT TRAN
END TRY
BEGIN CATCH
ROLLBACK TRAN
PRINT ERROR_MESSAGE()
END CATCH
GO
-- Task 2 (20 pts): Add data to the Products table
--***************************************************---
--NOTE: As the products have association with the category in the above data provided, so entering the data in categoryID column

BEGIN TRY
BEGIN TRAN
INSERT INTO Products (ProductName, CategoryID, UnitPrice)
VALUES
        ('Chai','1','18.00'),
        ('Chang','1','19.00'),
        ('Aniseed Syrup','2','10.00'),
        ('Chef Antons Cajun Seasoning','2','22.00')
COMMIT TRAN
END TRY
BEGIN CATCH
ROLLBACK TRAN
PRINT ERROR_MESSAGE()
END CATCH
GO

-- Task 3 (20 pts): Add data to the Inventories table
BEGIN TRY
BEGIN TRAN
INSERT INTO Inventories
(
    InventoryDate,
    ProductID,
    Count
)
VALUES
        ('2017-01-01','1','61'),
        ('2017-01-01','2','87'),
        ('2017-01-01','3','19'),
        ('2017-01-01','4','81'),
        ('2017-02-01','1','13'),
        ('2017-02-01','2','2'),
        ('2017-02-01','3','1'),
        ('2017-02-01','4','79'),
        ('2017-03-02','1','18'),
        ('2017-03-02','2','12'),
        ('2017-03-02','3','84'),
        ('2017-03-02','4','72')
COMMIT TRAN
END TRY
BEGIN CATCH
ROLLBACK TRAN
PRINT ERROR_MESSAGE()
END CATCH
GO

-- Task 4 (10 pts): Write code to update the Category "Beverages" to "Drinks"
BEGIN TRY
BEGIN TRAN
UPDATE Categories
SET CategoryName = 'Drinks'
WHERE CategoryID = 1
COMMIT TRAN
END TRY
BEGIN CATCH
ROLLBACK TRAN
PRINT ERROR_MESSAGE()
END CATCH
GO

-- Task 5 (30 pts): Write code to delete all Condiments data from the database (in all three tables!)
BEGIN TRY
BEGIN TRAN
DELETE FROM Inventories
WHERE ProductID IN (  SELECT ProductID
                      FROM Products
                      INNER JOIN Categories
                      ON Categories.CategoryID = Products.CategoryID
                      WHERE CategoryName = 'Condiments'
                    );
DELETE FROM Products
WHERE CategoryID IN (   SELECT CategoryID
                        FROM Categories
                        WHERE CategoryName = 'Condiments'
                    );

DELETE FROM Categories
WHERE CategoryName = 'Condiments';
COMMIT TRAN
END TRY
BEGIN CATCH
ROLLBACK TRAN
PRINT Error_Message()
END CATCH
GO


BEGIN TRANSACTION
Select * from Categories
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
Select * from Products
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
Select * from Inventories
COMMIT TRANSACTION
GO

/***************************************************************************************/
