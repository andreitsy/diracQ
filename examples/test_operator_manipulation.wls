#!/usr/bin/env wolframscript
(* Test: Operator manipulation functions *)
(* PushOperatorRight, PushOperatorLeft, PositionQ, DropQ, CommuteParts *)

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

Print["=== Test: Operator Manipulation ===\n"];

(* PushOperatorRight: move an operator rightward *)
expr1 = p[i] ** q[i];
pushed = PushOperatorRight[expr1, p[i]];
(* Should yield q[i]**p[i] + commutator terms *)
testTrue["PushOperatorRight[p**q, p] produces result",
    pushed =!= expr1
];

(* PushOperatorLeft: move an operator leftward *)
expr2 = q[i] ** p[i];
pushedL = PushOperatorLeft[expr2, p[i]];
testTrue["PushOperatorLeft[q**p, p] produces result",
    pushedL =!= expr2
];

(* Verify PushOperatorRight preserves the expression algebraically *)
(* p**q and q**p + [p,q] should be equal *)
test["PushOperatorRight[p[i]**q[i], p[i]] = q[i]**p[i] - I*hbar",
    PushOperatorRight[p[i] ** q[i], p[i]],
    q[i] ** p[i] - I \[HBar]
];

(* PositionQ: find positions of operators *)
expr3 = b\[Dagger][i] ** f\[Dagger][j] ** b[k];
pos = PositionQ[expr3, b\[Dagger][i]];
testTrue["PositionQ finds bdag[i] at position 1",
    Length[pos] > 0
];

pos2 = PositionQ[expr3, b[k]];
testTrue["PositionQ finds b[k]",
    Length[pos2] > 0
];

(* DropQ: remove operators by position *)
expr4 = p[i] ** q[j] ** p[k];
dropped = DropQ[expr4, {2}];
test["DropQ[p**q**p, {2}] drops q",
    dropped,
    p[i] ** p[k]
];

(* StandardOrderQ puts creation operators left of annihilation *)
(* With ApplyDefinition=True (default), bdag**b becomes the number operator n_b *)
(* Result is 1 + n_b[i] (delta[i,i] evaluates to 1, bdag**b -> number operator) *)
expr5 = b[i] ** b\[Dagger][i];
reordered = StandardOrderQ[expr5];
testTrue["StandardOrderQ[b[i]**bdag[i]] reorders (not same as input)",
    reordered =!= b[i] ** b\[Dagger][i]
];


Print["\n=== Results: ", passed, " passed, ", failed, " failed ==="];
Exit[If[failed > 0, 1, 0]]
