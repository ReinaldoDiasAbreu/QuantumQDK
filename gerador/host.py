import qsharp
from RandomQuantum import NumberGenerator

def GeraNumero(m):
    valor = m + 1  # inicializa um valor maior que maximo
    while valor > m: # Para quando o valor montado é menor que o máximo
        bit_string = [] # Lista para os números binários
        for i in range(0, m.bit_length()): # Loop do tamanho da palavra binária, de tamanho de bits necessarios para representar o valor
            bit_string.append(NumberGenerator.simulate()) # Concatena os bits retornados na lista
        valor = int("".join(str(x) for x in bit_string), 2) # Junta a lista em uma string e converte para da base 2 para um inteiro
    return valor # Retorna o valor caso for menor que o máximo

maximo = int(input("Digite o valor máximo: "))  # Captura a entrada e converte a string para um inteiro
simulacoes = int(input("Digite o número de simulações: ")) # Captura a entrada e converte a string para um inteiro

# Realiza as simulações
for i in range(simulacoes):
    print(GeraNumero(maximo))
