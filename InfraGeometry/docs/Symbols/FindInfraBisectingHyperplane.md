---
Template: Symbol
Name: FindInfraBisectingHyperplane
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraBisectingHyperplane
Keywords: [perpendicular bisector, hyperplane, bisector, separating set, Euclid I.10]
SeeAlso: [InfraPlane, FindInfraMidpoint, EquidistanceQ, SeparatesQ, FindInfraEquidistantSet]
RelatedGuides: [Experimental]
---

## Usage

<code>[FindInfraBisectingHyperplane]()[*g*, *p1*, *p2*]</code> gives the perpendicular bisector $\{v : d(p_1,v) = d(p_2,v)\}$ as a sorted vertex list. A positional `{lo, hi}` widens it to the slab $lo \le d(p_1,v) - d(p_2,v) \le hi$.

<code>[FindInfraBisectingHyperplane]()[*g*, *p1*, *p2*, *n*]</code> gives a `List` of exactly *n* vertex sets or `$Failed`; `UpTo[n]` gives up to *n*; `All` gives all of them. Under the default `Properties -> {}` the slab is the one vertex set.

## Details & Options

The bisector of *p1* and *p2* is the set of vertices equidistant from both. It is the codimension-1 object of the metric: in the plane a line, here a vertex set.

**It is empty at odd distance.** If $d(p_1,p_2)$ is odd then no vertex can be equidistant from both, since the two distances would have to be equal halves of an odd number. Below, two vertices at distance 6 on a square grid have a 21-vertex bisector, while at distance 5 the bisector is empty. This is the same parity obstruction that makes [FindInfraMidpoint]() return the two central vertices of each geodesic at odd distance, seen one dimension up.

The `{lo, hi}` slab is the repair: widening to $-1 \le d(p_1,v) - d(p_2,v) \le 1$ catches the vertices that straddle the bisector and is non-empty at either parity.

Option `Properties` takes `{}` (default; the slab itself as one vertex set), `{"Separating"}` (inclusion-minimal subsets that disconnect *p1* from *p2*), or `{"Separating", "Connected"}`. Option `"NextVertexFunction"` is read only when `Properties` names a class to search: it sees the vertices that can be peeled next and gives the ones to try, in order. `Identity` (default) is the canonical peel, so the count-less call is one minimal subset, deterministic; `RandomSample` peels in random order under an ambient `SeedRandom`; `RandomSample[#, UpTo[n]] &` keeps at most *n* branches per node. The class is the same under every value. `"RandomGreedy"` peels in random order, seeded by an ambient `SeedRandom`; `"Pruning"` caps the removable vertices tried per layer, and the result is then minimal among the survivors.

Corresponding notions in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Proposition I.10, I.11 | Bisecting a segment, and erecting a perpendicular at a point on it. |
| Hilbert | Group III, congruence | The locus equidistant from two points, from segment congruence. |
| Tarski | Equidistance | The set of *v* with *v p1* congruent to *v p2*, directly in the primitive relation. |
| Birkhoff | Ruler postulate | The locus at equal ruler distance from two points. |

## Basic Examples

The bisector exists at even distance and is empty at odd — a parity obstruction, not a failure of the construction.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {even = First @ Sort @ Select[VertexList[g], GraphDistance[g, a, #] == 6 &]},
  {odd = First @ Sort @ Select[VertexList[g], GraphDistance[g, a, #] == 5 &]},
  <|"distance 6" -> Length @ FindInfraBisectingHyperplane[g, a, even],
    "distance 5" -> Length @ FindInfraBisectingHyperplane[g, a, odd]|>]
```

The bisector of two vertices at distance 6, drawn with its endpoints. It runs clear across the patch, separating one from the other.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = First @ Sort @ Select[VertexList[g], GraphDistance[g, a, #] == 6 &]},
  InfraSubstrateHighlight[g,
    {FindInfraBisectingHyperplane[g, a, b] -> $InfraPlaneColor,
     {a, b} -> $InfraPointColor},
    "PointSizeRange" -> 15,
    VertexShapeFunction -> ({AbsolutePointSize[2.2], Point[#]} &),
    ImageSize -> 340]]
```

## Properties and Relations

Every vertex of the bisector is equidistant from the two points, which is what [EquidistanceQ]() tests.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = First @ Sort @ Select[VertexList[g], GraphDistance[g, a, #] == 6 &]},
  AllTrue[FindInfraBisectingHyperplane[g, a, b], EquidistanceQ[g, a, #, b, #] &]]
```
