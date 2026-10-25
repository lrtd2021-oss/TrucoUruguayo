# Evaluación del motor

Estado: **recomendación aprobada el 2026-10-25 (D-17): Godot 4.7.2 con GDScript.** ARQUITECTURA.md y TUTORIAL.md ya están adaptados. Este documento queda como registro de la evaluación.

## 1. Qué exige este juego

Antes de comparar motores conviene ser preciso sobre lo que este proyecto necesita de verdad, porque no es un juego de acción:

1. **Mucha interfaz y mucho texto.** Menús, opciones, tutorial por capítulos, consulta del reglamento con tablas, glosario, globos de diálogo, tanteador, botones de cantos, navegación con teclado, tamaño de texto configurable y, más adelante, traducciones. Es la parte más grande del trabajo de presentación.
2. **2D con animación de calidad:** cartas que se deslizan, giran y se asientan; retratos por capas con señas; transiciones; algún shader (brillo, papel, luz cálida).
3. **Lógica pura y comprobable:** reglas, pila de cantos, IA por muestreo y simulaciones de miles de partidas.
4. **Pruebas automáticas** que se puedan ejecutar sin intervención manual, porque el proyecto exige no afirmar nada que no se haya verificado.
5. **Publicación comercial en Steam para Windows.**
6. **Un equipo muy chico:** una persona, apoyada en herramientas de automatización.

No necesita 3D, física, iluminación avanzada ni un rendimiento extremo. Por lo tanto, **el techo gráfico teórico de un motor no es un criterio decisivo**: la calidad visual de un juego de cartas depende del arte, la animación y la interfaz, y cualquiera de los motores evaluados alcanza lo que pide la dirección artística.

## 2. Alternativas evaluadas

- **GameMaker LTS 2026.0** (propuesta inicial). Instalado y conocido por el equipo.
- **Godot 4.7** (estable 4.7.2, del 18 de agosto de 2026), con GDScript.
- **Unity 6**, con C#.
- Consideradas y descartadas al principio:
  - **Unreal:** orientado a 3D; desproporcionado para un juego 2D de cartas.
  - **LÖVE:** framework en Lua, con el que se hizo *Balatro*. Probó que se puede hacer un juego de cartas excelente, pero no trae editor ni sistema de interfaz, y toda la interfaz de este proyecto habría que programarla desde cero.
  - **Tecnologías web empaquetadas** (Phaser o PixiJS con Electron): muy buenas para interfaz, pero con integración con Steam más frágil (overlay, rendimiento del empaquetado), y se apartan de la intención original de usar un motor de videojuegos.
  - **Defold:** gratuito y sólido en 2D, pero con una comunidad y una documentación más chicas, lo que reduce la ayuda disponible.

## 3. Comparación por criterio

