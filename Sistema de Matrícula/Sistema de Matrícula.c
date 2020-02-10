#include <stdio.h>
#include <stdlib.h>
#include <locale.h>
#include <math.h>
#include <string.h>

#define TAM 20
#define TAM2 100
int numdecursos = 0;
int numdeinscritos = 0;

struct cadastro{
    int codcurso;
    char nomecurso[50];
    int vagascurso;
    char turnocurso;
} cadastrocursos[TAM];

struct inscricao{
    int curso;
    char nome[50];
    long long int cpf;
    int nota;
    char vaga;
}candidatos[TAM2];

struct classificar{
    char curso[20];
    char nome[100][50];
     long long int cpf[100];
    int nota[100];
    char vaga[100];
    char resul[100][10];
    int numinscritos;
} alunos[TAM];

void iniciarLista(){
    int i;
    for (i = 0; i < TAM; i++){
        cadastrocursos[i].codcurso = -1;
        cadastrocursos[i].nomecurso[0] = '\0';
        cadastrocursos[i].turnocurso = '\0';
        cadastrocursos[i].vagascurso = -1;
    }
    for (i = 0; i < TAM2; i++){
        candidatos[i].cpf = -1;
        candidatos[i].curso = -1;
        candidatos[i].nome[0]='\0';
        candidatos[i].nota = -1;
        candidatos[i].vaga = '\0';
    }
}

void carregar(){
    FILE *arquivo;
    arquivo = fopen("Lista de Cursos", "rb");
    int resp, i;

    if (arquivo == NULL){
        printf("\n\nArquivo de Cursos não pode ser aberto. \n\n\n");
        system("pause");
        return;
    }
    for ( ;; ){
       resp = fread(&cadastrocursos[numdecursos], sizeof (struct cadastro), 1, arquivo);
        if ( resp != 1 ){
            if ( feof (arquivo) ){
                break;
            }
            printf ( "\n\nErro de leitura no arquivo de Cursos. \n\n\n" );
            system("pause");
            return;
        }
        numdecursos++;
    }

    fclose(arquivo);

    arquivo = fopen("Lista de Inscritos", "rb");

    if (arquivo == NULL){
        printf("\n\nArquivo de Inscritos não pode ser aberto. \n\n\n");
        system("pause");
        return;
    }
    for ( ;; ){
       resp = fread(&candidatos[numdeinscritos], sizeof (struct inscricao), 1, arquivo);
        if ( resp != 1 ){
            if ( feof (arquivo) ){
                break;
            }
            printf ( "\n\nErro de leitura no arquivo de Inscritos. \n\n\n" );
            system("pause");
            return;
        }
        numdeinscritos++;
    }
    fclose(arquivo);
    printf("\n\nArquivos Carregados com sucesso. \n\n\n");
    system("pause");
}

void pergunta(){
    char resp;

    printf("\n\nDeseja Salvar os Dados (S-sim ou N-não)?: ");
    fflush(stdin);
    scanf("%c", &resp);
    while(resp != 's' && resp != 'n' && resp != 'S' && resp != 'N'){
        printf("\n\nOpção incorreta! Dígite novamente (S/N)?: ");
        fflush(stdin);
        scanf ("%c", &resp);
    }
    switch (resp){
    case 's':
    case 'S':
        salvar();
    }
}

void salvar(){
    FILE *arquivo;
    arquivo = fopen("Lista de Cursos", "wb");
    int result, i;

    if (arquivo == NULL){
        printf("\n\nArquivo de Cursos não pode ser aberto. \n\n\n");
        system("pause");
        return;
    }
    for (i=0; i<numdecursos; i++){
        if ( !(strcmp(cadastrocursos[i].nomecurso, "")==0) ){
            result = fwrite ( &cadastrocursos[i], sizeof ( struct cadastro ), 1, arquivo );
            if ( result != 1 ){
                printf ( "\n\nErro de escrita no arquivo de Cursos. \n\n\n" );
                system("pause");
                return;
            }
        }
    }
    fclose(arquivo);

    arquivo = fopen("Lista de Inscritos", "wb");

    if (arquivo == NULL){
        printf("\n\nArquivo de Inscritos não pode ser aberto. \n\n\n");
        system("pause");
        return;

    }
    for (i=0; i<numdeinscritos; i++){
        if ( !(strcmp(candidatos[i].nome, "")==0) ){
            result = fwrite ( &candidatos[i], sizeof ( struct inscricao ), 1, arquivo );
            if ( result != 1 ){
                printf ( "\n\nErro de escrita no arquivo de Inscritos. \n\n\n" );
                system("pause");
                return;
            }
        }
    }
    fclose(arquivo);
    printf("\n\nArquivos salvos com sucesso. \n\n\n");
    system("pause");
}

