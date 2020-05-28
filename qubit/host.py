import qsharp
from qubit import NewQubit

for i in range(10): # Repetição da simulação 10 vezes
    print(NewQubit.simulate()) # Imprimindo o bit de retorno da simulação

