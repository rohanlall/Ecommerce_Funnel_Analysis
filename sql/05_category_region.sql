-- Top categories by revenue
SELECT COALESCE(t.product_category_name_english, pr.product_category_name) AS category,
       COUNT(DISTINCT i.order_id) AS orders,
       ROUND(SUM(i.price), 0)     AS revenue
FROM order_items i
JOIN products pr USING (product_id)
LEFT JOIN category_translation t USING (product_category_name)
GROUP BY 1
ORDER BY revenue DESC
LIMIT 15;

-- Revenue and average freight cost by customer state
SELECT c.customer_state,
       COUNT(DISTINCT o.order_id)     AS orders,
       ROUND(SUM(i.price), 0)         AS revenue,
       ROUND(AVG(i.freight_value), 2) AS avg_freight
FROM orders o
JOIN customers c USING (customer_id)
JOIN order_items i USING (order_id)
GROUP BY 1
ORDER BY revenue DESC;
