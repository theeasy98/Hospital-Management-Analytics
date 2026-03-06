/*
Project: Customer Behaviour Dashboard
Author: Israel Favour Joseph
Tool: BigQuery
*/

SELECT

-- Customer
s.customer_id,

-- Order info
s.order_id,
s.order_date,

-- Clean delivery status
CASE
  WHEN LOWER(s.delivery_status) = 'delivered' THEN 'Delivered'
  WHEN LOWER(s.delivery_status) = 'delayed' THEN 'Delayed'
  ELSE 'Cancelled'
END AS delivery_status,

-- Clean payment method
CASE
  WHEN LOWER(s.payment_method) LIKE '%credit%' THEN 'Credit Card'
  WHEN LOWER(s.payment_method) LIKE '%paypal%' THEN 'PayPal'
  WHEN LOWER(s.payment_method) LIKE '%bank%' THEN 'Bank Transfer'
END AS payment_method,

-- Product info
p.product_name,
p.category,
p.base_price,

-- Quantity
SAFE_CAST(s.quantity AS INT64) AS quantity,

-- Unit price
SAFE_CAST(s.unit_price AS FLOAT64) AS unit_price,

-- Sales amount
SAFE_CAST(s.quantity AS INT64) * SAFE_CAST(s.unit_price AS FLOAT64)
AS sales_amount,

-- Discount applied
GREATEST(
SAFE_CAST(p.base_price AS FLOAT64) - SAFE_CAST(s.unit_price AS FLOAT64),0
) * SAFE_CAST(s.quantity AS INT64)
AS discount_applied,

-- Clean gender
CASE
  WHEN LOWER(c.gender) = 'male' THEN 'Male'
  WHEN LOWER(c.gender) = 'female' THEN 'Female'
  ELSE 'Other'
END AS gender,

-- Region
c.region,

-- Clean loyalty tier
CASE
  WHEN LOWER(c.loyalty_tier) = 'gold' THEN 'Gold'
  WHEN LOWER(c.loyalty_tier) = 'silver' THEN 'Silver'
  WHEN LOWER(c.loyalty_tier) = 'bronze' THEN 'Bronze'
END AS loyalty_tier,

c.signup_date,

-- Behaviour metrics
b.total_orders,
b.total_quantity,
b.total_spent,
b.avg_unit_price,
b.unique_products_bought,
b.customer_lifetime_days,

-- Average order value
SAFE_DIVIDE(b.total_spent , b.total_orders)
AS avg_order_value

FROM
`sales-and-customer-behaviour.customer_behaviour.sales_data` s

LEFT JOIN
`sales-and-customer-behaviour.customer_behaviour.product_info` p
ON s.product_id = p.product_id

LEFT JOIN
`sales-and-customer-behaviour.customer_behaviour.customer_info` c
ON s.customer_id = c.customer_id

LEFT JOIN
`sales-and-customer-behaviour.customer_behaviour.customer_behaviour` b
ON CAST(s.customer_id AS STRING) = CAST(b.customer_id AS STRING)

WHERE LOWER(c.loyalty_tier) IN ('gold','silver','bronze')