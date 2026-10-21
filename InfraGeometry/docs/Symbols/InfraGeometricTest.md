---
Template: Symbol
Name: InfraGeometricTest
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraGeometricTest
SeeAlso: [InfraGeometricAssertion, InfraMemberQ, InfraDistance, InfraScene]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraGeometricTest]()[*g*, *assertion*]</code> decides the [InfraGeometricAssertion]() *assertion* on the graph *g*, giving `True` or `False`.

## Details & Options

The graph is finite, simple, undirected and unweighted.

| Property | Gives `True` when |
|---|---|
| `"Distinct"` | the vertices are pairwise different; the empty list and a single vertex pass |
| `"Member"` | the vertex lies where the density of the object is not zero |
| `"EqualDistance"` | the two distances are equal and finite |

Two infinite distances are not equal for `"EqualDistance"`.

An unknown property, an object that is not a vertex, or an unbound symbol leaves the test unevaluated.

## Basic Examples

The centre of the square grid lies on a segment from it, and a vertex at distance 4 does not lie in the ball of radius 3:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
  {InfraGeometricTest[g, InfraGeometricAssertion[{a, InfraSegment[a, b]}, "Member"]],
   InfraGeometricTest[g, InfraGeometricAssertion[{b, InfraBall[a, 3]}, "Member"]]}]
```

Each vertex of the bisector of *a* and *b* is as far from *a* as from *b*:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
  Table[InfraGeometricTest[g, InfraGeometricAssertion[{{a, v}, {b, v}}, "EqualDistance"]], {v, FindInfraBisectingHyperplane[g, a, b]}]]
```

## Scope

`"Distinct"` on lists of vertices:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {a = First @ GraphCenter[g]},
  InfraGeometricTest[g, InfraGeometricAssertion[#, "Distinct"]] & /@ {{a, a + 1}, {a, a}, {a}, {}}]
```

## Possible Issues

A symbol that is not a vertex leaves the test unevaluated:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {a = First @ GraphCenter[g]},
  Head @ InfraGeometricTest[g, InfraGeometricAssertion[{a, x}, "Distinct"]]]
```
