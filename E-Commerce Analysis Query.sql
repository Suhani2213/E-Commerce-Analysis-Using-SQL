Select * FROM Customers;
Select * FROM Products;
Select * FROM Transactions;
Select * FROM Productsoff;
Select * FROM Sales;


-- What is the total revenue generated from each product category?
SELECT 
    p.Category, SUM(p.Price * t.Quantity) Total_Revenue
FROM
    Products p
        LEFT JOIN
    Transactions t ON p.ProductID = t.ProductID
GROUP BY p.Category
ORDER BY Total_Revenue DESC;


-- Which customer made the highest number of transactions?
SELECT 
    c.CustomerName, COUNT(t.TransactionID) Total_Transaction
FROM
    Customers c
        JOIN
    Transactions t ON c.CustomerID = t.CustomerID
GROUP BY c.CustomerID , c.CustomerName
ORDER BY Total_Transaction DESC
LIMIT 1;

-- List products that have never been sold.
SELECT 
    p.ProductName, SUM(t.Quantity) AS Quantity_Sold
FROM
    Products p
        LEFT JOIN
    Transactions t ON p.ProductID = t.ProductID
GROUP BY p.ProductID , p.ProductName
HAVING Quantity_Sold = 0
ORDER BY Quantity_Sold;


-- What is the average transaction value for each country?
SELECT 
    c.Country, ROUND(AVG(p.Price * t.Quantity)) Avg_Revenue
FROM
    Customers c
        JOIN
    Transactions t ON c.CustomerID = t.CustomerID
        JOIN
    Products p ON p.ProductID = t.ProductID
GROUP BY c.Country
ORDER BY Avg_Revenue DESC;


-- Which product category is most popular in terms of quantity sold?
SELECT 
    p.Category, SUM(t.Quantity) Quantity
FROM
    Products p
        JOIN
    Transactions t ON p.ProductID = t.ProductID
GROUP BY p.Category
ORDER BY Quantity DESC;


-- Identify customers who have spent more than $1000 in total.
SELECT 
    c.CustomerName, ROUND(SUM(p.Price * t.Quantity)) Total_Spent
FROM
    Customers c
        JOIN
    Transactions t ON c.CustomerID = t.CustomerID
        JOIN
    Products p ON p.ProductID = t.ProductID
GROUP BY c.CustomerID , c.CustomerName
HAVING Total_Spent > 1000;


-- How many transactions involved purchasing more than one item?
SELECT 
    COUNT(TransactionID)
FROM
    Transactions
WHERE
    Quantity > 1;


-- What is the difference in total sales between 'Electronics' and 'Furniture' categories?
SELECT 
    SUM(CASE
        WHEN p.Category = 'Electronics' THEN (p.Price * t.Quantity)
        ELSE 0
    END) 'ElectronicsSales',
    SUM(CASE
        WHEN p.Category = 'Furniture' THEN (p.Price * t.Quantity)
        ELSE 0
    END) 'FurnitureSales',
    SUM(CASE
        WHEN p.Category = 'Electronics' THEN (p.Price * t.Quantity)
        ELSE 0
    END) - SUM(CASE
        WHEN p.Category = 'Furniture' THEN (p.Price * t.Quantity)
        ELSE 0
    END) AS 'Sales_Difference'
FROM
    Products p
        JOIN
    Transactions t ON p.ProductID = t.ProductID;
    
    

-- Which country has the highest average spending per transaction?
SELECT 
    c.Country, AVG(p.Price * t.Quantity) Avg_Spent
FROM
    Customers c
        JOIN
    Transactions t ON c.CustomerID = t.CustomerID
        JOIN
    Products p ON p.ProductID = t.ProductID
GROUP BY c.Country , t.TransactionID
ORDER BY Avg_Spent DESC
LIMIT 1;


 -- For each product, calculate the total revenue and categorize its sales volume as 'High' (more than $500), 'Medium' ($100-$500), or 'Low' (less than $100)
SELECT 
    p.ProductName,
    SUM(p.Price * t.Quantity) AS 'Total_Revenue',
    CASE
        WHEN SUM(p.Price * t.Quantity) > 500 THEN 'High'
        WHEN SUM(p.Price * t.Quantity) BETWEEN 100 AND 500 THEN 'Medium'
        ELSE 'Low'
    END Sales_Volume
FROM
    Products p
        LEFT JOIN
    Transactions t ON p.ProductID = t.ProductID
GROUP BY p.ProductID , p.ProductName
ORDER BY Total_Revenue DESC;
 


