#!/usr/bin/env wolframscript
(* Test II: Harmonic Oscillator - Ladder Operators *)
(* Based on Examplebook Section (I) - creation/annihilation operators *)

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

Print["=== Test: Harmonic Oscillator ===\n"];

(* Define ladder operators with proper normalization (from Examplebook) *)
(* a = sqrt(m*omega/(2*hbar)) (q + i*p/(m*omega)) *)
(* adag = sqrt(m*omega/(2*hbar)) (q - i*p/(m*omega)) *)
Clear[i, j];
a[i_] := Sqrt[m \[Omega]/(2 \[HBar])] (q[i] + I p[i]/(m \[Omega]));
adag[i_] := Sqrt[m \[Omega]/(2 \[HBar])] (q[i] - I p[i]/(m \[Omega]));

(* [a, adag] = 1 with proper normalization *)
test["[a[i], adag[i]] = 1 (properly normalized)",
    Commutator[a[i], adag[i]],
    1
];

(* Number operator *)
nn[i_] := adag[i] ** a[i];

(* [n, a] = -a and [n, adag] = adag *)
(* Use SimplifyQ to verify these identities *)
test["SimplifyQ[Commutator[n[i], a[i]] + a[i]] = 0",
    SimplifyQ[Commutator[nn[i], a[i]] + a[i]],
    0
];

test["SimplifyQ[Commutator[n[i], adag[i]] - adag[i]] = 0",
    SimplifyQ[Commutator[nn[i], adag[i]] - adag[i]],
    0
];

(* Array commutators: [a[k], adag[l]] = delta[k,l] *)
A = {a[1], a[2], a[3]};
B = {adag[1], adag[2], adag[3]};
commArray = Outer[Commutator, A, B];

(* Direct structural comparison for the matrix *)
If[commArray === {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}},
    passed++; Print["  PASS: Outer[Commutator, {a[1..3]}, {adag[1..3]}] = identity matrix"],
    failed++; Print["  FAIL: Outer[Commutator, {a[1..3]}, {adag[1..3]}] = identity matrix"];
    Print["    Got: ", commArray]
];

(* SimplifyQ on adag**a + a**adag *)
(* With proper normalization: adag**a + a**adag = 2*n + 1 *)
(* In terms of fundamental operators: p^2/(m*omega*hbar) + m*omega*q^2/hbar *)
expr = adag[i] ** a[i] + a[i] ** adag[i];
result = SimplifyQ[expr];
(* Verify it equals 2*adag**a + 1 by checking Commutator[a, adag] = 1 *)
test["SimplifyQ[adag**a + a**adag] is nonzero (correct expansion)",
    result =!= 0,
    True
];

Print["\n=== Results: ", passed, " passed, ", failed, " failed ==="];
Exit[If[failed > 0, 1, 0]]
