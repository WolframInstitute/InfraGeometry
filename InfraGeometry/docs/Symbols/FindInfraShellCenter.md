---
Template: Symbol
Name: FindInfraShellCenter
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraShellCenter
Keywords: [centre, center of a circle, radius, shell, chord, bisector, Euclid III.1]
SeeAlso: [InfraShell, InfraShellQ, FindInfraEquidistantSet, FindInfraOsculatingShell, InfraMidpoint]
---

## Usage

<code>[FindInfraShellCenter]()[*g*, *s*]</code> gives the candidate centres and radii of the vertex set *s*, as a list of pairs {*density*, *r*}.

## Details & Options

The default method follows Euclid III.1: the centre of a circle lies on the perpendicular bisector of every chord, so it is the midpoint of every diameter. For each vertex *u* of *s*, its farthest vertices *v* in *s* give chords *uv*. Each midpoint *m* of a chord, *d(u, m) + d(m, v) = d(u, v)* with *d(u, m) = ⌊d(u, v)/2⌋* or *⌈d(u, v)/2⌉*, gets one vote, as a candidate centre at radius *d(u, m)*. The result groups the votes by radius: *density* counts the votes of each vertex.

On a graph the midpoints of the diameters need not be one vertex, so the votes spread; the centre is where they pile up.

`Method -> "EquidistantPoints"` gives instead the vertices at one common distance *r > 0* from every vertex of *s*, each with weight 1.

| Option | Default | Values |
|---|---|---|
| [Method]() | `"MaximalChordsBisectors"` | `"MaximalChordsBisectors"`, `"EquidistantPoints"`, or either with sub-options |

Sub-options of `"MaximalChordsBisectors"`:

| Sub-option | Default | Values |
|---|---|---|
| `"Maximality"` | `"PerVertex"` | `"PerVertex"`: the farthest vertices from each vertex; `"Diameter"`: only chords of the largest length |
| `"Distance"` | `"Extrinsic"` | `"Extrinsic"`: the distance of *g*; `"Intrinsic"`: the distance of the subgraph on *s* |
| `"Parity"` | `All` | `All`, `"Even"`, `"Odd"`: the parity of the chord length |

Corresponding notion in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Proposition III.1 | To find the centre of a given circle. |

## Basic Examples

The votes for the centre of the shell of radius 3. They pile up at the true centre, with 30 votes on the grid and 48 on the mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {votes = First @ Last @ FindInfraShellCenter[g, Keys @ InfraMeasurement[g, InfraShell[c, 3], "VertexDensity"]]},
    InfraSubstrateHighlight[g, {InfraShell[c, 3], votes}, PlotLabel -> MaximalBy[Normal @ votes, Last]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The equidistant points of the shell are its centre alone, at radius 3:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small"]}, {c = First @ GraphCenter[g]},
    {c, FindInfraShellCenter[g, Keys @ InfraMeasurement[g, InfraShell[c, 3], "VertexDensity"], Method -> "EquidistantPoints"]}],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Options

### Method

On the mesh some diameters have odd length, and their midpoints also vote at radius 2. Even chords only leave radius 3:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {shell = Keys @ InfraMeasurement[g, InfraShell[c, 3], "VertexDensity"]},
  Table[Last /@ FindInfraShellCenter[g, shell, Method -> m],
    {m, {"MaximalChordsBisectors", {"MaximalChordsBisectors", "Parity" -> "Even"}}}]]
```

## Possible Issues

On the grid the shell has no edges, so its intrinsic distances are infinite and the intrinsic method finds nothing:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {shell = Keys @ InfraMeasurement[g, InfraShell[c, 3], "VertexDensity"]},
  FindInfraShellCenter[g, shell, Method -> {"MaximalChordsBisectors", "Distance" -> "Intrinsic"}]]
```
