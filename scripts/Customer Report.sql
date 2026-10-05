WITH base AS(
SELECT 
s.order_number,
s.product_key,
s.order_date,
s.sales_amount,
s.quantity,
c.customer_key,
CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
DATEDIFF(YEAR, c.birthdate, GETDATE()) AS customer_age,
c.customer_number,
c.create_date
FROM fact_sales AS s
LEFT JOIN dim_customers AS c
ON s.customer_key = c.customer_key
WHERE order_date is not null
),
customer_aggregations AS(
SELECT 
	customer_key,
	customer_name,
	customer_number,
	create_date,
	customer_age,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) as total_quantity,
	COUNT(DISTINCT product_key) AS total_products,
	MAX(order_date) AS last_order
FROM base 
GROUP BY 
	customer_key,
	customer_name,
	customer_age,
	customer_number,
	create_date
),
customer AS (
SELECT 
	*,
	CASE
		WHEN customer_age < 20 THEN 'Under 20'
		WHEN customer_age BETWEEN 20 AND 29 THEN '20-29'
		WHEN customer_age BETWEEN 30 AND 39 THEN '30-39'
		WHEN customer_age BETWEEN 40 AND 49 THEN '40-49'
		Else 'above 50' 
	END AS age_group,
	CASE
		WHEN total_sales < 500 THEN 'New'
		WHEN total_sales < 5000   THEN 'Regular'
		Else 'VIP'
	END AS customer_segment
FROM customer_aggregations
)

/*
SELECT 
customer_key,
customer_name,
customer_age,
total_orders,
total_quantity,
total_products
total_sales,
last_order
FROM customer
*/


-- Age Group number	and sales
SELECT
age_group,
COUNT(customer_name) AS number_of_users,
SUM(total_sales) AS total_sales
FROM customer
Group BY age_group