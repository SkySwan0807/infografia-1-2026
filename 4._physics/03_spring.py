# ejemplo 3: joints (constraints) entre bodies.
# concepto nuevo: ademas de gravedad y colisiones, pymunk permite atar
# bodies con "joints" que les imponen relaciones. el DampedSpring simula
# un resorte real con tres parametros:
#
#   rest_length -> largo en reposo del resorte
#   stiffness   -> que tan fuerte tira hacia el rest_length
#   damping     -> friccion del resorte (cuanto disipa el rebote)
#
# escena: un anclaje fijo en lo alto + una pelota dinamica abajo, unidos
# por un resorte amortiguado. la pelota oscila y se va frenando hasta
# quedar colgada del anclaje en equilibrio con la gravedad.

import arcade
import pymunk

WIDTH = 800
HEIGHT = 600
TITLE = "03 - resorte amortiguado"

# parametros de la fisica
MASS = 10.0
DAMPING = 0.2         # 0 = sin friccion (oscila eterno); mas alto = se frena rapido
STIFFNESS = 70.0     # rigidez del resorte
REST_LENGTH = 200
ANCHOR_POINT = (400, 500)
INITIAL_POSITION = (500, 400)


class SpringView(arcade.View):
    def __init__(self):
        super().__init__()
        self.background_color = arcade.color.BLACK
        self.space = pymunk.Space()
        self.space.gravity = (0, -90)  # gravedad en px/seg^2 (~9.81 m/s^2 si 1m = 100px)

        # pelota: body dinamico + shape circular
        ball_body = pymunk.Body(MASS, pymunk.moment_for_circle(MASS, 0, 20))
        ball_body.position = INITIAL_POSITION
        ball_shape = pymunk.Circle(ball_body, 20)
        ball_shape.elasticity = 0.5
        self.space.add(ball_body, ball_shape)

        # anclaje: body STATIC en una posicion fija del mundo
        anchor_body = pymunk.Body(body_type=pymunk.Body.STATIC)
        anchor_body.position = ANCHOR_POINT

        # el joint: resorte amortiguado entre anchor y pelota.
        # los (0, 0) son los puntos de enganche EN COORDENADAS LOCALES de
        # cada body (centro del body).
        self.spring = pymunk.DampedSpring(
            anchor_body, ball_body,
            (0, 0), (0, 0),
            rest_length=REST_LENGTH,
            stiffness=STIFFNESS,
            damping=DAMPING,
        )
        self.space.add(self.spring)

        # sprites: solo para dibujar. la fisica vive en pymunk.
        self.anchor_sprite = arcade.SpriteCircle(10, color=arcade.color.RED)
        self.anchor_sprite.position = ANCHOR_POINT
        self.ball_sprite = arcade.SpriteCircle(20, color=arcade.color.BLUE)

        self.sprites = arcade.SpriteList()
        self.sprites.append(self.anchor_sprite)
        self.sprites.append(self.ball_sprite)

    def on_update(self, delta_time):
        self.space.step(1 / 60)
        # sincronizar sprite con body de la pelota.
        # self.spring.b es el segundo body que le pasamos al joint (la pelota).
        self.ball_sprite.position = self.spring.b.position

    def on_draw(self):
        self.clear()
        self.sprites.draw()
        # dibujar el resorte como una linea entre anclaje y pelota.
        # (pymunk no dibuja: nosotros decidimos como representarlo.)
        arcade.draw_line(
            self.anchor_sprite.center_x, self.anchor_sprite.center_y,
            self.ball_sprite.center_x, self.ball_sprite.center_y,
            arcade.color.YELLOW, 2,
        )


def main():
    window = arcade.Window(WIDTH, HEIGHT, TITLE)
    window.show_view(SpringView())
    arcade.run()


if __name__ == "__main__":
    main()
