# MIPS_1o.s (cópia comentada do helloworld.s)
#
# Print out "Hello World"

        .data					#os item subseguentes são armazenados do segmento de dados
msg:   .asciiz "Hello World"	#armazena uma string na memória terminada em nulo
	.extern foobar 4			#declarar que os dados armazenados em boobar tem tamanho de 4 bytes cada
								#e define boobar como uma label global

        .text					#os item subseguentes são armazenados do segmento de texto (instruções)
        .globl main				#declara que a label main é global e pode ser referenciada de outros arquivos
main:   li $v0, 4       # syscall 4 (print_str) |$vo = 4, para solicitar um serviço, o programa
												#carrega o código do system call no registrado $v0
        la $a0, msg     # argument: string		|$a0 = end. msg, e os argumentos em $a0~3
        syscall         # print the string		|SPIM prove um conjunto de pequenas serviços de SO
												#através da instrução syscall
        lw $t1, foobar			#$t1 = foobar
        
	#jr $ra          # retrun to caller		|salta para o end. armazenado em $ra
												#como existem um código de boot antes que evite repetições
												#no laço principal, $ra é definido neste boot com
												#endereço anterior a uma syscall de exit		
												#se comentar essa linha e rolar a de baixo o programa
												#fica em loop porém trava o QtSpim
	j main