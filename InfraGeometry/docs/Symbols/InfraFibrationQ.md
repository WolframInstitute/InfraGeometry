---
Template: Symbol
Name: InfraFibrationQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraFibrationQ
Keywords: [fibration, edge lifting, path lifting, predicate]
SeeAlso: [InfraFiberedGraph, InfraEdgeLiftMultiplicity, InfraAtMostOneEdgeLiftQ, InfraUniqueEdgeLiftingQ, InfraCoveringQ, InfraFiberBundleQ, RandomInfraConnection]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraFibrationQ]()[*fib*]</code> gives `True` if *fib* has the edge lifting property: every total vertex over *p* has a neighbour over every base neighbour of *p*.

## Details & Options

The condition is *m(x, q) ≥ 1* for every total vertex *x* and every base neighbour *q* of *π(x)*, with *m* the multiplicity of [InfraEdgeLiftMultiplicity]().

Then every base walk lifts to a walk from any vertex over its start, one step at a time. The lift need not be unique.

Fibers may have different sizes, and an edge may have several lifts at a vertex. Equal sizes and lifting together still need not give a complete connection.

Stronger conditions:

| Predicate | Adds |
|---|---|
| [InfraUniqueEdgeLiftingQ]() | exactly one lift of each base edge at each vertex |
| [InfraCoveringQ]() | unique lifting and no vertical edges |
| [InfraFiberBundleQ]() | unique lifting, isomorphic fibers, matchings that preserve the fibers' edges |

The empty fibered graph is a fibration. A list of objects gives `True` when every member is a fibration; the empty list gives `False`.

## Basic Examples

The double cover of the cycle of length 8 is a fibration. Deleting one edge breaks it: its two endpoints, drawn, lose their lift of a base edge:

```wl
With[{fib = InfraFiberedSubstrate["CycleDoubleCover", "Small"]}, {total = InfraTotalSpace[fib]},
  {cut = First @ EdgeList[total]}, {broken = InfraFiberedGraph[EdgeDelete[total, cut], InfraProjection[fib]]},
  InfraFiberedGraphHighlight[broken, List @@ cut, PlotLabel -> {InfraFibrationQ[fib], InfraFibrationQ[broken]},
    ImageSize -> Medium]]
```

Projected to its columns, the full grid graph is a fibration. The square grid is not: the vertices on its top and bottom rim have no neighbour in the next columns:

```wl
Table[
  InfraFibrationQ @ InfraFiberedGraph[g, AssociationThread[VertexList[g], Round @ GraphEmbedding[g][[All, 1]]]],
  {g, {GridGraph[{8, 8}], InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}}]
```

## Scope

Every entry of the catalogue is a fibration:

```wl
AllTrue[InfraFiberedSubstrate[All], InfraFibrationQ @ InfraFiberedSubstrate[#, "Small"] &]
```

## Properties and Relations

A branched fibration has fibers of sizes 1 and 2. It is a fibration, but not a fiber bundle:

```wl
With[{fib = InfraFiberedSubstrate["BranchedCycleFibration", "Small"]},
  InfraFiberedGraphHighlight[fib, PlotLabel -> {InfraFibrationQ[fib], InfraFiberBundleQ[fib]},
    ImageSize -> Medium]]
```

## Possible Issues

Equal fiber sizes and lifting do not give a complete connection. The vertices 1 and 2 over `"p"` both lift only to 4, so no perfect matching exists:

```wl
With[{fib = InfraFiberedGraph[Graph[Range[6], {1 <-> 4, 2 <-> 4, 3 <-> 5, 3 <-> 6}],
    <|1 -> "p", 2 -> "p", 3 -> "p", 4 -> "q", 5 -> "q", 6 -> "q"|>]},
  {InfraFibrationQ[fib], InfraEqualFiberSizesQ[fib], RandomInfraConnection[fib, All]}]
```
