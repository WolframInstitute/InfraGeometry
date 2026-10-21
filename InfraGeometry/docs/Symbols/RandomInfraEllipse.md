---
Template: Symbol
Name: RandomInfraEllipse
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraEllipse
Keywords: [ellipse, foci, distance sum, separating cycle, conic, random]
SeeAlso: [InfraEllipse, InfraEllipseQ, RandomInfraCircle, InfraQuadric, RandomInfraPoint]
---

## Usage

<code>[RandomInfraEllipse]()[*g*, {*p*, *q*}, *s*]</code> gives a random ellipse of *g* with foci *p* and *q* and distance sum *s*, as a directed cycle graph.

<code>[RandomInfraEllipse]()[*g*, {*p*, *q*}, {*s1*, *s2*}]</code> gives an ellipse on the band of sums from *s1* to *s2*.

<code>[RandomInfraEllipse]()[*g*, {*p*, *q*}, *s*, *n*]</code> gives a list of *n* distinct ellipses.

<code>[RandomInfraEllipse]()[*g*, [InfraEllipse]()[{*p*, *q*}, *s*], …]</code> draws from the symbolic ellipse.

## Details & Options

An ellipse is a cycle of the subgraph induced on the band *E = {v : s₁ ≤ d(p, v) + d(q, v) ≤ s₂}*; a single sum *s* is the band {*s*, *s*}. By default it separates a vertex with sum below *s₁* from a vertex with sum above *s₂*, and is as short as possible.

In the plane each sum gives one closed curve. On a graph an exact level often carries no separating cycle, and a band of width 1 or 2 does. A band can carry several shortest separating cycles.

The count *n* can be `n`, `UpTo[n]` or `All`. When fewer cycles qualify, the result is `{}`.

| Option | Default | Values |
|---|---|---|
| [Properties]() | `{"Separating", "Shortest"}` | any subset; without `"Shortest"` longer cycles are taken in order of length |
| `"NextVertexFunction"` | `Automatic` | `Identity` takes the cycles of each length in a fixed order |
| [RandomSeeding]() | `Automatic` | an integer or a string for a reproducible draw; `Inherited` to draw from the current random state |

## Basic Examples

An ellipse on the band of sums 6 to 8, with foci the centre and a point at distance 2, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {q = RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {RandomInfraEllipse[g, {c, q}, {6, 8}, RandomSeeding -> 1], c, q}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The number of shortest separating cycles on the band, and their length. On the grid there is one, on the mesh several:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small"]}, {c = First @ GraphCenter[g]},
    {q = RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1]},
    {ellipses = RandomInfraEllipse[g, {c, q}, {6, 8}, All]},
    {Length[ellipses], Union[VertexCount /@ ellipses]}],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Scope

The symbolic ellipse gives the same draw:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  RandomInfraEllipse[g, {c, 19}, {6, 8}, RandomSeeding -> 1] ===
    RandomInfraEllipse[g, InfraEllipse[{c, 19}, {6, 8}], RandomSeeding -> 1]]
```

## Options

### Properties

Without `"Shortest"` the separating cycles come in order of length; with no property at all the first cycles of the band are its unit squares:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  Table[VertexCount /@ RandomInfraEllipse[g, {45, 56}, {6, 8}, 3, Properties -> props, RandomSeeding -> 1],
    {props, {{"Separating"}, {}}}]]
```

### RandomSeeding

A fixed seed gives the same ellipse whatever [SeedRandom]() has set:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Table[SeedRandom[k]; VertexList @ RandomInfraEllipse[g, {c, 19}, {6, 8}, RandomSeeding -> 7], {k, 2}]]
```

## Properties and Relations

With equal foci and sum *2r* the ellipses are the circles of radius *r*:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Sort[Sort @* VertexList /@ RandomInfraEllipse[g, {c, c}, 6, All]] ==
    Sort[Sort /@ RandomInfraCircle[g, InfraCircle[c, 3], All]]]
```

## Possible Issues

On the grid the exact level carries no separating cycle:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {RandomInfraEllipse[g, {45, 56}, 6, All], RandomInfraEllipse[g, {45, 56}, 7, All]}]
```