| # | Criterio | GameMaker LTS 2026 | Godot 4.7 | Unity 6 |
|---|----------|--------------------|-----------|---------|
| 1 | Potencial de identidad visual | Alto. Sprites, shaders, partículas, secuencias y curvas de animación | Alto. Nodos 2D, shaders, partículas, `Tween` y `AnimationPlayer` | Alto. El más completo, pero su ventaja está en 3D y en efectos que este juego no necesita |
| 2 | Animación y presentación de cartas | Buena. Curvas de animación y secuencias; la composición en capas se programa a mano | Muy buena. `Tween` encadenables y `AnimationPlayer` para animar cualquier propiedad, también los retratos por capas | Muy buena. Animator y librerías de tweening de terceros |
| 3 | Interfaz pulida y adaptable | **Débil para este juego.** UI Layers con flexbox es nuevo (2024.13, editor en LTS 2026). No trae controles listos (desplazamiento, deslizadores, campos de texto) ni texto enriquecido nativo, y el foco de teclado es manual | **Fuerte.** Controles, contenedores, anclajes, temas globales, navegación de foco con teclado o mando, `RichTextLabel` con BBCode, escalado por resolución y traducciones integradas | Fuerte. uGUI o UI Toolkit con TextMeshPro. Más pesado de configurar |
| 4 | Juego 2D de cartas con diálogos, señas y tutorial | Adecuado en lo jugable, costoso en lo interactivo y textual | Muy adecuado. Escenas reutilizables para carta, retrato, globo y panel | Adecuado, aunque con más estructura de la necesaria |
| 5 | Reglas e IA | GML con structs y funciones: suficiente | GDScript con tipado estático y clases: suficiente. Es más lento que C# para simulaciones masivas, mitigable (sección 5) | C#: el mejor lenguaje de los tres para lógica grande y rápida |
| 6 | Integración de recursos | Buena para sprites. Los recursos se crean desde el IDE; editar los `.yy` a mano es arriesgado | Buena. Importa PNG, SVG, fuentes y audio arrastrándolos a la carpeta; los recursos son archivos de texto | Muy buena. Pipeline de recursos muy maduro |
| 7 | Edición como texto, automatización y documentación | Media. GML tiene menos ejemplos públicos. El proyecto lo administra el IDE (`.yy`): los scripts se pueden escribir fuera del IDE, pero rooms y objetos no con seguridad. Manual oficial bueno | **Alta.** Escenas, recursos y código son texto legible y comparable en Git; se pueden crear y revisar escenas completas fuera del editor, no solo scripts. `godot --doctool` exporta la referencia exacta de la versión instalada para verificar cada API. Manual oficial muy completo | Media. C# excelente, pero escenas y prefabs usan YAML con GUID, frágil de editar fuera del editor |
| 8 | Aprendizaje y viabilidad con un equipo chico | Lo conoce el equipo (proyectos anteriores) | Curva moderada. GDScript se parece a Python, que el equipo usa, y Godot ya se instaló aquí en 2025 | La curva más alta, con un editor pesado y muchas piezas para un juego chico |
| 9 | Depuración y pruebas | Depurador del IDE. Sin marco de pruebas. **Igor exige iniciar sesión** y no hay sesión en este equipo. Las pruebas se pueden ejecutar, pero no automatizar sin pasos manuales | Depurador, profiler, árbol de escena remoto. **Modo `--headless`**: pruebas por línea de comandos con GUT (MIT), sin cuenta ni ventana, con resultado y código de salida legibles por cualquier script | Test Framework oficial y modo batch. El editor necesita licencia activada con cuenta |
| 10 | Windows y Steam | Exportación nativa. Extensión oficial de Steamworks | Exportación nativa (plantillas aparte). GodotSteam, MIT y activo (versión para 4.7.2 de agosto de 2026). Precedente: *Slay the Spire 2*, juego de cartas, migró de Unity a Godot | Exportación nativa. Steamworks.NET o Facepunch. Muchísimos precedentes |
| 11 | Licencia y costos | Gratis para uso no comercial. **Vender exige Professional: 99,99 USD, pago único** (con precio regional). Consolas: suscripción Enterprise | **MIT. Gratis, sin regalías ni cuenta.** Consolas, solo a través de terceros (con costo) | Gratis hasta 200.000 USD de ingresos y financiación; pantalla de inicio opcional en Unity 6. Por encima, Pro (unos 2.310 USD por puesto y año). Antecedente de cambios de licencia (tarifa por instalación de 2023, retirada) |
| 12 | Ampliación futura | Móvil sí. Red con funciones de bajo nivel. Consolas con suscripción | Móvil sí. Red de alto nivel integrada. Herramientas propias como complementos del editor | El más amplio: móvil, consolas y servicios en línea |

Fuentes de los datos verificados: sección 8.

## 4. Capacidad teórica frente a resultado alcanzable

- **Unity** tiene el mayor techo técnico, pero sus ventajas (3D, servicios, consolas, Asset Store) no mejoran este juego. Su costo de configuración, su editor pesado y sus escenas difíciles de editar como texto restan velocidad a un equipo de una persona. El riesgo de licencia es bajo hoy, pero existe.
- **GameMaker** es excelente para juegos de acción 2D y el equipo lo conoce. Para este juego, sin embargo, lo más costoso es justamente lo que trae menos resuelto: interfaz, texto enriquecido, foco de teclado, escalado de texto y traducciones. Habría que escribir y mantener un pequeño sistema de interfaz propio. Además, sin sesión iniciada no se puede compilar ni ejecutar el proyecto por línea de comandos, así que buena parte de la verificación dependería de pasos manuales.
- **Godot** no gana por gráficos: gana porque **trae resuelto lo que más pesa en este proyecto** (interfaz, texto y adaptación a resoluciones), porque **se puede probar y ejecutar entero por línea de comandos** y porque **todo el proyecto es texto**, lo que permite construir y verificar con herramientas automáticas también escenas e interfaz, no solo lógica.

## 5. Recomendación: Godot 4.7 con GDScript

**Por qué es la más apropiada para este proyecto:**

