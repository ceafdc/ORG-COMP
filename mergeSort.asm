    .data
    .align 2
VETOR:       .word   51, 38, 41, 20, 44, 43, 31, 39, 53, 52, 27, 42, 33, 46, 37, 22, 26, 49, 35, 28, 30, 50, 32, 36, 55, 25, 24, 56, 23, 40, 29, 21, 48, 45, 34, 47, 54

    .text
    .align 2
    .globl main

main:

    la $a0, VETOR ## $a0 = &vetor[0]
    li $a1, 0     ## $a1 = inicio
    li $a3, 37    ## $a3 = tamanho

    move $t0, $a0

    li $v0, 9         #
    move $a0, $a3     # aloca um vetor auxiliar
    li $t1, 4         # usado no merge
    mul $a0, $a0, $t1 #
    syscall           #

    move $s0, $v0
    move $a0, $t0

    jal mergeSort

    move $a1, $a3

    jal printVetor

    li $v0, 10   #
    syscall      # exit


mergeSort:
    addi $sp, $sp, -28
    sw $s1, 24($sp)
    sw $s2, 20($sp)
    sw $a0, 16($sp) #vetor
    sw $a1, 12($sp) #inicio
    sw $a2, 8($sp)  #meio
    sw $a3, 4($sp)  #fim
    sw $ra, 0($sp)

    sub $t0, $a3, $a1
    addi $s1, $t0, -5
    bltzal $s1, ajustaBubble # se tam < 5 faz bubbleSort
    bltz $s1, desempilha

    move $s1, $a3    # manter valor do fim

    add $t1, $a1, $a3
    li $t0, 2
    div $a2, $t1, $t0  # $a2 = $a3 / 2

    move $a3, $a2
    #                  #a0    #a1    #a3
    jal mergeSort  # (vetor*, inicio, meio)

    move $a3, $s1   #manter valor do fim

    move $s1, $a1
    move $a1, $a2
    #                  #a0    #a1     #a3
    jal mergeSort  # (vetor*,meio + 1, fim)
    move $a1, $s1


    la $a0, VETOR

    jal merge

desempilha:
    lw $s1, 24($sp)
    lw $s2, 20($sp)
    lw $a0, 16($sp) #vetor
    lw $a1, 12($sp)  #inicio
    lw $a2, 8($sp)   #meio
    lw $a3, 4($sp)  #fim
    lw $ra, 0($sp)
    addi $sp, $sp, 28
    jr $ra

ajustaBubble:
    addi $sp, $sp, -16
    sw $a0, 12($sp) #vetor
    sw $a3, 8($sp) #fim
    sw $a1, 4($sp) #inicio
    sw $ra, 0($sp)

    li $t0, 4
    mul $t0, $a1, $t0
    add $a0, $a0, $t0 # &vetor[inicio]

    sub $a1, $a3, $a1 # fim - inicio = tamanho

    jal bubbleSort

    #jal printVetor

    lw $a0, 12($sp) #inicio
    lw $a3, 8($sp) #tamanho
    lw $a1, 4($sp) #meio
    lw $ra, 0($sp)
    addi $sp, $sp, 16
    jr $ra