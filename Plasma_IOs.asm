# Plasma_IOs.asm
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

loop:
#Somente para teste vvvvvvvvvv
#	lw	$t1,0x0050($gp)	# $t1 <- GPIOA
#	not	$t1,$t1		# $t1 <- not $t1
#	sw	$t1,0x0050($gp)	# GPIOA <- not GPIOA (for�a 1 nos bits que est�o em 1 na entrada GPIOA)
#Somente para teste /\/\/\/\/\
				
	lw	$t1,0x0050($gp)	# $t1 <- GPIOA
	
	sw	$t1,0x0030($gp)	# GPIO0 <- GPIO0 or $t1 (for�a 1 nos bits que est�o em 1 na entrada GPIOA)
	not	$t0,$t1		# $t0 <- not $t1
	sw	$t0,0x0040($gp)	# GPIO0 <- GPIO0 and not $t0 (for�a 0 nos bits que est�o em 0 na entrada GPIOA)
				# a opera��o not � impl�cita ao perif�rico
	jal 	delay		# chama a subrotina de delay e salva automaticamente o endere�o de retorno em $ra
	j	loop		# volta para o in�cio do la�o

delay:
	li	$t2,1		# t2 <- 1 (delay m�nimo)
	li	$t3,1		# t3 <- 1
dec:
	sub	$t2,$t2,$t3	# $t2 <- $t2-1	
	bnez 	$t2,dec		# salta se $t2 n�o � igual a 0
	jr 	$ra		# retorna da subrotina para o endere�o automaticamente armazenado em $ra (jal)								
