---
Template: Symbol
Name: WalkSingularities
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/WalkSingularities
Keywords: [singularity, self-intersection, self-tangency, cusp, double point, walk, immersed curve]
SeeAlso: [InfraImmersedQ, InfraGenericQ, InfraWalkCrossingQ, InfraWalkQ, InfraWalk, RandomInfraWalk]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[WalkSingularities]()[*walk*]</code> gives the self-intersections, self-tangencies and cusps of *walk*, as positions along it.

## Details & Options

For a walk *v₁*, …, *vₘ* the result is an association:

| Key | Value |
|---|---|
| `"SelfIntersections"` | the groups of two or more positions *i* with the same vertex *vᵢ* |
| `"SelfTangencies"` | the pairs of position intervals that run along the same arc of at least one edge, the second reversed when the arc is run backwards |
| `"Cusps"` | the blocks *i − k*, …, *i + k* about each turning point *i*, where *vᵢ₋ₜ = vᵢ₊ₜ* for *t ≤ k* |

These are the singularities of a curve: a double point, a stretch where the curve runs along itself, a point where it reverses. A walk without cusps is immersed ([InfraImmersedQ]()); one that also has no tangencies and only double points away from its ends is generic ([InfraGenericQ]()).

*walk* is a vertex list, a walk graph, or a list of walk graphs. A cycle graph is a closed walk, read round the cycle; its positions are taken modulo its length. A vertex list is always open: a list that ends where it starts counts its ends as a self-intersection.

The graph is not needed: the singularities are read off the vertex sequence.

## Basic Examples

A walk that crosses itself, one that runs back along a stretch, and one that turns back, each from the marked vertex. The labels name the kinds of singularity found. A stretch run twice and a cusp revisit vertices, so they come with self-intersections:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {walks = {{25, 35, 45, 55, 65, 66, 56, 46, 45, 44, 43}, {43, 44, 45, 46, 47, 57, 56, 46, 45, 44, 34},
     {43, 44, 45, 46, 47, 46, 36}}},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g, {InfraWalk[w], First @ w},
      PlotLabel -> Keys @ DeleteCases[WalkSingularities[w], {}]],
    {w, walks}]]
```

The first walk passes the vertex 45 at positions 3 and 9 and has nothing else:

```wl
WalkSingularities[{25, 35, 45, 55, 65, 66, 56, 46, 45, 44, 43}]
```

The second runs along 44, 45, 46 at positions 2 to 4 and back along it at positions 10 to 8:

```wl
WalkSingularities[{43, 44, 45, 46, 47, 57, 56, 46, 45, 44, 34}]
```

## Scope

A walk graph, as [RandomInfraWalk]() returns. A random walk of 6 edges from the centre steps back at once:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {walk = RandomInfraWalk[g, 45, {6}, RandomSeeding -> 1]},
  {Last /@ VertexList[walk], WalkSingularities[walk]}]
```

A closed walk is a directed cycle on the position pairs {*i*, *v*}, read round the cycle. The figure eight through 45 passes it twice as a closed walk, three times as the open list that starts and ends there:

```wl
With[{seq = {45, 46, 56, 55, 45, 44, 34, 35}},
  {closed = Graph[DirectedEdge @@@ Partition[MapIndexed[{First @ #2, #1} &, seq], 2, 1, 1]]},
  {WalkSingularities[closed]["SelfIntersections"], WalkSingularities[Append[seq, 45]]["SelfIntersections"]}]
```

## Properties and Relations

A walk is immersed exactly when it has no cusp. On 50 random walks of 6 edges:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {walks = RandomInfraWalk[g, 45, {6}, 50, RandomSeeding -> 2]},
  AllTrue[walks, w |-> InfraImmersedQ[g, w] === (WalkSingularities[w]["Cusps"] === {})]]
```
