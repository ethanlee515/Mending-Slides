Inductive raw_code (A : choiceType) : Type :=
| ret (x : A)
| opr (o : opsig) (x : src o) (k : tgt o → raw_code A)
| getr (l : Location) (k : l → raw_code A)
| putr (l : Location) (v : l) (k : raw_code A)
| sampler (op : Op) (k : Arit op → raw_code A).
