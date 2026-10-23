---
Template: Symbol
Name: ConcatenateInfraWalk
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/ConcatenateInfraWalk
Keywords: [concatenation, join, walk, path composition, polyline]
SeeAlso: [InfraWalk, InfraSegment, RandomInfraSegment, FindInfraPolylineSubdivision, RandomInfraWalk]
---

## Usage

<code>[ConcatenateInfraWalk]()[*w1*, *w2*]</code> gives the walks that run along *w1* and then along *w2*.

<code>[ConcatenateInfraWalk]()[*w1*, *w2*, *n*]</code> gives *n* of them.

## Details & Options

The concatenation of walks *u = (u₁, …, uₖ)* and *w = (w₁, …, wₘ)* with *uₖ = w₁* is *u · w = (u₁, …, uₖ, w₂, …, wₘ)*. Walks that do not meet end to start give nothing.

Each argument can be one walk or a family: a vertex list, a walk graph, a list of vertex lists or a list of walk graphs. Every walk of the first family is joined to every walk of the second that starts where it ends. The result is a list of directed path graphs.

The concatenation of two shortest paths need not be a shortest path. Joining the members of two segments at a common point gives the members of the polyline through the three points.

The count *n* can be `n`, `UpTo[n]` or `All`, the default. Fewer than *n* walks give `{}`.

## Basic Examples

The members of the segment from *a* to the centre joined to those from the centre to *b*. They are the members of the polyline <code>[InfraSegment]()[*a*, *c*, *b*]</code>, and the label compares the two counts:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {a = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 2], b = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 4]},
    {walks = ConcatenateInfraWalk[RandomInfraSegment[g, a, c, All], RandomInfraSegment[g, c, b, All]]},
    InfraSubstrateHighlight[g, {walks, a, c, b},
      PlotLabel -> {Length[walks], InfraMeasurement[g, InfraSegment[a, c, b], "Cardinality"]}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

Two vertex lists that meet end to start, read back as a vertex sequence:

```wl
Last /@ VertexList[First @ ConcatenateInfraWalk[{1, 2, 3}, {3, 4, 5}]]
```

## Properties and Relations

The order matters. The second walk must start where the first ends:

```wl
{Length @ ConcatenateInfraWalk[{1, 2, 3}, {3, 4}], ConcatenateInfraWalk[{3, 4}, {1, 2, 3}]}
```

The members of a segment of length 3 joined to their reverses go out and come back, along walks of length 6:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {members = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 1], All]},
  Union[EdgeCount /@ ConcatenateInfraWalk[members, Reverse /@ members]]]
```

## Possible Issues

A vertex of a resulting walk graph is a pair {*i*, *v*} of a position and a vertex, so a walk can come back to a vertex. There is no graph argument, and the walks are not checked against a graph:

```wl
VertexList @ First @ ConcatenateInfraWalk[{1, 2}, {2, 1}]
```
