import qsharp
import random
from BB84 import KeyBB84, RandomBit

def RandomBits(n): # Retorna vetor de n bits aleatórios com python (Opicional)
    v = []
    for i in range(n):
        v.append(random.randint(0, 1))
    return v

def QubitsRandonBits(n): # Retorna vetor de n bits aleatórios com Q#
    v = []
    for i in range(n):
        v.append(RandomBit.simulate())
    return v

def GeraChaveCompartilhada(): # Retona string de chave simétrica de 8 bits
    key = []
    while len(key) <= 8: # é necessário de 8 bits para representar qualquer valor da ASCII
        # numero n de bits/qubits que serão utilizados
        tam = 16
        # Cria vetores de bits de tamanho n aleatórios
        Alice = QubitsRandonBits(tam) # Alice gera n bits aleatórios de mensagem
        AliceB = QubitsRandonBits(tam) # Alice gera uma base de bits aleatórios onde serão aplicados a H
        BobB = QubitsRandonBits(tam) # Bob gera uma base de bits aleatórios onde serão aplicados a H
        # Faz a simulação com as bases aleatórias definidas e cria uma chave compartilhada
        key = KeyBB84.simulate(AliceBits = Alice, AliceBase = AliceB, BobBase = BobB, n = tam)
    # converte a lista de inteiros para uma string binária
    for i in range(len(key)):
        key[i] = str(key[i])
    key = "".join(key)

    return key

def CriptografaCaracter(c, key):
    c = (ord(c) + int(key, 2)) % 255
    return bin(c)

def DescriptografaCaracter(c, key):
    d = (int(c, 2) - int(key, 2)) % 255
    return chr(d)

def CriptografaMensagem(msg): # Usar qualquer método de criptografia de chave única    
    Msg_Cript = []
    Keys = []
    for i in msg:
        key = GeraChaveCompartilhada()
        Keys.append(key)
        Msg_Cript.append(CriptografaCaracter(i, key))
    return (Msg_Cript, Keys)

def DescriptografaMensagem(msgs, keys): # Descriptografa mesagem de acordo com o método de chave única usado
    Msg_Cript = []
    for i in range(len(msgs)):
        Msg_Cript.append(DescriptografaCaracter(msgs[i], keys[i]))
    Msg_Cript = "".join(Msg_Cript) 
    return Msg_Cript

# One-time pad
# Na criptografia, o one-time pad (OTP) é uma técnica de criptografia que não pode ser decifrada, 
# mas requer o uso de uma chave pré-compartilhada única, do mesmo tamanho ou maior que a mensagem 
# enviada. Nesta técnica, um texto simples é emparelhado com uma chave secreta aleatória 
# (também chamada de bloco único). 
# Porém deve-se respeitar os seguintes fatores:
#   - A chave deve ser verdadeiramente aleatória.
#   - A chave deve ter pelo menos o tamanho do texto sem formatação.
#   - A chave nunca deve ser reutilizada no todo ou em parte
#   - A chave deve ser mantida completamente em segredo.
# Se isso respeitado, será impossível que a mensagem possa ser descriptografada.
# Usando Computação Quântica para gerar a chave e compartilhá-la, podemos garantir os itens citados.

# Exemplo de sequência de execução com Q#:

msg = list(input("Digite uma palavra para enviar: ")) # Captura a mensagem
print(f"Mensagem: {msg}")

Msg_Cript, keys = CriptografaMensagem(msg) # Criptografa usando OTP para cada caracter
print(f"Chaves: {keys}")
print(f"Msg Criptografada: {Msg_Cript}")

Msg_Descript = DescriptografaMensagem(Msg_Cript, keys) # Descriptografa usando chave única
print(f"Msg Descriptografada: {Msg_Descript}")

