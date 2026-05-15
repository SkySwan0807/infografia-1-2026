# bresenham generalizado — funciona en los 8 octantes.
# generaliza bresenham.py manejando signos y eligiendo el eje "rapido".
#
# truco: en vez de iterar siempre en x, llevamos un "error" comun.
# si el error indica que es mejor mover en x, lo hacemos; si indica y,
# tambien. los signos sx, sy dan la direccion sin importar el cuadrante.

def get_line(x0: int, y0: int, x1: int, y1: int) -> list[tuple[int, int]]:
    points = []
    dx = abs(x1 - x0)
    dy = abs(y1 - y0)
    sx = 1 if x0 < x1 else -1
    sy = 1 if y0 < y1 else -1
    err = dx - dy

    x, y = x0, y0
    while True:
        points.append((x, y))
        if x == x1 and y == y1:
            break
        e2 = 2 * err
        if e2 > -dy:
            err -= dy
            x += sx
        if e2 < dx:
            err += dx
            y += sy
    return points


if __name__ == "__main__":
    from visualize import show

    # mismo line que bresenham.py para comparar
    p0, p1 = (5, 5), (50, 25)
    pixels = get_line(*p0, *p1)

    # ahora una linea "imposible" para el bresenham simple: dy > dx, hacia arriba-izquierda
    p2, p3 = (50, 5), (10, 30)
    pixels += get_line(*p2, *p3)

    # y una vertical pura
    p4, p5 = (30, 8), (30, 32)
    pixels += get_line(*p4, *p5)

    show(pixels, title="Bresenham 8 octantes", endpoints=[p0, p1, p2, p3, p4, p5])
