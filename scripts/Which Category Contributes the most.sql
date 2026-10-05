-- Which Category contributes the most to overall sales?
SELECT * FROM fact_sales
SELECT * FROM dim_products


SELECT
category,
sales,
SUM(sales) OVER () AS overall_sales,
CAST(
sales * 100.0 / SUM(sales) OVER () AS DECIMAL(10,2)
) AS percent_of_sales
FROM(
SELECT 
p.category,
SUM(s.sales_amount) AS sales
FROM fact_sales AS s
LEFT JOIN dim_products AS p
ON s.product_key = p.product_key
GROUP BY (p.category)
) AS f
ORDER BY percent_of_sales DESC;