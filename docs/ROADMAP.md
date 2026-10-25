# Hoja de ruta

Estados: **pendiente**, **en curso**, **bloqueada** y **completada**. Una tarea solo pasa a *completada* cuando se comprobó su criterio de aceptación.

## Resumen de fases

| Fase | Contenido | Estado |
|------|-----------|--------|
| 0 | Reconocimiento del entorno | completada |
| 1 | Investigación, diseño y planificación | en curso: motor aprobado; reglas, arte y tutorial en revisión |
| 2 | Motor de reglas y pruebas | completada con el reglamento base (ver nota) |
| 3 | Prototipo jugable | completada |
| 4 | IA, señas y comportamiento | completada (con mejoras de la IA pendientes) |
| 5 | Identidad visual, animaciones y audio | pendiente |
| 6 | Menús, diálogos, tutorial y accesibilidad | pendiente |
| 7 | Pruebas finales y preparación del lanzamiento | pendiente |

## Fase 0: reconocimiento del entorno

| Tarea | Estado | Verificación |
|-------|--------|--------------|
| Identificar la versión de GameMaker y del runtime | completada | `version.txt` y carpeta de runtimes: 2026.0.0.23 |
| Localizar Igor y la especificación de GML | completada | Archivos presentes (ARQUITECTURA.md, 1) |
| Revisar herramientas disponibles | completada | Python, Pillow, Node, ffmpeg y Git detectados |
| Revisar Git | completada | Repositorio propio creado (D-14) y remoto configurado |

## Fase 1: investigación, diseño y planificación

| Tarea | Estado | Verificación |
|-------|--------|--------------|
| Investigar el reglamento uruguayo y sus variantes | completada | REGLAS_TRUCO_URUGUAYO.md con 8 fuentes y discrepancias registradas |
| Investigar las señas | completada | Reglamento, punto 11 |
| Investigar las capacidades de GameMaker | completada | Funciones verificadas en `GmlSpec.xml` y en el manual LTS |
| Tres direcciones artísticas y una recomendación | completada | DIRECCION_ARTISTICA.md y boceto comparativo |
| Personajes y voz de los diálogos | completada | PERSONAJES.md |
| Arquitectura | completada | ARQUITECTURA.md |
| Diseño del sistema de aprendizaje: índice, objetivos, capítulo 1 completo, progreso, arquitectura y pruebas | completada | TUTORIAL.md |
| Evaluación del motor (GameMaker, Godot, Unity y otros) | completada | EVALUACION_MOTOR.md, con recomendación D-17 |
| Aprobación del motor (D-17) | completada | Godot 4.7.2 aprobado el 2026-10-25; ARQUITECTURA.md y TUTORIAL.md adaptados |
| **Revisión del usuario de las demás propuestas** | **pendiente** | Aprobación o cambios en D-03 a D-09, D-13, D-15, D-16 y TD-01 a TD-10 |

## Fase 2: motor de reglas

Dependencias: motor aprobado (D-17).

| # | Tarea | Estado | Verificación |
|---|-------|--------|--------------|
| 2.1 | Godot 4.7.2 portable y GUT 9.7.1 (descargados con autorización); referencia de la API con `--doctool` | completada | SHA-512 de Godot verificado; una prueba que falla devuelve 1 y una que pasa devuelve 0 |
| 2.2 | `juego/project.godot` con resolución base, renderizador Compatibilidad y tipado obligatorio | completada | El proyecto importa en headless; un script sin tipos se rechaza |
| 2.3 | GUT con `.gutconfig.json` y `herramientas/pruebas.sh` | completada | Comando único, código de salida correcto |
| 2.4 | `reglas/carta.gd` y `reglas/muestra.gd` | completada | R-01 a R-07 pasan |
| 2.5 | `reglas/tantos.gd` | completada | R-10 a R-17 y R-20 a R-25 pasan |
| 2.6 | `reglas/reglamento.gd`, `reglas/accion.gd` y `reglas/mano.gd`: fases, acciones válidas, bazas y pardas | completada | R-30 a R-36 y R-60 a R-64 pasan |
| 2.7 | Cantos: envido, flor y truco, con la pila de cantos | completada | R-40 a R-54 pasan |
| 2.8 | `reglas/partido.gd`: tanteador, falta y victoria | completada | R-43 y R-55 pasan |
| 2.9 | `reglas/vista.gd` y reproducibilidad | completada | R-18, R-65 y R-66 pasan |
| 2.10 | IA aleatoria y simulación masiva | completada | R-67: 1000 partidos (8638 manos) sin fallos y con cobertura de todas las situaciones |
| 2.11 | Desgloses de envido y flor, y escenarios construidos con `aplicar` | completada | Los desgloses cierran en todos los ejemplos del reglamento; un escenario ilegal no se construye |

