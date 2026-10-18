---
Template: Symbol
Name: InfraSupport
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSupport
Keywords: [support, region, ball, shell, tube, segment, vertex set, reader]
SeeAlso: [InfraMeasurement, InfraSubgraph, RandomInfraPoint, InfraBall, InfraShell, InfraSegment]
RelatedGuides: [EuclideanInfrageometry, RiemannianInfrageometry]
---

## Usage

<code>[InfraSupport]()[*graph*, *obj*]</code> gives the support of the head *obj* on *graph*: the sorted vertex list its members pass through.

<code>[InfraSupport]()[*graph*, {*obj_1*, *obj_2*, …}]</code> gives the list of supports.

## Details & Options

Definition: the support of a construction head is the union of the vertex sets of its members, the vertices of positive `"VertexDensity"`. It is <code>Keys @ [InfraMeasurement]()[*graph*, *obj*, "VertexDensity"]</code>.

A region head ([InfraBall](), [InfraShell](), [InfraTube](), [InfraCylinder](), [InfraCone](), [InfraSolidOfRevolution](), [InfraBallHull](), [InfraConvexHull](), [InfraQuadric]()) has exactly one member, its vertex set, so its support *is* the region and there is no `RandomInfra...` sampler for it: [InfraSupport]() reads the set and [RandomInfraPoint]() draws vertices of it. A chain family ([InfraSegment](), [InfraHalfLine](), [InfraInfiniteLine](), [InfraCircle](), [InfraArc]()) has many members and its support is the union of all of them, the metric interval of a segment for instance; one member is the matching `RandomInfra...` sampler.

[InfraSupport]() takes no options and draws no random numbers. A head without a `"VertexDensity"` reading on *graph* leaves the call unevaluated. [InfraSubgraph]() is the subgraph induced on the support.

## Basic Examples

The ball of radius 2 about the centre on the discretized plane, the square grid and the hexagonal tiling, its support drawn as a region and counted.

```wl
SeedRandom[1];
Row[Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {support = InfraSupport[g, InfraBall[First @ GraphCenter[g], 2]]},
    Labeled[InfraSubstrateHighlight[g, {support -> StandardGreen}], Length @ support]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]]
```

The support of a segment is its metric interval, the union of all shortest paths; one shortest path is a member.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {p = RandomInfraPoint[g, InfraShell[c, 4]]},
  {seg = InfraSegment[c, p]},
  {InfraSubstrateHighlight[g, {InfraSupport[g, seg] -> StandardGreen, RandomInfraSegment[g, seg] -> StandardBlue}],
   Length @ InfraSupport[g, seg], InfraMeasurement[g, seg, "Cardinality"]}]
```

A list of heads gives a list of supports.

```wl
With[
  {g = GridGraph[{5, 5}]},
  InfraSupport[g, {InfraBall[13, 1], InfraShell[13, 2], InfraSegment[1, 5]}]]
```

## Properties and Relations

The support is the key set of the vertex density, and a region is its own support.

```wl
With[
  {g = GridGraph[{5, 5}]},
  {ball = InfraBall[13, 2]},
  {InfraSupport[g, ball] === Keys @ InfraMeasurement[g, ball, "VertexDensity"],
   InfraMeasurement[g, ball, "Cardinality"],
   InfraSubgraph[g, ball] === Subgraph[g, InfraSupport[g, ball]]}]
```

The support of a chain family is the union of its members.

```wl
With[
  {g = GridGraph[{4, 4}]},
  {seg = InfraSegment[1, 16]},
  InfraSupport[g, seg] === Union @@ RandomInfraSegment[g, seg, All]]
```

Random points of a region are [RandomInfraPoint](), not a sampler of the region.

```wl
SeedRandom[1];
With[
  {g = GridGraph[{7, 7}]},
  {ball = InfraBall[25, 2]},
  SubsetQ[InfraSupport[g, ball], RandomInfraPoint[g, ball, 3]]]
```
