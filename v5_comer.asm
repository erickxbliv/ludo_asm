.data
	caminho: .asciiz "a----------b----------c----------d----------|   \n"		#esses espacos ajuda a ver se alguem sair (e alinham o endereco para um valor par)
	vitoria_a: .asciiz "-----"		#o tubo da vitoria so vai ate o penultimo, o primeiro a sair fica na ponta, o ultimo no centro (102)
	vitoria_b: .asciiz "-----"
	vitoria_c: .asciiz "-----"
	vitoria_d: .asciiz "-----"
	
	tubo_a: .word 0
	tubo_b: .word 0
	tubo_c: .word 0
	tubo_d: .word 0
	
	rota: .word 81,82,83,84,69,53,37,21,5,6,7,23,39,55,71,88,89,90,91,92,108,124,123,122,121,120,135,151,167,183,199,198,197,
	181,165,149,133,116,115,114,113,112,96,80
	
	a: .word 97 #("a")
	b: .word 98 #("b")
	c: .word 99 #("d")
	d: .word 100 #("d")
	vazio: .word 45 #("-")
	
	primeira_a: .word 0			#casa onde a peca comeca, e onde nascem pecas novas PELO CAMINHO
	primeira_b: .word 11
	primeira_c: .word 22
	primeira_d: .word 33
	
	estrelas: .word 81,23,123,181		#casa onde a peca comeca, e onde nascem pecas novas PELO VETOR MATRIZ DO TABULEIRO
	
	
	ultima_a: .word 100	#41		#o peao A nunca da a volta no tabuleiro
	ultima_b: .word 100	#9		#os valores comecam altos porque se nao, os peoes ganhariam o tempo todo
	ultima_c: .word 100	#20		#o peao precisa dar a volta no tabuleiro para ganhar, quando ele faz 1 volta
	ultima_d: .word 100	#31		#o valor da sua casa de morte e atualizado para assim fazer a checagem
	
	conversor: .word 48
	
	times: .word 4
	distancia: .word 11
	peoes: .word 4
	
	#array de peoes de cada time:
	
	direcao: .asciiz "lllEnnnnllssssCllllssooooZssssoonnnnQoooonnl"
	mensagem_1: .asciiz "Turno de "
	msg_a: .asciiz "A (amarelo)!"
	msg_b: .asciiz "B (azul)!"
	msg_c: .asciiz "C (vermelho)!"
	msg_d: .asciiz "D (verde)!"
	mensagem_2: .asciiz " Pressione qualquer tecla para jogar o dado: "
	mensagem_3: .asciiz "\nParabens! Vitoria de "
	mensagem_4: .asciiz "Tirou "
	
	casa_a: .word 0,1,2,3,4,   16,17,18,19,20,   32,33,34,35,36,   48,49,50,51,52,   64,65,66,67,68,   81,97,98,99,100,101,117
	casa_b: .word 8,9,10,11,12,   24,25,26,27,28,   40,41,42,43,44,   56,57,58,59,60,   72,73,74,75,76,   23,22,38,54,70,86,85
	casa_c: .word 136,137,138,139,140,   152,153,154,155,156,   168,169,170,171,172,   184,185,186,187,188,   200,201,202,203,204,   123,107,106,105,104,103,87
	casa_d: .word 128,129,130,131,132,   144,145,146,147,148,   160,161,162,163,164,   176,177,178,179,180,   192,193,194,195,196,   181,182,166,150,134,118,119
	
	casas_estrela: .word 81,23,123,181
	bordas: .word 208,209,210,211,212,213,214,215,216,217,218,219,220,221,13,29,45,61,77,93,109,125,141,157,173,189,205
	14,30,46,62,78,94,110,126,142,158,174,190,206,222,238,224,225,226,227,228,229,230,231,232,233,234,235,236,237
	15,31,47,63,79,95,111,127,143,159,175,191,207,223,239,255,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254
	
	green:  		.word 	0x00CC00
	dark_green:     	.word 	0x006600
	red:	        	.word 	0xFF0000
	dark_red:		.word 	0x660000
	blue:	        	.word 	0x0066CC
	dark_blue:		.word 	0x000099
	yellow:         	.word 	0xFFFF33
	dark_yellow:    	.word 	0xDAA520
	
	white:			.word 	0xFFFFFF
	black:			.word  	0x000000

