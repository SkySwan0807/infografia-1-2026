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
SPAWN_INTERVAL = 0.25  # segundos entre spawns


class FallingCoin(arcade.Sprite):
    def __init__(self, x):
        super().__init__(
            "4._sprites/img/coin.png", scale=0.2,
            center_x=x, center_y=HEIGHT + 30,
        )
        self.change_y = -random.uniform(150, 350)  # px/seg, hacia abajo

    def update(self, delta_time):
        self.center_y += self.change_y * delta_time
        if self.top < 0:
            # auto-eliminacion: la SpriteList que me contiene me deja ir.
            self.remove_from_sprite_lists()


class SpawnView(arcade.View):
    def __init__(self):
        super().__init__()
        self.background_color = arcade.color.MIDNIGHT_BLUE
        self.coins = arcade.SpriteList()
        self.spawn_timer = 0.0
        self.total_spawned = 0

    def on_update(self, delta_time):
        # acumulador de tiempo: cada SPAWN_INTERVAL, una moneda nueva.
        self.spawn_timer += delta_time
        if self.spawn_timer >= SPAWN_INTERVAL:
            self.spawn_timer = 0.0
            self.coins.append(FallingCoin(x=random.randint(20, WIDTH - 20)))
            self.total_spawned += 1

        # SpriteList.update propaga el delta_time a cada sprite.update()
        self.coins.update(delta_time)

    def on_draw(self):
        self.clear()
        self.coins.draw()
        arcade.draw_text(
            f"vivas: {len(self.coins)}   total spawneadas: {self.total_spawned}",
            10, HEIGHT - 30, arcade.color.WHITE, 16,
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
