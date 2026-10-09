SELECT 
    strftime('%Y-%m', o.order_purchase_timestamp) AS mes,
    ROUND(SUM(i.price), 2) AS facturacion_sin_envio,
    COUNT(DISTINCT o.order_id) AS total_pedidos,
    ROUND(SUM(i.price) / COUNT(DISTINCT o.order_id), 2) AS ticket_promedio
FROM 
    olist_orders_dataset o
JOIN 
    olist_order_items_dataset i ON o.order_id = i.order_id
WHERE 
    o.order_status = 'delivered'
	AND o.order_purchase_timestamp >= '2017-01-01'
    AND o.order_purchase_timestamp < '2018-09-01'
GROUP BY 
    mes
ORDER BY 
    mes ASC;
