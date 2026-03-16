#!/usr/bin/env wolframscript
(* Test: Angular Momentum Operators *)

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

Print["=== Test: Angular Momentum ===\n"];

(* [J_x, J_y] = I*hbar**J_z (and cyclic) *)
(* Note: result uses NonCommutativeMultiply since J is an operator *)
test["[J[i,x], J[i,y]] = I*hbar**J[i,z]",
    Commutator[J[i, x], J[i, y]],
    I \[HBar] J[i, z]
];

test["[J[i,y], J[i,z]] = I*hbar*J[i,x]",
    Commutator[J[i, y], J[i, z]],
    I \[HBar] J[i, x]
];

test["[J[i,z], J[i,x]] = I*hbar*J[i,y]",
    Commutator[J[i, z], J[i, x]],
    I \[HBar] J[i, y]
];

(* Same-component commutator vanishes *)
test["[J[i,x], J[i,x]] = 0",
    Commutator[J[i, x], J[i, x]],
    0
];

(* Different sites: result is I*hbar*delta[i,j]**J[i,z] *)
(* This is correct -- the package uses delta functions rather than assuming i!=j *)
test["[J[i,x], J[j,y]] = I*hbar*delta[i,j]*J[i,z]",
    Commutator[J[i, x], J[j, y]],
    I \[HBar] \[Delta][i, j] J[i, z]
];

Print["\n=== Results: ", passed, " passed, ", failed, " failed ==="];
Exit[If[failed > 0, 1, 0]]
