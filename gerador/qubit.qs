namespace RandomQuantum{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;

    operation NumberGenerator() : Result{
        using (q = Qubit()) { // Aloca um qubit no estado |0>
            H(q); // Coloca o qubit em superposição
            return MResetZ(q); // Mede, retorna a medida e reinicia o qubit para |0>
        }
    }
}
