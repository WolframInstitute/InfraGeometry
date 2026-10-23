---
Template: Symbol
Name: RandomInfraSphere
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraSphere
Keywords: [sphere, separating set, shell, band, minimal separator]
SeeAlso: [InfraSphere, InfraShell, InfraMemberQ, InfraMeasurement, RandomInfraPlane]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraSphere]()[*g*, *c*, *r*]</code> gives a random sphere of radius *r* about *c* in *g*, as a sorted vertex list.

<code>[RandomInfraSphere]()[*g*, *c*, {*r*, *s*}]</code> gives a random sphere in the band of radii *r* to *s*.

<code>[RandomInfraSphere]()[*g*, *c*, *r*, *n*]</code> gives a list of *n* distinct spheres.

<code>[RandomInfraSphere]()[*g*, [InfraSphere]()[*c*, *r*]]</code> and <code>[RandomInfraSphere]()[*g*, [InfraSphere]()[*c*, *r*], *n*]</code> are the same with the sphere given as a token.

## Details & Options

The band is *L = {v ≠ c : r ≤ d(c, v) ≤ s}*, the shell for *s = r*, and the exterior is *E = {v : d(c, v) > s}*. A sphere is a connected subset *S* of *L* that separates *c* from *E*, so that every path from *c* to *E* meets *S*, and is minimal: no proper subset of *S* separates.

On the square mesh a shell is a ring and is its own sphere. A band of two radii has many spheres, all connected: 60 for {1, 2} about the centre, 2100 for {2, 3}.

On the square grid the minimal separators about the centre are not connected, and the result is `{}`. `Properties -> {"Separating"}` gives the minimal separators themselves.

When nothing lies beyond the band, *E* is empty, and the only minimal separator is the empty set.

The count *n* can be `n`, `UpTo[n]` or `All`. A draw is uniform over all the spheres; `All` gives them sorted.

Options:

| Option | Default | Values |
|---|---|---|
| [Properties]() | `{"Separating", "Connected"}` | `{"Separating"}` the minimal separators; `{}` the band itself |
| `"NextVertexFunction"` | `Automatic` | `Automatic` random; `Identity` the first spheres in sorted order; a function of the sorted list of spheres |
| [RandomSeeding]() | `Automatic` | an integer or a string for a reproducible draw; `Inherited` to draw from the current random state |

## Basic Examples

A minimal separator in the band {2, 3} about the centre of the square grid, and a sphere in the same band of the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[First @ spec, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {sphere = RandomInfraSphere[g, c, {2, 3}, Properties -> Last @ spec, RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraShell[c, {2, 3}], sphere, c}]],
  {spec, {{"SquareGridGraph", {"Separating"}}, {"SquareMeshGraph", {"Separating", "Connected"}}}}]
```

On the mesh the shell of radius 3 is its own sphere:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {sphere = RandomInfraSphere[g, c, 3, RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {sphere, c},
    PlotLabel -> (sphere === Keys @ InfraMeasurement[g, InfraShell[c, 3], "VertexDensity"]), ImageSize -> Medium]]
```

Three spheres of the band {2, 3} on the mesh:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {sphere, c}, PlotLabel -> Length[sphere]],
    {sphere, RandomInfraSphere[g, c, {2, 3}, 3, RandomSeeding -> 1]}]]
```

## Options

### Properties

On the grid the bands {1, 2} and {2, 3} have 16 and 161 minimal separators, and none is connected:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Table[Length @ RandomInfraSphere[g, c, b, All, Properties -> p],
    {b, {{1, 2}, {2, 3}}}, {p, {{"Separating"}, {"Separating", "Connected"}}}]]
```

A minimal separator of the grid band {2, 3} falls into pieces that touch only diagonally:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {wall = RandomInfraSphere[g, c, {2, 3}, Properties -> {"Separating"}, RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {wall, c}, PlotLabel -> Length @ ConnectedComponents @ Subgraph[g, wall],
    ImageSize -> Medium]]
```

## Properties and Relations

A sphere of the band {1, 2} separates the centre from every vertex beyond distance 2, and no vertex can be removed from it:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {sphere = RandomInfraSphere[g, c, {1, 2}, RandomSeeding -> 1]},
  {far = Select[VertexList[g], GraphDistance[g, c, #] > 2 &]},
  {separatesQ = s |-> ! IntersectingQ[VertexComponent[VertexDelete[g, s], c], far]},
  {separatesQ[sphere], NoneTrue[sphere, separatesQ[DeleteCases[sphere, #]] &]}]
```

The token form gives the same draw:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  RandomInfraSphere[g, InfraSphere[c, {1, 2}], RandomSeeding -> 1] === RandomInfraSphere[g, c, {1, 2}, RandomSeeding -> 1]]
```

## Possible Issues

On the mesh nothing lies beyond radius 6. The empty set is then the only minimal separator, and it is not connected:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  RandomInfraSphere[g, c, 6, All, Properties -> #] & /@ {{"Separating"}, {"Separating", "Connected"}}]
```
