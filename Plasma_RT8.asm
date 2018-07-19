# Plasma_RT8.asm
#
# Cria 6 tarefas e faz a prepara��o do escalorador para execut�-las
# Salva o valor inicial do PC de cada tarefa na mem�ria RAM_RT
# Testa o conte�do salvo pelo context_manager
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


inicio:	li	$t1,6		# 6 tarefas
	sw	$t1,0xA0($gp)

	li	$t1,0x03	# Tarefas 0~5 (bits 0~5) -> somente a tarefa 0 come�a habilitada
	sw	$t1,0xB0($gp)
	
	li	$t1,0x00000001	# Tarefas com priodedade igual a 0, apenas a tarefa 0 com prioridade 1
	sw	$t1,0xC0($gp)

#	li	$t1,160		# Tempo entre ticks em clks (deve ser > tempo de back[34] + tempo de restaura��o[68]) 
#A tarefa 0 precisa de um time slice maior para conseguir rodar ao memos 1 vez antes do wait_flag (time_slice-78)
	li	$t1,260		# Tempo entre ticks em clks (deve ser > tempo de back[34] + tempo de restaura��o[68]) 
	sw	$t1,0x90($gp)
	
	# PC de cada tarefa no 1o endere�o do TCB na mem�ria ram_RT
	# End PC da tarefa 0 = 0x0002 0000
	# End PC da tarefa 1 = 0x0002 0100
	lui	$gp,0x0002	# Atualiza global pointer com os 16 msbs
	
	la	$t1,task0	# Carrega em t1 o endere�o da tarefa 0
	sw	$t1,0x0000($gp)	# Armazena o endere�o da tarefa 0 no TCB da tarefa 0 (1o endere�o)
	
	la	$t1,task1	# Carrega em t1 o endere�o da tarefa 1
	sw	$t1,0x0100($gp)	# Armazena o endere�o da tarefa 1 no TCB da tarefa 1 (1o endere�o)
	
	la	$t1,task2	# Carrega em t1 o endere�o da tarefa 2
	sw	$t1,0x0200($gp)	# Armazena o endere�o da tarefa 2 no TCB da tarefa 2 (1o endere�o)
	
	la	$t1,task3	# Carrega em t1 o endere�o da tarefa 3
	sw	$t1,0x0300($gp)	# Armazena o endere�o da tarefa 3 no TCB da tarefa 3 (1o endere�o)
	
	la	$t1,task4	# Carrega em t1 o endere�o da tarefa 4
	sw	$t1,0x0400($gp)	# Armazena o endere�o da tarefa 4 no TCB da tarefa 4 (1o endere�o)
	
	la	$t1,task5	# Carrega em t1 o endere�o da tarefa 5
	sw	$t1,0x0500($gp)	# Armazena o endere�o da tarefa 5 no TCB da tarefa 5 (1o endere�o)
	
	lui	$gp,0x2000	# Atualiza global pointer com os 16 msbs
	
	li	$t1,1		# Habilita o escalonador
	sw	$t1,0x80($gp)

# Como aqui n�o possui nenhum loop infinito esperando o Micrikernel decidir qual ser� a primeira tarefa,
# o programa entra direto na tarefa 0

#.text 0x00000200
# Aramazena o mostra alguns valores de registradores
task0:	lui	$gp,0x2000	# lui carrega o valor passado nos 16 msbs do registrador
				# 0x2000 0000 � o endere�o base dos perif�ricos no uP Plasma
	li	$t1,0xFFF
	sw	$t1,0x40($gp)	# GPIO0 <- 0x?????000 (for�a 0 em todos os 12 lsbs)
	sw	$t1,0x30($gp)	# GPIO0 <- 0x?????FFF (for�a 1 em todos os 12 lsbs)
	sw	$t1,0x40($gp)	# GPIO0 <- 0x?????000 (for�a 0 em todos os 12 lsbs)
	
	lw	$t1,0x50($gp)	# $t1 <- GPIOA
	sw	$t1,0x30($gp)	# GPIO0 <- GPIOA (for�a 1 em todos os 12 lsbs)
	lw	$t2,0xB0($gp)	# Tarefas 0~5 (bits 0~5)
	
