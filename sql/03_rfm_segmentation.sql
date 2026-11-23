-- RFM segmentation (most Olist customers buy once, so F is bucketed by count)
WITH base AS (
  SELECT c.customer_unique_id,
         MAX(o.order_purchase_timestamp) AS last_order,
         COUNT(DISTINCT o.order_id)      AS frequency,
         SUM(p.payment_value)            AS monetary
  FROM orders o
  JOIN customers c USING (customer_id)
  JOIN payments  p USING (order_id)
  WHERE o.order_status = 'delivered'
  GROUP BY 1
),
scored AS (
  SELECT *,
    DATEDIFF('day', last_order, (SELECT MAX(order_purchase_timestamp) FROM orders)) AS recency_days,
    NTILE(5) OVER (ORDER BY last_order) AS r,
    CASE WHEN frequency >= 3 THEN 5 WHEN frequency = 2 THEN 4 ELSE 1 END AS f,
    NTILE(5) OVER (ORDER BY monetary)   AS m
  FROM base
)
SELECT
  CASE
    WHEN r >= 4 AND f >= 4 THEN 'Champions'
    WHEN f >= 4            THEN 'Loyal'
    WHEN r >= 4 AND m >= 4 THEN 'High-value new'
    WHEN r >= 4            THEN 'Recent'
    WHEN r <= 2 AND m >= 4 THEN 'At risk (high value)'
    ELSE 'Hibernating'
  END AS segment,
  COUNT(*)                    AS customers,
  ROUND(SUM(monetary), 0)     AS revenue,
  ROUND(AVG(recency_days), 0) AS avg_recency_days
FROM scored
GROUP BY 1
ORDER BY revenue DESC;