int escape(){
    char resp;

    printf("Deseja realmente Entrar nessa opção (S-sim ou N-não)?: ");
    fflush(stdin);
    scanf("%c", &resp);
    while(resp != 's' && resp != 'n' && resp != 'S' && resp != 'N'){
        printf("\n\nOpção incorreta! Dígite novamente (S/N)?: ");
        fflush(stdin);
        scanf ("%c", &resp);
    }
    switch (resp){
    case 's':
    case 'S':
        return (1);
    case 'n':
    case 'N':
        return (0);
    }

}

void cadastrarCurso(){
    int i, teste=0;
    char resp;

    printf ("Digite o Código do Curso (Somente Números): ");
    fflush(stdin);
    scanf ("%d", &cadastrocursos[numdecursos].codcurso);
    for (i=0; i< numdecursos; i++){
        if (cadastrocursos[numdecursos].codcurso == cadastrocursos[i].codcurso){
            teste = 1;
        }
    }
    while (teste == 1 || cadastrocursos[numdecursos].codcurso == -1){
        teste = 0;
        printf("Código já Existe ou Inválido! Digite Novamente: ");
        fflush(stdin);
        scanf ("%d", &cadastrocursos[numdecursos].codcurso);
        for (i=0; i< numdecursos; i++){
            if (cadastrocursos[numdecursos].codcurso == cadastrocursos[i].codcurso){
                teste = 1;
            }
        }
    }

    printf ("Digite o Nome do Curso: ");
    fflush(stdin);
    fgets (&cadastrocursos[numdecursos].nomecurso, 50, stdin);
    cadastrocursos[numdecursos].nomecurso[strlen(cadastrocursos[numdecursos].nomecurso)-1] = '\0';

    printf ("Digite a Quantidade de Vagas: ");
    fflush(stdin);
    scanf ("%d", &cadastrocursos[numdecursos].vagascurso);

    printf ("Digite o Turno do Curso (M- Matutino/ V- Vespertino / N- Noturno / D- Diurno): ");
    fflush(stdin);
    scanf("%c", &cadastrocursos[numdecursos].turnocurso);

    while(cadastrocursos[numdecursos].turnocurso != 'm' && cadastrocursos[numdecursos].turnocurso != 'v' && cadastrocursos[numdecursos].turnocurso != 'n' && cadastrocursos[numdecursos].turnocurso != 'd'
        && cadastrocursos[numdecursos].turnocurso != 'M' && cadastrocursos[numdecursos].turnocurso != 'V' && cadastrocursos[numdecursos].turnocurso != 'N' && cadastrocursos[numdecursos].turnocurso != 'D'){
        printf("Opção incorreta! Dígite novamente (M/V/N/D)?: ");
        fflush(stdin);
        scanf ("%c", &cadastrocursos[numdecursos].turnocurso);
    }

    printf("Deseja Confirmar o Cadastro (S- Sim/ N- Não)?: ");
    fflush(stdin);
    scanf ("%c", &resp);

    while(resp != 's' && resp != 'n' && resp != 'S' && resp != 'N'){
        printf("Opção incorreta! Dígite novamente (S/N)?: ");
        fflush(stdin);
        scanf ("%c", &resp);
    }
    if (resp == 'n' || resp == 'N'){
        cadastrocursos[numdecursos].codcurso = -1;
        cadastrocursos[numdecursos].nomecurso[0] = '/0';
        cadastrocursos[numdecursos].vagascurso = -1;
        cadastrocursos[numdecursos].turnocurso = '/0';
        numdecursos;
    }
}

