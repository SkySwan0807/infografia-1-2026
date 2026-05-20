# ejemplo 1: SpriteList
# concepto nuevo: una SpriteList es un contenedor optimizado para muchos
# sprites. en vez de dibujar uno por uno (lento), arcade los manda al GPU
# en un solo batch con sprite_list.draw().
#
# aqui creamos N monedas en posiciones y escalas aleatorias, y las
# dibujamos todas con una sola llamada.

import arcade
import random

WIDTH = 1280
HEIGHT = 720
TITLE = "01 - SpriteList"
N_COINS = 10


class SpriteListView(arcade.View):
    def __init__(self):
        super().__init__()
        self.background_color = arcade.color.DARK_SLATE_BLUE
        self.coins = arcade.SpriteList()

        for _ in range(N_COINS):
            coin = arcade.Sprite(
                "3._sprites/img/coin.png",
                scale=random.uniform(0.1, 0.35),
                center_x=random.randint(40, WIDTH - 40),
                center_y=random.randint(40, HEIGHT - 40),
            )
            coin.change_x=random.uniform(-100, 100)  # velocidad horizontal
            coin.change_y=random.uniform(-100, 100)  # velocidad vertical
            self.coins.append(coin)

    def on_update(self, delta_time):
        for coin in self.coins:
            coin.angle += 45 * delta_time  # rotar 360 grados por segundo
            coin.center_x = (coin.center_x + coin.change_x * delta_time) % WIDTH  # wrap around horizontal
            coin.center_y = (coin.center_y + coin.change_y * delta_time) % HEIGHT  # wrap around vertical

    def on_draw(self):
        self.clear()
        self.coins.draw()  # una sola llamada para las N monedas
        arcade.draw_text(
            f"{len(self.coins)} sprites en una SpriteList",
            10, HEIGHT - 30, arcade.color.WHITE, 16,
        )


def main():
    window = arcade.Window(WIDTH, HEIGHT, TITLE)
    window.show_view(SpriteListView())
    arcade.run()


if __name__ == "__main__":
    main()


# extensiones:
# 1. que cada moneda rote sola: en on_update, recorrer self.coins y
#    hacer coin.angle += algo. DONE
# 2. que cada moneda tenga una velocidad aleatoria y se mueva. cuando
#    salga de pantalla por un borde, reaparecer del otro (wrap around).
# 3. presionar SPACE para regenerar todas las monedas en nuevas
#    posiciones (vaciar la SpriteList y volver a llenarla).
