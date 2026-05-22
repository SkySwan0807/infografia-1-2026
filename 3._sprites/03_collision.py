# ejemplo 3: deteccion de colision
# concepto nuevo: arcade.check_for_collision_with_list(sprite, lista)
# devuelve la lista de sprites de `lista` que estan tocando a `sprite`.
# usa el bounding box real (ancho x alto) en vez de comparar distancias
# a mano. mucho mas correcto que el "abs(dx) < 20" del ejemplo viejo.
#
# el jugador se mueve con las flechas y recoge monedas al tocarlas.

import arcade
import random

WIDTH = 1280
HEIGHT = 720
TITLE = "03 - colisiones"
SPEED = 6
N_COINS = 10
N_ENEMIES = 5


class CollisionView(arcade.View):
    def __init__(self):
        super().__init__()
        self.background_color = arcade.color.DARK_OLIVE_GREEN
        self.player = arcade.Sprite(
            r"Git de clase\infografia-1-2026\3._sprites\img\mario.png",
            scale=0.4,
            center_x=WIDTH // 2,
            center_y=HEIGHT // 2,
        )

        # ============================================
        # LISTAS DE SPRITES
        # ============================================

        self.coins = arcade.SpriteList()
        self.enemies = arcade.SpriteList()

        # ============================================
        # ESTADO DEL JUEGO
        # ============================================

        self.score = 0
        self.rounds = 1

        self.spawn_coins()
        self.spawn_enemies()

    # =========================================================
    # CREAR MONEDAS
    # =========================================================

    def spawn_coins(self):

        self.coins.clear()

        for _ in range(N_COINS):

            # monedas grandes o chicas
            is_big = random.choice([True, False])

            scale = 0.35 if is_big else 0.2
            points = 3 if is_big else 1

            coin = arcade.Sprite(
                r"Git de clase\infografia-1-2026\3._sprites\img\coin.png",
                scale=scale,
                center_x=random.randint(40, WIDTH - 40),
                center_y=random.randint(40, HEIGHT - 40),
            )

            # atributo personalizado
            coin.points = points
            self.coins.append(coin)

    def spawn_enemies(self):
        self.enemies.clear()

        for _ in range(N_ENEMIES):

            enemy = arcade.SpriteSolidColor(
                width=50,
                height=50,
                color=arcade.color.RED
            )

            enemy.center_x = random.randint(50, WIDTH - 50)
            enemy.center_y = random.randint(50, HEIGHT - 50)

            self.enemies.append(enemy)

    def on_key_press(self, symbol, modifiers):
        if symbol == arcade.key.UP:
            self.player.change_y = SPEED
        elif symbol == arcade.key.DOWN:
            self.player.change_y = -SPEED
        elif symbol == arcade.key.RIGHT:
            self.player.change_x = SPEED
        elif symbol == arcade.key.LEFT:
            self.player.change_x = -SPEED

    def on_key_release(self, symbol, modifiers):
        if symbol in (arcade.key.UP, arcade.key.DOWN):
            self.player.change_y = 0
        elif symbol in (arcade.key.LEFT, arcade.key.RIGHT):
            self.player.change_x = 0

    def on_update(self, delta_time):
        # mover jugador
        self.player.center_x += self.player.change_x
        self.player.center_y += self.player.change_y

        touched_coins = arcade.check_for_collision_with_list(
            self.player,
            self.coins
        )

        for coin in touched_coins:

            self.score += coin.points
            coin.remove_from_sprite_lists()

        if len(self.coins) == 0:
            self.rounds += 1
            self.spawn_coins()

        touched_enemies = arcade.check_for_collision_with_list(
            self.player,
            self.enemies
        )

        for enemy in touched_enemies:
            self.score -= 1

    def on_draw(self):
        self.clear()
        self.coins.draw()
        self.enemies.draw()

        arcade.draw_sprite(self.player)
        arcade.draw_text(
            f"score: {self.score}",
            10,
            HEIGHT - 30,
            arcade.color.WHITE,
            20,
        )

        arcade.draw_text(
            f"round: {self.rounds}",
            10,
            HEIGHT - 60,
            arcade.color.YELLOW,
            20,
        )

        arcade.draw_text(
            "moneda chica = 1 punto | grande = 3 puntos",
            10,
            HEIGHT - 90,
            arcade.color.LIGHT_GRAY,
            16,
        )


def main():
    window = arcade.Window(WIDTH, HEIGHT, TITLE)
    window.show_view(CollisionView())
    arcade.run()


if __name__ == "__main__":
    main()


# extensiones:
# 1. cuando se recogen todas las monedas, hacer respawn. agregar un
#    contador de "rondas" que aumenta cada vez que se vuelve a llenar.
# 2. monedas grandes (escala > 0.3) valen 3 puntos, chicas 1. pista:
#    guardar coin.points = ... al crearlas y leerlo en el bucle.
# 3. agregar "enemigos" (arcade.SpriteSolidColor rojos) en otra
#    SpriteList. si el jugador los toca, restan puntos. usa una segunda
#    llamada a check_for_collision_with_list.
