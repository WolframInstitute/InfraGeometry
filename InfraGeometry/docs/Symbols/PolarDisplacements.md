---
Template: Symbol
Name: PolarDisplacements
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/PolarDisplacements
Keywords: [displacement, polar coordinates, radial field, angular field, distance sphere]
SeeAlso: [GradientDisplacement, TranslationDisplacement, RandomDisplacement, DisplacementPlot, InfraCenter]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[PolarDisplacements]()[*g*, *c*]</code> gives the polar pair {*radial*, *angular*} about the vertex *c*: the radial displacement moves each vertex to its neighbours one step further from *c*, the angular one to its neighbours at the same distance from *c*.

## Details & Options

Definition: with *ρ(v) = d(c, v)*,

- *radial(v) = { u : u adjacent to v, ρ(u) = ρ(v) + 1 }*,
- *angular(v) = { u : u adjacent to v, ρ(u) = ρ(v) }*,

and a vertex with no such neighbour stays: its value is {*v*}. These are the discrete counterparts of the vector fields *∂_ρ* and *∂_θ* of polar coordinates, at scale 1.

Option `"Direction"` -> `"Inward"` takes *ρ(u) = ρ(v) − 1* for the radial displacement, so the centre stays; the default is `"Outward"`. The angular displacement does not depend on it.

The outward radial displacement is the gradient of *ρ* ([GradientDisplacement]()). On a bipartite graph, such as the square and the hexagonal tilings, no edge joins two vertices at the same distance from *c*, so the angular displacement fixes every vertex.

## Basic Examples

The polar pair about the centre of the discretized plane, the square tiling and the hexagonal tiling, radial in blue and angular in orange. The two tilings are bipartite, and their angular displacement draws nothing.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    DisplacementPlot[g, PolarDisplacements[g, InfraCenter[g]]]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]
```

On the triangular tiling the angular displacement runs both ways round the hexagonal distance spheres.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {polar = PolarDisplacements[g, InfraCenter[g]]},
  GraphicsRow[DisplacementPlot[g, #] & /@ polar]]
```

## Scope

Any vertex can be the centre.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  DisplacementPlot[g, PolarDisplacements[g, First @ Select[VertexList[g], VertexDegree[g, #] == 1 &]]]]
```

## Options

### Direction

The inward radial displacement points towards the centre, where it stays.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {inward = First @ PolarDisplacements[g, c, "Direction" -> "Inward"]},
  {DisplacementPlot[g, inward], inward[c]}]
```

## Properties and Relations

The outward radial displacement is the gradient of the distance from the centre.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {radial = First @ PolarDisplacements[g, c]},
  {DisplacementPlot[g, radial], radial === GradientDisplacement[g, AssociationThread[VertexList[g], GraphDistance[g, c]]]}]
```

The radial displacement is 1-continuous on the three tilings; the angular one only where it fixes every vertex.

```wl
With[
  {graphs = InfraSubstrate[#, "Small", "KeepCoordinates" -> True] & /@ {"SquareTilingGraph", "TriangularTilingGraph", "HexagonalTilingGraph"}},
  {polars = PolarDisplacements[#, InfraCenter[#]] & /@ graphs},
  {GraphicsRow[MapThread[DisplacementPlot, {graphs, polars}]], MapThread[{ContinuousDisplacementQ[#1, First[#2]], ContinuousDisplacementQ[#1, Last[#2]]} &, {graphs, polars}]}]
```

Both displacements are multivalued: on the triangular tiling an inner vertex has two or three neighbours further out and two on its own distance sphere.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {polar = PolarDisplacements[g, InfraCenter[g]]},
  {DisplacementPlot[g, polar], DisplacementSingleValuedQ /@ polar}]
```
