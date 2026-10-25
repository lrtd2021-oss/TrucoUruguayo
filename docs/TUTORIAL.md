# Sistema de aprendizaje

Estado: **propuesta para revisión.** No hay nada implementado. Los capítulos 7 y 8 dependen de reglas sin confirmar (D-06 y la falta envido en malas), así que su contenido es provisional hasta que se confirmen y el motor las pase en las pruebas.

## 1. Principios

1. **Se aprende haciendo en la mesa.** Cada concepto se presenta en una situación de juego, se muestra, se demuestra y se practica con una acción real: tocar una carta, ordenarla, jugarla, cantar o responder.
2. **Un concepto solo cuenta como aprendido si se comprueba.** Pulsar «Continuar» no completa nada. Un capítulo termina al superar su comprobación.
3. **Un único motor de reglas.** Los ejercicios corren sobre `Mano` y las funciones de cartas y tantos de la partida real. El contenido del tutorial **no escribe respuestas**: describe la situación y el motor calcula la respuesta correcta y su explicación. Así el tutorial no puede contradecir al juego.
4. **Poco texto y en el momento justo.** Como máximo dos frases por globo. Lo demás está en «Ver más» o en la Consulta.
5. **Equivocarse es parte del aprendizaje.** La devolución explica, señala el concepto y ofrece otro intento. Los personajes pueden bromear, nunca humillar.
6. **Ayuda justa.** Ninguna pista usa cartas ocultas de otros jugadores. El asistente recibe la misma vista filtrada que la IA (ARQUITECTURA.md, 6.1).
7. **Reglamento visible.** Cuando algo depende de una opción del reglamento, aparece la etiqueta «Reglamento activo: …», y los valores se toman del perfil de reglas en uso, nunca escritos a mano.

## 2. Modos

| Modo | Para qué sirve | Disponible |
|------|----------------|------------|
| **Aprender** | Capítulos con introducción, demostración, ejercicios y comprobación | Desde el inicio, según la progresión (sección 4) |
| **Practicar** | Situaciones aisladas por concepto, con variantes generadas y repetición ilimitada | Cada tema se habilita al completar el capítulo que lo enseña, o con «Desbloquear todo» |
| **Partida guiada** | Partido real contra rivales de nivel aprendiz, con indicaciones que se reducen con el tiempo | Al completar el capítulo 5 (recomendada al final del recorrido) |
| **Consulta** | Reglamento, señas, glosario y tablas, buscables y con ejemplos animados | Siempre, también durante una partida |

La propuesta original incluía «Práctica libre y consulta» como capítulo 12. Aquí se convierte en dos modos permanentes, porque no se completan: se usan cuando hace falta.

## 3. Índice de capítulos

Cambios respecto de la propuesta de partida, con su motivo:

- **La jerarquía va antes que la muestra.** Las piezas se entienden como «cartas que se ponen por encima de todas», y eso exige conocer primero la escalera fija (matas, chicas, negras, comunes). Por eso los capítulos 2 y 3 de la propuesta pasan a ser 2, 3 y 4.
- **El truco va antes que el envido.** El truco cambia el valor de la mano que se acaba de aprender a jugar. El envido es un juego aparte dentro de la mano, y su regla «el envido está primero» solo se entiende si ya se conoce el truco.
- **Se agrega «Los puntos del partido».** El orden de anotación (flor, envido, truco), las malas y buenas, la falta y el final inmediato no tenían capítulo propio.

| # | Capítulo | Objetivo de aprendizaje (al terminar, el jugador puede…) | Requiere |
|---|----------|----------------------------------------------------------|----------|
| 1 | **Bienvenido a la mesa** | Identificar a su compañero y a los rivales, seguir el orden de juego antihorario, reconocer quién es mano y quién es pie, y saber qué gana el partido | — |
| 2 | **La baraja** | Reconocer los cuatro palos y las cartas de cada palo, y saber que no hay 8 ni 9 | 1 |
| 3 | **El poder de las cartas** | Ordenar cartas sin muestra (matas, chicas, negras y comunes), decidir qué carta gana y reconocer cartas que empatan | 2 |
| 4 | **La muestra y las piezas** | Identificar las piezas a partir de la muestra, ubicarlas por encima de las matas y aplicar la regla del alcahuete | 3 |
| 5 | **Cómo se juega una mano** | Jugar una mano sin cantos: turnos, bazas, ganador de cada baza, pardas, irse al mazo y quién gana la mano | 4 |
| 6 | **El truco** | Gritar, querer, no querer y subir (retruco, vale cuatro), saber quién puede subir y cuánto vale cada resultado | 5 |
| 7 | **El envido** | Calcular el tanto con y sin piezas, cantar y responder la secuencia de envido, declarar o decir «son buenas», resolver empates y aplicar «el envido está primero» | 6 |
| 8 | **La flor** *(provisional, D-06)* | Reconocer cuándo hay flor, calcular su valor, saber que anula el envido y resolver flor contra flor, achicarse y contraflor al resto | 7 |
| 9 | **Los puntos del partido** | Leer el tanteador de fósforos, distinguir malas y buenas, calcular la falta y aplicar el orden de anotación y el final inmediato | 7 (y 8 para los ejemplos de flor) |
| 10 | **Las señas** | Reconocer cada seña del perfil activo, traducirla a cartas, hacer señas al compañero sin que lo vean los rivales y saber qué está permitido y qué no | 5 |
| 11 | **Estrategia** | Recordar cartas jugadas, leer la mesa, coordinar con el compañero (el pie), medir el riesgo y farolear con criterio | 6, 7, 10 |
| 12 | **Cultura de la mesa** | Reconocer expresiones y costumbres de la mesa uruguaya, distinguir el reglamento del juego de las variantes regionales y elegir opciones de reglamento con conocimiento | 1 |
| 13 | **Partida guiada** | Jugar un partido completo con asistencia que se reduce hasta desaparecer | 5 (recomendado: 1 a 11) |

