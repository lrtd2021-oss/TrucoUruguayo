# Dirección artística

Estado: **tres alternativas y una recomendación, pendientes de revisión.** No se producirán recursos finales hasta que se apruebe una dirección. El boceto comparativo [bocetos/direcciones.svg](bocetos/direcciones.svg) es una imagen de referencia, no un recurso del juego.

## Restricciones comunes

Valen para cualquier dirección elegida:

- **Las cartas se leen primero.** Número y palo legibles a 1280×720, en la mano propia y sobre la mesa. Los adornos no tapan los índices.
- **No depender solo del color.** Cada palo tiene forma propia, y las piezas llevan una insignia con forma y número además del color.
- **Señas legibles.** Las caras tienen rasgos separables (cejas, cada ojo, nariz, boca, mejillas y lengua), de modo que cada seña del perfil se distinga a tamaño de juego.
- **Originalidad.** No se copian barajas comerciales, ilustraciones de otros juegos ni obras protegidas. Las referencias sirven para entender un estilo, no para reproducirlo.
- **Producción viable** para un equipo chico. Se reutilizan piezas gráficas y se arma por composición en lugar de dibujar 40 cartas a mano.
- **Tipografías con licencia libre** (SIL Open Font License) incluidas en el proyecto.

## Referencias de ambiente consideradas

- **Club social o deportivo de barrio:** mesas de fórmica o madera, banderines del club, pizarra con el fixture, tubo fluorescente, cantina.
- **Boliche o almacén:** estanterías con botellas, mostrador de madera, luz cálida, radio AM.
- **Sobremesa familiar de domingo:** hule a cuadros, restos del asado, termo y mate, luz de patio.
- **Interior rural:** galpón o pulpería, chapa, farol, mate amargo.
- **Arte uruguayo del siglo XX:** el lenguaje del constructivismo de Joaquín Torres García y su taller (retícula, símbolos simples, paleta de tierras). Se toma como **lenguaje visual**: no se reproducen obras.

Elementos que se evitan como recurso fácil: banderas, escudos, el sol de la bandera como logotipo, el Obelisco o la rambla como postal, y el fileteado porteño, que se asocia más con Buenos Aires.

---

## Alternativa A: «Boliche de noche»

**Concepto.** Ilustración pintada, cálida y algo nostálgica. Es de noche, hay una lámpara colgante sobre la mesa y humo en el aire. Se parece a una escena de cine costumbrista.

- **Paleta:** verde fórmica `#2F5D50`, madera `#6B4226`, crema `#EFE3C8`, ámbar de lámpara `#F2A93B`, bordó `#7A1F2B` y negro humo `#1C1A17`.
- **Mesa y entorno:** madera gastada con marcas de vasos, un fondo desenfocado con estanterías y la luz concentrada en la mesa.
- **Cartas:** cartulina crema con textura, figuras pintadas con pincel e índices en serif clásica.
- **Personajes:** bustos semirrealistas pintados, en tres cuartos, con iluminación dramática.
- **Tipografía:** serif de época para los títulos (tipo slab) y humanista para el texto.
- **Animación:** movimientos suaves, humo y polvo con partículas, y parpadeo de la lámpara.
- **Sonido:** murmullo de boliche, radio AM lejana y vasos.
- **Producción:** **alta.** Cada expresión de un personaje pintado es un dibujo nuevo, y las señas exigen muchos fotogramas por personaje para mantener la calidad.
- **Ventajas:** mucha atmósfera y fuerza emocional inmediata.
- **Limitaciones:** las señas (guiños, muecas) se pierden con poca luz y a tamaño chico, es costosa de ampliar y tiene riesgo de caer en el sepia nostálgico genérico.

## Alternativa B: «Taller constructivo»

**Concepto.** Gráfica plana y geométrica inspirada en el constructivismo uruguayo: formas recortadas, retícula, símbolos simples y una paleta de tierras con acentos fuertes. La mesa es la de un club de barrio, pero dibujada con ese lenguaje.

