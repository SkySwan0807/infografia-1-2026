# 8._swarms — Enjambres: flocking (boids) + flow fields

Proyecto Godot 4.6. **Módulo 8**, dos sesiones sobre **movimiento de grupo y
comportamiento emergente**:

- **Sesión 1 — Boids**: una bandada que emerge de tres reglas locales.
- **Sesión 2 — Flow fields**: campos de flujo para mover multitudes hacia una meta.

**La idea del módulo:** reglas locales simples → patrón global complejo. Cada agente
solo mira a sus vecinos (boids) o lee un vector de su celda (flow field); nadie
programa "la bandada" ni "la multitud" — emergen. Es la continuación natural del
steering de la sesión 5.5 de Godot: ahí movíamos un agente; acá, cientos.

## Cómo correr cada escena

Abre la carpeta en Godot 4.6. Cada escena se corre sola con `F6`. En las escenas
con atractor/meta, **mové el mouse**: la bandada lo persigue / la multitud va hacia él.

| Escena | Tier | Sesión | Qué muestra |
|---|---|---|---|
| `scenes/01_separacion.tscn` | ✅ demo | 1 | Solo **separación**: los boids se reparten sin amontonarse. |
| `scenes/02_alineacion.tscn` | ✅ demo | 1 | Separación **+ alineación**: empiezan a moverse en la misma dirección. |
| `scenes/03_flocking.tscn` | ✅ demo | 1 | Las **tres reglas**: separación + alineación + cohesión = bandada. |
| `scenes/04_atractor.tscn` | ✅ demo | 1 | La bandada **persigue el mouse** (steering seek, sesión 5.5). |
| `scenes/05_campo_costo.tscn` | ✅ demo | 2 | **Campo de costo**: BFS desde la meta; mapa de calor (cerca = claro). |
| `scenes/06_campo_flujo.tscn` | 🎓 ejercicio | 2 | **Campo de flujo**: cada celda apunta a la meta. Completá `_construir_flujo()`. |
| `scenes/07_multitud.tscn` | 🔨 docente | 2 | **Multitud**: 200 agentes siguen el flujo hacia el mouse. Falta la separación (en vivo). |

> Escena principal del proyecto: `03_flocking.tscn`.

## Los tres niveles del proyecto

- **✅ Demos completos (`01`–`05`)** — para proyectar y correr. En la sesión 1, cambiá
  los **pesos** en el inspector del nodo raíz para ver el efecto de cada regla.
- **🎓 Ejercicio (`06`)** — `scripts/exercises/campo.gd` tiene el campo de costo listo
  y `_construir_flujo()` como `TODO`: calcular, por celda, el vector hacia el vecino
  de menor costo. Sin eso los agentes no se mueven. Solución en `_solutions/`.
- **🔨 Placeholder del docente (`07`)** — `scripts/agente_multitud.gd` sigue el flujo
  pero le falta la **separación** (un `TODO`): sin ella la multitud se encima. Se
  completa en vivo en clase. Solución en `_solutions/`.

## Las dos sesiones

**Sesión 1 — Boids.** Cada `boid.gd` mira a sus vecinos y suma tres impulsos
(separación, alineación, cohesión), cada uno un "steering" `= deseada - actual`
(igual que la 5.5). El `flock.gd` solo crea los boids y guarda los pesos comunes.
El mundo es toroidal (el que sale por un borde vuelve por el opuesto).

**Sesión 2 — Flow fields.** Un A* por agente no escala a cientos, y los boids no
tienen meta. El `campo.gd` resuelve el camino **una vez para todo el mapa**:
1. **campo de costo** — BFS desde la meta (0 en la meta, +1 por paso, las paredes no se cruzan);
2. **campo de flujo** — cada celda guarda el vector hacia su vecino de menor costo.
Después, cada agente solo lee el vector de su celda. Sumar **separación** (la regla
de los boids) hace que la multitud fluya sin encimarse: **flow field + separación =
navegación de multitudes**.

## Estructura

```
scenes/
  boid.tscn / agente.tscn / agente_multitud.tscn   los agentes (triángulos)
  01_separacion … 04_atractor                       sesión 1 (boids)
  05_campo_costo … 07_multitud                       sesión 2 (flow fields)
scripts/
  boid.gd            las 3 reglas + atractor (steering)
  flock.gd           crea los boids; pesos comunes
  campo.gd           campo de costo (BFS) + campo de flujo + dibujo
  agente.gd          sigue el flujo
  agente_multitud.gd flujo + separación (🔨 TODO)
  crowd.gd           crea la multitud
  exercises/
    campo.gd         campo de flujo con _construir_flujo() como 🎓 TODO
_solutions/          solo del docente (gitignored)
```

## Verificación

El proyecto se armó fuera del editor y se validó corriendo cada escena en headless.
Datos medidos: en `06` (ejercicio sin completar) el campo de flujo tiene **0** vectores
y los agentes **no se mueven**; con la solución, **558** vectores y los agentes fluyen.
Antes de clase, abrí cada escena en Godot 4.6 y confirmá:

- `01`–`03`: de "se dispersan" a "se ordenan" a "bandada" (probá tocar los pesos).
- `04`: la bandada sigue el mouse.
- `05`: mapa de calor del costo desde la meta.
- `06` (o `_solutions/06_campo_flujo_solved.tscn`): aparecen las flechas y los agentes fluyen.
- `07` (o `_solutions/07_multitud_solved.tscn`): 200 agentes van al mouse rodeando las paredes.