### 3.1 Orden recomendado y dependencias

```
1 ─► 2 ─► 3 ─► 4 ─► 5 ─► 6 ─► 7 ─► 8 ─► 9
     │                   │    │
     │                   ├────┴─► 11 ◄─ 10 ◄─ 5
12 ◄─1                   └─► 13 (partida guiada, desde 5)
```

Recorrido sugerido para quien empieza de cero: 1 → 13 en orden. El capítulo 12 es breve y puede verse en cualquier momento después del 1.

### 3.2 Lecciones avanzadas

Casos que confunden o que son demasiado densos para el primer recorrido. Se habilitan con el capítulo indicado y también se pueden abrir desde la Consulta.

| Id | Lección | Se habilita con |
|----|---------|-----------------|
| LA-1 | Pardas difíciles: tres pardas, parda en 2.ª o 3.ª, quién abre después de una parda | 5 |
| LA-2 | El alcahuete en todos sus casos: truco, envido, flor y seña | 4 y 8 |
| LA-3 | Cantos cruzados: truco interrumpido por envido o flor, y el orden en que se resuelven | 7 y 8 |
| LA-4 | Secuencias largas de envido y sus rechazos (envido, envido, real envido, falta) | 7 |
| LA-5 | Empates de tantos y orden de declaración | 7 |
| LA-6 | Colleras: varias flores en la mesa *(provisional)* | 8 |
| LA-7 | La falta según el tanteador, en malas y en buenas *(depende del reglamento activo)* | 9 |
| LA-8 | Irse al mazo: qué se pierde y cuándo conviene | 6 |

### 3.3 Casos que suelen confundir y dónde se enseñan

| Caso | Dónde |
|------|-------|
| El ancho de espadas no es la carta más alta cuando hay piezas | Cap. 4 |
| La carta de la muestra no está en juego | Cap. 4 |
| El 12 de la muestra es un rey común, salvo cuando hace de alcahuete | Cap. 4 y LA-2 |
| Las matas no cambian con el palo de la muestra | Cap. 4 |
| Las figuras valen 0 en el envido, pero el 10 y el 11 de la muestra valen 27 | Cap. 7 |
| Con dos piezas hay flor, no envido | Cap. 7 y 8 |
| La flor anula el envido, aunque ya se haya cantado | Cap. 8 |
| Parda en primera: decide la segunda | Cap. 5 |
| Solo puede subir el truco la pareja que lo quiso | Cap. 6 |
| No querer un envido da 1 punto al que cantó | Cap. 7 |
| La falta es lo que le falta **al que va ganando**, no al que la canta | Cap. 9 |
| Ganar un envido puede terminar el partido en ese momento | Cap. 9 |
| En la flor, la segunda pieza cuenta solo su unidad | Cap. 8 |
| «Guiño derecho» es el ojo derecho del personaje, a la izquierda de la pantalla | Cap. 10 |

### 3.4 Cobertura del reglamento

Cada regla de REGLAS_TRUCO_URUGUAYO.md está asignada a un capítulo o a una lección. Una prueba (T-14) comprueba que cada caso R-01 a R-55 aparece en al menos un ejercicio o en una entrada de la Consulta.

| Sección del reglamento | Capítulos |
|------------------------|-----------|
| 2 Baraja | 2 |
| 3 Muestra, piezas y alcahuete | 4, LA-2 |
| 4 Jerarquía | 3, 4 |
| 5.1–5.2 Valores y envido | 7 |
| 5.3 Flor | 8 |
| 6 Desarrollo y pardas | 1, 5, LA-1 |
| 7 Envido | 7, LA-4, LA-5 |
| 8 Flor | 8, LA-6 |
| 9 Truco | 6, LA-8 |
| 10 Partido | 1, 9, LA-7 |
| 11 Señas y marcas de cartas | 10 |
| 12 Glosario | Consulta y todos los capítulos |
| Variantes documentadas | 12 |

