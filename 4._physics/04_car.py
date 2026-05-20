# ejemplo 4: objeto compuesto (auto con motor).
# concepto nuevo: un "objeto" de juego puede ser varios bodies pegados
# entre si por joints. aqui el auto son TRES bodies (chasis + 2 ruedas)
# unidos por:
#
#   PinJoint    -> mantiene fijo el centro de cada rueda respecto al chasis
#                  (sin fijar la orientacion, asi pueden girar).
#   SimpleMotor -> aplica una velocidad angular sostenida entre dos bodies.
#                  cada rueda tiene su motor: por eso el auto avanza.
#
# tambien aparece el mundo estatico: piso + pared derecha como Segments.
# las lineas estaticas se dibujan a mano en on_draw porque no tienen sprite.

import arcade
import pymunk

WIDTH = 800
HEIGHT = 800
TITLE = "04 - auto con motor"

# geometria del auto
CHASSIS_W = 100
CHASSIS_H = 70
WHEEL_R = 20
WHEEL_DX = 50      # cuanto separadas las ruedas del centro del chasis
WHEEL_DY = -35     # cuanto debajo del centro del chasis
MOTOR_RATE = 10    # velocidad angular de las ruedas (rad/s aprox)


class Car:
    def __init__(self, x, y, space):
        # --- chasis: caja dinamica ---
        mass = 5
        moment = pymunk.moment_for_box(mass, (CHASSIS_W, CHASSIS_H))
        chassis_body = pymunk.Body(mass, moment)
        chassis_body.position = (x, y)
        chassis_shape = pymunk.Poly.create_box(chassis_body, (CHASSIS_W, CHASSIS_H))
        chassis_shape.elasticity = 0.3
        chassis_shape.friction = 0.5

        # --- rueda delantera ---
        f_wheel_body = pymunk.Body()
        f_wheel_body.position = (x + WHEEL_DX, y + WHEEL_DY)
        f_wheel_shape = pymunk.Circle(f_wheel_body, WHEEL_R)
        f_wheel_shape.density = 0.01   # liviana respecto al chasis
        f_wheel_shape.friction = 0.5   # friccion con el piso = traccion
        f_wheel_shape.elasticity = 1

        # --- rueda trasera ---
        r_wheel_body = pymunk.Body()
        r_wheel_body.position = (x - WHEEL_DX, y + WHEEL_DY)
        r_wheel_shape = pymunk.Circle(r_wheel_body, WHEEL_R)
        r_wheel_shape.density = 0.01
        r_wheel_shape.friction = 0.5
        r_wheel_shape.elasticity = 1

        # --- joints: pin (sujeta) + motor (mueve) por rueda ---
        # PinJoint(a, b, anchor_a_en_mundo, anchor_b_local).
        # collide_bodies=False evita que el chasis colisione con la rueda
        # con la que esta unido (porque se tocan en el punto del pin).
        f_joint = pymunk.PinJoint(
            chassis_body, f_wheel_body,
            (x + WHEEL_DX, y + WHEEL_DY), (0, 0),
        )
        f_joint.collide_bodies = False
        f_motor = pymunk.SimpleMotor(chassis_body, f_wheel_body, MOTOR_RATE)

        r_joint = pymunk.PinJoint(
            chassis_body, r_wheel_body,
            (x - WHEEL_DX, y + WHEEL_DY), (0, 0),
        )
        r_joint.collide_bodies = False
        r_motor = pymunk.SimpleMotor(chassis_body, r_wheel_body, MOTOR_RATE)

        # registrar todo en el espacio
        space.add(chassis_body, chassis_shape)
        space.add(f_wheel_body, f_wheel_shape)
        space.add(r_wheel_body, r_wheel_shape)
        space.add(f_joint, f_motor)
        space.add(r_joint, r_motor)

        # sprites para dibujar
        self.chassis_sprite = arcade.SpriteSolidColor(CHASSIS_W, CHASSIS_H, color=arcade.color.RED)
        self.f_wheel_sprite = arcade.SpriteCircle(WHEEL_R, color=arcade.color.GREEN)
        self.r_wheel_sprite = arcade.SpriteCircle(WHEEL_R, color=arcade.color.GREEN)
        self.sprites = arcade.SpriteList()
        self.sprites.append(self.chassis_sprite)
        self.sprites.append(self.f_wheel_sprite)
        self.sprites.append(self.r_wheel_sprite)

        # guardar referencias a los bodies para poder sincronizar
        self.chassis_shape = chassis_shape
        self.f_wheel = f_wheel_shape
        self.r_wheel = r_wheel_shape

    def update(self):
        # mismo patron de siempre: copiar pose del body al sprite.
        for sprite, shape in (
            (self.chassis_sprite, self.chassis_shape),
            (self.f_wheel_sprite, self.f_wheel),
            (self.r_wheel_sprite, self.r_wheel),
        ):
            sprite.center_x = shape.body.position.x
            sprite.center_y = shape.body.position.y
            sprite.radians = shape.body.angle


class CarView(arcade.View):
    def __init__(self):
        super().__init__()
        self.background_color = arcade.color.BLACK
        self.space = pymunk.Space()
        self.space.gravity = (0, -900)

        self.car = Car(200, 100, self.space)
        self.static_lines: list[tuple[float, float, float, float]] = []
        self.add_static_segment(0, 0, WIDTH, 0)            # piso
        self.add_static_segment(WIDTH, 0, WIDTH, HEIGHT)   # pared derecha

    def add_static_segment(self, x0, y0, x1, y1):
        segment_body = pymunk.Body(body_type=pymunk.Body.STATIC)
        segment_shape = pymunk.Segment(segment_body, (x0, y0), (x1, y1), 0)
        segment_shape.friction = 0.1
        self.space.add(segment_body, segment_shape)
        self.static_lines.append((x0, y0, x1, y1))

    def on_update(self, delta_time):
        self.space.step(1 / 60)
        self.car.update()

    def on_draw(self):
        self.clear()
        self.car.sprites.draw()
        for x0, y0, x1, y1 in self.static_lines:
            arcade.draw_line(x0, y0, x1, y1, arcade.color.WHITE, 2)


def main():
    window = arcade.Window(WIDTH, HEIGHT, TITLE)
    window.show_view(CarView())
    arcade.run()


if __name__ == "__main__":
    main()
