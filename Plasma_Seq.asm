# Plasma_Seq.asm
#
# Copia o valor do port de entrada no port de sa�dda 
# (GPIOA --> GPIO0, 2000 0050h --> 2000 0030h (Set Bits) ou 2000 0040h (Clear Bits)
#
# Para uso na CPU Plasma:
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
inicio:
	li	$t1,0x01	#pseudoinstru��o, equivale a "addiu	$t1,$0,0x01"
	#addiu	$t1,$0,0x01
	sw	$t1,0x30($gp)	#seta o bit 0
	not	$t1,$t1
	sw	$t1,0x40($gp)	#reseta os demais
	
	li	$t1,0x02	#pseudoinstru��o, equivale a "addiu	$t1,$0,0x02"
	#addiu	$t1,$0,0x01
	sw	$t1,0x30($gp)	#seta o bit 0
	not	$t1,$t1
	sw	$t1,0x40($gp)	#reseta os demais
	
	li	$t1,0x04	#pseudoinstru��o, equivale a "addiu	$t1,$0,0x04"
	#addiu	$t1,$0,0x01
	sw	$t1,0x30($gp)	#seta o bit 0
	not	$t1,$t1
	sw	$t1,0x40($gp)	#reseta os demais
	
	li	$t1,0x08	#pseudoinstru��o, equivale a "addiu	$t1,$0,0x08"
	#addiu	$t1,$0,0x01
	sw	$t1,0x30($gp)	#seta o bit 0
	not	$t1,$t1
	sw	$t1,0x40($gp)	#reseta os demais
	
	li	$t1,0x10	#pseudoinstru��o, equivale a "addiu	$t1,$0,0x10"
	#addiu	$t1,$0,0x01
	sw	$t1,0x30($gp)	#seta o bit 0
	not	$t1,$t1
	sw	$t1,0x40($gp)	#reseta os demais
	
	li	$t1,0x20	#pseudoinstru��o, equivale a "addiu	$t1,$0,0x20"
	#addiu	$t1,$0,0x01
	sw	$t1,0x30($gp)	#seta o bit 0
	not	$t1,$t1
	sw	$t1,0x40($gp)	#reseta os demais
	
	li	$t1,0x40	#pseudoinstru��o, equivale a "addiu	$t1,$0,0x40"
	#addiu	$t1,$0,0x01
	sw	$t1,0x30($gp)	#seta o bit 0
	not	$t1,$t1
	sw	$t1,0x40($gp)	#reseta os demais
	
	li	$t1,0x80	#pseudoinstru��o, equivale a "addiu	$t1,$0,0x80"
	#addiu	$t1,$0,0x01
	sw	$t1,0x30($gp)	#seta o bit 0
	not	$t1,$t1
	sw	$t1,0x40($gp)	#reseta os demais

	j	inicio

