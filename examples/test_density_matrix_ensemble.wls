#!/usr/bin/env wolframscript
(* Test: distinct pure-state ensembles can yield the same density matrix.
   rho1 = (3/4) |0><0| + (1/4) |1><1|
   rho2 = (1/2) |phi+><phi+| + (1/2) |phi-><phi-|
        |phi+-> = (sqrt[3]/2) |0> +- (1/2) |1>
*)

scriptDir = If[$InputFileName =!= "", DirectoryName[$InputFileName], Directory[]];
Get[FileNameJoin[{ParentDirectory[scriptDir], "DiracQ", "DiracQV1.m"}]];

(* Operator heads that must stay inside NonCommutativeMultiply arguments;
   anything else is treated as a c-number scalar and pulled out front. *)
opQ[expr_] := !FreeQ[expr, Bra | Ket | b | b\[Dagger] | f | f\[Dagger] |
                            q | p | J | X | \[Sigma]];

(* Distribute ** over Plus and pull scalar factors out of each ** argument
   so that outer products land in the {|0>,|1>} computational-basis dyads. *)
expandNC[expr_] := FixedPoint[
    Expand[# //. {
        NonCommutativeMultiply[a___, b_Plus, c___] :>
            (NonCommutativeMultiply[a, #, c] & /@ b),
        NonCommutativeMultiply[a___, Times[s_, op_], c___] /; !opQ[s] :>
            s NonCommutativeMultiply[a, op, c],
        NonCommutativeMultiply[a___, s_ /; !opQ[s] && s =!= 1, c___] :>
            s NonCommutativeMultiply[a, c]
    }] &,
    expr
];

passed = 0; failed = 0;
test[name_, lhs_, rhs_] := Module[{diff},
    diff = Simplify[expandNC[lhs] - expandNC[rhs]];
    If[diff === 0,
        passed++; Print["  PASS: ", name],
        failed++; Print["  FAIL: ", name, "  residual = ", diff]
    ]
];

Print["=== Test: density-matrix ensemble equivalence ===\n"];

(* Ensemble 1: classical mixture of |0> and |1> *)
rho1 = (3/4) Ket[0] ** Bra[0] + (1/4) Ket[1] ** Bra[1];

(* Ensemble 2: equal mixture of |phi+>, |phi-> *)
phiPlusKet  = (Sqrt[3]/2) Ket[0] + (1/2) Ket[1];
phiPlusBra  = (Sqrt[3]/2) Bra[0] + (1/2) Bra[1];
phiMinusKet = (Sqrt[3]/2) Ket[0] - (1/2) Ket[1];
phiMinusBra = (Sqrt[3]/2) Bra[0] - (1/2) Bra[1];

rho2 = (1/2) phiPlusKet ** phiPlusBra + (1/2) phiMinusKet ** phiMinusBra;

Print["  rho1 (expanded) = ", expandNC[rho1]];
Print["  rho2 (expanded) = ", expandNC[rho2]];

test["rho1 == rho2 (full operator equality)", rho1, rho2];

(* Cross-check: trace = 1 in both forms.
   Tr(rho) = sum_n <n|rho|n>; replace Bra[i]**Ket[j] -> KroneckerDelta[i,j]. *)
braketRule = NonCommutativeMultiply[h___, Bra[i_], Ket[j_], t___] :>
                 KroneckerDelta[i, j] NonCommutativeMultiply[h, t];

trace[rho_] := Module[{r, terms},
    terms = Sum[Bra[n] ** rho ** Ket[n], {n, 0, 1}];
    r = expandNC[terms] //. braketRule
        //. NonCommutativeMultiply[] -> 1;
    Simplify[r]
];

t1 = trace[rho1];
t2 = trace[rho2];
Print["  Tr[rho1] = ", t1, "    Tr[rho2] = ", t2];
If[t1 === 1 && t2 === 1,
    passed++; Print["  PASS: Tr[rho1] = Tr[rho2] = 1"],
    failed++; Print["  FAIL: traces are ", t1, ", ", t2]
];

Print["\n=== Results: ", passed, " passed, ", failed, " failed ==="];
Exit[If[failed > 0, 1, 0]]
