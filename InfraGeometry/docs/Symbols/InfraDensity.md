---
Template: Symbol
Name: InfraDensity
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraDensity
Keywords: [density, occupation, marginal, counting measure, multiset, support]
SeeAlso: [InfraMeasurement, RandomInfraSegment, InfraSubstrateHighlight, RandomInfraSegment, InfraIntersection]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraDensity]()[*graph*, *x*]</code> gives the marginal of the shape *x* to the vertex set of *graph*, an `Association` of vertices *v* to masses *m*, with respect to the counting measure.

## Details & Options

Definition: the density of a shape is the number of times it covers each vertex: once for a vertex, once per occurrence in a vertex list, and once per walk through the vertex for a family of walks.

It reads every shape:

| *x* | <code>[InfraDensity]()[*graph*, *x*]</code> |
|---|---|
| a vertex *v* | `<\|v -> 1\|>` |
| a vertex list | its `Counts` |
| a density `<\|v -> m\|>` | itself |
| a walk graph, a DAG, or a `List` of walks | the number of walks through each vertex |

The result is key-sorted, so two densities built by different routes compare with `SameQ`.

It is the one coercion of the API. `Keys` demotes a density to its support, and `Counts` promotes a vertex list to a density.

A Euclidean head is not a shape here: <code>[InfraDensity]()[*graph*, [InfraSegment]()[*p*, *q*]]</code> is `<|InfraSegment[p, q] -> 1|>`. The density of a head is <code>[InfraMeasurement]()[*graph*, *obj*, "VertexDensity"]</code>, and it equals the density of the head's members.

It is the raw marginal and takes no options. The two normalisations are one division away: `d / Max[d]` is the occupation in [0, 1], and `d / Total[d]` is the distribution summing to 1.

## Basic Examples

The shortest paths from the centre to a vertex four steps away, as a density: both end points are covered by every path, the middle vertices by fewer. Each vertex is drawn as large as its mass.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[a, 4]])},
  {density = InfraDensity[g, RandomInfraSegment[g, a, b, All]]},
  {InfraSubstrateHighlight[g, {density}, "PointSizeRange" -> {4, 16}], density}]
```

A vertex, a vertex list with a repeat, and a density.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = First @ AdjacencyList[g, a]},
  {densities = {InfraDensity[g, a], InfraDensity[g, {b, a, b}], InfraDensity[g, <|b -> 2, a -> 1|>]}},
  {GraphicsRow @ Table[InfraSubstrateHighlight[g, {density}, "PointSizeRange" -> {4, 16}], {density, densities}], densities}]
```

The two normalisations: by the heaviest mass, which the drawing uses, and by the total mass, a probability.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[a, 4]])},
  {density = InfraDensity[g, RandomInfraSegment[g, a, b, All]]},
  {InfraSubstrateHighlight[g, {density / Max[density]}, "PointSizeRange" -> {4, 16}],
   Max[density / Max[density]], Total[density / Total[density]]}]
```

## Properties and Relations

The density of a head's members is the head's `"VertexDensity"`, and so is the density of the head's graph.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[a, 4]])},
  {seg = InfraSegment[a, b]},
  {InfraSubstrateHighlight[g, {InfraDensity[g, Replace[ seg, { token_InfraPoint :> RandomInfraPoint[ g, token, All ], token_InfraSegment :> RandomInfraSegment[ g, token, All ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, All ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraCircle :> RandomInfraCircle[ g, token, All ], token_InfraArc :> RandomInfraArc[ g, token, All ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, All ], token_InfraPlane :> RandomInfraPlane[ g, token, All ], token_InfraBall :> RandomInfraBall[ g, token, All ], token_InfraShell :> RandomInfraShell[ g, token, All ], token_InfraSphere :> RandomInfraSphere[ g, token, All ], token_InfraTube :> RandomInfraTube[ g, token, All ], token_InfraCylinder :> RandomInfraCylinder[ g, token, All ], token_InfraCone :> RandomInfraCone[ g, token, All ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token, All ], token_InfraBallHull :> RandomInfraBallHull[ g, token, All ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token, All ], token_InfraQuadric :> RandomInfraQuadric[ g, token, All ], token_InfraWalk :> RandomInfraWalk[ g, token, All ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, All ], token_InfraEllipse :> RandomInfraEllipse[ g, token, All ], token_InfraIntersection :> RandomInfraIntersection[ g, token, All ], token_InfraUnion :> RandomInfraUnion[ g, token, All ], token_InfraRay :> RandomInfraHalfLine[ g, token, All ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, All ] } ]]}, "PointSizeRange" -> {4, 16}],
   InfraDensity[g, Replace[ seg, { token_InfraPoint :> RandomInfraPoint[ g, token, All ], token_InfraSegment :> RandomInfraSegment[ g, token, All ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, All ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraCircle :> RandomInfraCircle[ g, token, All ], token_InfraArc :> RandomInfraArc[ g, token, All ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, All ], token_InfraPlane :> RandomInfraPlane[ g, token, All ], token_InfraBall :> RandomInfraBall[ g, token, All ], token_InfraShell :> RandomInfraShell[ g, token, All ], token_InfraSphere :> RandomInfraSphere[ g, token, All ], token_InfraTube :> RandomInfraTube[ g, token, All ], token_InfraCylinder :> RandomInfraCylinder[ g, token, All ], token_InfraCone :> RandomInfraCone[ g, token, All ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token, All ], token_InfraBallHull :> RandomInfraBallHull[ g, token, All ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token, All ], token_InfraQuadric :> RandomInfraQuadric[ g, token, All ], token_InfraWalk :> RandomInfraWalk[ g, token, All ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, All ], token_InfraEllipse :> RandomInfraEllipse[ g, token, All ], token_InfraIntersection :> RandomInfraIntersection[ g, token, All ], token_InfraUnion :> RandomInfraUnion[ g, token, All ], token_InfraRay :> RandomInfraHalfLine[ g, token, All ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, All ] } ]] === InfraMeasurement[g, seg, "VertexDensity"],
   InfraDensity[g, InfraMeasurement[g, seg, "Graph"]] === InfraMeasurement[g, seg, "VertexDensity"]}]
```

A head itself is not read: the call stays unevaluated, while the drawing reads the head's densities.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[a, 4]])},
  {seg = InfraSegment[a, b]},
  {InfraSubstrateHighlight[g, {seg}], InfraDensity[g, seg]}]
```

[InfraMeasurement]() with `"Midpoint"` returns a density: the number of shortest paths centred at each vertex.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[a, 4]])},
  {midpoint = InfraMeasurement[g, InfraSegment[a, b], "Midpoint"]},
  {InfraSubstrateHighlight[g, {InfraSegment[a, b], midpoint}], midpoint}]
```
