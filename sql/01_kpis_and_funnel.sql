-- Headline KPIs (delivered orders)
SELECT
  COUNT(DISTINCT o.order_id)                                   AS orders,
  COUNT(DISTINCT c.customer_unique_id)                         AS customers,
  ROUND(SUM(p.payment_value), 2)                               AS revenue,
  ROUND(SUM(p.payment_value) / COUNT(DISTINCT o.order_id), 2)  AS aov
FROM orders o
JOIN customers c USING (customer_id)
JOIN payments  p USING (order_id)
WHERE o.order_status = 'delivered';

-- Order status funnel
SELECT order_status,
       COUNT(*) AS orders,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct
FROM orders
GROUP BY order_status
ORDER BY orders DESC;
