# ejemplo 2: sprite que sigue al mouse
# concepto nuevo: combinar on_mouse_motion (evento) con on_update
# (game loop). el mouse solo dice "este es el nuevo objetivo"; el
# movimiento real lo hace on_update cada frame, suavemente.
#
# formula: posicion += (objetivo - posicion) * factor * dt
# mientras mas lejos esta el objetivo, mas rapido se mueve. al
# acercarse, frena solo. eso es interpolacion lineal hacia un punto.

import arcade

WIDTH = 1280
HEIGHT = 720
TITLE = "02 - sprite que sigue al mouse"
FOLLOW_SPEED = 5.0  # 1/segundos. mas alto = mas rapido.


class FollowView(arcade.View):
    def __init__(self):
        super().__init__()
        self.background_color = arcade.color.DARK_SLATE_GRAY
        self.player = arcade.Sprite(
            "4._sprites/img/mario.png", scale=0.3,
            center_x=WIDTH // 2, center_y=HEIGHT // 2,
        )
        self.target_x = self.player.center_x
        self.target_y = self.player.center_y

    def on_mouse_motion(self, x, y, dx, dy):
        # arcade llama esto cada vez que el mouse se mueve.
        # solo guardamos el objetivo; movernos lo hace on_update.
        self.target_x = x
        self.target_y = y

    def on_update(self, delta_time):
        self.player.center_x += (self.target_x - self.player.center_x) * FOLLOW_SPEED * delta_time
        self.player.center_y += (self.target_y - self.player.center_y) * FOLLOW_SPEED * delta_time

    def on_draw(self):
        self.clear()
        # dibujar el objetivo como una marca chica, para ver el "tirar de cuerda"
        arcade.draw_circle_outline(self.target_x, self.target_y, 10, arcade.color.YELLOW, 2)
        arcade.draw_sprite(self.player)


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