## 4. Perfiles y progresión

Al entrar por primera vez a «Aprender», Tito pregunta: «¿Cuánto sabés de truco?».

| Respuesta | Qué pasa |
|-----------|----------|
| «Nada, quiero aprender» | Recorrido completo, capítulo por capítulo |
| «Juego al truco, pero no con muestra» | Los capítulos 1 a 3 y 5 ofrecen **prueba de dominio**; el recorrido destaca el 4 (muestra y piezas), el 7 (envido con piezas) y el 8 (flor) |
| «Ya juego al truco uruguayo» | Se ofrece «Desbloquear todo» y se sugieren Practicar, la Consulta y las lecciones avanzadas |

La respuesta solo **sugiere** un recorrido; se cambia desde el menú de aprendizaje cuando se quiera.

Reglas de desbloqueo:

- Un capítulo está disponible si sus requisitos están **completados** o **aprobados por prueba**, o si se eligió «Desbloquear todo».
- **Prueba de dominio:** cualquier capítulo disponible se puede saltar haciendo directamente su comprobación. Si se aprueba, el capítulo queda «aprobado por prueba» y habilita los siguientes.
- Los capítulos completados se pueden repetir enteros, o solo sus ejercicios, cuando se quiera.
- Se puede salir de una lección en cualquier momento. Al volver se ofrece «Seguir desde el paso N» o «Empezar de nuevo».
- La Consulta nunca está bloqueada.

## 5. Plantilla de capítulo

Cada capítulo es una lista de **pasos**. Cada paso es de un tipo, y los tipos corresponden a la plantilla pedida:

| Elemento | Tipo de paso | Qué hace |
|----------|--------------|----------|
| A. Objetivo | `portada` | Tarjeta con título, objetivo y requisitos |
| B. Introducción | `dialogo` | Líneas de personajes en la mesa |
| C. Explicación visual | `explicar` | Texto breve, resaltados en la mesa y cartas de ejemplo |
| D. Demostración | `demo` | Un escenario que avanza acción por acción con narración. Se puede pausar, retroceder, repetir o saltar |
| E. Ejercicio | `ejercicio` | La persona actúa y el motor valida |
| F. Devolución | parte de `ejercicio` | Mensaje de acierto o diagnóstico del error, con enlace al paso que lo explica |
| G. Comprobación | `comprobacion` | Serie de ejercicios sin pistas; hay que superarla para completar el capítulo |
| H. Resumen | `resumen` | Tres a cinco puntos, con enlaces a la Consulta |
| I. Continuación | parte de `resumen` | Siguiente capítulo, repetir ejercicios o volver al menú |

### 5.1 Tipos de ejercicio

Todos resuelven la respuesta correcta con el motor:

| Tipo | Acción de la persona | Respuesta calculada con |
|------|----------------------|-------------------------|
| `tocar` | Tocar un jugador, una carta o una zona de la mesa | Función del motor (por ejemplo, quién es mano según el repartidor) |
| `ordenar` | Ordenar cartas de mayor a menor | `Muestra.poder` |
| `comparar` | Elegir la carta que gana, o marcar «empatan» | `Muestra.poder` |
| `calcular` | Elegir o escribir un tanto | `Tantos.envido`, `Tantos.valor_flor` y su desglose |
| `responder` | Elegir una acción en un estado de mano | `Mano.acciones_validas` y `Mano.aplicar` |
| `jugar` | Jugar una baza o una mano completa | `Mano` con los rivales guionados o con IA |
| `sena_reconocer` | Ver un gesto y elegir las cartas que significa | Perfil de señas activo |
| `sena_hacer` | Elegir la seña que corresponde a su mano | Perfil de señas activo |
| `decidir` | Decisión de estrategia | Respuestas recomendadas escritas en el contenido, presentadas como **recomendación** y no como regla |

### 5.2 Devolución con diagnóstico

Cuando una respuesta es incorrecta, el motor busca el error más probable y responde según ese diagnóstico:

- **En el envido:** se calcula qué habría dado la cuenta si se sumaran las figuras, si se olvidaran los 20, si la pieza se tomara como carta común o si se sumaran tres cartas. Si la respuesta coincide con una de esas cuentas, se explica ese error concreto.
- **En la jerarquía:** se identifica el par de cartas mal ordenado y el grupo al que pertenece cada una.
- **En las respuestas a cantos:** si la acción es ilegal, se dice por qué, usando el motivo que devuelve `Mano.aplicar`.
- **Sin diagnóstico posible:** mensaje genérico, explicación del motor y enlace al paso.

