#!/usr/bin/env wolframscript
(* Test I: Canonical Position and Momentum Operators *)
(* Based on Examplebook Section (I) Canonical Pairs *)

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

Print["=== Test: Canonical Pairs ===\n"];

(* Basic commutation relations *)
test["[p[j], q[i]] = -I hbar delta[i,j]",
    Commutator[p[j], q[i]],
    -I \[HBar] \[Delta][i, j]
];

test["[q[i], p[j]] = I hbar delta[i,j]",
    Commutator[q[i], p[j]],
    I \[HBar] \[Delta][i, j]
];

(* Multi-index commutation relations *)
test["[p[j,alpha], q[i,beta]] = -I hbar delta[i,j] delta[alpha,beta]",
    Commutator[p[j, \[Alpha]], q[i, \[Beta]]],
    -I \[HBar] \[Delta][i, j] \[Delta][\[Alpha], \[Beta]]
];

(* Same-type commutators vanish *)
test["[q[i], q[j]] = 0",
    Commutator[q[i], q[j]],
    0
];

test["[p[i], p[j]] = 0",
    Commutator[p[i], p[j]],
    0
];

(* Specific direction: [p[j,y], q[i,y]] = -I hbar delta[i,j] *)
test["[p[j,y], q[i,y]] = -I hbar delta[i,j]",
    Commutator[p[j, y], q[i, y]],
    -I \[HBar] \[Delta][i, j]
];

(* Bare p and q (no indices) are treated as c-numbers *)
test["[p, q] (no indices) = 0 (c-numbers)",
    Commutator[p, q],
    0
];

(* Harmonic oscillator Hamiltonian: [H, q[i]] and [H, p[i]] *)
Clear[i, j];
H = p[i]^2/(2 m) + m \[Omega]^2/2 q[i]^2;

test["[H, q[i]] = -I hbar/m p[i]",
    Commutator[H, q[i]],
    -I (\[HBar]/m) p[i]
];

test["[H, p[i]] = I m omega^2 hbar q[i]",
    Commutator[H, p[i]],
    I m \[Omega]^2 \[HBar] q[i]
];

(* StandardOrderQ: reorder q**p *)
test["StandardOrderQ[q[i]**p[i]] puts p left",
    StandardOrderQ[q[i] ** p[i]],
    I \[HBar] + p[i] ** q[i]
];

Print["\n=== Results: ", passed, " passed, ", failed, " failed ==="];
Exit[If[failed > 0, 1, 0]]
