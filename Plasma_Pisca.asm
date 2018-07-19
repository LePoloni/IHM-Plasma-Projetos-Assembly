# Usar a configura��o de mem�ria "Comapct, Text at Address 0" (Settings -> Memory Configuration..)
# Dessa forma o programa � carregado a partir do endere�o 0 onde come�a os 8kB de mem�ria interna do Plasma

        .text					# os itens subseguentes s�o armazenados no segmento de texto (instru��es)
        .globl main				# declara que a label main � global e pode ser referenciada de outros arquivos
main:
	lui	$gp,0x2000	# lui carrega o valor passado nos 16 msbs do registrador
				# 0x2000 0000 � o endere�o base dos perif�ricos no uP Plasma
#Somente para teste vvvvvvvvvv
	# Usar a configura��o de mem�ria "Comapct, Text at Address 0" (Settings -> Memory Configuration..)
#	li	$gp,0x00001800	# li pseudo instru��o que carrega o valor passado de 32 bits no registrador
#	mtc0 	$12, $0		# Desabilita interrup��es (Coprocessador 0)
#	li	$t1,0x00005555	# $t1 <- 0x00005555
#	sw	$t1,0x0050($gp)	# GPIOA <- $t1
#Somente para teste /\/\/\/\/\

loop:
#	lw	$t2,0x50($gp)	# $t2 <- GPIOA
#	andi	$t2,$t2, 0x0200	# $t2 <- 0x00000?00 (m�scar� para verifica��o do bit 9)
	
#	beqz 	$t2,task2	# Se a chave est� em zero n�o faz nada
	
#	lw	$t2,0x0030($gp)	# $t2 <- GPIO0
#	andi	$t2,$t2,0x0200	# $t2 <- 0x00000?00 (l� apenas o estado do led9)
	
#	beqz  	$t2,acende	# Salta se $t2 n�o � igual a 0
		
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
#	bnez 	$t2,dec2	# salta se $t1 n�o � igual a 0

#	j	loop

	li	$t2,0x5555
	sw	$t2,0x30($gp)
	li	$t2,0xAAAA
	sw	$t2,0x40($gp)
	
	li	$t2,0x01
	li	$t3,1
dec2:
	sub	$t2,$t2,$t3	# $t2 <- $t2-1	
	bnez 	$t2,dec2	# salta se $t1 n�o � igual a 0
	
	li	$t2,0xAAAA
	sw	$t2,0x30($gp)
	li	$t2,0x5555
	sw	$t2,0x40($gp)
	
	li	$t2,0x01
	li	$t3,1
dec3:
	sub	$t2,$t2,$t3	# $t2 <- $t2-1	
	bnez 	$t2,dec3	# salta se $t1 n�o � igual a 0	
	
	j	loop