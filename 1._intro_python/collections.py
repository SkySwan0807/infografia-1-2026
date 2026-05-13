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