# Arquitectura

Estado: **Godot 4.7.2 (D-17).** Implementado y probado: el motor de reglas (capas 1 a 5, Fase 2), el control de la mesa (capa 8) y una presentación provisional (capa 9, Fase 3), con una IA básica de prueba. Las capas 6 (IA definitiva), 7, 10 y 11 siguen siendo diseño.

Las clases y funciones de Godot citadas aquí salen de la documentación general del motor. **Antes de usar cada una se verifica** contra la referencia de la versión instalada, que se exporta con `godot --doctool` (tarea 2.1). Si algo no existe o cambió de nombre en 4.7.2, se corrige este documento.

## 1. Entorno

| Elemento | Estado al 2026-10-25 |
|----------|----------------------|
| Motor | **Godot 4.7.2 estable, versión estándar (GDScript)**, instalado el 2026-10-25 en `%USERPROFILE%\Herramientas\Godot\4.7.2\` (portable, fuera del repositorio). Descargado del GitHub oficial de godotengine y verificado con su SHA-512 publicado. `--version` informa `4.7.2.stable.official.ed1daf0bf`. |
| Pruebas | GUT 9.7.1 (licencia MIT, julio de 2026; la serie 9.7 es la adaptada a los cambios de tipado de Godot 4.7), copiado en `juego/addons/gut/` con su `LICENSE.md`. |
| Referencia de la API | Exportada con `--doctool` en `%USERPROFILE%\Herramientas\Godot\4.7.2\api\` (810 clases). Trae nombres y firmas, pero no descripciones. |
| Plantillas de exportación | Descarga aparte. Se instalan recién cuando haya que exportar (Fase 7 o antes, si se necesita probar un ejecutable). |
| Herramientas del equipo | Python 3.12.5 con Pillow 11.0.0, Node 24.16, ffmpeg y Git, verificados. |
| Git | Repositorio propio en la carpeta del proyecto, rama `main`, remoto `github.com/lrtd2021-oss/TrucoUruguayo`. **No hay `user.name` ni `user.email` configurados.** |
| GameMaker | Sigue instalado (LTS 2026.0.0.23), pero ya no se usa en este proyecto (D-01 reemplazada). |

## 2. Estructura del repositorio

```
TrucoUruguayo/
├── README.md  CHANGELOG.md
├── docs/                      documentación
│   └── bocetos/               imágenes de referencia, no son recursos del juego
├── herramientas/              scripts de Python para generar recursos (Fase 5)
└── juego/                     proyecto de Godot
    ├── project.godot
    ├── reglas/                lógica pura: cartas, muestra, tantos, mano, partido, vista
    ├── ia/                    decisión de la IA y perfiles
    ├── senas/                 perfiles y lógica de señas
    ├── mesa/                  escena de la mesa y su controlador
    ├── ui/                    escenas de interfaz y tema global
    ├── tutorial/              controlador y escenas del aprendizaje
    ├── sistema/               autoloads: configuración, progreso, audio
    ├── datos/                 JSON de señas, diálogos, tutorial y textos
    ├── recursos/  audio/  fuentes/
    ├── pruebas/               pruebas GUT (casos R-xx y T-xx)
    └── addons/gut/