void alterarCurso (int posicao){
    int i, teste=0, auxcod, auxvag;
    char resp, auxnome[50], auxtur;

    auxcod = cadastrocursos[posicao].codcurso;
    strcpy(auxnome, cadastrocursos[posicao].nomecurso);
    auxtur = cadastrocursos[posicao].turnocurso;
    auxvag = cadastrocursos[posicao].vagascurso;

    printf("Código: %d\n", cadastrocursos[posicao].codcurso);
    printf("Nome: %s\n", cadastrocursos[posicao].nomecurso);
    printf("Vagas: %d\n", cadastrocursos[posicao].vagascurso);
    printf("Turno: %c\n", cadastrocursos[posicao].turnocurso);

    printf("------------------------------\n");

    printf ("\n\nDigite o Novo Código do Curso: ");
    fflush(stdin);
    scanf ("%d", &cadastrocursos[posicao].codcurso);
    for (i=0; i< numdecursos; i++){
        if (i != posicao){
            if (cadastrocursos[posicao].codcurso == cadastrocursos[i].codcurso){
                teste = 1;
            }
        }
    }
    while (teste == 1 ){
        teste = 0;
        printf("Código já Existe! Digite Novamente: ");
        fflush(stdin);
        scanf ("%d", &cadastrocursos[posicao].codcurso);
        for (i=0; i< numdecursos; i++){
            if (i != posicao){
                if (cadastrocursos[posicao].codcurso == cadastrocursos[i].codcurso){
                    teste = 1;
                }
            }
        }
    }
    printf ("Digite o Novo Nome do Curso: ");
    fflush(stdin);
    fgets (&cadastrocursos[posicao].nomecurso, 50, stdin);
    cadastrocursos[posicao].nomecurso[strlen(cadastrocursos[posicao].nomecurso)-1] = '\0';

    printf ("Digite a Nova Quantidade de Vagas: ");
    fflush(stdin);
    scanf ("%d", &cadastrocursos[posicao].vagascurso);

    printf ("Digite o Novo Turno do Curso (M- Matutino/ V- Vespertino / N- Noturno / D- Diurno): ");
    fflush(stdin);
    scanf("%c", &cadastrocursos[posicao].turnocurso);

    while(cadastrocursos[posicao].turnocurso != 'm' && cadastrocursos[posicao].turnocurso != 'v' && cadastrocursos[posicao].turnocurso != 'n' && cadastrocursos[posicao].turnocurso != 'd'
        && cadastrocursos[posicao].turnocurso != 'M' && cadastrocursos[posicao].turnocurso != 'V' && cadastrocursos[posicao].turnocurso != 'N' && cadastrocursos[posicao].turnocurso != 'D'){
        printf("Opção incorreta! Dígite novamente (M/V/N/D)?: ");
        fflush(stdin);
        scanf ("%c", &cadastrocursos[posicao].turnocurso);
    }

    printf("Deseja Confirmar o Cadastro (S- Sim/ N- Não)?: ");
    fflush(stdin);
    scanf ("%c", &resp);

    while(resp != 's' && resp != 'n' && resp != 'S' && resp != 'N'){
        printf("Opção incorreta! Dígite novamente (S/N)?: ");
        fflush(stdin);
        scanf ("%c", &resp);
    }

    if (resp == 'n' || resp == 'N'){
            cadastrocursos[posicao].codcurso = auxcod;
            strcpy(cadastrocursos[posicao].nomecurso, auxnome);
            cadastrocursos[posicao].turnocurso = auxtur;
            cadastrocursos[posicao].vagascurso = auxvag;
    }
    if (resp == 's' || resp == 'S'){
        for (i=0; i<numdeinscritos; i++){
            if (candidatos[i].curso == auxcod){
                candidatos[i].curso = cadastrocursos[posicao].codcurso;
            }
        }
    }
}

void separarVagas(int *pub, int *pub1, int *pub2, int *ampla, int *defe, int *total){

    if (*total % 2 == 0){
        *pub = *total / 2;
    }
    else{
        *pub = (*total / 2) + 1;
    }

    if (*pub % 2 == 0){
        *pub1= *pub / 2;
    }
    else{
        *pub1= (*pub / 2)+1;
    }

    *pub2 = *pub - *pub1;

    if (*total % 20 == 0){
        *defe = *total / 20;
    }
    else{
        *defe= (*total / 20)+1;
    }
    *ampla = *total - *pub - *defe;
}

