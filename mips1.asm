# MIPS_1o.s (c�pia comentada do helloworld.s)
#
# Print out "Hello World"

        .data					#os item subseguentes s�o armazenados do segmento de dados
msg:   .asciiz "Hello World"	#armazena uma string na mem�ria terminada em nulo
	.extern foobar 4			#declarar que os dados armazenados em boobar tem tamanho de 4 bytes cada
								#e define boobar como uma label global

        .text					#os item subseguentes s�o armazenados do segmento de texto (instru��es)
        .globl main				#declara que a label main � global e pode ser referenciada de outros arquivos
main:   li $v0, 4       # syscall 4 (print_str) |$vo = 4, para solicitar um servi�o, o programa
												#carrega o c�digo do system call no registrado $v0
        la $a0, msg     # argument: string		|$a0 = end. msg, e os argumentos em $a0~3
        syscall         # print the string		|SPIM prove um conjunto de pequenas servi�os de SO
												#atrav�s da instru��o syscall
        lw $t1, foobar			#$t1 = foobar
        
	#jr $ra          # retrun to caller		|salta para o end. armazenado em $ra
												#como existem um c�digo de boot antes que evite repeti��es
												#no la�o principal, $ra � definido neste boot com
												#endere�o anterior a uma syscall de exit		
												#se comentar essa linha e rolar a de baixo o programa
												#fica em loop por�m trava o QtSpim
	j main