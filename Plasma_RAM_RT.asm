# Plasma_RAM_RT.asm
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

# Chama tarefa 1 se sw8 = 0 e chama a tarefa 2 se sw8 = 1
	li $t1,0	# $t1 = 0
loop:	
	lui	$gp,0x0002	# Endere�a a RAM_RT 0x0002xxxx
	sw	$t1,0($gp)	# $0x00020000 = $t1
	lw	$t2,0($gp)	# $t2 = 0x00020000
	
	lui	$gp,0x2000	# Endere�a os perif�ricos
	sw	$t2,0x30($gp)	# GPIO0 |= $t2 (for�a 1)
	not	$t3,$t2
	sw	$t3,0x40($gp)	# GPIO0 &= $t2 (for�a 0)
	
	addiu	$t1,$t1,1	# $t1 = $t1+1

delay:	li	$t4,5
	li	$t5,1
dec:
	sub	$t4,$t4,$t5	# $t4 <- $t4-1	
	bnez 	$t4,dec		# salta se $t4 n�o � igual a 0
	nop	
	
	j	loop
	nop