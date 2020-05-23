// Código em Q#
// Deve possuir um namespace e operações, em analogia ao que temos
// no uso de bibliotecas e funções em outras linguagens, cada instrução
// deve ser finalizada com ponto e virgula e cada bloco é limitado por chaves.

// Quando importado pelo python, o QDK verificará nos arquivos .qs a existência
// do namespace e da operação importada.

namespace HelloWorld {
    // Inserção de outros namespaces (bibliotecas)
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;

    // Inserção de operações
    operation Hello() : Unit {
        // Essa operação não retorna nada (Unit), só
        // exibirá uma messagem no terminal.
        Message("Hello from quantum world!");
    }
}
