/* Segment Products into cost range and count how
	many producys fall into each segment*/
WITH product_prices AS(
SELECT 
DISTINCT product_name,
cost,
CASE WHEN cost < 100 THEN 'Below 100'
	 WHEN cost < 500 THEN '100-500'
	 WHEN cost < 1000 THEN '500-1000'
	 Else 'Above 1000'
END AS price_category
FROM dim_products as p
)
SELECT 
price_category,
COUNT(product_name) AS number_of_products
from product_prices
GROUP BY price_category
ORDER BY number_of_products DESC 

