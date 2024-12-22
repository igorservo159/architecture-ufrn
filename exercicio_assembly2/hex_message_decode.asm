# João Igor Ramos de Lima
# 20220050698

# Segmento de dados --------------

.data

msg_codificada: .word 0x00051010, 0x116A23B1, 0x21347582, 0x10061231, 0x11642467, 0x008695AB, 0x21CD6EEF, 0x00071323
                .word 0x11264517, 0x2089A2B0, 0x00E5F601, 0x212360F1, 0x11624533, 0x21676455, 0x00627089, 0x20AB8691
                .word 0x10A6CDB3, 0x21EF6C5D, 0x10E701F2, 0x00071423, 0x0162F345, 0x21677455, 0x10628971, 0x1082AB90
                .word 0x10A4CDB6, 0x016C9DEF, 0x21016031, 0x212362F3, 0x01745545, 0x10626770, 0x10868993, 0x21AB6AFB
                .word 0x00C6DDCD, 0x00E2F0EF, 0x116001E1, 0x0162F323, 0x20454754, 0x00667167, 0x20898290, 0x113AAB1B
                .word 0x113CCD0D, 0x000211EF

# Segmento de texto (instruções)

.text

main:

  la $s0, msg_codificada # Carrega o endereço base da mensagem em $s0
  li $t0, 42 # Número de words na mensagem (cada uma contém 1 caractere codificado)
  li $v0, 11 # Syscall 11 para imprimir um caractere ASCII

message_loop:
  lw $t1, 0($s0) # Carrega a próxima word da mensagem em $t1
  
  srl $t2, $t1, 28 # Obtém o nibble mais significativo do byte 3 (indica o byte inválido)
  andi $t2, $t2, 0xF # Isola os 4 bits menos significativos (0, 1 ou 2)

  srl $t3, $t1, 24 # Obtém o segundo nibble do byte 3 (indica o nibble a ser lido)
  andi $t3, $t3, 0xF # Isola os 4 bits menos significativos (0 ou 1)

  li $t4, 1 # Define o índice inicial para os nibbles 
  li $t5, 2 # Define o índice inicial para os bytes 
  li $t6, 0 # Inicializa o caractere final (word resultante)

  word_loop:
    beq $t2, $t5, break_if_byte_useless # Se o byte atual é inválido, pula para o próximo

    # Calcula o deslocamento necessário e extrai o byte atual
    sll $t7, $t5, 3 # Calcula o deslocamento do byte atual (t5 * 8 bits)
    srlv $t8, $t1, $t7 # Desloca o byte para o LSB (posição menos significativa)
    andi $t8, $t8, 0xFF # Isola o byte atual (8 bits)

    # Seleciona o nibble válido
    beq $t4, $t3, nibble_one # Verifica se deve processar o nibble mais significativo
    andi $t8, $t8, 0xF # Isola o nibble menos significativo do byte
    j store_nibble

  nibble_one:
    srl $t8, $t8, 4 # Desloca para obter o nibble mais significativo
    andi $t8, $t8, 0xF # Isola o nibble mais significativo

  store_nibble:
    sll $t6, $t6, 4 # Desloca o caractere final 4 bits à esquerda
    or $t6, $t6, $t8 # Adiciona o nibble à word final

  break_if_byte_useless:
    beq $t5, 0, end_word_loop # Se todos os bytes foram processados, sai do loop
    subi $t5, $t5, 1 # Decrementa o índice do byte
    
    j word_loop 

  end_word_loop:
    move $a0, $t6 # Move o caractere final para $a0 para ser impresso
    syscall # Chama a syscall para imprimir o caractere

    addi $s0, $s0, 4 # Avança para a próxima word
    subi $t0, $t0, 1 # Decrementa o número de words restantes
    bgtz $t0, message_loop # Continua no loop se ainda houver words a processar

# Finalizar programa

li $v0, 10 # Syscall 10 para encerrar o programa
syscall
