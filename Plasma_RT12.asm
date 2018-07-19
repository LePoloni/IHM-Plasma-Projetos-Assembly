# Plasma_RT12.asm (12-07-2017 para rodar no Plasma-v5)
#
# Cria 2 tarefas e faz a prepara��o do escalorador para execut�-las
# Salva o valor inicial do PC de cada tarefa na mem�ria RAM_RT
# Usa os registrador de task_sleep_reg para yield e sleep de tarefas
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

#########################################################################################
#PREPARA��O DO MICROKERNEL
#########################################################################################
inicio:	li	$t1,3		# Tr�s tarefas
	sw	$t1,0xA0($gp)

	li	$t1,0x07	# Tarefas 0~2 (bits 2~0)
	sw	$t1,0xB0($gp)
	
	li	$t1,0x00000331	# Tarefas 1 e 2 com priodedade igual a 3, tarefa 0 com prioridade 1
	sw	$t1,0xC0($gp)

	li	$t1,1000	# 1ms @ 1MHz Tempo entre ticks em clks (deve ser > tempo de back[34] + tempo de restaura��o[68]) 
	sw	$t1,0x90($gp)
	
	li	$t1,0
	sw	$t1,0x0100($gp)	# Tempo de sleep ou yield da tarefa atual

#########################################################################################
#PREPARA��O DAS TAREFAS
#########################################################################################	
	# PC de cada tarefa no 1o endere�o do TCB na mem�ria ram_RT
	# End PC da tarefa 0 = 0x0002 0000
	# End PC da tarefa 1 = 0x0002 0100
	lui	$gp,0x0002	# Atualiza global pointer com os 16 msbs
	
	la	$t1,task0	# Carrega em t1 o endere�o da tarefa 0
	sw	$t1,0x0000($gp)	# Armazena o endere�o da tarefa 0 no TCB da tarefa 0 (1o endere�o)
	
	la	$t1,task1	# Carrega em t1 o endere�o da tarefa 1
	sw	$t1,0x0100($gp)	# Armazena o endere�o da tarefa 1 no TCB da tarefa 1 (1o endere�o)
	
	la	$t1,task2	# Carrega em t1 o endere�o da tarefa 2
	sw	$t1,0x0200($gp)	# Armazena o endere�o da tarefa 2 no TCB da tarefa 2 (2o endere�o)
	
	lui	$gp,0x2000	# Atualiza global pointer com os 16 msbs
	
	li	$t1,1		# Habilita o escalonador
	sw	$t1,0x80($gp)
	
	j	task0
	nop	

#########################################################################################
#POSS�VEIS TAREFAS
#########################################################################################		
task0:	li	$t2,0xFFFF
	li	$t1,0x5554
wait:  	sw	$t2,0x0040($gp)	#Apaga todos os leds
	nop
 	sw	$t1,0x0030($gp)	#Acende os leds alternados
    	nop
	j	wait		#Espera escalonador come�ar a funcionar	realmente e rodar task 1 e task 2
	nop	

task1:	lui	$gp,0x2000	#Ponteiro para os registradores
	lui	$sp,0x0001	#Ponteiro para o stack pointer
	addi	$sp,$sp,0xFFFC	#64 words por tarefa
	
	li	$t0,0xFFFF
	li	$t1,0x0001
	li	$t2,0x00FF	#Oposto da task 1
	li	$t3,0x107D0	# Tempo de sleep = 2000 time slices, bit 16 = 1
    	li	$t4,0x007D0	# Tempo de sleep = 2000 time slices, bit 16 = 0
task1_2:    	sw	$t1,0x0030($gp)	#Acende o led 0
    	nop
    	nop
    	nop
    	nop
	sw	$t0,0x0040($gp)	#Apaga todos os leds
	nop
 	    	
    	lw	$t5,0x50($gp)	# $t5 <- GPIOA
    	andi	$t6,$t5, 0x0001	# $t6 <- 0x0000000? (m�scara para verifica��o da SW0 - EN sleep)
	beqz 	$t6,task1_2	# Se a chave est� em zero desabilita mant�m a execu��o
    	nop
    	
    	sw	$t3,0x0100($gp)	# Tempo de sleep ou yield da tarefa atual (grava o valor na borda de subida do bit 16)
    	sw	$t4,0x0100($gp)	# Tempo de sleep ou yield da tarefa atual (conta enquanto bit 16 = 0)
#    	sw	$0,0x0100($gp)	# Tempo de sleep ou yield da tarefa atual (conta enquanto bit 16 = 0)	
    	
	j	task1_2
	nop

task2:	lui	$gp,0x2000	#Ponteiro para os registradores
	lui	$sp,0x0001	#Ponteiro para o stack pointer
	addi	$sp,$sp,0xFEFC	#64 words por tarefa
	
	li	$t0,0xFFFF
	li	$t1,0x0002	#Oposto da task 0
	li	$t2,0x00FF
    	li	$t3,0x10FA0	# Tempo de sleep = 4000 time slices, bit 16 = 1
    	li	$t4,0x00FA0	# Tempo de sleep = 4000 time slices, bit 16 = 0
task2_2:    	sw	$t1,0x0030($gp)	#Acende o led 1
    	nop
    	nop
    	nop
    	nop
    	sw	$t0,0x0040($gp)	#Apaga todos os leds
    	nop
    	
    	lw	$t5,0x50($gp)	# $t5 <- GPIOA
    	andi	$t6,$t5, 0x0002	# $t6 <- 0x0000000? (m�scara para verifica��o da SW1 - EN sleep)
	beqz 	$t6,task2_2	# Se a chave est� em zero desabilita mant�m a execu��o
    	nop
    	
    	sw	$t3,0x0100($gp)	# Tempo de sleep ou yield da tarefa atual (grava o valor na borda de subida do bit 16)
    	sw	$t4,0x0100($gp)	# Tempo de sleep ou yield da tarefa atual (conta enquanto bit 16 = 0)
#    	sw	$0,0x0100($gp)	# Tempo de sleep ou yield da tarefa atual (conta enquanto bit 16 = 0)	
    	
	j	task2_2
	nop	
