import os
os.chdir(os.path.dirname(os.path.abspath(__file__)))

import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.ticker import FuncFormatter

miles = FuncFormatter(lambda x, _: f"{x/1000:,.0f} mil")


def leer(nombre):
    df = pd.read_csv(nombre, sep=None, engine="python", encoding="utf-8-sig")
    df.columns = df.columns.str.strip()
    return df


def guardar(nombre):
    plt.tight_layout()
    plt.savefig(nombre, dpi=150)
    plt.close()
    print("Guardado:", nombre)


# 1. Facturación mensual
df = leer("results01.csv")
plt.figure(figsize=(10, 5))
plt.plot(df["mes"], df["facturacion_sin_envio"], marker="o", color="#2563eb")
plt.title("Facturación mensual (R$), 2017 a 2018")
plt.ylabel("Facturación sin envío (R$)")
plt.xticks(rotation=45)
plt.gca().yaxis.set_major_formatter(miles)
plt.grid(axis="y", alpha=0.3)
guardar("results01.png")

# 2. Top 10 categorías
df = leer("results02.csv").sort_values("facturacion_sin_envio")
plt.figure(figsize=(9, 5))
plt.barh(df["categoria"], df["facturacion_sin_envio"], color="#2563eb")
plt.title("Top 10 categorías por facturación (R$)")
plt.xlabel("Facturación sin envío (R$)")
plt.gca().xaxis.set_major_formatter(miles)
guardar("results02.png")

# 3. Top 10 estados
df = leer("results03.csv")
plt.figure(figsize=(9, 5))
plt.bar(df["estado"], df["facturacion_sin_envio"], color="#2563eb")
plt.title("Top 10 estados por facturación (R$)")
plt.ylabel("Facturación sin envío (R$)")
plt.gca().yaxis.set_major_formatter(miles)
guardar("results03.png")

# 4. Recompra (solo clientes que repiten)
etiquetas = ["2 pedidos", "3 pedidos", "4 o más"]
clientes = [2562, 180, 47]
plt.figure(figsize=(7, 5))
barras = plt.bar(etiquetas, clientes, color="#2563eb")
plt.bar_label(barras)
plt.title("Clientes que volvieron a comprar (3% del total)")
plt.ylabel("Cantidad de clientes")
guardar("results04.png")

# 5. Entregas tarde por mes
df = leer("results05.csv")
plt.figure(figsize=(10, 5))
plt.plot(df["mes"], df["porcentaje_tarde"], marker="o", color="#dc2626")
plt.title("Porcentaje de entregas tarde por mes (%)")
plt.ylabel("Pedidos entregados tarde (%)")
plt.xticks(rotation=45)
plt.grid(axis="y", alpha=0.3)
guardar("results05.png")

print("Carpeta:", os.getcwd())
print("Imágenes creadas:", [f for f in os.listdir() if f.endswith(".png")])
