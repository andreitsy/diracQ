#!/usr/bin/env wolframscript
(* Test: Bosonic Creation and Annihilation Operators *)

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

Print["=== Test: Bosonic Operators ===\n"];

(* Basic commutation relations *)
test["[b[i], bdag[j]] = delta[i,j]",
    Commutator[b[i], b\[Dagger][j]],
    \[Delta][i, j]
];

test["[bdag[i], b[j]] = -delta[i,j]",
    Commutator[b\[Dagger][i], b[j]],
    -\[Delta][i, j]
];

test["[b[i], b[j]] = 0",
    Commutator[b[i], b[j]],
    0
];

test["[bdag[i], bdag[j]] = 0",
    Commutator[b\[Dagger][i], b\[Dagger][j]],
    0
];

(* With spin indices *)
test["[b[i,s1], bdag[j,s2]] = delta[s1,s2]*delta[i,j]",
    Commutator[b[i, \[Sigma]1], b\[Dagger][j, \[Sigma]2]],
    \[Delta][\[Sigma]1, \[Sigma]2] \[Delta][i, j]
];

test["[b[i,s1], b[j,s2]] = 0",
    Commutator[b[i, \[Sigma]1], b[j, \[Sigma]2]],
    0
];

(* AntiCommutator for bosons *)
test["{b[i], bdag[j]} = delta[i,j] + 2*bdag[j]**b[i]",
    AntiCommutator[b[i], b\[Dagger][j]],
    \[Delta][i, j] + 2 b\[Dagger][j] ** b[i]
];

(* StandardOrderQ: put creation operators left *)
test["StandardOrderQ[b[i]**bdag[j]] reorders",
    StandardOrderQ[b[i] ** b\[Dagger][j]],
    \[Delta][i, j] + b\[Dagger][j] ** b[i]
];

(* Number operator commutators *)
(* [nb[i], b[i]] = -b[i], [nb[i], bdag[i]] = bdag[i] *)
(* nb[i] = bdag[i]**b[i] *)
nb[i_] := b\[Dagger][i] ** b[i];
test["[nb[i], b[j]] using Commutator",
    Commutator[nb[i], b[j]],
    -\[Delta][i, j] b[i]
];

Print["\n=== Results: ", passed, " passed, ", failed, " failed ==="];
Exit[If[failed > 0, 1, 0]]