**Criterio de fase cumplido:** las pruebas R-01 a R-67 pasan **ejecutadas en Godot** (GUT en headless). Resultado en [RESULTADOS_PRUEBAS.md](RESULTADOS_PRUEBAS.md). R-68 (señas) corresponde a la Fase 4.

**Nota:** el motor implementa el reglamento base. Si se confirman otras opciones (D-04, D-06, falta en malas, D-20), cambian `Reglamento` o la anotación de la flor y sus pruebas, sin tocar la estructura.

## Fase 3: prototipo jugable

| # | Tarea | Estado | Verificación |
|---|-------|--------|--------------|
| 3.1 | Escena de mesa con cartas provisionales (`mesa/mesa.tscn`, `mesa/carta_vista.gd`) | completada | Capturas reales a 1280×720, 1366×768, 1920×1080 y 1920×1200. Se ven la mano propia (con insignia de pieza), la muestra con sus piezas y el alcahuete, las cartas jugadas, los dorsos, el tanteador con malas y buenas, las bazas, el valor de la mano y el registro |
| 3.2 | Controlador de la mesa (`mesa/controlador_mesa.gd`) y cola de eventos animados | completada | Un clic doble aplica una sola vez; mientras se anima no se aplica nada (pruebas `test_32_*`) |
| 3.3 | Botones creados a partir de las acciones válidas | completada | Un botón por acción válida, y solo las cartas jugables se pueden tocar (`test_33_*`). Los clics de ratón reales en ventana llegan al motor (`herramientas/probar_clics.sh`); comprobado también que falla si algo tapa la pantalla |
| 3.4 | Partida completa contra la IA mínima | completada | 8 partidos a 30 jugados tocando la interfaz, sin bloqueos (`test_34_*`); partidas automáticas con ventana |
| 3.5 | Fuente de decisión por asiento (humano, IA, guion) y pausa de la mesa | completada | El guion se aplica y una acción ilegal del guion se informa; pausar no cambia el resultado de una misma semilla (`test_35_*`) |

**Criterio de fase cumplido:** un partido completo se juega de principio a fin sin errores de estado, acciones ilegales ni bloqueos. Resultados en [RESULTADOS_PRUEBAS.md](RESULTADOS_PRUEBAS.md); capturas en `docs/capturas/`.

**Provisional en esta fase:** las cartas (rectángulos con texto), los colores, la disposición y la IA básica (`ia/ia_basica.gd`), que juega de forma legal pero sin estrategia ni personalidad. Todo se reemplaza en las Fases 4 a 6.

## Fase 4: IA, señas y comportamiento

| # | Tarea | Estado | Verificación |
|---|-------|--------|--------------|
| 4.1 | IA por muestreo con información legítima (`ia/muestreador.gd`, `ia/simulador.gd`, `ia/ia_muestreo.gd`) | completada | Le gana a la IA aleatoria 862 de 1000 partidos (86,2 %) con repartos espejados (`herramientas/medir_ia.sh`). Decide igual si cambian las cartas ocultas (R-65 para la IA). Decisiones en 6 ms de media y 45 ms como máximo |
| 4.2 | Personalidades (Tito, Marta, Cacho, Rosario, Washa) y tres dificultades (`ia/perfil_ia.gd`) | completada | En 30 partidos, Tito y Cacho gritan más truco y farolean más que Marta y Rosario (`test_42_*`) |
| 4.3 | Perfil de señas en datos (`datos/senas/clasico.json`) y validación | completada | R-68: sin conflictos con ninguna de las 40 muestras; cada seña significa lo documentado; el alcahuete usa la seña de la pieza que reemplaza |
| 4.4 | Emisión, observación e interpretación de señas | completada | El compañero ve siempre; un rival, según su atención y el disimulo de quien la hace (frecuencia medida); una seña no vista no cambia nada de lo que decide un rival (`test_44_*`) |
| 4.5 | Señas de la persona (menú «Hacer una seña…») | completada | Con «tengo el 2 de la muestra» el compañero estima 1,00 y grita truco; con «nada que valga» estima 0,13 y juega sin gritar (`test_45_*`) |
| 4.6 | Asistente de sugerencias (`ia/asistente.gd`) | completada | T-10: misma sugerencia con la misma información pública y distintas cartas ocultas |

**Criterio de fase cumplido:** los rivales completan partidas, toman siempre decisiones legales y no usan información oculta. Resultados en [RESULTADOS_PRUEBAS.md](RESULTADOS_PRUEBAS.md); capturas en `docs/capturas/`.

**Pendiente, para una iteración posterior de la IA:**

- **Fuerza:** contra la IA básica de la Fase 3 gana el 64,5 %. Es una IA de nivel intermedio: pierde puntos al querer retrucos de rivales fuertes y la política de los simulacros es simple.
- **Elección de dificultad:** la dificultad se elige en el código; el menú para elegirla es de la Fase 6.
- **Observación de señas:** por ahora es probabilística para todos. La mecánica de mirada en pantalla, en la que la persona tiene que estar atenta a los retratos, llega con los retratos de la Fase 5 (D-24).