.text
	
	j main 			#pula essas funcoes aqui
	pixel:
	
		sll $s1, $s1, 2		#multiplica o valor do indice por 4, que e o tamanho do dado word (numero)
		add $s1, $s1, $gp	#andar em gp esse valor para obter o endereco do indice procurado e por em s1
		sw  $t7, 0($s1)		#coloca a cor dentro do endereco desse indice
		jr $ra
		
	checagem:
	
		jr $ra
		
	usuario:		#essa funcao pede que o usuario jogue o dado e da um \n
		
		move $a3,$a0
		li $v0, 4
		la $a0,mensagem_1
		syscall		#imprime a mensagem 1
		la $a0,0($t5)
		syscall		#imprime a mensagem do grupo X
		la $a0,mensagem_2
		syscall		#imprime a mensagem 2
		
		li $v0, 12 
		syscall		#pede um input
		li $v0, 11
		li $a0,10
		syscall		#quebra a linha
		li $v0, 4
		la $a0,mensagem_4
		syscall		#imprime a mensagem 4
		
		
		li $v0,1
		move $a0,$a3
		syscall		#imprime o que tirou no dado
		li $v0,11
		li $a0,32
		syscall		#da um espaco
		jr $ra
		
	impressao:		#funcao de imprimir, chamada com jump ou branch
		
		li $v0,4
		la $a0,caminho
		syscall		#mostra caminho
		jr $ra		#volta exatamente de onde parou
		
	devolver_cor:		#essa funcao serve pra quando a peca sair de uma estrela, devolver a cor original dela inves de preto
	
		beq $t4,0,estrela_1
		beq $t4,11,estrela_2
		beq $t4,22,estrela_3
		beq $t4,33,estrela_4
		lw $t7,black	#se for uma casa simples, o branch nao acontece deixa preto e volta
		jr $ra
		
		estrela_1:	#aqui altera a cor pra cada casa estrela
			lw $t7,yellow
			jr $ra
		estrela_2:
			lw $t7,blue
			jr $ra
		estrela_3:
			lw $t7,red
			jr $ra
		estrela_4:
			lw $t7,green
			jr $ra
	
	main:
	
	move $t0, $zero		#casa do a
	li $t1, 11		#casa do b
	li $t2, 22		#casa do c
	li $t3, 33		#casa do d
	move $t4, $zero		#backup casa anterior dos jogadores
	
	move $t5, $zero		#registrador de uso instantaneo, imediato
	move $t6, $zero		#registrador comum de mexer em enderecos
	move $t7, $zero		#registrador de argumento das minhas funcoes
	
	move $s0, $zero 	#boolean de vitoria
	move $s1, $zero		#endereco do indice no vetor matriz de gp pra mexer nos pixels
	move $s2, $zero		#guarda o vencedor
	
	la $t5,impressao	
	jalr $t5		#aqui chama a fucao de imprimir
	
	#-----------------------------------------------------------------
	
	#X LIMPAR O CAMINHO DA PARTIDA ANTERIOR
	#X REIMPRIMIR AS CASAS ESTRELA
	#  TERMINAR ALGUMAS REGRAS COMO NAO PODER ACESSAR A MESMA CASA
	#  ENTRAR NO CAMINHO NOVO PARA A CONDICAO DE VITORIA
	#X PEDIR AO USUARIO QUE JOGUE O DADO
	#  SE POSSIVEL, ADICIONAR A FUNCAO DE COMER AS PECAS INIMIGAS
	#  PARA O ITEM ACIMA, ADICIONAR A SAIDA DE PECAS DA CASA PARA O TABULEIRO
	
	#  COMPLEMENTO PARA O ITEM ACIMA, ADICIONAR MAIS UMA PECA AOS JOGADORES E TURNO ENTRE ELAS
	#  OTIMIZACAO, TIRAR PSEUDO CODIGO
	
	lw $t7,black			#coloca no meu proprio argumento de funcao a cor do time
	move $t5,$zero
		
	for_clear:			#pequeno loop pra percorrer o vetor
		la $t6,rota		#meu registrador de enderecos pega o endereco do indice 0 do vetor em questao
		add $t6,$t6,$t5		#anda nesse endereco inicial o indice em t5 pra chegar no endereco desse indice
		lw $s1, 0($t6)		#coloca em s1 responsavel por guardar os pixels o valor naquele indice do vetor
		jal pixel		#chama a funcao pixel e volta aqui
		beq $t5,172,sair_clear	#se ja percorreu todo o vetor sai, se nao:
		addi $t5,$t5,4		#anda mais um indice considerando o tamanho de um numero (4) e reinicia o loop
		j for_clear
			
	sair_clear:
	
	lw $t7,yellow			#coloca no meu proprio argumento de funcao a cor do time
	move $t5,$zero
		
	for_a:				#pequeno loop pra percorrer o vetor
		la $t6,casa_a		#meu registrador de enderecos pega o endereco do indice 0 do vetor em questao
		add $t6,$t6,$t5		#anda nesse endereco inicial o indice em t5 pra chegar no endereco desse indice
		lw $s1, 0($t6)		#coloca em s1 responsavel por guardar os pixels o valor naquele indice do vetor
		jal pixel		#chama a funcao pixel e volta aqui
		beq $t5,124,sair_a	#se ja percorreu todo o vetor sai, se nao:
		addi $t5,$t5,4		#anda mais um indice considerando o tamanho de um numero (4) e reinicia o loop
		j for_a
			
	sair_a:
	
	lw $t7,blue			#coloca no meu proprio argumento de funcao a cor do time
	move $t5,$zero
		
	for_b:				#pequeno loop pra percorrer o vetor
		la $t6,casa_b		#meu registrador de enderecos pega o endereco do indice 0 do vetor em questao
		add $t6,$t6,$t5		#anda nesse endereco inicial o indice em t5 pra chegar no endereco desse indice
		lw $s1, 0($t6)		#coloca em s1 responsavel por guardar os pixels o valor naquele indice do vetor
		jal pixel		#chama a funcao pixel e volta aqui
		beq $t5,124,sair_b	#se ja percorreu todo o vetor sai, se nao:
		addi $t5,$t5,4		#anda mais um indice considerando o tamanho de um numero (4) e reinicia o loop
		j for_b
			
	sair_b:
	
	lw $t7,red			#coloca no meu proprio argumento de funcao a cor do time
	move $t5,$zero
		
	for_c:				#pequeno loop pra percorrer o vetor
		la $t6,casa_c		#meu registrador de enderecos pega o endereco do indice 0 do vetor em questao
		add $t6,$t6,$t5		#anda nesse endereco inicial o indice em t5 pra chegar no endereco desse indice
		lw $s1, 0($t6)		#coloca em s1 responsavel por guardar os pixels o valor naquele indice do vetor
		jal pixel		#chama a funcao pixel e volta aqui
		beq $t5,124,sair_c	#se ja percorreu todo o vetor sai, se nao:
		addi $t5,$t5,4		#anda mais um indice considerando o tamanho de um numero (4) e reinicia o loop
		j for_c
			
	sair_c:
	
	lw $t7,green			#coloca no meu proprio argumento de funcao a cor do time
	move $t5,$zero
		
	for_d:				#pequeno loop pra percorrer o vetor
		la $t6,casa_d		#meu registrador de enderecos pega o endereco do indice 0 do vetor em questao
		add $t6,$t6,$t5		#anda nesse endereco inicial o indice em t5 pra chegar no endereco desse indice
		lw $s1, 0($t6)		#coloca em s1 responsavel por guardar os pixels o valor naquele indice do vetor
		jal pixel		#chama a funcao pixel e volta aqui
		beq $t5,124,sair_d	#se ja percorreu todo o vetor sai, se nao:
		addi $t5,$t5,4		#anda mais um indice considerando o tamanho de um numero (4) e reinicia o loop
		j for_d
			
	sair_d:
	
	lw $t7,white			#coloca no meu proprio argumento de funcao a cor do time
	move $t5,$zero
		
	for_bordas:			#pequeno loop pra percorrer o vetor
		la $t6,bordas		#meu registrador de enderecos pega o endereco do indice 0 do vetor em questao
		add $t6,$t6,$t5		#anda nesse endereco inicial o indice em t5 pra chegar no endereco desse indice
		lw $s1, 0($t6)		#coloca em s1 responsavel por guardar os pixels o valor naquele indice do vetor
		jal pixel		#chama a funcao pixel e volta aqui
		beq $t5,344,sair_bordas	#se ja percorreu todo o vetor sai, se nao:
		addi $t5,$t5,4		#anda mais um indice considerando o tamanho de um numero (4) e reinicia o loop
		j for_bordas
			
	sair_bordas:
	
	nascimento:			#essa funcao horrivel ela mostra as pecas logo ao nascerem, antes do primeiro turno
		
		lw $t7,dark_yellow
		move $t5,$zero
		la $t6,estrelas		
		add $t6,$t6,$t5		
		lw $s1, 0($t6)		
		jal pixel		
		
		addi $t5,$t5,4
		lw $t7,dark_blue
		la $t6,estrelas		
		add $t6,$t6,$t5		
		lw $s1, 0($t6)		
		jal pixel
		
		addi $t5,$t5,4
		lw $t7,dark_red
		la $t6,estrelas		
		add $t6,$t6,$t5		
		lw $s1, 0($t6)		
		jal pixel
		
		addi $t5,$t5,4
		lw $t7,dark_green
		la $t6,estrelas		
		add $t6,$t6,$t5		
		lw $s1, 0($t6)		
		jal pixel
	
	#-----------------------------------------------------------------
	
	while:
		beq $s0,40,fim		#condicao da partida estar rolando, se n pula pra apos o loop, contagem pra evitar bug

		#mexer a -------------------------------------
		
		add $t4,$t0,$zero	#backup fazendo backup
		li $v0, 42 
		li $a1,6 		#atualizando dados da funcao random
		syscall

		addi $a0,$a0,1		#colocar o valor obtido dentro do intervalo de um dado cubico
		add $t0,$t0,$a0		#a anda o valor aleatorio da casa
		
		la $t5,msg_a		#colocar a mensagem que se altera pra cada peao no instantaneo, e da vez ao usuario
		jal usuario

		bgt $t0,43,Ifa
		j Endifa
		Ifa:			#esse comando permite o peao dar a volta no tabuleiro
			#add $t4,$t0,$zero		#vou deixar essa fora por enquanto, ela serve pra saber se o peao passou da morte
			addi $t0,$t0,-43		#quando o a da a volta ele tem que ir pra o caminho da vitoria, e nao dar a volta
		Endifa:
		
		#mostrar a ------------------- 

		lw $t5,a		#pra poder imprimir a letra a
		la $t6,caminho		#pegar o endereco de caminho
		add $t6,$t6,$t0		#encontra o endereco do indice a ser modificado
		sb $t5,0($t6)		#coloca a no novo indice de a
		
		
		lw $t7,dark_yellow	#pega a cor do peao	
		move $t5,$zero		
		
		la $t6,rota		#endereco do vetor onde esta cada pixel do caminho
		sll $t5,$t0,2		#multiplica a casa onde a peca esta por 4 (tamanho de word)
		add $t6,$t6,$t5		#coloca essa casa no endereco pois este indice do vetor e o pixel onde a peca esta
		lw $s1, 0($t6)		#bota no meu guarda pixel a o valor que esta nesse indice do vetor
		jal pixel		
			
			
		lw $t5,vazio		#pra poder imprimir o '-' (45)
		la $t6,caminho		#pegar o endereco de caminho
		add $t6,$t6,$t4		#encontra o endereco do indice a ser modificado
		sb $t5,0($t6)		#coloca um '-' no indice anterior de a
		
		jal devolver_cor
		move $t5,$zero
		
		la $t6,rota		#pega o mesmo endereco do vetor dos pixels de caminho
		sll $t5,$t4,2		#tinha um bug porque o backup estava pegando o valor de sair do tabuleiro
		add $t6,$t6,$t5		#anda nesse endereco anda pro indice encontrado
		lw $s1, 0($t6)		#pega qual o pixel no vetor-matriz tem que imprimir o pixel preto
		jal pixel
		

		la $t5,impressao	
		jalr $t5		#aqui chama a fucao de imprimir
		
		la $s2,msg_a		#guarda quem fez a ultima jogada em caso dele ser o vencedor
		lw $t5,ultima_a
		bgt $t4,$t5,fim		#se o peao passou da sua morte, ganhou
			
		#mexer b --------------------------------------
		
		add $t4,$t1,$zero	#backup fazendo backup
		li $v0, 42 
		li $a1,6 		#atualizando dados da funcao random
		syscall			
		addi $a0,$a0,1		#colocar o valor obtido dentro do intervalo de um dado
		add $t1,$t1,$a0		#a anda o valor aleatorio da casa
		
		la $t5,msg_b
		jal usuario
		
		bgt $t1,43,Ifb
		j Endifb
		Ifb:
			addi $t1,$t1,-43
			la $t6,ultima_b
			li $t5,9
			sw $t5,0($t6)
		Endifb:
		
		#mostrar b ------------------
		
		lw $t5,b		#pra poder imprimir a letra b
		la $t6,caminho		#pegar o endereco de caminho
		add $t6,$t6,$t1		#encontra o endereco do indice a ser modificado
		sb $t5,0($t6)		#coloca a no novo indice de b
		
		
		lw $t7,dark_blue	#pega a cor do peao	
		move $t5,$zero		
		
		la $t6,rota		#endereco do vetor onde esta cada pixel do caminho
		sll $t5,$t1,2		#multiplica a casa onde a peca esta por 4 (tamanho de word)
		add $t6,$t6,$t5		#coloca essa casa no endereco pois este indice do vetor e o pixel onde a peca esta
		lw $s1, 0($t6)		#bota no meu guarda pixel a o valor que esta nesse indice do vetor
		jal pixel		
		
		
		lw $t5,vazio		#pra poder imprimir o '-' (45)
		la $t6,caminho		#pegar o endereco de caminho
		add $t6,$t6,$t4		#encontra o endereco do indice a ser modificado
		sb $t5,0($t6)		#coloca um '-' no indice anterior de b
		
		
		jal devolver_cor
		move $t5,$zero
		
		la $t6,rota		#pega o mesmo endereco do vetor dos pixels de caminho
		sll $t5,$t4,2		#tinha um bug porque o backup estava pegando o valor de sair do tabuleiro
		add $t6,$t6,$t5		#anda nesse endereco anda pro indice encontrado
		lw $s1, 0($t6)		#pega qual o pixel no vetor-matriz tem que imprimir o pixel preto
		jal pixel
		
		
		la $t5,impressao	
		jalr $t5		#aqui chama a fucao de imprimir
		
		la $s2,msg_b
		lw $t5,ultima_b
		bgt $t1,$t5,fim		#se o peao passou da sua morte, ganhou
		
		#mexer c --------------------------------------
		
		add $t4,$t2,$zero	#backup fazendo backup
		li $v0, 42 
		li $a1,6 		#atualizando dados da funcao random
		syscall			
		addi $a0,$a0,1		#colocar o valor obtido dentro do intervalo de um dado
		add $t2,$t2,$a0		#a anda o valor aleatorio da casa
		
		la $t5,msg_c
		jal usuario
		
		bgt $t2,43,Ifc
		j Endifc
		Ifc:
			addi $t2,$t2,-43
			la $t6,ultima_c
			li $t5,20
			sw $t5,0($t6)
		Endifc:
		
		#mostrar c ------------------
		
		lw $t5,c		#pra poder imprimir a letra c
		la $t6,caminho		#pegar o endereco de caminho
		add $t6,$t6,$t2		#encontra o endereco do indice a ser modificado
		sb $t5,0($t6)		#coloca a no novo indice de c
		
		
		lw $t7,dark_red		#pega a cor do peao	
		move $t5,$zero		
		
		la $t6,rota		#endereco do vetor onde esta cada pixel do caminho
		sll $t5,$t2,2		#multiplica a casa onde a peca esta por 4 (tamanho de word)
		add $t6,$t6,$t5		#coloca essa casa no endereco pois este indice do vetor e o pixel onde a peca esta
		lw $s1, 0($t6)		#bota no meu guarda pixel a o valor que esta nesse indice do vetor
		jal pixel
		
		
		lw $t5,vazio		#pra poder imprimir o '-' (45)
		la $t6,caminho		#pegar o endereco de caminho
		add $t6,$t6,$t4		#encontra o endereco do indice a ser modificado
		sb $t5,0($t6)		#coloca um '-' no indice anterior de c
		
		
		jal devolver_cor
		move $t5,$zero
		
		la $t6,rota		#pega o mesmo endereco do vetor dos pixels de caminho
		sll $t5,$t4,2		#tinha um bug porque o backup estava pegando o valor de sair do tabuleiro
		add $t6,$t6,$t5		#anda nesse endereco anda pro indice encontrado
		lw $s1, 0($t6)		#pega qual o pixel no vetor-matriz tem que imprimir o pixel preto
		jal pixel
		
		
		la $t5,impressao	
		jalr $t5		#aqui chama a fucao de imprimir
		
		la $s2,msg_c
		lw $t5,ultima_c
		bgt $t2,$t5,fim		#se o peao passou da sua morte, ganhou
		
		#mexer d --------------------------------------
		
		add $t4,$t3,$zero	#backup fazendo backup
		li $v0, 42 
		li $a1,6 		#atualizando dados da funcao random
		syscall			
		addi $a0,$a0,1		#colocar o valor obtido dentro do intervalo de um dado
		add $t3,$t3,$a0		#a anda o valor aleatorio da casa
		
		la $t5,msg_d
		jal usuario
		
		bgt $t3,43,Ifd
		j Endifd
		Ifd:
			addi $t3,$t3,-43
			la $t6,ultima_d
			li $t5,31
			sw $t5,0($t6)
		Endifd:
		
		#mostrar d ------------------
		
		lw $t5,d		#pra poder imprimir a letra d
		la $t6,caminho		#pegar o endereco de caminho
		add $t6,$t6,$t3		#encontra o endereco do indice a ser modificado
		sb $t5,0($t6)		#coloca a no novo indice de d
		
		
		lw $t7,dark_green	#pega a cor do peao	
		move $t5,$zero		
		
		la $t6,rota		#endereco do vetor onde esta cada pixel do caminho
		sll $t5,$t3,2		#multiplica a casa onde a peca esta por 4 (tamanho de word)
		add $t6,$t6,$t5		#coloca essa casa no endereco pois este indice do vetor e o pixel onde a peca esta
		lw $s1, 0($t6)		#bota no meu guarda pixel a o valor que esta nesse indice do vetor
		jal pixel
		
		
		lw $t5,vazio		#pra poder imprimir o '-' (45)
		la $t6,caminho		#pegar o endereco de caminho
		add $t6,$t6,$t4		#encontra o endereco do indice a ser modificado
		sb $t5,0($t6)		#coloca um '-' no indice anterior de d
		
		
		jal devolver_cor
		move $t5,$zero
		
		la $t6,rota		#pega o mesmo endereco do vetor dos pixels de caminho
		sll $t5,$t4,2		#tinha um bug porque o backup estava pegando o valor de sair do tabuleiro
		add $t6,$t6,$t5		#anda nesse endereco anda pro indice encontrado
		lw $s1, 0($t6)		#pega qual o pixel no vetor-matriz tem que imprimir o pixel preto
		jal pixel
		
		
		la $t5,impressao	
		jalr $t5		#aqui chama a funcao de imprimir
		
		la $s2,msg_d
		lw $t5,ultima_d
		bgt $t3,$t5,fim		#se o peao passou da sua morte, ganhou
		
		#fim movimento -------------------
		
		addi $s0,$s0,1
		j while			#reinicia o loop
	fim:
	
	la $a0,mensagem_3	#imprimir primeira parte da mensagem de vitoria
	li $v0,4
	syscall
	move $a0,$s2		#imprimir o vencedor
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall			#encerra o programa
