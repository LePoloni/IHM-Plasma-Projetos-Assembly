# Plasma_Seq.asm
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
inicio:
	li	$t1,0x01	#pseudoinstrução, equivale a "addiu	$t1,$0,0x01"
	#addiu	$t1,$0,0x01
	sw	$t1,0x30($gp)	#seta o bit 0
	not	$t1,$t1
	sw	$t1,0x40($gp)	#reseta os demais
	
	li	$t1,0x02	#pseudoinstrução, equivale a "addiu	$t1,$0,0x02"
	#addiu	$t1,$0,0x01
	sw	$t1,0x30($gp)	#seta o bit 0
	not	$t1,$t1
	sw	$t1,0x40($gp)	#reseta os demais
	
	li	$t1,0x04	#pseudoinstrução, equivale a "addiu	$t1,$0,0x04"
	#addiu	$t1,$0,0x01
	sw	$t1,0x30($gp)	#seta o bit 0
	not	$t1,$t1
	sw	$t1,0x40($gp)	#reseta os demais
	
	li	$t1,0x08	#pseudoinstrução, equivale a "addiu	$t1,$0,0x08"
	#addiu	$t1,$0,0x01
	sw	$t1,0x30($gp)	#seta o bit 0
	not	$t1,$t1
	sw	$t1,0x40($gp)	#reseta os demais
	
	li	$t1,0x10	#pseudoinstrução, equivale a "addiu	$t1,$0,0x10"
	#addiu	$t1,$0,0x01
	sw	$t1,0x30($gp)	#seta o bit 0
	not	$t1,$t1
	sw	$t1,0x40($gp)	#reseta os demais
	
	li	$t1,0x20	#pseudoinstrução, equivale a "addiu	$t1,$0,0x20"
	#addiu	$t1,$0,0x01
	sw	$t1,0x30($gp)	#seta o bit 0
	not	$t1,$t1
	sw	$t1,0x40($gp)	#reseta os demais
	
	li	$t1,0x40	#pseudoinstrução, equivale a "addiu	$t1,$0,0x40"
	#addiu	$t1,$0,0x01
	sw	$t1,0x30($gp)	#seta o bit 0
	not	$t1,$t1
	sw	$t1,0x40($gp)	#reseta os demais
	
	li	$t1,0x80	#pseudoinstrução, equivale a "addiu	$t1,$0,0x80"
	#addiu	$t1,$0,0x01
	sw	$t1,0x30($gp)	#seta o bit 0
	not	$t1,$t1
	sw	$t1,0x40($gp)	#reseta os demais

	j	inicio

