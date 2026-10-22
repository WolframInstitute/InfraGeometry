---
Template: Symbol
Name: FindInfraPerpendicular
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraPerpendicular
Keywords: [perpendicular, Euclid I.12, foot, right angle, isosceles, radius]
SeeAlso: [InfraPerpendicularQ, RandomInfraParallel, RandomInfraInfiniteLine, FindClosestInfraPoint, InfraAngle]
RelatedGuides: [Experimental]
---

## Usage

<code>[FindInfraPerpendicular]()[*g*, *line*, *p*]</code> gives the lines through the vertex *p* perpendicular to *line*, as a list of directed path graphs.

<code>[FindInfraPerpendicular]()[*g*, *line*, *p*, *n*]</code> gives *n* of them.

## Details & Options

The default construction is Euclid I.12. Two vertices *a*, *b* of the line at the same distance from *p* are the base of an isosceles triangle; the midpoint of the base along the line is a foot *f*. When one vertex of the line is nearest to *p* it is a foot too: the circle about *p* through it touches the line there. The perpendiculars are the longest lines through a foot *f* and *p*; a shorter line through *f* and *p* is not returned.

When *p* lies on the line there is no foot apart from *p*, and the result is `{}`. Erecting a perpendicular at a point of the line is Euclid I.11.

A point off a line has many perpendiculars. They need not satisfy [InfraPerpendicularQ](), which tests a projection condition instead.

| Option | Default | Values |
|---|---|---|
| [Method]() | `"Metric"` | `"Metric"`, Euclid's construction; `"Projection"`, `"Coordinate"`, `"Arclength"`, `"Alexandrov"`, the lines through *p* that [InfraPerpendicularQ]() accepts with that method |
| `"Radius"` | `All` | *r*: find the feet and the longest lines inside the ball of radius *r* about *p* |

The count *n* can be `n`, `UpTo[n]` or `All`, the default. Fewer than *n* perpendiculars give `{}`, and `All` with a single perpendicular gives that graph rather than a list.

Corresponding notions in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Proposition I.12 | To draw a perpendicular to a given line from a point not on it. |
| Euclid | Postulate 4 | All right angles are equal to one another. |
| Hilbert | Group III | Right angles come from angle congruence. |
| Tarski | (derived) | Perpendicularity is defined from equidistance. |

## Basic Examples

The perpendiculars to a line through the centre of the square mesh from a vertex at distance 2 from it:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1]},
  {line = RandomInfraInfiniteLine[g, c, q, RandomSeeding -> 1]},
  {p = RandomInfraPoint[g, InfraShell[line, 2], RandomSeeding -> 1]},
  {perpendiculars = FindInfraPerpendicular[g, line, p]},
  InfraSubstrateHighlight[g, {line, perpendiculars, p}, PlotLabel -> Length[perpendiculars], ImageSize -> Medium]]
```

A point on the line has no perpendicular from it:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1]},
  {line = RandomInfraInfiniteLine[g, c, q, RandomSeeding -> 1]},
  FindInfraPerpendicular[g, line, c]]
```

## Options

### Radius

On the square grid a point at distance 2 from a line has 548 perpendiculars. Built inside the balls of radius 2, 3 and 4 about the point, there are 0, 6 and 12. The ball of radius 2 holds the two nearest vertices of the line but not the midpoint of the base they span, so it holds no foot:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1]},
  {line = RandomInfraInfiniteLine[g, c, q, RandomSeeding -> 1]},
  {p = RandomInfraPoint[g, InfraShell[line, 2], RandomSeeding -> 1]},
  Append[Table[r -> Length @ FindInfraPerpendicular[g, line, p, UpTo[1000], "Radius" -> r], {r, 2, 4}],
    All -> Length @ FindInfraPerpendicular[g, line, p]]]
```

When the ball meets the line only in its nearest vertex, that vertex is the foot. On the 5 × 5 grid the ball of radius 2 about the centre 13 meets the side 1, …, 5 only in 3, and every perpendicular passes through 3:

```wl
With[{g = GridGraph[{5, 5}]}, {perpendiculars = FindInfraPerpendicular[g, Range[5], 13, UpTo[10], "Radius" -> 2]},
  InfraSubstrateHighlight[g, {Range[5], perpendiculars, 13}, PlotLabel -> Length[perpendiculars], ImageSize -> Medium]]
```

## Properties and Relations

Every perpendicular is a line, an inextensible shortest path ([InfraInfiniteLineQ]()):

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1]},
  {line = RandomInfraInfiniteLine[g, c, q, RandomSeeding -> 1]},
  {p = RandomInfraPoint[g, InfraShell[line, 2], RandomSeeding -> 1]},
  InfraInfiniteLineQ[g, FindInfraPerpendicular[g, line, p]]]
```

## Possible Issues

A perpendicular can run along the line. On the square grid one of the 548 perpendiculars above shares 8 vertices with the line:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1]},
  {line = RandomInfraInfiniteLine[g, c, q, RandomSeeding -> 1]},
  {p = RandomInfraPoint[g, InfraShell[line, 2], RandomSeeding -> 1]},
  {shared = Length @ Intersection[VertexList[#], line] &},
  {widest = First @ MaximalBy[FindInfraPerpendicular[g, line, p], shared]},
  InfraSubstrateHighlight[g, {line, widest, p}, PlotLabel -> shared[widest], ImageSize -> Medium]]
```
