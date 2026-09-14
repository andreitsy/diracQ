# DiracQ

**DiracQ** is a Wolfram Language (Mathematica) package for symbolic manipulation of non-commuting quantum operators. It handles algebra involving bosonic/fermionic operators, canonical variables (q, p), angular momentum, Pauli matrices, Hubbard operators, and Dirac notation (Bra/Ket).

Updates:
- Compatibility with Mathematica 14.3 (also tested with Wolfram Engine 15.0)
- Support for wolframscript (command-line execution)
- Added tests using Claude

Original Authors:
- John Wright
- B. Sriram Shastry

This project is licensed under the GNU General Public License v2.0 (GPLv2), in accordance with the original distribution.

---

## Installation

Get the code by cloning the repository (or downloading it as a ZIP from GitHub):

```bash
git clone https://github.com/andreitsy/diracQ.git
```

Installing is optional: you can also load the package straight from the clone (see [Loading the Package](#loading-the-package)). Once installed, it loads from any notebook or script with ``Needs["DiracQ`"]``.

**In Mathematica**, following Wolfram's guide [How do I install packages?](https://support.wolfram.com/5648):

1. Choose **File > Install…**.
2. Under **Type of Item to install**, select **Package**.
3. Under **Source**, choose **From File…**, select `DiracQ/DiracQV1.m` in the clone, and click **Open**.
4. Enter `DiracQ` as the **Install Name** and click **OK**. It must be exactly `DiracQ`, the package's context name, for ``Needs["DiracQ`"]`` to work.

**From the command line** (for Wolfram Engine, which has no File menu), copy the `DiracQ` folder into your user `Applications` directory, which the kernel searches by default. Run this from the repository root:

```bash
wolframscript -code 'CopyDirectory["DiracQ", FileNameJoin[{$UserBaseDirectory, "Applications", "DiracQ"}]]'
```

On Windows, evaluate the `CopyDirectory[…]` expression in a Wolfram session instead, using the full path to the cloned `DiracQ` folder. To update an installed copy, delete it and copy again.

Then load the package in any notebook or script:

```wolfram
Needs["DiracQ`"]
```

The last character is a backtick (`` ` ``), not an apostrophe.

---

## Loading the Package

Without installing, load the package straight from the clone.

From a Mathematica notebook saved in the repository root:

```wolfram
SetDirectory[NotebookDirectory[]];
Get["DiracQ/DiracQV1.m"]
```

From a Wolfram script run in the repository root (the path is relative to the working directory):

```wolfram
Get["DiracQ/DiracQV1.m"]
```

Load DiracQ before using any of its symbols (`b`, `f`, `q`, `p`, …). If you get `::shdw` warnings such as "Symbol b appears in multiple contexts", those symbols were created before the package loaded: restart the kernel and load DiracQ first.

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

See `examples/example.wls` for a runnable version (run it from the repository root: `wolframscript -file examples/example.wls`).

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
| `test_density_matrix_ensemble.wls` | Two pure-state ensembles with the same density matrix |
| `test_kronecker_levi_civita.wls` | Kronecker delta and Levi-Civita symbols |
| `test_organize_humanize.wls` | Organize/Humanize round-trip conversion |
| `test_operator_manipulation.wls` | Operator reordering and simplification |
| `test_user_defined_operators.wls` | User-defined operators and custom commutation rules |

### Writing a New Test

The runner marks a test file as failed only when `wolframscript` exits with a non-zero status, so each script must count its failures and end with:

```wolfram
Exit[If[failed > 0, 1, 0]]
```

Test scripts live in `examples/` and the package in `DiracQ/`, so load the package relative to the script's parent directory:

```wolfram
scriptDir = If[$InputFileName =!= "", DirectoryName[$InputFileName], Directory[]];
Get[FileNameJoin[{ParentDirectory[scriptDir], "DiracQ", "DiracQV1.m"}]];
```

### Troubleshooting

If many tests fail at once with results such as `J[i, x]**J[i, y] - J[i, y]**J[i, x]`, check the top of the output for `Get::noopen`: the package didn't load. Mathematica's built-in `Commutator`, which DiracQ replaces when it loads, still evaluates without the package, so a failed load looks like wrong algebra rather than an error.

---

## References

- Wright, J. G. and Shastry, B. S. (2015). "DiracQ: A Package for Algebraic Manipulation of Non-Commuting Quantum Variables." *Journal of Open Research Software*, 3: e13. [doi:10.5334/jors.cb](https://doi.org/10.5334/jors.cb)
- Preprint: Wright, J. G. and Shastry, B. S. (2013). "DiracQ: A Quantum Many-Body Physics Package." [arXiv:1301.4494](https://arxiv.org/abs/1301.4494)
