# Personajes y diálogos

Estado: **propuesta para revisión.** El elenco y las líneas de muestra fijan el tono. Las líneas definitivas se escriben e integran en la Fase 6.

## Principios de escritura

- **Voseo y habla rioplatense**, según el personaje: unos hablan más y otros menos, unos usan más modismos y otros casi ninguno.
- **Nada de caricatura.** No todas las frases llevan «bo» o «ta». Un modismo por cada dos o tres líneas, como mucho, en los personajes que hablan así.
- **El diálogo depende del contexto.** Cada línea se elige según el evento, el resultado, el personaje, la relación (compañero o rival) y el estado del partido (ventaja, desventaja, final cerrado).
- **El diálogo nunca revela información privada.** Un personaje no dice «tengo el dos». Puede fanfarronear o quedarse callado, pero su texto se elige por personalidad y azar. La IA no lo usa como canal secreto con su compañero (ver ARQUITECTURA.md, sección IA).
- **Lenguaje apto para todo público.** Se admite la picardía, no el insulto.
- **Ritmo.** Como máximo una línea por evento y por mesa, y ninguna cuando las animaciones están aceleradas o el diálogo está desactivado.

## Elenco inicial

Cinco personajes, de los que se eligen tres por partida: el compañero y dos rivales. Son personas comunes, no estereotipos de postal.

| Personaje | Arquetipo | Cómo habla | Cómo juega (IA) | Rasgo visual |
|-----------|-----------|------------|-----------------|--------------|
| **Tito**, 63, jubilado del puerto | Compañero confiado | Cálido, canchero, con dichos. Habla bastante. | Grita truco con manos medias, farolea seguido. Señas generosas y poco disimuladas. | Boina, bigote canoso |
| **Marta**, 56, maestra jubilada | Calculadora | Seca, precisa. Dice números. Ironía fina. | Cuenta cartas, casi no farolea, quiere el envido solo con buenos tantos. Señas muy disimuladas. | Lentes, pelo corto |
| **Cacho**, 41, de la barra del club | Rival que provoca | Chicanero, rápido, con picardía. | Canta para presionar, sube cuando el rival duda. Reacciona a los errores ajenos. | Campera deportiva, barba |
| **Rosario**, 34, enfermera | Reservada | Habla muy poco: «Quiero.», «Son buenas.», «Ta.» | Sólida y difícil de leer. Pocas señas, pero muy precisas. | Pelo atado, mirada fija |
| **Washington, «Washa»**, 24, estudiante | El que festeja de más | Eufórico, exagerado, pura emoción. | Impulsivo, muy expresivo. Su cara a veces lo delata (mayor probabilidad de que los rivales vean sus señas). | Gorro de lana, sonrisa grande |

La personalidad cambia decisiones dentro de lo legal (cuándo cantar, cuánto arriesgar, cuánto disimular) y nunca la información disponible. Los valores de cada personaje (agresividad, farol, prudencia, atención y disimulo) están en `juego/ia/perfil_ia.gd`.

## Líneas de muestra

Las situaciones están en `datos/dialogos.json` (Fase 6). Aquí van ejemplos para fijar las voces.

### Presentación y saludo

- **Tito:** «Buenas, buenas. Sentate que esta noche la llevamos.»
- **Marta:** «Buenas noches. A treinta, ¿no? Así no se nos hace tarde.»
- **Cacho:** «Llegó carne fresca. Bienvenido, eh.»
- **Rosario:** «Buenas.»
- **Washa:** «¡Vamo arriba! ¿Quién reparte? ¡Quiero jugar ya!»

### Reparto y comienzo de la mano

- **Tito:** «Mezclá bien, que la otra vez me tocaron puras negras.»
- **Marta:** «Muestra de copas. Ojo con el perico.»
- **Cacho:** «Dale que no tenemos toda la noche.»

### Cantos

- **Tito** (truco): «¡Truco! Y no me mires así.»
- **Marta** (envido): «Envido.»
- **Cacho** (retruco): «¡Quiero retruco! A ver ahora.»
- **Rosario** (falta envido): «Falta envido.»
- **Washa** (flor): «¡Flor! ¡Flor, flor, flor!»

### Respuestas

- **Tito** (quiero): «Quiero, ¿qué voy a hacer?»
- **Marta** (son buenas): «Son buenas.»
- **Marta** (no quiero): «No quiero. No hay con qué.»
- **Cacho** (no quiero, molesto): «No quiero… pero esta me la cobro.»
- **Rosario** (quiero): «Quiero.»

### Jugadas inesperadas

- **Marta** (el rival mata con una pieza): «Mirá vos. Lo tenía guardado.»
- **Cacho** (el compañero se jugó una carta alta antes de tiempo): «¿Y eso? ¿Qué hacés tirando el ancho en primera?»
- **Washa** (gana con un farol): «¡No tenía nada! ¡NADA!»

### Victoria, derrota y empate

- **Tito** (gana la mano): «Esa era nuestra desde que repartieron.»
- **Marta** (pierde por poco): «Treinta y tres contra treinta y cuatro. Pasa.»
- **Rosario** (gana el partido): «Buena partida.»
- **Washa** (parda): «¿Parda? ¡Noooo! Bueno, vamos que se define en la otra.»

### Señas y reacciones

- **Cacho** (ve una seña rival): «Uh, qué cara puso tu compañero…»
- **Marta** (su compañero hace una seña muy evidente): «Más disimulado, por favor.»

### Errores del jugador (solo el compañero, y solo con el modo de aprendizaje activado)

- **Tito:** «Ojo, que vos sos pie: dejame jugar a mí primero la próxima.»
- **Marta:** «Con veintinueve no se quiere una falta. Lo hablamos después.»

### Tensión

- **Cacho** (los dos equipos a un punto de ganar): «Acá se termina todo. ¿Te animás?»
- **Tito:** «Tranquilo, que con calma se gana.»

### Celebraciones y despedidas

- **Tito:** «¡Ganamos! Mañana a la misma hora.»
- **Cacho** (pierde): «Tuvieron suerte. La revancha la quiero ya.»
- **Rosario:** «Me voy. Gracias.»
- **Washa:** «¡Qué partidazo! ¡Otra, otra!»

## Reglas de selección de líneas

1. Un evento (canto, respuesta, baza, final) propone una situación.
2. Se filtran las líneas del personaje por situación y condiciones: resultado, relación, marcador, si el canto fue un farol, etc.
3. Se descartan las líneas usadas hace poco (memoria de las últimas N por personaje).
4. Se elige al azar entre las que quedan, ponderando por intensidad según el marcador.
5. Si no hay ninguna o el diálogo está desactivado, no se muestra nada. Un silencio es mejor que una frase fuera de contexto.

Para elegir la línea se usa información pública o del propio personaje, por ejemplo saber si su canto fue un farol. La línea mostrada nunca revela esa información.
