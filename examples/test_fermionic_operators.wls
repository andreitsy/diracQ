#!/usr/bin/env wolframscript
(* Test: Fermionic Creation and Annihilation Operators *)
(* Based on Examplebook Section (III) Fermions at work *)

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

Print["=== Test: Fermionic Operators ===\n"];

(* Basic anticommutation relations *)
test["{f[i], fdag[j]} = delta[i,j]",
    AntiCommutator[f[i], f\[Dagger][j]],
    \[Delta][i, j]
];

test["{f[i], f[j]} = 0",
    AntiCommutator[f[i], f[j]],
    0
];

test["{fdag[i], fdag[j]} = 0",
    AntiCommutator[f\[Dagger][i], f\[Dagger][j]],
    0
];

(* Commutation relations for fermions *)
test["[f[i], fdag[j]] = delta[i,j] - 2*fdag[j]**f[i]",
    Commutator[f[i], f\[Dagger][j]],
    \[Delta][i, j] - 2 f\[Dagger][j] ** f[i]
];

(* With spin indices *)
test["{f[i,s1], fdag[j,s2]} = delta[s1,s2]*delta[i,j]",
    AntiCommutator[f[i, \[Sigma]1], f\[Dagger][j, \[Sigma]2]],
    \[Delta][\[Sigma]1, \[Sigma]2] \[Delta][i, j]
];

test["{f[i,s1], f[j,s2]} = 0",
    AntiCommutator[f[i, \[Sigma]1], f[j, \[Sigma]2]],
    0
];

(* Pauli exclusion: f[i]**f[i] = 0 *)
(* This is encoded through the anticommutation relation {f,f}=0 *)
test["{f[i,1], f[j,1]} = 0 (same spin)",
    AntiCommutator[f[i, 1], f[j, 1]],
    0
];

(* StandardOrderQ: fermionic reordering introduces sign *)
test["StandardOrderQ[f[i]**fdag[j]] reorders with sign",
    StandardOrderQ[f[i] ** f\[Dagger][j]],
    \[Delta][i, j] - f\[Dagger][j] ** f[i]
];

(* Vacuum annihilation: f**Ket[Vacuum] = 0 *)
test["f[i,sigma]**Ket[Vacuum] = 0",
    f[i, \[Sigma]] ** Ket[Vacuum],
    0
];

(* ProductQ[H, Ket[Vacuum]] for simple H = 0 since all terms end with annihilation *)
test["ProductQ with Ket[Vacuum] annihilation",
    ProductQ[f[1, 1], Ket[Vacuum]],
    0
];

Print["\n=== Results: ", passed, " passed, ", failed, " failed ==="];
Exit[If[failed > 0, 1, 0]]
