# Registro de decisiones

Cada decisión tiene un estado: **adoptada**, **propuesta** (espera revisión) o **reemplazada**.

| Id | Fecha | Decisión | Estado |
|----|-------|----------|--------|
| D-01 | 2026-10-25 | Motor GameMaker LTS 2026.0.0.23 con GML nativo | reemplazada por D-17 |
| D-02 | 2026-10-25 | Alcance 1.0: cuatro jugadores offline (persona + compañero IA contra dos IA) | adoptada |
| D-03 | 2026-10-25 | Reglamento base según REGLAS_TRUCO_URUGUAYO.md, con opciones configurables | propuesta |
| D-04 | 2026-10-25 | Partido a 30 (15 malas y 15 buenas), con opción a 40 | propuesta |
| D-05 | 2026-10-25 | La flor se juega siempre | propuesta |
| D-06 | 2026-10-25 | Puntuación de la flor según F8 (6 y 3), con colleras a 3 por flor | propuesta |
| D-07 | 2026-10-25 | Tantos calculados por el motor: no se puede mentir el tanto ni ocultar la flor | propuesta |
| D-08 | 2026-10-25 | Subir un canto implica querer el anterior («quiero retruco») | propuesta |
| D-09 | 2026-10-25 | Perfil de señas «clásico uruguayo» | propuesta |
| D-10 | 2026-10-25 | Proyecto del motor en `juego/`, documentación fuera | adoptada |
| D-11 | 2026-10-25 | Carta como entero 0–39; atributos de la muestra calculados, nunca guardados | adoptada |
| D-12 | 2026-10-25 | La IA recibe solo la vista filtrada del jugador | adoptada |
| D-13 | 2026-10-25 | Dirección artística B («Taller constructivo») | propuesta |
| D-14 | 2026-10-25 | Repositorio Git propio dentro de la carpeta del proyecto | adoptada |
| D-15 | 2026-10-25 | La persona decide siempre las respuestas de su pareja | propuesta |
| D-16 | 2026-10-25 | Ir al mazo lo decide el jugador de turno por toda la pareja | propuesta |
| D-17 | 2026-10-25 | Motor: Godot 4.7.2 (versión estándar) con GDScript, en lugar de GameMaker | adoptada |
| TD-01 a TD-10 | 2026-10-25 | Decisiones del sistema de aprendizaje (TUTORIAL.md, 13) | propuesta |
| D-18 | 2026-10-25 | La comparación de tantos es automática (sin acciones de declarar) | adoptada |
| D-19 | 2026-10-25 | Las apuestas de flor las responde quien tiene flor | adoptada |
| D-20 | 2026-10-25 | La flor se anota al cerrar la primera baza o al terminar la mano | adoptada |
| D-21 | 2026-10-25 | GUT 9.7.1 incluido en el repositorio (`juego/addons/gut/`) | adoptada |

## Detalle

**D-01. GameMaker LTS 2026.** Es la versión instalada y la que el equipo ya usó en proyectos anteriores. YoYo Games anunció que LTS 2026 es la línea principal de desarrollo hasta 2028, así que es una base estable. No se usa el runtime nuevo (GMRT), que todavía está en beta. *Reemplazada:* el usuario aclaró que GameMaker no era obligatorio. Se evaluaron alternativas y se aprobó Godot (D-17).

**D-02. Cuatro jugadores.** Es el formato en el que las señas, el compañero y el pie tienen sentido. Las partidas de dos y de seis quedan como ampliación, y el motor no las impide: la cantidad de jugadores es un parámetro.

**D-03. Reglamento base.** No existe un reglamento oficial único (ver REGLAS, punto 1). Se toma lo que coincide entre fuentes y se registran las variantes. Las opciones que difieren entre mesas se expresan como campos de `scr_reglamento`, no como código distinto.

**D-04. A 30.** Es la extensión más citada para la partida común (F2, F5, F7). La variante a 40 aparece en campeonatos y en F3 y F6, y se ofrece como opción.

**D-05. Flor obligatoria.** Las fuentes uruguayas específicas (F4, F5, F8) la tratan como parte del juego. La variante «sin flor» que menciona una fuente argentina no se incluye en 1.0.

**D-06. Flor contra flor.** Se adopta F8 por ser la fuente uruguaya más explícita y porque da un sistema coherente: rechazar una contraflor al resto equivale a achicarse. Alternativa: los valores argentinos (contraflor 6, contraflor al resto no querida 6 o 4). **Para confirmar con la mesa del usuario.**

