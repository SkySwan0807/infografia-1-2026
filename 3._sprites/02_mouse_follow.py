# ejemplo 2: sprite que sigue al mouse
# concepto nuevo: combinar on_mouse_motion (evento) con on_update
# (game loop). el mouse solo dice "este es el nuevo objetivo"; el
# movimiento real lo hace on_update cada frame, suavemente.
#
# formula: posicion += (objetivo - posicion) * factor * dt
# mientras mas lejos esta el objetivo, mas rapido se mueve. al
# acercarse, frena solo. eso es interpolacion lineal hacia un punto.

import math
import arcade

WIDTH = 1280
HEIGHT = 720
TITLE = "02 - sprite que sigue al mouse"

# velocidad constante en pixeles/segundo
FOLLOW_SPEED = [150, 250, 350, 500]


class FollowView(arcade.View):
    def __init__(self):
        super().__init__()
        self.background_color = arcade.color.DARK_SLATE_GRAY

        self.players = arcade.SpriteList()

        # crear varios sprites
        for speed in FOLLOW_SPEED:
            player = arcade.Sprite(
                r"Git de clase\infografia-1-2026\3._sprites\img\mario.png",
                scale=0.25,
                center_x=WIDTH // 2,
                center_y=HEIGHT // 2,
            )

            # guardar velocidad individual
            player.speed = speed

            self.players.append(player)

        # objetivo inicial
        self.target_x = WIDTH // 2
        self.target_y = HEIGHT // 2

    def on_mouse_motion(self, x, y, dx, dy):

        # guardar posicion objetivo
        self.target_x = x
        self.target_y = y

    def on_update(self, delta_time):

        for player in self.players:

            dx = self.target_x - player.center_x
            dy = self.target_y - player.center_y

            # distancia al objetivo
            distance = math.sqrt(dx**2 + dy**2)

            # evitar division por cero
            if distance > 1:

                direction_x = dx / distance
                direction_y = dy / distance

                player.center_x += direction_x * player.speed * delta_time
                player.center_y += direction_y * player.speed * delta_time

                player.angle = math.degrees(math.atan2(dy, dx))

    def on_draw(self):
        self.clear()
        # dibujar objetivo
        arcade.draw_circle_outline(
            self.target_x,
            self.target_y,
            10,
            arcade.color.YELLOW,
            2
        )

        # dibujar sprites
        self.players.draw()


def main():
    window = arcade.Window(WIDTH, HEIGHT, TITLE)
    window.show_view(FollowView())
    arcade.run()


if __name__ == "__main__":
    main()


# extensiones:
# 1. agregar varios sprites siguiendo al mouse, cada uno con un
#    FOLLOW_SPEED distinto. se forma una estela detras del cursor.
# 2. rotar el sprite para que "mire" hacia el objetivo. pista:
#       import math
#       dx = self.target_x - self.player.center_x
#       dy = self.target_y - self.player.center_y
#       self.player.angle = math.degrees(math.atan2(dy, dx))
# 3. velocidad constante en vez de proporcional: calcular un vector
#    unitario hacia el objetivo y multiplicar por una velocidad fija.
#    el sprite ya no desacelera al acercarse, sino que va a tope hasta
#    llegar.
