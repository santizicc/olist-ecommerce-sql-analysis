querie 1

WITH pedidos_por_cliente AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS pedidos
    FROM olist_orders_dataset o
    JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
        AND o.order_purchase_timestamp >= '2017-01-01'
        AND o.order_purchase_timestamp < '2018-09-01'
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS clientes_totales,
    SUM(CASE WHEN pedidos >= 2 THEN 1 ELSE 0 END) AS clientes_que_repiten,
    ROUND(SUM(CASE WHEN pedidos >= 2 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS porcentaje_recompra,
    ROUND(AVG(pedidos), 3) AS pedidos_promedio_por_cliente
FROM pedidos_por_cliente;


querie 2
WITH pedidos_por_cliente AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS pedidos
    FROM olist_orders_dataset o
    JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
        AND o.order_purchase_timestamp >= '2017-01-01'
        AND o.order_purchase_timestamp < '2018-09-01'
    GROUP BY c.customer_unique_id
)
SELECT
    pedidos,
    COUNT(*) AS clientes
FROM pedidos_por_cliente
GROUP BY pedidos
ORDER BY pedidos;
