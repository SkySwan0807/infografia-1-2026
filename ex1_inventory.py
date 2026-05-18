# ejercicio 0: inventario de mochila
# usa: listas, diccionarios, funciones, bucles
#
# objetivo: dado el inventario de un jugador (lista de items que pueden
#           repetirse) y una tabla de precios, calcular estadisticas
#           usando funciones pequeñas.


# lista de items que el jugador tiene en la mochila (con repetidos)
inventario = [
    "pocion",
    "espada",
    "pocion",
    "escudo",
    "pocion",
    "antorcha",
    "espada",
    "llave",
]

# tabla de precios: item -> oro
precios = {
    "pocion":   5,
    "espada":   50,
    "escudo":   40,
    "antorcha": 2,
    "llave":    10,
}


def valor_total(items: list[str], tabla: dict[str, int]) -> int:
    # TODO: devolver la suma del precio de todos los items del inventario.
    #
    return sum(tabla[item] for item in items)


def contar(items: list[str]) -> dict[str, int]:
    # TODO: devolver un diccionario item -> cuantas veces aparece en la lista.
    #
    # pista: empezar con un dict vacio {}. para cada item, si ya esta en el
    #        dict, sumarle 1; si no, ponerlo en 1.
    #        (tambien se puede usar dict.get(item, 0) + 1)
    #
    # ejemplo: ["a", "b", "a", "a"] -> {"a": 3, "b": 1}
    raise NotImplementedError("completar contar")


def mas_repetido(items: list[str]) -> str:
    # TODO: devolver el item que aparece mas veces en el inventario.
    #
    # pista: reusar contar(items) y despues buscar la clave con mayor valor.
    #        se puede recorrer el dict con un for y guardar el maximo,
    #        o usar max(dict, key=dict.get).
    raise NotImplementedError("completar mas_repetido")


# TODO: usar las funciones de arriba para imprimir:
#   1. el valor total de la mochila en oro
#   2. el conteo de cada item (item: cantidad)
#   3. cual es el item mas repetido
#
# formato sugerido:
#   valor total: 167 oro
#   conteo:
#     pocion:   3
#     espada:   2
#     escudo:   1
#     antorcha: 1
#     llave:    1
#   mas repetido: pocion


# extensiones opcionales (cuando lo de arriba ya funcione):
# 1. agregar una funcion vender(items, tabla, item) que quite UNA aparicion
#    del item de la lista y devuelva su precio (o 0 si no estaba).
# 2. hacer que valor_total ignore items que no estan en la tabla
#    (en vez de fallar con KeyError).
# 3. imprimir el conteo ordenado de mas a menos repetido.
