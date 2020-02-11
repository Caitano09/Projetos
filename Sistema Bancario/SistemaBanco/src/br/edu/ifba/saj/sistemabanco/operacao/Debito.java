package br.edu.ifba.saj.sistemabanco.operacao;

import br.edu.ifba.saj.sistemabanco.conta.Conta;

public class Debito extends Operacao {

    public Debito(double valor) {
        super(valor);
    }

    @Override
    public double operar() {
        return getValor() * -1;
    }

    @Override
    public boolean valida(Conta conta) {
        if (conta.getSaldoTotal() >= getValor()) {
            return true;
        }
        return false;
    }

}
