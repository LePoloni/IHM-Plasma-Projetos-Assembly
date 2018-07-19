# Plasma_RT3.asm
#
# Cria duas tarefas e faz a prepara��o do escalorador para execut�-las
# Salva o valor inicial do PC de cada tarefa na mem�ria RAM_RT
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
inicio:	li	$t1,2		# Duas tarefas
	sw	$t1,0xA0($gp)

	li	$t1,0x03	# Tarefas 0 e 1 (bits 0 e 1)
	sw	$t1,0xB0($gp)

	li	$t1,100		# Tempo entre ticks em clks (deve ser > tempo de back[34] + tempo de restaura��o[34]) 
	sw	$t1,0x90($gp)
	
	# PC de cada tarefa no 1o endere�o do TCB na mem�ria ram_RT
	# End PC da tarefa 0 = 0x0002 0000
	# End PC da tarefa 1 = 0x0002 0100
	lui	$gp,0x0002	# Atualiza global pointer com os 16 msbs
	
	la	$t1,task0	# Carrega em t1 o endere�o da tarefa 0
	sw	$t1,0x0000($gp)	# Armazena o endere�o da tarefa 0 no TCB da tarefa 0 (1o endere�o)
	
	la	$t1,task1	# Carrega em t1 o endere�o da tarefa 1
	sw	$t1,0x0100($gp)	# Armazena o endere�o da tarefa 1 no TCB da tarefa 1 (1o endere�o)
	
	# Teste ram_RT
	# Memoriza valores na ram_RT
	li	$t1,0x0001
	sw	$t1,0x0104($gp)
	li	$t1,0x0002
	sw	$t1,0x0108($gp)
	li	$t1,0x0004
	sw	$t1,0x010C($gp)
	li	$t1,0x0008
	sw	$t1,0x0110($gp)
	# L� ram_RT e escreve no port GPIO0
	lui	$gp,0x0002
	lw	$t1,0x0100($gp)		# Endere�o da tarefa 1
	lw	$t2,0x0104($gp)
	lw	$t3,0x0108($gp)
	lw	$t4,0x010C($gp)
	lw	$t5,0x0110($gp)
	
	lui	$gp,0x2000
	li	$t6,0xFF
	sw	$t6,0x40($gp)	# GPIO0 <- 0x??????00
	sw	$t5,0x30($gp)	# GPIO0 <- 0x??????08
	sw	$t6,0x40($gp)	# GPIO0 <- 0x??????00
	sw	$t4,0x30($gp)	# GPIO0 <- 0x??????04
	sw	$t6,0x40($gp)	# GPIO0 <- 0x??????00
	sw	$t3,0x30($gp)	# GPIO0 <- 0x??????02
	sw	$t6,0x40($gp)	# GPIO0 <- 0x??????00
	sw	$t2,0x30($gp)	# GPIO0 <- 0x??????01
	sw	$t6,0x40($gp)	# GPIO0 <- 0x??????00
	sw	$t1,0x30($gp)	# GPIO0 <- End Task1	
	sw	$t6,0x40($gp)	# GPIO0 <- 0x??????00
	
	lui	$gp,0x2000	# Atualiza global pointer com os 16 msbs
	
	li	$t1,1		# Habilita o escalonador
	sw	$t1,0x80($gp)

#.text 0x00000200
# GPIO0(7..0) <- GPIOA(7..0)
task0:	lui	$gp,0x2000	# lui carrega o valor passado nos 16 msbs do registrador
				# 0x2000 0000 � o endere�o base dos perif�ricos no uP Plasma

task0_loop:	addiu	$t1,$0,0xFF	# $t1 <- 0x000000FF
	sw	$t1,0x40($gp)	# GPIO0 <- 0x??????00 (for�a 0 em todos os 8 lsbs)
	
	lw	$t1,0x0050($gp)	# $t1 <- GPIOA
	and	$t1,$t1,0xFF	# $t1 <- 0x000000??	
	
	sw	$t1,0x0030($gp)	# GPIO0 <- GPIO0 or $t1 (for�a 1 nos 8 lsbs que est�o em 1 na entrada GPIOA)	
	
	# Delay de 1000 ciclos x tempo do loopind de teste			
	li	$t1,5
	li	$t0,1

dec1:	sub	$t1,$t1,$t0	# $t1 <- $t1-1	
	bnez 	$t1,dec1	# salta se $t1 n�o � igual a 0
	nop
	
	j	task0_loop
	nop
	
#.text 0x00000300
#Pisca led9 se sw9 = 1
task1:	lui	$gp,0x2000	# lui carrega o valor passado nos 16 msbs do registrador
				# 0x2000 0000 � o endere�o base dos perif�ricos no uP Plasma

task1_loop:	lw	$t2,0x50($gp)	# $t2 <- GPIOA
	andi	$t2,$t2, 0x0200	# $t2 <- 0x00000?00 (m�scar� para verifica��o do bit 9)
	
	beqz 	$t2,task1	# Se a chave sw9 est� em zero n�o faz nada
	nop
	
	lw	$t2,0x0030($gp)	# $t2 <- GPIO0
	andi	$t2,$t2,0x0200	# $t2 <- 0x00000?00 (l� apenas o estado do led9)
	
	beqz  	$t2,acende	# Salta se $t2 n�o � igual a 0
	nop
		
apaga:	addiu	$t2, $0,0x0200
	sw	$t2,0x40($gp)	# GPIO0 Clear <- 0x00000200 (Apaga o led9)
	j	delay2	
	nop

acende:	addiu	$t2, $0,0x0200
	sw	$t2,0x30($gp)	# GPIO0 Set <- 0x00000200 (Acende o led9)

delay2:	li	$t2,5
	li	$t3,1
	
dec2:	sub	$t2,$t2,$t3	# $t2 <- $t2-1	
	bnez 	$t2,dec2	# salta se $t1 n�o � igual a 0
	nop
	
	j	task1_loop
	nop

