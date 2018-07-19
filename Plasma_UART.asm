# Usar a configuração de memória "Comapct, Text at Address 0" (Settings -> Memory Configuration..)
# Dessa forma o programa é carregado a partir do endereço 0 onde começa os 8kB de memória interna do Plasma

        .text					# os itens subseguentes são armazenados no segmento de texto (instruções)
        .globl main				# declara que a label main é global e pode ser referenciada de outros arquivos
main:
	lui	$gp,0x2000	# lui carrega o valor passado nos 16 msbs do registrador
				# 0x2000 0000 é o endereço base dos periféricos no uP Plasma
#Somente para teste vvvvvvvvvv
	# Usar a configuração de memória "Comapct, Text at Address 0" (Settings -> Memory Configuration..)
#	li	$gp,0x00001800	# li pseudo instrução que carrega o valor passado de 32 bits no registrador
#	mtc0 	$12, $0		# Desabilita interrupções (Coprocessador 0)
#	li	$t1,0x00005555	# $t1 <- 0x00005555
#	sw	$t1,0x0050($gp)	# GPIOA <- $t1
#Somente para teste /\/\/\/\/\

loop:
#	lw	$t2,0x50($gp)	# $t2 <- GPIOA
#	andi	$t2,$t2, 0x0200	# $t2 <- 0x00000?00 (máscará para verificação do bit 9)
	
#	beqz 	$t2,task2	# Se a chave está em zero não faz nada
	
#	lw	$t2,0x0030($gp)	# $t2 <- GPIO0
#	andi	$t2,$t2,0x0200	# $t2 <- 0x00000?00 (lê apenas o estado do led9)
	
#	beqz  	$t2,acende	# Salta se $t2 não é igual a 0
		
#apaga:	
#	addiu	$t2, $0,0x0200
#	sw	$t2,0x40($gp)	# GPIO0 Clear <- 0x00000200 (Apaga o led9)
#	j	delay2	
#acende:
#	addiu	$t2, $0,0x0200
#	sw	$t2,0x30($gp)	# GPIO0 Set <- 0x00000200 (Acende o led9)

#delay2:								
#	li	$t2,10000000
#	li	$t3,1
#dec2:
#	sub	$t2,$t2,$t3	# $t2 <- $t2-1	
#	bnez 	$t2,dec2	# salta se $t1 não é igual a 0

#	j	loop

	li	$t1,0xFFFF
contador:	sw	$t1,0x40($gp)	#apaga todos os bits
	
	li	$t2,0x0030	#'0' em ASCII

proximo:	sw	$t2,0x30($gp)	#manda para os leds
	sw	$t2,0x00($gp)	#manda para serial
	jal	delay_1ms
	nop
	sw	$t1,0x40($gp)	#apaga todos os bits
	
	addi	$t2,$t2,1	#incrementa o contador
	beq 	$t2,0x3A,contador	#se chegou em '9'+1 volta pra '0'
	nop
	j	proximo	
	nop

delay_1ms:	li	$t3,8331	#2 clocks para entrar + 1 da instrução (25000 instruções)
	li	$t4,1			#1 clock
del:
	sub	$t3,$t3,$t4		#1 clock
	bnez 	$t3,del			#2 clocks por loop
	nop
	jr	$ra			#2 clocks retorna do delay
	nop