Siempre hay otro intento. Después de dos errores en el mismo ejercicio se ofrece «Ver la explicación otra vez» o «Mostrarme la respuesta». Mostrar la respuesta no cuenta como acierto.

## 6. Capítulo 1 completo: «Bienvenido a la mesa»

**Personajes:** Tito (tu compañero, hace de guía), Marta y Cacho (rivales). **Mesa:** vos abajo, Cacho a la derecha, Tito enfrente y Marta a la izquierda. **Reglamento citado:** puntos 6 y 10 (orden de juego, mano, pie y largo del partido).

### Pantalla 1.0: portada

- **Título:** Bienvenido a la mesa.
- **Objetivo:** «Vas a saber con quién jugás, contra quién, en qué orden se juega y qué hay que hacer para ganar.»
- **Botones:** Empezar · Hacer la prueba de dominio · Volver.

### Pantalla 1.1: llegada (introducción)

Escena de club de noche. Los tres personajes ya están sentados y hay una silla libre abajo. La cámara baja hasta la mesa.

> **Tito:** ¡Llegaste! Sentate, que te estábamos esperando.
> **Cacho:** Así que este es el que nos va a ganar… Vamos a ver.
> **Marta:** No le hagas caso. Bienvenido.

### Pantalla 1.2: la mesa (explicación visual)

Una luz ilumina por turno cada asiento. Debajo de cada personaje aparece una ficha con forma y texto. «Nosotros» lleva un **círculo** y «Ellos» un **cuadrado**, de modo que no depende del color.

> **Tito:** El truco se juega de a cuatro, en parejas. Yo soy tu compañero: me siento enfrente tuyo.
> **Tito:** Marta y Cacho juegan juntos, contra nosotros. Fijate que los compañeros nunca se sientan al lado.

**Ejercicio 1.A (tocar):** «Tocá a tu compañero.»

- Acierto: Tito saluda con la mano. *«Eso. Vos y yo, toda la noche.»*
- Error (toca a un rival): reacción del rival tocado. Cacho: *«¡Epa! Yo juego en contra, eh.»* Marta: *«Yo no, querido. Tu compañero está enfrente.»* Se resalta el asiento de enfrente.

### Pantalla 1.3: el objetivo (explicación visual)

Se resalta el tanteador: «Nosotros 0, Ellos 0», con fósforos dibujados y el número al lado. Debajo aparece la etiqueta «Reglamento activo: partido a 30».

> **Tito:** Gana la primera pareja que llega a **{partido.puntos}** puntos. Los puntos se ganan jugando las cartas y cantando.
> **Tito:** Los cantos tienen nombre: truco, envido, flor. Ya los vas a ir conociendo, de a uno.

Aparecen tres íconos chicos (truco, envido y flor) con la etiqueta «Próximamente» y desaparecen. Así se anuncian sin explicarlos todavía. `{partido.puntos}` sale del reglamento activo: si se elige el partido a 40, el texto dice 40.

### Pantalla 1.4: el orden de juego (demostración)

Demo animada:

1. Marta toma el mazo y aparece la ficha de «Reparte» junto a ella.
2. Una flecha recorre la mesa en sentido antihorario: Marta → vos → Cacho → Tito.
3. Marta reparte de a una carta, empezando por vos, porque estás a su derecha. Las cartas quedan boca abajo.

> **Tito:** Se juega en contra de las agujas del reloj, como sigue la flecha.
> **Tito:** El que está a la derecha del que reparte es **mano**: juega primero. Ahora la mano sos vos.
> **Marta:** Y el último de cada pareja es el **pie**. En nuestra pareja soy yo, porque repartí. En la de ustedes es Tito.

Controles de la demo: Pausa (Espacio), Anterior (←), Siguiente (→), Repetir (R) y Saltar demo (S).

**Ejercicio 1.B (tocar, tres rondas generadas):** la ficha de «Reparte» aparece junto a un jugador al azar. «¿Quién es mano? Tocalo.»

- La respuesta correcta la da el motor: el siguiente en sentido antihorario después del que reparte.
- Error: la flecha antihoraria aparece desde el que reparte y se detiene un instante en el jugador correcto. *«Fijate: a la derecha del que reparte. Siguiendo la flecha.»*
- Se repiten rondas hasta acertar tres en total, y cada repartidor sale una vez como mucho.

**Ejercicio 1.C (ordenar en la mesa):** «Tocá a los cuatro en el orden en que juegan la primera carta.» La persona toca los asientos uno por uno y cada toque correcto deja un número (1, 2, 3, 4).