```

La carpeta `juego/.godot/`, la caché de importación que genera el editor, no se versiona.

## 3. Capas y responsabilidades

La regla principal: **la lógica no dibuja y la presentación no decide.** Las capas 1 a 7 son scripts sin nodos (clases `RefCounted` o funciones estáticas), sin acceso al árbol de escena. Se pueden probar solas y en modo headless.

| # | Capa | Ubicación | Responsabilidad | Depende de |
|---|------|-----------|-----------------|------------|
| 1 | Cartas y muestra | `reglas/carta.gd`, `reglas/muestra.gd` | Identidad de cada carta, poder en el truco, valor de tanto, piezas y alcahuete | — |
| 2 | Tantos | `reglas/tantos.gd` | Envido, detección de flor, valor de flor y desgloses | 1 |
| 3 | Reglas de la mano | `reglas/reglamento.gd`, `reglas/mano.gd`, `reglas/accion.gd`, `reglas/escenario.gd` | Estado de la mano, acciones válidas, transiciones y eventos | 1, 2 |
| 4 | Partido | `reglas/partido.gd` | Tanteador, malas y buenas, falta, victoria, rotación del reparto | 3 |
| 5 | Información por jugador | `reglas/vista.gd` | Filtra el estado a lo que un jugador puede saber | 3, 4 |
| 6 | IA | `ia/ia_aleatoria.gd` (Fase 2, solo para pruebas); `ia/ia.gd`, `ia/perfil_ia.gd` (Fase 4) | Elige una acción a partir de una vista | 1, 2, 5 |
| 7 | Señas | `senas/senas.gd` | Perfiles, emisión, observación e interpretación | 1, 5 |
| 8 | Control de la mesa | `mesa/mesa.tscn` + `mesa/controlador_mesa.gd` | Pide acciones (a la persona, a la IA o a un guion), las aplica y emite los eventos como señales | 3–7 |
| 9 | Presentación | `mesa/`, `ui/` (escenas `Carta`, `Retrato`, `Globo`, `Tanteador`…) | Anima los eventos, dibuja la mesa y la interfaz y captura la entrada | 8 |
| 10 | Audio y diálogos | `sistema/audio.gd`, `mesa/dialogos.gd` | Reproduce sonidos y elige líneas según los eventos | 8 |
| 11 | Configuración y progreso | `sistema/config.gd`, `sistema/progreso.gd` (autoloads) | Opciones del usuario y progreso del aprendizaje, guardados en `user://` | — |

**Autoloads:** solo `Config`, `Progreso` y `Audio`, porque son de verdad globales. El estado del partido **no** es global: vive en el controlador de la mesa.

## 4. Modelo de cartas

- **Identidad:** un `int` de 0 a 39, `palo * 10 + índice`, con los palos en el orden oros, copas, espadas y bastos, y los índices 0 a 9 para los números 1, 2, 3, 4, 5, 6, 7, 10, 11 y 12. Al ser un entero no hay referencias compartidas, se compara con `==`, se serializa sin trabajo y no se puede «modificar» una carta por accidente.
- **Palo y número:** `Carta.palo(c)` y `Carta.numero(c)` (funciones estáticas de la clase `Carta`).
- **Atributos que dependen de la muestra:** nunca se guardan en la carta. Se calculan con un contexto de muestra:
  - `Muestra.new(carta_muestra)`, con `palo`, `alcahuete_activo` y `pieza_reemplazada`.
  - `muestra.orden_pieza(c)`: 0 si no es pieza, o de 1 a 5 (el alcahuete activo devuelve el orden de la pieza que reemplaza).
  - `muestra.poder(c)`: un `int` comparable (mayor gana). **Es la única fuente de la jerarquía del punto 4 del reglamento.**
  - `muestra.valor_tanto(c)`: el valor de la carta para envido y flor.
- **Reglas especiales:** el alcahuete se resuelve dentro de `orden_pieza`, de modo que ninguna otra función necesita conocerlo.
- **Tipado estático en todo el código.** `project.godot` trata como error las declaraciones sin tipo y la inferencia desde `Variant` (`debug/gdscript/warnings/untyped_declaration` y `inference_on_variant` en 2). Comprobado: un script con una variable sin tipo no carga. La carpeta `addons/` está excluida por defecto (`directory_rules`).

## 5. Estado de la mano

La clase `Mano` (`reglas/mano.gd`) guarda el estado de una mano con campos tipados y **solo cambia con `aplicar(accion)`**. El resto de sus métodos son consultas. `a_diccionario()` devuelve una copia del estado para compararlo en las pruebas. `Escenario` (`reglas/escenario.gd`) arma manos con cartas elegidas y aplica acciones previas con `aplicar`, de modo que no se puede construir un escenario ilegal.

### 5.1 Fases

