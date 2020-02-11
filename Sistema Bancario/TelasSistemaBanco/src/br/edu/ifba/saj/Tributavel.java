/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package br.edu.ifba.saj;

import br.edu.ifba.saj.sistemabanco.agencia.Agencia;
import br.edu.ifba.saj.sistemabanco.cliente.Cliente;
import br.edu.ifba.saj.sistemabanco.conta.Conta;
import br.edu.ifba.saj.sistemabanco.conta.ContaInvestimento;
import br.edu.ifba.saj.sistembanco.servico.SeguroDeVida;

/**
 *
 * @author danie
 */
public class Tributavel extends javax.swing.JInternalFrame {

    private Agencia agencia;
    private SeguroDeVida seguroDeVida;
    private Cliente cliente;
    private ContaInvestimento conta;

    /**
     * Creates new form Tributavel
     */
    public Tributavel(Agencia agencia, SeguroDeVida seguroDeVida) {
        this.agencia = agencia;
        this.seguroDeVida = seguroDeVida;
        initComponents();
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        txtNumConta = new javax.swing.JTextField();
        lblDono = new javax.swing.JLabel();
        btnBuscar = new javax.swing.JButton();
        lblNumConta = new javax.swing.JLabel();
        btnBuscar2 = new javax.swing.JButton();
        lblNome = new javax.swing.JLabel();
        txtCPF = new javax.swing.JTextField();
        lblCPF = new javax.swing.JLabel();
        jScrollPane1 = new javax.swing.JScrollPane();
        txtTributos = new javax.swing.JTextArea();
        btnOk = new javax.swing.JButton();

        btnBuscar.setText("Buscar");
        btnBuscar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnBuscarActionPerformed(evt);
            }
        });

        lblNumConta.setText("Nº da Conta(Investimento)");

        btnBuscar2.setText("Buscar");
        btnBuscar2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnBuscar2ActionPerformed(evt);
            }
        });

        txtCPF.setToolTipText("Informar o Nome");

        lblCPF.setText("CPF(Cliente Cadastrado)");

        txtTributos.setColumns(20);
        txtTributos.setRows(5);
        jScrollPane1.setViewportView(txtTributos);

        btnOk.setText("Ok");
        btnOk.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnOkActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane1, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                        .addComponent(lblCPF)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(txtCPF)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(btnBuscar2))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                        .addGroup(layout.createSequentialGroup()
                            .addComponent(lblNumConta)
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                            .addComponent(txtNumConta, javax.swing.GroupLayout.PREFERRED_SIZE, 240, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                            .addComponent(btnBuscar))
                        .addGroup(javax.swing.GroupLayout.Alignment.LEADING, layout.createSequentialGroup()
                            .addGap(380, 380, 380)
                            .addComponent(btnOk, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                        .addGap(0, 0, Short.MAX_VALUE)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(lblDono, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 250, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(lblNome, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 206, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(lblNumConta)
                    .addComponent(txtNumConta, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(btnBuscar))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(lblDono, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(11, 11, 11)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(lblCPF)
                    .addComponent(txtCPF, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(btnBuscar2))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(lblNome, javax.swing.GroupLayout.PREFERRED_SIZE, 28, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(btnOk)
                .addGap(29, 29, 29)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void btnBuscarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnBuscarActionPerformed
        // TODO add your handling code here:
        this.conta = (ContaInvestimento) agencia.obterContaPorNum(Integer.parseInt(txtNumConta.getText()));
        lblDono.setText(agencia.obterContaPorNum(Integer.parseInt(txtNumConta.getText())).getCliente().getNome());
    }//GEN-LAST:event_btnBuscarActionPerformed

    private void btnBuscar2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnBuscar2ActionPerformed
        // TODO add your handling code here:
        this.cliente = agencia.obterClientePorCPF(txtCPF.getText());
        lblNome.setText(agencia.obterClientePorCPF(txtCPF.getText()).getNome());
    }//GEN-LAST:event_btnBuscar2ActionPerformed

    private void btnOkActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnOkActionPerformed
        // TODO add your handling code here:
        double investimento = 0;
        double seguro = 0;
        if (this.conta != null) {
            investimento = conta.calculaTributos();
        }
        if (this.cliente != null) {
            seguro = seguroDeVida.calculaTributos();
        }

        txtTributos.setText("Conta Investimento: " + investimento + "\nSeguro de Vida: "
                + seguro + "\nTotal: " + (investimento + seguro));

    }//GEN-LAST:event_btnOkActionPerformed


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton btnBuscar;
    private javax.swing.JButton btnBuscar2;
    private javax.swing.JButton btnOk;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JLabel lblCPF;
    private javax.swing.JLabel lblDono;
    private javax.swing.JLabel lblNome;
    private javax.swing.JLabel lblNumConta;
    private javax.swing.JTextField txtCPF;
    private javax.swing.JTextField txtNumConta;
    private javax.swing.JTextArea txtTributos;
    // End of variables declaration//GEN-END:variables
}
