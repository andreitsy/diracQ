# DiracQ

**DiracQ** is a Wolfram Language (Mathematica) package for symbolic manipulation of non-commuting quantum operators. It handles algebra involving bosonic/fermionic operators, canonical variables (q, p), angular momentum, Pauli matrices, Hubbard operators, and Dirac notation (Bra/Ket).

Updates:
- Compatibility with Mathematica 14.3
- Support for wolframscript (command-line execution)
- Added tests using Claude

Original Authors:
- John Wright
- B. Sriram Shastry

This project is licensed under the GNU General Public License v2.0 (GPLv2), in accordance with the original distribution.

---

## Loading the Package

From a Mathematica notebook:

```wolfram
SetDirectory[NotebookDirectory[]];
Get["DiracQ/DiracQV1.m"]
```

From a Wolfram script:

```wolfram
Get["DiracQ/DiracQV1.m"]
```

---

## Quick Example

```wolfram
Get["DiracQ/DiracQV1.m"]

$Assumptions = {m > 0, \[Omega] > 0, \[HBar] > 0};

a[i_] := Sqrt[m \[Omega] / (2 \[HBar])] q[i] + I p[i]/Sqrt[2 \[HBar] m \[Omega]]
adag[i_] := Sqrt[m \[Omega] / (2 \[HBar])] q[i] - I p[i]/Sqrt[2 \[HBar] m \[Omega]]
n[i_] := adag[i] ** a[i]

(* [a, a†] = 1 *)
FullSimplify[SimplifyQ[Commutator[a[i], adag[i]]]]

(* [n, a] = -a *)
FullSimplify[SimplifyQ[Commutator[n[i], a[i]] + a[i]]]
```

See `examples/example.wls` for a runnable version.

---

## Running Tests

### Prerequisites

- [Wolfram Engine](https://www.wolfram.com/engine/) or Mathematica 14.3+ installed
- `wolframscript` available on your `PATH`

### Run All Tests

From the repository root:

```bash
./examples/run_all_tests.sh
```

Or equivalently:

```bash
cd examples && ./run_all_tests.sh
```

This discovers and runs every `examples/test_*.wls` file, then prints a pass/fail summary.

### Run a Single Test

```bash
wolframscript -file examples/test_bosonic_operators.wls
```

### Available Test Suites

| File | Coverage |
|------|----------|
| `test_bosonic_operators.wls` | Bosonic creation/annihilation commutation relations |
| `test_fermionic_operators.wls` | Fermionic anticommutation relations |
| `test_canonical_pairs.wls` | [q, p] canonical commutation relations |
| `test_angular_momentum.wls` | Angular momentum algebra |
| `test_pauli_matrices.wls` | Pauli matrix identities |
| `test_harmonic_oscillator.wls` | Harmonic oscillator operator algebra |
| `test_hubbard_model.wls` | Hubbard X-operator relations |
| `test_bra_ket.wls` | Dirac Bra/Ket notation |
| `test_kronecker_levi_civita.wls` | Kronecker delta and Levi-Civita symbols |
| `test_organize_humanize.wls` | Organize/Humanize round-trip conversion |
| `test_operator_manipulation.wls` | Operator reordering and simplification |
| `test_user_defined_operators.wls` | User-defined operators and custom commutation rules |

---

## References

- Wright, J. and Shastry, B.S., "DiracQ: A Quantum Algebra Package for Mathematica", [JORS paper](docs_pdf/DiracQ-Paper-JORS-92-781-1-PB.pdf)
