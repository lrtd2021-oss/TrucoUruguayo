# Reglamento del truco uruguayo

Este documento fija el reglamento que implementa el juego. Es la referencia única para el motor de reglas, la IA, el tutorial y las pruebas. Si el código y este documento no coinciden, hay un error en uno de los dos y se corrige antes de seguir.

Estado: **borrador para revisión (Fase 1)**. Las decisiones marcadas como *pendientes de confirmación* se pueden cambiar sin rehacer la arquitectura, porque se expresan como opciones de configuración del reglamento.

## 1. Criterio y fuentes

No existe un reglamento oficial único del truco uruguayo. No encontré una federación que publique uno, y cada mesa, club o campeonato fija sus propias bases. Por eso el reglamento base se construyó así:

1. Se toma como válido lo que coincide en **varias fuentes uruguayas o específicas de la variante uruguaya**.
2. Cuando hay discrepancia, se elige la opción más extendida o la más coherente con el resto del sistema, y se registra la alternativa como variante.
3. Las reglas argentinas solo se usan para aspectos de procedimiento en los que las fuentes uruguayas no dicen nada (por ejemplo, el orden de los cantos), y cuando no contradicen a una fuente uruguaya.

| Id | Fuente | Tipo | Uso |
|----|--------|------|-----|
| F1 | McLeod, J. (2022). *Uruguayan Truco*. Pagat.com. https://www.pagat.com/put/truco_ur.html | Referencia de juegos de cartas, basada en el aporte de un jugador | Muestra, piezas, rey de la muestra, valores, señas |
| F2 | McLeod, J. (s. f.). *Argentinean Truco*. Pagat.com. https://pagat.com/put/truco_ar.html | Referencia, variante argentina | Procedimiento de cantos, pardas, envido no querido |
| F3 | *Truco uruguayo* (s. f.). Wikipedia en español. https://es.wikipedia.org/wiki/Truco_uruguayo | Enciclopedia (cita reglamentos de retruco.com y GranAventura) | Jerarquía, valores, flor, malas y buenas, señas, variantes |
| F4 | Ludoteka (s. f.). *Truco Uruguayo: reglas del juego*. https://www.ludoteka.com/games/truco-uruguayo/rules | Plataforma de juego | Jerarquía completa, envido, flor, pardas |
| F5 | Conecta Games (2015). *Reglas del Truco Uruguayo*. https://conectagamesblog.wordpress.com/2015/12/17/reglas-del-truco-uruguayo/ | Plataforma de juego uruguaya | Valores, envido, truco, empates |
| F6 | Franchi Ugartemendía, A. (2026, 4 de abril). *Truco uruguayo: reglamento*. ServicioTI. https://www.servicioti.com.uy/2026/04/truco-uruguayo-reglamento.html | Blog uruguayo | Tabla de envido, flor, señas, glosario |
| F7 | Olveira Ramos, A. (2011, 28 de noviembre). *Truco uruguayo, un invento del gaucho oriental*. Crónicas Migrantes. http://armandolveira.blogspot.com/2011/11/truco-uruguayo-un-invento-del-gaucho.html | Blog; cita *Inventos Uruguayos* (El País, 2011) y Guarnieri (1970) | Alcahuete, flor, falta envido, señas, glosario |
| F8 | Truqui (s. f.). *La flor y la contraflor en el truco uruguayo*. https://www.truqui.app/la-flor-y-la-contraflor | Aplicación uruguaya | Flor contra flor, contraflor al resto |
| F9 | Documentación oficial del motor (ver ARQUITECTURA.md y EVALUACION_MOTOR.md) | Documentación técnica | Aspectos técnicos, no de reglas |

Fuentes descartadas o usadas con cautela:

- TrucoBits (2026), *Diferencia entre truco argentino y uruguayo*: afirma que la jerarquía uruguaya es igual a la argentina y no menciona la muestra. Contradice a todas las demás fuentes, así que no se usa.
- Wikipedia en inglés, artículo *Truco*: asigna 30 y 29 puntos al caballo y a la sota (perico y perica). Eso corresponde a la variante del litoral argentino y venezolana, no a la uruguaya con cinco piezas.
- Sitios de preguntas genéricas (laps4.com): mezclan variantes y asignan a la sota un valor distinto del de las fuentes uruguayas.

## 2. Baraja

- Baraja española de **40 cartas**: se quitan los 8, los 9 y los comodines.
- Cuatro palos: **oros (O), copas (C), espadas (E) y bastos (B)**.
- Cada palo tiene: 1, 2, 3, 4, 5, 6, 7, 10 (sota), 11 (caballo) y 12 (rey).
- Notación del proyecto: número seguido del palo. `1E` es el as de espadas, `11O` es el caballo de oros.

## 3. Muestra, piezas y alcahuete

**Muestra.** Después de repartir tres cartas a cada jugador se da vuelta la carta siguiente del mazo, que queda a la vista de todos. Su palo es el **palo de la muestra** (F1, F3, F4).

**Piezas.** Las cinco cartas del palo de la muestra que se convierten en las más altas (F1, F3, F4, F5, F6, F7):

| Pieza | Nombre popular | Poder en el truco | Valor para envido y flor |
|-------|----------------|-------------------|--------------------------|
| 2 de la muestra | el dos | 1.º (la carta más alta) | 30 |
| 4 de la muestra | el cuatro | 2.º | 29 |
| 5 de la muestra | el cinco | 3.º | 28 |
| 11 de la muestra | perico | 4.º | 27 |
| 10 de la muestra | perica | 5.º | 27 |

Algunas fuentes (F1) expresan los valores como 10, 9, 8, 7 y 7, y suman los 20 por separado. Es la misma cuenta; el proyecto usa 30, 29, 28, 27 y 27.

**Alcahuete.** El rey (12) del palo de la muestra se llama alcahuete. Si la carta que quedó como muestra es una pieza, esa pieza no está en juego, y el alcahuete **toma su lugar**: adopta su poder en el truco, su valor para envido y flor y su seña. Así las cinco piezas están siempre en juego (F1, F3, F7). Si la muestra no es una pieza, el 12 de la muestra es un rey común.

Ejemplo: muestra 4O. El 12O vale 29, es la segunda carta más alta y se señala con el beso. Las demás piezas (2O, 5O, 11O y 10O) no cambian.

## 4. Jerarquía para el truco

De mayor a menor. Las cartas de un mismo grupo empatan entre sí.

| Orden | Grupo | Cartas |
|-------|-------|--------|
| 1 | Pieza | 2 de la muestra |
| 2 | Pieza | 4 de la muestra |
| 3 | Pieza | 5 de la muestra |
| 4 | Pieza | 11 de la muestra |
| 5 | Pieza | 10 de la muestra |
| 6 | Mata | 1E (espadilla, «el ancho») |
| 7 | Mata | 1B (bastillo) |
| 8 | Mata | 7E |
| 9 | Mata | 7O |
| 10 | Chica | los cuatro 3 |
| 11 | Chica | los 2 que no son pieza |
| 12 | Chica | 1C y 1O (ases falsos) |
| 13 | Negra | los 12 que no hacen de alcahuete |
| 14 | Negra | los 11 que no son pieza |
| 15 | Negra | los 10 que no son pieza |
| 16 | Común | 7C y 7B (sietes falsos) |
| 17 | Común | los 6 |
| 18 | Común | los 5 que no son pieza |
| 19 | Común | los 4 que no son pieza |

Notas:

- Las matas no cambian con la muestra. Con muestra de espadas, el 1E y el 7E siguen siendo matas; las piezas son el 2E, 4E, 5E, 11E y 10E.
- Fuentes: F1 da el orden piezas, matas, 3 y 2; F4 da la tabla completa, que coincide con F3 y F7.

## 5. Tantos: envido y flor