- Error: el número del asiento equivocado tiembla y se marca con una cruz y la palabra «No». La flecha muestra al que correspondía. Se sigue desde ahí sin empezar de nuevo.

### Pantalla 1.5: bazas y manos (demostración breve)

Demo con las cartas boca arriba solo para mostrar. Cada jugador tira una carta y Tito gana la baza.

> **Tito:** Cada uno juega una carta: eso es una **baza**. La gana la carta más alta. Cuáles son las más altas lo vemos en un rato.
> **Tito:** Una **mano** tiene hasta tres bazas. La pareja que gana dos se lleva la mano.
> **Cacho:** Y después reparte el siguiente, así nadie se queja de la suerte.

Se ven tres fichas de baza (1.ª, 2.ª y 3.ª). En la primera aparece el círculo de «Nosotros» con la palabra «Ganada». La ficha de «Reparte» pasa al siguiente jugador.

### Pantalla 1.6: palabras de la mesa (explicación visual)

Cuatro tarjetas de glosario aparecen a medida que Tito las nombra. Quedan guardadas en el glosario de la Consulta.

| Palabra | Tarjeta |
|---------|---------|
| Mano | El reparto con sus tres bazas. También el jugador que juega primero. |
| Pie | El último en jugar de cada pareja. |
| Baza | Una vuelta en la que cada uno juega una carta. |
| Cantar | Proponer una apuesta: truco, envido o flor. Se contesta «quiero» o «no quiero». |

> **Marta:** Sí, «mano» quiere decir dos cosas. Te vas a acostumbrar.

### Pantalla 1.7: comprobación

Sin pistas ni flecha de ayuda. Reparte Cacho:

1. *Tocar:* «¿Quién es mano?» (respuesta: Tito).
2. *Tocar:* «¿Quién es el pie de tu pareja?» (respuesta: vos).
3. *Tocar:* «Tito ya jugó. ¿Quién juega ahora?» (respuesta: Marta).
4. *Elegir:* «¿Cuántos puntos necesita una pareja para ganar el partido?», con las opciones {partido.malas}, {partido.puntos} y 50. La correcta y la opción plausible (la mitad, las malas) salen del reglamento activo.

Se aprueba con los cuatro puntos correctos. Un error permite reintentar ese punto después de ver la explicación breve. Se registra cuáles se acertaron al primer intento, pero esto **no** impide aprobar.

> **Tito** (aprobado): ¡Ta, ya estás para sentarte en cualquier mesa! Bueno, casi. Falta conocer las cartas.
> **Cacho:** No te agrandes, que todavía no jugamos ni una.

### Pantalla 1.8: resumen y continuación

- Se juega de a cuatro, en parejas. Tu compañero está enfrente.
- Se juega en sentido antihorario.
- Mano: el de la derecha del que reparte. Juega primero.
- Pie: el último de cada pareja.
- Gana la pareja que llega primero a {partido.puntos}.

**Botones:** Siguiente: La baraja · Repetir ejercicios · Ver en la Consulta (Desarrollo de una mano) · Menú de aprendizaje.

### Cómo se ve en pantalla (1920×1080)

```
┌──────────────────────────────────────────────────────────────┐
│ [≡ Menú] Cap. 1 · Bienvenido a la mesa  4/9  [Consulta][Opc] │
│                         ┌──────┐                             │
│                         │ Tito │  ← compañero (círculo)      │
│   ┌──────┐              └──────┘              ┌──────┐       │
│   │Marta │   ┌──────────────────────────┐     │Cacho │       │
│   │  ■   │   │   zona de juego / mesa   │     │  ■   │       │
│   └──────┘   └──────────────────────────┘     └──────┘       │
│ ┌──────────────────────┐   [tus cartas]       [tanteador]    │
│ │ Globo de narración   │                      Nos 0 │ Ell 0  │
│ │ (máx. 2 frases)      │                                     │
│ │ [<][||][>][R] Saltar │                                     │
│ └──────────────────────┘                                     │
└──────────────────────────────────────────────────────────────┘
```

El panel de narración va en la esquina inferior izquierda. El diseño de la mesa reserva esa zona y nunca tapa las cartas, la muestra ni el tanteador. Cuando un resaltado cae debajo del panel, el panel se mueve a la esquina inferior derecha.

## 7. Partida guiada y asistencia

**Niveles de asistencia**, que se pueden cambiar en cualquier momento desde [Opciones] o con la tecla H:

| Nivel | Qué hace |
|-------|----------|
| Alta | Presenta cada mecánica nueva cuando aparece por primera vez y, antes de cada decisión, sugiere una acción con su motivo |
| Media | Presenta mecánicas nuevas y avisa antes de errores de reglas (por ejemplo, una respuesta que no conviene por cómo puntúa) |
| Baja | Solo responde cuando se pide, con el botón «¿Qué harías?» |
| Apagada | Nada |

