# helper compartido del modulo 3.1: dibujar pixels en una grilla coarsened.
# cada algoritmo de rasterizacion devuelve una lista de pixels, y este
# modulo abre una ventana arcade con la grilla y los pinta como cuadrados
# grandes para que se vea claramente cual celda esta encendida.

import arcade

CELL = 16          # pixeles de pantalla por "pixel" rasterizado
GRID_W = 60        # celdas a lo ancho
GRID_H = 35        # celdas a lo alto
WIDTH = CELL * GRID_W
HEIGHT = CELL * GRID_H

GRID_COLOR = (60, 60, 80)
PIXEL_COLOR = arcade.color.YELLOW
ENDPOINT_COLOR = arcade.color.CYAN


def show(pixels, title: str = "rasterizado", with_intensity: bool = False, endpoints: list | None = None):
    """abrir una ventana arcade y dibujar los pixels en la grilla.

    pixels: lista de (x, y) o (x, y, alpha) si with_intensity=True.
    endpoints: lista opcional de (x, y) para resaltar (en cyan).
    """
    endpoints = endpoints or []

    class GridView(arcade.View):
        def __init__(self):
            super().__init__()
            self.background_color = arcade.color.BLACK

        def on_draw(self):
            self.clear()
            # grilla
            for gx in range(GRID_W + 1):
                arcade.draw_line(gx * CELL, 0, gx * CELL, HEIGHT, GRID_COLOR, 1)
            for gy in range(GRID_H + 1):
                arcade.draw_line(0, gy * CELL, WIDTH, gy * CELL, GRID_COLOR, 1)

            # pixels rasterizados
            for p in pixels:
                if with_intensity:
                    x, y, a = p
                    a = max(0.0, min(1.0, a))
                    color = (int(255 * a), int(255 * a), int(180 * a))
                else:
                    x, y = p
                    color = PIXEL_COLOR
                if 0 <= x < GRID_W and 0 <= y < GRID_H:
                    arcade.draw_lrbt_rectangle_filled(
                        x * CELL, (x + 1) * CELL,
                        y * CELL, (y + 1) * CELL,
                        color,
                    )

            # endpoints como circulos
            for x, y in endpoints:
                arcade.draw_circle_filled(
                    x * CELL + CELL // 2, y * CELL + CELL // 2,
                    CELL // 3, ENDPOINT_COLOR,
                )

            arcade.draw_text(title, 10, HEIGHT - 26, arcade.color.WHITE, 16, bold=True)
            arcade.draw_text(f"{len(pixels)} pixels", 10, 8, arcade.color.WHITE, 12)

    window = arcade.Window(WIDTH, HEIGHT, title)
    window.show_view(GridView())
    arcade.run()
