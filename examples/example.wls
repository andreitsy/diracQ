#!/usr/bin/env wolframscript
SetDirectory[Directory[]];

Get["DiracQ/DiracQV1.m"]

$Assumptions = {m > 0, \[Omega] > 0, \[HBar] > 0};

a[i_] := Sqrt[m \[Omega] / (2 \[HBar])] q[i] + I p[i]/Sqrt[2 \[HBar] m \[Omega]]
adag[i_] := Sqrt[m \[Omega]/ (2 \[HBar])] q[i] - I p[i]/Sqrt[2 \[HBar] m \[Omega]]
n[i_] := adag[i] ** a[i]

Print[FullSimplify[SimplifyQ[Commutator[a[i], adag[i]]]]]
Print[FullSimplify[SimplifyQ[Commutator[n[i], a[i]] + a[i]]]]
Print[FullSimplify[SimplifyQ[Commutator[n[i], adag[i]] - adag[i]]]]

