package br.edu.ifba.saj.sistembanco.servico;

import br.edu.ifba.saj.sistemabanco.cliente.Cliente;
import br.edu.ifba.saj.sistemabanco.funcionario.Funcionario;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public abstract class Servico {

    protected List<Cliente> contratante;
    protected List<Funcionario> responsavel;
    protected List<Date> dataDeContratacao;

    public Servico() {
        this.contratante = new ArrayList<>();
        this.responsavel = new ArrayList<>();
        this.dataDeContratacao = new ArrayList<>();
    }

    public void adicionarContratante(Cliente cliente) {
        this.contratante.add(cliente);
    }

    public void adicionarResponsavel(Funcionario vendedor) {
        this.responsavel.add(vendedor);
    }

    public void adicionarData(Date data) {
        this.dataDeContratacao.add(data);
    }

    public String obterClientePorCPF(String numeroCPF) {

        for (int i = 0; i < contratante.size(); i++) {
            if (contratante.get(i).getCPF().equals(numeroCPF)) {
                return "<html>Cliente: " + contratante.get(i).getNome() + " | Responsável: "
                        + responsavel.get(i).getNome()+ " | Data: " + dataDeContratacao.get(i).toString() + "<br>";
            }
        }
        return "";
    }

}
