SELECT
    c.customer_state AS estado,
    ROUND(SUM(i.price), 2) AS facturacion_sin_envio,
    COUNT(DISTINCT o.order_id) AS total_pedidos,
    COUNT(DISTINCT c.customer_unique_id) AS clientes_unicos,
    ROUND(SUM(i.price) / COUNT(DISTINCT o.order_id), 2) AS facturacion_por_pedido,
    ROUND(SUM(i.price) * 100.0 / SUM(SUM(i.price)) OVER (), 2) AS porcentaje_del_total
FROM olist_orders_dataset o
JOIN olist_order_items_dataset i ON o.order_id = i.order_id
JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
    AND o.order_purchase_timestamp >= '2017-01-01'
    AND o.order_purchase_timestamp < '2018-09-01'
GROUP BY c.customer_state
ORDER BY facturacion_sin_envio DESC
LIMIT 10;
