---
Template: Symbol
Name: RandomInfraRay
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraRay
Keywords: [ray, half-line, direction, legacy]
SeeAlso: [RandomInfraHalfLine, InfraRay, InfraHalfLine, InfraRayQ]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraRay]()[*g*, *p*, *q*]</code> gives a random ray from *p* through *q* in *g*, as a vertex list.

<code>[RandomInfraRay]()[*g*, *p*, *q*, *n*]</code> gives a list of *n* distinct rays from *p* through *q*.

## Details & Options

[RandomInfraRay]() is the older name of [RandomInfraHalfLine](). It takes the same arguments and options and gives the same result. A token <code>[InfraRay]()[*p*, *q*]</code> is read as <code>[InfraHalfLine]()[*p*, *q*]</code>.

A ray from *p* through *q* is a shortest path from *p* through *q* that no edge prolongs at its far end.

## Basic Examples

A random ray from the centre through a vertex at distance 2, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
    {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraWalk[RandomInfraRay[g, p, q, RandomSeeding -> 1]], p, q}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Properties and Relations

The same draw as [RandomInfraHalfLine]():

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
  RandomInfraRay[g, p, q, 3, RandomSeeding -> 1] === RandomInfraHalfLine[g, p, q, 3, RandomSeeding -> 1]]
```
