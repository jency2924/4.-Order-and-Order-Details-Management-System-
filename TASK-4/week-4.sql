
USE ecommerceD__B;

-- 1. Display all orders
SELECT * FROM orders;

-- 2. Display all order details
SELECT * FROM order_details;

-- 3. Display orders with customer details
SELECT
    o.Order_ID,
    c.Customer_id,
    c.Customer_Name,
    o.Order_Date,
    o.Total_Amount,
    o.Order_Status
FROM orders o
INNER JOIN customer c
    ON o.Customer_ID = c.Customer_id
ORDER BY o.Order_Date DESC;

-- 4. Display products included in each order
SELECT
    o.Order_ID,
    o.Order_Date,
    p.Product_Name,
    od.Quantity,
    od.Price,
    (od.Quantity * od.Price) AS Line_Total
FROM orders o
INNER JOIN order_details od
    ON o.Order_ID = od.Order_ID
INNER JOIN product p
    ON od.Product_ID = p.Product_ID
ORDER BY o.Order_ID;

-- 5. Calculate total items in each order
SELECT
    Order_ID,
    SUM(Quantity) AS Total_Items
FROM order_details
GROUP BY Order_ID;

-- 6. Calculate order amount from order details
SELECT
    Order_ID,
    SUM(Quantity * Price) AS Calculated_Order_Amount
FROM order_details
GROUP BY Order_ID;

-- 7. Customer-wise order count and spending
SELECT
    c.Customer_id,
    c.Customer_Name,
    COUNT(o.Order_ID) AS Number_Of_Orders,
    COALESCE(SUM(o.Total_Amount), 0) AS Total_Spending
FROM customer c
LEFT JOIN orders o
    ON c.Customer_id = o.Customer_ID
GROUP BY c.Customer_id, c.Customer_Name
ORDER BY Total_Spending DESC;

-- 8. Product-wise sales report
SELECT
    p.Product_ID,
    p.Product_Name,
    COALESCE(SUM(od.Quantity), 0) AS Quantity_Sold,
    COALESCE(SUM(od.Quantity * od.Price), 0) AS Sales_Value
FROM product p
LEFT JOIN order_details od
    ON p.Product_ID = od.Product_ID
GROUP BY p.Product_ID, p.Product_Name
ORDER BY Sales_Value DESC;

-- 9. Order status summary
SELECT
    Order_Status,
    COUNT(*) AS Number_Of_Orders,
    SUM(Total_Amount) AS Total_Order_Value
FROM orders
GROUP BY Order_Status;

-- 10. Customers who placed more than one order
SELECT
    c.Customer_id,
    c.Customer_Name,
    COUNT(o.Order_ID) AS Number_Of_Orders
FROM customer c
INNER JOIN orders o
    ON c.Customer_id = o.Customer_ID
GROUP BY c.Customer_id, c.Customer_Name
HAVING COUNT(o.Order_ID) > 1;

-- 11. Calculate average order value
SELECT
    AVG(Total_Amount) AS Average_Order_Value
FROM orders;

-- 12. Classify orders based on amount
SELECT
    Order_ID,
    Total_Amount,
    CASE
        WHEN Total_Amount >= 5000 THEN 'High Value'
        WHEN Total_Amount >= 1000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Order_Category
FROM orders
ORDER BY Total_Amount DESC;

-- 13. Display orders within a date range
SELECT *
FROM orders
WHERE Order_Date BETWEEN '2026-01-01' AND '2026-12-31'
ORDER BY Order_Date;

-- 14. Find orders without order-detail records
SELECT
    o.Order_ID,
    o.Customer_ID,
    o.Order_Date
FROM orders o
LEFT JOIN order_details od
    ON o.Order_ID = od.Order_ID
WHERE od.Order_ID IS NULL;
