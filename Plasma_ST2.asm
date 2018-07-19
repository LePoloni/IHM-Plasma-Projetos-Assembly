# PlasmaST2.asm (standard)
#
# Habilita interrupção de contador e alternar entre sinalização com bit em 1 e 0.
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
	
	li 	$t0,0x01
	mtc0 	$t0, $12	#COP0 STATUS=1; enable interrupts mtc0
	
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
#.ktext	0x0000003c	#não funcionou por conta da software de conversão de Steve Rhoads!!!
int:	mtc0 	$0, $12	#COP0 STATUS=1; disable interrupts mtc0
	li	$t0,0x0002
    	sw	$t0,0x0030($gp)		#Acende o led 1
    	lw	$t1,0x0020($gp)		#Lê o valor de IRQ Status
    	lw	$t2,0x0010($gp)		#Lê o valor de IRQ Mask
test_counter_1: andi	$t3,$t2,0x08	#Aplica máscara em IRQ Mask para ver se counter_reg está habilitado
    	beqz 	$t3,test_counter_0	#Se não estiver pula para teste de not_counter_reg
    	nop
	andi	$t4,$t1,0x08		#Aplica máscara em IRQ Status para ver se counter_reg está com a flag ativa
	beqz	$t4,retorna		#Se a flag não está ativa retorna da interrupção
	nop
	
	li 	$t0,0x04
	sw	$t0,0x0010($gp)		#Habilita interrupção de not_counter_reg
	
	li	$t0,0xFFFF
    	sw	$t0,0x0040($gp)		#Apaga todos os leds
	li	$t0,0x00F0
    	sw	$t0,0x0030($gp)		#Acende os leds 7..4
	j	retorna
	nop
test_counter_0:	andi	$t3,$t2,0x04	#Aplica máscara em IRQ Mask para ver se not_counter_reg está habilitado
    	beqz 	$t3,retorna		#Se não estiver pula para retorna
    	nop
	andi	$t4,$t1,0x04		#Aplica máscara em IRQ Status para ver se not_counter_reg está com a flag ativa
	beqz	$t4,retorna		#Se a flag não está ativa retorna da interrupção
	nop
	
	li 	$t0,0x08
	sw	$t0,0x0010($gp)		#Habilita interrupção de counter_reg
	
	li	$t0,0xFFFF
    	sw	$t0,0x0040($gp)		#Apaga todos os leds
	li	$t0,0x000F
    	sw	$t0,0x0030($gp)		#Acende os leds 3..0
	j	retorna
	nop
retorna:li 	$t0,0x01
	mtc0 	$t0, $12	#COP0 STATUS=1; enable interrupts mtc0
#	eret 				#não funciona no plasma
	mfc0	$t0, $14	#COP0 Lê o PC salvo no endereço 0 dos registradores
	jr	$t0		#Vide arquivo boot.asm na documentação do Plasma (pasta ..\trunk\tools)
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
    	
#    	syscall			#força interrupção no Plasma
    	nop
    	
pula:	j	ini
	nop

    	
    	
    	
