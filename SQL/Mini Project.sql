USE Northwind;

--Exercise 1: Northwind Queries--
--1.1--
SELECT CustomerID, CompanyName, [Address], PostalCode, City, Region, Country 
FROM Customers 
WHERE City IN ('London', 'Paris');

--1.2--
SELECT * 
FROM Products 
WHERE QuantityPerUnit LIKE '%bottles%';

--1.3--
SELECT *, S.ContactName AS "SupplierName", S.Country AS "SupplierCountry" 
FROM Products P 
LEFT JOIN Suppliers S ON S.SupplierID = P.SupplierID 
WHERE QuantityPerUnit LIKE '%bottles%';

--1.4--
SELECT COUNT(*) as "Amount", C.CategoryName
FROM Products P 
RIGHT JOIN Categories C ON C.CategoryID = P.CategoryID
GROUP BY C.CategoryID, C.CategoryName 
ORDER BY COUNT(*) DESC;

--1.5--
SELECT CONCAT(TitleOfCourtesy, ' ' ,FirstName, ' ', LastName) AS "Full Name", City 
FROM Employees 
WHERE Country = 'UK';

--1.6--
SELECT inner_table.RegionDescription AS "Sales Region", FORMAT(inner_table.Amount, '#,###,###') AS "Sales Total" 
FROM (
    SELECT R.RegionDescription, ROUND(SUM((OD.UnitPrice * OD.Quantity) * (1-OD.Discount)), 0) AS "Amount" 
    FROM Region R
    JOIN Territories T ON R.RegionID = T.RegionID
    JOIN EmployeeTerritories ET ON T.TerritoryID = ET.TerritoryID
    JOIN Orders O ON O.EmployeeID = ET.EmployeeID
    JOIN [Order Details] OD ON OD.OrderID = O.OrderID 
    GROUP BY R.RegionDescription
) AS inner_table
WHERE "Amount" > 1000000;

--1.7--
SELECT COUNT(*) AS "Amount_of_orders" 
FROM Orders 
WHERE Freight > 100 AND ShipCountry IN ('USA', 'UK');

--1.8--
SELECT TOP 1 OrderID, ROUND(SUM((UnitPrice * Quantity) * Discount), 2) as "Value Of Discount"
FROM [Order Details] 
GROUP BY OrderID 
ORDER BY "Value Of Discount" DESC;


--Exercise 2: Create Spartans Table--
USE Ranson_DB;

--2.1--
DROP TABLE IF EXISTS spartans_table;
CREATE TABLE spartans_table 
(
    spartan_id int IDENTITY(1,1) PRIMARY KEY,
    title CHAR(3),
    first_name VARCHAR(15), 
    second_name VARCHAR(20), 
    university VARCHAR(40), 
    course_taken VARCHAR(40), 
    course_mark VARCHAR(3)
)

--2.2--
INSERT INTO spartans_table
VALUES ('Mr.', 'Benjamin', 'Ranson', 'Essex', 'Computer Science', '2:1'),
    ('Mr.', 'Andrew', 'Asare', 'London Metropolitan University', 'Computer Science', '2:1'),
    ('Mr.', 'Ayaz', 'Yar', 'Exeter', 'PPE', '2:1'),
    ('Ms.', 'Adedunni', 'Adebusuyi', 'Goldsmiths', 'Computer Science', '2:2'),
    ('Mr.', 'William', 'King', 'Swansea University', 'Computer Science', '1'),
    ('Mr.', 'Arun', 'Panesar', 'De Montfort', 'Software Engineering', '1'),
    ('Mr.', 'Jordan', 'Clarke', 'Salford', 'Physics', '2:1')

SELECT * FROM spartans_table;


--Exercise 3: Northwind Data Analysis linked to Excel--
USE Northwind;

--3.1--
SELECT CONCAT(E.FirstName, ' ', E.LastName) AS "Employee Name", CONCAT(Managers.FirstName, ' ', Managers.LastName) AS "Reports to" 
FROM Employees E
LEFT JOIN Employees AS "Managers" ON Managers.EmployeeID = E.ReportsTo;

--3.2--
SELECT inner_table.CompanyName, SalesTotal 
FROM (
    SELECT S.CompanyName, SUM((OD.UnitPrice * OD.Quantity) * (1 - OD.Discount)) AS "SalesTotal" 
    FROM [Order Details] OD
    JOIN Products P ON OD.ProductID = P.ProductID
    JOIN Suppliers S ON S.SupplierID = P.SupplierID
    GROUP BY S.CompanyName
) AS inner_table
WHERE SalesTotal > 10000
ORDER BY SalesTotal;

--3.3--
SELECT TOP 10 O.CustomerID, ROUND(SUM(UnitPrice * Quantity * (1 - Discount)), 2) AS "YTD Sales"
FROM Orders O
JOIN [Order Details] OD ON OD.OrderID = O.OrderID
WHERE YEAR(OrderDate) = (SELECT MAX(YEAR(OrderDate)) From Orders) 
AND O.ShippedDate IS NOT NULL
GROUP BY o.CustomerID
ORDER BY SUM(UnitPrice * Quantity * (1 - Discount)) DESC;

--3.4--
SELECT Order_date, date_diff AS "Average_Shipping_Time" 
FROM (
    SELECT CONCAT(YEAR(OrderDate), ' ' ,FORMAT(MONTH(OrderDate), '0#')) AS "Order_date", AVG(DATEDIFF(d, OrderDate, ShippedDate)) AS "date_diff" 
    FROM Orders
    GROUP BY MONTH(OrderDate), YEAR(OrderDate)
) AS inner_table
ORDER BY Order_date;
