# ejemplo 3: la composicion de transformaciones NO es conmutativa.
# concepto nuevo: dadas dos matrices A y B, en general
#     A @ B  !=  B @ A
# es decir: trasladar-y-luego-rotar NO es lo mismo que rotar-y-luego-trasladar.
# este ejemplo lo muestra visualmente con el mismo cuadrado y los mismos
# numeros, aplicados en distinto orden.
#
# recordatorio del orden: el producto se aplica de derecha a izquierda.
#   M = A @ B   ->   primero se aplica B al vertice, luego A al resultado.
#
# verde:    M_a = T(250, 0) @ R(45)   "rotar 45°, despues trasladar"
# magenta:  M_b = R(45) @ T(250, 0)   "trasladar, despues rotar"
#
# el cuadrado parte centrado en (200, 350). los dos caminos llevan a
# posiciones MUY distintas: la rotacion alrededor del origen del mundo, una
# vez trasladado, "barre" al cuadrado por un arco grande.

import arcade
import numpy as np

WIDTH = 900
HEIGHT = 700
TITLE = "03 - el orden de composicion importa"

SQUARE = [
    (-30, -30),
    ( 30, -30),
    ( 30,  30),
    (-30,  30),
]
START = (200, 350)


def T(dx, dy):
    return np.array([[1, 0, dx], [0, 1, dy], [0, 0, 1]], dtype=float)


def R(angle_deg):
    t = np.radians(angle_deg)
    c, s = np.cos(t), np.sin(t)
    return np.array([[c, -s, 0], [s, c, 0], [0, 0, 1]], dtype=float)


def apply(M, vertices):
    V = np.array([[x, y, 1] for x, y in vertices]).T
    V2 = M @ V
    return [(float(V2[0, i]), float(V2[1, i])) for i in range(V2.shape[1])]


class ComposeOrderView(arcade.View):
    def __init__(self):
        super().__init__()
        self.background_color = arcade.color.BLACK

        # primero colocamos el cuadrado base en START. desde ahi aplicamos
        # las dos composiciones a explorar.
        self.base = apply(T(*START), SQUARE)

        # camino A: rotar 45° y DESPUES trasladar (250, 0)
        # leer M_a derecha a izquierda: aplica R(45) al base, luego T(250, 0)
        M_a = T(250, 0) @ R(45)
        self.poly_a = apply(M_a, self.base)

        # camino B: trasladar (250, 0) y DESPUES rotar 45°
        M_b = R(45) @ T(250, 0)
        self.poly_b = apply(M_b, self.base)

    def on_draw(self):
        self.clear()

        # ejes y origen como referencia
        arcade.draw_line(0, 0, WIDTH, 0, arcade.color.DARK_GRAY, 1)
        arcade.draw_line(0, 0, 0, HEIGHT, arcade.color.DARK_GRAY, 1)
        arcade.draw_circle_filled(0, 0, 6, arcade.color.WHITE)
        arcade.draw_text("(0,0)", 10, 10, arcade.color.WHITE, 12)

        arcade.draw_polygon_outline(self.base, arcade.color.GRAY, 2)
        arcade.draw_polygon_outline(self.poly_a, arcade.color.GREEN, 3)
        arcade.draw_polygon_outline(self.poly_b, arcade.color.MAGENTA, 3)

        arcade.draw_text("gris:     original (en START)",
                         20, HEIGHT - 40, arcade.color.GRAY, 16)
        arcade.draw_text("verde:    M_a = T(250, 0) @ R(45)   -> rotar y luego trasladar",
                         20, HEIGHT - 65, arcade.color.GREEN, 16)
        arcade.draw_text("magenta:  M_b = R(45) @ T(250, 0)   -> trasladar y luego rotar",
                         20, HEIGHT - 90, arcade.color.MAGENTA, 16)
        arcade.draw_text("regla: M = A @ B se lee de derecha a izquierda (B primero)",
                         20, 20, arcade.color.YELLOW, 14)


def main():
    window = arcade.Window(WIDTH, HEIGHT, TITLE)
    window.show_view(ComposeOrderView())
    arcade.run()


if __name__ == "__main__":
    main()
