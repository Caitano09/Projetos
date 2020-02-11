package br.edu.ifba.saj.sistemabanco.agencia;

import br.edu.ifba.saj.sistemabanco.cliente.Cliente;
import br.edu.ifba.saj.sistemabanco.conta.Conta;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.TreeSet;

public class Agencia {

    private List<Conta> contas;
    private Set<Cliente> clientes;
    private int numero;

    public Agencia(int numero) {
        this.numero = numero;
        this.contas = new ArrayList<Conta>();
        this.clientes = new HashSet<Cliente>();
    }

    public int getNumero() {
        return numero;
    }

    public void adicionarConta(Conta conta) {
        this.contas.add(conta);
    }

    public boolean adicionarCliente(Cliente cliente) {
        Cliente auxCliente = obterClientePorCPF(cliente.getCPF());
        if (auxCliente.getCPF().equals("Erro")) {
            this.clientes.add(cliente);
            return true;
        } else {
            return false;
        }
    }

    public Cliente obterClientePorCPF(String numeroCPF) {

        for (Cliente cliente : clientes) {
            if (cliente.getCPF().equals(numeroCPF)) {
                return cliente;
            }
        }
        return new Cliente("Erro CPF não Cadastrado!", "Erro");
    }

    public Conta obterContaPorNum(int num) {
        for (int i = 0; i < contas.size(); i++) {
            if (contas.get(i).getNumero() == num) {
                return contas.get(i);
            }
        }
        return null;
    }
}
