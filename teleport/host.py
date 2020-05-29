import qsharp

from qsharp import Result

from Teleport import TeleportClassicalMessage

send = (Result.Zero, Result.One, Result.One, Result.Zero) # Sequencia de estados para enviar

print("\nTeleportando Estado do Qubit")
for i in send:
    TeleportClassicalMessage.simulate(valor = i) # Simulando para cada estado
