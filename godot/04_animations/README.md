# 04_animations — Sesión 4: Animaciones y máquinas de estado

Proyecto Godot 4.6. Cuarta sesión del módulo 7.

**La idea de la sesión:** tu código no dice *"mostrá el frame 14"*; dice
*"estoy atacando hacia la derecha"*. Hay **dos máquinas de estado**:

1. una en **código** (un `enum`) que decide la **lógica** del personaje, y
2. el **AnimationTree** que decide cómo se **ve**.

El código solo llama a `state_machine.travel("Run")` y el AnimationTree elige
la animación. Separar *estado* de *visual* es el "ajá" de la clase.

## Cómo correr cada escena

Abrí la carpeta en Godot 4.6. Escena principal: `03_arena_combate.tscn`.
Con cada escena abierta, `F6` la corre sola.

| Escena | Tier | Qué muestra |
|---|---|---|
| `scenes/01_animationplayer.tscn` | ✅ demo | Lo básico: el `AnimationPlayer`. `caminar` anima `frame` (flipbook); `rebote` (ESPACIO) anima `scale` y `modulate` → *anima cualquier propiedad*. |
| `scenes/02_estado_simple.tscn` | ✅ demo | El paso intermedio: una **máquina de estado mínima** (idle / run / attack, una animación por estado) con `AnimationTree` + `travel()`, **sin BlendSpace**. |
| `scenes/03_arena_combate.tscn` | 🔨 demo en vivo | El player con dos máquinas de estado + cada estado es un **BlendSpace2D** (4 direcciones) + ataque cuyo **HitBox se activa desde la animación** + `Health` con señales y un HUD. |
| `scenes/04_enemigo_estados.tscn` | 🎓 ejercicio | El murciélago con la máquina a medio hacer: tiene el AnimationTree y las animaciones, falta la máquina de **código**. |

## Controles

- **WASD / flechas** — mover (top-down, 4 direcciones).
- **ESPACIO** o **clic** — atacar.

## Los tres niveles del proyecto

- **✅ Demos completos** — `01_animationplayer`, `02_estado_simple` y el
  murciélago "saco de boxeo" de la arena. Se proyectan y corren tal cual.
- **🔨 Placeholder del docente** — `scripts/player_combate.gd`. La escena carga,
  pero las líneas clave (los `travel()`, el `blend_position`, el cambio de
  estado) están como `# TODO` para completar en vivo frente a la clase. La
  solución paso a paso está en la guía de la sesión.
- **🎓 Ejercicio del estudiante** — `scripts/exercises/enemigo_estados.gd` (con
  `# TODO`). El alumno arma la máquina de estado de 5 estados
  (PATROL / CHASE / ATTACK / HURT / DIE).

## Estructura

```
scenes/
  01_animationplayer.tscn      ✅ AnimationPlayer básico
  02_estado_simple.tscn        ✅ máquina de estado mínima (sin BlendSpace)
  03_arena_combate.tscn        🔨 demo de combate (escena principal)
  04_enemigo_estados.tscn      🎓 ejercicio (script con TODO)
  player.tscn                  player top-down con AnimationTree (4 direcciones)
  bat.tscn                     murciélago simple (persigue y muere)
  hit_box.tscn / hurt_box.tscn  áreas de golpe/daño (capas de la sesión 3)
scripts/
  flipbook.gd                  ✅
  estado_simple.gd             ✅ máquina de estado mínima
  player_combate.gd            🔨 placeholder del docente
  arena.gd                     HUD de la arena
  bat_simple.gd                enemigo "saco de boxeo"
  health.gd / hit_box.gd       componentes de combate reutilizables
  exercises/
    enemigo_estados.gd         🎓 ejercicio (TODO)
```

## Capas de física (repaso de la sesión 3)

El proyecto usa capas con nombre (Project Settings → Layer Names):

| Capa | Nombre | Quién la usa |
|---|---|---|
| 2 | `player` | cuerpo del player |
| 3 | `enemy` | cuerpo del enemigo |
| 4 | `player_hit` | HitBox del player (su golpe) |
| 5 | `player_hurt` | HurtBox del player (lo dañan) |
| 6 | `enemy_hit` | HitBox del enemigo |
| 7 | `enemy_hurt` | HurtBox del enemigo |

`layer` = lo que SOY; `mask` = lo que DETECTO.
