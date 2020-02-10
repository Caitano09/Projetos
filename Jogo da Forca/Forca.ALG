Algoritmo "forca"

Var
   jogador1, jogador2, palavra, letra: caractere
   LetrasPalavra: vetor[1..15] de caractere
   i, erros, acertos: inteiro

procedimento forca(player1, player2: caractere)

inicio
   escreval
   escreval (player1," digite a palavra: ")
   leia (palavra)
   enquanto (compr(palavra) > 15) faca //testando comprimento da palavra
      escreval ("Palavra tem mais de 15 letras, tente novamente!")
      leia (palavra)
   fimenquanto
   limpatela
   escreval ("O jogo começou! ", player2, " tem 6 chances para adivinhar a palavra")
   escreval
   escreval
   para i de 1 ate compr(palavra) faca //zerando o vetor colocando " _ "
      LetrasPalavra[i] <- (" _ ")
   fimpara

   erros <- 0
   acertos <- 0
   repita
      para i de 1 ate compr(palavra) faca // escrevendo o vetor atual na tela
         escreva (letraspalavra[i])
      fimpara
      escreva ("            |Erros", erros,"/6")
      escreval ("           |Acertos", acertos,"/", compr(palavra))
      escreval
      escreval ("Digite a letra: ")
      leia (letra)
      enquanto (compr(letra) > 1) faca // testando se o usuario digitou somente uma letra
         escreval ("Digite apenas uma letra, tente novamente: ")
         leia (letra)
      fimenquanto
      se ((pos(maiusc(letra), maiusc (palavra))) <> 0) entao //Não diferenciar letra maiuscula de minuscula e testando se a letra existe na palavra
         para i de 1 ate compr(palavra) faca
            se (pos(maiusc(letra), copia(maiusc(palavra),i, 1)) <> 0) entao // testando se a palavra tem duas letras iguais
               se (asc (LetrasPalavra[i]) = 32) entao //testando se o usuário não digitou uma letra certa duas vezes
                  LetrasPalavra[i] <- letra //O vetor recebe a letra se o usuario acertou
                  acertos <- acertos + 1
               fimse
            fimse
         fimpara
      senao
         erros <- erros + 1
      fimse
      escreval

      limpatela
   ate(erros = 6) ou (acertos = compr(palavra))//condições de saída
   se (erros = 6) entao
      escreval (player2, " você não conseguiu adivinhar a palavra: ",palavra, ". Que pena!")
   senao
      escreval (player2, " você conseguiu adivinhar a palavra: ", palavra, ". Parabéns!")
   fimse
fimprocedimento

Inicio
   escreval ("Digite o nome do jogador 1:")
   leia (jogador1)
   escreval
   escreval ("Digite o nome do jogador 2:")
   leia (jogador2)
   forca(jogador1, jogador2) //jogador um escolhe a palavra
   escreval
   escreval ("Agora é a vez do ", jogador2, " escolher a palavra")
   forca(jogador2, jogador1) // jogador dois esoclhe a palavra
Fimalgoritmo