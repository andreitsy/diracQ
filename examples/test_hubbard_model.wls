#!/usr/bin/env wolframscript
(* Test: Hubbard Model *)
(* Based on Examplebook Section (III) - Fermionic Hubbard model commutators *)

scriptDir = If[$InputFileName =!= "", DirectoryName[$InputFileName], Directory[]];
Get[FileNameJoin[{scriptDir, "DiracQ", "DiracQV1.m"}]];

passed = 0;
failed = 0;

test[name_, result_, expected_] := Module[{ok},
    ok = Simplify[result - expected] === 0;
    If[ok,
        passed++; Print["  PASS: ", name],
        failed++; Print["  FAIL: ", name];
        Print["    Expected: ", expected];
        Print["    Got:      ", result]
    ]
];

testTrue[name_, result_] := Module[{},
    If[result,
        passed++; Print["  PASS: ", name],
        failed++; Print["  FAIL: ", name];
        Print["    Expected True, got: ", result]
    ]
];

Print["=== Test: Hubbard Model ===\n"];

(* Define the Hubbard Hamiltonian *)
(* H = -Sum_ij_sigma t[i,j] fdag[i,sigma]**f[j,sigma] + U Sum_i nf[i,1]**nf[i,-1] *)
(* Using explicit spin values as recommended in the Examplebook *)
Clear[i, j, k, H];

(* Problem 1: [f[k,1], H] *)
(* This is the equation of motion for spin-up fermion *)
(* Use different indices from the Hamiltonian to avoid summation conflicts *)
H = -Sum[t[ii, jj] f\[Dagger][ii, \[Sigma]] ** f[jj, \[Sigma]], {ii, 1, 3}, {jj, 1, 3}, {\[Sigma], {1, -1}}] +
    U Sum[Subscript[n, f][ii, 1] ** Subscript[n, f][ii, -1], {ii, 1, 3}];

(* Commutator of f[k,1] with the Hubbard H *)
result1 = Commutator[f[k, 1], H];
testTrue["[f[k,1], H_Hubbard] produces nonzero result",
    result1 =!= 0
];

(* Test with a simpler 2-site Hubbard model *)
Clear[H2];
H2 = -t[1, 2] (f\[Dagger][1, 1] ** f[2, 1] + f\[Dagger][2, 1] ** f[1, 1]) +
     U Subscript[n, f][1, 1] ** Subscript[n, f][1, -1];

result2 = Commutator[f[k, 1], H2];
testTrue["[f[k,1], H_2site] produces result",
    result2 =!= 0
];

(* Vacuum properties with fermions *)
test["f[1,1]**Ket[Vacuum] = 0",
    f[1, 1] ** Ket[Vacuum],
    0
];

(* Applying ProductQ to H**fdag**fdag**Ket[Vacuum] *)
(* From Examplebook: ProductQ[H, fdag[1,1]**fdag[2,-1]**Ket[Vacuum]] *)
Clear[Hcluster];
Hcluster = -t (f\[Dagger][1, 1] ** f[2, 1] + f\[Dagger][2, 1] ** f[1, 1]);
state = f\[Dagger][1, 1] ** f\[Dagger][2, -1] ** Ket[Vacuum];
resultH = ProductQ[Hcluster, state];
testTrue["ProductQ[H, fdag**fdag**Ket[Vacuum]] is nonzero",
    resultH =!= 0
];

Print["\n=== Results: ", passed, " passed, ", failed, " failed ==="];
Exit[If[failed > 0, 1, 0]]