ent1:	li	$t4,0x02	# M�scara de bits
	andi	$t3,$t1, 0x0001	# $t3 <- 0x0000000? (m�scara para verifica��o da SW0 - EN task1)
	beqz 	$t3,ent1_0	# Se a chave est� em zero desabilita a tarefa
	nop
ent1_1:	or 	$t2,$t2,$t4	# $t2 <- tarefas or m�scara (tarefa a ser habilitada)	
	j	ent2
	nop	
ent1_0:	not	$t4,$t4
	and	$t2,$t2,$t4	# $t2 <- tarefas and /m�scara (tarefa a ser desabilitada)

ent2:	li	$t4,0x04	# M�scara de bits
	andi	$t3,$t1, 0x0002	# $t3 <- 0x0000000? (m�scara para verifica��o da SW1 - EN task2)
	beqz 	$t3,ent2_0	# Se a chave est� em zero desabilita a tarefa
	nop
ent2_1:	or	$t2, $t2, $t4	# $t2 <- tarefas or m�scara (tarefa a ser habilitada)		
	j	ent3
	nop	
ent2_0:	not	$t4,$t4		# $t3 <- /$t3
	and	$t2, $t2, $t4	# $t4 <- tarefas and /m�scara (tarefa a ser desabilitada)	
		
ent3:	li	$t4,0x08	# M�scara de bits
	andi	$t3,$t1, 0x0004	# $t3 <- 0x0000000? (m�scara para verifica��o da SW2 - EN task3)
	beqz 	$t3,ent3_0	# Se a chave est� em zero desabilita a tarefa
	nop
ent3_1:	or 	$t2,$t2,$t4	# $t2 <- tarefas or m�scara (tarefa a ser habilitada)	
	j	ent4
	nop	
ent3_0:	not	$t4,$t4
	and	$t2,$t2,$t4	# $t2 <- tarefas and /m�scara (tarefa a ser desabilitada)

ent4:	li	$t4,0x10	# M�scara de bits
	andi	$t3,$t1, 0x0008	# $t3 <- 0x0000000? (m�scara para verifica��o da SW3 - EN task4)
	beqz 	$t3,ent4_0	# Se a chave est� em zero desabilita a tarefa
	nop
ent4_1:	or	$t2, $t2, $t4	# $t2 <- tarefas or m�scara (tarefa a ser habilitada)		
	j	ent5
	nop	
ent4_0:	not	$t4,$t4		# $t3 <- /$t3
	and	$t2, $t2, $t4	# $t4 <- tarefas and /m�scara (tarefa a ser desabilitada)
	
ent5:	li	$t4,0x20	# M�scara de bits
	andi	$t3,$t1, 0x0010	# $t3 <- 0x000000?0 (m�scara para verifica��o da SW4 - EN task5)
	beqz 	$t3,ent5_0	# Se a chave est� em zero desabilita a tarefa
	nop
ent5_1:	or 	$t2,$t2,$t4	# $t2 <- tarefas or m�scara (tarefa a ser habilitada)	
	j	ent6
	nop	
ent5_0:	not	$t4,$t4
	and	$t2,$t2,$t4	# $t2 <- tarefas and /m�scara (tarefa a ser desabilitada)

ent6:	sw	$t2, 0xB0($gp)	# Atualiza estado das Tarefas5~1 (bits 5~1)	
	
	lw	$t2,0xC0($gp)	# Prioridades das Tarefas 5~0 (bits 23~0)

prt1:	li	$t4,0x00000010	# M�scara de bits
	andi	$t3,$t1, 0x0020	# $t3 <- 0x000000?0 (m�scara para verifica��o da SW5 - PRIO task1)
	beqz 	$t3,prt1_0	# Se a chave est� em zero desabilita a tarefa
	nop
prt1_1:	or 	$t2,$t2,$t4	# $t2 <- tarefas or m�scara (tarefa a ser priorizada)	
	j	prt2
	nop	
prt1_0:	not	$t4,$t4
	and	$t2,$t2,$t4	# $t2 <- tarefas and /m�scara (tarefa a ser despriorizada)

