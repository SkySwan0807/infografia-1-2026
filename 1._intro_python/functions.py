# declaracion de la funcion
def saludar(nombre):
    print(f"Hola {nombre}!")
    print("mucho gusto")

# p1 = (x, y)
def calcular_distancia(p1, p2):
    dx = p2[0] - p1[0]
    dy = p2[1] - p1[1]

    return (dx**2 + dy**2)**0.5

a = (0, 0)
b = 300, 400

distancia = calcular_distancia(a, b)