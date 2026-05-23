# ejemplo 1: transformaciones 2D "a mano" (sin matrices).
# concepto nuevo del modulo: rotar y trasladar un poligono aplicando las
# formulas geometricas directamente sobre cada vertice.
#
#   trasladar:    (x, y) -> (x + dx, y + dy)
#   rotar(t):     (x, y) -> (x*cos(t) - y*sin(t), x*sin(t) + y*cos(t))
#   rotar(t, p):  trasladar -p, rotar en origen, trasladar +p
#                 (rotacion alrededor de un pivote p = (px, py))
#
# en el ejemplo 02 vamos a ver EL MISMO escenario expresado como producto
# de matrices 3x3. la idea es entender primero lo que las matrices automatizan.

import arcade
import math

WIDTH = 800
HEIGHT = 800
TITLE = "01 - transformaciones a mano"

# cuadrado original (vertices en sentido antihorario)
SQUARE = [
    (100, 100),
    (300, 100),
    (300, 300),
    (100, 300),
]


class Polygon:
    """poligono 2D con operaciones aplicadas vertice por vertice."""

    def __init__(self, vertices, color=arcade.color.RED):
        self.vertices = list(vertices)
        self.color = color

    def translate(self, dx, dy):
        self.vertices = [(x + dx, y + dy) for x, y in self.vertices]

    def rotate(self, angle_deg, px=0.0, py=0.0):
        # rotacion alrededor del punto (px, py).
        # paso 1: llevar el pivote al origen (trasladar -p).
        # paso 2: rotar en el origen con la formula clasica.
        # paso 3: volver a colocar el pivote en su lugar (trasladar +p).
        t = math.radians(angle_deg)
        cos_t, sin_t = math.cos(t), math.sin(t)
        rotated = []
        for x, y in self.vertices:
            x0, y0 = x - px, y - py
            xr = x0 * cos_t - y0 * sin_t
            yr = x0 * sin_t + y0 * cos_t
            rotated.append((xr + px, yr + py))
        self.vertices = rotated

    def draw(self):
        arcade.draw_polygon_outline(self.vertices, self.color, 3)


class NaiveTransformView(arcade.View):
    def __init__(self):
        super().__init__()
        self.background_color = arcade.color.BLACK

        # cuadrado original en rojo
        self.original = Polygon(SQUARE, arcade.color.RED)

        # mismo cuadrado, rotado -75 grados alrededor del punto (100, 100)
        self.rotated = Polygon(SQUARE, arcade.color.GREEN)
        self.rotated.rotate(-75, px=100, py=100)

        # otro mas, esta vez solo trasladado
        self.shifted = Polygon(SQUARE, arcade.color.CYAN)
        self.shifted.translate(350, 350)

    def on_draw(self):
        self.clear()
        self.original.draw()
        self.rotated.draw()
        self.shifted.draw()

        # marcar el pivote para entender visualmente la rotacion
        arcade.draw_circle_filled(100, 100, 5, arcade.color.YELLOW)
        arcade.draw_text("pivote (100, 100)", 110, 90, arcade.color.YELLOW, 14)
        arcade.draw_text("rojo: original  |  verde: rotado -75°  |  cyan: trasladado",
                         20, 20, arcade.color.WHITE, 14)


def main():
    window = arcade.Window(WIDTH, HEIGHT, TITLE)
    window.show_view(NaiveTransformView())
    arcade.run()


if __name__ == "__main__":
    main()
