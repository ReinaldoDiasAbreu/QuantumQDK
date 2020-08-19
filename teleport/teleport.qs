namespace teleport {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Measurement;

    operation SetQubit(q : Qubit, bit : Result) : Unit{
        if(M(q) != bit){
            X(q);
        }
    }

    operation GerarEstadoBell(q1 : Qubit, q2 : Qubit) : Unit{
        H(q1);
        CNOT(q1, q2);
    }

    operation QuantumTeleport(Msg : Result) : (Result, Result, Result, Result){

        using ((qM, qA, qB) = (Qubit(), Qubit(), Qubit())){
            // Alice e Bob compartilha um qubit emaranhado previamente
            // para isso vamos gerar um estado de bell |B00>
            GerarEstadoBell(qA, qB);

            // Alice configura seu qubit de mensagem com o bit que quer enviar
            SetQubit(qM, Msg);

            // Alice aplica a CNOT no seu qubit de mensagem e após aplica a H
            // Note que essa operação é o inverso do circuito para gerar o emaranhamento
            CNOT(qM, qA);
            H(qM);

            //Nesso ponto o qubit emaranhado de Bob já sofreu influencia das operações de Alice
            // Alice então vai medir seus qubits, e enviar as medidas para Bob, seguindo uma
            // sequencia nas medidas Bob vai aplicar ou não operações em seu qubit para 
            // obter na medida exatamente o bit configurado no qubit de mensagem de Alice

            let MqMsg = MResetZ(qM);
            let MqA = MResetZ(qA);

            // Alice envia esses dois bits obtidos para Bob
            // Bob aplicará as operações X ou Z de acordo com os bits recebidos
            // De acordo com as medidas de Alice, Bob fará:
            // |  qA | qMsg |    X  |   Z   |
            // |   0 |   0  |    F  |   F   |
            // |   1 |   0  |    V  |   F   |
            // |   0 |   1  |    F  |   V   |
            // |   1 |   1  |    V  |   V   |
            // Lembrando que seguindo o circuito há uma sequência para aplicar as portas
            // Se ambas forem aplicadas, primeiro aplica-se a X e depois a Z.

            if(MqA == One){
                X(qB);
            }
            if(MqMsg == One){
                Z(qB);
            }

            // Agora Bob fará a medida do seu qubit, e terá o mesmo valor do bit de mensagem.

            let MqB = MResetZ(qB);

            // Vamos retornar as medidas

            return (Msg, MqMsg, MqA, MqB);
            
        }

    }

}
