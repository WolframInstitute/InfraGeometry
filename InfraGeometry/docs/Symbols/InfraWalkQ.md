---
Template: Symbol
Name: InfraWalkQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraWalkQ
Keywords: [walk, path, closed walk, adjacency, test]
SeeAlso: [InfraWalk, RandomInfraWalk, InfraGeodesicQ, InfraSegmentQ, InfraImmersedQ, WalkSingularities]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[InfraWalkQ]()[*g*, *walk*]</code> gives `True` if *walk* is a walk in *g*: each vertex adjacent to the next.

## Details & Options

A walk is a vertex sequence *v₀*, *v₁*, …, *vₖ* with *k ≥ 1* and *vᵢ₋₁vᵢ* an edge of *g* for every *i*. Vertices and edges may repeat.

*walk* is a vertex list, a walk graph as [RandomInfraWalk]() returns, a list of walk graphs, a directed acyclic graph, or a cycle graph. A cycle graph is a closed walk and is read round the cycle. A directed acyclic graph passes when every path from a source to a sink passes.

A single vertex is not a walk.

In an [InfraScene](), `InfraWalkQ[w]` is the assertion that *w* is a walk.

## Basic Examples

A step back is allowed; a jump is not:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {InfraWalkQ[g, {45, 46, 45}], InfraWalkQ[g, {45, 47}]}]
```

A random walk of 8 edges from the centre, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {walk = RandomInfraWalk[g, c, {8}, RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {walk, c}, PlotLabel -> InfraWalkQ[g, walk]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Scope

The graph of a segment passes, since every path from its source to its sink is a walk:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  InfraWalkQ[g, InfraMeasurement[g, InfraSegment[45, 67], "Graph"]]]
```

As an assertion in a scene. The second point is any neighbour of the first, 4 on the grid:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, pB}, {pA == InfraPoint[c], pB == InfraPoint[], InfraWalkQ[{pA, pB}]}]},
  {ends = InfraSceneInstance[#, pB] & /@ RandomInfraSceneInstance[scene, g, All]},
  InfraSubstrateHighlight[g, {ends, c}, PlotLabel -> Length[ends], ImageSize -> Medium]]
```

## Possible Issues

A single vertex is not a walk:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, InfraWalkQ[g, {45}]]
```