prt2:	li	$t4,0x00000100	# M�scara de bits
	andi	$t3,$t1, 0x0040	# $t3 <- 0x000000?0 (m�scara para verifica��o da SW6 - PRIO task2)
	beqz 	$t3,prt2_0	# Se a chave est� em zero desabilita a tarefa
	nop
prt2_1:	or 	$t2,$t2,$t4	# $t2 <- tarefas or m�scara (tarefa a ser priorizada)	
	j	prt3
	nop	
prt2_0:	not	$t4,$t4
	and	$t2,$t2,$t4	# $t2 <- tarefas and /m�scara (tarefa a ser despriorizada)

prt3:	li	$t4,0x00001000	# M�scara de bits
	andi	$t3,$t1, 0x0080	# $t3 <- 0x000000?0 (m�scara para verifica��o da SW7 - PRIO task3)
	beqz 	$t3,prt3_0	# Se a chave est� em zero desabilita a tarefa
	nop
prt3_1:	or 	$t2,$t2,$t4	# $t2 <- tarefas or m�scara (tarefa a ser priorizada)	
	j	prt4
	nop	
prt3_0:	not	$t4,$t4
	and	$t2,$t2,$t4	# $t2 <- tarefas and /m�scara (tarefa a ser despriorizada)

prt4:	li	$t4,0x00010000	# M�scara de bits
	andi	$t3,$t1, 0x0100	# $t3 <- 0x00000?00 (m�scara para verifica��o da SW8 - PRIO task4)
	beqz 	$t3,prt4_0	# Se a chave est� em zero desabilita a tarefa
	nop
prt4_1:	or 	$t2,$t2,$t4	# $t2 <- tarefas or m�scara (tarefa a ser priorizada)	
	j	prt5
	nop	
prt4_0:	not	$t4,$t4
	and	$t2,$t2,$t4	# $t2 <- tarefas and /m�scara (tarefa a ser despriorizada)

prt5:	li	$t4,0x00100000	# M�scara de bits
	andi	$t3,$t1, 0x0200	# $t3 <- 0x00000?00 (m�scara para verifica��o da SW9 - PRIO task5)
	beqz 	$t3,prt5_0	# Se a chave est� em zero desabilita a tarefa
	nop
prt5_1:	or 	$t2,$t2,$t4	# $t2 <- tarefas or m�scara (tarefa a ser priorizada)	
	j	prt6
	nop	
prt5_0:	not	$t4,$t4
	and	$t2,$t2,$t4	# $t2 <- tarefas and /m�scara (tarefa a ser despriorizada)

prt6:	sw	$t2,0xC0($gp)	# Atualiza prioridades das Tarefas 5~1 (bits 23~4)

	j	task0
	nop

task1:	lui	$gp,0x2000	# lui carrega o valor passado nos 16 msbs do registrador
				# 0x2000 0000 � o endere�o base dos perif�ricos no uP Plasma
	li	$t0,0xFFF
	li	$t1,0x001
	
	sw	$t0,0x0040($gp)	# GPIO0 <- 0x?????000 (for�a 0 em todos os 12 lsbs)
	sw	$t1,0x0030($gp)	# GPIO0 <- valor $x
	j	task1
	nop

task2:	lui	$gp,0x2000	# lui carrega o valor passado nos 16 msbs do registrador
				# 0x2000 0000 � o endere�o base dos perif�ricos no uP Plasma
	li	$t0,0xFFF
	li	$t1,0x002
	
	sw	$t0,0x0040($gp)	# GPIO0 <- 0x?????000 (for�a 0 em todos os 12 lsbs)
	sw	$t1,0x0030($gp)	# GPIO0 <- valor $x
	j	task2
	nop

task3:	lui	$gp,0x2000	# lui carrega o valor passado nos 16 msbs do registrador
				# 0x2000 0000 � o endere�o base dos perif�ricos no uP Plasma
	li	$t0,0xFFF
	li	$t1,0x004
	
	sw	$t0,0x0040($gp)	# GPIO0 <- 0x?????000 (for�a 0 em todos os 12 lsbs)
	sw	$t1,0x0030($gp)	# GPIO0 <- valor $x
	j	task3
	nop

