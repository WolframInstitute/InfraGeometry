---
Template: Symbol
Name: RandomInfraSphere
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraSphere
Keywords: [sphere, separating set, shell, band, minimal separator]
SeeAlso: [InfraSphere, InfraShell, RandomInfraCircle, InfraMeasurement, InfraBall]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraSphere]()[*g*, *c*, *r*]</code> gives a random sphere of radius *r* about *c* in *g*, as a sorted vertex list.

<code>[RandomInfraSphere]()[*g*, *c*, {*r*, *s*}]</code> gives a random sphere in the band of radii *r* to *s*.

<code>[RandomInfraSphere]()[*g*, *c*, *r*, *n*]</code> gives a list of *n* distinct spheres.

<code>[RandomInfraSphere]()[*g*, [InfraSphere]()[*c*, *r*]]</code> and <code>[RandomInfraSphere]()[*g*, [InfraSphere]()[*c*, *r*], *n*]</code> are the same with the sphere given as a token.

## Details & Options

The band is *L = {v : r ≤ d(c, v) ≤ s}*, the shell for *s = r*, and *ρ = (r + s)/2*. A sphere is an inclusion-minimal connected subset *S* of *L* that separates: after removing *S*, the component of *c* lies in the ball of radius *ρ* and every other vertex lies outside it.

A shell with no edges has no connected subset of more than one vertex. On the square grid, which is bipartite, a sphere of one radius does not exist by default; the band {*r*, *r* + 1} has spheres.

The peeling takes vertices out of the band one at a time while it still separates, so a sphere is minimal, not of least size.

When the band does not separate, the result is `{}`.

The count *n* can be `n`, `UpTo[n]` or `All`. All spheres of a large band can take long.

Options:

| Option | Default | Values |
|---|---|---|
| [Properties]() | `{"Separating", "Connected"}` | `{"Separating"}` drops connectedness; `{}` gives the band itself |
| `"NextVertexFunction"` | `Automatic` | `Automatic` peels in random order; `Identity` in vertex order; a function of the candidate list gives the vertices to try |
| [RandomSeeding]() | `Automatic` | an integer or a string for a reproducible draw; `Inherited` to draw from the current random state |

## Basic Examples

A sphere in the band {3, 4} about the centre, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    InfraSubstrateHighlight[g, {InfraShell[c, {3, 4}], RandomInfraSphere[g, c, {3, 4}, RandomSeeding -> 1], c}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

On the mesh the shell of radius 3 is a cycle, and the sphere is the whole shell, the vertices of the circle of radius 3:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {sphere = RandomInfraSphere[g, c, 3, RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {sphere, c}, PlotLabel -> {Length[sphere], sphere === Sort @ RandomInfraCircle[g, c, 3]},
    ImageSize -> Medium]]
```

Three spheres of the band {3, 4} on the grid, each of 23 vertices:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {sphere, c}, PlotLabel -> Length[sphere]],
    {sphere, RandomInfraSphere[g, c, {3, 4}, 3, RandomSeeding -> 1]}]]
```

## Options

### Properties

On the grid the shell of radius 3 separates but has no edges. Without connectedness the sphere is the whole shell of 12 vertices; with it there is none:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {sphere = RandomInfraSphere[g, c, 3, Properties -> {"Separating"}, RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {sphere, c}, PlotLabel -> {Length[sphere], RandomInfraSphere[g, c, 3]}, ImageSize -> Medium]]
```

## Properties and Relations

Removing a sphere of the band {3, 4} leaves the centre with vertices within distance 3 only:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {sphere = RandomInfraSphere[g, c, {3, 4}, RandomSeeding -> 1]},
  Max[GraphDistance[g, c, #] & /@ VertexComponent[VertexDelete[g, sphere], c]]]
```

The token form gives the same draw:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  RandomInfraSphere[g, InfraSphere[c, {3, 4}], RandomSeeding -> 1] === RandomInfraSphere[g, c, {3, 4}, RandomSeeding -> 1]]
```
