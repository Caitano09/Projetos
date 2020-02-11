package br.edu.ifba.saj.sistemabanco.operacao;

import br.edu.ifba.saj.sistemabanco.conta.Conta;

public class CreditoTaxado extends Operacao {

    public CreditoTaxado(double valor) {
        super(valor);
    }

    @Override
    public double operar() {
        return getValor() - getValor() * 0.0033;
    }

    @Override
    public boolean valida(Conta conta) {
        return true;
    }

}
