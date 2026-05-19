import arcade

WIDTH = 1280
HEIGHT = 720
TITLE = "hola arcade"
MOVEMENT_SPEED = 8

class Player(arcade.Sprite):
    def __init__(self, scale = 1, center_x = 0, center_y = 0):
        super().__init__("4._sprites/img/mario.png", scale, center_x, center_y)
        self.score = 0

    def update(self, delta_time: float = 1/60):
        # MRU
        self.center_x += self.change_x
        self.center_y += self.change_y

        # x_k+1 = x_k + dx
        # self.center_x = self.center_x + self.change_x

    
    def check_coins(self, coins: arcade.SpriteList):
        for coin in coins:
            if (
                abs(self.center_x - coin.center_x) < 20 and 
                abs(self.center_y - coin.center_y) < 20
            ):
                coins.remove(coin)
                self.score += 10

    def shoot(self, bullets: arcade.SpriteList):
        bullets.append(Bullet(center_x=self.center_x, center_y=self.center_y))
class Bullet(arcade.SpriteSolidColor):
    def __init__(self, speed = 10, center_x = 0, center_y = 0):
        super().__init__(15, 15, center_x, center_y, arcade.color.RED)
        self.change_x = speed

    def update(self, delta_time):
        self.center_x += self.change_x
        self.center_y += self.change_y
        if self.center_x > WIDTH or self.center_x < 0:
            self.remove_from_sprite_lists() # auto eliminacion
        
class Coin(arcade.Sprite):
    def __init__(self, scale = 1, center_x = 0, center_y = 0):
        super().__init__("4._sprites/img/coin.png", scale, center_x, center_y)


class KeyboardMovementView(arcade.View):
    def __init__(self):
        super().__init__()
        self.background_color = arcade.color.BLACK
        self.sprite_list = arcade.SpriteList()
        self.coins = arcade.SpriteList()
        self.bullets = arcade.SpriteList()
        self.player = Player(
            center_x=WIDTH // 2,
            center_y=HEIGHT // 2,
            scale=0.4
            )
        self.sprite_list.append(self.player)
        self.spawn_coins()

    def spawn_coins(self):
        for x_pos in range(50, WIDTH, 150):
            coin = Coin(center_x=x_pos, center_y=500, scale=0.15)
            # self.sprite_list.append(coin)
            self.coins.append(coin)

    def on_update(self, delta_time):
        self.sprite_list.update(delta_time)
        self.bullets.update(delta_time)
        self.player.check_coins(self.coins)
        print(len(self.bullets))

    def on_draw(self):
        self.clear()
        self.sprite_list.draw()
        self.coins.draw()
        self.bullets.draw()
        arcade.draw_text(
            f"Score: {self.player.score}", 
            20, 
            HEIGHT - 40, 
            arcade.color.AERO_BLUE, 
            font_size=25)
    
    def on_key_press(self, symbol, modifiers):
        if symbol == arcade.key.UP:
            self.player.change_y = MOVEMENT_SPEED
        elif symbol == arcade.key.DOWN:
            self.player.change_y = -MOVEMENT_SPEED
        elif symbol == arcade.key.RIGHT:
            self.player.change_x = MOVEMENT_SPEED
        elif symbol == arcade.key.LEFT:
            self.player.change_x = -MOVEMENT_SPEED
        elif symbol == arcade.key.SPACE:
            self.player.shoot(self.bullets)

    def on_key_release(self, symbol, modifiers):
        if symbol in [arcade.key.UP, arcade.key.DOWN]:
            self.player.change_y = 0
        elif symbol in [arcade.key.LEFT, arcade.key.RIGHT]:
            self.player.change_x = 0
                        

def main():
    window = arcade.Window(WIDTH, HEIGHT, TITLE)
    game = KeyboardMovementView()
    window.show_view(game)
    arcade.run()


if __name__ == "__main__":
    main()