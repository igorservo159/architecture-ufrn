# Aluno: João Igor Ramos de Lima
# Matrícula: 20220050698

.data

.align 2
array: .space 40                # Espaço para armazenar 10 inteiros (40 bytes)

.text

main:

  la $s0, array                 # Carrega o endereço base do vetor em $s0
  li $t0, 10                    # Número de elementos do array

#Geração e armazenamento de números aleatórios

generate_random:
  li $v0, 42                    # Syscall para gerar número aleatório
  li $a0, 1			# Teste seed
  li $a1, 255                   # Limite superior (0 a 255)
  syscall

  sw $a0, 0($s0)                # Armazena o número aleatório no array
  addi $s0, $s0, 4              # Avança para a próxima posição do array
  subi $t0, $t0, 1              # Decrementa contador
  bgtz $t0, generate_random     # Loop até completar os 10 números - branch if greater than zero" (desviar se maior que zero)

#Exibição dos números gerados

display_array:
  li $t0, 10                    # Reinicia o contador para a exibição
  la $s0, array                 # Faz o ponteiro apontar novamente para o início do array

display_loop:
  lw $a0, 0($s0)                # Carrega o valor do array para exibir
  li $v0, 1                     # Syscall para print integer
  syscall

  li $v0, 11                    # Syscall para print char (nova linha)
  li $a0, 10                    # Código ASCII de nova linha
  syscall

  addi $s0, $s0, 4              # Avança para o próximo número
  subi $t0, $t0, 1              # Decrementa contador
  bgtz $t0, display_loop        # Loop até exibir todos os números

# Ordenação com Bubble Sort

sort_array:
  li $t0, 9                     # Número de elementos - 1
sort_outer_loop:
  li $t1, 0                     # Contador do loop interno
  la $s0, array                 # Ponteiro para o início do array

sort_inner_loop:
  lw $t2, 0($s0)                # Carrega elemento atual
  lw $t3, 4($s0)                # Carrega próximo elemento

  ble $t2, $t3, no_swap         # Verifica se $t2 <= $t3; se sim, não troca
  # A instrução ble significa "branch if less than or equal" (desviar se menor ou igual)

  # Troca os elementos
  sw $t3, 0($s0)                # Coloca $t3 na posição atual
  sw $t2, 4($s0)                # Coloca $t2 na próxima posição

no_swap:
  addi $s0, $s0, 4              # Move para o próximo par
  addi $t1, $t1, 1              # Incrementa o contador do loop interno

  blt $t1, $t0, sort_inner_loop # Continua no loop interno
  # A instrução blt significa "branch if less than" (desviar se menor que)

  subi $t0, $t0, 1              # Decrementa o contador do loop externo
  bgtz $t0, sort_outer_loop     # Continua no loop externo até ordenar


# Exibe os números ordenados

display_sorted:
  li $t0, 10                    # Reinicia o contador para exibir array ordenado
  la $s0, array                 # Ponteiro para o início do array

display_sorted_loop:
  lw $a0, 0($s0)                # Carrega o valor do array para exibir
  li $v0, 1                     # Syscall para print integer
  syscall

  li $v0, 11                    # Syscall para print char (nova linha)
  li $a0, 10                    # Código ASCII de nova linha
  syscall

  addi $s0, $s0, 4              # Avança para o próximo número
  subi $t0, $t0, 1              # Decrementa contador
  bgtz $t0, display_sorted_loop # Continua até exibir todos os números

# Finaliza o programa

  li $v0, 10                    # Syscall para encerrar o programa
  syscall