# ejercicio 1: pelota que rebota.
# introduce on_update(delta_time): el callback que arcade llama cada frame
# automaticamente, sin necesidad de un evento del usuario.

import arcade
import random

WIDTH = 800
HEIGHT = 600
TITLE = "pelota rebotando"


class Ball:
    def __init__(self, x: float, y: float, vx: float, vy: float, r: float = 20):
        self.x = x
        self.y = y
        self.vx = vx  # velocidad en pixeles por segundo
        self.vy = vy
        self.r = r
        self.color = arcade.color.CYAN

    def update(self, dt: float, w: int, h: int):
        # integrar posicion: pos += velocidad * tiempo
        self.x += self.vx * dt
        self.y += self.vy * dt

        # rebote en bordes: invertir velocidad y empujar dentro del area
        if self.x - self.r < 0:
            self.x = self.r
            self.vx = -self.vx
            self.color = (int(random.random() * 255), int(random.random() * 255), int(random.random() * 255))
        elif self.x + self.r > w:
            self.x = w - self.r
            self.vx = -self.vx
            self.color = (int(random.random() * 255), int(random.random() * 255), int(random.random() * 255))

        if self.y - self.r < 0:
            self.y = self.r
            self.vy = -self.vy
            self.color = (int(random.random() * 255), int(random.random() * 255), int(random.random() * 255))
        elif self.y + self.r > h:
            self.y = h - self.r
            self.vy = -self.vy
            self.color = (int(random.random() * 255), int(random.random() * 255), int(random.random() * 255))

    def draw(self):
        arcade.draw_circle_filled(self.x, self.y, self.r, self.color)


class BouncingView(arcade.View):
    def __init__(self):
        super().__init__()
        self.background_color = arcade.color.DARK_BLUE_GRAY
        self.ball = Ball(x=WIDTH // 2, y=HEIGHT // 2, vx=100, vy=220)
        self.balls = [self.ball]

    def on_update(self, delta_time: float):
        # arcade llama esto ~60 veces por segundo. delta_time = segundos
        # transcurridos desde el frame anterior.
        self.ball.update(delta_time, WIDTH, HEIGHT)

    def on_draw(self):
        self.clear()
        self.ball.draw()


def main():
    window = arcade.Window(WIDTH, HEIGHT, TITLE)
    view = BouncingView()
    window.show_view(view)
    arcade.run()


if __name__ == "__main__":
    main()
