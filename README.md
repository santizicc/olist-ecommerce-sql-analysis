# olist-ecommerce-sql-analysis
## 1. ¿Cuánto se vendió por mes y cómo evolucionó?

**Alcance:** pedidos entregados (`delivered`) entre enero de 2017 y agosto de 2018.
Se excluyen los meses de los extremos del dataset porque tienen datos incompletos.
Los montos están en reales brasileños (R$) y no incluyen el costo de envío.

**Consulta:** [`queries/01_ventas_por_mes.sql`](queries/01_ventas_por_mes.sql)

```sql
SELECT
    strftime('%Y-%m', o.order_purchase_timestamp) AS mes,
    ROUND(SUM(i.price), 2) AS facturacion_sin_envio,
    COUNT(DISTINCT o.order_id) AS total_pedidos,
    ROUND(SUM(i.price) / COUNT(DISTINCT o.order_id), 2) AS ticket_promedio
FROM olist_orders_dataset o
JOIN olist_order_items_dataset i ON o.order_id = i.order_id
WHERE o.order_status = 'delivered'
    AND o.order_purchase_timestamp >= '2017-01-01'
    AND o.order_purchase_timestamp < '2018-09-01'
GROUP BY mes
ORDER BY mes ASC;
```

**Resultado:** [`results/01_ventas_por_mes.csv`](results/01_ventas_por_mes.csv)

![Facturación mensual](results/01_ventas_por_mes.png)

**Conclusión:**
La facturación creció de forma sostenida durante 2017: pasó de R$ 111.798 en
enero a R$ 726.033 en diciembre. El máximo del año fue en noviembre, con
R$ 987.765, un 52% más que en octubre (R$ 648.248). El pico coincide con el
Black Friday.

El salto de noviembre vino del volumen y no del precio: los pedidos pasaron
de 4.478 a 7.289 (+63%), mientras que el ticket promedio bajó de R$ 144,76 a
R$ 135,51. A lo largo de 2017 el ticket promedio se mantuvo estable, entre
R$ 124 y R$ 149. En 2018, [COMPLETAR: qué pasó con las ventas, por ejemplo
si se mantuvieron por encima de los niveles de noviembre de 2017 o bajaron].

**Recomendación:** reforzar el stock, la logística y la atención al cliente
de cara a noviembre, que es el mes de mayor demanda.
