# ejemplo 4: spawn y despawn dinamico
# concepto nuevo: la cantidad de sprites cambia mientras corre el juego.
#   - cada SPAWN_INTERVAL segundos aparece una moneda nueva arriba.
#   - cada moneda cae, y se elimina sola cuando sale por abajo.
#
# patron clave: el sprite decide cuando morir, llamando dentro de su
# propio update() a self.remove_from_sprite_lists(). asi la View no
# tiene que llevar la cuenta de "quien sigue vivo".

import arcade
import random

WIDTH = 1280
HEIGHT = 720
TITLE = "04 - spawn / despawn"

INITIAL_SPAWN_INTERVAL = 0.25
MIN_SPAWN_INTERVAL = 0.05

DIFFICULTY_INTERVAL = 5.0


class FallingCoin(arcade.Sprite):
    def __init__(self, x):
        super().__init__(
            r"Git de clase\infografia-1-2026\3._sprites\img\coin.png",
            scale=0.2,
            center_x=x,
            center_y=HEIGHT + 30,
        )

        # velocidad vertical
        self.change_y = -random.uniform(150, 350)

        self.change_x = random.uniform(-80, 80)

    def update(self, delta_time):
        self.center_x += self.change_x * delta_time
        self.center_y += self.change_y * delta_time

        if (
            self.top < 0
            or self.right < 0
            or self.left > WIDTH
        ):
            self.remove_from_sprite_lists()


class SpawnView(arcade.View):
    def __init__(self):
        super().__init__()
        self.background_color = arcade.color.MIDNIGHT_BLUE
        self.coins = arcade.SpriteList()
        self.spawn_timer = 0.0
        self.difficulty_timer = 0.0
        self.spawn_interval = INITIAL_SPAWN_INTERVAL
        self.total_spawned = 0
        self.total_destroyed = 0

    def on_mouse_press(self, x, y, button, modifiers):
        if button == arcade.MOUSE_BUTTON_LEFT:
            hits = arcade.get_sprites_at_point(
                (x, y),
                self.coins
            )

            for sprite in hits:
                sprite.remove_from_sprite_lists()
                self.total_destroyed += 1

    def on_update(self, delta_time):
        # acumulador de tiempo: cada SPAWN_INTERVAL, una moneda nueva.
        self.spawn_timer += delta_time
        if self.spawn_timer >= self.spawn_interval:
            self.spawn_timer = 0.0
            self.coins.append(
                FallingCoin(
                    x=random.randint(20, WIDTH - 20)
                )
            )

            self.total_spawned += 1

        self.difficulty_timer += delta_time

        if self.difficulty_timer >= DIFFICULTY_INTERVAL:

            self.difficulty_timer = 0.0

            # reducir intervalo gradualmente
            self.spawn_interval -= 0.02

            # piso minimo
            self.spawn_interval = max(
                MIN_SPAWN_INTERVAL,
                self.spawn_interval
            )

        self.coins.update(delta_time)

    def on_draw(self):
        self.clear()
        self.coins.draw()

        arcade.draw_text(
            f"vivas: {len(self.coins)}",
            10,
            HEIGHT - 30,
            arcade.color.WHITE,
            18,
        )

        arcade.draw_text(
            f"spawneadas: {self.total_spawned}",
            10,
            HEIGHT - 60,
            arcade.color.WHITE,
            18,
        )

        arcade.draw_text(
            f"destruidas: {self.total_destroyed}",
            10,
            HEIGHT - 90,
            arcade.color.WHITE,
            18,
        )

        arcade.draw_text(
            f"spawn interval: {self.spawn_interval:.2f}",
            10,
            HEIGHT - 120,
            arcade.color.YELLOW,
            18,
        )


def main():
    window = arcade.Window(WIDTH, HEIGHT, TITLE)
    window.show_view(SpawnView())
    arcade.run()


if __name__ == "__main__":
    main()


# extensiones:
# 1. click izquierdo para "explotar" una moneda: si el click cae sobre
#    una moneda, eliminarla. pista:
#       hits = arcade.get_sprites_at_point((x, y), self.coins)
#       for s in hits: s.remove_from_sprite_lists()
# 2. dificultad creciente: cada 5 segundos, reducir SPAWN_INTERVAL un
#    poco (con un piso minimo, p.ej. 0.05).
# 3. viento: al crear cada moneda, darle un change_x aleatorio entre
#    -80 y 80. agregar en su update la componente horizontal.