- **Paleta:** blanco hueso `#EDE6D6`, negro carbón `#1E1E1C`, ocre `#C8963E`, rojo óxido `#A8432F`, azul pizarra `#2E4A62`, verde oliva `#5F6B3A` y gris piedra `#8C877D`.
- **Mesa y entorno:** tablero de madera visto desde arriba, con vetas geométricas. Al fondo, una pared de club resuelta en bloques de color: banderín, pizarra, radio, termo.
- **Cartas:** fondo hueso, contorno grueso e índices grandes. Palos rediseñados como pictogramas: el oro como disco con anillos, la copa como cáliz de trazos rectos, la espada recta y el basto como palo nudoso. Las figuras son personajes geométricos de pocos planos.
- **Personajes:** retratos frontales hechos de planos de color, con rasgos separados en capas que se animan por separado. Cada seña es una combinación de estados de esas capas.
- **Tipografía:** una display geométrica para títulos y cantos, y **Atkinson Hyperlegible** (OFL, diseñada para baja visión) para la interfaz.
- **Animación:** desplazamientos y escalados con curvas de animación, rebotes cortos y cartas que se deslizan y se asientan con un leve giro. Pocas partículas.
- **Sonido:** grabaciones limpias de mesa (cartas, fósforos, mate), y música escasa de guitarra o percusión de candombe a bajo volumen.
- **Producción:** **media.** Las formas planas se pueden generar por código (Python + Pillow, disponible en el equipo) o vectorizar con facilidad. Una cara son unas diez piezas reutilizables.
- **Ventajas:** muy legible, identidad uruguaya sin símbolos nacionales y señas nítidas. Escala bien a cualquier resolución y es coherente entre cartas, personajes e interfaz.
- **Limitaciones:** si se ejecuta mal puede quedar fría o «de infografía». Necesita textura (papel, grano) y animación con carácter para tener calidez.

## Alternativa C: «Sobremesa de papel»

**Concepto.** Estilo de recortes de papel y cartón, como un teatrito de títeres sobre una mesa familiar de domingo. Luz de día, hule a cuadros y humor tierno.

- **Paleta:** rojo hule `#C0392B`, blanco mantel `#F4EFE6`, amarillo `#F2C14E`, verde parra `#6A994E`, marrón cartón `#A47551` y celeste `#8EC5E8`.
- **Mesa y entorno:** hule a cuadros, sombras de papel superpuesto, parra y ladrillo al fondo.
- **Cartas:** cartón con bordes irregulares y palos como recortes con sombra.
- **Personajes:** títeres de cartón con articulaciones visibles. Las expresiones se hacen cambiando piezas recortadas.
- **Tipografía:** manuscrita amable para títulos y Atkinson Hyperlegible para la interfaz.
- **Animación:** movimientos con tirón, como de títere (stop motion simulado).
- **Sonido:** patio, pájaros, vajilla y risas.
- **Producción:** **media**, pero exige escanear o simular texturas de papel de forma convincente.
- **Ventajas:** cálida, accesible para principiantes y familiar.
- **Limitaciones:** tono infantil que choca con la tensión del truco (mentir, provocar). Las texturas de borde irregular complican la lectura de las cartas chicas, y el hule a cuadros compite con las cartas como fondo.

---

## Recomendación: B, «Taller constructivo», con la calidez de A

Se recomienda la **alternativa B**, ambientada de noche en un **club social de barrio** y con la luz cálida de A (lámpara sobre la mesa y textura de papel y madera).

Razones:

1. **Las señas son una mecánica, no un adorno.** Un guiño izquierdo tiene que distinguirse de uno derecho en un retrato de 200 píxeles. Las caras por capas de B lo garantizan, y además permiten animar cada seña con poco costo.
2. **Legibilidad de las cartas.** Fondo claro, contorno fuerte y pictogramas simples son lo más legible de las tres opciones, también para personas con daltonismo, porque cada palo tiene forma propia.
3. **Identidad uruguaya sin clichés.** El lenguaje constructivo es propio del arte uruguayo y se reconoce sin banderas. Combinado con objetos de club (termo, banderín, pizarra, tanteador de fósforos) da un ambiente local y original.
4. **Viabilidad.** Es la única opción en la que buena parte de los recursos se puede producir y modificar por código con las herramientas disponibles, sin depender de un ilustrador para cada cambio.
5. **Coherencia.** Cartas, caras, tanteador y botones pueden salir de la misma retícula y la misma paleta.

Riesgo principal y mitigación: que quede fría. Se mitiga con textura de grano, animaciones con rebote, luz cálida en la mesa y diálogos con humor.

## Sistema de cartas (para la dirección recomendada)

Composición en tiempo de ejecución, sin 40 dibujos independientes:

