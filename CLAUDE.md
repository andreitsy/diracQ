# CLAUDE.md

## Testing

The test runner (`./examples/run_all_tests.sh`) executes every `examples/test_*.wls` and marks a file FAIL when `wolframscript` exits non-zero, so a test script must exit non-zero on failure (existing tests end with `Exit[If[failed > 0, 1, 0]]`).

Test scripts live in `examples/` but the package is in `DiracQ/`, so load it relative to the script's parent directory:

```wolfram
scriptDir = If[$InputFileName =!= "", DirectoryName[$InputFileName], Directory[]];
Get[FileNameJoin[{ParentDirectory[scriptDir], "DiracQ", "DiracQV1.m"}]];
```

If the package fails to load, tests report wrong algebra rather than an obvious error: Mathematica has a built-in `Commutator` that returns `a**b - b**a`, which the package clears and redefines on load (see the compatibility fix at the top of `DiracQ/DiracQV1.m`). When many tests fail at once, check the output for `Get::noopen` first.
