---
Template: Symbol
Name: InfraFibrationQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraFibrationQ
Keywords: [edge lifting, fibration, path lifting]
SeeAlso: [InfraFiberedGraph, InfraEdgeLiftMultiplicity, InfraAtMostOneEdgeLiftQ, InfraUniqueEdgeLiftingQ, InfraFiberBundleQ, RandomInfraConnection]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraFibrationQ]()[*fib*]</code> tests the edge lifting property: every total vertex over *p* has a neighbour over every base neighbour of *p*.

## Details & Options

- The base is the reconstructed [InfraBaseSpace]().
- This is the project's lift-existence convention. It does not impose the unique incoming-edge lifting used by some standard graph-fibration definitions.
- Equivalently, every entry of [InfraEdgeLiftMultiplicity]() is positive. The projection is locally surjective on transverse neighbourhoods.
- The condition allows unequal fibers and multiple lifts. It does not guarantee a perfect matching or a complete connection.
- [InfraUniqueEdgeLiftingQ]() adds uniqueness. [InfraFiberBundleQ]() also requires common fiber graphs and preservation of their adjacency.
- The empty fibered graph satisfies the condition vacuously. Unsupported inputs remain unevaluated.
- A nonempty list is tested by conjunction. An empty result list is False and does not establish existence.

## Basic Examples

The double cover of a cycle is a fibration. Deleting one total edge breaks it: its two endpoints, drawn, lose their lift of a base edge.

```wl
SeedRandom[ 7 ];
With[
  {fib = InfraFiberedSubstrate["CycleDoubleCover", "Small"]},
  {total = InfraTotalSpace[fib]},
  {cut = First @ EdgeList[total]},
  {broken = InfraFiberedGraph[EdgeDelete[total, cut], InfraProjection[fib]]},
  {InfraSubstrateHighlight[InfraTotalSpace[broken], {InfraMeasurement[total, List @@ cut, "VertexDensity" ]}], InfraFibrationQ[fib], InfraFibrationQ[broken]}]
```

Every entry of the catalogue is a fibration.

```wl
SeedRandom[ 7 ];
AllTrue[InfraFiberedSubstrate[All], InfraFibrationQ @ InfraFiberedSubstrate[#, "Small"] &]
```

## Properties and Relations

A branched fibration has fibers of different sizes and is still a fibration.

```wl
SeedRandom[ 7 ];
With[
  {fib = InfraFiberedSubstrate["BranchedCycleFibration", "Small"]},
  {InfraTotalSpace[fib], InfraFibrationQ[fib], InfraFiberBundleQ[fib]}]
```

## Possible Issues

Even equal fiber sizes and lift existence do not guarantee a complete connection.
The first two source vertices here can only reach the same target vertex.

```wl
SeedRandom[ 7 ];
With[ { fib = InfraFiberedGraph[ Graph[ Range[ 6 ],
    UndirectedEdge @@@ { { 1, 4 }, { 2, 4 }, { 3, 5 }, { 3, 6 } } ],
    <| 1 -> "p", 2 -> "p", 3 -> "p", 4 -> "q", 5 -> "q", 6 -> "q" |> ] },
  { InfraFiberedGraphHighlight[ fib ], InfraFibrationQ[ fib ], RandomInfraConnection[ fib, All ] } ]
```
