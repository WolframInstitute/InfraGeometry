---
Template: Symbol
Name: FindInfraPolylineSubdivision
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraPolylineSubdivision
Keywords: [polyline, geodesic polygon, subdivision, knots, legs, piecewise geodesic]
SeeAlso: [InfraSegment, InfraSegmentQ, ConcatenateInfraWalk, FindEmbeddingClosestPath, InfraGeodesicQ]
---

## Usage

<code>[FindInfraPolylineSubdivision]()[*g*, *walk*]</code> cuts the walk into the fewest pieces that are shortest paths of *g*.

## Details & Options

The walk *(w₁, …, wₙ)* is cut at knots *w₁ = wᵢ₁, wᵢ₂, …, wᵢₖ = wₙ* so that each leg *(wᵢⱼ, …, wᵢⱼ₊₁)* is a shortest path: *d(wᵢⱼ, wᵢⱼ₊₁) = iⱼ₊₁ − iⱼ*. The result is the list of legs, each a directed path graph.

Each leg is made as long as possible before the next knot. Since a piece of a shortest path is a shortest path, this gives the fewest legs.

The walk is then a member of the polyline <code>[InfraSegment]()[*wᵢ₁*, …, *wᵢₖ*]</code> through its knots.

A walk with fewer than two vertices gives `{}`.

| Option | Default | Values |
|---|---|---|
| `"MaxLength"` | `Infinity` | a number *L*: every leg has at most *L* edges |

## Basic Examples

A circle snapped to the substrate, cut into shortest paths; the knots are drawn as points. On the grid a staircase is a shortest path and four legs suffice; the mesh needs 12:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {o = Mean @ GraphEmbedding[g], r = 0.35 Max[GraphEmbedding[g]]},
    {walk = Last /@ VertexList[FindEmbeddingClosestPath[g, Line[Table[o + r {Cos[t], Sin[t]}, {t, 0, 2 Pi, Pi/40}]]]]},
    {legs = FindInfraPolylineSubdivision[g, walk]},
    InfraSubstrateHighlight[g, {legs, First /@ VertexList /@ legs}, PlotLabel -> Length[legs]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The walk is a member of the polyline through its knots, and each leg is a shortest path:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {o = Mean @ GraphEmbedding[g], r = 0.35 Max[GraphEmbedding[g]]},
  {walk = Last /@ VertexList[FindEmbeddingClosestPath[g, Line[Table[o + r {Cos[t], Sin[t]}, {t, 0, 2 Pi, Pi/40}]]]]},
  {legs = FindInfraPolylineSubdivision[g, walk]},
  {knots = Append[First /@ VertexList /@ legs, Last @ walk]},
  {InfraMemberQ[g, InfraSegment @@ knots, walk], AllTrue[legs, InfraSegmentQ[g, VertexList[#]] &]}]
```

## Options

### MaxLength

The lengths of the legs of the grid circle, without a cap and with legs of at most 3 edges:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {walk = Last /@ VertexList[FindEmbeddingClosestPath[g, Line[Table[{5.5, 5.5} + 3.5 {Cos[t], Sin[t]}, {t, 0, 2 Pi, Pi/40}]]]]},
  Table[EdgeCount /@ FindInfraPolylineSubdivision[g, walk, "MaxLength" -> L], {L, {Infinity, 3}}]]
```
