# 02 — Nodos 2D, input y movimiento

Sesión 2 del módulo Godot. Movimiento **top-down (vista cenital, 8 direcciones)**: el jugador se mueve en las cuatro direcciones (y diagonales), sin gravedad ni salto.

Slides: [`slides/08.1_godot_2d.md`](../../slides/08.1_godot_2d.md)
Guía del docente: [`slides/GUIDE_godot.md`](../../slides/GUIDE_godot.md) (sección Sesión 2)

## Cómo correr

```
Abrir la carpeta 02_nodes_2d/ en Godot 4.6.
F5  → corre la escena principal (01_movimiento.tscn).
F6  → corre la escena que tengas abierta.
```

Controles (definidos en Project Settings → Input Map):

| Acción | Teclas |
|---|---|
| `izquierda` / `derecha` | A / D · ← / → |
| `arriba` / `abajo` | W / S · ↑ / ↓ |
| `correr` | Shift |
| `dash` | Espacio |
| `atacar` | J |

## Estructura de la sesión

Los archivos están organizados en **tres niveles**:

### Demos completos (✅ — para proyectar y correr)

| Escena | Qué muestra |
|---|---|
| `scenes/01_movimiento.tscn` | Movimiento 8-direccional con `Input.get_vector` + `.normalized()` + `move_and_slide()` |
| `scenes/03_camara.tscn` | `Camera2D` que sigue al jugador por un nivel más grande |
| `scenes/04_input_separado.tscn` | Patrón de separación: un nodo `PlayerControl` lee el input y maneja un `CharacterBody2D` por señales |

### Placeholders del docente (🔨 — completar en vivo en clase)

Estas escenas tienen el árbol de nodos listo y el script estructurado, pero les falta la
implementación clave marcada con `# TODO`. La idea es completarlas **en vivo** durante la clase.

| Escena | Qué se completa en vivo |
|---|---|
| `scenes/02_flip.tscn` | Voltear el sprite según la dirección horizontal del movimiento |

> El código exacto para completar cada `# TODO` está en la guía del docente.

### Ejercicios para estudiantes (🎓 — completar como práctica)

Cada ejercicio tiene `# TODO` para que el estudiante lo complete, y una solución de referencia
en `exercises/soluciones/`.

| Ejercicio | Objetivo |
|---|---|
| `exercises/ex1_correr.tscn` | Mantener Shift para moverse más rápido (sprint) |
| `exercises/ex2_dash.tscn` | Tocar Espacio para un impulso rápido en la dirección actual (con cooldown) |
| `exercises/ex3_ataque.tscn` | Atacar con J, bloqueando el movimiento mientras dura, con cooldown por `Timer` |

## Conceptos de la sesión

- `CharacterBody2D` + `velocity` + `move_and_slide()`.
- `Input.get_vector()` / `Input.get_axis()` para leer movimiento.
- `Vector2.normalized()` — por qué la diagonal sin normalizar es más rápida.
- `Camera2D` que sigue a un nodo.
- Acciones personalizadas en el **Input Map** (no solo `ui_*`).
- Patrón de **separación de responsabilidades**: el control del input vive en un nodo aparte del cuerpo físico.

## Assets

Texturas simples (placeholder) copiadas de `01_gdscript_basics`. Son intencionalmente básicas:
puedes reemplazarlas por sprites más lindos (por ejemplo los de `bunny/assets/`) sin tocar el código.
