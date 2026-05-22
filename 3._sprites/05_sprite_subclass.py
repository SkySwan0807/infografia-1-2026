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
GRAVITY = 800

class Bouncer(arcade.Sprite):
    def __init__(self, x, y, vx, vy):
        super().__init__(
            r"Git de clase\infografia-1-2026\3._sprites\img\coin.png",
            scale=0.25,
            center_x=x,
            center_y=y,
        )

        self.change_x = vx
        self.change_y = vy

    def update(self, delta_time):
        self.change_y -= GRAVITY * delta_time

        self.center_x += self.change_x * delta_time
        self.center_y += self.change_y * delta_time

        if self.change_x > 0:
            self.angle += 200 * delta_time
        else:
            self.angle -= 200 * delta_time


        if self.left < 0:
            self.left = 0
            self.change_x = -self.change_x
        elif self.right > WIDTH:
            self.right = WIDTH
            self.change_x = -self.change_x

        if self.bottom < 0:
            self.bottom = 0
            # perder energia en cada rebote
            self.change_y = -self.change_y * 0.85

        elif self.top > HEIGHT:
            self.top = HEIGHT
            self.change_y = -self.change_y

class Wanderer(arcade.Sprite):
    def __init__(self, x, y):
        super().__init__(
            r"Git de clase\infografia-1-2026\3._sprites\img\coin.png",
            scale=0.20,
            center_x=x,
            center_y=y,
        )

        self.color = arcade.color.SKY_BLUE

        self.change_x = random.uniform(-200, 200)
        self.change_y = random.uniform(-200, 200)

        # tiempo hasta cambiar direccion
        self.timer = random.uniform(0.5, 2.0)

    def update(self, delta_time):

        self.timer -= delta_time

        if self.timer <= 0:

            self.change_x = random.uniform(-250, 250)
            self.change_y = random.uniform(-250, 250)

            self.timer = random.uniform(0.5, 2.0)

        self.center_x += self.change_x * delta_time
        self.center_y += self.change_y * delta_time

        self.angle += 120 * delta_time

        if self.right < 0:
            self.left = WIDTH

        elif self.left > WIDTH:
            self.right = 0

        if self.top < 0:
            self.bottom = HEIGHT

        elif self.bottom > HEIGHT:
            self.top = 0

class BouncerView(arcade.View):
    def __init__(self):
        super().__init__()
        self.background_color = arcade.color.DARK_SLATE_GRAY
        self.sprites = arcade.SpriteList()

        # arrancar con algunos objetos mezclados
        for _ in range(4):

            self.spawn_bouncer(
                WIDTH // 2,
                HEIGHT // 2
            )

        for _ in range(3):

            self.spawn_wanderer(
                random.randint(100, WIDTH - 100),
                random.randint(100, HEIGHT - 100),
            )

    def spawn_bouncer(self, x, y):

        vx = random.uniform(-350, 350)
        vy = random.uniform(100, 500)

        self.sprites.append(
            Bouncer(x, y, vx, vy)
        )

    def spawn_wanderer(self, x, y):

        self.sprites.append(
            Wanderer(x, y)
        )

    def on_mouse_press(self, x, y, button, modifiers):

        # click izquierdo -> bouncer
        if button == arcade.MOUSE_BUTTON_LEFT:

            self.spawn_bouncer(x, y)

        # click derecho -> wanderer
        elif button == arcade.MOUSE_BUTTON_RIGHT:

            self.spawn_wanderer(x, y)

    def on_update(self, delta_time):

        # polimorfismo:
        # cada sprite ejecuta SU version de update()
        self.sprites.update(delta_time)

    def on_draw(self):
        self.clear()
        self.sprites.draw()
        arcade.draw_text(
            f"{len(self.sprites)} sprites",
            10,
            HEIGHT - 30,
            arcade.color.WHITE,
            18,
        )

        arcade.draw_text(
            "click izquierdo = Bouncer",
            10,
            HEIGHT - 60,
            arcade.color.YELLOW,
            16,
        )

        arcade.draw_text(
            "click derecho = Wanderer",
            10,
            HEIGHT - 90,
            arcade.color.SKY_BLUE,
            16,
        )


def main():

    window = arcade.Window(
        WIDTH,
        HEIGHT,
        TITLE
    )

    window.show_view(
        BouncerView()
    )

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
