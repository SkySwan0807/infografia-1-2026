# listas: ordenadas, mutables
colores = ["rojo", "verde", "azul"]
print(colores[2])
colores[0] = "naranja"
print(colores)
colores.append([3, 4, "hola"])
print(colores)
print(colores[:2])
print(len(colores))

# for i in range(len(colores)):
#     print(colores[len(colores)-1-i])

# forma pythonica de iterar sobre una lista
for color in colores[::-1]:
    print(color)


# tuplas: ordenadas, inmutables. utiles para puntos (x, y)
p1 = (100, 200)
p2 = (300, 400)
# print(f"x={p1[0]}, y={p1[1]}")

# una lista de puntos = los vertices de un poligono
poligono = [(0, 0), (100, 0), (100, 100), (0, 100)]
for x, y in poligono:
    print(f"x={x}, y={y}")


# diccionarios: pares clave-valor
color_rgb = {
    "rojo":  (255, 0, 0),
    "verde": (0, 255, 0),
    "azul":  (0, 0, 255),
}

color_rgb["cyan"] = (0, 255, 255)

for color, valor_rgb in color_rgb.items():
    print(color, valor_rgb)