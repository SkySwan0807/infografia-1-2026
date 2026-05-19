# ejemplo 5: subclase de arcade.Sprite con su propio update()
# concepto nuevo: encapsular el comportamiento dentro del sprite. la
# View ya no sabe como rebota la moneda; solo le pide a la SpriteList
# que se actualice, y cada sprite se hace cargo de si mismo.
#
# este es el patron base para tener muchos tipos distintos (jugador,
# enemigo, proyectil, particula...) coexistiendo: todos tienen la misma
# interfaz update(dt) + draw(), pero cada uno con su propia logica
# adentro. polimorfismo de toda la vida.
#
# de paso aparecen las propiedades self.left / self.right / self.top /
# self.bottom: son los bordes del sprite calculados a partir del centro
# y el tamano. mas correctas que comparar center_x con WIDTH a secas.

import arcade
import random

WIDTH = 1280
HEIGHT = 720
TITLE = "05 - sprite con comportamiento propio"


class Bouncer(arcade.Sprite):
    def __init__(self, x, y, vx, vy):
        super().__init__(
            "4._sprites/img/coin.png", scale=0.25,
            center_x=x, center_y=y,
        )
        self.change_x = vx  # px/seg
        self.change_y = vy

    def update(self, delta_time):
        # integrar posicion: pos += velocidad * dt
        self.center_x += self.change_x * delta_time
        self.center_y += self.change_y * delta_time

        # rebote contra bordes: invertir velocidad y encajar adentro.
        # usar left/right/top/bottom respeta el tamano real del sprite.
        if self.left < 0:
            self.left = 0
            self.change_x = -self.change_x
        elif self.right > WIDTH:
            self.right = WIDTH
            self.change_x = -self.change_x

        if self.bottom < 0:
            self.bottom = 0
            self.change_y = -self.change_y
        elif self.top > HEIGHT:
            self.top = HEIGHT
            self.change_y = -self.change_y


class BouncerView(arcade.View):
    def __init__(self):
        super().__init__()
        self.background_color = arcade.color.DARK_SLATE_GRAY
        self.sprites = arcade.SpriteList()
        # arrancar con un par para que se vea algo desde el frame 0
        for _ in range(3):
            self.spawn_one(WIDTH // 2, HEIGHT // 2)

    def spawn_one(self, x, y):
        vx = random.uniform(-300, 300)
        vy = random.uniform(-300, 300)
        self.sprites.append(Bouncer(x, y, vx, vy))

    def on_mouse_press(self, x, y, button, modifiers):
        self.spawn_one(x, y)

    def on_update(self, delta_time):
        # la View no sabe que hacen los sprites; solo dispara update.
        self.sprites.update(delta_time)

    def on_draw(self):
        self.clear()
        self.sprites.draw()
        arcade.draw_text(
            f"{len(self.sprites)} bouncers   (click izquierdo = agregar)",
            10, HEIGHT - 30, arcade.color.WHITE, 16,
        )


def main():
    window = arcade.Window(WIDTH, HEIGHT, TITLE)
    window.show_view(BouncerView())
    arcade.run()


if __name__ == "__main__":
    main()


# extensiones:
# 1. gravedad: en update, antes de chequear bordes, hacer
#       self.change_y -= 800 * delta_time
#    al rebotar contra el piso, perder energia para que no rebote
#    eternamente:
#       self.change_y = -self.change_y * 0.85
# 2. rotar mientras se mueve: self.angle += 200 * delta_time. probar
#    distintos signos segun el sentido de change_x.
# 3. crear una segunda subclase (p.ej. Wanderer) que vague aleatoriamente
#    en vez de rebotar (cada tanto cambia change_x/change_y al azar).
#    mezclarla con Bouncers en la misma SpriteList: comparten la API,
#    cada uno tiene su update propio. esa es la idea de polimorfismo.