### 5.1 Valor de cada carta

| Carta | Valor |
|-------|-------|
| Piezas (y alcahuete activo) | 30, 29, 28, 27, 27 según la tabla del punto 3 |
| 1 a 7 que no son pieza | su número |
| 10, 11 y 12 que no son pieza | 0 |

### 5.2 Envido

Se calcula con las tres cartas y se toma el mejor resultado posible (F4, F5, F6, F7):

1. **Con una pieza:** valor de la pieza + el valor de la carta más alta de las otras dos.
2. **Sin pieza, con dos cartas del mismo palo:** 20 + la suma de esas dos.
3. **Sin pieza y con tres palos distintos:** el valor de la carta más alta.

Rango: de 0 a 37 (2 de la muestra y un 7).

Con dos piezas, o con una pieza y dos cartas del mismo palo, la mano tiene flor (punto 5.3). Como la flor anula el envido, esos casos nunca se calculan como envido.

### 5.3 Flor

**Cuándo se tiene flor** (F1, F4, F5, F6):

- tres cartas del mismo palo;
- dos o tres piezas;
- una pieza y dos cartas del mismo palo entre sí.

**Valor de la flor** (F4, F5, F6):

- La pieza más alta cuenta su valor completo (30, 29, 28 o 27).
- Las demás piezas cuentan solo su unidad: 10, 9, 8 o 7 (su valor menos 20).
- Las cartas que no son pieza cuentan su valor normal (figuras 0).
- Sin piezas: 20 + la suma de las tres cartas.

Rango: de 20 a 47 (2, 4 y 5 de la muestra).

## 6. Desarrollo de una mano

- Juegan cuatro personas en dos parejas. Los compañeros se sientan enfrentados y los turnos alternan entre parejas.
- El reparto y el juego van en **sentido antihorario**. El jugador a la derecha de quien reparte es **mano** y juega primero. Quien reparte es el **pie** de la vuelta.
- Se reparten tres cartas a cada jugador y se da vuelta la muestra.
- Una mano tiene hasta tres **bazas**. En cada baza, cada jugador juega una carta. El que juega primero en la primera baza es la mano; en las siguientes, el que ganó la baza anterior.
- Gana la mano la pareja que gana dos bazas. La tercera no se juega si ya hay un ganador.
- Tras cada mano, el reparto pasa al jugador de la derecha.

### 6.1 Quién gana una baza

- Gana la carta de mayor poder según el punto 4.
- Si las cartas más altas son de la misma pareja, la baza es de esa pareja.
- Si las cartas más altas son iguales y de parejas distintas, la baza es **parda**. La siguiente la abre el mismo jugador que abrió la baza parda (F2).

### 6.2 Resolución con pardas

Confirmado por F2, F4 y F5:

| Situación | Ganador de la mano |
|-----------|--------------------|
| Una pareja gana dos bazas | esa pareja |
| Parda en la 1.ª | quien gane la 2.ª; si también es parda, quien gane la 3.ª |
| Parda en la 2.ª o en la 3.ª | quien ganó la 1.ª |
| Tres pardas | la pareja del jugador mano |

## 7. Envido

### 7.1 Cuándo se puede cantar

- Solo durante la **primera baza**, en el turno propio y antes de jugar la propia carta (F2, F5, F6).
- No se puede cantar si ya se declaró una flor en la mano (F3, F4, F5).
- No se puede abrir después de que se haya **querido** un truco.
- **«El envido está primero»:** si alguien grita truco en la primera baza, la pareja que responde puede cantar envido antes de contestar el truco. Se resuelve el envido y después se responde el truco (F2, F7).

### 7.2 Secuencia de cantos

Una secuencia válida tiene, en este orden, hasta dos **envido**, hasta un **real envido** y, al final, una **falta envido** (F2). Cada canto lo hace la pareja que acaba de recibir el anterior. La falta envido no se puede subir.

