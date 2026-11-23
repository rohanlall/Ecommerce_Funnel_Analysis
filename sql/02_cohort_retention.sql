-- Monthly cohort retention, keyed on customer_unique_id (the real customer)
WITH purchases AS (
  SELECT c.customer_unique_id,
         DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month
  FROM orders o JOIN customers c USING (customer_id)
  WHERE o.order_status = 'delivered'
),
cohorts AS (
  SELECT customer_unique_id, MIN(order_month) AS cohort_month
  FROM purchases GROUP BY 1
)
SELECT ch.cohort_month,
       DATEDIFF('month', ch.cohort_month, p.order_month) AS month_number,
       COUNT(DISTINCT p.customer_unique_id)              AS active_customers
FROM purchases p JOIN cohorts ch USING (customer_unique_id)
GROUP BY 1, 2
ORDER BY 1, 2;
