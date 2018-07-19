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

	j	loop

#.ktext 0x00000200
#min:
#	addiu	$t1,$0,0x55
#	sw	$t1,0x30($gp)
#	j	min

task1:	# GPIO0(7..0) <- GPIOA(7..0)
	addiu	$t1,$0,0xFF	# $t1 <- 0x000000FF
	sw	$t1,0x40($gp)	# GPIO0 <- 0x??????00 (for�a 0 em todos os 8 lsbs)
	
	lw	$t1,0x0050($gp)	# $t1 <- GPIOA
	and	$t1,$t1,0xFF	# $t1 <- 0x000000??	
	
	sw	$t1,0x0030($gp)	# GPIO0 <- GPIO0 or $t1 (for�a 1 nos 8 lsbs que est�o em 1 na entrada GPIOA)	
	
	# Delay de 1000 ciclos x tempo do loopind de teste			
	li	$t1,5
	li	$t0,1
dec1:
	sub	$t1,$t1,$t0	# $t1 <- $t1-1	
	bnez 	$t1,dec1	# salta se $t1 n�o � igual a 0
	
	#j	task1
	j	loop

#.ktext 0x00000300
task2:	#Pisca led9 se sw9 = 1
	lw	$t2,0x50($gp)	# $t2 <- GPIOA
	andi	$t2,$t2, 0x0200	# $t2 <- 0x00000?00 (m�scar� para verifica��o do bit 9)
	
	#beqz 	$t2,task2	# Se a chave est� em zero n�o faz nada
	beqz 	$t2,loop	# Se a chave est� em zero n�o faz nada
	
	lw	$t2,0x0030($gp)	# $t2 <- GPIO0
	andi	$t2,$t2,0x0200	# $t2 <- 0x00000?00 (l� apenas o estado do led9)
	
	beqz  	$t2,acende	# Salta se $t2 n�o � igual a 0
		
apaga:	
	addiu	$t2, $0,0x0200
	sw	$t2,0x40($gp)	# GPIO0 Clear <- 0x00000200 (Apaga o led9)
	j	delay2	
acende:
	addiu	$t2, $0,0x0200
	sw	$t2,0x30($gp)	# GPIO0 Set <- 0x00000200 (Acende o led9)

delay2:								
	li	$t2,5
	li	$t3,1
dec2:
	sub	$t2,$t2,$t3	# $t2 <- $t2-1	
	bnez 	$t2,dec2	# salta se $t1 n�o � igual a 0
	
	#j	task2
	j	loop

#vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
loop:	# Chama tarefa 1 se sw8 = 0 e chama a tarefa 2 se sw8 = 1
	lw	$t2,0x50($gp)	# $t2 <- GPIOA
	andi	$t2,$t2,0x0100	# $t2 <- 0x00000?00 (m�scar� para verifica��o do bit 8)
	#andi	$t2,$t2,0x0200	# $t2 <- 0x00000?00 (m�scar� para verifica��o do bit 9)
	
	#teste
	sw	$t2,0x30($gp)
	not	$t2,$t2
	sw	$t2,0x40($gp)
	#j	loop
	# Assim em vez de testar a chave, testa o led
	lw	$t2,0x30($gp)	# $t2 <- GPIO0
	andi	$t2,$t2,0x0100	# $t2 <- 0x00000?00 (m�scar� para verifica��o do bit 8)
	#fim do teste	
	
	#beqz 	$t2,task1	# Se a chave est� em zero roda a tarefa 1
	#bnez 	$t2,task1	# Se a chave n�o est� em zero roda a tarefa 1
	bgtz 	$t2,task1	# Se a chave � maior que zero roda a tarefa 1
	j	task2		# Sen�o roda a tarefa 2