void inscreverCandidato (){
    int i, teste=0, teste1=0;
    char resp;

    printf("Digite o Nome do Candidato: ");
    fflush(stdin);
    fgets(&candidatos[numdeinscritos].nome, 50, stdin);
    candidatos[numdeinscritos].nome[strlen(candidatos[numdeinscritos].nome) -1] = '\0';

    printf("Digite o CPF do Candidato (sem os pontos): ");
    fflush(stdin);
    scanf("%lld", &candidatos[numdeinscritos].cpf);
    for (i=0; i < numdeinscritos; i++){
        if (candidatos[numdeinscritos].cpf == candidatos[i].cpf){
            teste = 1;
        }
    }
    while (teste == 1 || candidatos[numdeinscritos].cpf == -1){
        teste = 0;
        printf("CPF já Existe ou Inválido! Digite Novamente: ");
        fflush(stdin);
        scanf ("%lld", &candidatos[numdeinscritos].cpf);
        for (i=0; i< numdeinscritos; i++){
            if (candidatos[numdeinscritos].cpf == candidatos[i].cpf){
                teste = 1;
            }
        }
    }

    printf("Digite a Média da Nota do Enem: ");
    fflush(stdin);
    scanf("%d", &candidatos[numdeinscritos].nota);
    while (candidatos[numdeinscritos].nota > 1000 || candidatos[numdeinscritos].nota < 0){
        printf("Nota Inválida! Digite Novamente: ");
        fflush(stdin);
        scanf("%d", &candidatos[numdeinscritos].nota);
    }


    printf("\n----DIGITE O CÓDIGO DO CURSO DESEJADO----\n");
    for (i=0; i <numdecursos; i++){
        printf ("%s - %d\n", cadastrocursos[i].nomecurso, cadastrocursos[i].codcurso);
    }
    fflush(stdin);
    scanf("%d", &candidatos[numdeinscritos].curso);
    for (i=0; i <numdecursos; i++){
        if (candidatos[numdeinscritos].curso == cadastrocursos[i].codcurso){
            teste1 = 1;
        }
    }
    while (teste1 == 0){
        printf("Código do Curso Inválido! Digite Novamente: ");
        fflush(stdin);
        scanf("%d", &candidatos[numdeinscritos].curso);
        for (i=0; i <numdecursos; i++){
            if (candidatos[numdeinscritos].curso == cadastrocursos[i].codcurso){
                teste1 = 1;
            }
        }
    }

    printf("\n----DIGITE O TIPO DE VAGA DESEJADA----\n\n");
    printf("A - Ampla Concorrência\n");
    printf("B - Cota de Escola Pública(renda MENOR ou IGUAL a 1,5 salário mínimo)\n");
    printf("C - Cota de Escola Pública(renda SUPERIOR a 1,5 salário mínimo)\n");
    printf("D - Pessoa com Deficiência\n");
    fflush(stdin);
    scanf("%c", &candidatos[numdeinscritos].vaga);
    while (candidatos[numdeinscritos].vaga != 'a' && candidatos[numdeinscritos].vaga != 'b' && candidatos[numdeinscritos].vaga != 'c' && candidatos[numdeinscritos].vaga != 'd'
        && candidatos[numdeinscritos].vaga != 'A' && candidatos[numdeinscritos].vaga != 'B' && candidatos[numdeinscritos].vaga != 'C' && candidatos[numdeinscritos].vaga != 'D'){
        printf("Opção incorreta! Dígite novamente (A/B/C/D)?: ");
        fflush(stdin);
        scanf ("%c", &candidatos[numdeinscritos].vaga);
    }

    printf("Deseja Confirmar o Cadastro (S- Sim/ N- Não)?: ");
    fflush(stdin);
    scanf ("%c", &resp);

    while(resp != 's' && resp != 'n' && resp != 'S' && resp != 'N'){
        printf("Opção incorreta! Dígite novamente (S/N)?: ");
        fflush(stdin);
        scanf ("%c", &resp);
    }

    if (resp == 'n' || resp == 'N'){
        candidatos[numdeinscritos].cpf = 0;
        candidatos[numdeinscritos].curso = 0;
        candidatos[numdeinscritos].nome[0] = '/0';
        candidatos[numdeinscritos].nota = 0;
        candidatos[numdeinscritos].vaga = '/0';
        numdeinscritos++;
    }
}

