namespace Teleport {

    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;

    operation Set(valor : Result, q : Qubit) : Unit{
        // Setando o estado do qubit
        if(M(q) != valor){ // Caso medida for diferente do valor que queremos
            X(q); // Inverte o estado do qubit
        }
    }

    operation CreateBellState(init : Result, control : Qubit, y : Qubit) : Unit{
        // Inicializa o estado do primeiro qubit, podendo ser |0> ou |1>
        Set(init, control); 
        // Setando o segundo qubit com estado |0>, dessa forma terremos 2 estados de Bell possíveis,
        // o |B00> ou |B10>, assim quando medido um dos qubits o outro terá a mesma medida.
        Set(Zero, y);
        // Aplicando o circuito gerador de estados
        H(control);
        CNOT(control, y);
    }

    operation TeleportClassicalMessage(valor : Result) : Unit{
        using ((msg, q1, q2) = (Qubit(),Qubit(),Qubit())) {
            
            // msg -> Qubit de mensagem, deverá conter o estado a ser enviado
            // q1 -> Qubit pertencente a Alice que será emaranhado com o qubit de Bob
            // q2 -> Qubit pertencente a Bob que será emaranhado com um qubit de Alice

            // Setando o valor da mensagem e entrelaçando um qubit com bob previamente
            Set(valor, msg); // Seta o estado de mensagem
            CreateBellState(Zero, q1, q2); // Cria um estado de Bell |B00>, podendo ser usado |B10>
            
            // Operações realizadas por Alice em seus qubits
            CNOT(msg, q1); 
            H(msg);

            // Alice envia as medidas obtidas dos seus qubits por um meio clássico (Ex: Internet)

            // Bob recebe as medidas e realiza as correções necessárias
            if(MResetZ(q1) == One){
                X(q2);
            }
            if(MResetZ(msg) == One){
                Z(q2);
            }

            // Bob lê seu qubit com estado corrigo
            let m = MResetZ(q2);

            // Verificando se Bob recebeu o valor correto
            Message($"Alice enviou: {valor} -> Bob mediu: {m}");
            //Message(valor == m ? "Teleport feito com sucesso!" | "Falha no Teleport!");

        }
    }

}