| Fase | Quién actúa (`actor()`) | Acciones posibles |
|------|-------------------------|-------------------|
| `TURNO` | el jugador de turno | jugar carta; cantar envido, real envido o falta (1.ª baza, antes de jugar la propia carta, sin flor declarada ni truco querido); gritar truco o subir (si su pareja tiene la palabra); ir al mazo |
| `CANTO` | quien responde el canto de arriba de la pila | quiero; no quiero; subir según la escalera del canto; «el envido está primero» frente al primer truco; frente a una flor, contraflor al resto |
| `TERMINADA` | nadie | — |

Transiciones automáticas dentro de `aplicar`, que quedan registradas como eventos:

- **Cierre de baza:** ganador o parda, y si la mano terminó.
- **Comparación de tantos:** se declara desde la mano, cada uno habla solo si supera al mejor rival y si no dice «son buenas». No hay decisión que tomar, así que no es una fase (D-18).
- **Anotación:** flor, envido y truco, comprobando la victoria después de cada una.

**Flor obligatoria.** Antes de cualquier otra acción, `actor()` exige declarar la flor a quien la tiene y todavía no jugó en la primera baza:

- cuando es su turno;
- cuando le toca responder;
- o, si hay un envido cantado, aunque no sea su turno (la flor anula el envido).

**Pila de cantos.** Los cantos pendientes forman una pila. Se resuelve primero el canto de arriba y después se retoma el de abajo (por ejemplo, un truco suspendido por un envido o una flor). Así se implementan «el envido está primero» y «la flor está primero» sin casos especiales sueltos.

**Quién responde** (`decisor`):

- Por defecto, el siguiente al que cantó.
- Se puede fijar un asiento por pareja; la persona responde por la suya (D-15).
- Las apuestas de flor las responde siempre quien tiene flor (D-19).

### 5.2 Acciones y eventos

- Una **acción** es una instancia de `Accion` con `tipo`, `jugador` y, para jugar una carta, `carta`. `mano.acciones_validas(jugador)` devuelve la lista completa de acciones válidas, vacía si no le toca.
- `mano.aplicar(accion)` comprueba que la acción esté en esa lista. Si no está, **no cambia nada** y devuelve un error con su motivo. Si está, aplica la transición y devuelve los **eventos** producidos: carta jugada, canto, respuesta, baza ganada, parda, puntos anotados, fin de mano…
- La interfaz construye sus botones **a partir de la lista de acciones válidas**. Por eso no puede ofrecer algo ilegal.
- **Doble acción:** si un clic llega dos veces, la segunda acción ya no está en la lista de acciones válidas del nuevo estado y se rechaza (prueba R-64).
- **Reproducibilidad:**
  - Cada reparto usa su propio `RandomNumberGenerator` con semilla y una mezcla Fisher-Yates con `randi_range`. **No se usa `Array.shuffle()`**, que depende del generador global. Una misma semilla da siempre la misma mano (R-66).
  - Cada mano guarda la lista de acciones aplicadas. Repetir esas acciones desde el estado inicial reproduce la partida, lo que sirve para depurar y para el retroceso del tutorial.
- **Partido:** `Partido` (`reglas/partido.gd`) reparte con su semilla de a una carta en sentido antihorario, desde la mano, y da vuelta la carta siguiente como muestra. También rota el reparto y lleva el tanteador entre manos.

## 6. Información e IA

### 6.1 Vista de jugador

`Vista.para(mano, jugador)` construye un objeto **nuevo** (`Vista`) que contiene solamente:

- las cartas propias;
- la muestra;
- las cartas jugadas y quién las jugó;
- los cantos, las respuestas y los tantos declarados;
- las cartas mostradas al final de manos anteriores;
- el tanteador;
- las señas que **ese jugador observó** (no todas las que se hicieron).

**La IA solo recibe la vista**, nunca el estado completo. La firma de `IA.decidir(vista, perfil, rng)` no permite acceder a las cartas ocultas, y una prueba recorre la vista para comprobar que no contiene ninguna carta oculta de otro jugador (R-65).

### 6.2 Cómo decide la IA

