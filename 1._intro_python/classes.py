import math

# declaracion de clase: plantilla para crear objetos con atributos y metodos
class Point:
    def __init__(self, x: float, y: float):
        self.x = x
        self.y = y

    def distance_to(self, other: "Point") -> float:
        dx = other.x - self.x
        dy = other.y - self.y
        return math.sqrt(dx * dx + dy * dy)

    def __str__(self) -> str:
        return f"Point({self.x}, {self.y})"
    
# intanciar objetos: crear variables que son instancias de la clase
origen = Point(0, 0)
a = Point(300, 400)
b = Point(100, 100)

print(type(Point))
print(type(origen))
print(origen.distance_to(a))
print(a)

poligono = [Point(0, 0), Point(100, 0), Point(100, 100), Point(0, 100)]

for punto in poligono:
    print(origen.distance_to(punto))