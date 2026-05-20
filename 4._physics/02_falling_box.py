# ejemplo 2: pymunk + arcade.
# concepto nuevo: pymunk simula la fisica; arcade dibuja. el puente entre
# ambos es copiar, cada frame, la posicion y angulo del Body de pymunk a
# las propiedades center_x / center_y / radians del Sprite de arcade.
#
#   pymunk          ->   arcade
#   body.position.x ->   sprite.center_x
#   body.position.y ->   sprite.center_y
#   body.angle      ->   sprite.radians
#
# escena: una caja dinamica con un angulo inicial cae por gravedad y
# rebota sobre un piso estatico (Segment).

import arcade
import pymunk

WIDTH = 800
HEIGHT = 800
TITLE = "02 - caja cayendo (pymunk + arcade)"


class FallingBoxView(arcade.View):
    def __init__(self):
        super().__init__()
        self.background_color = arcade.color.BLACK

        # espacio fisico con gravedad en pixeles/seg^2.
        # OJO: ahora la unidad importa: estamos en pixeles, asi que la
        # gravedad tambien debe ser grande (cf. 01_hello_pymunk donde
        # usabamos -9 porque las unidades eran arbitrarias).
        self.space = pymunk.Space()
        self.space.gravity = (0, -90)

        # body dinamico: necesita masa Y momento de inercia (para rotacion)
        body = pymunk.Body(mass=5, moment=pymunk.moment_for_box(1, (30, 30)))
        body.position = (WIDTH // 2, HEIGHT // 2)
        body.angle = 0.2  # angulo inicial: asi rota al caer en vez de caer plana

        # shape: la caja real (para colisiones). elasticity = rebote.
        self.shape = pymunk.Poly.create_box(body, (30, 30))
        self.shape.elasticity = 0.9
        self.shape.friction = 0.1

        # piso: un body STATIC nunca se mueve (no le afecta la gravedad).
        # el Segment va de (0, 20) a (WIDTH, 20): una linea horizontal.
        floor_body = pymunk.Body(body_type=pymunk.Body.STATIC)
        floor_shape = pymunk.Segment(floor_body, (0, 20), (WIDTH, 20), 0)
        floor_shape.friction = 0.1
        floor_shape.elasticity = 0.7

        # registrar todo en el espacio
        self.space.add(body, self.shape)
        self.space.add(floor_body, floor_shape)

        # sprite visual asociado al body de la caja
        self.sprites = arcade.SpriteList()
        self.body_sprite = arcade.SpriteSolidColor(30, 30, color=arcade.color.CYAN)
        self.sprites.append(self.body_sprite)

    def on_update(self, delta_time):
        # avanzar la fisica con paso FIJO (1/60). usar delta_time variable
        # puede hacer que la simulacion oscile en framerates bajos.
        self.space.step(1 / 60)

        # sincronizar sprite con body: este es el patron clave del modulo.
        self.body_sprite.center_x = self.shape.body.position.x
        self.body_sprite.center_y = self.shape.body.position.y
        self.body_sprite.radians = self.shape.body.angle

    def on_draw(self):
        self.clear()
        self.sprites.draw()
        # dibujar el piso a mano (el Segment de pymunk no tiene sprite)
        arcade.draw_line(0, 20, WIDTH, 20, arcade.color.WHITE, 2)


def main():
    window = arcade.Window(WIDTH, HEIGHT, TITLE)
    window.show_view(FallingBoxView())
    arcade.run()


if __name__ == "__main__":
    main()
