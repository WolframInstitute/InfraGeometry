---
Template: Symbol
Name: RandomInfraLine
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraLine
Keywords: [line, inextensible shortest path, legacy]
SeeAlso: [RandomInfraInfiniteLine, InfraLine, InfraInfiniteLine, InfraLineQ]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraLine]()[*g*, *p*, *q*]</code> gives a random line through *p* and *q* in *g*, as a vertex list.

<code>[RandomInfraLine]()[*g*, *path*]</code> gives a random line that contains the shortest path *path*.

<code>[RandomInfraLine]()[*g*, *p*, *q*, *n*]</code> gives a list of *n* distinct lines through *p* and *q*.

## Details & Options

[RandomInfraLine]() is the older name of [RandomInfraInfiniteLine](). It takes the same arguments and options and gives the same result. A token <code>[InfraLine]()[*p*, *q*]</code> is read as <code>[InfraInfiniteLine]()[*p*, *q*]</code>.

A line is a shortest path that no edge prolongs at either end.

## Basic Examples

A random line through the centre and a vertex at distance 2, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
    {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraWalk[RandomInfraLine[g, p, q, RandomSeeding -> 1]], p, q}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Properties and Relations

The same draw as [RandomInfraInfiniteLine]():

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
  RandomInfraLine[g, p, q, 3, RandomSeeding -> 1] === RandomInfraInfiniteLine[g, p, q, 3, RandomSeeding -> 1]]
```
