# ejemplo 6: callbacks de colision.
# concepto nuevo: hasta ahora la fisica era una caja negra que se mueve
# sola. con un collision handler, pymunk nos AVISA cuando dos shapes
# de tipos especificos chocan. ahi podemos meter logica de juego:
# sumar puntos, cambiar color, reproducir sonido, romper bodies, etc.
#
# el patron:
#   1. asignar shape.collision_type = <numero> a cada shape relevante.
#   2. space.add_collision_handler(type_a, type_b) -> handler.
#   3. handler.begin = funcion. pymunk la llama al iniciar el contacto.
#
# escena tipo "pachinko": una pelota cae rebotando entre clavos hasta
# llegar al "gol" abajo. cada gol incrementa el score y respawnea la
# pelota arriba en una posicion x aleatoria.

import arcade
import math
import pymunk
import random

WIDTH = 800
HEIGHT = 700
TITLE = "06 - callback de colision (pachinko)"

# tipos de colision: numeros arbitrarios que identifican shapes en los
# handlers. convencion: definirlos como constantes con nombre.
BALL_TYPE = 1
GOAL_TYPE = 2
PEG_TYPE = 3

class CollisionView(arcade.View):
    def __init__(self):
        super().__init__()
        self.background_color = arcade.color.DARK_BLUE_GRAY
        self.space = pymunk.Space()
        self.space.gravity = (0, -500)

        self.score = 0
        self.needs_respawn = False

        # paredes laterales (los Segments no rebotan tanto como las pelotas)
        self.walls: list[tuple[tuple[int, int], tuple[int, int]]] = []
        self.add_wall((0, 0), (0, HEIGHT))
        self.add_wall((WIDTH, 0), (WIDTH, HEIGHT))

        # campo de clavos: grilla de circulos estaticos. los guardamos
        # aparte para dibujarlos sin tener que iterar el space.
        self.pegs: list[tuple[float, float, float]] = []
        for row in range(5):
            for col in range(7):
                x = 80 + col * 100 + (row % 2) * 50
                y = HEIGHT - 150 - row * 80
                self.add_peg(x, y, 10)

        # zona de gol abajo: un Segment STATIC con collision_type = GOAL_TYPE.
        # sensor=True hace que detecte el contacto pero NO empuje a la pelota:
        # la pelota atraviesa, el callback dispara, respawneamos arriba.
        goal_body = pymunk.Body(body_type=pymunk.Body.STATIC)
        goal_shape = pymunk.Segment(goal_body, (350, 30), (450, 30), 8)
        goal_shape.collision_type = GOAL_TYPE
        goal_shape.sensor = True
        self.space.add(goal_body, goal_shape)

        # pelota inicial
        self.ball_body: pymunk.Body | None = None
        self.ball_shape: pymunk.Circle | None = None
        self.spawn_ball()

        # REGISTRAR EL HANDLER. cuando una shape de tipo BALL_TYPE entre
        # en contacto con una de tipo GOAL_TYPE, pymunk llama a self.on_goal.
        # el callback retorna True (procesar la colision) o False (ignorar).
        handler = self.space.add_collision_handler(BALL_TYPE, GOAL_TYPE)
        handler.begin = self.on_goal

        handler = self.space.add_collision_handler(BALL_TYPE, PEG_TYPE)
        handler.begin = self.on_peg

        self.canyon = arcade.SpriteSolidColor(
            20, 80, 
            center_x=WIDTH//2, 
            center_y=HEIGHT - 40,
            color=arcade.color.GREEN)

        self.sprites = arcade.SpriteList()
        self.sprites.append(self.canyon)

    def add_wall(self, a, b):
        body = pymunk.Body(body_type=pymunk.Body.STATIC)
        shape = pymunk.Segment(body, a, b, 2)
        shape.elasticity = 0.6
        self.space.add(body, shape)
        self.walls.append((a, b))

    def add_peg(self, x, y, r):
        body = pymunk.Body(body_type=pymunk.Body.STATIC)
        body.position = (x, y)
        shape = pymunk.Circle(body, r)
        shape.elasticity = 0.9
        shape.friction = 0.2
        shape.collision_type = PEG_TYPE
        self.space.add(body, shape)
        self.pegs.append((x, y, r))

    def spawn_ball(self, x = None, y = None, init_velocity = (0, 0)):
        # si habia una pelota anterior, sacarla del espacio
        if self.ball_body is not None:
            self.space.remove(self.ball_body, self.ball_shape)
        
        body = pymunk.Body(mass=1, moment=pymunk.moment_for_circle(1, 0, 12))
        if x is not None and y is not None:
            body.position = (x, y)
        else:
            body.position = (random.randint(80, WIDTH - 80), HEIGHT - 40)
        
        body.velocity = init_velocity

        shape = pymunk.Circle(body, 12)
        shape.elasticity = 0.7
        shape.friction = 0.3
        shape.collision_type = BALL_TYPE   # <- la marca que dispara el handler
        self.space.add(body, shape)
        self.ball_body = body
        self.ball_shape = shape

    def on_mouse_press(self, x, y, button, modifiers):
        # click para respawnear la pelota en la posicion del mouse.
        # self.spawn_ball(x, y)
        spawn_x = int(WIDTH//2 + 40 * math.cos(-self.canyon.radians - math.pi/2))
        spawn_y = int(HEIGHT - 40 + 40 * math.sin(-self.canyon.radians - math.pi/2))

        # calculo de la velocidad
        MAX_VEL = 400
        vel_x = int(MAX_VEL * math.cos(-self.canyon.radians - math.pi/2)) 
        vel_y = int(MAX_VEL * math.sin(-self.canyon.radians - math.pi/2))

        self.spawn_ball(
            spawn_x,
            spawn_y,
            (vel_x, vel_y)
        )

    def on_mouse_motion(self, x, y, dx, dy):
        # apuntar el canyon con el mouse.
        self.canyon.angle = arcade.math.get_angle_degrees(
            self.canyon.center_x, self.canyon.center_y, 
            x, y
            ) - 90

    def on_goal(self, arbiter, space, data):
        # se dispara una vez por contacto que EMPIEZA (no por frame).
        # arbiter.shapes son las dos shapes que se tocaron, en orden
        # (BALL, GOAL) porque asi registramos el handler.
        self.score += 30
        # NO podemos remover bodies aqui adentro: pymunk esta a la mitad
        # de iterar contactos. agendamos un flag y el respawn ocurre al
        # final del frame, en on_update.
        # self.needs_respawn = True
        return True  # True = aceptar la colision normalmente

    def on_peg(self, arbiter, space, data):
        print("tocamos un clavo!")
        self.score += 1
        return True

    def on_update(self, delta_time):
        self.space.step(1 / 60)
        if self.needs_respawn:
            self.spawn_ball()
            self.needs_respawn = False

    def on_draw(self):
        self.clear()
        # ca;on
        self.sprites.draw()
        # clavos
        for x, y, r in self.pegs:
            arcade.draw_circle_filled(x, y, r, arcade.color.LIGHT_GRAY)
        # paredes
        for (x0, y0), (x1, y1) in self.walls:
            arcade.draw_line(x0, y0, x1, y1, arcade.color.WHITE, 2)
        # linea del gol
        arcade.draw_line(350, 30, 450, 30, arcade.color.LIGHT_GREEN, 4)
        # pelota
        bx, by = self.ball_body.position
        arcade.draw_circle_filled(bx, by, 12, arcade.color.YELLOW)
        # ui
        arcade.draw_text(
            f"goles: {self.score}",
            20, HEIGHT - 40, arcade.color.WHITE, 22,
        )

        arcade.draw_text(
            f"angulo cañon: {self.canyon.angle:.1f}",
            20, HEIGHT - 120, arcade.color.WHITE, 22,
        )


def main():
    window = arcade.Window(WIDTH, HEIGHT, TITLE)
    window.show_view(CollisionView())
    arcade.run()


if __name__ == "__main__":
    main()
