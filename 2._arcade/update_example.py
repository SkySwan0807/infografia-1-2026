# minima ventana de arcade.
# patron base: una clase View + arcade.Window + arcade.run().

import arcade

WIDTH = 1280
HEIGHT = 720
TITLE = "hola arcade"


class UpdateView(arcade.View):
    def __init__(self):
        super().__init__()
        self.background_color = arcade.color.BLACK
        self.x_pos = 0

    def on_draw(self):
        self.clear()
        arcade.draw_circle_filled(self.x_pos, 360, 30, arcade.color.RED)

    def on_update(self, delta_time):
        self.x_pos += delta_time * 300
        if self.x_pos > WIDTH:
            self.x_pos = 0


def main():
    window = arcade.Window(WIDTH, HEIGHT, TITLE)
    game = UpdateView()
    window.show_view(game)
    arcade.run()


if __name__ == "__main__":
    main()