task4:	lui	$gp,0x2000	# lui carrega o valor passado nos 16 msbs do registrador
				# 0x2000 0000 � o endere�o base dos perif�ricos no uP Plasma
	li	$t0,0xFFF
	li	$t1,0x008
	
	sw	$t0,0x0040($gp)	# GPIO0 <- 0x?????000 (for�a 0 em todos os 12 lsbs)
	sw	$t1,0x0030($gp)	# GPIO0 <- valor $x
	j	task4
	nop	
	
#.text 0x00000300
#Mostra o que foi armazenado desligando o escalonador
task5:	lui	$gp,0x2000	# lui carrega o valor passado nos 16 msbs do registrador
				# 0x2000 0000 � o endere�o base dos perif�ricos no uP Plasma

	#Aguarda terminar o backup dos registradores
delay1:	li	$t2,15
	li	$t3,1
	
dec1:	sub	$t2,$t2,$t3	# $t2 <- $t2-1	
	bnez 	$t2,dec1	# salta se $t1 n�o � igual a 0
	nop

	sw	$zero,0x80($gp)	# Desabilita o escalonador

	li	$t1,0xFFF
	sw	$t1,0x40($gp)	# GPIO0 <- 0x?????000 (for�a 0 em todos os 12 lsbs)
	li	$t1,0x333
	sw	$t1,0x0030($gp)	# GPIO0 <- 0x333
	
	li	$t1,0xFFF
	sw	$t1,0x40($gp)	# GPIO0 <- 0x??????00 (for�a 0 em todos os 12 lsbs)
	li	$t1,0xCCC
	sw	$t1,0x0030($gp)	# GPIO0 <- 0xCC
	
	#L� backup da task1
	lui	$gp,0x0002	# Seleciona a mem�ria ram_RT

	lw	$s0,0x0000($gp)	# $s0 <- Backup PC
	lw	$s1,0x0100($gp)	# $s1 <- Backup PC
	lw	$s2,0x0200($gp)	# $s2 <- Backup PC
	lw	$s3,0x0300($gp)	# $s3 <- Backup PC
	lw	$s4,0x0400($gp)	# $s4 <- Backup PC

	#Mostra backup do PC de cada tarefa
	lui	$gp,0x2000
	
	li	$t1,1		# Habilita o escalonador
	sw	$t1,0x80($gp)
	
	li	$t1,0xFFF
	sw	$t1,0x40($gp)	# GPIO0 <- 0x?????000 (for�a 0 em todos os 12 lsbs)
	sw	$t1,0x30($gp)	# GPIO0 <- 0x?????FFF (for�a 1 em todos os 12 lsbs)
	
	sw	$t1,0x40($gp)	# GPIO0 <- 0x?????000 (for�a 0 em todos os 12 lsbs)
	sw	$s0,0x0030($gp)	# GPIO0 <- valor PC
	
	sw	$t1,0x40($gp)	# GPIO0 <- 0x??????00 (for�a 0 em todos os 12 lsbs)
	sw	$s1,0x0030($gp)	# GPIO0 <- valor $x
	
	sw	$t1,0x40($gp)	# GPIO0 <- 0x??????00 (for�a 0 em todos os 12 lsbs)
	sw	$s2,0x0030($gp)	# GPIO0 <- valor $x
	
	sw	$t1,0x40($gp)	# GPIO0 <- 0x??????00 (for�a 0 em todos os 12 lsbs)
	sw	$s3,0x0030($gp)	# GPIO0 <- valor $x
	
	sw	$t1,0x40($gp)	# GPIO0 <- 0x??????00 (for�a 0 em todos os 12 lsbs)
	sw	$s4,0x0030($gp)	# GPIO0 <- valor $x
	
	#Aguarda terminar o time slice (tempo do loop = $t2 x 3)
#delay2:	li	$t2,50
#Ajusta para time slice de 260
delay2:	li	$t2,80
	li	$t3,1
	
dec2:	sub	$t2,$t2,$t3	# $t2 <- $t2-1	
	bnez 	$t2,dec2	# salta se $t1 n�o � igual a 0
	nop

	j	task5
	nop