**Reducción automática:** cada mecánica (envido, truco, flor, parda…) se presenta una sola vez. Las sugerencias de un concepto se apagan después de tres decisiones seguidas en las que la persona coincidió con la recomendación sin pedir ayuda. Al bajar de nivel automáticamente, un aviso lo dice y ofrece volver al anterior. **Pendiente de aprobación (TD-07).**

**Cómo se arma:**

- Las primeras manos usan **semillas elegidas** para que aparezcan las mecánicas en orden: una mano sin cantos, una con envido, una con truco y una con flor. Una prueba comprueba que cada semilla produce la situación buscada (T-12). Después, el reparto es al azar.
- Los rivales usan la dificultad «aprendiz»: juegan de forma legal y razonable, y farolean poco.
- Tito da las indicaciones con su voz de personaje.

**Indicaciones justas:**

- Las sugerencias las calcula el asistente con la vista de la persona (`Vista.para`) y el mismo evaluador de la IA. Nunca ve cartas ocultas.
- Una prueba de invariancia (T-10) cambia al azar las cartas ocultas de los rivales sin tocar la información pública y comprueba que las indicaciones no cambian.

## 8. Arquitectura

Implementación en Godot 4.7.2 (D-17), según ARQUITECTURA.md. Como allí, cada clase o función de Godot citada se verifica contra la referencia de la versión instalada antes de usarla.

### 8.1 Contenido como datos

Archivos JSON en `juego/datos/tutorial/`, leídos con `FileAccess` y `JSON`. El preset de exportación los incluye con el filtro de archivos no recurso (ARQUITECTURA.md, 8):

```
tutorial/
├── indice.json          capítulos, requisitos, conceptos y lecciones avanzadas
├── cap01_mesa.json      pasos del capítulo 1
├── cap02_baraja.json    …
└── practicar.json       situaciones de práctica por concepto
```

Ejemplo (extracto del capítulo 1):

```json
{
  "id": "cap01", "titulo": "Bienvenido a la mesa",
  "objetivo": "Vas a saber con quién jugás, contra quién, en qué orden se juega y qué hay que hacer para ganar.",
  "requiere": [], "conceptos": ["parejas", "orden_juego", "mano_pie", "objetivo"],
  "reglamento": ["6", "10"],
  "pasos": [
    { "tipo": "dialogo", "lineas": [
      { "quien": "tito", "texto": "¡Llegaste! Sentate, que te estábamos esperando." } ] },
    { "tipo": "ejercicio", "id": "cap01_ej_mano", "clase": "tocar",
      "consigna": "¿Quién es mano? Tocalo.",
      "generador": { "tipo": "repartidor_al_azar", "rondas": 3 },
      "respuesta": "motor:mano_de_repartidor",
      "repaso": "paso_orden",
      "casos_reglamento": [] }
  ]
}
```

Decisiones de formato:

- **JSON y no recursos de Godot (`.tres`):** es independiente del motor y se puede corregir un texto o agregar un ejercicio sin tocar código. La falta de verificación del compilador se compensa con un **validador** que corre al cargar y en las pruebas: revisa campos obligatorios, ids únicos, referencias a pasos y personajes existentes, y que cada `motor:` apunte a una función registrada.
- **Textos en español dentro de cada capítulo:** es más fácil de escribir y revisar. Si se traduce más adelante, un script extrae los textos a claves.
- **Marcadores `{reglamento.campo}`:** se reemplazan por texto usando el perfil de reglas activo. Un marcador desconocido es un error del validador, no un texto roto en pantalla.
- **Respuestas `motor:…`:** son nombres de funciones registradas en una tabla (`tutorial/respuestas.gd`) que llaman al motor. **El contenido nunca escribe una respuesta numérica a mano.** Cuando un ejercicio reproduce un ejemplo del reglamento (por ejemplo, R-10: 35), se agrega `"esperado_documentado": 35`, y la prueba T-02 comprueba que el motor da lo mismo. Si no coincide, se registra la discrepancia en DECISIONES.md antes de corregir.

### 8.2 Scripts y objetos nuevos

| Elemento | Responsabilidad |
|----------|-----------------|
| `tutorial/contenido.gd` | Carga y valida el contenido, reemplaza los marcadores y calcula el desbloqueo |
| `tutorial/respuestas.gd` | Tabla de respuestas `motor:` y diagnósticos de errores. Solo llama a funciones de las capas 1 a 5 |
| `reglas/escenario.gd` | `Escenario.construir(def)`: arma un estado de mano con cartas fijas, muestra, repartidor y tanteador, y aplica las acciones previas **con `Mano.aplicar`**. Un escenario ilegal no se puede construir |
| `sistema/progreso.gd` (autoload `Progreso`) | Lee y guarda `user://progreso.json` (sección 9) |
| `ia/asistente.gd` | Sugerencias a partir de la vista de la persona, usando el evaluador de `IA` |
| `tutorial/tutorial.tscn` | Controlador de una sesión de capítulo: avanza los pasos, maneja retroceder y repetir, y crea o destruye los elementos de interfaz del paso |
| `ui/narracion.tscn`, `ui/resaltado.tscn` | Globo de narración (`RichTextLabel`) y resaltado (contorno, flecha, oscurecimiento del resto) |
| `ui/consulta.tscn` | Capa de Consulta: reglamento, señas y glosario. Se usa también durante las partidas |

