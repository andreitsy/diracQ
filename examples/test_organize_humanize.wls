#!/usr/bin/env wolframscript
(* Test: Organize/Humanize roundtrip and expression analysis functions *)

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

Print["=== Test: Organize/Humanize ===\n"];

(* Organize/Humanize roundtrip *)
expr1 = 3 q[i] ** p[j];
org1 = Organize[expr1];
hum1 = Humanize[org1];
test["Humanize[Organize[3*q[i]**p[j]]] roundtrip",
    hum1,
    expr1
];

(* More complex expression *)
(* Note: Humanize uses ** for c-number*operator products, so compare structurally *)
expr2 = A q[i] ** p[j] + B p[i] ** q[j];
org2 = Organize[expr2];
hum2 = Humanize[org2];
test["Humanize[Organize[A*q**p + B*p**q]] roundtrip",
    Simplify[hum2 /. NonCommutativeMultiply -> Times],
    Simplify[expr2 /. NonCommutativeMultiply -> Times]
];

(* Organize produces a list of 4-tuples *)
testTrue["Organize output is a list",
    ListQ[org1]
];

testTrue["Each organized term has 4 elements",
    Length[org1[[1]]] == 4
];

(* TakeQPart extracts operator parts *)
expr3 = A b\[Dagger][i] ** b[j] + B f\[Dagger][i] ** f[j];
qpart = TakeQPart[expr3];
testTrue["TakeQPart returns a list",
    ListQ[qpart]
];

testTrue["TakeQPart extracts 2 operator strings",
    Length[qpart] == 2
];

(* TakeCPart extracts c-number parts *)
cpart = TakeCPart[expr3];
testTrue["TakeCPart returns a list",
    ListQ[cpart]
];

(* FullOrganize = Organize + simplify in organized form *)
expr4 = b[i] ** b\[Dagger][i];
fullorg = FullOrganize[expr4];
testTrue["FullOrganize returns organized expression",
    ListQ[fullorg]
];

(* QCoefficient extracts coefficient of a specific operator string *)
expr5 = A b\[Dagger][1] ** b[1] + B b\[Dagger][2] ** b[2] + C b\[Dagger][1] ** b[2];
coeff = QCoefficient[expr5, b\[Dagger][1] ** b[1]];
test["QCoefficient extracts correct coefficient",
    coeff,
    A
];

Print["\n=== Results: ", passed, " passed, ", failed, " failed ==="];
Exit[If[failed > 0, 1, 0]]
