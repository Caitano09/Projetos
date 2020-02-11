package br.edu.ifba.saj.sistemabanco.funcionario;

public class Funcionario {

    private String nomeCompleto;

    public Funcionario(String nomeCompleto) {
        this.nomeCompleto = nomeCompleto;
    }

    public String getNome() {
        return nomeCompleto;
    }
}
