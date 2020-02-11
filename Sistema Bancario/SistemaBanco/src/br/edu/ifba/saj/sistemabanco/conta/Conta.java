package br.edu.ifba.saj.sistemabanco.conta;

import br.edu.ifba.saj.sistemabanco.excecoes.SaldoInsuficienteException;
import br.edu.ifba.saj.sistemabanco.cliente.Cliente;
import br.edu.ifba.saj.sistemabanco.operacao.Operacao;
import java.util.ArrayList;
import java.util.Collection;

public abstract class Conta {

    private static int chave = 0;
    private int numero;
    private Cliente cliente;
    private double saldo;
    private Collection extrato;
    private int agencia;

    public Conta() {
        extrato = new ArrayList();
        chave++;
        setNumero(chave);
    }

    public int getAgencia() {
        return agencia;
    }

    public void setAgencia(int agencia) {
        this.agencia = agencia;
    }

    public int getNumero() {
        return numero;
    }

    public void setNumero(int numero) {
        this.numero = numero;
    }

    public Cliente getCliente() {
        return cliente;
    }

    public void setCliente(Cliente cliente) {
        this.cliente = cliente;
    }

    public double getSaldo() {
        return saldo;
    }

    protected void setSaldo(double saldo) {
        this.saldo = saldo;
    }

    protected Collection getExtrato() {
        return extrato;
    }

    public void executa(Operacao operacao) {
        if (operacao.valida(this)) {
            double valorOperacao = operacao.operar();
            this.saldo += valorOperacao;
            extrato.add(valorOperacao);
        } else {
            throw new SaldoInsuficienteException("Saldo Insuficiente");
        }
    }

    public String exibirExtrato() {
        String extratoGeral = "";

        for (Object auxExtrato : extrato) {
            extratoGeral += String.format("*  %8.2f \n", (double) auxExtrato);
        }

        return extratoGeral;
    }

    public boolean equals(Object obj) {
        Conta outraConta = (Conta) obj;
        return this.getNumero() == outraConta.getNumero();
    }

    public String toString() {
        return "Conta numero: " + getNumero() + "\n Saldo: " + getSaldo() + "\n Cliente: " + getCliente().getNome();
    }

    public abstract double getSaldoTotal();
}
