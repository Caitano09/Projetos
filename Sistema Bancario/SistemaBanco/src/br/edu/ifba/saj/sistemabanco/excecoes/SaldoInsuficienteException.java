package br.edu.ifba.saj.sistemabanco.excecoes;

public class SaldoInsuficienteException extends RuntimeException {

    public SaldoInsuficienteException(String erro) {
        super(erro);
    }

}