void alterarInscricao (int local){
    int i, teste=0, teste1=0, auxcpf , auxcurso;
    char resp, auxnome[50], auxvaga;
    float auxnota;

    auxcpf = candidatos[local].cpf;
    strcpy(auxnome, candidatos[local].nome);
    auxcurso = candidatos[local].curso;
    auxnota = candidatos[local].nota;
    auxvaga = candidatos[local].vaga;

    printf("Nome: %s\n", candidatos[local].nome);
    printf("CPF: %lld\n", candidatos[local].cpf);
    printf("Nota: %d\n", candidatos[local].nota);
    printf("Cód. Curso: %d\n", candidatos[local].curso);
    printf("Tip. Vaga: %c\n", candidatos[local].vaga);
    printf("---------------------------------\n");

    printf("\n\nDigite o Novo Nome do Candidato: ");
    fflush(stdin);
    fgets(&candidatos[local].nome, 50, stdin);
    candidatos[local].nome[strlen(candidatos[local].nome) -1] = '\0';

    printf("Digite o Novo CPF do Candidato (sem os pontos): ");
    fflush(stdin);
    scanf("%lld", &candidatos[local].cpf);
    for (i=0; i< numdeinscritos; i++){
        if (i != local){
            if (candidatos[local].cpf == candidatos[i].cpf){
                teste = 1;
            }
        }
    }
    while (teste == 1){
        teste = 0;
        printf("CPF já Existe! Digite Novamente: ");
        fflush(stdin);
        scanf ("%lld", &candidatos[local].cpf);
        for (i=0; i< numdeinscritos; i++){
            if (i != local){
                if (candidatos[local].cpf == candidatos[i].cpf){
                    teste = 1;
                }
            }
        }
    }

    printf("Digite a Nova Média da Nota do Enem: ");
    fflush(stdin);
    scanf("%d", &candidatos[local].nota);
    while (candidatos[local].nota > 1000 || candidatos[local].nota < 0){
        printf("Nota Inválida! Digite Novamente: ");
        scanf("%d", &candidatos[local].nota);
    }

    printf("\n----DIGITE O NOVO CÓDIGO DO CURSO DESEJADO----\n ");
    for (i=0; i <numdecursos; i++){
        printf ("%s - %d\n", cadastrocursos[i].nomecurso, cadastrocursos[i].codcurso);
    }
    fflush(stdin);
    scanf("%d", &candidatos[local].curso);
    for (i=0; i <numdecursos; i++){
        if (candidatos[local].curso == cadastrocursos[i].codcurso){
            teste1 = 1;
        }
    }
    while (teste1 == 0){
        printf("Código do Curso Inválido! Digite Novamente: ");
        fflush(stdin);
        scanf("%d", &candidatos[local].curso);
        for (i=0; i <numdecursos; i++){
            if (candidatos[local].curso == cadastrocursos[i].codcurso){
                teste1 = 1;
            }
        }
    }

    printf("\n----DIGITE O NOVO TIPO DE VAGA DESEJADA----\n\n");
    printf("A - Ampla Concorrência\n");
    printf("B - Cota de Escola Pública(renda MENOR ou IGUAL a 1,5 salário mínimo)\n");
    printf("C - Cota de Escola Pública(renda SUPERIOR a 1,5 salário mínimo)\n");
    printf("D - Pessoa com Deficiência\n");
    fflush(stdin);
    scanf("%c", &candidatos[local].vaga);
    while (candidatos[local].vaga != 'a' && candidatos[local].vaga != 'b' && candidatos[local].vaga != 'c' && candidatos[local].vaga != 'd'
        && candidatos[local].vaga != 'A' && candidatos[local].vaga != 'B' && candidatos[local].vaga != 'C' && candidatos[local].vaga != 'D'){
        printf("Opção incorreta! Dígite novamente (A/B/C/D)?: ");
        fflush(stdin);
        scanf ("%c", &candidatos[local].vaga);
    }

    printf("Deseja Confirmar o Cadastro (S- Sim/ N- Não)?: ");
    fflush(stdin);
    scanf ("%c", &resp);

    while(resp != 's' && resp != 'n' && resp != 'S' && resp != 'N'){
        printf("Opção incorreta! Dígite novamente (S/N)?: ");
        fflush(stdin);
        scanf ("%c", &resp);
    }

    if (resp == 'n' || resp == 'N'){
        candidatos[local].cpf = auxcpf;
        strcpy(candidatos[local].nome, auxnome);
        candidatos[local].curso = auxcurso;
        candidatos[local].nota = auxnota;
        candidatos[local].vaga = auxvaga;
    }
}

