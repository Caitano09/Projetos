package br.edu.ifba.saj.sistemabanco.conta;

public class ContaCorrente extends Conta {

    private double limite = 100;

    public ContaCorrente() {
        super();
    }

    @Override
    public double getSaldoTotal() {
        return getSaldo() + getLimite();
    }

    public double getLimite() {
        return limite;
    }

    public void setLimite(double limite) {
        this.limite = limite;
    }
}
