# Plasma_RT4.asm
#
# Cria duas tarefas e faz a preparação do escalorador para executá-las
# Salva o valor inicial do PC de cada tarefa na memória RAM_RT
# Testa o conteúdo salvo pelo context_manager
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
inicio:	li	$t1,2		# Duas tarefas
	sw	$t1,0xA0($gp)

	li	$t1,0x03	# Tarefas 0 e 1 (bits 0 e 1)
	sw	$t1,0xB0($gp)

	li	$t1,100		# Tempo entre ticks em clks (deve ser > tempo de back[34] + tempo de restauração[34]) 
	sw	$t1,0x90($gp)
	
	# PC de cada tarefa no 1o endereço do TCB na memória ram_RT
	# End PC da tarefa 0 = 0x0002 0000
	# End PC da tarefa 1 = 0x0002 0100
	lui	$gp,0x0002	# Atualiza global pointer com os 16 msbs
	
	la	$t1,task0	# Carrega em t1 o endereço da tarefa 0
	sw	$t1,0x0000($gp)	# Armazena o endereço da tarefa 0 no TCB da tarefa 0 (1o endereço)
	
	la	$t1,task1	# Carrega em t1 o endereço da tarefa 1
	sw	$t1,0x0100($gp)	# Armazena o endereço da tarefa 1 no TCB da tarefa 1 (1o endereço)
	
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
	# Lê ram_RT e escreve no port GPIO0
	lui	$gp,0x0002
	lw	$t1,0x0100($gp)		# Endereço da tarefa 1
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
# Aramazena o mostra alguns valores de registradores
task0:	lui	$gp,0x2000	# lui carrega o valor passado nos 16 msbs do registrador
				# 0x2000 0000 é o endereço base dos periféricos no uP Plasma

task0_loop:	li	$t1,0xFF
	sw	$t1,0x40($gp)	# GPIO0 <- 0x??????00 (força 0 em todos os 8 lsbs)
	sw	$t1,0x0030($gp)	# GPIO0 <- 0xFF
	
	sw	$t1,0x40($gp)	# GPIO0 <- 0x??????00 (força 0 em todos os 8 lsbs)
	li	$2,2
	sw	$2,0x0030($gp)	# GPIO0 <- valor $x
	
	sw	$t1,0x40($gp)	# GPIO0 <- 0x??????00 (força 0 em todos os 8 lsbs)
	li	$3,3
	sw	$3,0x0030($gp)	# GPIO0 <- valor $x
	
	sw	$t1,0x40($gp)	# GPIO0 <- 0x??????00 (força 0 em todos os 8 lsbs)
	li	$4,4
	sw	$4,0x0030($gp)	# GPIO0 <- valor $x
	
	sw	$t1,0x40($gp)	# GPIO0 <- 0x??????00 (força 0 em todos os 8 lsbs)
	li	$5,5
	sw	$5,0x0030($gp)	# GPIO0 <- valor $x
	
	sw	$t1,0x40($gp)	# GPIO0 <- 0x??????00 (força 0 em todos os 8 lsbs)
	li	$31,31
	sw	$31,0x0030($gp)	# GPIO0 <- valor $x
	
	j	task0_loop
	nop
	
#.text 0x00000300
#Mostra o que foi armazenado desligando o escalonador
task1:	lui	$gp,0x2000	# lui carrega o valor passado nos 16 msbs do registrador
				# 0x2000 0000 é o endereço base dos periféricos no uP Plasma

	#Aguarda terminar o backup dos registradores
delay1:	li	$t2,15
	li	$t3,1
	
dec1:	sub	$t2,$t2,$t3	# $t2 <- $t2-1	
	bnez 	$t2,dec1	# salta se $t1 não é igual a 0
	nop

	sw	$zero,0x80($gp)	# Desabilita o escalonador

task1_loop:	li	$t1,0xFF
	sw	$t1,0x40($gp)	# GPIO0 <- 0x??????00 (força 0 em todos os 8 lsbs)
	li	$t1,0x33
	sw	$t1,0x0030($gp)	# GPIO0 <- 0x33
	
	li	$t1,0xFF
	sw	$t1,0x40($gp)	# GPIO0 <- 0x??????00 (força 0 em todos os 8 lsbs)
	li	$t1,0xCC
	sw	$t1,0x0030($gp)	# GPIO0 <- 0xCC
	
	#Lê backup
	lui	$gp,0x0002	# Seleciona a memória ram_RT

	lw	$s1,0x0000($gp)	# $t2 <- Backup PC
	lw	$s2,0x0008($gp)	# $t2 <- Backup $t2
	lw	$s3,0x000C($gp)	# $t2 <- Backup $t3
	lw	$s4,0x0010($gp)	# $t2 <- Backup $t4
	lw	$s5,0x0014($gp)	# $t2 <- Backup $t5
	lw	$s6,0x007C($gp)	# $t2 <- Backup $ra
	
	#Mostra backup
	lui	$gp,0x2000
	
	li	$t1,0xFF
	
	sw	$t1,0x40($gp)	# GPIO0 <- 0x??????00 (força 0 em todos os 8 lsbs)
	sw	$s1,0x0030($gp)	# GPIO0 <- valor PC
	
	sw	$t1,0x40($gp)	# GPIO0 <- 0x??????00 (força 0 em todos os 8 lsbs)
	sw	$s2,0x0030($gp)	# GPIO0 <- valor $x
	
	sw	$t1,0x40($gp)	# GPIO0 <- 0x??????00 (força 0 em todos os 8 lsbs)
	sw	$s3,0x0030($gp)	# GPIO0 <- valor $x
	
	sw	$t1,0x40($gp)	# GPIO0 <- 0x??????00 (força 0 em todos os 8 lsbs)
	sw	$s4,0x0030($gp)	# GPIO0 <- valor $x
	
	sw	$t1,0x40($gp)	# GPIO0 <- 0x??????00 (força 0 em todos os 8 lsbs)
	sw	$s5,0x0030($gp)	# GPIO0 <- valor $x
	
	sw	$t1,0x40($gp)	# GPIO0 <- 0x??????00 (força 0 em todos os 8 lsbs)
	sw	$s6,0x0030($gp)	# GPIO0 <- valor $x

	j	task1_loop
	nop

