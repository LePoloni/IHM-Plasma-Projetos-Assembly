# Plasma_ST4.asm (standard)
#
# Habilita interrupção de contador e alternar entre sinalização com bit em 1 e 0.
# Além disso alterna entre duas tarefas.
#
# Para uso na CPU Plasma:
# Usar a configuração de memória "Comapct, Text at Address 0" (Settings -> Memory Configuration..)
# Dessa forma o programa é carregado a partir do endereço 0 onde começa os 8kB de memória interna do Plasma

#data
#fout:   .asciiz "testout.txt"      # filename for output
#buffer: .asciiz "The quick brown fox jumps over the lazy dog."

	.data
buffer:  .asciiz "Teste"
        .text			# os itens subseguentes são armazenados no segmento de texto (instruções)
        .globl main		# declara que a label main é global e pode ser referenciada de outros arquivos
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

#########################################################################################
#TRATAMENTO DE INTERRUPÇÕES/EXCEÇÕES
#########################################################################################
#.ktext	0x0000003c	#não funcionou por conta da software de conversão de Steve Rhoads!!!
int:	mtc0 	$0, $12	#COP0 STATUS=1; disable interrupts mtc0 (creio que isso não é necessário)

#########################################################################################
#DEBUG - ACENDE UM LED
	lui	$k1,0x2000
	li	$k0,0xFFFF
	sw	$k0,0x0040($gp)	#Apaga todos os leds
	li	$k0,0x0100
    	sw	$k0,0x0030($k1)	#Acende o led 8
#########################################################################################
#VERIFICA QUANTAS INTERRUPÇÇÕES OCORRERAM (isso não resolve pq o bit do timer continua em 1)
#	lui	$k1,0x1000
#	lw	$k0,4($k1)
#	addi	$k0,$k0,1
#	sw	$k0,4($k1)	#Atualiza o número de interrupções

#	beq	$k0,3,trata_int	#Define o número de interrupções necessárias pelo teste

#retorna:	li 	$k0,0x01
#	mtc0 	$k0, $12	#COP0 STATUS=1; enable interrupts mtc0
#	mfc0	$k0, $14	#COP0 Lê o PC salvo no endereço 0 dos registradores
#	jr	$k0	
#	nop
#trata_int:	lw	$0,4($k1)	#Zera o contador
#INVERTE A INTERRUPÇÃO HABILITADA (COUNTER_REG <-> NOT_COUNTER_REG)
	lw	$k0,0x10($k1)	#Lê o valor IRQ Mask
	xor	$k0,$k0,0x000C	#Inverte o estado dos bit de CONUNTER
	sw	$k0,0x10($k1)	#Atualiza a máskara IRQ Mask
#########################################################################################
#BACKUP PARA TAREFA EM ANDAMENTO NO STACK PADRÃO
	lui	$k1,0x0001	#Acesso ao seguimento de dados (0x0001.0000)
	lw	$k0,0($k1)	#Lê a variável global que armazena o offset do TCB da tarefa em execução (0x??00)
	lui	$k1,0x0002	#Carrega o endereço do TCB da task 0 (0x0002.0000)
	add	$k1,$k1,$k0	#Monta o endereço do TCB da tarefa em execução (0x0002.??00)
	
	#Backup do PC
	mfc0	$k0,  $14       #C0_EPC=14 (Exception PC)
	addi	$k0,  $k0,-4	#Backup one opcode
	sw	$k0,  0($k1)   	#pc	
	#Backup dos demais registradores
	sw	$1,   4($k1)    #at
   	sw	$2,   8($k1)    #v0
   	sw    	$3,  12($k1)    #v1
   	sw    	$4,  16($k1)    #a0
   	sw    	$5,  20($k1)    #a1
   	sw    	$6,  24($k1)    #a2
   	sw    	$7,  28($k1)    #a3
   	sw    	$8,  32($k1)    #t0
   	sw    	$9,  36($k1)    #t1
   	sw    	$10, 40($k1)    #t2
   	sw    	$11, 44($k1)    #t3
   	sw    	$12, 48($k1)    #t4
   	sw    	$13, 52($k1)    #t5
   	sw    	$14, 56($k1)    #t6
   	sw    	$15, 60($k1)    #t7
   	sw    	$16, 64($k1)    #s0
   	sw    	$17, 58($k1)    #s1
   	sw    	$18, 72($k1)    #s2
   	sw    	$19, 76($k1)    #s3
   	sw    	$20, 80($k1)    #s4
   	sw    	$21, 84($k1)    #s5
   	sw    	$22, 88($k1)    #s6
   	sw    	$23, 92($k1)    #s7
   	sw    	$24, 96($k1)    #t8
   	sw    	$25,100($k1)    #t9
  	#sw	$26,104($k1)    #k0	#Usado para SO
   	#sw	$27,108($k1)    #k1	#Usado para SO
   	sw	$28,112($k1)    #gp
   	sw	$29,116($k1)    #sp
   	sw	$30,120($k1)    #fp
   	sw    	$31,124($k1)    #ra
#########################################################################################
#DEBUG - ACENDE UM LED
	li	$k0,0x0200
	lui	$k1,0x2000
    	sw	$k0,0x0030($k1)		#Acende o led 9
#########################################################################################
#IDENTIFICA A TAREFA QUE ENTRARÁ EM EXECUÇÃO (SIMULA O ESCALONADOR SIMPLIFICADO)
	lui	$k1,0x0001	#Acesso ao seguimento de dados (0x0001.0000)
	lw	$k0,0($k1)	#Lê a variável global que armazena o offset do TCB da tarefa em execução
	
	andi	$k0,$k0,0x0100	#Verifica qual tarefa estava em execução
	
	beqz	$k0,rest_task1	#Se foi a 0, restaura task 1
	nop			#Senão, restaura task 0

