package br.edu.ifba.saj.sistemabanco.operacao;

import br.edu.ifba.saj.sistemabanco.conta.Conta;

public class Transfere extends Operacao {

    private Conta outraConta;

    public Transfere(Conta outraConta, double valor) {
        super(valor);
        this.outraConta = outraConta;
    }

    @Override
    public double operar() {
        outraConta.executa(new Credito(getValor()));
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
