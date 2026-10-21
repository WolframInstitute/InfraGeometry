---
Template: Symbol
Name: PolarDisplacements
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/PolarDisplacements
Keywords: [displacement, polar coordinates, radial field, angular field, distance sphere]
SeeAlso: [GradientDisplacement, TranslationDisplacement, RandomDisplacement, DisplacementPlot, GraphCenter]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[PolarDisplacements]()[*g*, *c*]</code> gives the pair {*radial*, *angular*} about the vertex *c*: the radial displacement moves each vertex to its neighbours one step further from *c*, the angular one to its neighbours at the same distance from *c*.

## Details & Options

With *ρ(v) = d(c, v)*, the two displacements are

- *radial(v) = {u ∼ v : ρ(u) = ρ(v) + 1}*,
- *angular(v) = {u ∼ v : ρ(u) = ρ(v)}*,

and a vertex with no such neighbour stays. They are the discrete counterparts of the polar vector fields *∂ᵨ* and *∂_θ* at scale 1.

Both are multivalued. On the square grid an inner vertex off the axes through *c* has two neighbours further out, a vertex on an axis three, and *c* four.

On a bipartite graph, such as the square grid, no edge joins two vertices at the same distance from *c*, and the angular displacement fixes every vertex.

The outward radial displacement is the gradient of *ρ* ([GradientDisplacement]()).

Options:

| Option | Default | Values |
|---|---|---|
| `"Direction"` | `"Outward"` | `"Inward"` takes *ρ(u) = ρ(v) − 1* for the radial displacement; the angular one does not change |

## Basic Examples

The radial displacement about the centre in blue and the angular one in red, on the square grid and on the square mesh. The grid is bipartite, and its angular displacement draws nothing:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    DisplacementPlot[g, PolarDisplacements[g, First @ GraphCenter[g]]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The two displacements of the mesh apart. The angular one runs both ways along the distance spheres:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  GraphicsRow[DisplacementPlot[g, #] & /@ PolarDisplacements[g, First @ GraphCenter[g]]]]
```

## Scope

Any vertex can be the centre. A vertex of the periphery of the mesh, of largest eccentricity:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  DisplacementPlot[g, PolarDisplacements[g, First @ GraphPeriphery[g]]]]
```

## Options

### Direction

The inward radial displacement points to the centre, which stays:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {inward = First @ PolarDisplacements[g, c, "Direction" -> "Inward"]},
  DisplacementPlot[g, inward, PlotLabel -> inward[c]]]
```

## Properties and Relations

The outward radial displacement is the gradient of the distance from the centre:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  First @ PolarDisplacements[g, c] === GradientDisplacement[g, AssociationThread[VertexList[g], GraphDistance[g, c]]]]
```

The radial displacement is 1-continuous on the grid but not on the mesh. The angular displacement of the mesh is 2-continuous, not 1-continuous:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {polar = PolarDisplacements[g, First @ GraphCenter[g]]},
    {ContinuousDisplacementQ[g, First @ polar], ContinuousDisplacementQ[g, Last @ polar],
     ContinuousDisplacementQ[g, Last @ polar, 2]}],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The numbers of values of the radial displacement of the grid, with their counts. The 32 pendant vertices have no neighbour further out and stay:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  KeySort @ Counts[Length /@ Values @ First @ PolarDisplacements[g, First @ GraphCenter[g]]]]
```
