# 03 — Física y colisiones

Sesión 3 del módulo Godot. **Side-view con gravedad**: el jugador se mueve izquierda/derecha y salta. Aparecen los otros tipos de cuerpo (`StaticBody2D`, `RigidBody2D`, `Area2D`) y el sistema de **capas y máscaras** como modelo mental para "qué interactúa con qué".

Slides: [`slides/08.2_godot_physics.md`](../../slides/08.2_godot_physics.md)
Guía del docente: [`slides/GUIDE_godot_physics.md`](../../slides/GUIDE_godot_physics.md)

## Cómo correr

```
Abrir la carpeta 03_physics_collisions/ en Godot 4.6.
F5  → corre la escena principal (01_pachinko.tscn).
F6  → corre la escena que tengas abierta.
```

Controles (definidos en Project Settings → Input Map):

| Acción | Teclas |
|---|---|
| `izquierda` / `derecha` | A / D · ← / → |
| `saltar` | Espacio · W · ↑ |

## Capas físicas (Project Settings → Layer Names → 2D Physics)

| Bit | Nombre | Uso |
|---|---|---|
| 1 | `mundo` | piso, paredes exteriores, plataformas, clavos del pachinko |
| 2 | `jugador` | el jugador y el fantasma (es un personaje también) |
| 3 | `muro` | pilares interiores del demo del fantasma |
| 4 | `recolectable` | monedas |
| 5 | `hazard` | púas, Hurtbox del enemigo |
| 6 | `enemigo` | cuerpo del enemigo (ex2) |
| 7 | `pelota` | bolas del pachinko |

Cada cuerpo tiene **`collision_layer`** (en qué capas SOY) y **`collision_mask`** (qué capas DETECTO). Una colisión sucede cuando el `mask` de uno toca alguna `layer` del otro.

## Estructura de la sesión

Los archivos están organizados en **tres niveles**:

### Demos completos (✅ — para proyectar y correr)

| Escena | Qué muestra |
|---|---|
| `scenes/01_pachinko.tscn` | Pachinko / Galton board — `StaticBody2D` (clavos) + `RigidBody2D` (bolas) + `Area2D` (cajas) |
| `scenes/04_layers_fantasma.tscn` | Capas/máscaras: el fantasma atraviesa los pilares si destildas su mask de `muro` |

### Placeholders del docente (🔨 — completar en vivo en clase)

Estas escenas tienen el árbol de nodos listo y el script estructurado, pero les falta la
implementación clave marcada con `# TODO`. La idea es completarlas **en vivo** durante la clase.

| Escena | Qué se completa en vivo |
|---|---|
| `scenes/02_gravedad_y_salto.tscn` | Gravedad, input horizontal y salto (`is_on_floor` + `just_pressed`) en `player_gravedad.gd` |
| `scenes/03_pickups_y_hazards.tscn` | El handler de `body_entered` de la moneda (`moneda.gd`) y de la púa (`pua.gd`) |

> Las soluciones para los placeholders están en `scripts/_ref/`. Son referencia para el docente, no se referencian desde ninguna escena.

### Ejercicios para estudiantes (🎓 — completar como práctica)

Cada ejercicio tiene `# TODO` para que el estudiante lo complete, y una solución de referencia
en `exercises/soluciones/`.

| Ejercicio | Objetivo | Concepto |
|---|---|---|
| `exercises/ex1_doble_salto.tscn` | Permitir saltar hasta 2 veces antes de tocar piso | estado en una variable + reset al tocar piso |
| `exercises/ex2_enemigo_patrulla.tscn` | Enemigo que camina ida y vuelta en un rango y daña al jugador al tocarlo | mover entre límites + patrón **Hurtbox** (Area2D hijo) |

## Conceptos de la sesión

- Los **4 tipos de cuerpo**: `StaticBody2D`, `CharacterBody2D`, `RigidBody2D`, `Area2D`.
- **Gravedad** = sumar a `velocity.y` cada frame; **salto** = poner `velocity.y` a un valor negativo cuando `is_on_floor()`.
- **`Area2D`** + `body_entered` para pickups, hazards, triggers, hurtboxes.
- **Capas y máscaras** como modelo mental — la pieza central de la sesión.
- **Patrón Hurtbox**: separar el cuerpo que se mueve del Area2D que detecta el daño.

## Assets

Texturas en `assets/textures/` — sprites de Kenney (CC0) mineados del proyecto staging `collisions_demo/`. Para el pachinko se usa `fireball.png` (bola), `gem.png` (clavo). Para el jugador, `player_idle.png`. Para el enemigo del ex2, `enemy_b.png`. Las púas, plataformas y pilares se dibujan con `Polygon2D` (sin sprite).
