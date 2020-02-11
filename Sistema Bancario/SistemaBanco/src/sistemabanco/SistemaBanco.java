package sistemabanco;

import br.edu.ifba.saj.sistemabanco.cliente.Cliente;
import br.edu.ifba.saj.sistemabanco.conta.Conta;
import br.edu.ifba.saj.sistemabanco.conta.ContaCorrente;
import br.edu.ifba.saj.sistemabanco.conta.ContaPoupanca;
import br.edu.ifba.saj.sistemabanco.excecoes.SaldoInsuficienteException;
import br.edu.ifba.saj.sistemabanco.operacao.Credito;
import br.edu.ifba.saj.sistemabanco.operacao.CreditoTaxado;
import br.edu.ifba.saj.sistemabanco.operacao.Debito;
import br.edu.ifba.saj.sistemabanco.operacao.Transfere;

public class SistemaBanco {

    public static void main(String[] args) {
        Conta minhaConta = new ContaPoupanca(9);
        Cliente cliente1 = new Cliente("Daniel", "11111111111");
        minhaConta.setCliente(cliente1);

        Conta outraConta = new ContaCorrente();
        Cliente cliente2 = new Cliente("Jose", "22222222222");
        outraConta.setCliente(cliente2);

        System.out.println("Depositando 10 na conta de " + minhaConta.getCliente().getNome() + "(" + minhaConta.getNumero() + ")");
        minhaConta.executa(new Credito(10));
        System.out.println("Depositando 10 na conta de " + minhaConta.getCliente().getNome() + "(" + minhaConta.getNumero() + ")");
        minhaConta.executa(new Credito(10));
        System.out.println("Sacando 100 na conta de " + minhaConta.getCliente().getNome() + "(" + minhaConta.getNumero() + ")");
        try {
            minhaConta.executa(new Debito(100));
        } catch (SaldoInsuficienteException e) {
            System.out.println(e.getMessage());
        }
        System.out.println("<=====================================");
        System.out.println("Depositando 1000 na conta de " + outraConta.getCliente().getNome() + "(" + outraConta.getNumero() + ")");
        outraConta.executa(new CreditoTaxado(1000));
        System.out.println("Sacando 2000 na conta de " + outraConta.getCliente().getNome() + "(" + outraConta.getNumero() + ")");
        try {
            outraConta.executa(new Debito(2000));
        } catch (SaldoInsuficienteException e) {
            System.out.println(e.getMessage());
        }

        System.out.println("<=====================================");
        System.out.println("O saldo da conta do cliente " + minhaConta.getCliente().getNome() + " é: " + minhaConta.getSaldo());
        System.out.printf("O saldo da conta do cliente %s é: %.1f \n", outraConta.getCliente().getNome(), outraConta.getSaldo());
        System.out.println("=====================================>");

        System.out.println("Trasnferindo 2000");
        try {
            outraConta.executa(new Transfere(minhaConta, 2000));
        } catch (SaldoInsuficienteException e) {
            System.out.println(e.getMessage());
        }

        System.out.println("<=====================================");
        System.out.println("O saldo da conta do cliente " + minhaConta.getCliente().getNome() + " é: " + minhaConta.getSaldo());
        System.out.printf("O saldo da conta do cliente %s é: %.1f \n", outraConta.getCliente().getNome(), outraConta.getSaldo());
        System.out.println("=====================================>");

        System.out.println("Trasnferindo 1000");
        try {
            outraConta.executa(new Transfere(minhaConta, 1000));
        } catch (SaldoInsuficienteException e) {
            System.out.println(e.getMessage());
        }

        System.out.println("<=====================================");
        System.out.println("O saldo da conta do cliente " + minhaConta.getCliente().getNome() + " é: " + minhaConta.getSaldo());
        System.out.printf("O saldo da conta do cliente %s é: %.1f \n", outraConta.getCliente().getNome(), outraConta.getSaldo());
        System.out.println("=====================================>");

        System.out.println("=====================================>");
        System.out.println(minhaConta.exibirExtrato());
        System.out.println("=====================================>");
        System.out.println("=====================================>");
        System.out.println(outraConta.exibirExtrato());
    }

}
