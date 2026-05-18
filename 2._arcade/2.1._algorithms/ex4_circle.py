# ejercicio: midpoint circle algorithm (boilerplate).
#
# ya rasterizamos lineas de varias maneras. el circulo es la siguiente
# primitiva natural y usa la misma idea que Bresenham: una variable de
# decision incremental que solo necesita enteros.
#
# truco: aprovechar la simetria del circulo. solo calculamos los pixels
# de UN octante (1/8 del circulo) y reflejamos para los otros 7.
#
# referencia rapida del algoritmo:
#   x, y = 0, r
#   p = 1 - r        # variable de decision
#   while x < y:
#       x += 1
#       if p < 0:
#           p += 2*x + 1
#       else:
#           y -= 1
#           p += 2*(x - y) + 1
#       (graficar los 8 puntos simetricos)


def plot_8_symmetric(xc: int, yc: int, x: int, y: int) -> list[tuple[int, int]]:
    """devuelve los 8 puntos simetricos al centro (xc, yc)
    a partir de un punto (x, y) en el primer octante.
    """
    return [
        (xc + x, yc + y), (xc - x, yc + y),
        (xc + x, yc - y), (xc - x, yc - y),
        (xc + y, yc + x), (xc - y, yc + x),
        (xc + y, yc - x), (xc - y, yc - x),
    ]


def get_circle(xc: int, yc: int, r: int) -> list[tuple[int, int]]:
    pixels: list[tuple[int, int]] = []

    # estado inicial: arrancamos en el "norte" del circulo (0, r)
    x, y = 0, r
    p = 1 - r
    pixels.extend(plot_8_symmetric(xc, yc, x, y))

    # iteramos solo en el segundo octante (x crece, y decrece) hasta que
    # se cruzan en la diagonal x == y. los otros 7 octantes salen gratis
    # por simetria via plot_8_symmetric.
    while x < y:
        x += 1
        if p < 0:
            p += 2 * x + 1
        else:
            y -= 1
            p += 2 * (x - y) + 1
        pixels.extend(plot_8_symmetric(xc, yc, x, y))

    return pixels


if __name__ == "__main__":
    from visualize import show

    pixels = get_circle(30, 17, 12)
    show(pixels, title="Midpoint circle", endpoints=[(30, 17)])


# extensiones opcionales (cuando lo basico funcione):
# 1. dibujar varios circulos concentricos con distintos r.
# 2. comparar contra el "metodo bruto": for x in -r..r: y = sqrt(r^2 - x^2)
#    y ver la diferencia de pixels generados.
# 3. extender a elipses (algoritmo de midpoint ellipse).
# 4. circulo "relleno": en cada paso, en vez de 8 puntos, dibujar las
#    lineas horizontales que conectan los pares simetricos.
