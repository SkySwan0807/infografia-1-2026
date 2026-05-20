# ejemplo 1: pymunk en modo "headless" (sin ventana, sin arcade).
# concepto nuevo: pymunk es un motor de fisica 2D, independiente de
# como se dibuje. los tres ladrillos basicos son:
#
#   Space  -> el mundo. tiene gravedad, contiene bodies, avanza el tiempo
#   Body   -> el objeto fisico. tiene masa, posicion, velocidad, angulo
#   Shape  -> la forma del body para colisiones (caja, circulo, segmento)
#
# en este archivo no hay ventana: simulamos 100 pasos e imprimimos en la
# consola el bounding box de cada body. sirve para ver que pymunk "se
# mueve solo" antes de meter dibujo en el medio. en 02_falling_box.py
# vamos a montar arcade encima para verlo en pantalla.

import pymunk

# crear el espacio. la gravedad es un vector; Y negativo = hacia abajo.
# las unidades son arbitrarias aqui (no hay pantalla); en los siguientes
# ejemplos vamos a usar valores grandes porque trabajamos en pixeles.
space = pymunk.Space()
space.gravity = (0, -9)

# crear un body dinamico (le aplica gravedad y se mueve solo)
body = pymunk.Body()
body.position = (50, 100)
body.mass = 1

# crear una shape (caja) ligada a ese body
shape = pymunk.Poly.create_box(body)

# registrar body + shape en el espacio
space.add(body, shape)

# debug_draw imprime una representacion ASCII de los bodies a stdout.
# es la forma mas barata de "ver" la simulacion sin abrir una ventana.
print_options = pymunk.SpaceDebugDrawOptions()

for _ in range(100):
    space.step(0.02)  # avanzar 20 ms (equivale a 50 FPS)
    space.debug_draw(print_options)
