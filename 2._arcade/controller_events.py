# eventos de control (joystick / gamepad).
# arcade nos pasa la posicion del stick y los botones via callbacks.

import arcade

WIDTH = 1280
HEIGHT = 720
TITLE = "eventos de control"


class ControllerView(arcade.View):
    def __init__(self):
        super().__init__()
        self.background_color = arcade.color.YELLOW
        self.controller = None
        self.x_joy, self.y_joy = 0.0, 0.0
        self.last_button: str | None = None

        # API moderna: get_controllers() devuelve los controles conectados
        controllers = arcade.get_controllers()
        print(f"encontrados {len(controllers)} controles!")
        if controllers:
            self.controller = controllers[0]
            self.controller.open()
            self.controller.push_handlers(self)
            print("conectado a un control")

    def on_joybutton_press(self, controller, button_name):
        self.last_button = button_name
        print(f"boton presionado: {button_name}")

    def on_joybutton_release(self, controller, button_name):
        print(f"boton suelto: {button_name}")

    def on_joyaxis_motion(self, controller, axis, value):
        # ejes "x"/"y" del stick izquierdo. el eje y arcade lo da invertido.
        if axis == "x":
            self.x_joy = value
        elif axis == "y":
            self.y_joy = -value

    def on_draw(self):
        self.clear()
        # dibujar una linea desde el centro hacia donde apunta el stick
        mid_point = WIDTH // 2, HEIGHT // 2
        end_point = (
            mid_point[0] + int(self.x_joy * 100),
            mid_point[1] + int(self.y_joy * 100),
        )
        arcade.draw_line(*mid_point, *end_point, arcade.color.BLUE, 4)


def main():
    window = arcade.Window(WIDTH, HEIGHT, TITLE)
    game = ControllerView()
    window.show_view(game)
    arcade.run()


if __name__ == "__main__":
    main()
