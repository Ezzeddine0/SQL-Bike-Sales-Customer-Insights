/*Group customers into three segments based on their spending behaviour:
	- VIP: Customer with at least 12 months of history and spending more than $5,000
	- Regular: at least 12 months but spending $5,000 or less
	- New: Customer with lifespan less than 12 months*/


WITH customers AS(
SELECT 
c.customer_id,
SUM(s.sales_amount) as total_sales, 
DATEDIFF(MONTH, c.create_date, CAST(GETDATE() AS DATE)) AS timespan_in_months
FROM dim_customers AS c
LEFT JOIN fact_sales AS s
ON c.customer_key = s.customer_key
GROUP BY 
c.customer_id,
DATEDIFF(MONTH, c.create_date, CAST(GETDATE() AS DATE))
),
customer_segments AS(
SELECT 
customer_id,
total_sales,
timespan_in_months,
CASE WHEN total_sales > 5000 and timespan_in_months >- 12 THEN 'VIP'
	 WHEN total_sales < 5000 and timespan_in_months >= 12 THEN 'Regular'
	 WHEN timespan_in_months < 12 THEN 'New'
END AS segment
FROM customers
)
SELECT
segment,
COUNT(customer_id) AS Number_Of_Users,
FORMAT(SUM(total_sales),'C','en-US' )AS Total_sales
FROM customer_segments
GROUP BY segment