| Secuencia | Si se quiere | Si no se quiere (para quien cantó último) |
|-----------|--------------|-------------------------------------------|
| Envido | 2 | 1 |
| Real envido | 3 | 1 |
| Envido, envido | 4 | 2 |
| Envido, real envido | 5 | 2 |
| Envido, envido, real envido | 7 | 4 |
| Falta envido (sola) | la falta | 1 |
| … y luego falta envido | la falta | la suma de lo ya cantado y aceptado antes de la falta |

Regla general del rechazo: quien no quiere entrega lo que valía la secuencia antes del último canto, y 1 si el último canto era el primero (F2, F5, F6).

### 7.3 Falta envido

Vale los puntos que le faltan a la pareja que va ganando para llegar al final del partido (F3, F4, F5, F6, F8).

*Variante documentada (F7):* si las dos parejas están en malas, la falta vale lo que le falta al puntero para terminar las malas. **Pendiente de confirmación** (ver punto 13).

### 7.4 Comparación de los tantos

- Se declaran en orden a partir del jugador mano. Cada jugador declara su tanto solo si supera el mejor tanto de la pareja contraria ya declarado. Si no lo supera, dice «son buenas».
- Gana el tanto más alto. **Empate: gana el más cercano a la mano** en el orden de juego (F2, F5, F7).
- Al terminar la mano se muestran las cartas que respaldan el tanto ganador, si todavía no se jugaron.
- En el juego digital los tantos los calcula el motor, de modo que no se puede declarar un tanto falso. Ver DECISIONES.md, D-07.

## 8. Flor

### 8.1 Reglas generales

- La flor **se juega siempre** y es obligatoria: quien la tiene la canta en su primer turno, antes de jugar su primera carta (F4, F5, F8).
- Una flor declarada anula el envido de esa mano, aunque ya se hubiera cantado (F3, F4, F5).
- Si el truco se grita antes de que alguien con flor la declare, primero se resuelve la flor (F2, F7).
- Si dos compañeros tienen flor, cada uno la declara y cada una cuenta (colleras; F3).

### 8.2 Puntuación (reglamento base)

| Situación | Puntos |
|-----------|--------|
| Solo una pareja tiene flor | 3 por cada flor declarada por esa pareja |
| Las dos parejas tienen flor y nadie sube (flor contra flor) | la mejor flor gana 3 por cada flor declarada en la mesa (6 con una flor por pareja) |
| Una pareja se achica («con flor me achico») | la otra pareja suma 3 por cada flor propia; la que se achica no suma |
| Contraflor al resto, querida («con flor quiero») | la mejor flor gana la falta (punto 7.3) |
| Contraflor al resto, no querida | equivale a achicarse: quien la cantó suma 3 por cada flor propia |
| Empate de flores | gana la más cercana a la mano |

Secuencia cuando las dos parejas tienen flor:

1. La primera pareja declara su flor.
2. La segunda pareja, al declarar la suya, elige entre *flor* (queda flor contra flor), *contraflor al resto* o *con flor me achico*.
3. Si la segunda solo declaró, la primera puede cantar *contraflor al resto* o achicarse. Si no hace nada, queda flor contra flor.
4. A una contraflor al resto se responde *con flor quiero* o *con flor me achico*.

Base documental: F8 da el valor de flor contra flor (6) y de la contraflor al resto no querida (3). F7 confirma «con flor quiero: 6 tantos» y que la contraflor al resto define el partido. F2 aporta la secuencia de respuestas. El reparto de 3 puntos por flor en las colleras sigue a F2, porque las fuentes uruguayas no lo explican. **Pendiente de confirmación** (ver punto 13).

*Variantes documentadas, no incluidas en el reglamento base:* «con flor envido» y «con flor envido la falta» (F3, F4), y la contraflor simple de 6 tantos como canto aparte (reglamentos argentinos).

## 9. Truco

