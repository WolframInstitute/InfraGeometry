---
Template: Symbol
Name: TorusTessellation
Context: WolframInstitute`SyntheticInfrageometry`
ContextPath: [WolframInstitute`Infrageometry`]
Paclet: WolframInstitute/SyntheticInfrageometry
URI: WolframInstitute/SyntheticInfrageometry/ref/TorusTessellation
Keywords: [torus, flat torus, square lattice, triangular lattice, honeycomb, Cayley graph, wraparound]
SeeAlso: [TessellationGraph, InfraSubstrate, FindInfraShell, InfraSegment, InfraHighlightGraph]
RelatedGuides: [EuclideanGeometryGuide]
---

## Usage

<code>[TorusTessellation]()[{*m*, *n*}, *shape*]</code> is the *m* × *n* flat torus tiled by *shape*: `"Square"`, `"Triangular"` or `"Hexagonal"`.

<code>[TorusTessellation]()[{*m*, *n*}]</code> is the triangular torus.

## Details & Options

The three regular tilings of the plane, wrapped on a torus:

| *shape* | Type | Degree | Vertices | Vertex names |
|---|---|---|---|---|
| `"Square"` | {4, 4} | 4 | *m n* | `{i, j}`, 1 ≤ *i* ≤ *m*, 1 ≤ *j* ≤ *n* |
| `"Triangular"` | {3, 6} | 6 | *m n* | `{i, j}`, 0 ≤ *i* < *m*, 0 ≤ *j* < *n* |
| `"Hexagonal"` | {6, 3} | 3 | 2 *m n* | `{i, j, s}`, *s* ∈ {0, 1} the sublattice |

The square and triangular tori are Cayley graphs of ℤ/*m* × ℤ/*n*, with the steps ±e₁, ±e₂, and for the triangular torus also ±(e₁ + e₂). The honeycomb has two vertices per cell. Every one of the three is vertex-transitive, so every vertex sees the same torus.

The torus has no boundary, so no vertex is special and there is no rim to avoid. It pays for this with **wraparound**. A shell of radius *r* grows like the plane's only until *r* reaches half the shorter side; beyond that it meets itself and shrinks. Two vertices half-way round are joined by geodesics going both ways round. For plane geometry, use a patch from [InfraSubstrate]() instead.

The graph has no coordinates; its layout is the default. `"SquareTorusGraph"`, `"TriangularTorusGraph"` and `"HexagonalTorusGraph"` in [InfraSubstrate]() are these graphs placed on a torus of revolution. `Graph` options are passed on to the graph.

## Basic Examples

Between two points half-way round the square torus there are two geodesics, one each way round.

```wl
With[
  {g = InfraSubstrate["SquareTorusGraph", "Small", "KeepCoordinates" -> True]},
  InfraHighlightGraph[g,
    {InfraSegment[{1, 1}, {6, 1}], Directive[$InfraPointColor], {1, 1}, {6, 1}},
    ImageSize -> 300]]
```

The three shapes on an 8 × 6 torus: vertex count, degree and diameter.

```wl
Table[
  With[{g = TorusTessellation[{8, 6}, shape]},
    {shape, VertexCount[g], Union @ VertexDegree[g], GraphDiameter[g]}],
  {shape, {"Square", "Triangular", "Hexagonal"}}]
```

## Scope

The shell sizes on a 12 × 12 square torus. They grow by 4 at every step, as in the plane, up to radius 5; at radius 6 the shell meets itself, and it shrinks to the single antipode at radius 12.

```wl
With[
  {g = TorusTessellation[{12, 12}, "Square"]},
  Table[Length @ FindInfraShell[g, {1, 1}, r], {r, 0, 12}]]
```

## Properties and Relations

Every vertex looks the same.

```wl
VertexTransitiveGraphQ /@ {TorusTessellation[{8, 6}, "Square"], TorusTessellation[{8, 6}], TorusTessellation[{8, 6}, "Hexagonal"]}
```

The square torus is the Cartesian product of two cycles.

```wl
IsomorphicGraphQ[TorusTessellation[{8, 6}, "Square"], GraphProduct[CycleGraph[8], CycleGraph[6], "Cartesian"]]
```

The square torus substrate of [InfraSubstrate]() is the 10 × 10 square torus.

```wl
Sort @ EdgeList @ InfraSubstrate["SquareTorusGraph", "Small"] ===
  Sort @ EdgeList @ TorusTessellation[{10, 10}, "Square"]
```