## Fase 5: identidad visual, animaciones y audio

Dependencia: D-13 aprobada.

| # | Tarea | Criterio de aceptación |
|---|-------|------------------------|
| 5.1 | Generador de pictogramas, marcos e insignias (`herramientas/`) | Los PNG se generan con un comando reproducible |
| 5.2 | Composición de las 40 caras al iniciar el juego | Las 40 cartas se leen bien a 1280×720 (revisión visual registrada) |
| 5.3 | Retratos por capas de los 5 personajes | Las 12 señas se distinguen a tamaño de juego |
| 5.4 | Mesa, ambiente y tanteador de fósforos | Revisión en las 5 resoluciones previstas |
| 5.5 | Animaciones con curvas y velocidad configurable | Al acelerar o desactivar las animaciones, el estado no cambia |
| 5.6 | Efectos de sonido y ambiente grabados y normalizados | Cuatro grupos de audio con volumen independiente |
| 5.7 | Música y voces (externas) | Bloqueada hasta tener fuente y licencia |

## Fase 6: menús, diálogos, tutorial y accesibilidad

| # | Tarea | Criterio de aceptación |
|---|-------|------------------------|
| 6.1 | Menú principal, configuración y créditos | Todas las opciones funcionan y se guardan |
| 6.2 | Diálogos contextuales | Ninguna línea revela información privada; se pueden acelerar u omitir |
| 6.3 | Infraestructura del aprendizaje: carga y validación de contenido, pasos, resaltado, narración y progreso | T-02, T-04, T-06, T-07 y T-13 pasan |
| 6.4 | Capítulo 1 completo, como primera versión vertical | T-01, T-03 y T-05 pasan para el capítulo 1; revisión del usuario |
| 6.5 | Capítulos 2 a 6 y lecciones LA-1 y LA-8 | T-01 a T-05 y T-13 pasan |
| 6.6 | Capítulos 7 a 13 y lecciones restantes (después de confirmar D-06) | T-01 a T-05, T-13 y T-14 pasan |
| 6.7 | Modo Practicar con generadores de situaciones | Cada concepto genera variantes válidas con semilla reproducible |
| 6.8 | Partida guiada con asistencia decreciente | T-08, T-09, T-10 y T-12 pasan |
| 6.9 | Consulta de reglas, señas y glosario, también durante las partidas | T-11 pasa |
| 6.10 | Accesibilidad: tamaño de texto, contraste, velocidad, teclado completo | Cada opción visible tiene efecto comprobado |

## Fase 7: pruebas finales y lanzamiento

| # | Tarea | Criterio de aceptación |
|---|-------|------------------------|
| 7.1 | Ejecutar todas las pruebas automáticas y la simulación masiva | Informe sin fallos |
| 7.2 | Pruebas manuales con un guion de recorridos, incluidas M-01 a M-03 del aprendizaje | Registro de resultados; M-01 cumple el criterio de TUTORIAL.md, 12 |
| 7.3 | Ejecutable de Windows con las plantillas de exportación oficiales de 4.7.2 e integración con Steam (GodotSteam) | El ejecutable funciona en un equipo sin Godot instalado e incluye los JSON de `datos/` |
| 7.4 | Instrucciones de instalación y compilación | README actualizado y verificado siguiendo los pasos |

## Riesgos

| Riesgo | Impacto | Mitigación |
|--------|---------|------------|
| Cambios entre versiones de Godot | Código que deja de funcionar | Versión fijada en 4.7.2; actualizar solo a propósito y con las pruebas pasando |
| Rendimiento de la IA en GDScript | Decisiones lentas en dificultad alta | Medido en 4.1: 6 ms de media y menos de 60 ms en difícil. Por ahora no hace falta C# |
| Tutorial y motor se contradicen | Se enseña una regla incorrecta | Las respuestas las calcula el motor; T-02 compara con los ejemplos del reglamento |
| Reglas de la flor discutidas entre mesas | Reglas que el jugador siente «mal» | Opciones de reglamento y confirmación del usuario (REGLAS, punto 13) |
| Señas poco legibles | Mecánica central sin valor | Retratos por capas; pruebas de legibilidad en la Fase 5 |
| IA demasiado débil o demasiado fuerte | Experiencia pobre | Métricas en simulación masiva; tres dificultades |
| Música y voces dependen de terceros | Retraso o recursos de licencia dudosa | Juego completo sin ellas; solo se incorporan con licencia verificada |
| Escenas o recursos de Godot editados como texto con errores | El proyecto no abre o pierde referencias | Validar cada cambio abriendo el proyecto en modo headless; preferir crear escenas por código o en el editor y revisar el diff |
