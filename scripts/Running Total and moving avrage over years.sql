-- Running Total and moving avrage over Years.

SELECT * FROM fact_sales;




SELECT
Order_Date,
Total_Sales,
SUM(Total_Sales) OVER (ORDER BY Order_Date) AS Running_Total_Sales,
AVG(Total_Price) OVER (ORDER BY Order_Date) AS Moving_Avrage_Price
FROM(
SELECT
DateTrunc(YEAR, order_date) as Order_Date,
SUM(sales_amount) as Total_Sales,
AVG(price) as Total_Price
FROM fact_sales
WHERE order_date is not null
GROUP BY DateTrunc(YEAR, order_date)
) t