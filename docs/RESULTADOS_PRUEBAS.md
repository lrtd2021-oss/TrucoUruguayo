# Resultados de pruebas

Registro de las ejecuciones reales de las pruebas automáticas. Una prueba solo cuenta como pasada si figura aquí con su ejecución.

## 2026-10-25: cierre de la Fase 4

- **Comando:** `herramientas/pruebas.sh`.
- **Resultado:** 9 scripts, **79 pruebas, 79 pasadas**, 18.633 comprobaciones, 46 s, sin errores de script.
- **Nuevo:**
  - `test_senas.gd`: R-68 y la observación de señas (frecuencia medida: 0,40 esperado, dentro de ±0,04).
  - `test_ia.gd`:
    - acciones siempre legales;
    - 37 de 40 partidos contra la aleatoria;
    - decisiones iguales con distintas cartas ocultas;
    - personalidades;
    - elección de señas;
    - lectura de la seña del compañero;
    - señas no vistas;
    - asistente (T-10);
    - señas en el controlador.
- **Medición de fuerza (`herramientas/medir_ia.sh`, repartos espejados):**
  - contra la IA aleatoria, **862 de 1000 (86,2 %)**;
  - contra la IA básica, 129 de 200 (64,5 %);
  - decisión media de 5 a 6 ms y máxima de 45 ms (nivel normal).
- **Personalidades** (30 partidos), tasa de truco por oportunidad y faroles de truco:

  | Personaje | Tasa de truco | Faroles |
  |-----------|---------------|---------|
  | Tito | 0,55 | 23 |
  | Cacho | 0,49 | 25 |
  | Rosario | 0,42 | 11 |
  | Marta | 0,35 | 6 |

- **Seña del compañero (4.5):**
  - con «tengo el 2 de la muestra», estimación 1,00 y truco;
  - con «nada que valga», estimación 0,13 y juega sin gritar.
- **Clics reales:** «bien» a 1920×1080, 1366×768 y 1280×720.
- **Capturas:** la seña del compañero en el registro y el menú de señas.
- **Problemas encontrados y corregidos durante la fase:**
  - **Agujero en el script de pruebas:** un archivo que no compilaba pasaba sin fallar (D-26). Corregido y comprobado con un archivo roto a propósito.
  - **Decisiones de flor:** la IA se achicaba cuando le convenía querer. Ahora compara lo que gana y lo que arriesga.
  - **Desempate de cartas:** entre cartas casi igual de buenas jugaba cualquiera. Ahora juega la más baja.
  - **Inferencia de cantos:** quería retrucos y envidos rivales como si las cartas fueran al azar (D-25).
  - **Pruebas mal planteadas:** dos pruebas pedían decisiones fuera de turno o en una situación con envido posible. Se replantearon, y la IA ahora responde «no le toca» en lugar de fallar.

## 2026-10-25: cierre de la Fase 3

- **Comando:** `herramientas/pruebas.sh`.
- **Resultado:** 7 scripts, **64 pruebas, 64 pasadas**, 11.539 comprobaciones, 8,9 s, sin nodos huérfanos.
- **Nuevo, `test_mesa.gd`:**
  - clic doble y bloqueo durante la animación (3.2);
  - botones solo para acciones válidas (3.3);
  - 8 partidos completos jugados tocando la interfaz (3.4);
  - guion por asiento y pausa (3.5);
  - la regla D-15 en el controlador.
- **Clics reales en ventana:** `herramientas/probar_clics.sh` dio «bien» a 1920×1080, 1366×768 y 1280×720. Con un panel tapando la pantalla, la misma comprobación falló como debía (código 1).
- **Capturas revisadas:** 1280×720, 1366×768, 1920×1080 y 1920×1200. Problemas encontrados y corregidos:
  - el panel del registro tapaba al rival de la derecha;
  - los dorsos aparecían a tamaño completo, porque los contenedores anulan la escala de sus hijos;
  - la insignia de pieza se pisaba con el número de la esquina.

## 2026-10-25: cierre de la Fase 2

- **Entorno:** Godot 4.7.2.stable.official.ed1daf0bf (headless), GUT 9.7.1, Windows 11.
- **Comando:** `herramientas/pruebas.sh`
- **Resultado:** 6 scripts, **57 pruebas, 57 pasadas**, 11.242 comprobaciones, 4,7 s. Código de salida 0.

| Script | Casos |
|--------|-------|
| `test_cartas_muestra.gd` | R-01 a R-07 |
| `test_tantos.gd` | R-10 a R-17, R-20 a R-25 y desgloses de todos los ejemplos del reglamento (tarea 2.11) |
| `test_bazas.gd` | R-30 a R-36 |
| `test_cantos.gd` | R-40 a R-55 y el decisor fijo de D-15 |
| `test_estados.gd` | R-18, R-60 a R-66 y escenarios ilegales (tarea 2.11) |
| `test_simulacion.gd` | R-67 |

**Simulación R-67:** 1000 partidos con decisiones al azar, 8638 manos, sin acciones rechazadas, sin bloqueos, con las cartas conservadas y el tanteador coherente. Situaciones recorridas:

| Situación | Veces | Situación | Veces |
|-----------|-------|-----------|-------|
| Truco | 4045 | Flor declarada | 4215 |
| Retruco | 1688 | Envido anulado por flor | 1576 |
| Vale cuatro | 740 | Flor contra flor (comparación) | 231 |
| Envido | 1713 | Contraflor al resto | 149 |
| Real envido | 1827 | Con flor me achico | 108 |
| Falta envido | 2098 | Pardas | 70 |
| «Son buenas» | 1902 | Partido terminado por tantos a mitad de mano | 758 |
| Ir al mazo | 5641 | | |

**Validación del sistema de pruebas (tarea 2.1):** una prueba que fallaba a propósito devolvió el código de salida 1; con todo en verde, 0.

**Errores encontrados durante la fase:** todos fueron de los datos de prueba, no del motor.

- Dos manos de prueba tenían flor sin querer. El motor exigió declararla, como corresponde.
- Una carta estaba repetida entre dos manos. La validación de `Mano` lo detectó.

**No cubierto todavía:**

- R-68 (señas), que corresponde a la Fase 4.
- Las pruebas del tutorial (T-01 a T-14), de la Fase 6.
- Las advertencias comunes de GDScript (por ejemplo, variables sin usar) no se muestran en modo headless. Hay que revisarlas en el editor.
