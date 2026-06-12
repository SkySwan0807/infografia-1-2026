# 05.5_ai_navigation — Navegación con IA (steering + pathfinding)

Proyecto Godot 4.6. Cubre **dos sesiones** del módulo 7, sobre un solo escenario
que se va extendiendo:

- **Sesión 5.5 — IA reactiva** (steering + detección + máquina de estados).
- **Sesión 5.6 — Pathfinding** (`AStarGrid2D` sobre el tilemap; navmesh como contraste).

**La idea:** en la sesión 5 aprendimos a construir el mundo con tiles. Ahora ese
mundo se vuelve el **dato sobre el que un enemigo navega**. Primero con IA reactiva
(rápida pero choca contra las paredes), y después con pathfinding (calcula el camino
y rodea los obstáculos). El mapa de tiles es, a la vez, lo que se dibuja, lo que
choca, y la grilla por la que se navega.

## Cómo correr cada escena

Abre la carpeta en Godot 4.6. Cada escena se corre sola con `F6`. Mové al jugador
con **WASD / flechas** y mirá cómo reacciona el enemigo.

| Escena | Tier | Sesión | Qué muestra |
|---|---|---|---|
| `scenes/01_steering.tscn` | ✅ demo | 5.5 | **Seek + arrive**: el enemigo va derecho al jugador y frena al llegar. Campo abierto, sin paredes. |
| `scenes/02_escenario_reactivo.tscn` | ✅ demo | 5.5 | **El escenario.** Máquina de estados PATRULLA→PERSIGUE→REGRESA + línea de vista (RayCast2D). Funciona… hasta que se **traba contra el muro**. |
| `scenes/03_grilla.tscn` | ✅ demo | 5.6 | **La grilla.** `AStarGrid2D` construido desde el TileMapLayer de paredes; se dibuja encima (rojo = bloqueada). |
| `scenes/04_camino.tscn` | ✅ demo | 5.6 | **Seguir el camino.** A* calcula la ruta y el enemigo rodea el muro. Se dibuja el camino. (Probá `diagonales = true`.) |
| `scenes/05_recalculo.tscn` | 🔨 docente | 5.6 | **Recalcular bien.** La 04 recalcula 60×/seg; acá se completa en vivo el *throttling*. |
| `scenes/06_terreno.tscn` | 🎓 ejercicio | 5.6 | **Terreno con costo.** Pesos por celda (`set_point_weight_scale`): el enemigo rodea el barro. Completá `_pesos_por_terreno()`. |
| `scenes/07_navagent.tscn` | ✅ demo | 5.6 | **El camino del motor.** `NavigationAgent2D` + navmesh horneado del tilemap. El contraste con A*. |

> Escena principal del proyecto: `02_escenario_reactivo.tscn`.

## Controles

- **WASD / flechas** — mover al jugador (top-down).

## Los tres niveles del proyecto

Igual que el resto del módulo:

- **✅ Demos completos (`01`, `02`, `03`, `04`, `07`)** — para proyectar y correr.
- **🔨 Placeholder del docente (`05`)** — `enemigo_recalculo.gd` tiene un bloque
  `TODO` (el *throttling*) para completar en vivo en clase.
- **🎓 Ejercicio (`06`)** — `scripts/exercises/enemigo_terreno.gd` tiene 3 `TODO`:
  leer el dato `costo` de cada tile y aplicarlo como peso. Solución en `_solutions/`.

## El escenario

El mundo (`scenes/escenario.tscn`, pintado por `scripts/mapa.gd`) es un cuarto con:

- un **borde** de cerco (con colisión),
- un **muro divisor** vertical en la mitad de arriba (deja paso por abajo) — obliga
  a rodear,
- un par de **pilares**,
- un **charco de barro** (agua) en la zona abierta — caminable pero **caro** (costo 5
  vs 1 del pasto), para el ejercicio de terreno.

Las paredes son los **obstáculos** (la IA las lee con `paredes.get_used_cells()`);
el suelo lleva en cada tile un dato custom **`costo`** (lo lee con `get_cell_tile_data`).

## Estructura

```
tilesets/
  mundo_nav.tres      pasto + tierra + cerco (con colisión) + agua;
                      capa de física (paredes) + custom data "costo"
scenes/
  escenario.tscn      el mundo (Suelo + Paredes), pintado por código
  player.tscn         jugador top-down reusado (sesión 2)
  01_steering.tscn … 07_navagent.tscn
scripts/
  mapa.gd             pinta el escenario; expone Suelo/Paredes
  jugador.gd          movimiento top-down
  enemigo_steering.gd seek + arrive
  enemigo_reactivo.gd máquina de estados + línea de vista
  grilla_debug.gd     dibuja el AStarGrid2D
  enemigo_astar.gd    seguir el camino A* (+ diagonales)
  enemigo_recalculo.gd throttling (placeholder)
  nav_bake.gd         hornea el navmesh desde el tilemap
  enemigo_navagent.gd NavigationAgent2D
  exercises/
    enemigo_terreno.gd  pesos por terreno (con TODO)
_solutions/           solo del docente (gitignored)
  enemigo_terreno_solved.gd
  06_terreno_solved.tscn
```

## Verificación

El proyecto se armó fuera del editor. Antes de la primera clase, abrí cada `.tscn`
en Godot 4.6 y corré con `F6`:

- `01`: el enemigo persigue y frena suave sobre el jugador.
- `02`: acercá el jugador al enemigo sin pared en medio → lo persigue; metelo detrás
  del muro → el enemigo **se traba** (ese es el gancho de la sesión 5.6).
- `03`: se ve la grilla; las paredes salen en rojo.
- `04`: el enemigo rodea el muro siguiendo el camino dibujado.
- `06`: con el ejercicio completo (o `_solutions/06_terreno_solved.tscn`), el enemigo
  **rodea el barro** en vez de cruzarlo.
- `07`: el enemigo navega con el navmesh del motor.
