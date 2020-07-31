namespace BB84 {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Measurement;

    // Gera bit aleatório com 1 qubit
    operation RandomBit() : Int{
        using (q = Qubit()){
            H(q);
            if(MResetZ(q) == One){
                return 1;
            }
            else{
                return 0;
            }
        }
    }

    // Operações de Conversão/Impressão, não necessárias no protocolo

    operation PrintVetorInt(v : Int[], n : Int) : Unit{
        mutable str = "";
        for(i in 0..n-1){
            set str = str + " " + IntAsString(v[i]);
        }
        Message(str);
    }

    operation ConvertResultinIntArray(v : Result[], n : Int) : Int[]{
        mutable arr = new Int[n];
        for(i in 0..n-1){
            if(v[i]==One){
                set arr w/= i <- 1;
            }else{
                set arr w/= i <- 0;
            }
        }
        return arr;
    }

    // Operações de Aplicação de Base e  Medidas

    operation AliceApply(qubits : Qubit[], n : Int, AliceBits : Int[], AliceBase : Int[]) : Unit{
        for(i in 0..n-1){
            if(AliceBits[i] == 1){ X(qubits[i]); } // Se o bit é 1, o qubit passará a ser |1>
            if(AliceBase[i] == 1){ H(qubits[i]); } // Aplica H aleatoriamente sequindo o vetor de bits
        }
    }

    operation BobRead(qubits : Qubit[], n : Int, BobBase : Int[]) : Result[]{
        // Bob recebe a transmissão e aplica aleatoriamete H
        // Caso os dois tenham aplicado a H nos mesmos qubits, teram as mesmas medidas
        // Caso contrários os valores serão diferentes
        mutable MeasureBob = new Result[n];
        for(i in 0..n-1){
            if(BobBase[i] == 1){ H(qubits[i]); }
            set MeasureBob w/= i <- M(qubits[i]);
        }
        return MeasureBob;
    }

    // Operação do Protocolo BB84

    operation KeyBB84(AliceBits : Int[], AliceBase : Int[], BobBase : Int[], n : Int) : Int[]{
        // Operação principal que gera uma chave entre Alice e Bob

        using( qubits = Qubit[n] ) // Aloca n qubits em |0>
        {
            // Alice aplica X para setar seus Bits
            // E aplica H de acordo com a base aleatoriamente
            AliceApply(qubits, n, AliceBits, AliceBase);

            // TRANSMISSÃO DOS QUBITS PARA BOB ... (Ex: Fótons por Fibra Ótica em condições ideais)

            // Bob recebe os qubits e aplica a H aleatoriamente e faz a medida
            mutable BobM = BobRead(qubits, n, BobBase);
            mutable BobBits = ConvertResultinIntArray(BobM, n); //operação apenas para trocar o tipo Result em Inteiros (0 ou 1)

            // Reconciliacão de bases
            // Bob envia a Alice somente os seus bits de Base (por meio público), idem para Alice.
            // Assim, tanto Alice quanto Bob, podem comparar as bases de cada um, e usar como chave 
            // os Bits de Mensagem cujos bits de base utilizados são iguais, logo Alice e Bob terão uma chave idêntica.


            // Alice separa os bits de chave, comparando sua base com a gerada por Bob, idem para Bob
            mutable key = new Int[n];
            mutable t = 0;
            for(i in 0..n-1){
                if(AliceBase[i] == BobBase[i]){
                    set key w/= t <- AliceBits[i];
                    set t = t + 1;
                }
            }

            
            ResetAll(qubits);
            return key[0..t-1]; // Retorna a chave compartilhada

            // OBS:
            // Caso Eva interceptasse os qubits, qualquer tentativa de captura da informação, por parte
            // de Eva, implica em mudanças nesta informação, segundo a Teoria da Medida.

            // Existe um próximo passo que é a verificação se houve interceptação, onde Bob envia a Alice parte 
            // de sua chave, caso os valores sejam diferentes indica que ou houve espionagem ou erros nos instrumentos
            // invalidando a chave gerada e repetindo o processo.

        }

    }

}
