#!/usr/bin/env wolframscript
(* Test: User-defined operators via AddOperator/DeleteOperator *)
(* Based on Introduction.pdf description of extensibility *)

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

Print["=== Test: User-Defined Operators ===\n"];

(* Add a custom operator *)
AddOperator[\[Alpha]];
testTrue["AddOperator adds to Operators list",
    MemberQ[Operators, \[Alpha]]
];

(* Define commutation relation for custom operator *)
CommutatorDefinition[\[Alpha][i_], \[Alpha][j_]] := \[Delta][i, j];

(* Test the custom commutator *)
test["Custom [alpha[i], alpha[j]] = delta[i,j]",
    Commutator[\[Alpha][i], \[Alpha][j]],
    \[Delta][i, j]
];

(* Organize recognizes custom operator as q-number *)
org = Organize[A \[Alpha][i]];
testTrue["Organize recognizes custom operator",
    Length[org[[1]][[4]]] > 0  (* q-number list is nonempty *)
];

(* Delete custom operator *)
DeleteOperator[\[Alpha]];
testTrue["DeleteOperator removes from Operators list",
    !MemberQ[Operators, \[Alpha]]
];

(* Add another operator and define anticommutation *)
AddOperator[\[Beta]];
AntiCommutatorDefinition[\[Beta][i_], \[Beta][j_]] := 2 \[Delta][i, j];

test["Custom {beta[i], beta[j]} = 2*delta[i,j]",
    AntiCommutator[\[Beta][i], \[Beta][j]],
    2 \[Delta][i, j]
];

DeleteOperator[\[Beta]];

Print["\n=== Results: ", passed, " passed, ", failed, " failed ==="];
Exit[If[failed > 0, 1, 0]]
