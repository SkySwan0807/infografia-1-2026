# eventos basicos: teclado y mouse.
# patron: (1) atender el evento -> (2) mutar estado -> (3) renderizar en on_draw.

import arcade

WIDTH = 1280
HEIGHT = 720
TITLE = "eventos arcade"


class CircleCharacter:
    def __init__(self, x0, y0, r=50, color=arcade.color.RED):
        self.x = x0
        self.y = y0
        self.r = r
        self.color = color

    def draw(self):
        arcade.draw_circle_filled(self.x, self.y, self.r, self.color)


class EventsView(arcade.View):
    def __init__(self):
        super().__init__()
        self.background_color = arcade.color.YELLOW
        # estado de la app
        self.char = CircleCharacter(WIDTH // 2, HEIGHT // 2)
        self.speed = 4
        self.stroke_points: list[tuple[int, int]] = []

    # 1. atencion de eventos
    def on_key_press(self, symbol, modifiers):
        if symbol == arcade.key.UP:
            # 2. actualizacion del estado
            self.char.y += self.speed
        elif symbol == arcade.key.DOWN:
            self.char.y -= self.speed

    def on_mouse_press(self, x, y, button, modifiers):
        print(f"boton presionado! {button} en posicion: {x}, {y}")
        # cada click empieza un trazo nuevo
        self.stroke_points = []

    def on_mouse_drag(self, x, y, dx, dy, _buttons, _modifiers):
        self.stroke_points.append((x, y))

    def on_mouse_release(self, x, y, button, modifiers):
        # al soltar el mouse, el personaje teleporta a esa posicion
        self.char.x = x
        self.char.y = y

    def draw_stroke(self):
        if len(self.stroke_points) >= 2:
            arcade.draw_line_strip(self.stroke_points, arcade.color.GREEN, 3)

    # 3. renderizacion
    def on_draw(self):
        self.clear()
        self.char.draw()
        self.draw_stroke()


def main():
    window = arcade.Window(WIDTH, HEIGHT, TITLE)
    game = EventsView()
    window.show_view(game)
    arcade.run()


if __name__ == "__main__":
    main()
