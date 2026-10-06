---
Template: Symbol
Name: RadarCoordinates
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RadarCoordinates
Keywords: [radar coordinates, distance vector, trilateration, resolving set, metric basis, landmarks, coordinatization]
SeeAlso: [ResolvingSetQ, FindResolvingSet, MetricDimension, ResistanceCoordinates, OrthogonalCoordinates]
RelatedGuides: [Experimental]
---

## Usage

<code>[RadarCoordinates]()[*g*, *basis*, *v*]</code> gives the distances (*d*(*v*, *b*₁), …, *d*(*v*, *b*ₖ)) of the vertex *v* of *g* from the stations *b*₁, …, *b*ₖ of *basis*.

<code>[RadarCoordinates]()[*g*, *basis*]</code> gives the association of every vertex of *g* with its radar coordinates.

## Details & Options

Definition: the radar coordinates of a vertex *v* from a basis (*b*₁, …, *b*ₖ) are its distances (*d*(*v*, *b*₁), …, *d*(*v*, *b*ₖ)). The vertices of the basis are radar stations, and each vertex is located by its distances to them, as in trilateration.

The coordinates tell every two vertices apart exactly when the basis is a resolving set, [ResolvingSetQ](). A smallest resolving set is found by [FindResolvingSet](), and its size is the [MetricDimension]().

A station may also be a set of vertices, given as a density or as a walk graph. Its coordinate is the list of distances to its vertices, reduced to one number by the option `"AnchorAggregation"`: [Min]() (the default) gives the distance to the nearest vertex of the set, and any function of a list may be given.

The point *v* may also be a density; the result is then the list of the coordinates of its vertices.

| Option | Default | |
|---|---|---|
| `"AnchorAggregation"` | [Min]() | the function that reduces the distances to the vertices of a set station to one coordinate |

## Basic Examples

Three stations at three corners of the square, hexagonal and triangular tilings, a vertex two steps from the centre, and a shortest path from it to each station. Its coordinates are the lengths of the three paths, in the order of the stations.

```wl
With[
  {panels = Table[
     With[
       {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
       {stations = First @ FindResolvingSet[g]},
       {site = (SeedRandom[1]; RandomInfraPoint[g, InfraCenter[g], 2])},
       {InfraSubstrateHighlight[g, Join[InfraWalk[FindShortestPath[g, site, #]] & /@ stations, {stations, site}]],
        RadarCoordinates[g, stations, site]}],
     {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]},
  {GraphicsRow[First /@ panels], Last /@ panels}]
```

Two corners of one side of a grid resolve it. Drawn at its radar coordinates from them, the grid is itself again, turned by 45 degrees.

```wl
With[
  {g = GridGraph[{6, 6}]},
  {stations = {1, 6}},
  {GraphicsRow[{InfraSubstrateHighlight[g, {stations}],
     Graph[VertexList[g], EdgeList[g], VertexCoordinates -> Normal[RadarCoordinates[g, stations]]]}],
   ResolvingSetQ[g, stations]}]
```

## Scope

A station may be a set of vertices, given as a density. With the rim of each tiling as the one station, the coordinate is the depth of each vertex. Its level sets are rings, and the centre lies deepest, at the radius of the tiling.

```wl
With[
  {panels = Table[
     With[
       {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
       {depth = RadarCoordinates[g, {AssociationThread[GraphExteriorBoundary[g, Method -> "MaxDegree"], 1]}]},
       {InfraSubstrateHighlight[g, Values @ KeySort @ GroupBy[Keys[depth], depth]], depth[InfraCenter[g]]}],
     {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]},
  {GraphicsRow[First /@ panels], Last /@ panels}]
```

## Options

### AnchorAggregation

A station of two vertices six steps apart, read three ways on the square tiling. Each level set of the coordinate has its own colour, the least one red. [Min]() gives the distance to the nearer vertex: its level sets are the outer shells of the unions of two balls, starting at the two vertices. [Max]() gives the distance to the farther vertex: its level sets are the outer shells of the intersections of two balls, starting at the midpoints. [Total]() gives the sum of the two distances: its level sets are the infra-ellipses with the two vertices as foci, starting at the interval between them.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {foci = {(SeedRandom[1]; RandomInfraPoint[g, InfraCenter[g], 3]), (SeedRandom[2]; RandomInfraPoint[g, InfraCenter[g], 3])}},
  {readings = Table[RadarCoordinates[g, {AssociationThread[foci, 1]}, "AnchorAggregation" -> aggregation], {aggregation, {Min, Max, Total}}]},
  {GraphicsRow[InfraSubstrateHighlight[g, Values @ KeySort @ GroupBy[Keys[#], #]] & /@ readings], GraphDistance[g, Sequence @@ foci]}]
```

## Properties and Relations

Two corners of the square tiling do not resolve it. Drawn at its radar coordinates from them, the tiling folds along the line through the two corners onto half of itself: 113 vertices land on 64 points.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {stations = Take[First @ FindResolvingSet[g], 2]},
  {radar = RadarCoordinates[g, stations]},
  {Graph[VertexList[g], EdgeList[g], VertexCoordinates -> Normal[radar]],
   CountDistinct[Values[radar]], VertexCount[g], ResolvingSetQ[g, stations]}]
```

## Possible Issues

A vertex list as a station is read as a set only by the three-argument form. The two-argument form hands the list to [GraphDistance](), which leaves it unevaluated with a message. A density works in both forms.

```wl
With[
  {g = PathGraph[Range[5]]},
  {g, RadarCoordinates[g, {{1, 5}}, 3], RadarCoordinates[g, {AssociationThread[{1, 5}, 1]}],
   Quiet @ RadarCoordinates[g, {{1, 5}}][3]}]
```
