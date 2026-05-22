# ejercicio 0: slingshot
# combinar los tres conceptos del modulo de fisica:
#   - body KINEMATIC + cambio a DYNAMIC en runtime (concepto nuevo)
#   - apply_impulse_at_local_point para "disparar" (concepto nuevo)
#   - collision_type + handler + remocion DIFERIDA (reuso de 06_)
#   - drag con mouse (reuso de 05_, simplificado)
#
# objetivo: un mini Angry Birds. arrastrar el proyectil amarillo hacia atras
# del anchor rojo y soltar para dispararlo. el proyectil tiene que tumbar
# las cajas cian y aumentar el score.
#
# lo que ya esta hecho:
#   - paredes, gravedad, sprites, dibujo, sync body<->sprite, respawn, SPACE.
#
# lo que tenes que completar (5 TODOs):
#   1. registrar el collision handler en __init__
#   2. completar _on_hit_target (callback + remocion diferida)
#   3. completar on_mouse_press (empezar a apuntar si click sobre el proyectil)
#   4. completar on_mouse_motion (clampear la posicion del proyectil durante aim)
#   5. completar on_mouse_release (LA mas importante: switch a DYNAMIC + impulso)
#
# correr:
#   cd 5._physics && uv run ex0_slingshot.py

import arcade
import pymunk
from pymunk import Vec2d

WIDTH = 1000
HEIGHT = 700
TITLE = "tarea 0 - slingshot"

ANCHOR = Vec2d(200, 300)
PROJECTILE_R = 18
TARGET_SIZE = 40
MAX_DRAG = 150        # cuanto se puede estirar el slingshot (px)
IMPULSE_SCALE = 6     # cuanto impulso por pixel de drag (tunear el "feel")
PROJECTILE_MASS = 1

PROJECTILE_TYPE = 1
TARGET_TYPE = 2


