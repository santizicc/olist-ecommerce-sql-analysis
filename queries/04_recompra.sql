


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
