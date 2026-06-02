# 05_tilemaps — Sesión 5: TileMapLayer

Proyecto Godot 4.6. Quinta sesión del módulo 7.

**La idea de la sesión:** un mundo de juego no se dibuja pixel por pixel ni se
arma con miles de `Sprite2D`. Se construye con **tiles**: piezas chiquitas de una
grilla que se repiten. Un `TileMapLayer` es esa grilla, y un `TileSet` es la caja
de piezas. Vamos a aprender el flujo **a mano en el editor** (importar, configurar,
pintar) y después a hacer lo mismo **desde código** (un mapa es, en el fondo, una
tabla de números).

## Cómo correr cada escena

Abre la carpeta en Godot 4.6. Cada escena se corre sola con `F6`.

| Escena | Tier | Qué muestra |
|---|---|---|
| `scenes/01_primer_tilemap.tscn` | 🔨 a mano | Un `TileMapLayer` **vacío**. El flujo base: crear el TileSet, poner tile size 16, agregar la fuente y pintar pasto. |
| `scenes/02_colisiones.tscn` | 🔨 a mano | Dos capas (suelo + paredes) y **colisión por tiles**. Agregas la capa de física y pintas el cerco; el jugador choca. |
| `scenes/03_mapa_por_codigo.tscn` | ✅ demo | El mapa **desde código**: un array 2D de números → `set_cell()`. Un nivel es dato. |
| `scenes/04_terrenos_autotile.tscn` | ✅ demo | **Autotile / terrenos**: dices "esta zona es pasto" y los bordes se resuelven solos (`set_cells_terrain_connect`). |
| `scenes/05_leer_el_mapa.tscn` | 🎓 ejercicio | **Leer** el mapa: el tile bajo el jugador trae un dato "tipo"; en el agua se frena. Completas el lookup. |
| `scenes/06_mundo_jugable.tscn` | ✅ demo | Todo junto: pasto + camino + estanque + cerco con colisión + jugador + cámara que sigue. (Escena principal.) |

## Controles

- **WASD / flechas** — mover (top-down, 4 direcciones).

## Los tres niveles del proyecto

- **🔨 A mano en el editor (`01`, `02`)** — son el corazón de la sesión: aprender
  *el flujo*. Vienen con la textura lista y el `TileMapLayer` esperando; tú creas
  el TileSet y pintas siguiendo la guía (`slides/GUIDE_godot_tilemaps.md`).
- **✅ Demos completos (`03`, `04`, `06`)** — para proyectar y correr. Pintan el
  mapa **desde código**, así que no dependen de que nadie pinte nada a mano.
- **🎓 Ejercicio (`05`)** — `scripts/exercises/leer_mapa.gd` tiene 3 `# TODO`:
  leer la celda bajo el jugador y frenarlo en el agua. Solución en `_solutions/`.

## Por qué unos a mano y otros por código

Pintar un `TileMapLayer` guarda las celdas como un blob binario, así que estas
escenas se diseñaron para enseñar las **dos formas reales** de armar un mapa:

- **A mano (editor):** el flujo del artista. Es lo que harás en `01` y `02`.
- **Por código (`set_cell`):** el flujo del programador, data-driven. Es lo que
  ves en `03`, `05` y `06`, y la base de los niveles procedurales.

## Estructura

```
tilesets/
  suelo.tres     ✅ atlas de pasto (lo usa 03)
  paredes.tres   🔨 pasto + cerco, SIN colisión (la agregas en 02)
  mundo.tres     ✅ pasto + tierra + cerco (con colisión) + agua (lo usa 06)
  datos.tres     🎓 pasto + agua con un custom data layer "tipo" (lo usa 05)
  terreno.tres   ✅ pasto con un terrain set para autotile (lo usa 04)
scenes/
  01_primer_tilemap.tscn   🔨 TileMapLayer vacío
  02_colisiones.tscn       🔨 2 capas + jugador
  03_mapa_por_codigo.tscn  ✅ + suelo.tres + mapa_por_codigo.gd
  04_terrenos_autotile.tscn ✅ + terreno.tres + terrenos.gd
  05_leer_el_mapa.tscn     🎓 + datos.tres + jugador con el ejercicio
  06_mundo_jugable.tscn    ✅ + mundo.tres + jugador + Camera2D
  player.tscn              ✅ jugador top-down reusado (sesión 2)
scripts/
  jugador.gd               ✅ movimiento top-down (move_and_slide)
  relleno_pasto.gd         ✅ rellena una grilla de pasto
  mapa_por_codigo.gd       ✅ pinta desde un array 2D
  terrenos.gd              ✅ set_cells_terrain_connect
  mapa_con_agua.gd         ✅ el escenario del ejercicio 05
  mundo.gd                 ✅ arma el mundo integrador (dos capas)
  exercises/
    leer_mapa.gd           🎓 leer custom data (TODO)
_solutions/                solo del docente (en .gitignore)
assets/textures/
  tiles/   Grass, Hills, Tilled_Dirt, Water, Fences, Doors, Walls, Roof  (Sprout Lands, 16px)
  Player/  Player.png  (el zorro de las sesiones 2 y 4)
```

## Capas de física

Solo dos, igual que la sesión 2:

| Capa | Nombre | Quién la usa |
|---|---|---|
| 1 | `mundo` | los tiles de cerco con colisión (en `mundo.tres`) |
| 2 | `jugador` | el cuerpo del jugador |

El jugador está en la capa `jugador` y su `mask` incluye `mundo`, así que choca con
los tiles de cerco sin escribir una sola línea de colisión.

## Revisar una vez en el editor

Este proyecto se armó fuera de Godot. Al abrirlo por primera vez, conviene confirmar:

- [ ] El proyecto importa sin errores y `06_mundo_jugable.tscn` abre.
- [ ] Los `.tres` abren en el inspector del TileSet sin warnings; cada fuente
      (atlas) muestra sus tiles. Si alguno se rompió, basta re-agregar la textura
      como fuente en el panel TileSet.
- [ ] `F6` en `03`, `04`, `06`: los mapas se pintan al correr. En `06` el jugador
      camina, choca con el cerco y la cámara lo sigue.
- [ ] El tile de pasto se ve liso. Las coordenadas de atlas (ej. `Vector2i(1,5)`)
      apuntan a un casillero concreto de `Grass.png`; si ves un tile raro, ajusta
      la coordenada en el script o en el `.tres` (el casillero de pasto liso está
      en la banda inferior izquierda de la imagen).
- [ ] `04` (terrenos): trae solo el tile central cableado, así que el bloque se ve
      liso. Para ver los **bordes** del autotile, asigna los tiles de esquina/lado
      en el panel TileSet → Terrains (es el ejercicio del bitmask de las slides).
- [ ] `_solutions/05_leer_el_mapa_solved.tscn`: el jugador se frena en el estanque.
