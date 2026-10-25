# Cambios

## [Sin publicar]

### Fase 3: prototipo jugable (2026-10-25)

- Mesa jugable con cartas provisionales: mano propia con insignia de pieza, muestra con sus piezas y el alcahuete, cartas jugadas animadas, dorsos de los rivales, globos de cantos, tanteador con malas y buenas, bazas, valor de la mano y registro de la partida.
- Controlador de la mesa con fuente de decisión por asiento (persona, IA o guion), pausa y bloqueo de acciones mientras se anima.
- IA básica provisional que juega de forma legal y razonable.
- Pruebas de la interfaz (64 en total) y comprobación de clics reales con ventana.

### Fase 2: motor de reglas (2026-10-25)

- Proyecto de Godot 4.7.2 (`juego/`) con tipado estático obligatorio y GUT 9.7.1 para las pruebas.
- Motor de reglas: cartas, muestra, piezas y alcahuete; jerarquía; envido y flor con desgloses; mano con bazas, pardas, pila de cantos, flor obligatoria, flor contra flor, achique, contraflor al resto, truco y sus subidas, ir al mazo y final inmediato del partido; partido con reparto reproducible por semilla; vista filtrada por jugador.
- IA aleatoria para pruebas y simulación de 1000 partidos.
- 57 pruebas automáticas en verde (casos R-01 a R-67 del reglamento).

### Fase 0 y 1 (2026-10-25)

- Diagnóstico del entorno: GameMaker LTS 2026.0.0.23, Igor y herramientas disponibles.
- Reglamento base del truco uruguayo con fuentes, variantes, señas y 54 casos de prueba definidos.
- Visión del producto, tres direcciones artísticas con recomendación, elenco de personajes y voz de los diálogos.
- Arquitectura propuesta, registro de decisiones y hoja de ruta por fases.
- Diseño del sistema de aprendizaje: 13 capítulos, lecciones avanzadas, cuatro modos, capítulo 1 completo, progreso persistente y 14 pruebas específicas.
- Evaluación de motores (GameMaker, Godot, Unity y otros). Se aprobó Godot 4.7.2 con GDScript (D-17), y la arquitectura y el diseño del tutorial quedaron adaptados a Godot.
