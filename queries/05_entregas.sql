querie 1

SELECT
    COUNT(*) AS pedidos_entregados,
    ROUND(AVG(julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp)), 1) AS dias_promedio_entrega,
    ROUND(AVG(julianday(order_estimated_delivery_date) - julianday(order_purchase_timestamp)), 1) AS dias_promedio_prometido,
    ROUND(MAX(julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp)), 0) AS dias_maximo,
    SUM(CASE WHEN date(order_delivered_customer_date) > date(order_estimated_delivery_date) THEN 1 ELSE 0 END) AS pedidos_tarde,
    ROUND(SUM(CASE WHEN date(order_delivered_customer_date) > date(order_estimated_delivery_date) THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS porcentaje_tarde
FROM olist_orders_dataset
WHERE order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL
    AND order_purchase_timestamp >= '2017-01-01'
    AND order_purchase_timestamp < '2018-09-01';


querie 2

SELECT
    strftime('%Y-%m', order_purchase_timestamp) AS mes,
    COUNT(*) AS pedidos,
    ROUND(AVG(julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp)), 1) AS dias_promedio_entrega,
    ROUND(SUM(CASE WHEN date(order_delivered_customer_date) > date(order_estimated_delivery_date) THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS porcentaje_tarde
FROM olist_orders_dataset
WHERE order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL
    AND order_purchase_timestamp >= '2017-01-01'
    AND order_purchase_timestamp < '2018-09-01'
GROUP BY mes
ORDER BY mes;

querie 3

SELECT
    CASE WHEN date(o.order_delivered_customer_date) > date(o.order_estimated_delivery_date)
         THEN 'Tarde' ELSE 'A tiempo' END AS entrega,
    COUNT(DISTINCT o.order_id) AS pedidos,
    ROUND(AVG(r.review_score), 2) AS puntaje_promedio
FROM olist_orders_dataset o
JOIN olist_order_reviews_dataset r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL
    AND o.order_purchase_timestamp >= '2017-01-01'
    AND o.order_purchase_timestamp < '2018-09-01'
GROUP BY entrega;
