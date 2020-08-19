import qsharp
from qsharp import Result
from teleport import QuantumTeleport

'''
    Simulação do envio do estado de um qubit, usando o circuito 
    de teleporte quântico

    Simulação do Circuito Online no Link abaixo:
    https://algassert.com/quirk#circuit={"cols":[[1,"H"],[1,"•","X"],["•","X"],["H"],["Measure","Measure"],[1,"•","X"],["•",1,"Z"],[1,1,"Measure"]]}
'''

# Simular o envio de informação para bob, para cada bit de mensagem
print("Enviando estado |0>")
for i in range(10):
    Msg, qM, qA, qB = QuantumTeleport.simulate(Msg = Result.Zero)
    print(Msg, qM, qA, qB, Msg == qB)

print("Enviando estado |1>")
for i in range(10):
    Msg, qM, qA, qB = QuantumTeleport.simulate(Msg = Result.One)
    print(Msg, qM, qA, qB, Msg == qB)

# Observe que não há relação entre a mensagem enviada e os qubits após medidos.
