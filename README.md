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
