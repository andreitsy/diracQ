#!/usr/bin/env wolframscript
(* Test: Kronecker delta and Levi-Civita symbol *)

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

Print["=== Test: Kronecker Delta and Levi-Civita ===\n"];

(* Kronecker delta *)
test["delta[i,i] evaluates (identical args)",
    \[Delta][x, x],
    1
];

(* delta with Evaluation->Identical option *)
test["delta[1,2, Evaluation->Identical] = 0",
    \[Delta][1, 2, Evaluation -> Identical],
    0
];

test["delta[1,1, Evaluation->Identical] = 1",
    \[Delta][1, 1, Evaluation -> Identical],
    1
];

(* Levi-Civita symbol *)
test["epsilon[x,y,z] = 1",
    \[Epsilon][x, y, z],
    1
];

test["epsilon[y,z,x] = 1",
    \[Epsilon][y, z, x],
    1
];

test["epsilon[z,x,y] = 1",
    \[Epsilon][z, x, y],
    1
];

test["epsilon[x,z,y] = -1",
    \[Epsilon][x, z, y],
    -1
];

test["epsilon[y,x,z] = -1",
    \[Epsilon][y, x, z],
    -1
];

test["epsilon[z,y,x] = -1",
    \[Epsilon][z, y, x],
    -1
];

(* Repeated indices give zero *)
test["epsilon[x,x,y] = 0",
    \[Epsilon][x, x, y],
    0
];

test["epsilon[x,y,x] = 0",
    \[Epsilon][x, y, x],
    0
];

Print["\n=== Results: ", passed, " passed, ", failed, " failed ==="];
Exit[If[failed > 0, 1, 0]]
