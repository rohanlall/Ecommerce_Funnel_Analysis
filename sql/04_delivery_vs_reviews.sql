-- Does late delivery hurt review scores?
WITH d AS (
  SELECT order_id,
         DATEDIFF('day', order_estimated_delivery_date, order_delivered_customer_date) AS days_late
  FROM orders
  WHERE order_status = 'delivered' AND order_delivered_customer_date IS NOT NULL
)
SELECT
  CASE WHEN days_late <= -7 THEN '1. 7+ days early'
       WHEN days_late <= 0  THEN '2. On time'
       WHEN days_late <= 7  THEN '3. 1-7 days late'
       ELSE                      '4. 7+ days late' END AS delivery_bucket,
  COUNT(*)                      AS orders,
  ROUND(AVG(r.review_score), 2) AS avg_review,
  ROUND(100.0 * AVG(CASE WHEN r.review_score <= 2 THEN 1 ELSE 0 END), 1) AS pct_negative
FROM d JOIN reviews r USING (order_id)
GROUP BY 1
ORDER BY 1;
