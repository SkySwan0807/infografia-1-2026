# 9._ui — UI: cómo el juego le habla al jugador

Proyecto Godot 4.6. **Módulo 9**, dos sesiones sobre **interfaz de usuario**:

- **Sesión 1 — Que se vea bien**: `Control`, anclas, contenedores y un tema.
- **Sesión 2 — Que funcione**: botones, señales, cambio de pantalla, pausa y un HUD vivo.

**La idea del módulo:** la UI de Godot es su propio mundo —nodos `Control`, no
`Node2D`— y se arma en dos pasos. Primero **que se vea bien**: dejas de posicionar
por píxel y los **contenedores** acomodan todo solos; un **tema** le da el mismo
aspecto a toda la interfaz desde un solo lugar. Después **que funcione**: los botones
emiten **señales** que cambian de pantalla, la **pausa** congela el juego sin congelar
el menú, y un **HUD** escucha las señales del juego y se actualiza solo.

Es el último módulo antes del proyecto final: lo que armas acá (menú → juego → pausa →
HUD → game over) es el esqueleto de UI de cualquier juego.

## Cómo correr cada escena

Abre la carpeta en Godot 4.6. Cada escena se corre sola con `F6`. En la `01`,
**redimensiona la ventana** para ver las anclas en acción. En la `06`, **pulsa Esc**.

| Escena | Tier | Sesión | Qué muestra |
|---|---|---|---|
| `scenes/01_control_vs_anchors.tscn` | ✅ demo | 1 | **Anclas y presets**: los paneles siguen sus esquinas al redimensionar; un `Node2D` no. |
| `scenes/02_contenedores.tscn` | ✅ demo | 1 | **Contenedores**: VBox / Grid / Margin / Center acomodan a sus hijos; *size flags*. |
| `scenes/03_menu_con_tema.tscn` | ✅ demo | 1 | Un **menú** con `tema.tres`: un solo tema viste todos los botones. |
| `scenes/04_panel_settings.tscn` | 🎓 ejercicio | 1 | **Panel de opciones**. Faltan las filas (Label + control). Las agregas tú. |
| `scenes/05_menu_interactivo.tscn` | ✅ demo | 2 | **Menú interactivo**: `pressed` → `change_scene_to_file()`. |
| `scenes/06_pausa.tscn` | ✅ demo | 2 | **Pausa**: `get_tree().paused` + `process_mode`. El cuadrado se congela, el menú no. |
| `scenes/07_hud_vivo.tscn` | 🔨 docente | 2 | **HUD vivo**: puntos, tiempo y barra de vida que escuchan señales. La barra se completa en vivo. |
| `scenes/08_game_over.tscn` | 🎓 ejercicio | 2 | **Game over**. Los botones están conectados pero vacíos: cablea la navegación. |

> Escena principal del proyecto: `05_menu_interactivo.tscn` (con `F5` arranca el menú).
> **El flujo de la sesión 2**: `05` —Jugar→ `07` —se acaba la vida→ `08` —Reintentar/Menú→ vuelve.

## Los tres niveles del proyecto

- **✅ Demos completos (`01`, `02`, `03`, `05`, `06`)** — para proyectar y correr tal cual.
- **🎓 Ejercicios (`04`, `08`)** — tienen un `TODO`:
  - `04` es **solo escena**: agrega dentro del `VBoxContainer` dos filas (un `HBoxContainer`
    con `Label` + control). El `Label` lleva `size_flags_horizontal = 3` para empujar el
    control a la derecha.
  - `08` es **solo script** (`scripts/exercises/game_over.gd`): los botones ya están
    conectados; falta que sus métodos cambien de escena.
  - Soluciones en `_solutions/` (esa carpeta está en `.gitignore`: no se reparte).
- **🔨 Placeholder del docente (`07`)** — `scripts/barra_vida.gd` ya se conecta a la señal
  `vida_cambiada`, pero su reacción (`_on_vida_cambiada`) está vacía: una sola línea que se
  escribe en vivo. Hasta entonces la barra se queda llena aunque la vida baje —se nota.

## Las dos sesiones

**Sesión 1 — que se vea bien.** Un `Control` vive en coordenadas de pantalla, no de
mundo. Las **anclas** lo amarran a un borde/esquina, así la UI se acomoda cuando cambia
el tamaño de la ventana (`01`). Pero lo que de verdad ahorra trabajo son los
**contenedores**: un `VBoxContainer`, `HBoxContainer`, `GridContainer`… dueñan la
posición de sus hijos —dejas de arrastrar por píxel (`02`). Y un **tema** (`tema.tres`)
define cómo se ven *todos* los botones, paneles y etiquetas desde un solo lugar (`03`).

**Sesión 2 — que funcione.** Un botón emite la señal `pressed`; nosotros la escuchamos
y le pedimos al árbol que cambie de pantalla (`05`). Regla mental: **las señales suben,
las llamadas bajan**. La **pausa** es `get_tree().paused = true`: congela el árbol entero,
salvo los nodos con `process_mode` en *Siempre* o *Cuando se pausa* —por eso el menú de
pausa sigue vivo mientras el juego se congela (`06`). Y el **HUD** no pregunta nada en un
bucle: **escucha las señales** del juego (`vida_cambiada`, un `Timer`) y cada widget se
actualiza solo (`07`).

## APIs nuevas en este módulo

No aparecieron en módulos anteriores; vale la pena nombrarlas:

- `get_tree().change_scene_to_file("res://...")` — reemplaza la escena actual por otra.
- `get_tree().paused` y la propiedad `process_mode` de cada nodo — la pausa.
- Tema (`Theme` / `.tres`) y `StyleBoxFlat` — el aspecto de toda la UI desde un lugar.
- Contenedores y `size_flags_*` — el layout automático.

## Estructura

```
scenes/
  01_control_vs_anchors.tscn   ✅ anclas / presets (+ un Node2D que NO se ancla)
  02_contenedores.tscn         ✅ VBox / Grid / Margin / Center + size flags
  03_menu_con_tema.tscn        ✅ menú que referencia tema.tres
  04_panel_settings.tscn       🎓 ejercicio: armar el panel de opciones
  05_menu_interactivo.tscn     ✅ botones → change_scene_to_file
  06_pausa.tscn                ✅ pausa con process_mode
  07_hud_vivo.tscn             🔨 HUD que escucha señales (barra = TODO en vivo)
  08_game_over.tscn            🎓 ejercicio: cablear la navegación
scripts/
  menu_principal.gd            ✅ navegación del menú (05)
  pausa.gd                     ✅ alternar pausa + botones (06)
  mover.gd                     ✅ el cuadrado que rebota / se congela (06, 07)
  salud.gd                     ✅ modelo de vida con señales (07)
  barra_vida.gd                🔨 barra que escucha la señal (07) — reacción en vivo
  hud.gd                       ✅ controla puntos, tiempo y game over (07)
  exercises/
    game_over.gd               🎓 navegación de la pantalla de game over (08)
themes/
  tema.tres                    ✅ el tema único del proyecto
_solutions/                    (en .gitignore — solo para el docente)
  04_panel_settings_solved.tscn
  08_game_over_solved.tscn
  game_over_solved.gd
```

> El proyecto se armó fuera del editor y se validó importando y corriendo cada escena en
> headless, sin errores. Si lo abres en el editor, eso es lo que tienes que ver.
