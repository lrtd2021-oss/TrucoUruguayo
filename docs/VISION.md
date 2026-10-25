# Visión del producto

## Qué es

Un videojuego de truco uruguayo para PC, con muestra, piezas, flor y señas, en el que se juega en pareja contra dos rivales controlados por la computadora. La idea es reproducir lo que pasa en una mesa de verdad: gente con su forma de jugar, sus gestos, sus silencios y sus discusiones por los tantos.

## Para quién

- **Quien ya juega al truco uruguayo** y quiere una partida fiel cuando no tiene con quién jugar. Para esta persona, la exigencia principal es que las reglas estén bien y que la IA no haga trampa.
- **Quien conoce el truco argentino** pero no la muestra. Necesita ver con claridad qué cartas son piezas en cada mano.
- **Quien nunca jugó.** Necesita un modo de aprendizaje que explique las reglas y las señas sin obligarlo a leer un manual.

## Experiencia buscada

1. **Sentarse a una mesa.** La pantalla muestra una mesa con tres personas reconocibles: tu compañero enfrente y los rivales a los costados. Las cartas propias están cerca y el resto de la información está a la vista sin tapar el juego.
2. **Leer a los demás.** Las señas son una mecánica real. Tu compañero te las hace y vos se las podés hacer a él. Si mirás a los rivales en el momento justo, podés descubrir las suyas, y ellos pueden descubrir las tuyas.
3. **Personalidad sin trampa.** Cada rival juega distinto (uno arriesga, otro calcula, otro provoca), pero todos respetan las reglas y solo usan la información que tendría una persona en su lugar.
4. **Ritmo de mesa.** Los diálogos acompañan sin frenar. Se pueden acelerar u omitir.
5. **Aprender jugando.** Un sistema de aprendizaje por capítulos lleva desde cero hasta el partido completo. Tiene cuatro modos: Aprender, Practicar, Partida guiada y Consulta. Cada capítulo enseña una competencia concreta y la comprueba con acciones en la mesa, usando el mismo motor de reglas que las partidas. Detalle en TUTORIAL.md.

## Identidad

Uruguaya sin depender de banderas ni postales: el club de barrio o el boliche, el termo bajo el brazo, el tanteador con fósforos, el voseo y el humor seco. La dirección artística se discute en DIRECCION_ARTISTICA.md.

## Alcance de la primera versión (1.0)

Incluye:

- Partida offline de cuatro jugadores: persona y compañero IA contra dos rivales IA.
- Reglamento uruguayo completo según REGLAS_TRUCO_URUGUAYO.md, con las opciones documentadas allí.
- Sistema de señas jugable, con perfil clásico y consulta.
- IA con tres niveles de dificultad y personalidades diferenciadas.
- Sistema de aprendizaje: 13 capítulos, lecciones avanzadas, práctica por concepto, partida guiada con asistencia decreciente y consulta disponible también durante las partidas.
- Menús, configuración persistente, audio con volúmenes separados y opciones de accesibilidad que funcionan.
- Windows, pantalla horizontal, resoluciones de escritorio.

No incluye (posibles ampliaciones):

- Multijugador en línea o local.
- Partidas de dos o de seis jugadores (pico a pico).
- Echar los perros, con flor envido y otras variantes regionales que no estén en el reglamento base.
- Otras plataformas.

## Herramientas al servicio del producto

El motor y las herramientas se eligen según lo que permita hacer el mejor juego posible (auténtico, atractivo, sólido, ampliable y comercialmente viable en Steam), no por haber sido la primera propuesta ni por ser los más cómodos de programar. GameMaker fue la propuesta inicial. Después de compararlo con Godot y Unity (EVALUACION_MOTOR.md), se eligió **Godot 4.7.2** (D-17), antes de escribir código específico.

## Qué significa «terminado»

Ver los criterios de calidad de ROADMAP.md. En resumen: reglas verificadas por pruebas, partidas completas sin bloqueos, identidad visual coherente, una persona nueva puede aprender a jugar dentro del juego, y existe un ejecutable probado con instrucciones para compilarlo.