**D-07. Sin tantos falsos.** En la mesa real se puede «cantar mal» un tanto y la penalidad llega al final, cuando se muestran las cartas (F7). En el juego, el motor conoce los tantos. Permitir mentir agregaría un sistema de penalidades sin aportar a la experiencia. En cambio, se conserva la elección estratégica real: decir «son buenas» para no revelar información. Igual con la flor: es obligatoria y el motor no deja jugar la primera carta sin declararla. En el modo de aprendizaje se canta sola.

**D-08. «Quiero retruco».** F2 exige decir «quiero» antes de subir, pero en la práctica uruguaya se responde directamente «¡retruco!» y eso implica aceptar (F5: los gritos se alternan). El resultado en puntos es el mismo. Se modela como una única respuesta para no agregar un paso de interfaz sin efecto.

**D-09. Señas clásicas.** Es el conjunto que repiten cuatro fuentes independientes (F1, F3, F6, F7). La seña del 5 tiene dos versiones (arrugar la nariz o subir el labio superior). Se elige la nariz, que tiene tres fuentes. El alcahuete hereda la seña de la pieza que reemplaza.

**D-10. Carpeta `juego/`.** El editor del motor administra su carpeta de proyecto (en Godot, todo lo que está bajo `project.godot` se importa) y no conviene mezclarla con documentación y scripts de Python.

**D-11. Carta como entero.** Es lo más simple que cumple con todo: comparable, serializable e inmutable. La jerarquía depende de la muestra, así que se calcula, y una única función (`Muestra.poder`) es la fuente de verdad.

**D-12. Vista filtrada.** Es la forma más directa de garantizar, y de probar, que la IA no hace trampa.

**D-13. Dirección B.** Ver la justificación completa en DIRECCION_ARTISTICA.md. Se espera la revisión del usuario antes de producir recursos.

**D-14. Repositorio propio.** Al inspeccionar el entorno se encontró que la carpeta de usuario completa (`C:\Users\lrtd2`) es un repositorio Git sin commits. Para no mezclar el proyecto con archivos personales se creó un repositorio independiente en la carpeta del proyecto, conectado al remoto de GitHub. El repositorio de la carpeta de usuario no se tocó.

**D-15. Respuestas de la pareja humana.** En la mesa, cualquiera de los dos compañeros puede responder un canto y suele hacerlo el pie. En el juego, cuando cantan a la pareja de la persona, responde siempre la persona, que puede guiarse por las señas de su compañero. Así no hay decisiones importantes que se tomen sin su control.

**D-17. Godot 4.7.2.** Para este juego, lo más costoso es la interfaz, el texto y el tutorial, no los gráficos. Godot trae resueltos esos sistemas, permite ejecutar las pruebas por línea de comandos sin cuenta, guarda todo el proyecto como texto editable y verificable, y es MIT, sin costo de licencia para vender. El techo visual de los tres motores evaluados es equivalente para un juego de cartas 2D. Sacrificios: se pierde la familiaridad con GameMaker y GDScript es más lento que C# para la IA. Análisis completo en EVALUACION_MOTOR.md. **Aprobada por el usuario el 2026-10-25.** Las descargas (editor 4.7.2 portable y GUT) se piden con autorización al empezar la Fase 2.

**D-18. Tantos automáticos.** Con tantos calculados por el motor (D-07), declarar o decir «son buenas» no es una decisión: cada uno habla solo si supera al mejor rival. Se resuelve dentro de `aplicar` y queda en el historial como eventos `tanto` y `son_buenas`, que la interfaz mostrará uno por uno. El resultado coincide siempre con «gana el mayor; en empate, el más cercano a la mano».

**D-19. Responde la flor quien la tiene.** Solo quien tiene flor puede apostar sobre la flor (F2). Es una excepción a D-15: si el compañero IA de la persona es el único de la pareja con flor, él responde la contraflor.

**D-20. Momento de anotar la flor.** Para comparar flores hay que esperar a que todos hayan tenido su turno de declarar, así que la flor se anota al cerrar la primera baza (o antes, si la mano termina). Si la mano termina antes de que un jugador llegue a su turno (por ejemplo, un truco no querido), su flor no llega a declararse y no cuenta. Queda registrado como comportamiento a confirmar junto con las demás reglas de la flor.

**D-21. GUT en el repositorio.** Las pruebas tienen que poder ejecutarse con solo clonar el repositorio y tener Godot. GUT es MIT y su licencia viaja en `addons/gut/LICENSE.md`.

**D-16. Ir al mazo por pareja.** F2 exige que los dos compañeros abandonen. Para simplificar, en la pareja rival decide el jugador de turno. En la pareja de la persona solo decide la persona, en coherencia con D-15: el compañero IA nunca se va al mazo por su cuenta. La opción individual de «pasar» (F6) queda como variante futura.
