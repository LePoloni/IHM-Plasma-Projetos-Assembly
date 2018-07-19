# Plasma_IOs.asm
#
# Copia o valor do port de entrada no port de saídda 
# (GPIOA --> GPIO0, 2000 0050h --> 2000 0030h (Set Bits) ou 2000 0040h (Clear Bits)
#
# Para uso na CPU Plasma:
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
#Somente para teste vvvvvvvvvv
#	lw	$t1,0x0050($gp)	# $t1 <- GPIOA
#	not	$t1,$t1		# $t1 <- not $t1
#	sw	$t1,0x0050($gp)	# GPIOA <- not GPIOA (força 1 nos bits que estão em 1 na entrada GPIOA)
#Somente para teste /\/\/\/\/\
				
	lw	$t1,0x0050($gp)	# $t1 <- GPIOA
	
	sw	$t1,0x0030($gp)	# GPIO0 <- GPIO0 or $t1 (força 1 nos bits que estão em 1 na entrada GPIOA)
	not	$t0,$t1		# $t0 <- not $t1
	sw	$t0,0x0040($gp)	# GPIO0 <- GPIO0 and not $t0 (força 0 nos bits que estão em 0 na entrada GPIOA)
				# a operação not é implícita ao periférico
	jal 	delay		# chama a subrotina de delay e salva automaticamente o endereço de retorno em $ra
	j	loop		# volta para o início do laço

delay:
	li	$t2,1		# t2 <- 1 (delay mínimo)
	li	$t3,1		# t3 <- 1
dec:
	sub	$t2,$t2,$t3	# $t2 <- $t2-1	
	bnez 	$t2,dec		# salta se $t2 não é igual a 0
	jr 	$ra		# retorna da subrotina para o endereço automaticamente armazenado em $ra (jal)								
