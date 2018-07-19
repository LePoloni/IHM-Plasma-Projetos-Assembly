# PlasmaST1.asm (standard)
#
# Cria 6 tarefas e faz a preparação do escalorador para executá-las
# Salva o valor inicial do PC de cada tarefa na memória RAM_RT
# Testa o conteúdo salvo pelo context_manager
#
# Para uso na CPU Plasma:
# Usar a configuração de memória "Comapct, Text at Address 0" (Settings -> Memory Configuration..)
# Dessa forma o programa é carregado a partir do endereço 0 onde começa os 8kB de memória interna do Plasma

#data
#fout:   .asciiz "testout.txt"      # filename for output
#buffer: .asciiz "The quick brown fox jumps over the lazy dog."

	.data
buffer:  .asciiz "Teste"
        .text					# os itens subseguentes são armazenados no segmento de texto (instruções)
        .globl main				# declara que a label main é global e pode ser referenciada de outros arquivos
main:	lui	$gp,0x2000	# lui carrega o valor passado nos 16 msbs do registrador
				# 0x2000 0000 é o endereço base dos periféricos no uP Plasma
#Somente para teste vvvvvvvvvv
	# Usar a configuração de memória "Comapct, Text at Address 0" (Settings -> Memory Configuration..)
#	li	$gp,0x00001800	# li pseudo instrução que carrega o valor passado de 32 bits no registrador
#	mtc0 	$12, $0		# Desabilita interrupções (Coprocessador 0)
#	li	$t1,0x00005555	# $t1 <- 0x00005555
#	sw	$t1,0x0050($gp)	# GPIOA <- $t1
#Somente para teste /\/\/\/\/\

#	li	$gp,0x00001800 	#teste apenas
inicio:	li 	$t0,0x08
	sw	$t0,0x0010($gp)	#Habilita interrupção de contador bit de flag em 1
	j	ini
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
#.ktext	0x0000003c
int:	li	$t0,0x0002
    	sw	$t0,0x0030($gp)		#Acende o led 1
	nop
retorna:   	
    	eret 
	nop
	
#.text	0x000004c	
ini:	li  	$v0, 1           # service 1 is print integer
#    	add 	$a0, $t0, $zero  # load desired value into argument register $a0, using pseudo-op
    	
#    	li  	$v0, 4
#    	la  	$a0, buffer
    	
    	li	$t0,0xFFFF
    	sw	$t0,0x0040($gp)		#Apaga todos os leds
    	li	$t0,0x0001
    	sw	$t0,0x0030($gp)		#Acende o led 0
    	
    	lw	$t1,0x50($gp)		# $t1 <- GPIOA	lê as chaves
    	
    	syscall			#força interrupção no Plasma
    	nop
    	
pula:	j	ini
	nop

    	
    	
    	
