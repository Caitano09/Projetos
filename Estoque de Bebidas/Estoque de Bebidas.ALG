Algoritmo "principal"

tipo
   Drink = registro
      nome: caractere
      preco: real
      quant: inteiro
      codigo: inteiro
   fimregistro

   Conta = registro
      venda: inteiro
      quantVenda: inteiro
   fimregistro
   
Var
   menu, cont, venda, compra, codigo, quantVend, quantCompra, contVend: inteiro
   existeCodigo: logico
   bebida: vetor[1..20] de Drink
   comanda: vetor[1..20] de Conta
   resp, nomeVend: caractere
   valorVend, valorTotal: real
   i: inteiro


Inicio
   cont <- 0
   repita

      Escreval ("                            MENU                         ")
      Escreval ()
      Escreval ("1. Cadastrar Bebida")
      escreval ("2. Vender Bebida")
      escreval ("3. Comprar Bebida")
      escreval ("4. Emitir relatório de estoque")
      escreval ("5. Sair")

      escreval
      escreva ("Dígite o número da opção correspondente: ")
      leia (menu)
      limpatela

      escolha (menu)

      caso 1
         // CADASTRO
         resp <- "0"
         repita
            cont <- cont + 1
            Escreval ("                            CADASTRO                         ")
            Escreval ()
            escreva ("Nome da Bebida: ")
            leia(bebida[cont].nome)
            bebida[cont].codigo <- cont

            enquanto (bebida[cont].nome = "") faca
               Escreval ()
               Escreval ("Nome da Bebida inválido.")
               Escreva ("Digite novamente: ")
               leia (bebida[cont].nome)
               escreval ()
            fimenquanto

            escreva ("Preço Unitário [Reais]: ")
            leia(bebida[cont].preco)

            enquanto (bebida[cont].preco = 0) faca
               Escreval ()
               Escreval ("Preço inválido.")
               Escreva ("Digite novamente: ")
               leia (bebida[cont].preco)
               escreval ()
            fimenquanto

            escreva ("Quantidade em Estoque: ")
            leia(bebida[cont].quant)

            enquanto (bebida[cont].quant = 0) faca
               Escreval ()
               Escreval ("Quantidade inválida.")
               Escreva ("Digite novamente: ")
               leia (bebida[cont].quant)
               Escreval ()
            fimenquanto

            escreval
            escreva ("Deseja confirmar o cadastro (s/n)?: ")
            leia(resp)

            repita

               se (resp <> "n" ) e (resp <> "s") entao
                  escreva ("Opção incorreta, Dígite novamente (s/n)?: ")
                  leia (resp)
               fimse

               se (resp = "n") entao

                  bebida[cont].nome <- ""
                  bebida[cont].codigo <- 0
                  bebida[cont].preco <- 0
                  bebida[cont].quant <- 0
                  cont <- cont - 1

               fimse

            ate (resp = "n") ou (resp = "s")
            limpatela
         ate (resp = "n") ou (resp = "s")

      caso 2
         // VENDA
         resp <- "0"
         codigo <- 0
         contvend <- 0
         valortotal <- 0
         se (bebida[1].codigo <>  0) entao
            repita
               Escreval ("                               VENDA                             ")
               Escreval ()
               escreval ("1. Para encontrar a bebida por meio de código.")
               escreval ("2. Para voltar ao menu.")
               escreval
               escreva ("Digite sua opção: ")
               leia (venda)
               limpatela
               escolha (venda)

               caso 1
                  repita
                     Escreval("Nome - Código")
                     para i de 1 ate cont faca

                        Escreval(bebida[i].nome," -   ",bebida[i].codigo)

                     fimpara
                     Escreval ()
                     escreva ("Código da bebida: ")
                     leia (codigo)

                     existeCodigo <- falso
                     para i de 1 ate cont faca
                        se (bebida[i].codigo = codigo) entao
                           existeCodigo <- verdadeiro
                        fimse
                     fimpara

                     se (nao existeCodigo) entao
                        escreval
                        escreval ("Código Inválido")
                        escreval
                     senao
                        escreval
                        escreval ("Nome: ", bebida[codigo].nome)
                        escreval ("Preço: R$", bebida[codigo].preco:5:2)
                        escreval ("Quantidade: ", bebida[codigo].quant)
                        escreval
                        escreva ("Quantidade de ", bebida[codigo].nome, " vendida: ")
                        leia (quantvend)
                        contvend <- contvend + 1
                        comanda[contvend].venda <- codigo

                        se (quantvend <= bebida[codigo].quant) entao
                           valorvend <-  quantvend * bebida[codigo].preco
                           valortotal <- valortotal + valorvend
                           bebida[codigo].quant <- bebida[codigo].quant - quantvend
                           comanda[contvend].quantVenda <- quantvend
                        senao
                           escreval ("Quantidade vendida excede o total.")
                           contvend <- contvend - 1
                        fimse

                     fimse

                     se (venda = 1) entao
                        escreval
                        escreva ("Deseja continuar a venda (s/n)?: ")
                        leia (resp)

                        enquanto (resp <> "s") e (resp <> "n") faca
                           escreva ("Opção incorreta, Dígite novamente (s/n)?: ")
                           leia (resp)
                        fimenquanto
                     fimse
                     limpatela
                  ate (resp = "n")

                  se (resp = "n") entao

                     para i de 1 ate contvend faca

                        Escreval (bebida[comanda[i].venda].nome, " ---- ", comanda[i].quantVenda," ---- R$ ",comanda[i].quantVenda * bebida[comanda[i].venda].preco:5:2)

                     fimpara

                     escreval
                     escreval ("Total da venda = R$", valortotal:5:2)
                     escreval
                  fimse

                  se (venda = 1) entao
                     Escreva ("Pressione - ENTER - para voltar ao menu.")
                     leia (resp)
                     limpatela
                  fimse

               caso 2
                  resp <- ""

               outrocaso
                  escreval ("Código inválido.")
                  escreval
               fimescolha

            ate (resp = "")

         senao
            escreval ("Não há bebida cadastrada.")
            escreval
         fimse

      caso 3
         // COMPRA
         resp <- "0"
         codigo <- 0
         se (bebida[1].codigo <>  0) entao
            repita
               Escreval ("                               COMPRA                             ")
               Escreval ()
               escreval ("1. Para encontrar a bebida por meio de código.")
               escreval ("2. Para voltar ao menu.")
               escreval
               escreva ("Digite sua opção: ")
               leia (compra)
               limpatela

               escolha (compra)

               caso 1
                  repita
                     Escreval("Nome - Código")
                     para i de 1 ate cont faca

                        Escreval(bebida[i].nome," -   ",bebida[i].codigo)

                     fimpara
                     Escreval ()
                     escreva ("Código da bebida: ")
                     leia (codigo)

                     existeCodigo <- falso
                     para i de 1 ate cont faca
                        se (bebida[i].codigo = codigo) entao
                           existeCodigo <- verdadeiro
                        fimse
                     fimpara

                     se (nao existeCodigo) entao
                        escreval
                        escreval ("Código Inválido")
                        escreval
                     senao
                        escreval
                        escreval ("Nome: ", bebida[codigo].nome)
                        escreval ("Preço: R$", bebida[codigo].preco:5:2)
                        escreval ("Quantidade: ", bebida[codigo].quant)
                        escreval
                        Escreva ("Quantidade de ", bebida[codigo].nome," comprada: ")
                        leia (quantcompra)

                        Se (quantcompra > 0) entao
                           bebida[codigo].quant <- bebida[codigo].quant + quantcompra)
                        senao
                           Escreva ("Valor inválido.")
                        fimse
                     fimse

                     Escreval ()
                     Escreva ("Deseja continuar a compra (s/n)? ")
                     leia (resp)

                     enquanto (resp <> "s") e (resp <> "n") faca
                        escreva ("Opção incorreta, Dígite novamente (s/n)?: ")
                        leia (resp)
                     fimenquanto

                     limpatela
                  ate (resp = "n")

               caso 2
                  resp <- "n"

               outrocaso
                  escreval ("Código inválido.")
                  escreval
               fimescolha


            ate (resp = "n")

         senao
            escreval ("Não há bebida cadastrada.")
            escreval
         fimse

      caso 4
         // ESTOQUE
         resp <- "nada"
         valortotal <- 0
         se (bebida[1].codigo <> 0) entao
            Escreval ("                               ESTOQUE                             ")
            Escreval ()
            para i de 1 ate cont faca

               Escreval ("Nome: ",bebida[i].nome)
               Escreval ("Preço: R$",bebida[i].preco:5:2)
               Escreval ("Quantidade: ",bebida[i].quant)
               Escreval ("=======================")
               valortotal <- valortotal + bebida[i].preco * bebida[i].quant
            fimpara

            Escreval ()
            Escreval ("Valor Global: R$", valortotal:5:2)
            Escreval ()

            enquanto (resp = "nada") faca
               Escreva ("Pressione - ENTER - para voltar ao menu.")
               leia (resp)
               limpatela
            fimenquanto

         senao
            escreval ("Não há bebida cadastrada.")
            escreval
         fimse


      caso 5
         menu <- 5

      outrocaso
         escreval ("Opção Invalida.")
         escreval

      fimescolha

   ate (menu = 5)

Fimalgoritmo                                                '