Cambios en lo ya diseñado:

- **El controlador de la mesa gana una «fuente de decisión» por asiento:** `humano`, `ia` o `guion`. En las demos y los ejercicios, los rivales siguen un guion de acciones (que también pasan por `Mano.aplicar`). Es la única modificación del controlador: el tutorial juega en la **misma escena de mesa** que una partida normal.
- **Pausa:** la mesa puede pausarse. Detiene los temporizadores de la IA y la cola de animaciones, y bloquea la entrada a la mesa. Lo usan la Consulta y el menú de pausa.
- **Desgloses:** `Tantos` agrega `desglose_envido` y `desglose_flor`, que devuelven qué cartas contaron y por qué. La explicación del tutorial se arma a partir de ese desglose (por ejemplo: «29 del 4 de la muestra + 6 del 6 de copas = 35»).

### 8.3 Retroceder y repetir

Como cada escenario se construye aplicando acciones, retroceder al paso N consiste en reconstruir el escenario y aplicar las primeras N−1 acciones sin animar. No se guardan copias del estado ni hay que «deshacer» acciones.

## 9. Progreso persistente

Archivo aparte de la configuración: `user://progreso.json`. La preferencia de asistencia se guarda en `user://config.cfg`, junto con las demás opciones.

```json
{
  "version": 1,
  "perfil": "conoce_truco",
  "desbloquear_todo": false,
  "capitulos": {
    "cap01": { "estado": "completado", "paso": 0 },
    "cap02": { "estado": "en_curso", "paso": 5 }
  },
  "ejercicios": {
    "cap01_ej_mano": { "intentos": 4, "resuelto": true, "primer_intento": false }
  },
  "conceptos": {
    "orden_juego": { "practicas": 7, "ultimo": "acierto" }
  }
}
```

- **Estados de capítulo:** `no_iniciado`, `en_curso` (con el paso donde quedó), `completado` y `aprobado_por_prueba`.
- **Indicadores honestos:**
  - en el menú: «Completado», «Aprobado por prueba» o «En curso, paso 5 de 9»;
  - en Practicar: «Practicado 7 veces · último: acierto».
- **Sin porcentajes de dominio**, porque no hay una medición definida que los respalde.
- **Escritura segura:** se escribe en `progreso.tmp`, se reemplaza el anterior con `DirAccess`. Si el archivo falta o está dañado, se arranca con un progreso vacío y se avisa, sin cerrar el juego.
- **Versión:** el campo `version` permite migrar el formato si cambia. Los ids de capítulos y ejercicios que ya no existen se ignoran sin error.
- **Reiniciar progreso:** opción en el menú de aprendizaje, con confirmación (es una de las pocas confirmaciones justificadas).
- **Independencia:** `Progreso` no conoce el motor de reglas y el motor no conoce el progreso.

## 10. Experiencia de usuario

- **Las mismas cartas, personajes, tipografía, botones y mesa** que la partida.
- **Controles en cada paso:** Anterior ← · Pausa Espacio · Siguiente → o Enter · Repetir R · Saltar demo S · Consulta F1 · Salir Esc. Todo funciona igual con ratón y con teclado.
- **Resaltados:** contorno grueso, flecha y oscurecimiento suave del resto (sin ocultarlo). Nunca solo un cambio de color.
- **Información en pantalla:** como máximo un globo de narración y un resaltado principal a la vez.
- **Sin dependencia del sonido:** si hay voces, siempre llevan subtítulos, y ninguna consigna existe solo en audio. La velocidad del texto y de las demos respeta la configuración general.
- **Consulta durante una partida:** abre una capa encima, pausa la mesa y, al cerrarla, la partida sigue exactamente donde estaba.

## 11. Pruebas del sistema de aprendizaje

Automáticas, con GUT en modo headless (ARQUITECTURA.md, 9), salvo T-13, que necesita ventana para medir con la fuente real. Mientras no se ejecuten en Godot no cuentan como pasadas.

