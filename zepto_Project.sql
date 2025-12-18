create table zepto(
sku_id serial PRIMARY KEY,
category varchar(120),
name varchar(200) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
OutOfStock BOOLEAN,
Quantity INTEGER);

--Data Exploration...

--Count Of Rows:
SELECT COUNT(*) FROM zepto;

--Sample Data:
SELECT * FROM zepto
LIMIT 10;

--NULL VALUES :
SELECT * FROM zepto
WHERE  name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
outOfStock IS NULL
OR
Quantity IS NULL;

--DIFFRENT PRODUCT CATEGORIES:
SELECT DISTINCT category 
FROM zepto ORDER BY category;

-- PRODUCTS IS IN (STOCK AND OUT OF STOCK).
SELECT outOfStock,COUNT(sku_id)
FROM zepto 
GROUP BY outOfStock;

--PRODUCT NAMES THAT ARE IN MULTIPLE TIMES.
SELECT name,count(sku_id) AS "NO OF SKUs"
FROM zepto 
GROUP BY name 
HAVING count(sku_id)>1
ORDER BY COUNT(sku_id) DESC;


--## DATA CLEANING:

--PRODUCTS WITH PRICE=0
SELECT * FROM zepto
WHERE mrp=0 OR discountedSellingPrice =0;

DELETE FROM zepto 
WHERE mrp=0;

--CONVERT PAISE INTO RUPEES:
UPDATE zepto
SET mrp=mrp/100.0,
discountedSellingPrice =discountedSellingPrice/100.00;

SELECT mrp,discountedSellingPrice 
FROM zepto
LIMIT 10;

--##Let's Solve Some Business Quetions Here:
--1Q.Find The Top 10 Best-Value Products Based On The Discount Percentage.
SELECT DISTINCT name,mrp,discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

--2Q.What Are The Products With High MRP But OutOf Stock
SELECT DISTINCT name,mrp
FROM zepto
WHERE outOfStock=TRUE AND mrp>300
ORDER BY mrp  DESC;

--3Q.Caliculate The Estimate Revenue For Each Category
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS Total_Revenue
FROM zepto
GROUP BY category
ORDER BY Total_Revenue;

--4Q.Find All Products where MRP Is GreaterThan ₹500 And Discount Is Lessthan 10%.
SELECT  DISTINCT name,mrp,discountPercent
FROM zepto
WHERE mrp>500 AND discountPercent < 10
ORDER BY mrp DESC,discountPercent DESC;

--5Q.Identify The Top 5 Categories Offering The Highest Average Discount Percentage.
SELECT category,
ROUND(AVG(discountPercent),2) AS Avg_Discount
FROM zepto
GROUP BY category ORDER BY Avg_Discount DESC
LIMIT 5;

--6Q.Find The Price Per Gram For Products Above 100g And Sort By Best Value.
SELECT DISTINCT name,weightInGms,discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS Price_Per_Gram
FROM zepto
WHERE weightInGms >=100
ORDER BY Price_Per_Gram;

--7Q.Group The Products Into Categories Like Low,Medium And Bulk.
SELECT DISTINCT name,weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
     WHEN weightInGms < 5000 THEN 'Medium'
	 ELSE 'Bulk'
	 END AS Weight_Category
FROM zepto;

--8Q.What Is The Total Inventory Weight Per Category.
SELECT category,
SUM(weightInGms * availableQuantity) AS Total_Weight
FROM zepto
GROUP BY category
ORDER BY Total_Weight;