| Canto | Si se quiere | Si no se quiere (para quien cantó) |
|-------|--------------|------------------------------------|
| Sin truco | 1 | — |
| Truco | 2 | 1 |
| Retruco | 3 | 2 |
| Vale cuatro | 4 | 3 |

Fuentes: F2, F3, F4, F5, F6, F7.

- Cualquier jugador puede gritar truco en su turno, antes de jugar su carta.
- Solo puede subir la pareja que **quiso** el último canto. Los cantos alternan entre parejas (F2, F5).
- Se puede responder a un canto con *quiero*, *no quiero* o con la subida siguiente. Subir implica querer el canto anterior («quiero retruco»). Ver DECISIONES.md, D-08.
- Una pareja que ya quiso puede subir más adelante, en el turno de alguno de sus jugadores.
- **Irse al mazo:** abandonar la mano. Equivale a no querer: la otra pareja suma lo que vale el truco en ese momento (1 si no hubo truco, o lo que corresponda por un canto pendiente). En el reglamento base, irse al mazo en la primera baza no tiene penalidad adicional por el envido. Los tantos ya resueltos se mantienen.

## 10. Partido, malas y buenas

- El partido es **a 30 puntos**: 15 malas y 15 buenas (F2, F5, F7). Opción configurable: a 40, con 20 malas y 20 buenas (F3, F5, F6).
- Orden de anotación dentro de una mano: flor, envido y truco (F2).
- **Si una pareja llega al total, el partido termina en ese momento**, aunque la mano no haya terminado (F2).
- Tanteador tradicional con fósforos agrupados en cuadrados de cinco (F7); ver DIRECCION_ARTISTICA.md.

## 11. Señas

Las señas son gestos para pasarle información al compañero. Forman parte legítima del juego. Está prohibido mostrar las cartas o decir lo que se tiene. Los rivales pueden ver una seña si están atentos (F1, F6, F7).

### 11.1 Perfil de señas inicial («clásico uruguayo»)

| Cartas | Seña | Coincidencia |
|--------|------|--------------|
| 2 de la muestra | levantar las cejas | F1, F3, F6, F7 |
| 4 de la muestra | beso (labios hacia adelante) | F1, F3, F6, F7 |
| 5 de la muestra | arrugar la nariz | F1, F3, F6 (F7: labio superior hacia arriba) |
| 11 de la muestra (perico) | guiño del ojo derecho | F1, F3, F6, F7 |
| 10 de la muestra (perica) | guiño del ojo izquierdo | F1, F3, F6, F7 |
| 1E o 1B | mueca con la boca hacia la derecha | F1, F3, F6, F7 |
| 7E o 7O | mueca con la boca hacia la izquierda | F1, F3, F6, F7 |
| cualquier 3 | morder el labio inferior | F1, F3, F6, F7 |
| cualquier 2 que no sea pieza | abrir apenas la boca | F1, F3, F6, F7 |
| 1C o 1O | asomar la punta de la lengua | F3, F6, F7 |
| nada que valga | cerrar los dos ojos | F1, F3, F6, F7 |
| flor | inflar los cachetes | F6 (una sola fuente) |

Reglas del perfil:

- El alcahuete activo se señala con la seña de la pieza que reemplaza. Es una deducción del punto 3, no una regla explícita de las fuentes.
- La seña de flor tiene una sola fuente. Se incluye porque es simple y no entra en conflicto con otra. Las señas de puntos de envido (F6 menciona lamer el labio superior) quedan fuera del perfil inicial por falta de confirmación.
- La arquitectura admite otros perfiles de señas (ver ARQUITECTURA.md). En una partida hay un solo perfil activo, y el apartado de consulta muestra cuál es.

### 11.2 Sobre las «marcas de cartas»

Esta expresión tiene cuatro significados, y conviene no confundirlos:

1. **Diseño gráfico de las cartas:** el dibujo de palos, números y figuras. El proyecto diseña una baraja original (DIRECCION_ARTISTICA.md).
2. **Marcas de identificación legítimas:** índices en las esquinas y un indicador visual de pieza para la carta en la mano propia. Son ayudas de lectura que solo ve quien tiene la carta.
3. **Señas tradicionales:** gestos entre compañeros, documentados en 11.1.
4. **Cartas marcadas para hacer trampa:** dorsos con información oculta. **No se implementa.** Todos los dorsos son idénticos, y la IA no puede obtener información de ellos.

Si con «marcas» se quería decir otra tradición concreta, se documentará antes de implementarla.

## 12. Glosario

| Término | Significado |
|---------|-------------|
| Mano | 1) Cada reparto con sus tres bazas. 2) El jugador que juega primero. |
| Pie | Último en jugar de cada pareja; suele dirigir las decisiones de su pareja. |
| Baza | Cada una de las tres vueltas de cartas de una mano (también «ronda»). |
| Parda | Baza empatada. |
| Gritar / tocar / cantar | Cantar truco / envido / flor (F6). |
| Matar | Jugar una carta que supera a las ya jugadas. |
| Ir al mazo | Abandonar la mano. |
| Son buenas | Reconocer que el tanto rival es mejor sin declarar el propio. |
| Achicarse | Ceder la flor con «con flor me achico». |
| Colleras / trilleras | Dos o tres compañeros con flor (F3). |
| Echar los perros | Desafío previo al reparto (F5, F6, F7); fuera del alcance inicial. |
| Pico a pico | Manos uno contra uno en el partido de seis (F3, F6); fuera del alcance inicial. |
| Dormir afuera | No llegar a las buenas (F7). |

## 13. Decisiones pendientes de confirmación

Estas decisiones no impiden diseñar ni programar, porque se implementan como opciones de un único perfil de reglamento. Sí conviene confirmarlas antes de cerrar la Fase 2, idealmente con la forma de jugar de tu propia mesa:

1. **Puntos de la flor con dos parejas con flor** (8.2): flor contra flor a 6 y contraflor al resto no querida a 3 (F8), frente a la variante argentina, que da 4 y 6.
2. **Falta envido en malas** (7.3): lo que le falta al puntero para ganar el partido (mayoría) o para terminar las malas (F7).
3. **Largo del partido:** a 30 (15 y 15) como base o a 40 (20 y 20).
4. **Irse al mazo en la primera baza sin haber cantado envido:** sin penalidad (base) o con la penalidad de algunas mesas.

## 14. Casos que serán pruebas automatizadas

Convención: muestra indicada entre corchetes. Cada caso tiene un identificador que se repetirá en el código de pruebas.

### Baraja y jerarquía

- **R-01:** la baraja tiene 40 cartas distintas y ningún 8, 9 o comodín.
- **R-02** [3O]: las piezas son 2O, 4O, 5O, 11O y 10O, y el 12O es un rey común.
- **R-03** [4O]: el 12O es alcahuete, tiene poder 2.º y vale 29. El 2O, 5O, 11O y 10O siguen siendo piezas.
- **R-04** [12O]: no hay alcahuete y las piezas son las cinco normales.
- **R-05** [cualquiera]: el orden completo del punto 4 se cumple para las 40 cartas, sin empates entre grupos distintos.
- **R-06** [3E]: el 1E y el 7E son matas y no piezas, y el 2E es la carta más alta.
- **R-07** [3O]: el 3C y el 3E empatan; el 7C y el 7B empatan; el 1C y el 1O empatan.

### Envido

- **R-10** [3O]: 4O, 3B, 6C → 35 (29 + 6).
- **R-11** [3O]: 7E, 3E, 6O → 30 (20 + 7 + 3).
- **R-12** [3O]: 6B, 3C, 12E → 6.
- **R-18:** la carta de la muestra nunca está en la mano de un jugador.
- **R-13** [3O]: 4O, 1B, 1O → 30 (29 + 1).
- **R-14** [3O]: 2O, 7C, 12B → 37 (máximo).
- **R-15** [4O]: 12O (alcahuete), 7E, 5C → 36 (29 + 7).
- **R-16** [3O]: 12C, 11E, 10B → 0.
- **R-17** [3O]: 10C, 11C, 5E → 20 (20 + 0 + 0).

