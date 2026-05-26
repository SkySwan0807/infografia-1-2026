# bresenham clasico — version simplificada (un solo octante).
# solo funciona para dx > 0, dy > 0, dx >= dy. el caso "facil".
# la version generalizada esta en bresenham_full.py.
#
# idea: para cada paso en x, decidir si tambien subimos en y mirando
# la variable de decision Pk. si Pk > 0, el pixel siguiente esta mas
# cerca de y+1 que de y, asi que subimos.

def get_line(x0: int, y0: int, x1: int, y1: int) -> list[tuple[int, int]]:
    dx, dy = x1 - x0, y1 - y0
    xk, yk = x0, y0
    points = [(x0, y0)]
    Pk = 2 * dy - dx
    while xk < x1:
        xk += 1
        if Pk > 0:
            yk += 1
            Pk = Pk + 2 * dy - 2 * dx
        else:
            Pk = Pk + 2 * dy
        points.append((xk, yk))
    return points


if __name__ == "__main__":
    from visualize import show

    p0, p1 = (5, 50), (20, 20)
    pixels = get_line(*p0, *p1)
    show(pixels, title="Bresenham (un octante)", endpoints=[p0, p1])
