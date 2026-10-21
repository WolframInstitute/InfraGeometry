---
Template: Symbol
Name: InfraEqualQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraEqualQ
Keywords: [equality, density, overlap, Jaccard, symbolic object]
SeeAlso: [InfraMeasurement, InfraIntersection, InfraUnion, InfraBall, InfraSegment]
RelatedGuides: [Experimental]
---

## Usage

<code>[InfraEqualQ]()[*g*, *a*, *b*]</code> tests whether the objects *a* and *b* are equal in *g*: whether their vertex densities share more mass than they do not.

## Details & Options

An object *A* has a vertex density *μ* and an object *B* a density *ν*, their `"VertexDensity"` in [InfraMeasurement](). The common mass is *|A ∩ B| = Σ min(μ(v), ν(v))*, the total masses are *|A|* and *|B|*, and *|A Δ B| = |A| + |B| − 2|A ∩ B|*.

The default test is *|A ∩ B| > |A Δ B|*: the weighted Jaccard index *|A ∩ B| / (|A| + |B| − |A ∩ B|)* is more than 1/2.

Equality of objects on a graph is a matter of degree, and the methods give four degrees, from the strictest:

| [Method]() | *a* and *b* are equal when |
|---|---|
| `"Multiset"` | the densities are the same |
| `"Set"` | the supports are the same |
| `"Diffuse"` | the default: *\|A ∩ B\| > \|A Δ B\|* |
| `"Overlap"` | the supports meet |

## Basic Examples

Two balls of radius 3 whose centres lie 1, 2 and 3 apart on the square grid. The first two pairs are equal, the third is not:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {balls = Table[InfraBall[RandomInfraPoint[g, InfraShell[c, k], RandomSeeding -> 1], 3], {k, 3}]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraBall[c, 3], b}, PlotLabel -> InfraEqualQ[g, InfraBall[c, 3], b]],
    {b, balls}]]
```

A segment and its reverse are equal under every method:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 1]},
  Table[m -> InfraEqualQ[g, InfraSegment[c, b], InfraSegment[b, c], Method -> m],
    {m, {"Multiset", "Set", "Diffuse", "Overlap"}}]]
```

## Options

### Method

A segment and one of its members. They overlap, but the member carries 5 of the 20 units of mass of the segment, and the segment covers 8 vertices to the member's 5:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 1]}, {path = RandomInfraSegment[g, c, b, RandomSeeding -> 1]},
  {methods = {"Multiset", "Set", "Diffuse", "Overlap"}},
  InfraSubstrateHighlight[g, {InfraSegment[c, b], path},
    PlotLabel -> Table[InfraEqualQ[g, InfraSegment[c, b], path, Method -> m], {m, methods}], ImageSize -> Medium]]
```

## Properties and Relations

The default test is a weighted Jaccard index above 1/2. Two balls of radius 3 whose centres lie 2 apart on the grid:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {ball = InfraBall[RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], 3]},
  {a = InfraMeasurement[g, InfraBall[c, 3], "VertexDensity"], b = InfraMeasurement[g, ball, "VertexDensity"]},
  {common = Total @ Merge[KeyIntersection[{a, b}], Min]},
  {common / (Total[a] + Total[b] - common), InfraEqualQ[g, InfraBall[c, 3], ball]}]
```