- **Base:** marco y fondo (1 sprite), dorso único (1 sprite, idéntico para las 40 cartas).
- **Palos:** 4 pictogramas, con una versión grande y otra chica para los índices.
- **Pintas del 1 al 7:** disposiciones definidas como datos (coordenadas por número) que reutilizan el pictograma del palo. Los ases tienen un pictograma grande especial.
- **Figuras:** 3 ilustraciones base (sota de pie, caballo con jinete y rey sentado) con el emblema del palo que sostienen intercambiable, más el color de acento del palo.
- **Índices:** número y palo en dos esquinas opuestas.
- **Insignia de pieza:** solo en la mano propia, cuando la muestra convierte la carta en pieza. Lleva forma (estrella de cinco puntas recortada) y número de orden (1 a 5); el alcahuete lleva además una «A». No depende del color.
- Las caras de las cartas se componen una vez al iniciar el juego y se guardan como sprites, con `sprite_create_from_surface`, que existe en el runtime instalado (ver ARQUITECTURA.md). Así no se redibujan en cada fotograma.

## Personajes y señas

- **Retrato por capas:** cabeza, pelo, cejas (izquierda y derecha), ojos (izquierdo y derecho: abierto, cerrado, guiño), nariz (normal, arrugada), boca (neutra, beso, mueca a la derecha, mueca a la izquierda, mordida, entreabierta, lengua, sonrisa, enojo) y mejillas (normal, infladas).
- **Lado de la seña:** «derecho» e «izquierdo» se refieren siempre al lado del personaje, no al de quien mira. El guiño del ojo derecho (perico) se ve en el ojo que queda a la izquierda de la pantalla. Lo mismo vale para las muecas de las matas. Es un error fácil de cometer al dibujar y lo cubre una prueba visual en la Fase 5.
- Cada seña se define como datos: qué capas cambian, a qué estado y durante cuánto tiempo. Un perfil de señas es una tabla, no código.
- Las expresiones emocionales (alegría, fastidio, sorpresa, concentración) usan las mismas capas, con otra duración y sin el «tic» característico de las señas. Así una sonrisa no se confunde con una seña.
- Detalles de cada personaje en [PERSONAJES.md](PERSONAJES.md).

## Interfaz

- Botones con forma de ficha recortada, el mismo contorno que las cartas y la tipografía de interfaz.
- **Tanteador de fósforos** agrupados de a cinco (cuatro lados y una diagonal), con malas y buenas separadas por una línea, y el número visible al lado para no obligar a contar.
- Los cantos aparecen como globos con texto grande y un pictograma (truco, envido, flor) además del color.
- La baza en disputa y las bazas ganadas se marcan con fichas numeradas (1.ª, 2.ª, 3.ª) con el resultado escrito (ganada, perdida, parda).

## Sonido

- **Efectos:** mezclar, repartir, carta sobre la mesa (normal y «golpe» al matar), fósforo al anotar, mate, silla. Se pueden grabar con un celular en un ambiente silencioso y editar con herramientas libres. Hay ffmpeg en el equipo para convertir y normalizar.
- **Ambiente:** murmullo de club en loop, con volumen propio.
- **Música:** escasa, solo en menús y momentos de cierre. Requiere composición original o una biblioteca con licencia verificada. **No se puede generar con las herramientas disponibles**: es una tarea externa (ver ROADMAP.md).
- **Voces:** los cantos cortos («¡Truco!», «Quiero», «Son buenas») grabados por voces uruguayas reales. Hasta entonces, solo texto. El diálogo largo siempre es texto.

## Producción de recursos

| Recurso | Cómo se produce | Integración |
|---------|-----------------|-------------|
| Pictogramas, marcos, insignias, fósforos | Script de Python + Pillow en `herramientas/` que exporta PNG | Texturas importadas por Godot |
| Figuras de cartas y retratos | Primera versión generada por código; refinamiento posible en un editor vectorial libre (Inkscape, a instalar) | PNG por capa |
| Tipografías | Google Fonts (OFL) | Fuente cargada con `font_add` desde Included Files, con su licencia |
| Efectos y ambiente | Grabación propia, edición y normalización con ffmpeg | Archivos de audio en Godot, por bus (efectos, ambiente) |
| Música y voces | Externo (composición o grabación) | Grupos de audio separados |

Estados de un recurso, registrados en ROADMAP.md: *referencia* → *generado* → *integrado en Godot* → *verificado en juego*.
