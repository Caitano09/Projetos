package br.edu.ifba.saj.sistembanco.servico;

import br.edu.ifba.saj.sistemabanco.cliente.Cliente;
import br.edu.ifba.saj.sistemabanco.funcionario.Funcionario;
import br.edu.ifba.saj.sistemabanco.veiculo.Veiculo;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class SeguroDeVeiculo extends Servico {

    private List<Veiculo> veiculo;
    private List valorDoSeguroDeVeiculo;
    private List franquia;

    public SeguroDeVeiculo() {
        super();
        veiculo = new ArrayList<>();
        valorDoSeguroDeVeiculo = new ArrayList();
        franquia = new ArrayList();
    }

    public void setVeiculo(Veiculo veiculo) {
        this.veiculo.add(veiculo);
    }

    public void setValorDoSeguroDeVeiculo(double valorDoSeguroDeVeiculo) {
        this.valorDoSeguroDeVeiculo.add(valorDoSeguroDeVeiculo);
    }

    public void setFranquia(double franquia) {
        this.franquia.add(franquia);
    }

    @Override
    public String obterClientePorCPF(String numeroCPF) {

        for (int i = 0; i < contratante.size(); i++) {
            if (contratante.get(i).getCPF().equals(numeroCPF)) {
                return super.obterClientePorCPF(numeroCPF)
                        + "Placa do Veiculo: " + veiculo.get(i).getPlaca() + " | Seguro do Veículo: "
                        + valorDoSeguroDeVeiculo.get(i) + " | Franquia: " + franquia.get(i) + "</html>";
            }
        }
        return "";
    }

}
