#!/usr/bin/env wolframscript
(* Test: Pauli Spin Matrices *)
(* Based on DiracQ paper example: Zeeman Hamiltonian H = A*sigma_x + B*sigma_y + C*sigma_z *)
(* ProductQ[H,H] should give A^2 + B^2 + C^2 *)

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

Print["=== Test: Pauli Matrices ===\n"];

(* Pauli algebra: sigma_i^2 = 1 (identity) *)
(* {sigma[i,alpha], sigma[i,beta]} = 0 for alpha != beta *)
(* [sigma[i,alpha], sigma[i,beta]] = 2*I*epsilon[alpha,beta,gamma]*sigma[i,gamma] *)

(* Zeeman Hamiltonian example from the paper *)
(* Use cA, cB, cC to avoid conflict with Mathematica's protected C symbol *)
Clear[H];
H = cA \[Sigma][i, x] + cB \[Sigma][i, y] + cC \[Sigma][i, z];

(* H^2 = (A^2 + B^2 + C^2) * identity *)
(* ProductQ[H, H] should simplify to A^2 + B^2 + C^2 *)
result = ProductQ[H, H];
test["ProductQ[H,H] = cA^2 + cB^2 + cC^2 (Zeeman)",
    result,
    cA^2 + cB^2 + cC^2
];

(* Basic Pauli commutators *)
(* [sigma_x, sigma_y] = 2*I*sigma_z *)
test["[sigma[i,x], sigma[i,y]] = 2I*sigma[i,z]",
    Commutator[\[Sigma][i, x], \[Sigma][i, y]],
    2 I \[Sigma][i, z]
];

test["[sigma[i,y], sigma[i,z]] = 2I*sigma[i,x]",
    Commutator[\[Sigma][i, y], \[Sigma][i, z]],
    2 I \[Sigma][i, x]
];

test["[sigma[i,z], sigma[i,x]] = 2I*sigma[i,y]",
    Commutator[\[Sigma][i, z], \[Sigma][i, x]],
    2 I \[Sigma][i, y]
];

(* Same-component commutator vanishes *)
test["[sigma[i,x], sigma[i,x]] = 0",
    Commutator[\[Sigma][i, x], \[Sigma][i, x]],
    0
];

(* Different site operators: result includes delta[i,j] factor *)
test["[sigma[i,x], sigma[j,y]] = 2I*delta[i,j]**sigma[i,z]",
    Commutator[\[Sigma][i, x], \[Sigma][j, y]],
    2 I \[Delta][i, j] \[Sigma][i, z]
];

(* Anticommutation: {sigma_x, sigma_y} = 0 *)
test["{sigma[i,x], sigma[i,y]} = 0",
    AntiCommutator[\[Sigma][i, x], \[Sigma][i, y]],
    0
];

(* {sigma_x, sigma_x} = 2 (sigma^2 = identity) *)
test["{sigma[i,x], sigma[i,x]} = 2",
    AntiCommutator[\[Sigma][i, x], \[Sigma][i, x]],
    2
];

Print["\n=== Results: ", passed, " passed, ", failed, " failed ==="];
Exit[If[failed > 0, 1, 0]]
