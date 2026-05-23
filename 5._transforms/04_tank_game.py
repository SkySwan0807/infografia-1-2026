# ejemplo 4: tanque interactivo (composicion de transformaciones a 60 FPS).
# concepto nuevo: aplicar matrices ACUMULATIVAMENTE en cada frame. en cada
# tick el tanque gira un delta angular y se mueve un delta lineal en la
# direccion en la que apunta. la matriz de pose del cuerpo se va
# transformando frame a frame, sin recalcular desde cero.
#
# este es el patron que usa todo motor de juegos para mover objetos: en vez
# de recomputar la posicion absoluta, COMPONES una transformacion delta
# sobre la transformacion actual.
#
# controles:
#   flecha arriba / abajo   -> velocidad lineal (avance / reversa)
#   flecha izq / der        -> velocidad angular (girar)
#   click izquierdo         -> disparar una bala (punto que viaja recto)
#   r                       -> respawn

import arcade
import math
import numpy as np
import random

WIDTH = 900
HEIGHT = 700
TITLE = "04 - tanque interactivo"

SPEED = 220            # px / segundo
ANGULAR_SPEED = 2.5    # rad / segundo
BULLET_SPEED = 600     # px / segundo
BULLET_LIFETIME = 2.0  # segundos


def T(dx, dy):
    return np.array([[1, 0, dx], [0, 1, dy], [0, 0, 1]], dtype=float)


def R(theta):
    c, s = math.cos(theta), math.sin(theta)
    return np.array([[c, -s, 0], [s, c, 0], [0, 0, 1]], dtype=float)


class Polygon:
    def __init__(self, vertices, color):
        self.vertices = list(vertices)
        self.color = color

    def apply(self, M):
        V = np.array([[x, y, 1] for x, y in self.vertices]).T
        V2 = M @ V
        self.vertices = [(float(V2[0, i]), float(V2[1, i])) for i in range(V2.shape[1])]

    def translate(self, dx, dy):
        self.apply(T(dx, dy))

    def rotate(self, theta, pivot):
        px, py = pivot
        self.apply(T(px, py) @ R(theta) @ T(-px, -py))

    def draw(self):
        arcade.draw_polygon_outline(self.vertices, self.color, 4)


class Tank:
    def __init__(self, x, y, color):
        # estado: posicion del centro, angulo, velocidades.
        self.x = x
        self.y = y
        self.theta = 0.0
        self.speed = 0.0
        self.angular_speed = 0.0

        # cuerpo: triangulo apuntando a +x, centrado en (x, y).
        local = [(40, 0), (-30, 25), (-30, -25)]
        self.body = Polygon([(vx + x, vy + y) for vx, vy in local], color)

        # cada bala: [x, y, theta, tiempo_de_vida_restante]
        self.bullets: list[list[float]] = []

    def shoot(self):
        self.bullets.append([self.x, self.y, self.theta, BULLET_LIFETIME])

    def update(self, dt):
        # 1) deltas de este frame, calculados con la orientacion ACTUAL
        dtheta = self.angular_speed * dt
        dx = self.speed * math.cos(self.theta) * dt
        dy = self.speed * math.sin(self.theta) * dt

        # 2) aplicar la rotacion ALREDEDOR DEL CENTRO actual, luego la translacion.
        #    importante: rotamos primero, asi el "front" del tanque queda alineado
        #    con la nueva direccion antes de movernos.
        self.body.rotate(dtheta, pivot=(self.x, self.y))
        self.body.translate(dx, dy)

        # 3) sincronizar el estado del tanque
        self.theta += dtheta
        self.x += dx
        self.y += dy

        # 4) balas: viajan en linea recta en la direccion que tenian al ser disparadas
        for b in self.bullets:
            b[0] += BULLET_SPEED * math.cos(b[2]) * dt
            b[1] += BULLET_SPEED * math.sin(b[2]) * dt
            b[3] -= dt
        self.bullets = [
            b for b in self.bullets
            if b[3] > 0 and 0 <= b[0] <= WIDTH and 0 <= b[1] <= HEIGHT
        ]

    def draw(self):
        self.body.draw()
        # punto blanco en el centro: util para "ver" donde esta el pivote.
        arcade.draw_circle_filled(self.x, self.y, 3, arcade.color.WHITE)
        for x, y, _, _ in self.bullets:
            arcade.draw_circle_filled(x, y, 5, arcade.color.RED)


class TankView(arcade.View):
    def __init__(self):
        super().__init__()
        self.background_color = arcade.color.BLACK
        self._reset_tank()

    def _reset_tank(self):
        color = (
            random.randint(120, 255),
            random.randint(120, 255),
            random.randint(120, 255),
        )
        self.tank = Tank(WIDTH // 2, HEIGHT // 2, color)

    def on_key_press(self, symbol, modifiers):
        if symbol == arcade.key.UP:
            self.tank.speed = SPEED
        if symbol == arcade.key.DOWN:
            self.tank.speed = -SPEED
        if symbol == arcade.key.LEFT:
            self.tank.angular_speed = ANGULAR_SPEED
        if symbol == arcade.key.RIGHT:
            self.tank.angular_speed = -ANGULAR_SPEED
        if symbol == arcade.key.R:
            self._reset_tank()

    def on_key_release(self, symbol, modifiers):
        if symbol in (arcade.key.UP, arcade.key.DOWN):
            self.tank.speed = 0
        if symbol in (arcade.key.LEFT, arcade.key.RIGHT):
            self.tank.angular_speed = 0

    def on_mouse_press(self, x, y, button, modifiers):
        if button == arcade.MOUSE_BUTTON_LEFT:
            self.tank.shoot()

    def on_update(self, dt):
        self.tank.update(dt)

    def on_draw(self):
        self.clear()
        self.tank.draw()
        arcade.draw_text(
            "flechas: mover/girar  |  click: disparar  |  r: respawn",
            20, 20, arcade.color.LIGHT_GRAY, 14,
        )


def main():
    window = arcade.Window(WIDTH, HEIGHT, TITLE)
    window.show_view(TankView())
    arcade.run()


if __name__ == "__main__":
    main()