1. La interfaz, el tutorial, la consulta y la accesibilidad (tamaño de texto, navegación con teclado, contraste por temas) se construyen con componentes del motor en lugar de un sistema propio. Es la mayor reducción de trabajo y de riesgo de todo el proyecto.
2. Las pruebas se ejecutan con un comando y sin intervención. Eso cumple el principio de no afirmar nada sin verificarlo, y permite simular miles de partidas en cada cambio.
3. Todo el proyecto (escenas, temas, recursos y código) es texto que se revisa en Git y que se puede crear y verificar con scripts. Con GameMaker, rooms y objetos dependerían del IDE.
4. MIT, sin costo, sin cuenta y sin regalías. No hay que comprar licencia antes de vender.
5. Hay un precedente directo y reciente de un juego de cartas comercial de primer nivel (*Slay the Spire 2*).

**Ventajas frente a GameMaker:** interfaz y texto integrados, pruebas automáticas reales, proyecto totalmente editable como texto, sin costo de licencia, API verificable por versión con `--doctool`, traducciones integradas y red de alto nivel si algún día hay multijugador.

**Sacrificios:**

- Se pierde la familiaridad del equipo con GameMaker y con su IDE.
- Hay que aprender el modelo de nodos y escenas de Godot.
- Para simulaciones masivas, GDScript es más lento que C#.

**¿Mejor resultado visual y jugable?**

- En lo visual puro, **no de forma significativa**: el resultado depende del arte y la animación, y los tres llegan.
- En lo jugable y en la experiencia, **sí**: una interfaz más pulida y accesible, un tutorial más rico (texto enriquecido, resaltados, paneles adaptables) y menos errores gracias a las pruebas automáticas. Para este juego, eso es lo que más se nota.

**Dificultades nuevas y cómo se mitigan:**

| Dificultad | Mitigación |
|------------|------------|
| Godot cambia entre versiones menores | Fijar 4.7.2 en el proyecto y actualizar solo a propósito, con las pruebas como red |
| Rendimiento de la IA por muestreo en GDScript | Tipado estático, cartas como enteros y presupuesto de muestras por dificultad. Si no alcanza, solo el núcleo del muestreo pasa a C# o a una extensión, sin tocar el resto |
| Steam depende de GodotSteam (tercero) | Es MIT y activo. La integración con Steam es una capa chica y aislada que se hace al final |
| Descargas nuevas | El editor de Godot (portable), las plantillas de exportación y el complemento GUT. **Las descargo solo con tu aprobación** |
| Si el proyecto tiene un requisito académico de usar GameMaker | En ese caso la recomendación cambia: ver la sección 7 |

**Versión de Godot:** la estándar (GDScript), no la .NET. La .NET exige instalar el SDK, y el beneficio de C# no compensa la complejidad adicional mientras GDScript alcance.

## 6. Efectos en el proyecto

**Arquitectura.** Las capas de ARQUITECTURA.md se mantienen idénticas; cambia la implementación:

| GameMaker (borrador anterior) | Godot |
|-----------------------------|-------|
| `scr_cartas`, `scr_muestra`, `scr_tantos`, `scr_mano`, `scr_partido`, `scr_vista` | Scripts `class_name` con funciones estáticas o `RefCounted` en `reglas/`, sin nodos (lógica pura) |
| `scr_ia`, `scr_senas` | `ia/` y `senas/`, también sin nodos |
| `obj_mesa` | Escena `Mesa.tscn`, con un nodo controlador que recibe acciones y emite señales con los eventos |
| `obj_presentador`, `obj_ui_*` | Escenas `Carta`, `Retrato`, `Globo` y `Tanteador`, animadas con `Tween`; interfaz con `Control` y un `Theme` global |
| Configuración con `json_stringify` en `game_save_id` | `ConfigFile` o JSON en `user://` |
| Audio con grupos y `audio_group_set_gain` | Buses de audio (música, ambiente, efectos, voces) con volumen por bus |
| Configuración «Pruebas» y macro | GUT con `godot --headless`; las pruebas viven en `pruebas/` |
| Verificación con `GmlSpec.xml` | Verificación con la referencia exportada por `godot --doctool` de 4.7.2 |

**Tutorial.** El diseño de TUTORIAL.md no cambia. Los contenidos siguen en JSON, el validador y las respuestas calculadas por el motor se mantienen, y los nombres `scr_*` y `obj_*` pasan a sus equivalentes en Godot. Mejoras concretas: `RichTextLabel` para resaltar términos dentro del globo, contenedores que reubican el panel según la resolución, y navegación con teclado sin código propio.

**Flujo de trabajo:**

- El proyecto se abre en el editor de Godot.
- Las pruebas se ejecutan con un comando, que devuelve el resultado y un código de salida.
- Para verificar la parte visual, el juego puede lanzarse con un argumento que guarda capturas para revisarlas.

