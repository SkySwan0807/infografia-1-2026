# ejemplo 5: agarrar bodies con el mouse.
# concepto nuevo: hacer que la fisica sea INTERACTIVA con dos cosas:
#
#   - body KINEMATIC: tercer tipo de body (los otros eran DYNAMIC y STATIC).
#     no le afecta la gravedad ni las colisiones; lo movemos a mano.
#     perfecto para representar el cursor: sigue al mouse libremente.
#
#   - joints DINAMICOS: hasta ahora los joints se creaban en __init__ y
#     quedaban para siempre. aqui creamos un PivotJoint al hacer click
#     y lo destruimos al soltar -> agarrar / soltar bodies en vivo.

import arcade
import pymunk

WIDTH = 1000
HEIGHT = 700
TITLE = "05 - agarrar con el mouse"


class MouseDragView(arcade.View):
    def __init__(self):
        super().__init__()
        self.background_color = arcade.color.DARK_SLATE_GRAY
        self.space = pymunk.Space()
        self.space.gravity = (0, -900)

        # paredes estaticas: una "caja" cerrada donde flotan los bodies.
        self.walls: list[tuple[tuple[int, int], tuple[int, int]]] = []
        for a, b in (
            ((20, 20), (WIDTH - 20, 20)),                       # piso
            ((20, HEIGHT - 20), (WIDTH - 20, HEIGHT - 20)),     # techo
            ((20, 20), (20, HEIGHT - 20)),                      # izquierda
            ((WIDTH - 20, 20), (WIDTH - 20, HEIGHT - 20)),      # derecha
        ):
            self.add_wall(a, b)

        # bodies dinamicos: una mezcla de cajas y pelotas
        self.dyn: list[tuple[pymunk.Body, arcade.Sprite]] = []
        self.add_box(300, 400)
        self.add_box(500, 500)
        self.add_ball(700, 400)
        self.add_ball(400, 250)

        # cursor: body KINEMATIC. pymunk no le aplica gravedad ni le deja
        # responder a colisiones, pero acepta que le seteemos la posicion
        # a mano. perfecto para "ser" el mouse dentro del mundo fisico.
        self.cursor_body = pymunk.Body(body_type=pymunk.Body.KINEMATIC)
        self.cursor_body.position = (WIDTH // 2, HEIGHT // 2)
        # hay que agregarlo al space, si no el PivotJoint del click no puede
        # vincularlo con el body agarrado (pymunk exige que ambos esten dentro).
        self.space.add(self.cursor_body)

        # joint vigente mientras se mantiene el click. None si no agarramos nada.
        self.grab_joint: pymunk.PivotJoint | None = None

    def add_wall(self, a, b):
        body = pymunk.Body(body_type=pymunk.Body.STATIC)
        shape = pymunk.Segment(body, a, b, 2)
        shape.friction = 0.5
        shape.elasticity = 0.5
        self.space.add(body, shape)
        self.walls.append((a, b))

    def add_box(self, x, y, size=40):
        body = pymunk.Body(mass=1, moment=pymunk.moment_for_box(1, (size, size)))
        body.position = (x, y)
        shape = pymunk.Poly.create_box(body, (size, size))
        shape.elasticity = 0.4
        shape.friction = 0.6
        self.space.add(body, shape)
        sprite = arcade.SpriteSolidColor(size, size, color=arcade.color.CYAN)
        self.dyn.append((body, sprite))

    def add_ball(self, x, y, r=22):
        body = pymunk.Body(mass=1, moment=pymunk.moment_for_circle(1, 0, r))
        body.position = (x, y)
        shape = pymunk.Circle(body, r)
        shape.elasticity = 0.7
        shape.friction = 0.5
        self.space.add(body, shape)
        sprite = arcade.SpriteCircle(r, color=arcade.color.YELLOW)
        self.dyn.append((body, sprite))

    def on_mouse_motion(self, x, y, dx, dy):
        # mover el cursor body. al ser KINEMATIC, pymunk lo deja moverse
        # sin aplicar gravedad ni resolver colisiones.
        self.cursor_body.position = (x, y)

    def on_mouse_press(self, x, y, button, modifiers):
        if button != arcade.MOUSE_BUTTON_LEFT:
            return
        # buscar la shape mas cercana al punto del click (distancia 0 = sobre).
        hit = self.space.point_query_nearest((x, y), 0, pymunk.ShapeFilter())
        if hit is None or hit.shape.body.body_type != pymunk.Body.DYNAMIC:
            return
        # crear PivotJoint entre cursor y body, anclado en el punto exacto
        # del click. con esto el body no "salta" al crear el joint.
        body = hit.shape.body
        local_anchor = body.world_to_local((x, y))
        self.grab_joint = pymunk.PivotJoint(
            self.cursor_body, body, (0, 0), local_anchor,
        )
        # max_force evita que se rompa la fisica al arrastrar muy rapido:
        # el joint puede tirar con esta fuerza maxima, no infinita.
        self.grab_joint.max_force = 50000
        self.space.add(self.grab_joint)

    def on_mouse_release(self, x, y, button, modifiers):
        if button != arcade.MOUSE_BUTTON_LEFT or self.grab_joint is None:
            return
        self.space.remove(self.grab_joint)
        self.grab_joint = None

    def on_update(self, delta_time):
        self.space.step(1 / 60)
        # sincronizar todos los sprites con sus bodies (el patron de siempre)
        for body, sprite in self.dyn:
            sprite.center_x = body.position.x
            sprite.center_y = body.position.y
            sprite.radians = body.angle

    def on_draw(self):
        self.clear()
        for _body, sprite in self.dyn:
            arcade.draw_sprite(sprite)
        for (x0, y0), (x1, y1) in self.walls:
            arcade.draw_line(x0, y0, x1, y1, arcade.color.WHITE, 2)
        # marca visual del cursor: un anillo rojo siguiendo el mouse
        cx, cy = self.cursor_body.position
        arcade.draw_circle_outline(cx, cy, 8, arcade.color.RED, 2)
        # si estamos agarrando algo, una linea desde el cursor al anchor
        if self.grab_joint is not None:
            world_anchor = self.grab_joint.b.local_to_world(self.grab_joint.anchor_b)
            arcade.draw_line(cx, cy, world_anchor.x, world_anchor.y,
                             arcade.color.LIGHT_GREEN, 2)
        arcade.draw_text(
            "click izquierdo + arrastrar para agarrar bodies",
            20, HEIGHT - 40, arcade.color.WHITE, 14,
        )


def main():
    window = arcade.Window(WIDTH, HEIGHT, TITLE)
    window.show_view(MouseDragView())
    arcade.run()


if __name__ == "__main__":
    main()
