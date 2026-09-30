---
Template: Symbol
Name: RandomInfraPoint
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraPoint
Keywords: [point, random vertex, distance]
SeeAlso: [InfraCenter, FindInfraPoint]
RelatedGuides: [Experimental]
---

## Usage

<code>[RandomInfraPoint]()[*graph*]</code> gives a uniformly random vertex of *graph*.

<code>[RandomInfraPoint]()[*graph*, *p*, *d*]</code> gives a uniformly random vertex at graph distance *d* from *p*.

## Details & Options

A point on a graph is a vertex, and that is what it returns. The three-argument form draws uniformly from the metric shell {*v* : *d(p, v)* = *d*}; it is <code>RandomChoice @ [FindInfraShell]()[*graph*, *p*, *d*]</code>.

`SeedRandom` in front reproduces the draw, as with every random construction in this paclet.

## Basic Examples

Five draws from the shell of radius 3 about the centre of a grid. Two of them fall on the same vertex.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {draws = Table[RandomInfraPoint[g, c, 3], 5]},
  InfraSubstrateHighlight[g, {FindInfraShell[g, c, 3], c, draws}, ImageSize -> 250]]
```

A random vertex of a grid, and a random vertex at distance 2 from its center.

```wl
With[
  {g = GridGraph[{5, 5}]},
  SeedRandom[1];
  RandomInfraPoint[g]
]
```

```wl
With[
  {g = GridGraph[{5, 5}]},
  {c = InfraCenter[g]},
  SeedRandom[1];
  RandomInfraPoint[g, c, 2]
]
```

## Properties and Relations

The draw at a distance is a random choice from the shell; the same seed gives the same vertex.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {SeedRandom[7]; RandomInfraPoint[g, 41, 3], SeedRandom[7]; RandomChoice @ FindInfraShell[g, 41, 3]}]
```
