# Truco Uruguayo

Videojuego de truco uruguayo para PC, hecho en Godot. Se juega con muestra, piezas, flor y señas, en pareja con un compañero controlado por la computadora y contra dos rivales.

## Estado

**Fase 4 terminada: IA, personalidades y señas.** Se juega un partido completo contra rivales con personalidad que estiman sus chances sin ver cartas ocultas. El compañero y los rivales se hacen señas, y vos podés hacerle señas a tu compañero. Las cartas siguen siendo provisionales. Hay 79 pruebas automáticas en verde. El arte, el sonido, los menús y el tutorial llegan en las fases siguientes.

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
  ia/          inteligencia artificial: por muestreo, personalidades, asistente y rivales de referencia
  senas/       perfiles de señas y registro de quién vio cada una
  datos/       datos editables (perfil de señas en JSON)
  mediciones/  medición larga de la fuerza de la IA
  mesa/        escena de la mesa, controlador y cartas provisionales
  pruebas/     pruebas automáticas (GUT)
```

## Compilar y ejecutar

Para jugar, abrí `juego/project.godot` con Godot 4.7.2 y apretá F5, o ejecutá desde la carpeta del repositorio:

```bash
~/Herramientas/Godot/4.7.2/Godot_v4.7.2-stable_win64.exe --path juego
```

**Controles del prototipo:**

- clic en una carta para jugarla, o las teclas 1, 2 y 3;
- clic en los botones de la derecha para cantar o responder;
- Enter para pasar a la mano siguiente;
- S o el botón «Hacer una seña…» para hacerle una seña a tu compañero;
- P o Esc para pausar.

Para comprobar que los clics llegan con la ventana real:

```bash
herramientas/probar_clics.sh
```

Para medir la fuerza de la IA (1000 partidos, unos 5 minutos):

```bash
herramientas/medir_ia.sh
```

Para ejecutar las pruebas sin abrir el editor:

```bash
herramientas/pruebas.sh
```

El script busca Godot en `~/Herramientas/Godot/4.7.2/`. Si está en otra carpeta, indicá la ruta del ejecutable de consola en la variable `GODOT`. Devuelve 0 si todas las pruebas pasan, y 1 si alguna falla o si algún script tiene errores. Para ejecutar un solo archivo: `herramientas/pruebas.sh -gselect=test_cantos`.
