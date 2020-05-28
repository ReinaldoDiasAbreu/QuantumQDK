namespace qubit{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;

    // Manipulando estado do qubit, invertendo o estado
    operation Set(valor : Result, q : Qubit) : Unit{
        if(M(q) != valor){ // Medida do qubit sem resetar e comparo com o valor desejado
            X(q); // Inverto caso o valor for diferente do desejado
        }
    }
    // Alocação de um Qubit
    operation NewQubit() : Result{
        using (q = Qubit()) {
            H(q); // Aplicando a Hadamard para colocar o qubit em estado de Sobreposição
            // ....
            Set(One, q); // Aplicando operação para setar o qubit
            return MResetZ(q); // Retornando medida (Result) e resetando o qubit para |0> para desalocar
        }
    }
    
}
