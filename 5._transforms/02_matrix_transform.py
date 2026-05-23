# ejemplo 2: las mismas transformaciones, ahora como matrices 3x3.
# concepto nuevo: COORDENADAS HOMOGENEAS. al pasar (x, y) -> (x, y, 1),
# translacion, escala y rotacion se pueden expresar TODAS como una matriz
# 3x3 que multiplicamos por el vector columna del vertice. y lo mas
# importante: componer dos transformaciones = multiplicar sus matrices.
#
#   T(dx, dy) = [1 0 dx]    S(sx, sy) = [sx 0 0]    R(t) = [cos -sin 0]
#               [0 1 dy]                [0 sy 0]           [sin  cos 0]
#               [0 0  1]                [0  0 1]           [0    0   1]
#
# rotacion alrededor de un pivote (px, py):
#       M = T(px, py) @ R(t) @ T(-px, -py)
# (numpy.dot / @ multiplica matrices; leer de DERECHA a IZQUIERDA, porque
# es lo que se aplica primero al vector).
#
# el resultado visual debe ser identico al ejemplo 01. comparen los dos:
# misma escena, dos "lenguajes" para describirla.

import arcade
import numpy as np

WIDTH = 800
HEIGHT = 800
TITLE = "02 - transformaciones con matrices 3x3"

SQUARE = [
    (100, 100),
    (300, 100),
    (300, 300),
    (100, 300),
]


def T(dx, dy):
    return np.array([
        [1, 0, dx],
        [0, 1, dy],
        [0, 0,  1],
    ], dtype=float)


def S(sx, sy):
    return np.array([
        [sx, 0,  0],
        [0,  sy, 0],
        [0,  0,  1],
    ], dtype=float)


def R(angle_deg):
    t = np.radians(angle_deg)
    c, s = np.cos(t), np.sin(t)
    return np.array([
        [c, -s, 0],
        [s,  c, 0],
        [0,  0, 1],
    ], dtype=float)


class Polygon:
    """poligono 2D operado mediante matrices 3x3 en coordenadas homogeneas."""

    def __init__(self, vertices, color=arcade.color.RED):
        self.vertices = list(vertices)
        self.color = color

    def apply(self, M):
        # apilamos los vertices como columnas: cada columna es (x, y, 1).
        # multiplicamos por la matriz, descartamos la fila homogenea y volvemos
        # a una lista de tuplas (x, y).
        V = np.array([[x, y, 1] for x, y in self.vertices]).T   # 3 x N
        V2 = M @ V                                               # 3 x N
        self.vertices = [(float(V2[0, i]), float(V2[1, i])) for i in range(V2.shape[1])]

    def translate(self, dx, dy):
        self.apply(T(dx, dy))

    def scale(self, sx, sy, pivot=(0.0, 0.0)):
        px, py = pivot
        # T(p) @ S @ T(-p): llevar el pivote al origen, escalar, devolverlo.
        self.apply(T(px, py) @ S(sx, sy) @ T(-px, -py))

    def rotate(self, angle_deg, pivot=(0.0, 0.0)):
        px, py = pivot
        # mismo patron T @ R @ T^{-1} que en 01_naive_transform.py, pero ahora
        # es una sola multiplicacion de matrices en lugar de codigo a mano.
        self.apply(T(px, py) @ R(angle_deg) @ T(-px, -py))

    def draw(self):
        arcade.draw_polygon_outline(self.vertices, self.color, 3)


class MatrixTransformView(arcade.View):
    def __init__(self):
        super().__init__()
        self.background_color = arcade.color.BLACK

        # rojo: original (mismo cuadrado que 01)
        self.original = Polygon(SQUARE, arcade.color.RED)

        # verde: rotado -75° alrededor del pivote (100, 100) — IGUAL que 01
        self.rotated = Polygon(SQUARE, arcade.color.GREEN)
        self.rotated.rotate(-75, pivot=(100, 100))

        # cyan: trasladado — IGUAL que 01
        self.shifted = Polygon(SQUARE, arcade.color.CYAN)
        self.shifted.translate(350, 350)

        # extra: escalado a la mitad alrededor de su propio centro (200, 200)
        self.scaled = Polygon(SQUARE, arcade.color.MAGENTA)
        self.scaled.scale(0.5, 0.5, pivot=(200, 200))
        self.scaled.translate(450, 100)

    def on_draw(self):
        self.clear()
        self.original.draw()
        self.rotated.draw()
        self.shifted.draw()
        self.scaled.draw()
        arcade.draw_circle_filled(100, 100, 5, arcade.color.YELLOW)
        arcade.draw_text("mismo resultado que 01, expresado como producto de matrices 3x3",
                         20, 20, arcade.color.WHITE, 14)


def main():
    window = arcade.Window(WIDTH, HEIGHT, TITLE)
    window.show_view(MatrixTransformView())
    arcade.run()


if __name__ == "__main__":
    main()
