# 10._shaders — Shaders: el GPU pinta cada pixel

Proyecto Godot 4.6. **Módulo 10**, tres sesiones sobre **shaders**:

- **Sesión 1 — Pintar con matemática**: `fragment()`, `UV`, patrones, uniforms.
- **Sesión 2 — Vestir sprites**: texturas, distorsión, `vertex()` y el puente con GDScript.
- **Sesión 3 — La pantalla entera**: shaders de pantalla, pausa en gris, luz 2D + normal maps.

**La idea del módulo:** hasta ahora el CPU decide y el GPU obedece. Un shader es código
que corre *en* el GPU — una vez por pixel (`fragment()`) o por vértice (`vertex()`),
todos a la vez, en paralelo. En rasterización (módulo 3.1) pintaste pixeles uno por uno
con un `for`; acá no hay `for`: el GPU ya está dentro. La pregunta que contesta un
fragment shader es una sola: **¿de qué color es ESTE pixel?**

El alcance crece una escala por sesión: **un rectángulo → un sprite → la pantalla
entera**. Es el último módulo antes del proyecto final: el hit flash, el disolver, la
viñeta de daño y la pausa en gris son efectos listos para enchufar en tu juego.

## Cómo correr cada escena

Abre la carpeta en Godot 4.6. Cada escena se corre sola con `F6`.

| Escena | Tier | Sesión | Qué muestra |
|---|---|---|---|
| `scenes/01_color_solido.tscn` | ✅ demo | 1 | `fragment()` y `COLOR`: tres líneas, primer shader. |
| `scenes/02_uv_gradiente.tscn` | ✅ demo | 1 | **UV** (la posición del pixel), `mix`, `length` + `smoothstep`. |
| `scenes/03_visual_vs_codigo.tscn` | ✅ demo | 1 | El **mismo** shader como grafo (VisualShader) y como código, lado a lado. |
| `scenes/04_patrones.tscn` | ✅ demo | 1 | `floor` + `mod`: tablero y franjas — celdas sin arrays. |
| `scenes/05_uniforms.tscn` | 🔨 docente | 1 | **Uniforms**: las constantes se convierten en perillas del inspector, en vivo. |
| `scenes/06_ejercicio_bandera.tscn` | 🎓 ejercicio | 1 | **La bandera**: franjas con `UV.y` + círculo suave. Magenta = falta tu código. |
| `scenes/07_efectos_textura.tscn` | ✅ demo | 2 | `texture(TEXTURE, UV)`: gris, sepia, tinte y contorno (vecinos). |
| `scenes/08_distorsion.tscn` | ✅ demo | 2 | Distorsionar **dónde se lee** la textura: agua, calor, pixelar. |
| `scenes/09_vertex_ondas.tscn` | ✅ demo | 2 | `vertex()`: sprite de 4 vértices vs malla subdividida; pasto anclado. |
| `scenes/10_hit_flash.tscn` | 🔨 docente | 2 | **El puente**: GDScript empuja un uniform con `set_shader_parameter` + tween. |
| `scenes/11_ejercicio_disolver.tscn` | 🎓 ejercicio | 2 | **Disolver**: ruido + `discard`. El clic ya está cableado; falta tu línea. |
| `scenes/12_pantalla.tscn` | ✅ demo | 3 | Shader de **pantalla** (`hint_screen_texture`): viñeta y CRT con teclas 0/1/2. |
| `scenes/13_pausa_gris.tscn` | 🔨 docente | 3 | Esc pausa (módulo 9) y la pantalla **debería** ponerse gris — en vivo. |
| `scenes/14_luz_normal.tscn` | ✅ demo | 3 | `PointLight2D` + **normal map**: la misma imagen, con y sin volumen. |
| `scenes/15_ejercicio_onda.tscn` | 🎓 ejercicio | 3 | **Síntesis**: viñeta de daño con H — shader de pantalla + puente GDScript. |

> Escena principal del proyecto: `01_color_solido.tscn`.
> Teclas usadas: `H` (golpe, escenas 10 y 15), `Esc` (pausa, escena 13),
> `0/1/2` (efecto de pantalla, escena 12), clic (disolver, escena 11),
> mouse (la antorcha de la 14).

## Los tres niveles del proyecto

- **✅ Demos completos (`01`–`04`, `07`–`09`, `12`, `14`)** — para proyectar y correr tal cual.
- **🔨 Placeholders del docente (`05`, `10`, `13`)** — corren sin errores pero les falta
  *la* línea, que se escribe en vivo (el `TODO (en vivo):` la trae casi lista):
  - `05`: declarar los `uniform` (con `source_color` / `hint_range`) y borrar las constantes.
  - `10`: la mezcla hacia blanco en `hit_flash.gdshader`. El script ya empuja el uniform:
    hasta escribir la línea, H no hace nada — y cuando funcione, **flashean los dos
    sprites**, porque comparten el material (el gotcha es a propósito; el arreglo es
    `resource_local_to_scene` o `material.duplicate()`).
  - `13`: la desaturación por luminancia en `pausa_gris.gdshader`. Pausa sí, gris no — se nota.
- **🎓 Ejercicios (`06`, `11`, `15`)** — tienen `TODO` con tres niveles de pista
  (qué → con qué herramienta → casi-la-línea) y un **estado roto visible**: magenta,
  clic que no hace nada, H que no hace nada. Cada uno trae su reto extra.
  Soluciones en `_solutions/` (en `.gitignore`: no se reparte).

