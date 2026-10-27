---
Template: Symbol
Name: InfraDeformationSize
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraDeformationSize
Keywords: [deformation, homotopy, walk distance, prefix, suffix, edit]
SeeAlso: [SelectInfraWalk, FindInfraHomotopy, RandomInfraSegment, InfraWalk]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[InfraDeformationSize]()[*ref*, *walk*]</code> gives the number of edges of the walk *ref* that *walk* replaces.

<code>[InfraDeformationSize]()[*ref*, {*w1*, *w2*, …}]</code> gives the number for each walk *wi*.

## Details & Options

For *ref* with *m* edges, let *p* be the number of edges of the longest common prefix of *ref* and *walk*, and *s* the number of edges of the longest common suffix. The deformation size is *max(0, m − p − s)*: the edges of *ref* strictly between the part the two walks share at the start and the part they share at the end.

It counts edges of *ref*, not of *walk*, so it is not symmetric.

Walks can be vertex lists or walk graphs. There is no graph argument.

The size measures where two walks differ along *ref*, not how far apart they run: two walks that leave *ref* at the same place and rejoin it at the same place have the same size.

## Basic Examples

Two shortest paths from the centre to a point at distance 6. The label is how many edges of the first the second replaces:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {members = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 6], RandomSeeding -> 2], All]},
    InfraSubstrateHighlight[g, {InfraWalk[First @ members], InfraWalk[Last @ members]},
      PlotLabel -> InfraDeformationSize[First @ members, Last @ members]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

How many of the 20 shortest paths on the grid replace 0, 2, 3, … edges of the first one:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {members = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 6], RandomSeeding -> 2], All]},
  KeySort @ Counts @ InfraDeformationSize[First @ members, PathGraph[#, DirectedEdges -> True] & /@ members]]
```

## Properties and Relations

Replacing one vertex in the middle of a walk replaces the two edges at it:

```wl
InfraDeformationSize[{1, 2, 3, 4, 5}, {1, 2, 7, 4, 5}]
```

The size is not symmetric. It counts the edges of the first walk:

```wl
{InfraDeformationSize[{1, 2, 3, 4, 5}, {1, 9, 5}], InfraDeformationSize[{1, 9, 5}, {1, 2, 3, 4, 5}]}
```
