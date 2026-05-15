# DDA (Digital Differential Analyzer).
# el algoritmo "obvio" antes de Bresenham: avanzar en pasos pequeños
# usando floats e ir redondeando para obtener el pixel mas cercano.
#
# - mas corto y simple de leer que Bresenham.
# - usa floats: en hardware antiguo era mucho mas lento.
# - acumula error de redondeo en lineas largas.
#
# bresenham gana en velocidad y precision en enteros; DDA gana en claridad.

def get_line(x0: int, y0: int, x1: int, y1: int) -> list[tuple[int, int]]:
    dx = x1 - x0
    dy = y1 - y0
    # numero de pasos = la distancia mas grande entre los dos ejes
    steps = max(abs(dx), abs(dy))
    if steps == 0:
        return [(x0, y0)]

    x_inc = dx / steps
    y_inc = dy / steps

    points = []
    x, y = float(x0), float(y0)
    for _ in range(steps + 1):
        points.append((round(x), round(y)))
        x += x_inc
        y += y_inc
    return points


if __name__ == "__main__":
    from visualize import show

    # mismo segmento que bresenham_full.py para comparar visualmente
    p0, p1 = (5, 5), (50, 25)
    p2, p3 = (50, 5), (10, 30)
    p4, p5 = (30, 8), (30, 32)
    pixels = get_line(*p0, *p1) + get_line(*p2, *p3) + get_line(*p4, *p5)

    show(pixels, title="DDA", endpoints=[p0, p1, p2, p3, p4, p5])