class SlingshotView(arcade.View):
    def __init__(self):
        super().__init__()
        self.background_color = arcade.color.DARK_SLATE_GRAY
        self.space = pymunk.Space()
        self.space.gravity = (0, -500)

        self.score = 0
        # remociones diferidas: nunca tocar el space dentro de un callback (ver 06_).
        self.pending_removals: list[tuple[pymunk.Body, pymunk.Shape]] = []

        # paredes estaticas (piso + tres lados)
        self.walls: list[tuple[tuple[int, int], tuple[int, int]]] = []
        self._add_wall((0, 40), (WIDTH, 40))
        self._add_wall((0, 40), (0, HEIGHT))
        self._add_wall((WIDTH, 40), (WIDTH, HEIGHT))
        self._add_wall((0, HEIGHT), (WIDTH, HEIGHT))

        # proyectil: body KINEMATIC parqueado en el anchor + sprite circular.
        self.projectile_body, self.projectile_shape = self._spawn_projectile()
        self.projectile_sprite = arcade.SpriteCircle(PROJECTILE_R, color=arcade.color.YELLOW)

        # targets: cinco cajas dinamicas en una pequeña pila a la derecha.
        # (body, shape, sprite) por cada uno. la gravedad las acomoda.
        self.targets: list[tuple[pymunk.Body, pymunk.Shape, arcade.Sprite]] = []
        self.target_sprites = arcade.SpriteList()
        base_x = 780
        for dx, dy in [
            (0, 0), (60, 0), (120, 0),
            (30, 60), (90, 60),
        ]:
            self._add_target(base_x + dx - 60, 60 + dy)

        # estado del aim: True mientras el usuario mantiene apretado el mouse.
        self.is_aiming = False

        # TODO 1: registrar el handler de colision proyectil <-> target.
        # pista (ver 06_collision_callback.py):
        #   handler = self.space.add_collision_handler(<tipo_a>, <tipo_b>)
        #   handler.begin = <funcion>
        # los tipos son PROJECTILE_TYPE y TARGET_TYPE. la funcion es self._on_hit_target.

    # --- helpers ya completos ---

    def _add_wall(self, a, b):
        body = pymunk.Body(body_type=pymunk.Body.STATIC)
        shape = pymunk.Segment(body, a, b, 2)
        shape.elasticity = 0.5
        shape.friction = 0.6
        self.space.add(body, shape)
        self.walls.append((a, b))

    def _spawn_projectile(self):
        body = pymunk.Body(body_type=pymunk.Body.KINEMATIC)
        body.position = ANCHOR
        shape = pymunk.Circle(body, PROJECTILE_R)
        shape.elasticity = 0.4
        shape.friction = 0.5
        shape.collision_type = PROJECTILE_TYPE
        self.space.add(body, shape)
        return body, shape

    def _add_target(self, x, y):
        body = pymunk.Body(
            mass=1,
            moment=pymunk.moment_for_box(1, (TARGET_SIZE, TARGET_SIZE)),
        )
        body.position = (x, y)
        shape = pymunk.Poly.create_box(body, (TARGET_SIZE, TARGET_SIZE))
        shape.elasticity = 0.3
        shape.friction = 0.7
        shape.collision_type = TARGET_TYPE
        self.space.add(body, shape)
        sprite = arcade.SpriteSolidColor(TARGET_SIZE, TARGET_SIZE, color=arcade.color.CYAN)
        self.target_sprites.append(sprite)
        self.targets.append((body, shape, sprite))

    def _click_is_on_projectile(self, x, y) -> bool:
        px, py = self.projectile_body.position
        return (x - px) ** 2 + (y - py) ** 2 <= PROJECTILE_R ** 2

    def _respawn_projectile(self):
        self.space.remove(self.projectile_body, self.projectile_shape)
        self.projectile_body, self.projectile_shape = self._spawn_projectile()
        self.is_aiming = False

    # --- TODOs ---

    def _on_hit_target(self, arbiter, space, data):
        # TODO 2: callback de colision proyectil <-> target.
        #
        # arbiter.shapes te da las dos shapes que se tocaron, en el orden que
        # registraste el handler (proyectil primero, target segundo). de la
        # shape del target sacas el body con shape.body.
        #
        # CRITICO: no podemos llamar a space.remove() desde aqui (pymunk esta
        # iterando contactos). agendar en self.pending_removals y procesar al
        # final del frame en on_update. ver 06_collision_callback.py para el
        # patron exacto.
        #
        # ademas: incrementar self.score y devolver True para aceptar la colision.
        raise NotImplementedError("completar _on_hit_target")

    def on_mouse_press(self, x, y, button, modifiers):
        # TODO 3: empezar a apuntar si el usuario hizo click sobre el proyectil.
        #
        # condiciones (todas tienen que cumplirse para empezar a apuntar):
        #   - el boton sea arcade.MOUSE_BUTTON_LEFT
        #   - el proyectil este parqueado (body_type == pymunk.Body.KINEMATIC).
        #     ya que en runtime puede ser DYNAMIC (volando), entonces ignorar.
        #   - el click cae sobre el proyectil. usar self._click_is_on_projectile(x, y).
        #
        # si todo se cumple: poner self.is_aiming = True.
        raise NotImplementedError("completar on_mouse_press")

    def on_mouse_motion(self, x, y, dx, dy):
        # TODO 4: durante el aim, mover el proyectil a la posicion del mouse,
        # pero CLAMPEADA a un radio MAX_DRAG alrededor del ANCHOR.
        #
        # si no estamos apuntando (self.is_aiming es False), no hacer nada.
        #
        # pista con Vec2d:
        #   offset = Vec2d(x, y) - ANCHOR
        #   si offset.length > MAX_DRAG:
        #       offset = offset.normalized() * MAX_DRAG
        #   self.projectile_body.position = ANCHOR + offset
        raise NotImplementedError("completar on_mouse_motion")

    def on_mouse_release(self, x, y, button, modifiers):
        # TODO 5 (la mas importante): disparar el proyectil al soltar el mouse.
        #
        # condiciones de salida temprana:
        #   - boton != arcade.MOUSE_BUTTON_LEFT  -> no es nuestro evento
        #   - not self.is_aiming                 -> no estabamos apuntando
        #
        # si no se cumplen: salir.
        #
        # cuando si: poner self.is_aiming = False y disparar.
        #
        # como disparar:
        #   1. calcular el vector "drag" = self.projectile_body.position - ANCHOR.
        #      si su .length es muy chico (< 5) no disparar -- el usuario solo
        #      hizo click sin arrastrar. resetear projectile_body.position = ANCHOR
        #      y salir.
        #   2. cambiar el body a DYNAMIC:
        #        self.projectile_body.body_type = pymunk.Body.DYNAMIC
        #   3. asignar mass y moment EXPLICITAMENTE. esto es importante:
        #      un body que fue KINEMATIC tiene mass=inf; al pasar a DYNAMIC
        #      queda en 0 si no se lo seteamos a mano, y aplicar impulso da nan.
        #
        #        self.projectile_body.mass = PROJECTILE_MASS
        #        self.projectile_body.moment = pymunk.moment_for_circle(
        #            PROJECTILE_MASS, 0, PROJECTILE_R,
        #        )
        #   4. calcular el impulso = -drag * IMPULSE_SCALE
        #      (el menos es para que vaya en direccion OPUESTA al arrastre)
        #   5. aplicar el impulso al centro de masa:
        #        self.projectile_body.apply_impulse_at_local_point(impulse, (0, 0))
        raise NotImplementedError("completar on_mouse_release")

    # --- el resto ya esta listo ---

    def on_key_press(self, symbol, modifiers):
        if symbol == arcade.key.SPACE:
            self._respawn_projectile()

    def on_update(self, delta_time):
        self.space.step(1 / 60)

        # remociones diferidas (targets golpeados): se procesan despues del step.
        for body, shape in self.pending_removals:
            self.space.remove(body, shape)
            keep = []
            for b, s, sp in self.targets:
                if b is body:
                    sp.remove_from_sprite_lists()
                else:
                    keep.append((b, s, sp))
            self.targets = keep
        self.pending_removals.clear()

        # auto-respawn si el proyectil se fue fuera de la pantalla.
        if self.projectile_body.body_type == pymunk.Body.DYNAMIC:
            px, py = self.projectile_body.position
            if px < -50 or px > WIDTH + 50 or py < -50:
                self._respawn_projectile()

        # sincronizar sprites con sus bodies (patron del modulo).
        self.projectile_sprite.center_x = self.projectile_body.position.x
        self.projectile_sprite.center_y = self.projectile_body.position.y
        self.projectile_sprite.radians = self.projectile_body.angle
        for body, _shape, sprite in self.targets:
            sprite.center_x = body.position.x
            sprite.center_y = body.position.y
            sprite.radians = body.angle

    def on_draw(self):
        self.clear()
        for (x0, y0), (x1, y1) in self.walls:
            arcade.draw_line(x0, y0, x1, y1, arcade.color.WHITE, 2)
        arcade.draw_circle_filled(ANCHOR.x, ANCHOR.y, 6, arcade.color.RED)
        if self.is_aiming:
            px, py = self.projectile_body.position
            arcade.draw_line(ANCHOR.x, ANCHOR.y, px, py, arcade.color.LIGHT_GREEN, 3)
        self.target_sprites.draw()
        arcade.draw_sprite(self.projectile_sprite)
        arcade.draw_text(
            f"score: {self.score}",
            20, HEIGHT - 40, arcade.color.WHITE, 22,
        )
        arcade.draw_text(
            "click sobre el proyectil amarillo, arrastra y suelta para disparar.  SPACE = respawn",
            20, 10, arcade.color.LIGHT_GRAY, 12,
        )


# extensiones opcionales (cuando los 5 TODOs ya funcionen):
# 1. agregar obstaculos: una columna de cajas a media altura entre el slingshot
#    y los targets. cambia la estrategia de disparo (hay que curvarse por arriba).
# 2. limite de disparos: terminar el juego despues de N tiros, mostrar "fin".
# 3. distintos tipos de proyectil: uno pesado (mas masa, mas daño), uno liviano.
# 4. multi-hit: que un target requiera 2-3 golpes antes de desaparecer.
#    pista: agregar un atributo "hp" al body (body.hp = 3) y decrementarlo en el
#    handler en lugar de remover directamente.
# 5. sonido en cada impacto con arcade.play_sound.


def main():
    window = arcade.Window(WIDTH, HEIGHT, TITLE)
    window.show_view(SlingshotView())
    arcade.run()


if __name__ == "__main__":
    main()
