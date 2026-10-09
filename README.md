# olist-ecommerce-sql-analysis
# Análisis de ventas de e-commerce (Olist) con SQL

Análisis de datos reales de un marketplace brasileño para responder preguntas
de negocio con SQL. El objetivo es pasar de los datos crudos a conclusiones
claras que sirvan para tomar decisiones.

- **Dataset:** [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (Kaggle)
- **Herramientas:** SQL (SQLite) y DB Browser for SQLite
- **Autor:** Santiago, estudiante avanzado de Sistemas de Información de las Organizaciones (UBA)

> Los montos están en reales brasileños (R$) y no incluyen el costo de envío.
> El dataset no se incluye en este repositorio: se descarga desde Kaggle.

## Resumen de hallazgos

- Las ventas crecieron de forma sostenida durante 2017 y alcanzaron su máximo en noviembre, con un salto de 52% respecto de octubre.
- El aumento de noviembre vino de la cantidad de pedidos y no del precio: el ticket promedio se mantuvo estable.

*(Se irán sumando hallazgos a medida que se resuelvan las demás preguntas.)*

---

## 1. ¿Cuánto se vendió por mes y cómo evolucionó?

**Alcance:** pedidos entregados (`delivered`) entre enero de 2017 y agosto de 2018.
Se excluyen los meses de los extremos del dataset porque tienen datos incompletos.

**Consulta:** [`queries/01_ventas_por_mes.sql`](queries/01_ventas_por_mes.sql)

<details>
<summary>Ver la consulta SQL</summary>

```sql
SELECT
    strftime('%Y-%m', o.order_purchase_timestamp) AS mes,
    ROUND(SUM(i.price), 2) AS facturacion_sin_envio,
    COUNT(DISTINCT o.order_id) AS
## 2. ¿Cuáles son las 10 categorías que más facturan?

**Alcance:** mismo período y filtros que la pregunta 1 (pedidos entregados,
enero de 2017 a agosto de 2018). Las categorías se tradujeron al inglés con la
tabla de traducción del dataset.

**Consulta:** [`queries/02_top_categorias.sql`](queries/02_top_categorias.sql)

<details>
<summary>Ver la consulta SQL</summary>

```sql
SELECT
    COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS categoria,
    ROUND(SUM(i.price), 2) AS facturacion_sin_envio,
    COUNT(DISTINCT o.order_id) AS total_pedidos,
    ROUND(SUM(i.price) / COUNT(DISTINCT o.order_id), 2) AS facturacion_por_pedido,
    ROUND(SUM(i.price) * 100.0 / SUM(SUM(i.price)) OVER (), 2) AS porcentaje_del_total
FROM olist_orders_dataset o
JOIN olist_order_items_dataset i ON o.order_id = i.order_id
JOIN olist_products_dataset p ON i.product_id = p.product_id
LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
    AND o.order_purchase_timestamp >= '2017-01-01'
    AND o.order_purchase_timestamp < '2018-09-01'
GROUP BY categoria
ORDER BY facturacion_sin_envio DESC
LIMIT 10;
```

</details>

**Resultado:** [`results/02_top_categorias.csv`](results/02_top_categorias.csv)

![Top 10 categorías por facturación](results/02_top_categorias.png)

**Conclusión:**
Las diez categorías más vendidas concentran el 62,5% de la facturación (sin
envío) entre enero de 2017 y agosto de 2018, y ninguna supera el 10% del
total, por lo que las ventas están repartidas. Salud y belleza lidera con
R$ 1,23 millones (9,3%), seguida por relojes y regalos (R$ 1,16 millones) y
cama, baño y mesa (R$ 1,02 millones).

Los perfiles son distintos: relojes y regalos factura casi lo mismo que salud
y belleza con un 36% menos de pedidos, porque cada pedido vale cerca de un 50%
más (R$ 212 contra R$ 143). Cama, baño y mesa, en cambio, vende por volumen:
tiene el mayor número de pedidos (9.267) y un valor por pedido bajo (R$ 110).

**Recomendación:** cuidar el stock y la promoción de las categorías líderes y
evaluar la logística de las de mayor valor por pedido, donde cada entrega
fallida cuesta más.
