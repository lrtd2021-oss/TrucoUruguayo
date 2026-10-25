# Truco Uruguayo

Videojuego de truco uruguayo para PC, hecho en Godot. Se juega con muestra, piezas, flor y señas, en pareja con un compañero controlado por la computadora y contra dos rivales.

## Estado

**Fase 2 terminada: motor de reglas implementado y probado** (57 pruebas en verde, incluidos 1000 partidos simulados). Todavía no hay interfaz ni recursos gráficos: eso empieza en la Fase 3. Quedan en revisión algunas opciones del reglamento, la dirección artística y el diseño del tutorial.

| Documento | Contenido |
|-----------|-----------|
| [docs/RESULTADOS_PRUEBAS.md](docs/RESULTADOS_PRUEBAS.md) | Ejecuciones reales de las pruebas automáticas |
| [docs/VISION.md](docs/VISION.md) | Objetivo, público, experiencia y alcance de la versión 1.0 |
| [docs/REGLAS_TRUCO_URUGUAYO.md](docs/REGLAS_TRUCO_URUGUAYO.md) | Reglamento adoptado, fuentes, tablas, señas y casos de prueba |
| [docs/DIRECCION_ARTISTICA.md](docs/DIRECCION_ARTISTICA.md) | Tres alternativas visuales y la recomendada |
| [docs/PERSONAJES.md](docs/PERSONAJES.md) | Elenco, voz de cada personaje y líneas de muestra |
| [docs/TUTORIAL.md](docs/TUTORIAL.md) | Sistema de aprendizaje: capítulos, modos, capítulo 1 completo, progreso y pruebas |
| [docs/EVALUACION_MOTOR.md](docs/EVALUACION_MOTOR.md) | Comparación de GameMaker, Godot y Unity, y motivos de la elección de Godot |
| [docs/ARQUITECTURA.md](docs/ARQUITECTURA.md) | Entorno verificado, capas, modelo de datos, IA, señas y pruebas |
| [docs/DECISIONES.md](docs/DECISIONES.md) | Decisiones tomadas y su justificación |
| [docs/ROADMAP.md](docs/ROADMAP.md) | Fases, tareas, criterios de aceptación y riesgos |

## Requisitos

- Windows 10 u 11.
- **Godot 4.7.2** estable, versión estándar (GDScript), descargado de [godotengine.org](https://godotengine.org/download/windows/). Motivos de la elección en [docs/EVALUACION_MOTOR.md](docs/EVALUACION_MOTOR.md).
- Para las pruebas, Git Bash (o cualquier `bash`). GUT ya viene incluido en `juego/addons/gut/`.

## Estructura

```
docs/          documentación del proyecto
herramientas/  scripts del proyecto (pruebas; generación de recursos desde la Fase 5)
juego/         proyecto de Godot
  reglas/      motor de reglas: cartas, muestra, tantos, mano, partido, vista
  ia/          inteligencia artificial (por ahora, la aleatoria para pruebas)
  pruebas/     pruebas automáticas (GUT)
```

## Compilar y ejecutar

Todavía no hay nada que jugar: el proyecto contiene solo el motor de reglas. Para abrirlo, ejecutá Godot 4.7.2 e importá `juego/project.godot`.

Para ejecutar las pruebas sin abrir el editor:

```bash
herramientas/pruebas.sh
```

El script busca Godot en `~/Herramientas/Godot/4.7.2/`. Si está en otra carpeta, indicá la ruta del ejecutable de consola en la variable `GODOT`. Devuelve 0 si todas las pruebas pasan y 1 si alguna falla. Para ejecutar un solo archivo: `herramientas/pruebas.sh -gselect=test_cantos`.
