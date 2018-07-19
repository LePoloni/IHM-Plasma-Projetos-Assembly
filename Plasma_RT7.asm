# Plasma_RT7.asm
#
# Cria cinco tarefas e faz a preparação do escalorador para executá-las
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


inicio:	li	$t1,5		# Cinco tarefas
	sw	$t1,0xA0($gp)

#	li	$t1,0x1F	# Tarefas 0~4 (bits 0~4)
	li	$t1,0x0F	# Tarefas 0~4 (bits 0~3)
	sw	$t1,0xB0($gp)
	
	li	$t1,0x00033333	# Tarefas com priodedade igual a 3
	sw	$t1,0xC0($gp)

	li	$t1,160		# Tempo entre ticks em clks (deve ser > tempo de back[34] + tempo de restauração[68]) 
	sw	$t1,0x90($gp)
	
	# PC de cada tarefa no 1o endereço do TCB na memória ram_RT
	# End PC da tarefa 0 = 0x0002 0000
	# End PC da tarefa 1 = 0x0002 0100
	lui	$gp,0x0002	# Atualiza global pointer com os 16 msbs
	
	la	$t1,task0	# Carrega em t1 o endereço da tarefa 0
	sw	$t1,0x0000($gp)	# Armazena o endereço da tarefa 0 no TCB da tarefa 0 (1o endereço)
	
	la	$t1,task1	# Carrega em t1 o endereço da tarefa 1
	sw	$t1,0x0100($gp)	# Armazena o endereço da tarefa 1 no TCB da tarefa 1 (1o endereço)
	
	la	$t1,task2	# Carrega em t1 o endereço da tarefa 2
	sw	$t1,0x0200($gp)	# Armazena o endereço da tarefa 2 no TCB da tarefa 2 (1o endereço)
	
	la	$t1,task3	# Carrega em t1 o endereço da tarefa 3
	sw	$t1,0x0300($gp)	# Armazena o endereço da tarefa 3 no TCB da tarefa 3 (1o endereço)
	
	la	$t1,task4	# Carrega em t1 o endereço da tarefa 4
	sw	$t1,0x0400($gp)	# Armazena o endereço da tarefa 4 no TCB da tarefa 4 (1o endereço)
	
	lui	$gp,0x2000	# Atualiza global pointer com os 16 msbs
	
	li	$t1,1		# Habilita o escalonador
	sw	$t1,0x80($gp)

#.text 0x00000200
# Aramazena o mostra alguns valores de registradores
task0:	lui	$gp,0x2000	# lui carrega o valor passado nos 16 msbs do registrador
				# 0x2000 0000 é o endereço base dos periféricos no uP Plasma
	li	$t0,0xFFF
	li	$t1,0x001
	li	$t2,0x002
	li	$t3,0x003
	li	$t4,0x004

task0_loop:	sw	$t0,0x40($gp)	# GPIO0 <- 0x?????000 (força 0 em todos os 12 lsbs)
	sw	$t0,0x0030($gp)	# GPIO0 <- 0xFFF
	
	sw	$t0,0x40($gp)	# GPIO0 <- 0x?????000 (força 0 em todos os 12 lsbs)
	sw	$t1,0x0030($gp)	# GPIO0 <- valor $x
	
	sw	$t0,0x40($gp)	# GPIO0 <- 0x?????000 (força 0 em todos os 12 lsbs)
	sw	$t2,0x0030($gp)	# GPIO0 <- valor $x
	
	sw	$t0,0x40($gp)	# GPIO0 <- 0x?????000 (força 0 em todos os 12 lsbs)
	sw	$t3,0x0030($gp)	# GPIO0 <- valor $x
	
	sw	$t0,0x40($gp)	# GPIO0 <- 0x?????000 (força 0 em todos os 12 lsbs)
	sw	$t4,0x0030($gp)	# GPIO0 <- valor $x
	
	j	task0_loop
	nop
	
# Aramazena o mostra alguns valores de registradores
task1:	lui	$gp,0x2000	# lui carrega o valor passado nos 16 msbs do registrador
				# 0x2000 0000 é o endereço base dos periféricos no uP Plasma
	li	$t0,0xFFF
	li	$t1,0x101
	li	$t2,0x102
	li	$t3,0x103
	li	$t4,0x104

task1_loop:	sw	$t0,0x40($gp)	# GPIO0 <- 0x?????000 (força 0 em todos os 12 lsbs)
	sw	$t0,0x0030($gp)	# GPIO0 <- 0xFFF
	
	sw	$t0,0x40($gp)	# GPIO0 <- 0x?????000 (força 0 em todos os 12 lsbs)
	sw	$t1,0x0030($gp)	# GPIO0 <- valor $x
	
	sw	$t0,0x40($gp)	# GPIO0 <- 0x?????000 (força 0 em todos os 12 lsbs)
	sw	$t2,0x0030($gp)	# GPIO0 <- valor $x
	
	sw	$t0,0x40($gp)	# GPIO0 <- 0x?????000 (força 0 em todos os 12 lsbs)
	sw	$t3,0x0030($gp)	# GPIO0 <- valor $x
	
	sw	$t0,0x40($gp)	# GPIO0 <- 0x?????000 (força 0 em todos os 12 lsbs)
	sw	$t4,0x0030($gp)	# GPIO0 <- valor $x
	
	j	task1_loop
	nop

# Aramazena o mostra alguns valores de registradores
task2:	lui	$gp,0x2000	# lui carrega o valor passado nos 16 msbs do registrador
				# 0x2000 0000 é o endereço base dos periféricos no uP Plasma
	li	$t0,0xFFF
	li	$t1,0x201
	li	$t2,0x202
	li	$t3,0x203
	li	$t4,0x204