-- How much revenue was generated each day of the sale?
SELECT 
    s.SaleDate,
    ROUND(((p.OriginalPrice - (p.OriginalPrice * p.DiscountRate) / 100) * s.QuantitySold)) AS Revenue
FROM
    Productsoff p
        RIGHT JOIN
    Sales s ON p.ProductID = s.ProductID
WHERE
    s.SaleDate BETWEEN '2023-03-11' AND '2023-03-18'
ORDER BY Revenue DESC;


-- Which product had the highest sales volume during the sale?
SELECT 
    p.ProductID,
    p.ProductName,
    SUM(s.QuantitySold) AS Volume_Sold
FROM
    Productsoff p
        RIGHT JOIN
    Sales s ON p.ProductID = s.ProductID
WHERE
    s.SaleDate BETWEEN '2023-03-11' AND '2023-03-18'
GROUP BY p.ProductID , p.ProductName
ORDER BY Volume_Sold DESC
LIMIT 1;


-- What was the total discount given during the sale period?
SELECT 
    ROUND(SUM(((p.OriginalPrice * p.DiscountRate) / 100) * s.QuantitySold)) AS 'TOTAL Discount ($)'
FROM
    Productsoff p
        RIGHT JOIN
    Sales s ON p.ProductID = s.ProductID
WHERE
    s.SaleDate BETWEEN '2023-03-11' AND '2023-03-18';


-- How does the sale performance compare in terms of units sold before and during the sale?
SELECT 
    SUM(CASE
        WHEN s.SaleDate BETWEEN '2023-03-11' AND '2023-03-18' THEN s.QuantitySold
        ELSE 0
    END) AS Quantity_Sold_During_Sale,
    SUM(CASE
        WHEN s.SaleDate BETWEEN '2023-03-01' AND '2023-03-09' THEN s.QuantitySold
        ELSE 0
    END) AS Quantity_Sold_Before_Sale
FROM
    Sales s;


-- What was the average discount rate applied to products sold during the sale?
SELECT 
    AVG(p.DiscountRate) AVG_Discount_Rate
FROM
    Productsoff p
        JOIN
    Sales s ON p.ProductID = s.ProductID
WHERE
    s.SaleDate BETWEEN '2023-03-11' AND '2023-03-18'
ORDER BY AVG_Discount_Rate DESC; 


-- Which day had the highest revenue, and what was the top-selling product on that day?
SELECT 
    s.SaleDate,
    p.ProductName,
    ROUND(SUM((p.OriginalPrice - ((p.OriginalPrice * p.DiscountRate) / 100)) * s.QuantitySold)) AS Total_Revenue
FROM
    Productsoff p
        JOIN
    Sales s ON p.ProductID = s.ProductID
GROUP BY s.SaleDate , p.ProductName
ORDER BY Total_Revenue DESC
LIMIT 1;


-- How many units were sold per product category during the sale?
SELECT 
    p.ProductName, SUM(s.QuantitySold) AS Units_Sold
FROM
    Productsoff p
        RIGHT JOIN
    Sales s ON p.ProductID = s.ProductID
WHERE
    s.SaleDate BETWEEN '2023-03-11' AND '2023-03-18'
GROUP BY p.ProductName
ORDER BY Units_Sold DESC;


-- What was the total number of transactions each day?
SELECT SaleDate, COUNT(SaleID) AS Transaction
FROM Sales
GROUP BY SaleDate
ORDER BY SaleDate;


-- Which product had the largest discount impact on revenue?
SELECT 
    p.ProductName,
    ROUND(SUM(((p.OriginalPrice * p.DiscountRate) / 100) * s.QuantitySold)) AS 'TOTAL Discount (PRICE)'
FROM
    Productsoff p
        RIGHT JOIN
    Sales s ON p.ProductID = s.ProductID
GROUP BY s.ProductID , p.ProductName
LIMIT 1;


-- Calculate the percentage increase in sales volume during the sale compared to a similar period before the sale. 
SELECT 
    (Quantity_Sold_During_Sale - Quantity_Sold_Before_Sale) / Quantity_Sold_Before_Sale * 100 AS Percentage_Increase
FROM
    (SELECT 
        SUM(CASE
                WHEN s.SaleDate BETWEEN '2023-03-11' AND '2023-03-18' THEN s.QuantitySold
                ELSE 0
            END) AS Quantity_Sold_During_Sale,
            SUM(CASE
                WHEN s.SaleDate BETWEEN '2023-03-01' AND '2023-03-09' THEN s.QuantitySold
                ELSE 0
            END) AS Quantity_Sold_Before_Sale
    FROM
        Sales s) AS Qty;
