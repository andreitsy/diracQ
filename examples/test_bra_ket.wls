#!/usr/bin/env wolframscript
(* Test: Bra/Ket Dirac Notation *)
(* Based on Examplebook Section (III) Problem 3 *)

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

Print["=== Test: Bra/Ket Notation ===\n"];

(* Annihilation operator on vacuum gives 0 *)
test["f[i,sigma]**Ket[Vacuum] = 0",
    f[i, \[Sigma]] ** Ket[Vacuum],
    0
];

test["b[i]**Ket[Vacuum] = 0",
    b[i] ** Ket[Vacuum],
    0
];

(* Bra/Ket ordering - should not be reordered *)
testTrue["Ket**Bra stays ordered",
    StandardOrderQ[Ket[x] ** Bra[y]] === Ket[x] ** Bra[y]
];

(* Creation operators on vacuum produce states *)
state1 = f\[Dagger][1, 1] ** f\[Dagger][2, -1] ** Ket[Vacuum];
testTrue["fdag[1,1]**fdag[2,-1]**Ket[Vacuum] is nonzero",
    state1 =!= 0
];

(* ProductQ with Ket[Vacuum] *)
test["ProductQ[f[1,1], Ket[Vacuum]] = 0",
    ProductQ[f[1, 1], Ket[Vacuum]],
    0
];

(* Applying Hamiltonian to vacuum *)
(* Simple H with only fermionic operators applied to vacuum should give 0 *)
(* because all terms contain annihilation operators *)
Clear[H];
H = f\[Dagger][1, 1] ** f[2, 1];
test["ProductQ[fdag**f, Ket[Vacuum]] = 0 (annihilation kills vacuum)",
    ProductQ[H, Ket[Vacuum]],
    0
];

(* But applying H to a state created by creation operators *)
ketState = f\[Dagger][2, 1] ** Ket[Vacuum];
resultH = ProductQ[H, ketState];
testTrue["ProductQ[fdag[1,1]**f[2,1], fdag[2,1]**Ket[Vacuum]] is nonzero",
    resultH =!= 0
];

Print["\n=== Results: ", passed, " passed, ", failed, " failed ==="];
Exit[If[failed > 0, 1, 0]]
