---
Template: Symbol
Name: InfraWalkCrossingQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraWalkCrossingQ
Keywords: [crossing, transverse, double point, self-intersection, touching, walk, scale]
SeeAlso: [WalkSingularities, InfraGenericQ, InfraImmersedQ, InfraShell, InfraWalk]
---

## Usage

<code>[InfraWalkCrossingQ]()[*g*, *walk*, *v*, *r*]</code> gives `True` if the two passes of *walk* through the vertex *v* cross at scale *r*, and `False` if they only touch.

<code>[InfraWalkCrossingQ]()[*g*, *walk*, {*i*, *j*}, *r*]</code> tests the passes at the positions *i* and *j*.

## Details & Options

On a graph a double point has no tangent lines to compare, so the crossing is read at a distance. Each pass enters the ball *Bᵣ₋₁(v)*, leaves it, and runs on through the annulus of the vertices at distance *r* and *r* + 1 from *v*. The passes cross at scale *r* when each one cuts the annulus between the two ends of the other.

This is the linking of two pairs of points on a circle: on a surface-like substrate the passes cross when their ends alternate round *v*.

The test is `False` unless *v* is visited exactly twice, the two passes stay apart inside *Bᵣ₋₁(v)*, and the walk reaches distance *r* + 1 on both sides of both passes.

*walk* is a vertex list, a walk graph, a list of walk graphs, or a cycle graph, read round the cycle.

## Basic Examples

Two walks through the centre of the grid, each visiting it twice. The passes of the first cross; those of the second only touch:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {walks = {{25, 35, 45, 55, 65, 66, 56, 46, 45, 44, 43}, {25, 35, 45, 46, 47, 57, 67, 66, 65, 55, 45, 44, 43}}},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g, {InfraWalk[w], 45}, PlotLabel -> InfraWalkCrossingQ[g, w, 45, 1]], {w, walks}]]
```

The double visit is at the positions 3 and 9:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {walk = {25, 35, 45, 55, 65, 66, 56, 46, 45, 44, 43}},
  {WalkSingularities[walk]["SelfIntersections"], InfraWalkCrossingQ[g, walk, {3, 9}, 1]}]
```

## Possible Issues

The walk must run on to distance *r* + 1 from the vertex. The crossing walk ends at distance 2, so at scale 2 the test fails:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {walk = {25, 35, 45, 55, 65, 66, 56, 46, 45, 44, 43}},
  Table[InfraWalkCrossingQ[g, walk, 45, r], {r, 1, 2}]]
```

A vertex visited three times is not a double point, and the test fails:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  InfraWalkCrossingQ[g, {25, 35, 45, 55, 65, 66, 56, 46, 45, 44, 43, 33, 34, 35, 45, 55}, 45, 1]]
```
