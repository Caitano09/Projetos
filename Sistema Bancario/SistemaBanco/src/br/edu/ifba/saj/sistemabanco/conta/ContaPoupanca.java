package br.edu.ifba.saj.sistemabanco.conta;

public class ContaPoupanca extends Conta {

    private int aniversario;

    public ContaPoupanca(int aniversario) {
        super();
        this.aniversario = aniversario;
    }

    public int getAniversario() {
        return aniversario;
    }

    @Override
    public double getSaldoTotal() {
        return getSaldo();
    }

}
