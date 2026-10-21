---
Template: Symbol
Name: FindInfraSpanningAxes
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraSpanningAxes
Keywords: [spanning axes, diameter, longest shortest path, separation, frame]
SeeAlso: [FindInfraOrthogonalAxes, FindInfraOrthogonalRays, OrthogonalCoordinates, GraphDiameter]
RelatedGuides: [RiemannianInfrageometry]
---

## Usage

<code>[FindInfraSpanningAxes]()[*g*, *n*]</code> gives *n* well-separated shortest paths across *g* of the length of its diameter, each a vertex list.

<code>[FindInfraSpanningAxes]()[*g*]</code> gives one such path.

## Details & Options

The candidates are the shortest paths between two vertices at distance at least `"MinLength"`, by default the diameter of *g*. The first candidate is taken; each next axis is the candidate farthest from those chosen, by `"AxisDistance"`. The choice stops when the best candidate is closer than `"MinSeparation"`.

Unlike [FindInfraOrthogonalAxes]() the axes have no common centre: they span the whole graph.

The count *n* can be `n`, `UpTo[n]` or `All`. Fewer than *n* axes give `{}`.

Options:

| Option | Default | Values |
|---|---|---|
| `"AxisDistance"` | `"MinEndpoint"` | `"MinEndpoint"`, the least distance between an end of the candidate and an end of a chosen axis; `"Separation"`, the least distance between their vertices; `"Hausdorff"`, the Hausdorff distance to the chosen vertices |
| `"MinLength"` | `Automatic` | the least length of a candidate; `Automatic` is the diameter |
| `"MinSeparation"` | `Automatic` | the least distance of a new axis; `Automatic` is half the length of the first axis |
| `"AxisThickness"` | 0 | *t* > 0 also takes, with each axis, the candidates within Hausdorff distance *t* of it |
| `"RandomPick"` | `False` | `True` picks the first axis, and each next one among the tied best, at random |

## Basic Examples

The spanning axes of the square grid and of the square mesh. The grid has two, the mesh one:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    InfraSubstrateHighlight[g, InfraWalk /@ FindInfraSpanningAxes[g, All]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The axes have the length of the diameter:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {GraphDiameter[g], Length /@ FindInfraSpanningAxes[g, All] - 1}]
```

## Options

### MinLength

Admitting paths of length 10 gives the mesh two axes:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  InfraSubstrateHighlight[g, InfraWalk /@ FindInfraSpanningAxes[g, 2, "MinLength" -> 10], ImageSize -> Medium]]
```

### AxisDistance

On the 5 × 5 grid the two diagonal pairs of corners give the candidates. Ends apart keep two axes; vertices apart keep one, since every two candidates meet:

```wl
Table[Length @ FindInfraSpanningAxes[GridGraph[{5, 5}], All, "AxisDistance" -> m], {m, {"MinEndpoint", "Separation"}}]
```

## Possible Issues

Asking for more axes than there are gives `{}`. The square mesh has one:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]},
  {FindInfraSpanningAxes[g, 2], Length @ FindInfraSpanningAxes[g, UpTo[2]]}]
```