1. **Legalidad primero:** solo elige entre las acciones válidas, que vienen incluidas en la vista.
2. **Valoración por muestreo:** reparte al azar las cartas desconocidas entre los otros jugadores, respetando lo que se sabe (cartas vistas, tantos declarados, flor declarada o no, señas observadas), y estima la probabilidad de ganar cada baza, el envido o la flor. Esto usa solo información legítima.
3. **Perfil de personalidad:** umbrales para querer y subir, frecuencia de farol, disimulo de señas, atención a las señas ajenas y memoria de cartas jugadas.
4. **Dificultad:** cambia la cantidad de muestras, la memoria, la precisión al leer señas y lo «humano» de los errores. **Nunca cambia la información disponible.**
5. **Fluidez:** el muestreo puede correr en un hilo del `WorkerThreadPool` para no trabar la interfaz. Se activa solo si las mediciones de la Fase 4 lo justifican. Si GDScript no alcanzara el presupuesto de tiempo en dificultad alta, solo el núcleo del muestreo pasaría a C# o a una extensión, sin tocar el resto.

Los cálculos de tantos y de jerarquía de la IA llaman a las mismas funciones de las capas 1 y 2. La IA no tiene su propia versión del envido.

## 7. Señas

- **Perfil de señas:** archivo JSON en `datos/senas/` que asocia cada seña con un conjunto de cartas descripto por reglas (por ejemplo, «pieza de orden 1», «1E o 1B», «cualquier 3») y con su animación en el retrato (capas y duración). El perfil inicial es «clásico uruguayo» (reglamento, punto 11.1). Al cargarlo se valida que no haya dos señas que se superpongan.
- **Emisión:** un jugador puede hacer una seña en su turno, o al comienzo de la mano mientras todos miran sus cartas. La seña genera un evento que el retrato del emisor anima. Cada retrato indica además hacia dónde mira su personaje.
- **Observación:** cada jugador que **está mirando** al emisor en ese momento ve la seña. El compañero la ve casi siempre. Un rival la ve según su atención, el disimulo del emisor y si estaba mirando. La persona humana ve las señas que se reproducen en pantalla, **incluidas las de los rivales entre sí**, si está atenta. Es la misma regla para todos.
- **Interpretación:** la IA traduce cada seña observada a un conjunto de cartas posibles y la usa como restricción en el muestreo. Puede equivocarse si su perfil de dificultad lo indica.
- **Sin canal secreto:** el compañero IA solo informa a la persona con señas visibles en pantalla, sujetas a las mismas reglas de observación que cualquier otra. El diálogo nunca contiene información privada.

## 8. Presentación, entrada, audio y configuración

- **Cola de eventos:** el controlador de la mesa aplica acciones y emite cada evento con una señal. El presentador los anima **de a uno**: espera el final de cada `Tween` con `await` antes de seguir. Mientras haya animaciones pendientes, la entrada de la persona queda bloqueada, salvo acelerar u omitir. La presentación nunca cambia el estado de la mano.
- **Turnos de la IA:** cuando le toca a un jugador IA, el controlador le pide la acción después de una pausa de «pensar» (un `Timer` o `get_tree().create_timer`), ajustada a la velocidad elegida.
- **Pausa:** pausar la mesa detiene los temporizadores, la cola de animaciones y la entrada. Usa el modo de proceso de los nodos para que la Consulta y el menú de pausa sigan funcionando.
- **Resolución:**
  - Base 1920×1080 con estiramiento `canvas_items` y aspecto `expand`: la mesa se adapta a otras proporciones sin deformarse, y la interfaz se reacomoda con anclajes y contenedores.
  - Se probará a 1280×720, 1366×768, 1920×1080, 2560×1440 y 1920×1200.
  - Renderizador **Compatibilidad**, para la mayor compatibilidad de hardware en un juego 2D. Se puede cambiar más adelante sin tocar el código del juego.
- **Interfaz:**
  - Nodos `Control`, contenedores y un `Theme` global (`ui/tema.tres`) con la tipografía, los colores y los estilos de la dirección artística.
  - El **tamaño de texto** configurable se aplica escalando los tamaños de fuente del tema.
  - Globos y tutorial usan `RichTextLabel`, para resaltar términos dentro del texto.
