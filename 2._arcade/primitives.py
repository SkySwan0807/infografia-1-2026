import arcade

WIDTH = 1000
HEIGHT = 500
TITLE = "primitivas con Arcade"

class PrimitivesView(arcade.View):
    def __init__(self):
        super().__init__()
        self.background_color = arcade.color.ALABAMA_CRIMSON

    def on_draw(self):
        self.clear()
        arcade.draw_point(500, 250, arcade.color.BLACK, 10)
        arcade.draw_line(500, 250, 700, 400, arcade.color.CYAN, 4)
    
    def on_key_press(self, symbol, modifiers):
        print(f"tecla presionada: {symbol} modificadores: {modifiers}")
    
    def on_mouse_press(self, x, y, button, modifiers):
        print(f"({x}, {y}) botón: {button}")

def main():
    window = arcade.Window(WIDTH, HEIGHT, TITLE)
    game = PrimitivesView()
    window.show_view(game)
    arcade.run()


if __name__ == "__main__":
    main()
