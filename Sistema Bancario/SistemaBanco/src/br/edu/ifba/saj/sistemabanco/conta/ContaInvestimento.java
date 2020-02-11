package br.edu.ifba.saj.sistemabanco.conta;

import br.edu.ifba.saj.sistemabanco.tributo.Tributavel;

public class ContaInvestimento extends Conta implements Tributavel {

    @Override
    public double getSaldoTotal() {
        return this.getSaldo();
    }

    @Override
    public double calculaTributos() {
        return this.getSaldo() * 0.01;
    }

}
