# ejemplo 5: 3D simple (matrices 4x4 + proyeccion ortografica).
# conceptos nuevos:
#   1. en 3D usamos coordenadas homogeneas (x, y, z, 1) y matrices 4x4.
#   2. la rotacion en 3D necesita ELEGIR UN EJE: hay tres rotaciones distintas,
#      una por eje, y no conmutan entre si.
#
#        Rx(t) = [1   0       0     0]    Ry(t) = [ cos  0   sin  0]
#                [0   cos   -sin    0]            [  0   1    0   0]
#                [0   sin    cos    0]            [-sin  0   cos  0]
#                [0   0      0      1]            [  0   0    0   1]
#
#        Rz(t) = [cos  -sin  0  0]
#                [sin   cos  0  0]
#                [ 0    0    1  0]
#                [ 0    0    0  1]
#
#   3. para mostrar 3D en una pantalla 2D necesitamos PROYECTAR. la forma mas
#      simple es "olvidar la z" (ortografica): los objetos lejos se ven del
#      mismo tamaño que los cercanos. no es realista pero alcanza para empezar.
#      en el ejercicio ex1 vamos a agregar perspectiva (lejos = mas chico).
#
# el cubo se mantiene centrado en el origen del mundo; la proyeccion se
# encarga de llevarlo al centro de la pantalla. esa separacion entre
# "pose del objeto en el mundo" y "como lo vemos en pantalla" es lo que
# permite cambiar la proyeccion despues sin tocar el resto del codigo.

import arcade
import numpy as np

WIDTH = 800
HEIGHT = 800
TITLE = "05 - cubo 3D (proyeccion ortografica)"


def T3(dx, dy, dz):
    return np.array([
        [1, 0, 0, dx],
        [0, 1, 0, dy],
        [0, 0, 1, dz],
        [0, 0, 0,  1],
    ], dtype=float)


def S3(sx, sy, sz):
    return np.array([
        [sx, 0,  0,  0],
        [0,  sy, 0,  0],
        [0,  0,  sz, 0],
        [0,  0,  0,  1],
    ], dtype=float)


def Rx(t):
    c, s = np.cos(t), np.sin(t)
    return np.array([
        [1, 0,  0, 0],
        [0, c, -s, 0],
        [0, s,  c, 0],
        [0, 0,  0, 1],
    ], dtype=float)


def Ry(t):
    c, s = np.cos(t), np.sin(t)
    return np.array([
        [ c, 0, s, 0],
        [ 0, 1, 0, 0],
        [-s, 0, c, 0],
        [ 0, 0, 0, 1],
    ], dtype=float)


def Rz(t):
    c, s = np.cos(t), np.sin(t)
    return np.array([
        [c, -s, 0, 0],
        [s,  c, 0, 0],
        [0,  0, 1, 0],
        [0,  0, 0, 1],
    ], dtype=float)


class Object3D:
    """objeto 3D en wireframe: lista de vertices + lista de aristas (i, j)."""

    def __init__(self, vertices, edges, color):
        self.vertices = list(vertices)
        self.edges = list(edges)
        self.color = color

    def apply(self, M):
        V = np.array([[x, y, z, 1] for x, y, z in self.vertices]).T  # 4 x N
        V2 = M @ V
        self.vertices = [
            (float(V2[0, i]), float(V2[1, i]), float(V2[2, i]))
            for i in range(V2.shape[1])
        ]

    def translate(self, dx, dy, dz):
        self.apply(T3(dx, dy, dz))

    def scale(self, sx, sy, sz):
        self.apply(S3(sx, sy, sz))

    def rotate(self, theta, axis):
        Rm = {"x": Rx, "y": Ry, "z": Rz}[axis.lower()](theta)
        self.apply(Rm)

    def project_orthographic(self, screen_w, screen_h):
        # ortografica: ignoramos la z y centramos en pantalla.
        return [(x + screen_w / 2, y + screen_h / 2) for x, y, _ in self.vertices]

    def draw(self, screen_w, screen_h):
        pts = self.project_orthographic(screen_w, screen_h)
        for i, j in self.edges:
            x0, y0 = pts[i]
            x1, y1 = pts[j]
            arcade.draw_line(x0, y0, x1, y1, self.color, 2)


# cubo unitario centrado en el origen, vertices en {-1, +1}^3
CUBE_VERTICES = [
    ( 1,  1,  1), ( 1,  1, -1), ( 1, -1,  1), ( 1, -1, -1),
    (-1,  1,  1), (-1,  1, -1), (-1, -1,  1), (-1, -1, -1),
]
CUBE_EDGES = [
    (0, 1), (1, 3), (3, 2), (2, 0),     # cara x = +1
    (4, 5), (5, 7), (7, 6), (6, 4),     # cara x = -1
    (0, 4), (1, 5), (2, 6), (3, 7),     # conexiones entre las dos caras
]


class Cube3DView(arcade.View):
    def __init__(self):
        super().__init__()
        self.background_color = arcade.color.BLACK
        self.cube = Object3D(CUBE_VERTICES, CUBE_EDGES, arcade.color.YELLOW)
        # llevamos el cubo unitario a un tamaño visible (lado = 300 px)
        self.cube.scale(150, 150, 150)

    def on_update(self, dt):
        # rotacion sostenida: yaw alrededor de Y, leve pitch alrededor de X.
        self.cube.rotate(dt * 0.8, "y")
        self.cube.rotate(dt * 0.3, "x")

    def on_draw(self):
        self.clear()
        self.cube.draw(WIDTH, HEIGHT)
        arcade.draw_text("proyeccion ortografica: la z se ignora al dibujar",
                         20, 20, arcade.color.WHITE, 14)


def main():
    window = arcade.Window(WIDTH, HEIGHT, TITLE)
    window.show_view(Cube3DView())
    arcade.run()


if __name__ == "__main__":
    main()