- **Entrada:**
  - Acciones definidas en el mapa de entrada del proyecto (jugar carta 1, 2 y 3, cada canto, acelerar, consulta…), con ratón y teclado completos.
  - La navegación con teclado usa el sistema de foco de los `Control`.
- **Audio:** buses Música, Ambiente, Efectos y Voces, con un volumen por bus desde la configuración.
- **Configuración:** `ConfigFile` en `user://config.cfg`, versionada. Al cargar, se completan con valores por defecto las claves que falten, y un archivo dañado no impide arrancar.
- **Textos:** los textos de la interfaz pasan por el sistema de traducción de Godot (`tr()`), con un archivo CSV en `datos/textos/`, aunque al principio solo haya español de Uruguay. Los textos del tutorial van dentro de su propio contenido (TD-04).
- **Exportación:** los JSON de `datos/` no son recursos de Godot, así que el preset de exportación debe incluirlos con el filtro de archivos no recurso (`*.json`). Hay una prueba de humo del ejecutable exportado en la Fase 7.

## 9. Pruebas automatizadas

- **GUT**, con pruebas en `pruebas/` (`test_*.gd`). Cada caso lleva el identificador del reglamento (R-xx) o del tutorial (T-xx).
- **Ejecución por línea de comandos, sin ventana:**
  `herramientas/pruebas.sh`, que ejecuta `godot --headless --path juego -s addons/gut/gut_cmdln.gd -gexit` con la configuración de `juego/.gutconfig.json`.
  Comprobado en la tarea 2.1: devuelve 0 si todo pasa y 1 si alguna prueba falla. Acepta opciones de GUT, por ejemplo `-gselect=test_cantos`.
- **Simulación masiva:** una prueba juega 1000 partidos con decisiones al azar (`IaAleatoria`) y comprueba que terminan, que no hubo acciones rechazadas, que las cartas se conservan y que los puntos suman bien (R-67). Además exige haber pasado al menos una vez por cada situación importante (cada canto y respuesta, pardas, anulación del envido, final por tantos), para que «sin bloqueos» signifique algo.
- **Limitación conocida:** en modo headless, `--check-only` muestra los errores (incluidas las declaraciones sin tipo) pero no las advertencias comunes, como una variable sin usar. Esas solo se ven en el editor.
- **Verificación visual:** la mesa acepta argumentos propios después de `--`, leídos con `OS.get_cmdline_user_args()`: `--semilla`, `--auto`, `--velocidad`, `--resolucion`, `--captura` y `--capturar-tras`. Guarda una captura PNG de la ventana y cierra el juego. Requiere ventana: no funciona en headless.
- **Clics reales de punta a punta:** `herramientas/probar_clics.sh` abre el juego con `--probar-clics`, envía clics de ratón con `Input.parse_input_event` sobre una carta y un botón, y sale con 0 si llegaron al motor. Hace falta porque en headless la ventana mide 64×64 y el panel de GUT queda encima de todo, así que ahí los clics sintéticos no son representativos. Por eso las pruebas GUT de la interfaz emiten las señales directamente.
- **Verificación de la API:** la referencia de clases de 4.7.2, exportada con `godot --doctool`, se guarda fuera del repositorio y se consulta antes de usar una clase o función nueva.
- **Regla de honestidad:** una prueba solo cuenta como pasada si se ejecutó en Godot y su resultado quedó registrado.

## 10. Lo que se evita a propósito

- Estado del juego en autoloads o variables globales. Solo la configuración, el progreso y el audio son globales.
- Lógica de reglas en nodos de presentación o en `_process`.
- Herencia profunda de escenas o patrones sin necesidad.
- Complementos o extensiones fuera de GUT y, al final, GodotSteam. Ninguno más está previsto para la versión 1.0.
- Red. La arquitectura no la impide (acciones serializables y vista por jugador son justo lo que haría falta), pero no se programa nada de red.
