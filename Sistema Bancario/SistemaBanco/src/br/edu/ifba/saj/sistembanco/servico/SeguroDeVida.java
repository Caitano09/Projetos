package br.edu.ifba.saj.sistembanco.servico;

import br.edu.ifba.saj.sistemabanco.cliente.Cliente;
import br.edu.ifba.saj.sistemabanco.funcionario.Funcionario;
import br.edu.ifba.saj.sistemabanco.tributo.Tributavel;
import java.util.Date;

public class SeguroDeVida extends Servico implements Tributavel {

    public SeguroDeVida() {
        super();
    }

    @Override
    public double calculaTributos() {
        return 200;
    }

    public String obterClientePorCPF(String numeroCPF) {

        for (int i = 0; i < contratante.size(); i++) {
            if (contratante.get(i).getCPF().equals(numeroCPF)) {
                return super.obterClientePorCPF(numeroCPF) + "Seguro de Vida: " + this.calculaTributos() + "</html>";
            }
        }
        return "";
    }

}
