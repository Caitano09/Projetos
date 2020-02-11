package br.edu.ifba.saj.sistemabanco.operacao;

import br.edu.ifba.saj.sistemabanco.conta.Conta;

public abstract class Operacao {

    private double valor;

    public Operacao(double valor) {
        this.valor = valor;
    }

    protected double getValor() {
        return valor;
    }

    public abstract double operar();

    public abstract boolean valida(Conta conta);
}
