# 04.5_companion — Bonus: compañero autónomo + game manager

Proyecto Godot 4.6. **Mini-integración** entre las sesiones 4 y 5 del módulo 7.
No agrega conceptos nuevos: **junta** todo lo de combate (player, enemigo,
`Health`, HitBox/HurtBox, capas) en **una sola escena** y agrega dos piezas de
arquitectura: un **compañero (conejo) con IA propia** y un **GameManager** que
coordina el estado del juego y las barras de vida.

**La idea:** hasta ahora cada cosa vivía sola. Acá el alumno ve cómo se *integra*
un juego: varios personajes con vida, una UI que reacciona a señales, y un aliado
que debe decidir entre **dos objetivos a la vez** (quedarse con vos vs. ir a pelear).

## El juego

Sobreviví y **junta las 5 monedas** antes de que se acabe el tiempo, mientras dos
murciélagos te persiguen. Tu **conejo** te acompaña y pelea por su cuenta.

- **Ganás:** juntás todas las monedas.
- **Perdés:** se acaba el tiempo **o** muere tu personaje.

## Cómo correr

```
Abrir la carpeta 04.5_companion/ en Godot 4.6.
F5  → corre la escena principal (scenes/main.tscn).
```

## Controles

- **WASD / flechas** — mover (top-down, 4 direcciones).
- **ESPACIO** o **clic** — atacar.

> Solo **tu personaje** junta monedas. El **conejo** no recoge: su trabajo es pelear.

## Los tres niveles del proyecto

### ✅ Completo (reutilizado, no se toca)
Vienen terminados de sesiones anteriores y son los bloques de construcción:

- `scripts/player_combate.gd` + `scenes/player.tscn` — el player con combate (sesión 4).
- `scripts/enemy.gd` + `scenes/enemy.tscn` — el murciélago con su FSM de 5 estados (sesión 4).
- `scripts/coin.gd` + `scenes/coin.tscn` — la moneda coleccionable (sesión 6).
- `scripts/health.gd`, `scripts/hit_box.gd`, `scenes/hit_box.tscn`, `scenes/hurt_box.tscn` — componentes de combate (sesión 3/4).
- `scripts/health_bar.gd` — barra de vida que se conecta sola a un `Health` por señal.

### 🔨 Placeholder del docente — `scripts/game_manager.gd`
La escena carga y el reloj corre, pero falta **conectar las señales** y escribir
los handlers de victoria/derrota (marcados con `# TODO 🔨`). Es la parte de
*integración* para completar **en vivo**: conectar `coin.collected`,
`game_timer.timeout` y los `health_depleted` del player y del pet.

### 🎓 Ejercicios del estudiante
1. **El combate del conejo** — `scripts/pet.gd`. El conejo ya **sigue** al jugador
   y se aturde si lo golpean, pero **no pelea**. El alumno completa los `# TODO` de
   la máquina de estado: el salto `FOLLOW → CHASE`, perseguir al enemigo, y atacar
   cuando está a tiro (con el detalle del **leash**: si se aleja mucho del jugador,
   abandona la pelea y vuelve).
2. **¿Qué pasa si muere el conejo?** — el `# TODO 🎓` en `_on_pet_died()` del
   GameManager. Decisión de diseño: avisar y seguir / penalizar el tiempo / que
   también sea derrota.

> Soluciones de referencia en `_solutions/` (`pet_solved.gd`, `game_manager_solved.gd`).

## La pieza interesante: el conejo es un aliado con doble objetivo

El enemigo de la sesión 4 tenía **un** objetivo (perseguir al player). El conejo
tiene **dos en conflicto** y decide en cada frame:

```
        ┌──────── enemigo cerca Y dentro del leash ────────┐
        ▼                                                   │
   [ FOLLOW ] ──────────────────────────────────────► [ CHASE ] ──► [ ATTACK ]
   sigue al jugador        (si se aleja del jugador      a tiro
                            o pierde al enemigo, vuelve)
        ▲                                                   │
        └──────────────── [ HURT ] ◄────── lo golpean ──────┘
```

El **leash** (correa) es lo que vuelve esto un *compañero* y no un segundo enemigo:
nunca se va demasiado lejos de vos.

## Capas de física (reutilizadas de la sesión 4)

El conejo juega **en el equipo del jugador**, así que reusa exactamente las mismas
capas que el player — no se inventan capas nuevas:

| Capa | Nombre | Quién la usa |
|---|---|---|
| 1 | `world` | paredes del borde |
| 2 | `player` | cuerpo del player **y del conejo** + sus HurtBox (para que el enemigo los detecte) |
| 3 | `enemy` | cuerpo del enemigo, su DetectionArea |
| 4 | `player_hit` | HitBox del player **y del conejo** (su golpe) |
| 5 | `player_hurt` | HurtBox del player y del conejo (los dañan) |
| 6 | `enemy_hit` | HitBox del enemigo |
| 7 | `enemy_hurt` | HurtBox del enemigo (lo que detecta el DetectionArea del conejo) |

`layer` = lo que SOY; `mask` = lo que DETECTO. Como el conejo está en `player_hit` /
`player_hurt`, el esquema de la sesión 4 "ya funciona": el enemigo lo daña y él daña
al enemigo, sin tocar nada.

## Estructura

```
scenes/
  main.tscn          escena principal (player + conejo + enemigos + monedas + HUD)
  player.tscn        ✅ player con combate (reusado)
  enemy.tscn         ✅ murciélago con FSM (reusado)
  pet.tscn           el conejo (Sprite2D + HitBox/HurtBox/DetectionArea/Health)
  coin.tscn          ✅ moneda (reusada)
  hit_box.tscn / hurt_box.tscn   ✅ áreas de golpe/daño
scripts/
  player_combate.gd  ✅ reusado
  enemy.gd           ✅ reusado
  coin.gd            ✅ reusado
  health.gd / hit_box.gd  ✅ componentes
  health_bar.gd      ✅ barra de vida (se conecta a un Health por señal)
  pet.gd             🎓 ejercicio: la IA del conejo (TODO)
  game_manager.gd    🔨 placeholder del docente: integración (TODO)
_solutions/
  pet_solved.gd            solución del conejo
  game_manager_solved.gd   solución del GameManager
assets/
  textures/Player, textures/Enemies, textures/coin.png   (sesiones 4 y 6)
  characters/CharacterSprites.png                          (el conejo, del pack bunny)
```

## Notas de animación del conejo

El conejo **no usa AnimationTree** (eso ya fue la sesión 4). Se anima **por código**
en `pet.gd::_update_animation()`: `CharacterSprites.png` es una grilla 4×4 donde la
**fila** es la dirección (0 abajo, 1 arriba, 2 izquierda, 3 derecha) y las
**columnas 1–3** son el ciclo de caminar. Es a propósito: el foco del ejercicio es la
**IA**, no la animación.

## Revisar una vez en el editor

Este proyecto se armó fuera de Godot. Al abrirlo por primera vez, conviene confirmar:

- [ ] El proyecto importa sin errores y `main.tscn` abre.
- [ ] Las animaciones del player y del murciélago (AnimationTree) se ven bien.
- [ ] El conejo se ve y mira hacia donde camina (ajustar `scale`/`position` del `Sprite2D` si hace falta).
- [ ] Tras completar `pet.gd`, el conejo persigue y pega; la HitBox solo prende durante el ataque (`ATTACK_TIME`).
- [ ] Las barras de vida bajan al recibir golpes.
