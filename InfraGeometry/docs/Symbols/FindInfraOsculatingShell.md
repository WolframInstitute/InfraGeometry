---
Template: Symbol
Name: FindInfraOsculatingShell
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraOsculatingShell
Keywords: [osculating circle, curvature, radius of curvature, shell, window, centre]
SeeAlso: [FindInfraShellCenter, InfraShell, RandomInfraSphere, FindInfraEquidistantSet, RandomInfraCircle]
---

## Usage

<code>[FindInfraOsculatingShell]()[*g*, *walk*, *i*, *k*]</code> gives the shells that contain the *k* vertices of *walk* around position *i*.

<code>[FindInfraOsculatingShell]()[*g*, *walk*, *i*, *k*, *n*]</code> gives *n* of them.

## Details & Options

The window is the *k* consecutive vertices of the walk centred at position *i*, cut off at the ends of the walk. For every vertex *c* at one common distance *r* from all window vertices, the result contains the shell *Sᵣ(c) = {v : d(c, v) = r}*, as a sorted vertex list. Shells come in order of increasing *r*.

It is the graph analogue of the osculating circle: the circles through *k* nearby points of a curve. In the plane three points fix one circle. On a graph a short window lies on many shells, and a longer one cuts them down.

The walk can be a vertex list, a walk graph or a list of walk graphs.

The count *n* can be `n`, `UpTo[n]` or `All`, the default. Fewer than *n* shells give `{}`.

| Option | Default | Values |
|---|---|---|
| [Properties]() | `{}` | `{}`: the shell; `{"Separating"}`, `{"Separating", "Connected"}`: the spheres of [RandomInfraSphere]() inside it |
| `"NextVertexFunction"` | `Identity` | passed to [RandomInfraSphere]() |

## Basic Examples

Along the circle of radius 3 on the mesh, a window of 7 vertices lies on one shell only, the circle itself:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {cycle = First @ RandomInfraCircle[g, InfraCircle[c, 3], All]},
  {shells = FindInfraOsculatingShell[g, cycle, 6, 7]},
  InfraSubstrateHighlight[g, {shells, cycle[[3 ;; 9]], c}, PlotLabel -> Length[shells], ImageSize -> Medium]]
```

The number of shells through the window against its size *k*:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {cycle = First @ RandomInfraCircle[g, InfraCircle[c, 3], All]},
  Table[k -> Length @ FindInfraOsculatingShell[g, cycle, 6, k], {k, 1, 11, 2}]]
```

## Properties and Relations

The single shell of the long window is the shell of radius 3 about the centre:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {cycle = First @ RandomInfraCircle[g, InfraCircle[c, 3], All]},
  FindInfraOsculatingShell[g, cycle, 6, 7] == {Sort @ Keys @ InfraMeasurement[g, InfraShell[c, 3], "VertexDensity"]}]
```
