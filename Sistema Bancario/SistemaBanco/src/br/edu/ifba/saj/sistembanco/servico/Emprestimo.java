package br.edu.ifba.saj.sistembanco.servico;

import br.edu.ifba.saj.sistemabanco.cliente.Cliente;
import br.edu.ifba.saj.sistemabanco.funcionario.Funcionario;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Emprestimo extends Servico {

    private List valor;
    private List taxa;

    public Emprestimo() {
        super();
        valor = new ArrayList();
        taxa = new ArrayList();
    }

    public void setValor(double valor) {
        this.valor.add(valor);
    }

    public void setTaxa(double taxa) {
        this.taxa.add(taxa);
    }

    @Override
    public String obterClientePorCPF(String numeroCPF) {

        for (int i = 0; i < contratante.size(); i++) {
            if (contratante.get(i).getCPF().equals(numeroCPF)) {
                return super.obterClientePorCPF(numeroCPF)
                        + "Emprestimo: " + valor.get(i) + " | Taxa: " + taxa.get(i) + "</html>";
            }
        }
        return "";
    }
}
