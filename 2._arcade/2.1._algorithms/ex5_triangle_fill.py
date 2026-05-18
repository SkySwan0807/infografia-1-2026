# scanline triangle fill.
# despues de saber rasterizar lineas, la primitiva 2D que sigue es el
# triangulo relleno — la base de TODA la rasterizacion 3D moderna.
#
# idea: ordenar los 3 vertices por y. partir el triangulo en dos mitades
# (la "panza" inferior y la superior). para cada scanline horizontal,
# encontrar donde la cruzan las dos aristas activas e iluminar la franja
# entre ambas.

def get_triangle(p0: tuple[int, int], p1: tuple[int, int], p2: tuple[int, int]) -> list[tuple[int, int]]:
    # ordenar por y ascendente: v0 (mas bajo), v1 (medio), v2 (mas alto)
    v0, v1, v2 = sorted([p0, p1, p2], key=lambda p: p[1])
    (x0, y0), (x1, y1), (x2, y2) = v0, v1, v2

    pixels: list[tuple[int, int]] = []

    def edge_x(ya: int, yb: int, xa: int, xb: int, y: int) -> float:
        # x sobre la arista (xa,ya)-(xb,yb) a la altura y, por interpolacion lineal
        if yb == ya:
            return float(xa)
        t = (y - ya) / (yb - ya)
        return xa + (xb - xa) * t

    # mitad inferior: y0 <= y < y1, aristas (v0->v1) y (v0->v2)
    for y in range(y0, y1):
        xa = edge_x(y0, y2, x0, x2, y)
        xb = edge_x(y0, y1, x0, x1, y)
        for x in range(int(min(xa, xb)), int(max(xa, xb)) + 1):
            pixels.append((x, y))

    # mitad superior: y1 <= y <= y2, aristas (v0->v2) y (v1->v2)
    for y in range(y1, y2 + 1):
        xa = edge_x(y0, y2, x0, x2, y)
        xb = edge_x(y1, y2, x1, x2, y)
        for x in range(int(min(xa, xb)), int(max(xa, xb)) + 1):
            pixels.append((x, y))

    return pixels


if __name__ == "__main__":
    from visualize import show

    p0, p1, p2 = (10, 5), (50, 12), (25, 30)
    pixels = get_triangle(p0, p1, p2)

    show(pixels, title="Triangle fill (scanline)", endpoints=[p0, p1, p2])
