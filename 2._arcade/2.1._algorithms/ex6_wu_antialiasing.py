# algoritmo de Wu — primera aparicion del anti-aliasing en el curso.
#
# bresenham/DDA prenden UN pixel por paso: la linea queda escalonada.
# Wu prende DOS pixels por paso (los dos vecinos verticales del paso
# actual) con intensidades proporcionales a que tan cerca estan de la
# linea ideal. el ojo integra los dos en un gris -> el escalon
# desaparece visualmente.
#
# devuelve tuplas (x, y, intensity) con intensity en [0, 1].
from ex3_bresenham_full import get_line as get_line_bresenham

def get_line(x0: int, y0: int, x1: int, y1: int) -> list[tuple[int, int, float]]:
    points: list[tuple[int, int, float]] = []

    # si la pendiente es mayor a 1, intercambiar ejes para iterar siempre
    # sobre el eje "largo". despues al guardar volvemos a swap.
    steep = abs(y1 - y0) > abs(x1 - x0)
    if steep:
        x0, y0 = y0, x0
        x1, y1 = y1, x1
    # garantizar x0 < x1
    if x0 > x1:
        x0, x1 = x1, x0
        y0, y1 = y1, y0

    dx = x1 - x0
    dy = y1 - y0
    gradient = dy / dx if dx != 0 else 1.0

    def plot(x: int, y_int: int, alpha: float):
        if steep:
            points.append((y_int, x, alpha))
        else:
            points.append((x, y_int, alpha))

    # endpoints — version simple: pixel pleno
    plot(x0, y0, 1.0)
    plot(x1, y1, 1.0)

    # interior: dos pixels por columna con intensidades fraccionales
    intery = y0 + gradient
    for x in range(x0 + 1, x1):
        y_int = int(intery)
        frac = intery - y_int
        plot(x, y_int, 1 - frac)
        plot(x, y_int + 1, frac)
        intery += gradient

    return points


if __name__ == "__main__":
    from visualize import show

    p0, p1 = (5, 5), (55, 22)
    p2, p3 = (5, 30), (55, 8)
    pixels = (
        get_line(*p2, *p3) 
        + [(x, y, 1.0) for x, y in get_line_bresenham(*p0, *p1)]
    )

    show(
        pixels,
        title="Wu (anti-aliasing)",
        with_intensity=True,
        endpoints=[p0, p1, p2, p3],
    )
