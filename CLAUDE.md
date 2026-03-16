# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

DiracQ is a Wolfram Language (Mathematica) package for symbolic manipulation of non-commuting quantum operators. It handles algebra involving bosonic/fermionic operators, canonical variables (q, p), angular momentum, Pauli matrices, Hubbard operators, and Dirac notation (Bra/Ket). Authors: John Wright and B. Sriram Shastry (UCSC, 2013/2015). Licensed under GNU GPL v2.

## Running

```wolfram
(* From Mathematica notebook *)
SetDirectory[NotebookDirectory[]];
Get["DiracQV1.m"]

(* From command line *)
wolframscript -file example.wls
```

The package has no external dependencies beyond the Wolfram Language standard library. There is no build step, test suite, or linter.

## Architecture

**Single-file package**: All code lives in `DiracQ/DiracQV1.m` (~2150 lines), structured as a standard Wolfram `BeginPackage`/`EndPackage` module with ~50 public symbols.

### Dual Representation System

The core architectural idea is a dual representation for operator expressions:

- **Standard form**: Normal Wolfram expressions using `NonCommutativeMultiply` (`**`)
- **Organized form**: Internal 4-tuple `{coefficient, sum_indices, c_numbers, q_numbers}` that separates scalar parts from operator parts

`Organize` converts standard → internal. `Humanize` converts internal → standard. Most heavy manipulation happens in the organized form.

### Key Internal Functions

- `commute`/`anticommute` — Recursively evaluate commutation relations using registered definitions
- `QOrderedQ` — Defines canonical ordering: Bra/Ket → b† → b → f† → f → J → X → σ → p → q. Creation operators sort left of annihilation (same species). Fermionic swaps introduce −1 signs.
- `sumreduce` — Collapses Kronecker deltas with summation indices
- `combine` — Merges two organized terms (union of sum indices, product of coefficients, join of operator lists)
- `fermitest` — Returns True for fermionic operators (f, f†), False otherwise

### Operator Definition System

99 predefined commutator/anticommutator rules covering: fermions ({f[i], f†[j]} = δ_ij), bosons ([b[i], b†[j]] = δ_ij), canonical pairs ([q, p] = iℏδ), angular momentum ([Jα, Jβ] = iℏε_αβγ Jγ), Hubbard X operators, and Pauli matrices. Users extend via `AddOperator`, `CommutatorDefinition`, `AntiCommutatorDefinition`, and `OperatorProduct`.

### Key Options

- `ApplyDefinition` — Whether to apply product definitions (default: True)
- `StandardReordering` — Place commutator results in standard order (default: True)
- `Decomposition` — `CommutatorRule` vs `AntiCommutatorRule` for composite commutators

## File Layout

- `DiracQ/DiracQV1.m` — The entire package implementation
- `DiracQ/Kernel/init.m` — Package initialization for Mathematica's package loader
- `example.wls` — Executable wolframscript demonstrating basic harmonic oscillator algebra
- `docs_pdf/` — PDFs and Mathematica notebooks (tutorials, examples, glossary, published paper)
