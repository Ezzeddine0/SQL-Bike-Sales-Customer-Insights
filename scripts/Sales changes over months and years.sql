-- Changes over years and months

SELECT * FROM fact_sales;



SELECT DateTrunc(MONTH, order_date) AS Order_Month, 
SUM(sales_amount) AS Total_Sales,
SUM(quantity) as Total_Quantity
FROM fact_sales
WHERE order_date is not null
GROUP BY DateTrunc(MONTH, order_date)
ORDER BY DateTrunc(MONTH, order_date);


SELECT YEAR(order_date) AS Order_Year,
SUM(sales_amount) AS Total_Sales,
COUNT(DISTINCT customer_key) AS Total_Customer,
SUM(quantity) AS Total_Quantity
FROM fact_sales
WHERE order_date is not null
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date);