rest_task0:	lui	$k1,0x0001	#Acesso ao seguimento de dados (0x0001.0000)
	sw	$0,0($k1)		#Grava a indicação do TCB da próxima tarefa
	lui	$k1,0x0002		#Carrega o endereço do TCB da task 0 (0x0002.0000)
	j	rest
	nop
rest_task1:	lui	$k1,0x0001	#Acesso ao seguimento de dados (0x0001.0000)
	li	$k0,0x0100		#Faz o offset para task 1 (0x0100)	
	sw	$k0,0($k1)		#Grava a indicação do TCB da próxima tarefa
	lui	$k1,0x0002		#Carrega o endereço do TCB da task 0 (0x0002.0000)
	addi	$k1,$k1,0x0100		#Faz o offset para task 1 (0x0002.0100)
	j	rest
	nop
#########################################################################################
#RESTAURA CONTEXTO PARA TAREFA QUE ENTRARÁ EM EXECUÇÃO
	#Restaura o PC
rest:	lw	$k0,  0($k1)   	#pc
	#Restaura os demais registradores
	lw	$1,   4($k1)    #at
   	lw	$2,   8($k1)    #v0
   	lw    	$3,  12($k1)    #v1
   	lw    	$4,  16($k1)    #a0
   	lw    	$5,  20($k1)    #a1
   	lw    	$6,  24($k1)    #a2
   	lw    	$7,  28($k1)    #a3
   	lw    	$8,  32($k1)    #t0
   	lw    	$9,  36($k1)    #t1
   	lw    	$10, 40($k1)    #t2
   	lw    	$11, 44($k1)    #t3
   	lw    	$12, 48($k1)    #t4
   	lw    	$13, 52($k1)    #t5
   	lw    	$14, 56($k1)    #t6
   	lw    	$15, 60($k1)    #t7
   	lw    	$16, 64($k1)    #s0
   	lw    	$17, 58($k1)    #s1
   	lw    	$18, 72($k1)    #s2
   	lw    	$19, 76($k1)    #s3
   	lw    	$20, 80($k1)    #s4
   	lw    	$21, 84($k1)    #s5
   	lw    	$22, 88($k1)    #s6
   	lw    	$23, 92($k1)    #s7
   	lw    	$24, 96($k1)    #t8
   	lw    	$25,100($k1)    #t9
  	#lw	$26,104($k1)    #k0	#Usado para SO
   	#lw	$27,108($k1)    #k1	#Usado para SO
   	lw	$28,112($k1)    #gp
   	lw	$29,116($k1)    #sp
   	lw	$30,120($k1)    #fp
   	lw    	$31,124($k1)    #ra
#########################################################################################
#DEBUG - APAGA LEDS
	li	$k1,0x0FFF
	lui	$fp,0x2000	#<----- Usei o $fp (CUIDADO!!!)	
    	sw	$k1,0x0040($fp)	#Apaga leds
#########################################################################################
#RETORNA DA INTERRUPÇÃO
	ori   	$k1, $0, 0x1    #re-enable interrupts (grava 1 em $k1)
   	jr    	$k0		#Desvia para a nova tarefa
   	mtc0  	$k1, $12        #COP0 STATUS=1; enable interrupts (lembrar que o Plasma sempre executa uma instrução após uma instrução de desvio)	

#########################################################################################
#PREPARAÇÃO DAS TAREFAS
#########################################################################################
ini:	lui	$k1,0x0002	#Carrega o endereço do TCB da task 0 (0x0002.0000)
	la	$k0,task0	#Armazena o endereço da task 0
	sw	$k0,0($k1)	#Armazena o endereço da task 0 na TCB
	
	addi	$k1,$k1,0x0100	#Faz o offset para task 1 (0x0002.0100)
	la	$k0,task1	#Armazena o endereço da task 1
	sw	$k0,0($k1)	#Armazena o endereço da task 1 na TCB
	
	lui	$k1,0x0001	#Acesso ao seguimento de dados (0x0001.0000)
	li	$k0,0x0200	#Offset do TCB da task 2 (inexistente)
	sw	$k0,0($k1)	#Define que a tarefa inicial em em execução é a task 2 (para não atrapalhar o PC)
	
	li	$t3,0xFFFF
	li	$t4,0x5555
wait:  	sw	$t3,0x0040($gp)	#Apaga todos os leds
	nop
 	sw	$t4,0x0030($gp)	#Acende os leds alternados
    	nop
	j	wait		#Espera por uma interrupção para começar a alternar entre as tarefas	
	nop	

#########################################################################################
#POSSÍVEIS TAREFAS
#########################################################################################		
task0:	lui	$gp,0x2000	#Ponteiro para os registradores
	lui	$sp,0x0001	#Ponteiro para o stack pointer
	addi	$sp,$sp,0xFFFC	#64 words por tarefa
	
	li	$t0,0xFFFF
	li	$t1,0x0001
	li	$t2,0x00FF	#Oposto da task 1
task0_2:    	sw	$t0,0x0040($gp)	#Apaga todos os leds
	nop
 	sw	$t1,0x0030($gp)	#Acende o led 0
    	nop
	j	task0_2
	nop

task1:	lui	$gp,0x2000	#Ponteiro para os registradores
	lui	$sp,0x0001	#Ponteiro para o stack pointer
	addi	$sp,$sp,0xFEFC	#64 words por tarefa
	
	li	$t0,0xFFFF
	li	$t1,0x00FF	#Oposto da task 0
	li	$t2,0x0002
task1_2:    	sw	$t0,0x0040($gp)	#Apaga todos os leds
    	nop
    	sw	$t2,0x0030($gp)	#Acende o led 1
    	nop
	j	task1_2
	nop	

    	
    	
    	
