import arcade

WIDTH = 1280
HEIGHT = 720
TITLE = "hola arcade"

class SpriteView(arcade.View):
    def __init__(self):
        super().__init__()
        self.background_color = arcade.color.BLACK
        self.sprite = arcade.Sprite("4._sprites/img/mario.png", scale=0.5)
        self.sprite.center_x = WIDTH // 2
        self.sprite.center_y = HEIGHT // 2

    def on_draw(self):
        self.clear()
        arcade.draw_sprite(self.sprite)
    
    def on_key_press(self, symbol, modifiers):
        if symbol == arcade.key.NUM_1:
            self.sprite.scale = 1
        elif symbol == arcade.key.NUM_2:
            self.sprite.scale = 2
        elif symbol == arcade.key.RIGHT:
            self.sprite.center_x += 10
        elif symbol == arcade.key.LEFT:
            self.sprite.center_x -= 10
        elif symbol == arcade.key.R:
            self.sprite.angle += 5
        
            

def main():
    window = arcade.Window(WIDTH, HEIGHT, TITLE)
    game = SpriteView()
    window.show_view(game)
    arcade.run()


if __name__ == "__main__":
    main()