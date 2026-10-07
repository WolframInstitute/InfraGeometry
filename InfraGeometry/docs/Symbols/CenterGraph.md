---
Template: Symbol
Name: CenterGraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/CenterGraph
Keywords: [centre, center, ball, interior, rim, cut, substrate preparation]
SeeAlso: [InfraSubstrate, FindInfraPoint, InfraSubstrateHighlight, GraphCenter, NeighborhoodGraph]
RelatedGuides: [InfraSubstrates]
---

## Usage

<code>[CenterGraph]()[*g*, *k*]</code> gives the ball of *k* hops about the centre of *g*.

<code>[CenterGraph]()[*g*, -*k*]</code> gives the ball whose radius is *k* less than the radius of *g*.

<code>[CenterGraph]()[*g*, Scaled[*q*]]</code> gives the ball whose radius is the fraction *q* of the radius of *g*.

<code>[CenterGraph]()[*g*]</code> gives the centre of *g*.

## Details & Options

The centre is `GraphCenter[g]`, the vertices of least eccentricity, and the radius `GraphRadius[g]` is that eccentricity. `CenterGraph[g, k]` is `NeighborhoodGraph[g, GraphCenter[g], k]`, the subgraph induced on the vertices within `k` hops of the centre.

A negative `k` gives the radius `GraphRadius[g] + k`, never below 0. On a patch that is itself a ball about its centre, as the tilings are, `CenterGraph[g, -1]` is the patch without its rim.

`Scaled[q]` gives the radius `Floor[q GraphRadius[g]]`, with `q` clipped to `[0, 1]`: the same fraction of the radius on every size of a substrate.

`k >= GraphRadius[g]` and `Scaled[1]` give the whole graph; `k = 0` and `Scaled[0]` give the centre.

The cut keeps the vertex labels and coordinates of `g`, so a construction made on it draws on `g`.

A disconnected graph is returned whole. On a vertex-transitive graph every vertex is a centre, so every cut is the whole graph.

## Basic Examples

The ball of two hops about the centre of the square tiling.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  InfraSubstrateHighlight[g, {VertexList @ CenterGraph[g, 2]}]]
```

A negative count is taken from the radius. On the three tilings, `-1` drops the rim.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    InfraSubstrateHighlight[g, {VertexList @ CenterGraph[g, -1]}]],
  {name, {"SquareTilingGraph", "TriangularTilingGraph", "HexagonalTilingGraph"}}]
```

`Scaled[q]` takes a fraction of the radius, the same on every size.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate["HexagonalTilingGraph", size, "KeepCoordinates" -> True]},
    InfraSubstrateHighlight[g, {VertexList @ CenterGraph[g, Scaled[1/2]]}]],
  {size, {"Small", "Medium", "Large"}}]
```

## Scope

A construction made on the cut stays off the rim and draws on the whole substrate: three points drawn from the ball two hops short of the radius.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {core = CenterGraph[g, -2]},
  {points = (SeedRandom[1]; FindInfraPoint[core, 3])},
  InfraSubstrateHighlight[g, {VertexList @ core, points}]]
```

The centre alone: on a grid of even side it is four vertices.

```wl
With[
  {g = GridGraph[{6, 6}]},
  InfraSubstrateHighlight[g, {VertexList @ CenterGraph[g]}]]
```

## Properties and Relations

The size of the cut against `k`, from minus the radius to the radius: the negative half repeats the positive one, read from the outside in.

```wl
With[
  {g = InfraSubstrate["SquareMeshGraph", "Small"]},
  {r = GraphRadius[g]},
  ListStepPlot[Table[{k, VertexCount @ CenterGraph[g, k]}, {k, -r, r}], AxesLabel -> {"k", "vertices"}]]
```

## Possible Issues

A bare fraction is not a count of hops, and the call stays unevaluated. The fraction is `Scaled[q]`.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small"]},
  {Head @ CenterGraph[g, 0.9], VertexCount @ CenterGraph[g, Scaled[0.9]]}]
```

The ball is round in the graph metric, not in the shape of the patch. On the square mesh a negative count trims the corners first, and `-1`, `-2` and `-3` still reach the sides.

```wl
With[
  {g = InfraSubstrate["SquareMeshGraph", "Medium", "KeepCoordinates" -> True]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {VertexList @ CenterGraph[g, k]}], {k, {-1, -2, -3}}]]
```