### Flor

- **R-20** [3O]: 7B, 6B, 3B → flor de 36.
- **R-21** [3O]: 2O, 4O, 5O → flor de 47.
- **R-22** [3O]: 2O, 10O, 12C → flor de 37 (30 + 7 + 0).
- **R-23** [3O]: 5O, 7C, 6C → flor de 41 (28 + 7 + 6).
- **R-24** [3O]: 4O, 3B, 6C → no hay flor.
- **R-25** [4O]: 12O, 2O, 1E → flor de 40 (30 + 9 + 1).

### Bazas y pardas (cuatro jugadores)

- **R-30:** en una baza, el 3O del equipo A y el 3C del equipo B son las cartas más altas → parda.
- **R-31:** las dos cartas más altas son del mismo equipo e iguales → gana ese equipo.
- **R-32:** parda en la 1.ª y A gana la 2.ª → gana A sin jugar la 3.ª.
- **R-33:** A gana la 1.ª, B gana la 2.ª y la 3.ª es parda → gana A.
- **R-34:** A gana la 1.ª y la 2.ª es parda → gana A sin jugar la 3.ª.
- **R-35:** tres pardas → gana la pareja del jugador mano.
- **R-36:** después de una parda, abre la baza siguiente el mismo jugador que abrió la parda.

### Cantos y puntuación

- **R-40:** envido no querido → 1 para quien cantó.
- **R-41:** envido, envido, real envido no querido → 4 para quien cantó el real envido.
- **R-42:** envido, real envido, querido → 5 para el mejor tanto.
- **R-43:** tanteador 22 a 10, falta envido querida → vale 8. Si la gana el que tiene 10, queda 22 a 18. Si la gana el puntero, llega a 30 y gana el partido.
- **R-44:** envido y luego falta envido no querida → 2 para quien cantó la falta.
- **R-45:** empate de tantos → gana el jugador más cercano a la mano.
- **R-46:** truco no querido → 1. Truco querido y retruco no querido → 2. Vale cuatro querido → 4 al ganador de la mano.
- **R-47:** la pareja que gritó truco no puede cantar retruco.
- **R-48:** después de querer el truco no se puede abrir el envido.
- **R-49:** truco en la primera baza → la pareja que responde puede cantar envido primero; el truco se responde después.
- **R-50:** una flor declarada anula un envido cantado antes.
- **R-51:** solo una pareja tiene flor → 3 puntos. Colleras sin flor rival → 6.
- **R-52:** flor contra flor → 6 para la mejor flor. Empate → la más cercana a la mano.
- **R-53:** contraflor al resto querida → la mejor flor gana la falta. No querida → 3 para quien la cantó.
- **R-54:** irse al mazo con truco querido → la otra pareja suma 2.
- **R-55:** un equipo con 28 gana un envido de 2 → llega a 30 y el partido termina sin jugar el resto de la mano.

### Estados, turnos e información

- **R-60:** no se puede jugar una carta fuera de turno.
- **R-61:** con un canto pendiente de respuesta, solo valen las respuestas permitidas por ese canto.
- **R-62:** no se puede cantar envido en la segunda baza.
- **R-63:** quien tiene flor no puede jugar su primera carta sin declararla.
- **R-64:** aplicar dos veces la misma acción (doble clic) no cambia el estado la segunda vez.
- **R-65:** la vista de un jugador no contiene las cartas ocultas de los demás.
- **R-66:** con la misma semilla, el reparto es siempre idéntico.
- **R-67:** mil partidas IA contra IA con semillas distintas terminan sin bloqueos ni acciones ilegales.
- **R-68:** cada seña del perfil activo se traduce en el conjunto de cartas documentado en 11.1, y el alcahuete usa la seña de la pieza que reemplaza.
