.data
	caminho: .asciiz "--------------------------------------------|   \n"		#esses espacos ajuda a ver se alguem sair (e alinham o endereco para um valor par)
	vitoria_a: .asciiz "-----"		#o tubo da vitoria so vai ate o penultimo, o primeiro a sair fica na ponta, o ultimo no centro (102)
	vitoria_b: .asciiz "-----"
	vitoria_c: .asciiz "-----"
	vitoria_d: .asciiz "-----"
	
	status_a: .word 0	#0 - dormindo, 1 - jogando, 2 - tubo, 3 - ganhou?
	status_b: .word 0
	status_c: .word 0
	status_d: .word 0
	
	
	dormindo_a: .word 17
	dormindo_b: .word 25
	dormindo_c: .word 153
	dormindo_d: .word 145
	
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
	camas: .word 17,25,153,145
	
	
	ultima_a: .word 41	#41		#o peao A nunca da a volta no tabuleiro
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
	
	tapete_a: .word 97, 98, 99, 100, 101, 117
	tapete_b: .word 22, 38, 54, 70, 86, 85
	tapete_c: .word 107, 106, 105, 104, 103, 87
	tapete_d: .word 182, 166, 150, 134, 118, 119
	
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
	move $s3, $zero		#instantaneo temporario
	move $s4, $zero		#resultado do dado
	move $s5, $zero		#backup do $ra
	
	la $t5,impressao	
	jalr $t5		#aqui chama a fucao de imprimir
	
	#-----------------------------------------------------------------
	
	#X LIMPAR O CAMINHO DA PARTIDA ANTERIOR
	#X REIMPRIMIR AS CASAS ESTRELA
	#X TERMINAR ALGUMAS REGRAS COMO NAO PODER ACESSAR A MESMA CASA
	#X ENTRAR NO CAMINHO NOVO PARA A CONDICAO DE VITORIA
	#X PEDIR AO USUARIO QUE JOGUE O DADO
	#X SE POSSIVEL, ADICIONAR A FUNCAO DE COMER AS PECAS INIMIGAS
	#X PARA O ITEM ACIMA, ADICIONAR A SAIDA DE PECAS DA CASA PARA O TABULEIRO
	#X NAO PODE NASCER E COMER UMA PECA NA CASA ESTRELA AO MESMO TEMPO
	
	#  COMPLEMENTO PARA O ITEM ACIMA, ADICIONAR MAIS UMA PECA AOS JOGADORES E TURNO ENTRE ELAS
	#  OTIMIZACAO, TIRAR PSEUDO CODIGO
	
	#deu um exception quando chamou a funcao pixel, ja nessa versao finalizada
	#o azul costuma ter o rastro mal apagado
	#o amarelo ja entrou no tubo do azul
	#o azul ja foi impresso no endereco base (0) de gp
	#o vermelho ja entrou no tubo do verde
	#pequeno bug onde o azul pegou entrou_b com t2 = 25 e assim o pixel deu out of range
	#as vezes tem bug ao comer, devem vir todos do azul
	#as casas estrela de vez em quando bugam com a impressao da sua peca em cima...


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
	
	nascimento:			#essa funcao horrivel ela foi modif e agora mostra as pecas dormindo
		
		lw $t7,dark_yellow
		move $t5,$zero
		la $t6,camas	
		add $t6,$t6,$t5		
		lw $s1, 0($t6)		
		jal pixel		
		
		addi $t5,$t5,4
		lw $t7,dark_blue
		la $t6,camas	
		add $t6,$t6,$t5		
		lw $s1, 0($t6)		
		jal pixel
		
		addi $t5,$t5,4
		lw $t7,dark_red
		la $t6,camas	
		add $t6,$t6,$t5		
		lw $s1, 0($t6)		
		jal pixel
		
		addi $t5,$t5,4
		lw $t7,dark_green
		la $t6,camas	
		add $t6,$t6,$t5		
		lw $s1, 0($t6)		
		jal pixel

	#IMPRESSAO
	
	#-----------------------------------------------------------------
	
	while:
		beq $s0,80,fim		#condicao da partida estar rolando, se n pula pra apos o loop, contagem pra evitar bug

		#MEXER A @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
		
		add $t4,$t0,$zero	#backup fazendo backup
		li $v0, 42 
		li $a1,6 		#atualizando dados da funcao random
		syscall
		addi $a0,$a0,1		#colocar o valor obtido dentro do intervalo de um dado cubico
		add $s4,$a0,$zero
		
		la $t5,msg_a		#colocar a mensagem que se altera pra cada peao no instantaneo, e da vez ao usuario
		jal usuario
		
		lw $t5,status_a		#ve qual o status que o time esta, dormindo, jogando etc
		beq $t5,0,acordar_a
		beq $t5,1,jogar_a
		beq $t5,2,tubulacao_a	#cada possibilidade vai pra um bloco de tratamento diferente
		
		la $s3,fim_a		#caso de erro, pois algum dos casos devia ter acontecido
		jr $s3
		
		acordar_a:
		
			bne $s4,6,fim_a		#se tiver tirado 6 com a peca dormindo, ai pode nascer
			
			lw $t5,primeira_a
			la $t6,caminho
			add $t6,$t6,$t5
			lb $t5,0($t6)			#olha no indice [nascimento de a] de caminho oq tem la
			bne $t5,45,fim_a		#so pode nascer se nao tiver peca na casa estrela do time
			
			lw $t0,primeira_a		#ele pega qual a posicao do time a no caminho
			lw $t5, a
			la $t6,caminho
			add $t6,$t6,$t0
			sb $t5, 0($t6)			#colocar o time no caminho, bem onde ele nasce
			
			lw $t4, dormindo_a
			lw $t7,yellow
			lw $s1, dormindo_a		#apagar o rastro de que a peca estava dormindo
			jal pixel
			
			lw $t7,dark_yellow
			la $t6,estrelas
			lw $s1,0($t6)			#agora mostrar ela na casa estrela ao nascer
			jal pixel
			
			la $t6,status_a
			li $t5, 1			#mudar status para 1, pois esta em jogo
			sw $t5,0($t6)
			
			la $t5,impressao	
			jalr $t5		#aqui chama a fucao de imprimir
			la $s3,fim_a			#encerrar jogada de a
			jr $s3
				
		jogar_a:
		
			add $t0,$t0,$s4		#a ja esta no jogo, entao anda no caminho o valor aleatorio que tirou
			
			lw $t5,vazio		#pra poder imprimir o '-' (45)
			la $t6,caminho		#pegar o endereco de caminho
			add $t6,$t6,$t4		#encontra o endereco do indice a ser modificado
			sb $t5,0($t6)		#coloca um '-' no indice anterior de a
			
			jal devolver_cor	#verifica se ela deixou rastro em uma estrela e ajeita como estava
			move $t5,$zero
		
			la $t6,rota		#pega o mesmo endereco do vetor dos pixels de caminho
			sll $t5,$t4,2		#tinha um bug porque o backup estava pegando o valor de sair do tabuleiro
			add $t6,$t6,$t5		#anda nesse endereco anda pro indice encontrado
			lw $s1, 0($t6)		#pega qual o pixel no vetor-matriz tem que imprimir o pixel preto
			jal pixel
				
			lw $t5,ultima_a
			bgt $t0,$t5,entrou_a
			j nao_entrou_a
			
			entrou_a:		#se entrou no tubo, nao entra em caminho, entra apenas no tubo e fica pra ganhar
			
				sub $t0,$t0,$t5		#a posicao atual da peca do time, agora no tubo
			
				la $t6,status_a
				li $t5,2
				sw $t5,0($t6)		#status = modo tubo
				
				lw $t5,a		
				la $t6, vitoria_a		
				add $t6,$t6,$t0		
				sb $t5,0($t6)		#andar dentro do caminho do tubo
				
				lw $t7,dark_yellow
				la $t6,tapete_a			
				sll $t5,$t0,2		#pra saber em qual posicao do tubo esta, e pegar esse indice em enderecos de word
				add $t6,$t6,$t5			
				lw $s1, 0($t6)		
				jal pixel
				
				beq $t0,5,ganhar_a
				la $s3,terminar_imp_a	#terminar turno
				jr $s3
				
			nao_entrou_a:		#se ainda nao entrou no tubo, funcionar normalmente a jogada pelo caminho
			
				beq $t0,$t1,amatarb
				beq $t0,$t2,amatarc
				beq $t0,$t3,amatard
				j pacifico_a
			
				amatarb:
					la $t6,morrer_b
					jalr $t6
					j pacifico_a
				amatarc:
					la $t6,morrer_c
					jalr $t6
					j pacifico_a
				amatard:
					la $t6,morrer_d
					jalr $t6
				pacifico_a:
			
				lw $t5,a		#pra poder imprimir a letra a
				la $t6,caminho		#pegar o endereco de caminho
				add $t6,$t6,$t0		#encontra o endereco do indice a ser modificado
				sb $t5,0($t6)		#coloca a no novo indice de a
			
				lw $t7,dark_yellow	#pega a cor do peao
				la $t6,rota		#endereco do vetor onde esta cada pixel do caminho
				sll $t5,$t0,2		#multiplica a casa onde a peca esta por 4 (tamanho de word)
				add $t6,$t6,$t5		#coloca essa casa no endereco pois este indice do vetor e o pixel onde a peca esta
				lw $s1, 0($t6)		#bota no meu guarda pixel a o valor que esta nesse indice do vetor
				jal pixel	
				
			terminar_imp_a:

			la $t5,impressao	
			jalr $t5		#aqui chama a fucao de imprimir
		
			la $s2,msg_a		#guarda quem fez a ultima jogada em caso dele ser o vencedor
			la $s3,fim_a
			jr $s3
			
		tubulacao_a:
			
			add $t5,$t0,$s4
			bne $t5,5,fim_a	
			add $t0,$t0,$s4
				
			lw $t5,vazio		#pra poder imprimir o '-' (45)
			la $t6,vitoria_a		#pegar o endereco de caminho
			add $t6,$t6,$t4		#encontra o endereco do indice a ser modificado
			sb $t5,0($t6)		#coloca um '-' no indice anterior de a
			
			lw $t7,yellow
			la $t6,tapete_a		#pega o mesmo endereco do vetor dos pixels de caminho
			sll $t5,$t4,2		#tinha um bug porque o backup estava pegando o valor de sair do tabuleiro
			add $t6,$t6,$t5		#anda nesse endereco anda pro indice encontrado
			lw $s1, 0($t6)		#pega qual o pixel no vetor-matriz tem que imprimir o pixel preto
			jal pixel
			
					
			lw $t5,a		#pra poder imprimir a letra a
			la $t6,vitoria_a		#pegar o endereco de caminho
			add $t6,$t6,$t0		#encontra o endereco do indice a ser modificado
			sb $t5,0($t6)		#coloca a no novo indice de a
			
			lw $t7,dark_yellow	#pega a cor do peao
			la $t6,tapete_a		#endereco do vetor onde esta cada pixel do caminho
			sll $t5,$t0,2		#multiplica a casa onde a peca esta por 4 (tamanho de word)
			add $t6,$t6,$t5		#coloca essa casa no endereco pois este indice do vetor e o pixel onde a peca esta
			lw $s1, 0($t6)		#bota no meu guarda pixel a o valor que esta nesse indice do vetor
			jal pixel	
				
		ganhar_a:
		
			la $s2,msg_a
			lw $t5,ultima_a
			
			la $t6,fim
			jr $t6
		
		morrer_a:
		
		
			move $s5,$ra
			lw $t5,vazio		#pra poder imprimir o '-' (45)
			la $t6,caminho		#pegar o endereco de caminho
			add $t6,$t6,$t0		#encontra o endereco do indice a ser modificado
			sb $t5,0($t6)		#coloca um '-' no indice anterior de a
			#jal pixel		#NAO PODE APAGAR O RASTRO PQ TEM UMA PECA EM CIMA
		
			lw $t7,dark_yellow
			la $t6,dormindo_a	
			lw $s1, 0($t6)		
			jal pixel
			
			la $t6,status_a
			li $t5, 0
			sw $t5,0($t6)	
					
			move $t0,$zero
			move $ra,$s5
			jr $ra
		
		fim_a:

		#MEXER B ######################################################################################################################

		add $t4,$t1,$zero	#backup fazendo backup
		li $v0, 42 
		li $a1,6 		#atualizando dados da funcao random
		syscall
		addi $a0,$a0,1		#colocar o valor obtido dentro do intervalo de um dado cubico
		add $s4,$a0,$zero
		
		la $t5,msg_b		#colocar a mensagem que se altera pra cada peao no instantaneo, e da vez ao usuario
		jal usuario
		
		lw $t5,status_b		#ve qual o status que o time esta, dormindo, jogando etc
		beq $t5,0,acordar_b
		beq $t5,1,jogar_b
		beq $t5,2,tubulacao_b	#cada possibilidade vai pra um bloco de tratamento diferente
		
		la $s3,fim_b		#caso de erro, pois algum dos casos devia ter acontecido
		jr $s3
		
		acordar_b:
		
			bne $s4,6,fim_b	#se tiver tirado 6 com a peca dormindo, ai pode nascer
			
			lw $t5,primeira_b
			la $t6,caminho
			add $t6,$t6,$t5
			lb $t5,0($t6)			#olha no indice [nascimento de a] de caminho oq tem la
			bne $t5,45,fim_b		#so pode nascer se nao tiver peca na casa estrela do time
			
			lw $t1,primeira_b		#ele pega qual a posicao do time a no caminho
			lw $t5, b
			la $t6,caminho
			add $t6,$t6,$t1
			sb $t5, 0($t6)			#colocar o time no caminho, bem onde ele nasce
			
			lw $t4, dormindo_b
			lw $t7,blue
			lw $s1, dormindo_b		#apagar o rastro de que a peca estava dormindo
			jal pixel
			
			lw $t7,dark_blue
			la $t6,estrelas
			lw $s1,4($t6)			#agora mostrar ela na casa estrela ao nascer
			jal pixel
			
			la $t6,status_b
			li $t5, 1			#mudar status para 1, pois esta em jogo
			sw $t5,0($t6)
			
			la $t5,impressao	
			jalr $t5		#aqui chama a fucao de imprimir
			la $s3,fim_b			#encerrar jogada de a
			jr $s3
				
		jogar_b:
		
			add $t4,$t1,$zero
			add $t1,$t1,$s4		#a ja esta no jogo, entao anda no caminho o valor aleatorio que tirou
			bgt $t1,43,Ifb
			j Endifb
			Ifb:
				addi $t1,$t1,-43
				la $t6,ultima_b
				li $t5,9
				sw $t5,0($t6)
			Endifb:
			
			lw $t5,vazio		#pra poder imprimir o '-' (45)
			la $t6,caminho		#pegar o endereco de caminho
			add $t6,$t6,$t4		#encontra o endereco do indice a ser modificado
			sb $t5,0($t6)		#coloca um '-' no indice anterior de a
			
			jal devolver_cor	#verifica se ela deixou rastro em uma estrela e ajeita como estava
			move $t5,$zero
		
			la $t6,rota		#pega o mesmo endereco do vetor dos pixels de caminho
			sll $t5,$t4,2		#tinha um bug porque o backup estava pegando o valor de sair do tabuleiro
			add $t6,$t6,$t5		#anda nesse endereco anda pro indice encontrado
			lw $s1, 0($t6)		#pega qual o pixel no vetor-matriz tem que imprimir o pixel preto
			jal pixel
				
			lw $t5,ultima_b
			bgt $t1,$t5,entrou_b
			j nao_entrou_b
			
			entrou_b:		#se entrou no tubo, nao entra em caminho, entra apenas no tubo e fica pra ganhar
				sub $t1,$t1,$t5		#a posicao atual da peca do time, agora no tubo
			
				la $t6,status_b
				li $t5,2
				sw $t5,0($t6)		#status = modo tubo
				
				lw $t5,b		
				la $t6, vitoria_b	
				add $t6,$t6,$t1	
				sb $t5,0($t6)		#andar dentro do caminho do tubo
				
				lw $t7,dark_blue
				la $t6,tapete_b	
				sll $t5,$t1,2		#pra saber em qual posicao do tubo esta, e pegar esse indice em enderecos de word
				add $t6,$t6,$t5			
				lw $s1, 0($t6)		
				jal pixel
				
				beq $t1,5,ganhar_b
				la $s3,terminar_imp_b	#terminar turno
				jr $s3
				
			nao_entrou_b:		#se ainda nao entrou no tubo, funcionar normalmente a jogada pelo caminho
				beq $t1,$t0,bmatara
				beq $t1,$t2,bmatarc
				beq $t1,$t3,bmatard
				j pacifico_b
				bmatara:
					la $t6,morrer_a
					jalr $t6
					j pacifico_b
				bmatarc:
					la $t6,morrer_c
					jalr $t6
					j pacifico_b
				bmatard:
					la $t6,morrer_d
					jalr $t6
				pacifico_b:
				lw $t5,b		#pra poder imprimir a letra a
				la $t6,caminho		#pegar o endereco de caminho
				add $t6,$t6,$t1		#encontra o endereco do indice a ser modificado
				sb $t5,0($t6)		#coloca a no novo indice de a
				lw $t7,dark_blue	#pega a cor do peao
				la $t6,rota		#endereco do vetor onde esta cada pixel do caminho
				sll $t5,$t1,2		#multiplica a casa onde a peca esta por 4 (tamanho de word)
				add $t6,$t6,$t5		#coloca essa casa no endereco pois este indice do vetor e o pixel onde a peca esta
				lw $s1, 0($t6)		#bota no meu guarda pixel a o valor que esta nesse indice do vetor
				jal pixel	
				
			terminar_imp_b:

			la $t5,impressao	
			jalr $t5		#aqui chama a fucao de imprimir
		
			la $s2,msg_b		#guarda quem fez a ultima jogada em caso dele ser o vencedor
			la $s3,fim_b
			jr $s3
			
		tubulacao_b:
			
			add $t5,$t1,$s4
			bne $t5,5,fim_b	
			add $t1,$t1,$s4
				
			lw $t5,vazio		#pra poder imprimir o '-' (45)
			la $t6,vitoria_b	#pegar o endereco de caminho
			add $t6,$t6,$t4		#encontra o endereco do indice a ser modificado
			sb $t5,0($t6)		#coloca um '-' no indice anterior de a
			
			lw $t7,blue
			la $t6,tapete_b		#pega o mesmo endereco do vetor dos pixels de caminho
			sll $t5,$t4,2		#tinha um bug porque o backup estava pegando o valor de sair do tabuleiro
			add $t6,$t6,$t5		#anda nesse endereco anda pro indice encontrado
			lw $s1, 0($t6)		#pega qual o pixel no vetor-matriz tem que imprimir o pixel preto
			jal pixel
			
					
			lw $t5,b		#pra poder imprimir a letra a
			la $t6,vitoria_b		#pegar o endereco de caminho
			add $t6,$t6,$t1		#encontra o endereco do indice a ser modificado
			sb $t5,0($t6)		#coloca a no novo indice de a
			
			lw $t7,dark_blue	#pega a cor do peao
			la $t6,tapete_b		#endereco do vetor onde esta cada pixel do caminho
			sll $t5,$t1,2		#multiplica a casa onde a peca esta por 4 (tamanho de word)
			add $t6,$t6,$t5		#coloca essa casa no endereco pois este indice do vetor e o pixel onde a peca esta
			lw $s1, 0($t6)		#bota no meu guarda pixel a o valor que esta nesse indice do vetor
			jal pixel	
				
		ganhar_b:
		
			la $s2,msg_b
			lw $t5,ultima_b
			
			la $t6,fim
			jr $t6
		
		morrer_b:
		
			move $s5,$ra
			lw $t5,vazio		#pra poder imprimir o '-' (45)
			la $t6,caminho		#pegar o endereco de caminho
			add $t6,$t6,$t1		#encontra o endereco do indice a ser modificado
			sb $t5,0($t6)		#coloca um '-' no indice anterior de a
			#jal pixel		#NAO PODE APAGAR O RASTRO PQ TEM UMA PECA EM CIMA
		
			lw $t7,dark_blue
			la $t6,dormindo_b	
			lw $s1, 0($t6)		
			jal pixel
			
			la $t6,status_b
			li $t5, 0
			sw $t5,0($t6)	
					
			move $t1,$zero
			move $ra,$s5
			jr $ra
		
		fim_b:
		

		
		#MEXER C $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		
		add $t4,$t2,$zero	#backup fazendo backup
		li $v0, 42 
		li $a1,6 		#atualizando dados da funcao random
		syscall
		addi $a0,$a0,1		#colocar o valor obtido dentro do intervalo de um dado cubico
		add $s4,$a0,$zero
		
		la $t5,msg_c		#colocar a mensagem que se altera pra cada peao no instantaneo, e da vez ao usuario
		jal usuario
		
		lw $t5,status_c		#ve qual o status que o time esta, dormindo, jogando etc
		beq $t5,0,acordar_c
		beq $t5,1,jogar_c
		beq $t5,2,tubulacao_c	#cada possibilidade vai pra um bloco de tratamento diferente
		
		la $s3,fim_c		#caso de erro, pois algum dos casos devia ter acontecido
		jr $s3
		
		acordar_c:
		
			bne $s4,6,fim_c #se tiver tirado 6 com a peca dormindo, ai pode nascer
			
			lw $t5,primeira_c
			la $t6,caminho
			add $t6,$t6,$t5
			lb $t5,0($t6)			#olha no indice [nascimento de a] de caminho oq tem la
			bne $t5,45,fim_c		#so pode nascer se nao tiver peca na casa estrela do time
			
			lw $t1,primeira_c		#ele pega qual a posicao do time a no caminho
			lw $t5, c
			la $t6,caminho
			add $t6,$t6,$t2
			sb $t5, 0($t6)			#colocar o time no caminho, bem onde ele nasce
			
			lw $t4, dormindo_c
			lw $t7,red
			lw $s1, dormindo_c		#apagar o rastro de que a peca estava dormindo
			jal pixel
			
			lw $t7,dark_red
			la $t6,estrelas
			lw $s1,8($t6)			#agora mostrar ela na casa estrela ao nascer
			jal pixel
			
			la $t6,status_c
			li $t5, 1			#mudar status para 1, pois esta em jogo
			sw $t5,0($t6)
			
			la $t5,impressao	
			jalr $t5		#aqui chama a fucao de imprimir
			la $s3,fim_c			#encerrar jogada de a
			jr $s3
				
		jogar_c:
			
					add $t4,$t2,$zero	
			add $t2,$t2,$s4		#a ja esta no jogo, entao anda no caminho o valor aleatorio que tirou
					
			bgt $t2,43,Ifc
			j Endifc
			Ifc:
				addi $t2,$t2,-43
				la $t6,ultima_c
				li $t5,20
				sw $t5,0($t6)
			Endifc:
			
			
		
			lw $t5,vazio		#pra poder imprimir o '-' (45)
			la $t6,caminho		#pegar o endereco de caminho
			add $t6,$t6,$t4		#encontra o endereco do indice a ser modificado
			sb $t5,0($t6)		#coloca um '-' no indice anterior de a
			
			jal devolver_cor	#verifica se ela deixou rastro em uma estrela e ajeita como estava
			move $t5,$zero
		
			la $t6,rota		#pega o mesmo endereco do vetor dos pixels de caminho
			sll $t5,$t4,2		#tinha um bug porque o backup estava pegando o valor de sair do tabuleiro
			add $t6,$t6,$t5		#anda nesse endereco anda pro indice encontrado
			lw $s1, 0($t6)		#pega qual o pixel no vetor-matriz tem que imprimir o pixel preto
			jal pixel
				
			lw $t5,ultima_c
			bgt $t2,$t5,entrou_c
			j nao_entrou_c
			
			entrou_c:		#se entrou no tubo, nao entra em caminho, entra apenas no tubo e fica pra ganhar
			
				sub $t2,$t2,$t5		#a posicao atual da peca do time, agora no tubo
			
				la $t6,status_c
				li $t5,2
				sw $t5,0($t6)		#status = modo tubo
				
				lw $t5,c		
				la $t6, vitoria_c	
				add $t6,$t6,$t2
				sb $t5,0($t6)		#andar dentro do caminho do tubo
				
				lw $t7,dark_red
				la $t6,tapete_c
				sll $t5,$t2,2		#pra saber em qual posicao do tubo esta, e pegar esse indice em enderecos de word
				add $t6,$t6,$t5			
				lw $s1, 0($t6)		
				jal pixel
				
				beq $t2,5,ganhar_c
				la $s3,terminar_imp_c	#terminar turno
				jr $s3
				
			nao_entrou_c:		#se ainda nao entrou no tubo, funcionar normalmente a jogada pelo caminho
			
				beq $t2,$t0,cmatara
				beq $t2,$t1,cmatarb
				beq $t2,$t3,cmatard
				j pacifico_c
			
				cmatara:
					la $t6,morrer_a
					jalr $t6
					j pacifico_c
				cmatarb:
					la $t6,morrer_b
					jalr $t6
					j pacifico_c
				cmatard:
					la $t6,morrer_d
					jalr $t6
				pacifico_c:
			
				lw $t5,c		#pra poder imprimir a letra a
				la $t6,caminho		#pegar o endereco de caminho
				add $t6,$t6,$t2		#encontra o endereco do indice a ser modificado
				sb $t5,0($t6)		#coloca a no novo indice de a
			
				lw $t7,dark_red		#pega a cor do peao
				la $t6,rota		#endereco do vetor onde esta cada pixel do caminho
				sll $t5,$t2,2		#multiplica a casa onde a peca esta por 4 (tamanho de word)
				add $t6,$t6,$t5		#coloca essa casa no endereco pois este indice do vetor e o pixel onde a peca esta
				lw $s1, 0($t6)		#bota no meu guarda pixel a o valor que esta nesse indice do vetor
				jal pixel	
				
			terminar_imp_c:

			la $t5,impressao	
			jalr $t5		#aqui chama a fucao de imprimir
		
			la $s2,msg_c		#guarda quem fez a ultima jogada em caso dele ser o vencedor
			la $s3,fim_c
			jr $s3
			
		tubulacao_c:
			
			add $t5,$t2,$s4
			bne $t5,5,fim_c
			add $t2,$t2,$s4
				
			lw $t5,vazio		#pra poder imprimir o '-' (45)
			la $t6,vitoria_c		#pegar o endereco de caminho
			add $t6,$t6,$t4		#encontra o endereco do indice a ser modificado
			sb $t5,0($t6)		#coloca um '-' no indice anterior de a
			
			lw $t7,red
			la $t6,tapete_c		#pega o mesmo endereco do vetor dos pixels de caminho
			sll $t5,$t4,2		#tinha um bug porque o backup estava pegando o valor de sair do tabuleiro
			add $t6,$t6,$t5		#anda nesse endereco anda pro indice encontrado
			lw $s1, 0($t6)		#pega qual o pixel no vetor-matriz tem que imprimir o pixel preto
			jal pixel
			
					
			lw $t5,c		#pra poder imprimir a letra a
			la $t6,vitoria_c	#pegar o endereco de caminho
			add $t6,$t6,$t2		#encontra o endereco do indice a ser modificado
			sb $t5,0($t6)		#coloca a no novo indice de a
			
			lw $t7,dark_red	#pega a cor do peao
			la $t6,tapete_c		#endereco do vetor onde esta cada pixel do caminho
			sll $t5,$t2,2		#multiplica a casa onde a peca esta por 4 (tamanho de word)
			add $t6,$t6,$t5		#coloca essa casa no endereco pois este indice do vetor e o pixel onde a peca esta
			lw $s1, 0($t6)		#bota no meu guarda pixel a o valor que esta nesse indice do vetor
			jal pixel	
				
		ganhar_c:
		
			la $s2,msg_c
			lw $t5,ultima_c
			
			la $t6,fim
			jr $t6
		
		morrer_c:
			
			move $s5,$ra
			lw $t5,vazio		#pra poder imprimir o '-' (45)
			la $t6,caminho		#pegar o endereco de caminho
			add $t6,$t6,$t2		#encontra o endereco do indice a ser modificado
			sb $t5,0($t6)		#coloca um '-' no indice anterior de a
			#jal pixel		#NAO PODE APAGAR O RASTRO PQ TEM UMA PECA EM CIMA
		
			lw $t7,dark_red
			la $t6,dormindo_c	
			lw $s1, 0($t6)		
			jal pixel
			
			la $t6,status_c
			li $t5, 0
			sw $t5,0($t6)	
					
			move $t2,$zero
			move $ra,$s5
			jr $ra
		
		fim_c:
		
		#MEXER D %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
		add $t4,$t3,$zero	#backup fazendo backup
		li $v0, 42 
		li $a1,6 		#atualizando dados da funcao random
		syscall
		addi $a0,$a0,1		#colocar o valor obtido dentro do intervalo de um dado cubico
		add $s4,$a0,$zero
		
		la $t5,msg_d		#colocar a mensagem que se altera pra cada peao no instantaneo, e da vez ao usuario
		jal usuario
		
		lw $t5,status_d		#ve qual o status que o time esta, dormindo, jogando etc
		beq $t5,0,acordar_d
		beq $t5,1,jogar_d
		beq $t5,2,tubulacao_d	#cada possibilidade vai pra um bloco de tratamento diferente
		
		la $s3,fim_d		#caso de erro, pois algum dos casos devia ter acontecido
		jr $s3
		
		acordar_d:
		
			bne $s4,6,fim_d #se tiver tirado 6 com a peca dormindo, ai pode nascer
			
			lw $t5,primeira_d
			la $t6,caminho
			add $t6,$t6,$t5
			lb $t5,0($t6)			#olha no indice [nascimento de a] de caminho oq tem la
			bne $t5,45,fim_d		#so pode nascer se nao tiver peca na casa estrela do time
			
			lw $t1,primeira_d		#ele pega qual a posicao do time a no caminho
			lw $t5, d
			la $t6,caminho
			add $t6,$t6,$t3
			sb $t5, 0($t6)			#colocar o time no caminho, bem onde ele nasce
			
			lw $t4, dormindo_d
			lw $t7,green
			lw $s1, dormindo_d		#apagar o rastro de que a peca estava dormindo
			jal pixel
			
			lw $t7,dark_green
			la $t6,estrelas
			lw $s1,12($t6)			#agora mostrar ela na casa estrela ao nascer
			jal pixel
			
			la $t6,status_d
			li $t5, 1			#mudar status para 1, pois esta em jogo
			sw $t5,0($t6)
			
			la $t5,impressao	
			jalr $t5		#aqui chama a fucao de imprimir
			la $s3,fim_d			#encerrar jogada de a
			jr $s3
				
		jogar_d:
		
			add $t3,$t3,$s4		#a ja esta no jogo, entao anda no caminho o valor aleatorio que tirou
			
			bgt $t3,43,Ifd
			j Endifd
			Ifd:
				addi $t3,$t3,-43
				la $t6,ultima_d
				li $t5,31
				sw $t5,0($t6)
			Endifd:
			
			
		
			lw $t5,vazio		#pra poder imprimir o '-' (45)
			la $t6,caminho		#pegar o endereco de caminho
			add $t6,$t6,$t4		#encontra o endereco do indice a ser modificado
			sb $t5,0($t6)		#coloca um '-' no indice anterior de a
			
			jal devolver_cor	#verifica se ela deixou rastro em uma estrela e ajeita como estava
			move $t5,$zero
		
			la $t6,rota		#pega o mesmo endereco do vetor dos pixels de caminho
			sll $t5,$t4,2		#tinha um bug porque o backup estava pegando o valor de sair do tabuleiro
			add $t6,$t6,$t5		#anda nesse endereco anda pro indice encontrado
			lw $s1, 0($t6)		#pega qual o pixel no vetor-matriz tem que imprimir o pixel preto
			jal pixel
				
			lw $t5,ultima_d
			bgt $t3,$t5,entrou_d
			j nao_entrou_d
			
			entrou_d:		#se entrou no tubo, nao entra em caminho, entra apenas no tubo e fica pra ganhar
			
				sub $t3,$t3,$t5		#a posicao atual da peca do time, agora no tubo
			
				la $t6,status_d
				li $t5,2
				sw $t5,0($t6)		#status = modo tubo
				
				lw $t5,d		
				la $t6, vitoria_d
				add $t6,$t6,$t3
				sb $t5,0($t6)		#andar dentro do caminho do tubo
				
				lw $t7,dark_green
				la $t6,tapete_d
				sll $t5,$t3,2		#pra saber em qual posicao do tubo esta, e pegar esse indice em enderecos de word
				add $t6,$t6,$t5			
				lw $s1, 0($t6)		
				jal pixel
				
				beq $t3,5,ganhar_d
				la $s3,terminar_imp_d	#terminar turno
				jr $s3
				
			nao_entrou_d:		#se ainda nao entrou no tubo, funcionar normalmente a jogada pelo caminho
			
			
				beq $t3,$t0,dmatara
				beq $t3,$t1,morrer_b
				beq $t3,$t2,morrer_c
				j pacifico_d
			
				dmatara:
					la $t6,morrer_a
					jalr $t6
					j pacifico_d
				dmatarb:
					la $t6,morrer_b
					jalr $t6
					j pacifico_d
				dmatarc:
					la $t6,morrer_c
					jalr $t6
				pacifico_d:
			
				lw $t5,d		#pra poder imprimir a letra a
				la $t6,caminho		#pegar o endereco de caminho
				add $t6,$t6,$t3		#encontra o endereco do indice a ser modificado
				sb $t5,0($t6)		#coloca a no novo indice de a
			
				lw $t7,dark_green		#pega a cor do peao
				la $t6,rota		#endereco do vetor onde esta cada pixel do caminho
				sll $t5,$t3,2		#multiplica a casa onde a peca esta por 4 (tamanho de word)
				add $t6,$t6,$t5		#coloca essa casa no endereco pois este indice do vetor e o pixel onde a peca esta
				lw $s1, 0($t6)		#bota no meu guarda pixel a o valor que esta nesse indice do vetor
				jal pixel	
				
			terminar_imp_d:

			la $t5,impressao	
			jalr $t5		#aqui chama a fucao de imprimir
		
			la $s2,msg_d		#guarda quem fez a ultima jogada em caso dele ser o vencedor
			la $s3,fim_d
			jr $s3
			
		tubulacao_d:
			
			add $t5,$t3,$s4
			bne $t5,5,fim_d
			add $t3,$t3,$s4
				
			lw $t5,vazio		#pra poder imprimir o '-' (45)
			la $t6,vitoria_d		#pegar o endereco de caminho
			add $t6,$t6,$t4		#encontra o endereco do indice a ser modificado
			sb $t5,0($t6)		#coloca um '-' no indice anterior de a
			
			lw $t7,green
			la $t6,tapete_d		#pega o mesmo endereco do vetor dos pixels de caminho
			sll $t5,$t4,2		#tinha um bug porque o backup estava pegando o valor de sair do tabuleiro
			add $t6,$t6,$t5		#anda nesse endereco anda pro indice encontrado
			lw $s1, 0($t6)		#pega qual o pixel no vetor-matriz tem que imprimir o pixel preto
			jal pixel
			
					
			lw $t5,d		#pra poder imprimir a letra a
			la $t6,vitoria_d	#pegar o endereco de caminho
			add $t6,$t6,$t3		#encontra o endereco do indice a ser modificado
			sb $t5,0($t6)		#coloca a no novo indice de a
			
			lw $t7,dark_green	#pega a cor do peao
			la $t6,tapete_d		#endereco do vetor onde esta cada pixel do caminho
			sll $t5,$t3,2		#multiplica a casa onde a peca esta por 4 (tamanho de word)
			add $t6,$t6,$t5		#coloca essa casa no endereco pois este indice do vetor e o pixel onde a peca esta
			lw $s1, 0($t6)		#bota no meu guarda pixel a o valor que esta nesse indice do vetor
			jal pixel	
				
		ganhar_d:
		
			la $s2,msg_d
			lw $t5,ultima_d
			
			la $t6,fim
			jr $t6
		
		morrer_d:
			
			move $s5,$ra
			lw $t5,vazio		#pra poder imprimir o '-' (45)
			la $t6,caminho		#pegar o endereco de caminho
			add $t6,$t6,$t3		#encontra o endereco do indice a ser modificado
			sb $t5,0($t6)		#coloca um '-' no indice anterior de a
			#jal pixel		#NAO PODE APAGAR O RASTRO PQ TEM UMA PECA EM CIMA
		
			lw $t7,dark_green
			la $t6,dormindo_d	
			lw $s1, 0($t6)		
			jal pixel
			
			la $t6,status_d
			li $t5, 0
			sw $t5,0($t6)	
					
			move $t3,$zero
			move $ra,$s5
			jr $ra
		
		fim_d:
		
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