## Las tres sesiones

**Sesión 1 — pintar con matemática.** Un shader de fragmento corre para cada pixel a la
vez; la única entrada que distingue a un pixel de otro es su posición `UV` (`01`, `02`).
La escena `03` enseña que el **grafo** (VisualShader) y el **código** son dos vistas del
mismo shader — cada nodo es una línea. Con `floor`/`mod` la posición se vuelve celdas
(`04`), y con los **uniforms** el shader saca perillas al inspector (`05`).

**Sesión 2 — vestir sprites.** `texture(TEXTURE, UV)` lee la imagen del sprite: a partir
de ahí gris, sepia, tinte y contorno son matemática sobre el color (`07`). Distorsionar
las UV antes de leer = agua, calor, pixelar (`08`). `vertex()` es el otro programa del
pipeline: mueve geometría, y por eso un sprite (4 vértices) se tambalea donde una malla
subdividida ondea (`09`). Y el puente que lo vuelve *de juego*: GDScript escribe uniforms
con `set_shader_parameter()` — hit flash (`10`) y disolver (`11`).

**Sesión 3 — la pantalla entera.** Un `ColorRect` que cubre la pantalla puede **leer el
frame ya dibujado** (`hint_screen_texture` + `SCREEN_UV`) y repintarlo: viñeta, CRT
(`12`). Combinado con la pausa del módulo 9: Esc congela el juego y desatura la pantalla
(`13`). La luz 2D no necesita shader propio: `PointLight2D` + un **normal map** hacen
que un sprite plano reaccione al ángulo de la luz (`14`). Cierre síntesis: la viñeta de
daño, disparada desde GDScript (`15`).

## APIs nuevas en este módulo

- `shader_type canvas_item`, `fragment()`, `vertex()` — los dos programas del pipeline.
- `COLOR`, `UV`, `TEXTURE`, `TEXTURE_PIXEL_SIZE`, `TIME`, `VERTEX`, `SCREEN_UV` — las
  variables nativas del shader.
- `uniform` + hints (`source_color`, `hint_range`, `hint_screen_texture`) — perillas
  para el inspector, el puente con el juego, y la lectura del frame.
- `ShaderMaterial.set_shader_parameter()` / `tween_property("shader_parameter/...")` —
  escribir uniforms desde GDScript.
- `discard` — el pixel no se dibuja.
- `VisualShader` — el mismo shader, como grafo de nodos.
- `MeshInstance2D` + `PlaneMesh` subdividido — vértices de sobra para `vertex()`.
- `NoiseTexture2D` (+ `FastNoiseLite`) — el ruido del disolver.
- `CanvasTexture` (diffuse + normal), `PointLight2D`, `CanvasModulate` — luz 2D.

## Estructura

```
scenes/        01–15 (tabla de arriba)
shaders/
  color_solido / uv_lineal / uv_mix / uv_radial      ✅ sesión 1
  radial_codigo.gdshader + visual_radial.tres        ✅ los gemelos de la 03
  tablero / franjas                                  ✅ patrones
  uniforms_demo.gdshader                             🔨 perillas en vivo
  gris / sepia / tinte / contorno                    ✅ efectos de textura
  agua / calor / pixelar                             ✅ distorsión
  ondear / pasto                                     ✅ vertex
  hit_flash.gdshader                                 🔨 la mezcla se escribe en vivo
  pantalla_fx.gdshader                               ✅ viñeta / CRT
  pausa_gris.gdshader                                🔨 la desaturación se escribe en vivo
  exercises/
    bandera.gdshader                                 🎓 franjas + círculo
    disolver.gdshader                                🎓 ruido + discard
    onda.gdshader                                    🎓 viñeta de daño (partes A y B)
scripts/
  hit_flash.gd        ✅ H → set_shader_parameter + tween (10)
  disolver_click.gd   ✅ clic → tween de "progreso" (11)
  mover.gd            ✅ sprites que rebotan, el "juego" de mentira (12, 13, 15)
  pantalla_fx.gd      ✅ teclas 0/1/2 → uniform "modo" (12)
  pausa_gris.gd       ✅ Esc → paused + uniform "cantidad" (13)
  luz.gd              ✅ antorcha que sigue el mouse (14)
  exercises/
    onda.gd           🎓 viñeta de daño (parte C)
assets/
  player.png, coin.png                  sprites (coin dash, módulo 7)
  piedra_diffuse.png, piedra_normal.png piedra generada + su normal map (14)
_solutions/                             (en .gitignore — solo para el docente)
  bandera_solved.gdshader, disolver_solved.gdshader,
  onda_solved.gdshader, onda_solved.gd
```

> El proyecto se armó fuera del editor y se validó corriendo cada escena en headless,
> sin errores — incluidas las versiones resueltas de los tres ejercicios y de los tres
> placeholders 🔨 (se aplican, se corre la escena, se restauran). El renderer headless
> sí compila los shaders, así que un error de sintaxis no se escapa; lo que no se ve en
> headless es la imagen: antes de clase abre cada escena en el editor y confirma que la
> `03` muestra el grafo, que la malla de la `09` ondea suave y que la luz de la `14`
> da volumen a la piedra de la izquierda.