void gerarLista (){
    int i ,j, d=0, qtdalunos=0;

    for (i=0; i < numdecursos; i++){
        strcpy(alunos[i].curso, cadastrocursos[i].nomecurso);
    }

    for (i=0; i < numdecursos; i++){
        d=0;
        qtdalunos = 0;
        for (j=0; j < numdeinscritos; j++){
            if (cadastrocursos[i].codcurso == candidatos[j].curso){
                alunos[i].cpf[d] = candidatos[j].cpf;
                alunos[i].nota[d] = candidatos[j].nota;
                alunos[i].vaga[d] = candidatos[j].vaga;
                strcpy(alunos[i].nome[d], candidatos[j].nome);
                qtdalunos++;
                d++;
            }
        }
        alunos[i].numinscritos = qtdalunos;
    }
}

void gerarClassificacao (int cont){
    int i, j, contA=0, contB=0, contC=0, contD=0;
    int A=0, BC=0, B=0, C=0, D=0, soma;
    int aux;
    int aux2;
    char aux1[30], aux3;

    gerarLista();

    for (i=0; i<alunos[cont].numinscritos; i++){
        for (j=i+1; j<alunos[cont].numinscritos; j++){
            if (alunos[cont].nota[i] < alunos[cont].nota[j]){
                aux = alunos[cont].cpf[i];
                strcpy(aux1, alunos[cont].nome[i]);
                aux2 = alunos[cont].nota[i];
                aux3 = alunos[cont].vaga[i];

                alunos[cont].cpf[i] = alunos[cont].cpf[j];
                strcpy(alunos[cont].nome[i], alunos[cont].nome[j]);
                alunos[cont].nota[i] = alunos[cont].nota[j];
                alunos[cont].vaga[i] = alunos[cont].vaga[j];

                alunos[cont].cpf[j] = aux;
                strcpy(alunos[cont].nome[j], aux1);
                alunos[cont].nota[j] = aux2;
                alunos[cont].vaga[j] = aux3;
            }
        }
    }
    soma = cadastrocursos[cont].vagascurso;
    separarVagas(&BC, &B, &C, &A, &D, &soma);

    for (i=0; i<alunos[cont].numinscritos; i++){
        switch (alunos[cont].vaga[i]){
        case 'A':
        case 'a':
            if (contA < A){
                strcpy(alunos[cont].resul[i], "APROVADO");
                contA++;
            }
            else{
                strcpy(alunos[cont].resul[i], "EM ESPERA");
            }
            break;
        case 'B':
        case 'b':
            if (contB < B){
                strcpy(alunos[cont].resul[i], "APROVADO");
                contB++;
            }
            else{
                strcpy(alunos[cont].resul[i], "EM ESPERA");
            }
            break;
        case 'C':
        case 'c':
            if (contC < C){
                strcpy(alunos[cont].resul[i], "APROVADO");
                contC++;
            }
            else{
                strcpy(alunos[cont].resul[i], "EM ESPERA");
            }
            break;
        case 'D':
        case 'd':
            if (contD < D){
                strcpy(alunos[cont].resul[i], "APROVAD0");
                contD++;
            }
            else{
                strcpy(alunos[cont].resul[i], "EM ESPERA");
            }
            break;
        }
    }
}

