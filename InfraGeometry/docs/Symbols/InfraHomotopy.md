---
Template: Symbol
Name: InfraHomotopy
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraHomotopy
Keywords: [homotopy, paths, loops, elementary moves, filled cycles]
SeeAlso: [FindInfraHomotopy, HomotopicQ, NullHomotopicQ, HomotopyMoveTypes]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[InfraHomotopy]()[*a*, *b*]</code> is an inert specification of homotopy between the walks *a* and *b*.

## Details & Options

The token stores the two walks and the relation options `"NullHomotopicCycles"` and `"FreeHomotopy"`. It does not search for a homotopy or assert that one exists.

<code>[FindInfraHomotopy]()[*g*, [InfraHomotopy]()[*a*, *b*, *options*]]</code> searches for a witness on the substrate *g*. Pass computation limits and [Method]() to the finder.

| Relation option | Default | Meaning |
|---|---|---|
| `"NullHomotopicCycles"` | `{1, 2, 3}` | permit stutters, backtracks and triangle face moves; an integer *k* permits lengths 1 through *k*, or give explicit cycles |
| `"FreeHomotopy"` | `False` | fix path endpoints or the loop base point; `True` frees them |

A vertex list specifies an open walk. A directed cycle graph specifies a loop. Both inputs must have the same open or closed shape.

A computed homotopy remains a list of walk graphs. The token is a request, not a wrapper around a computed chain. [HomotopyMoveTypes]() reads the chain directly.

## Basic Examples

The two routes across a filled triangle:

```wl
With[{g = CycleGraph[3]}, {homotopy = InfraHomotopy[{1, 2, 3}, {1, 3}]},
  HomotopyMoveTypes[FindInfraHomotopy[g, homotopy]]]
```

Fill a square to connect its two routes:

```wl
With[{g = CycleGraph[4]},
  FindInfraHomotopy[g, InfraHomotopy[{1, 2, 3}, {1, 4, 3}, "NullHomotopicCycles" -> 4]]]
```
