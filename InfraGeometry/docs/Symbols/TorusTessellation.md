---
Template: Symbol
Name: TorusTessellation
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/TorusTessellation
Keywords: [torus, flat torus, square lattice, triangular lattice, honeycomb, Cayley graph, wraparound]
SeeAlso: [TessellationGraph, InfraSubstrate, InfraShell, InfraSegment, InfraSubstrateHighlight]
RelatedGuides: [InfraSubstrates]
---

## Usage

<code>[TorusTessellation]()[{*m*, *n*}, *shape*]</code> gives the *m* × *n* flat torus tiled by *shape*: `"Square"`, `"Triangular"` or `"Hexagonal"`.

<code>[TorusTessellation]()[{*m*, *n*}]</code> gives the triangular torus.

## Details & Options

The three regular tilings of the plane, wrapped on a torus:

| *shape* | Type | Degree | Vertices | Vertex names |
|---|---|---|---|---|
| `"Square"` | {4, 4} | 4 | *mn* | {*i*, *j*}, 1 ≤ *i* ≤ *m*, 1 ≤ *j* ≤ *n* |
| `"Triangular"` | {3, 6} | 6 | *mn* | {*i*, *j*}, 0 ≤ *i* < *m*, 0 ≤ *j* < *n* |
| `"Hexagonal"` | {6, 3} | 3 | 2*mn* | {*i*, *j*, *s*}, *s* ∈ {0, 1} the sublattice |

The square and triangular tori are Cayley graphs of *ℤₘ × ℤₙ* with the steps *±e₁*, *±e₂*, and for the triangular torus also *±(e₁ + e₂)*. All three are vertex-transitive: there is no rim and no special vertex.

The price is wraparound. On the square torus the shell of radius *r* has *4r* vertices, as in the plane, only while *r* < min(*m*, *n*)/2; past that it meets itself and shrinks. Two vertices half-way round are joined by shortest paths both ways round.

The graph has no coordinates. `"SquareTorusGraph"`, `"TriangularTorusGraph"` and `"HexagonalTorusGraph"` of [InfraSubstrate]() are such tori placed on a torus of revolution. [Graph]() options are passed on.

## Basic Examples

The three shapes on an 8 × 6 torus, labelled with their numbers of vertices and their degrees:

```wl
GraphicsRow @ Table[With[{g = TorusTessellation[{8, 6}, shape]}, Graph[g, PlotLabel -> {VertexCount[g], Union @ VertexDegree[g]}]],
  {shape, {"Square", "Triangular", "Hexagonal"}}]
```

Between two vertices half-way round the 10 × 10 square torus there are two shortest paths, one each way round:

```wl
With[{g = InfraSubstrate["SquareTorusGraph", "Small", "KeepCoordinates" -> True]},
  InfraSubstrateHighlight[g, {InfraSegment[{1, 1}, {6, 1}], {1, 1}, {6, 1}},
    PlotLabel -> InfraMeasurement[g, InfraSegment[{1, 1}, {6, 1}], "Cardinality"], ImageSize -> Medium]]
```

## Scope

The shell sizes on the 12 × 12 square torus. They grow by 4 up to radius 5, as in the plane; at radius 6 the shell meets itself, and it shrinks to the single antipode at radius 12:

```wl
With[{g = TorusTessellation[{12, 12}, "Square"]},
  ListStepPlot[Table[InfraMeasurement[g, InfraShell[{1, 1}, r], "CountingMeasure"], {r, 0, 12}], DataRange -> {0, 12},
    AxesLabel -> {"r", "shell"}]]
```

## Properties and Relations

Every vertex looks the same:

```wl
Table[VertexTransitiveGraphQ @ TorusTessellation[{8, 6}, shape], {shape, {"Square", "Triangular", "Hexagonal"}}]
```

The square torus is the Cartesian product of two cycles:

```wl
IsomorphicGraphQ[TorusTessellation[{8, 6}, "Square"], GraphProduct[CycleGraph[8], CycleGraph[6], "Cartesian"]]
```

It is the [TessellationGraph]() of type {4, 4} and size {*m*, *n*}, and the 10 × 10 one is the substrate `"SquareTorusGraph"`:

```wl
{IsomorphicGraphQ[TessellationGraph[{4, 4}, {8, 6}], TorusTessellation[{8, 6}, "Square"]],
 Sort @ EdgeList @ InfraSubstrate["SquareTorusGraph", "Small"] === Sort @ EdgeList @ TorusTessellation[{10, 10}, "Square"]}
```
