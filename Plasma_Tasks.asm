# Plasma_Tasks.asm
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

# Chama tarefa 1 se sw8 = 0 e chama a tarefa 2 se sw8 = 1
loop:	lw	$t2,0x50($gp)	# $t2 <- GPIOA
	andi	$t2,$t2,0x0100	# $t2 <- 0x00000?00 (máscará para verificação do bit 8)
	
	beqz 	$t2,task1	# Se a chave está em zero roda a tarefa 1
	#bnez 	$t2,task1	# Se a chave não está em zero roda a tarefa 1
	#bgtz 	$t2,task1	# Se a chave é maior que zero roda a tarefa 1
	nop
	j	task2		# Senão roda a tarefa 2
	nop
	
#.text 0x00000200
# GPIO0(7..0) <- GPIOA(7..0)
task1:	addiu	$t1,$0,0xFF	# $t1 <- 0x000000FF
	sw	$t1,0x40($gp)	# GPIO0 <- 0x??????00 (força 0 em todos os 8 lsbs)
	
	lw	$t1,0x0050($gp)	# $t1 <- GPIOA
	and	$t1,$t1,0xFF	# $t1 <- 0x000000??	
	
	sw	$t1,0x0030($gp)	# GPIO0 <- GPIO0 or $t1 (força 1 nos 8 lsbs que estão em 1 na entrada GPIOA)	
	
	# Delay de 1000 ciclos x tempo do loopind de teste			
	li	$t1,5
	li	$t0,1

dec1:	sub	$t1,$t1,$t0	# $t1 <- $t1-1	
	bnez 	$t1,dec1	# salta se $t1 não é igual a 0
	nop
	
	#j	task1
	j	loop
	nop
	
#.text 0x00000300
#Pisca led9 se sw9 = 1
task2:	lw	$t2,0x50($gp)	# $t2 <- GPIOA
	andi	$t2,$t2, 0x0200	# $t2 <- 0x00000?00 (máscará para verificação do bit 9)
	
	#beqz 	$t2,task2	# Se a chave está em zero não faz nada
	beqz 	$t2,loop	# Se a chave está em zero não faz nada
	nop
	
	lw	$t2,0x0030($gp)	# $t2 <- GPIO0
	andi	$t2,$t2,0x0200	# $t2 <- 0x00000?00 (lê apenas o estado do led9)
	
	beqz  	$t2,acende	# Salta se $t2 não é igual a 0
	nop
		
apaga:	addiu	$t2, $0,0x0200
	sw	$t2,0x40($gp)	# GPIO0 Clear <- 0x00000200 (Apaga o led9)
	j	delay2	
	nop

acende:	addiu	$t2, $0,0x0200
	sw	$t2,0x30($gp)	# GPIO0 Set <- 0x00000200 (Acende o led9)

delay2:	li	$t2,5
	li	$t3,1
dec2:
	sub	$t2,$t2,$t3	# $t2 <- $t2-1	
	bnez 	$t2,dec2	# salta se $t1 não é igual a 0
	nop
	
	#j	task2
	j	loop
	nop

