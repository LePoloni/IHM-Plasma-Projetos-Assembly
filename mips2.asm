# MIPS_1o.s (cópia comentada do helloworld.s)
#
# Print out "Hello World"

        .data					#os itens subseguentes são armazenados no segmento de dados
msg:    .asciiz "Teste Subrotinas\n"		#armazena uma string na memória terminada em nulo
msg2:	.asciiz "\nFim do Teste"
	.extern foobar 4			#declarar que os dados armazenados em boobar tem tamanho de 4 bytes cada
						#e define boobar como uma label global

        .text					#os itens subseguentes são armazenados no segmento de texto (instruções)
        .globl main				#declara que a label main é global e pode ser referenciada de outros arquivos
main:   li $v0, 4       			# syscall 4 (print_str) |$vo = 4, para solicitar um serviço, o programa
												#carrega o código do system call no registrado $v0
        la $a0, msg     			# argument: string	|$a0 = end. msg, e os argumentos em $a0~3
        syscall         			# print the string	|SPIM prove um conjunto de pequenas serviços de SO
	
	addiu $a0, $0, 1	#move 1 para $a0
	addiu $s0, $0, 10	#move 10 para $s0
loop:
	jal inc_reg		#chama a subrotina de incremento
	beq $v0, $s0, fim	#branch if equal
	abs $a0, $v0		#copia o resultado($v0) em $a0
	li $v0, 1 		# system call code for print_int
	syscall 		# print the int
	j loop			#volta para chamada da subrotina
fim:
	li $v0, 4   		# syscall 4 (print_str) |$vo = 4, para solicitar um serviço, o programa
        la $a0, msg2     	# argument: string	|$a0 = end. msg, e os argumentos em $a0~3
        syscall        
	li $v0, 10		# syscall 10 (exit)
	 syscall

inc_reg:
	addiu $v0, $a0, 1	#$v0 = $a0+1
	jr $ra			#retorna da subrotina para o endereço automaticamente armazenado em $ra (jal)								
