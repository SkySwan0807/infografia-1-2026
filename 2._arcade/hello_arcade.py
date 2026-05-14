# minima ventana de arcade.
# patron base: una clase View + arcade.Window + arcade.run().

import arcade

WIDTH = 1280
HEIGHT = 720
TITLE = "hola arcade"


class HelloView(arcade.View):
    def __init__(self):
        super().__init__()
        self.background_color = arcade.color.AMAZON

    def on_draw(self):
        self.clear()


def main():
    window = arcade.Window(WIDTH, HEIGHT, TITLE)
    game = HelloView()
    window.show_view(game)
    arcade.run()


if __name__ == "__main__":
    main()
