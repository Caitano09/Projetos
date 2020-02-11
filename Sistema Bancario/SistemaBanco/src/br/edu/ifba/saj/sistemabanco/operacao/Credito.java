package br.edu.ifba.saj.sistemabanco.operacao;

import br.edu.ifba.saj.sistemabanco.conta.Conta;

public class Credito extends Operacao {

    public Credito(double valor) {
        super(valor);
    }

    @Override
    public double operar() {
        return getValor();
    }

    @Override
    public boolean valida(Conta conta) {
        return true;
    }

}