task2_loop:	sw	$t0,0x40($gp)	# GPIO0 <- 0x?????000 (força 0 em todos os 12 lsbs)
	sw	$t0,0x0030($gp)	# GPIO0 <- 0xFFF
	
	sw	$t0,0x40($gp)	# GPIO0 <- 0x?????000 (força 0 em todos os 12 lsbs)
	sw	$t1,0x0030($gp)	# GPIO0 <- valor $x
	
	sw	$t0,0x40($gp)	# GPIO0 <- 0x?????000 (força 0 em todos os 12 lsbs)
	sw	$t2,0x0030($gp)	# GPIO0 <- valor $x
	
	sw	$t0,0x40($gp)	# GPIO0 <- 0x?????000 (força 0 em todos os 12 lsbs)
	sw	$t3,0x0030($gp)	# GPIO0 <- valor $x
	
	sw	$t0,0x40($gp)	# GPIO0 <- 0x?????000 (força 0 em todos os 12 lsbs)
	sw	$t4,0x0030($gp)	# GPIO0 <- valor $x
	
	j	task2_loop
	nop

# Aramazena o mostra alguns valores de registradores
task3:	lui	$gp,0x2000	# lui carrega o valor passado nos 16 msbs do registrador
				# 0x2000 0000 é o endereço base dos periféricos no uP Plasma
	li	$t0,0xFFF
	li	$t1,0x301
	li	$t2,0x302
	li	$t3,0x303
	li	$t4,0x304

task3_loop:	sw	$t0,0x40($gp)	# GPIO0 <- 0x?????000 (força 0 em todos os 12 lsbs)
	sw	$t0,0x0030($gp)	# GPIO0 <- 0xFFF
	
	sw	$t0,0x40($gp)	# GPIO0 <- 0x?????000 (força 0 em todos os 12 lsbs)
	sw	$t1,0x0030($gp)	# GPIO0 <- valor $x
	
	sw	$t0,0x40($gp)	# GPIO0 <- 0x?????000 (força 0 em todos os 12 lsbs)
	sw	$t2,0x0030($gp)	# GPIO0 <- valor $x
	
	sw	$t0,0x40($gp)	# GPIO0 <- 0x?????000 (força 0 em todos os 12 lsbs)
	sw	$t3,0x0030($gp)	# GPIO0 <- valor $x
	
	sw	$t0,0x40($gp)	# GPIO0 <- 0x?????000 (força 0 em todos os 12 lsbs)
	sw	$t4,0x0030($gp)	# GPIO0 <- valor $x
	
	j	task3_loop
	nop
	
#.text 0x00000300
#Mostra o que foi armazenado desligando o escalonador
task4:	lui	$gp,0x2000	# lui carrega o valor passado nos 16 msbs do registrador
				# 0x2000 0000 é o endereço base dos periféricos no uP Plasma

	#Aguarda terminar o backup dos registradores
delay1:	li	$t2,15
	li	$t3,1
	
dec1:	sub	$t2,$t2,$t3	# $t2 <- $t2-1	
	bnez 	$t2,dec1	# salta se $t1 não é igual a 0
	nop

	sw	$zero,0x80($gp)	# Desabilita o escalonador

	li	$t1,0xFFF
	sw	$t1,0x40($gp)	# GPIO0 <- 0x?????000 (força 0 em todos os 12 lsbs)
	li	$t1,0x33
	sw	$t1,0x0030($gp)	# GPIO0 <- 0x33
	
	li	$t1,0xFF
	sw	$t1,0x40($gp)	# GPIO0 <- 0x??????00 (força 0 em todos os 12 lsbs)
	li	$t1,0xCC
	sw	$t1,0x0030($gp)	# GPIO0 <- 0xCC
	
	#Lê backup da task1
	lui	$gp,0x0002	# Seleciona a memória ram_RT

	lw	$s0,0x0000($gp)	# $s1 <- Backup PC
	lw	$s1,0x0100($gp)	# $s2 <- Backup PC
	lw	$s2,0x0200($gp)	# $s3 <- Backup PC
	lw	$s3,0x0300($gp)	# $s4 <- Backup PC

	#Mostra backup
	lui	$gp,0x2000
	
	li	$t1,1		# Habilita o escalonador
	sw	$t1,0x80($gp)
	
	li	$t1,0xFFF

task4_loop:	sw	$t1,0x40($gp)	# GPIO0 <- 0x?????000 (força 0 em todos os 12 lsbs)
	sw	$t1,0x30($gp)	# GPIO0 <- 0x?????FFF (força 1 em todos os 12 lsbs)
	
	sw	$t1,0x40($gp)	# GPIO0 <- 0x?????000 (força 0 em todos os 12 lsbs)
	sw	$s0,0x0030($gp)	# GPIO0 <- valor PC
	
	sw	$t1,0x40($gp)	# GPIO0 <- 0x??????00 (força 0 em todos os 12 lsbs)
	sw	$s1,0x0030($gp)	# GPIO0 <- valor $x
	
	sw	$t1,0x40($gp)	# GPIO0 <- 0x??????00 (força 0 em todos os 12 lsbs)
	sw	$s2,0x0030($gp)	# GPIO0 <- valor $x
	
	sw	$t1,0x40($gp)	# GPIO0 <- 0x??????00 (força 0 em todos os 12 lsbs)
	sw	$s3,0x0030($gp)	# GPIO0 <- valor $x
	
	j	task4_loop
#	j	task4
	nop