**Publicación comercial:**

- Exportación a Windows con las plantillas oficiales y Steamworks mediante GodotSteam.
- Sin costo de licencia del motor. Sí siguen existiendo el pago de la cuota de Steam Direct y los demás requisitos de Valve.

## 7. Si se mantiene GameMaker

Si preferís GameMaker, o si hay un requisito académico, el proyecto es viable igual. Hay que asumir:

- Un sistema de interfaz propio (o la librería comunitaria Scribble para el texto, que habría que evaluar).
- Iniciar sesión en el IDE para que las pruebas puedan ejecutarse con Igor.
- La compra de la licencia Professional antes de vender.

La arquitectura actual ya está escrita para ese caso.

## 8. Plan para empezar con Godot (si se aprueba)

1. **Herramientas** (descargas con tu aprobación, desde godotengine.org y el repositorio oficial de GUT):
   - Godot 4.7.2 estándar para Windows (zip portable), en una carpeta de herramientas fuera del repositorio.
   - Las plantillas de exportación recién cuando haga falta exportar.
   - GUT, compatible con 4.7, copiado en `juego/addons/gut/` con su licencia.
2. **Estructura inicial:**

   ```
   juego/
   ├── project.godot        Godot 4.7, base 1920×1080, estiramiento canvas_items/expand,
   │                        renderizador Compatibilidad (máxima compatibilidad de hardware en 2D)
   ├── reglas/              cartas, muestra, tantos, mano, partido, vista (lógica pura)
   ├── ia/  senas/
   ├── mesa/  ui/  tutorial/
   ├── datos/               JSON de señas, diálogos y tutorial
   ├── recursos/  audio/  fuentes/
   ├── pruebas/             pruebas GUT (R-xx y T-xx)
   └── addons/gut/
   ```

3. **Primera verificación** (tarea 2.1 de la hoja de ruta, adaptada): ejecutar `godot --headless --path juego` con una prueba que falla a propósito y otra que pasa, y comprobar el código de salida.
4. **Fase 2 sin otros cambios:** el mismo motor de reglas, los mismos casos R-xx y los mismos criterios de aceptación.

## 9. Fuentes

- Godot Engine (2026). *Download for Windows*: https://godotengine.org/download/windows/ (4.7.2 estable, 18/08/2026; plantillas de exportación aparte; la versión .NET requiere el SDK).
- GodotSteam (2026, 22 de agosto). *Godot 4.7.2 and GodotSteam 4.22*: https://godotsteam.com/blog/2026/08/22/godot-472-and-godotsteam-422--411/
- Wikipedia. *Slay the Spire II*: https://en.wikipedia.org/wiki/Slay_the_Spire_II; 80.lv, *Slay the Spire 2 is sticking with Godot*: https://80.lv/articles/slay-the-spire-2-is-sticking-with-godot-leaving-unity-behind/
- GameMaker. *Pricing terms change FAQ*: https://gamemaker.io/help/articles/november-2023-pricing-terms-change-faq (Professional 99,99 USD, pago único).
- GameMaker. *LTS 2026.0 release*: https://gamemaker.io/blog/lts-2026-release; *UI Layers*: https://manual.gamemaker.io/lts/en/The_Asset_Editors/Room_Properties/UI_Layers.htm; *Version 2024.13*: https://gamemaker.io/en/blog/release-2024-13
- GameMaker. *Building via Command Line* (Igor requiere sesión): https://manual.gamemaker.io/lts/en/Settings/Building_via_Command_Line.htm
- GameMaker. *Steamworks SDK: setting up your games*: https://gamemaker.io/en/help/articles/steamworks-sdk-setting-up-your-games
- Unity. *Changes to Unity subscription plans and pricing*: https://unity.com/products/pricing-updates (Personal hasta 200.000 USD; pantalla de inicio opcional en Unity 6).
- Wikipedia. *Balatro*: https://en.wikipedia.org/wiki/Balatro (motor LÖVE).

Lo que no verifiqué en esta evaluación y queda para la primera tarea con el motor elegido: el tamaño de las descargas, la compatibilidad exacta de GUT con 4.7.2 y el rendimiento real de la IA en GDScript. Las afirmaciones sobre las capacidades de cada motor (nodos de interfaz, `Tween`, `RichTextLabel`, modo headless, `--doctool`) provienen de la documentación general de cada uno y se comprobarán con la referencia exportada de la versión instalada antes de usarlas.
