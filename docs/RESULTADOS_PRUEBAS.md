# Resultados de pruebas

Registro de las ejecuciones reales de las pruebas automáticas. Una prueba solo cuenta como pasada si figura aquí con su ejecución.

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
