# Laboratorio: Estructura de Computadores
# Actividad: Optimización de Pipeline en Procesadores MIPS
# Objetivo: Calcular Y[i] = A * X[i] + B e identificar y reducir riesgos de datos.

.data
    vector_x: .word 1, 2, 3, 4, 5, 6, 7, 8     # Vector de entrada X con 8 valores
    vector_y: .space 32                         # Espacio para 8 enteros (8 * 4 bytes)
    const_a:  .word 3                           # Constante A
    const_b:  .word 5                           # Constante B
    tamano:   .word 8                           # Tamaño del vector

.text
.globl main

main:
    # --- Inicialización ---
    la $s0, vector_x                            # Dirección base del vector X
    la $s1, vector_y                            # Dirección base del vector Y
    lw $t0, const_a                             # Cargar constante A en $t0
    lw $t1, const_b                             # Cargar constante B en $t1
    lw $t2, tamano                              # Cargar el tamaño del vector en $t2
    li $t3, 0                                   # Índice i = 0

loop:
    # --- Condición de salida ---
    beq $t3, $t2, fin                           # Si i == tamano, salir del bucle

    # --- Cálculo de dirección de memoria ---
    sll $t4, $t3, 2                             # t4 = i * 4, desplazamiento en bytes
    addu $t5, $s0, $t4                          # t5 = dirección de X[i]

    # --- Carga de dato ---
    lw $t6, 0($t5)                              # Cargar X[i] desde memoria en $t6

    # --- Instrucciones independientes ---
    # Estas instrucciones no dependen del valor cargado en $t6.
    # Se colocan aquí para separar el lw de la operación mul
    # y reducir el riesgo Load-Use en el pipeline.
    addu $t9, $s1, $t4                          # t9 = dirección de Y[i]
    addi $t3, $t3, 1                            # Incrementar el índice i = i + 1

    # --- Operación aritmética ---
    mul $t7, $t6, $t0                           # t7 = X[i] * A
    addu $t8, $t7, $t1                          # t8 = t7 + B

    # --- Almacenamiento del resultado ---
    sw $t8, 0($t9)                              # Guardar Y[i] = X[i] * A + B

    # --- Volver al bucle ---
    j loop                                      # Repetir el proceso para el siguiente elemento

fin:
    # --- Finalización del programa ---
    li $v0, 10                                  # Código de syscall para finalizar el programa
    syscall                                     # Finalizar la ejecución