int main(){
    int menu, i, j, codigo, teste;
    long long int cpf;
    int c12, c1, c2, am, pcd, soma, a, b, c, d;
    char resp;
    setlocale(LC_ALL, "");

    iniciarLista();

    printf("Deseja Carregar o Arquivo Salvo (S-sim ou N-não)?: ");
    fflush(stdin);
    scanf("%c", &resp);
    while(resp != 's' && resp != 'n' && resp != 'S' && resp != 'N'){
        printf("\n\nOpção incorreta! Dígite novamente (S/N)?: ");
        fflush(stdin);
        scanf ("%c", &resp);
    }
    switch (resp){
    case 's':
    case 'S':
        carregar();
    }

    do{

        system("cls");
        printf ("----DIGITE A OPÇÃO DESEJADA----\n\n");
        printf ("1- Cadastrar Cursos\n");
        printf ("2- Alterar Cursos\n");
        printf ("3- Separar e Visualizar Vagas por Tipos\n");
        printf ("4- Inscrever Candidato\n");
        printf ("5- Alterar Inscrição\n");
        printf ("6- Gerar Lista de Inscritos\n");
        printf ("7- Gerar Classificação\n");
        printf ("8- Sair\n");
        fflush(stdin);
        scanf ("%d", &menu);

        switch (menu){
        case 1:
            if (escape()){
                system("cls");
                cadastrarCurso();
                numdecursos++;
            }
            printf("\n\n\n");
            system("pause");
            pergunta();
            break;

        case 2:
            if (escape()){
                system("cls");
                teste = 0;
                if (cadastrocursos[0].codcurso == -1){
                    printf("Cadastre um Curso Primeiro!\n");
                }
                else{
                    printf ("----DIGITE O CÓDIGO DO CURSO DESEJADO----\n");
                    for (i=0; i <numdecursos; i++){
                        printf ("%s - %d\n", cadastrocursos[i].nomecurso, cadastrocursos[i].codcurso);
                    }
                    fflush(stdin);
                    scanf ("%d", &codigo);
                    for (i=0; i <numdecursos; i++){
                        if (cadastrocursos[i].codcurso == codigo){
                            printf("\n----INFORMAÇÕES ATUAIS DO CURSO ----\n\n");
                            alterarCurso(i);
                            teste = 1;
                        }
                    }
                    if (teste == 0){
                        printf("Código Inválido\n");
                    }
                }
            }
            printf("\n\n\n");
            system("pause");
            pergunta();
            break;

        case 3:
            system("cls");
            if (cadastrocursos[0].codcurso == -1){
                printf("Cadastre um Curso Primeiro!\n\n\n");
            }
            else{
                for (i=0; i < numdecursos; i++){
                    c12 = 0;
                    c1 = 0;
                    c2 = 0;
                    am = 0;
                    pcd = 0;
                    soma = cadastrocursos[i].vagascurso;

                    separarVagas(&c12, &c1, &c2, &am, &pcd, &soma);

                    printf("-----------DIVISÃO DE VAGAS DO CURSO \"%s\" CÓDIGO \"%d\"-----------\n\n", cadastrocursos[i].nomecurso,  cadastrocursos[i].codcurso);
                    printf("               TOTAL DE VAGAS: %d\n\n", soma);
                    printf("VAGAS ESCOLA PÚBLICA PARA RENDA <= 1,5 salários: %d\n", c1);
                    printf("VAGAS ESCOLA PÚBLICA PARA RENDA > 1,5 salários: %d\n\n", c2);
                    printf("VAGAS PESSOAS COM DEFICIÊNCIA: %d\n\n", pcd);
                    printf("VAGAS PARA AMPLA CONCORRÊNCIA: %d\n\n\n\n", am);
                }
            }
            system("pause");
            break;

        case 4:
            if (escape()){
                system("cls");
                if (cadastrocursos[0].codcurso == -1){
                    printf("Cadastre um Curso Primeiro!\n");
                }
                else{
                    inscreverCandidato();
                    numdeinscritos++;
                }
            }
                printf("\n\n\n");
                system("pause");
                pergunta();
                break;

        case 5:
            if (escape()){
                system("cls");
                teste = 0;
                if (candidatos[0].cpf == -1){
                    printf("Cadastre um Candidato Primeiro!\n");
                }
                else{
                    printf("Digite o CPF: ");
                    fflush(stdin);
                    scanf("%lld", &cpf);
                    for (i=0; i <numdeinscritos; i++){
                        if (candidatos[i].cpf == cpf){
                            printf("\n----INFORMAÇÕES ATUAIS DO CANDIDATO ----\n\n");
                            alterarInscricao(i);
                            teste = 1;
                        }
                    }
                    if (teste == 0){
                        printf("CPF Inválido\n");
                    }
                }
            }
            printf("\n\n\n");
            system("pause");
            pergunta();
            break;

        case 6:
            system("cls");
            if (cadastrocursos[0].codcurso == -1){
                printf("Cadastre um Curso Primeiro!\n\n\n");
            }
            else{
                printf("*Simbologia do Tipo de Vagas\n\n");
                printf("A- Ampla concorrência\n");
                printf("B- Cota de escola Público com renda <= 1,5 Salários\n");
                printf("C- Cota de escola Público com renda > 1,5 Salários\n");
                printf("D- Cota para pessoas com deficiência\n\n");

                gerarLista();

                for (i=0; i<numdecursos; i++){
                    printf("---------INSCRITOS DO CURSO DE %s----------\n\n", alunos[i].curso);

                    for(j=0; j<alunos[i].numinscritos; j++){
                        if (alunos[i].vaga[j] == 'A' || alunos[i].vaga[j] == 'a'){
                            printf("Nome: %s      CPF: %lld        Nota do Enem: %d        Tipo da Vaga: %c\n",
                                   alunos[i].nome[j], alunos[i].cpf[j], alunos[i].nota[j], alunos[i].vaga[j]);
                        }
                    }
                    printf("\n");
                    for(j=0; j<alunos[i].numinscritos; j++){
                        if (alunos[i].vaga[j] == 'B' || alunos[i].vaga[j] == 'b'){
                            printf("Nome: %s      CPF: %lld        Nota do Enem: %d        Tipo da Vaga: %c\n",
                                   alunos[i].nome[j], alunos[i].cpf[j], alunos[i].nota[j], alunos[i].vaga[j]);
                        }
                    }
                    printf("\n");
                    for(j=0; j<alunos[i].numinscritos; j++){
                        if (alunos[i].vaga[j] == 'C' || alunos[i].vaga[j] == 'c'){
                            printf("Nome: %s      CPF: %lld        Nota do Enem: %d        Tipo da Vaga: %c\n",
                                   alunos[i].nome[j], alunos[i].cpf[j], alunos[i].nota[j], alunos[i].vaga[j]);
                        }
                    }
                    printf("\n");
                    for(j=0; j<alunos[i].numinscritos; j++){
                        if (alunos[i].vaga[j] == 'D' || alunos[i].vaga[j] == 'd'){
                            printf("Nome: %s      CPF: %lld        Nota do Enem: %d        Tipo da Vaga: %c\n",
                                   alunos[i].nome[j], alunos[i].cpf[j], alunos[i].nota[j], alunos[i].vaga[j]);
                        }
                    }
                printf("\n\n\n");
                }
            }
            system("pause");
            break;

        case 7:
            system("cls");
            if (cadastrocursos[0].codcurso == -1){
                printf("Cadastre um Curso Primeiro!\n\n\n");
            }
            else{

                printf("*Simbologia do Tipo de Vagas\n");
                printf("A- Ampla concorrência\n");
                printf("B- Cota de escola Público com renda <= 1,5 Salários\n");
                printf("C- Cota de escola Público com renda > 1,5 Salários\n");
                printf("D- Cota para pessoas com deficiência\n\n");
                for (i=0; i<numdecursos; i++){
                    a=0;
                    b=0;
                    c=0;
                    d=0;
                    printf("---------CLASSIFICAÇÃO DO CURSO DE %s----------\n\n", alunos[i].curso);
                    gerarClassificacao(i);
                    for (j=0; j<alunos[i].numinscritos; j++){
                        if (alunos[i].vaga[j] == 'A' || alunos[i].vaga[j] == 'a'){
                            a++;
                            printf("%dº Nome: %s      Nota do Enem: %d        Tipo da Vaga: %c            %s\n",
                                    a, alunos[i].nome[j], alunos[i].nota[j], alunos[i].vaga[j], alunos[i].resul[j]);
                        }
                    }
                    printf("\n");
                    for (j=0; j<alunos[i].numinscritos; j++){
                        if (alunos[i].vaga[j] == 'B' || alunos[i].vaga[j] == 'b'){
                            b++;
                                printf("%dº Nome: %s      Nota do Enem: %d        Tipo da Vaga: %c            %s\n",
                                    b, alunos[i].nome[j], alunos[i].nota[j], alunos[i].vaga[j], alunos[i].resul[j]);
                        }
                    }
                    printf("\n");
                    for (j=0; j<alunos[i].numinscritos; j++){
                        if (alunos[i].vaga[j] == 'C' || alunos[i].vaga[j] == 'c'){
                            c++;
                            printf("%dº Nome: %s      Nota do Enem: %d        Tipo da Vaga: %c            %s\n",
                                    c, alunos[i].nome[j], alunos[i].nota[j], alunos[i].vaga[j], alunos[i].resul[j]);
                        }
                    }
                    printf("\n");
                    for (j=0; j<alunos[i].numinscritos; j++){
                        if (alunos[i].vaga[j] == 'D' || alunos[i].vaga[j] == 'd'){
                            d++;
                            printf("%dº Nome: %s      Nota do Enem: %d        Tipo da Vaga: %c            %s\n",
                                    d, alunos[i].nome[j], alunos[i].nota[j], alunos[i].vaga[j], alunos[i].resul[j]);
                        }
                    }
                    printf("\n\n\n");
                }
            }
            system("pause");
            break;

        case 8:
            system("cls");
            printf("Saindo...\n\n\n");
            menu = 8;
            break;

        default:
            system("cls");
            printf("Opção Inválida! Tente Novamente.\n\n\n");
            system("pause");
            break;
        }
    }while(menu != 8);
    system("pause");
    return 0;
}


