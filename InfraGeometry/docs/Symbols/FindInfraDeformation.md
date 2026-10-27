---
Template: Symbol
Name: FindInfraDeformation
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraDeformation
Keywords: [deformation, certificate, simple path, homotopy, filled face, tube, excess length]
SeeAlso: [InfraDeformation, RandomInfraDeformation, FindInfraHomotopy, InfraMemberQ, HomotopyMoveTypes]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[FindInfraDeformation]()[*g*, *family*, *target*]</code> finds a certified chain of simple vertex-list paths from the reference of *family* to *target* using elementary filled-face moves.

## Details & Options

*family* is an [InfraDeformation]() object, and *target* must be one of its members. The result is a list of vertex lists, starting at the reference and ending at the target. Consecutive paths differ by a move across a declared face.

Every intermediate path is checked to be simple, to retain the ordered endpoints, to stay within the reference tube, and to have excess at most the upper excess bound. The number of moves is checked against `"MaxMoves"`.

The requested lower excess bound applies to the target. Intermediate paths may have smaller excess, including the reference at excess 0. Thus a family with exact target excess `{k}` can still have a certificate beginning at the reference.

| Option | Default | Meaning |
|---|---|---|
| `"NullHomotopicCycles"` | `{3, 4}` | lengths of filled cycles, each at least 3, or an explicit list of simple cyclic vertex lists |
| `"MaxMoves"` | `Infinity` | nonnegative integer bound on the number of elementary moves, or `Infinity` |
| `"MaxStates"` | `1000` | positive integer bound on the certificate search states |
| [Method]() | `Automatic` | `Automatic` or `"Exhaustive"` |

The face option is a list; for example, `{4}` permits square moves. An explicit face lists its vertices cyclically without repeating the first vertex at the end. The faces used by the search lie inside the tube.

The search calls [FindInfraHomotopy]() and validates the resulting chain. It is incomplete: a failed search, a reached search limit, or a proposed chain that violates an intermediate-path constraint leaves the original call unevaluated. This does not establish that no admissible chain exists. A target outside the family also leaves the call unevaluated.

The family's `"MaxStates"` bounds construction of its counting graph. The finder's separate `"MaxStates"` bounds the certificate search. Finding a certificate does not require enumerating the whole nearby-path family.

## Basic Examples

Replace an edge of a square by its other three sides:

```wl
SeedRandom[1];
With[{g = CycleGraph[4]},
  FindInfraDeformation[g, InfraDeformation[{1, 2}, UpTo[2]], {1, 4, 3, 2}]]
```

The target has exact excess 2, while the reference has excess 0:

```wl
SeedRandom[1];
With[{g = CycleGraph[4]},
  FindInfraDeformation[g, InfraDeformation[{1, 2}, {2}], {1, 4, 3, 2}]]
```

## Options

### NullHomotopicCycles

Declare the square explicitly and interchange its two shortest routes:

```wl
SeedRandom[1];
With[{g = CycleGraph[4]},
  FindInfraDeformation[g, InfraDeformation[{1, 2, 3}, {0}], {1, 4, 3},
    "NullHomotopicCycles" -> {{1, 2, 3, 4}}]]
```

## Possible Issues

A zero-move budget cannot supply this nonconstant chain. Display an unresolved call explicitly:

```wl
SeedRandom[1];
With[{g = CycleGraph[4]},
  Replace[FindInfraDeformation[g, InfraDeformation[{1, 2}, UpTo[2]], {1, 4, 3, 2}, "MaxMoves" -> 0],
    _FindInfraDeformation -> "Undecided"]]
```