| Id | Qué comprueba | Cómo |
|----|---------------|------|
| T-01 | Todos los capítulos se abren y se cierran | Por cada capítulo: cargar, recorrer los pasos en modo sin animaciones con respuestas correctas del motor, completar. Repetirlo saliendo en cada paso y verificar que no quedan nodos de interfaz y que la mesa vuelve a su estado inicial |
| T-02 | Las explicaciones representan las reglas | Todos los marcadores se resuelven; cada `esperado_documentado` coincide con el motor; cada escenario se construye sin acciones rechazadas |
| T-03 | Los ejercicios tienen respuestas correctas | La respuesta del motor se acepta y las respuestas incorrectas listadas en el contenido se rechazan |
| T-04 | Los errores generan devolución útil | Cada ejercicio tiene devolución de error, cada diagnóstico tiene texto y enlace a un paso existente, y existe el mensaje genérico |
| T-05 | Repetir una lección no corrompe el estado | Completar un capítulo dos veces: los contadores solo crecen, no hay duplicados y el estado final de la mesa es igual |
| T-06 | El progreso se guarda y se recupera | Guardar, leer y comparar; un archivo dañado o vacío da un progreso vacío sin error; una versión antigua se migra |
| T-07 | El desbloqueo es coherente | Grafo de requisitos sin ciclos ni referencias rotas. Para 500 progresos al azar: disponible si y solo si se cumplen los requisitos, hay prueba aprobada o está «Desbloquear todo» |
| T-08 | Las ayudas se activan y se desactivan | Con asistencia apagada no hay sugerencias; un cambio a mitad de partida rige desde la decisión siguiente; la opción persiste |
| T-09 | La partida guiada se completa | Simulación con un jugador automático en el asiento humano, para N semillas: el partido termina sin bloqueos |
| T-10 | El tutorial no revela información oculta | Prueba de invariancia: con la misma vista pública y distintas cartas ocultas de los rivales, sugerencias y diálogos idénticos |
| T-11 | La Consulta no altera la partida | Abrir y cerrar la Consulta en puntos al azar de una partida simulada: el estado serializado es igual antes y después, y el resultado final coincide con el de la misma semilla sin Consulta |
| T-12 | Las semillas elegidas producen la situación buscada | Cada semilla de la partida guiada cumple su predicado (hay envido posible, hay flor, etc.) |
| T-13 | Los textos entran en el panel | A 1280×720, cada texto mide menos que el panel (medido con la fuente y el tamaño del tema) |
| T-14 | El reglamento está cubierto | Cada caso R-01 a R-55 aparece en al menos un ejercicio o entrada de la Consulta |

**Manuales**, con registro de resultados en la Fase 7:

- **M-01:** tres personas que no saben jugar completan los capítulos 1 a 5 y la partida guiada sin ayuda externa.
- **M-02:** lectura de todas las pantallas del capítulo en las cinco resoluciones previstas.
- **M-03:** recorrido completo solo con teclado.

## 12. Criterios de aceptación

El sistema de aprendizaje se acepta cuando:

1. T-01 a T-14 pasan ejecutadas en Godot.
2. M-01: al menos dos de las tres personas completan una partida contra la IA de nivel normal después del recorrido, sin consultar fuentes externas.
3. Ningún capítulo afirma una regla marcada como pendiente sin la etiqueta de provisional o de reglamento activo.
4. Cada opción de asistencia y cada control de la interfaz tiene un efecto comprobado.
5. No hay discrepancias abiertas entre el tutorial y el motor en DECISIONES.md.

## 13. Decisiones que requieren aprobación

| Id | Decisión propuesta |
|----|--------------------|
| TD-01 | Reordenar el índice: jerarquía antes que muestra, truco antes que envido, nuevo capítulo «Los puntos del partido», y práctica y consulta como modos y no como capítulo |
| TD-02 | Desbloqueo por requisitos, con prueba de dominio y opción «Desbloquear todo» |
| TD-03 | Tito como guía principal. Marta interviene en los cálculos, Rosario en las señas y Cacho pone a prueba a la persona. Washa aparece en algunos capítulos como compañero de aprendizaje que comete errores típicos para demostrarlos |
| TD-04 | Contenido en JSON con validador, y textos en español dentro de cada capítulo |
| TD-05 | Las respuestas de los ejercicios las calcula el motor y el contenido no escribe valores a mano, salvo los «esperados documentados» para contrastar |
| TD-06 | Los ejercicios de estrategia aceptan varias respuestas y se presentan como recomendación |
| TD-07 | Cuatro niveles de asistencia, con reducción automática después de tres aciertos seguidos por concepto |
| TD-08 | Indicadores de progreso sin porcentajes: estado del capítulo y práctica por concepto |
| TD-09 | Pregunta inicial de perfil que solo sugiere un recorrido |
| TD-10 | El contenido de los capítulos 7, 8 y 9 queda provisional hasta confirmar D-06 y la falta envido en malas |
