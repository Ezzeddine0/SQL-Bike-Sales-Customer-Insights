/* Yearly Performance of products by comparing their sales to both
avrage sales performance of the product and the previous year's sales*/




WITH yearly_yroduct_sales AS (
SELECT  
p.product_name as Product_Name,
YEAR(s.order_date) AS Order_Year,
SUM(s.sales_amount) AS Total_Sales
FROM fact_sales AS s
LEFT JOIN dim_products as p
ON s.product_key = p.product_key
WHERE s.order_date is not null
GROUP BY 
p.product_name,
YEAR(s.order_date)
)
SELECT
Product_Name,
Order_Year,
Total_Sales,
LAG(Total_Sales) OVER (PARTITION BY Product_Name ORDER BY Order_Year) AS Previous_Year_Sales,
AVG(Total_Sales) OVER(PARTITION BY Product_Name) AS Avrage_Sales_Per_Product,
Total_Sales - AVG(Total_Sales) OVER(PARTITION BY Product_Name) AS diff_avg,
CASE WHEN Total_Sales - AVG(Total_Sales) OVER(PARTITION BY Product_Name) > 0 THEN 'Above Avg'
	 WHEN Total_Sales - AVG(Total_Sales) OVER(PARTITION BY Product_Name) < 0 THEN 'Below Avg'
	 Else 'Avg'
END
FROM yearly_yroduct_sales
Order BY 
Product_Name,
Order_Year