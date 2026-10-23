---
Template: Symbol
Name: InfraIntegral
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraIntegral
Keywords: [integral, line integral, region, value density, multi-object, fundamental theorem, flux, Gauss theorem, family of walks]
SeeAlso: [InfraDifferential, InfraCodifferential, InfraAntiderivative, InfraMeasurement, InfraSegment, InfraBall]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[InfraIntegral]()[*f*, *obj*]</code> is the integral of the 0-form or 1-form *f* over the object *obj*: one sum over a region, or one sum along each member of a family of walks. It is a symbolic object; [InfraMeasurement]() evaluates it on a graph.

## Details & Options

Definition: over a region *R*, *∫_R f = Σ_(v ∈ R) f(v)*. Along a walk *γ = (v_0, …, v_k)*, a 0-form gives *∫_γ f = Σ_i f(v_i)*, both ends included, and a 1-form gives *∫_γ ω = Σ_i ω(v_(i−1) → v_i)*.

*obj* is any object [InfraMeasurement]() reads, with no new head for the domain:

| *obj* | Integral |
|---|---|
| a region: a ball, shell, tube or other set head, a vertex, a vertex list, a density | one value, the sum over its support, the keys of its `"VertexDensity"` |
| a family of walks: a segment, ray, line, open arc, or any head whose `"Graph"` is a directed acyclic graph or a `List` of alternative ones | one value per member, a chain of the graph from a source to a sink |

A head of another paclet works the same way when that paclet is loaded, such as the light cones and worldlines of InfraCausality. Polylines, closed arcs and circles stay unevaluated: their `List` of graphs holds factors of one member, or a copy of a vertex.

*f* is a 0-form, an [Association]() *v* -> *x* or a function applied to each vertex, or a 1-form, an [Association]() `DirectedEdge[u, v] -> x` read antisymmetrically. A missing key counts as 0. A head with a `"Function"` reading is read through it: <code>[InfraDifferential]()[*h*]</code> is a 1-form, [InfraCodifferential](), [InfraAntiderivative]() and [InfraDerivative]() are 0-forms.

| Reading | Region | Family of walks |
|---|---|---|
| `"Value"` | the sum over the support | the common value of the members, or the sorted `List` of their distinct values |
| `"ValueDensity"` | `<|value -> 1|>` | `<|x -> number of members whose integral is x|>` |
| `"Mean"` | the value | the mean over the members; unevaluated when there is none |
| `"Cardinality"` | 1 | the number of members |
| `"Flux"` | for a 1-form, its values on the edges entering the region minus those on the edges leaving it | — |

`All` gives the readings that apply. The value density is computed by one forward sweep of the graph, which carries the distribution of the partial integrals at every vertex, never by enumerating the members. The mean reads the occupation densities of the object.

Along a family of walks the integral is itself a multi-object, one value per member, which the value density records. The integral of a differential has one value: *∫_γ df = f(q) − f(p)* on every member from *p* to *q*.

## Basic Examples

The integral of a differential along a segment, on the discretized plane, the square grid and the hexagonal tiling: every shortest path from *p* to *q* has the integral *f(q) − f(p)*, so the value density is a single atom carrying all of them.

```wl
SeedRandom[1];
Row[Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {p = First @ GraphCenter[g]},
    {q = RandomInfraPoint[g, InfraShell[p, 5]], f = AssociationThread[VertexList[g], RandomInteger[{-9, 9}, VertexCount[g]]]},
    Labeled[InfraSubstrateHighlight[g, {InfraSegment[p, q], p, q}],
      Normal @ InfraMeasurement[g, InfraIntegral[InfraDifferential[f], InfraSegment[p, q]], "ValueDensity"]]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]]
```

The integral of a function along the same segment of the square grid is a multi-object: its value density, one bar per value, counts the shortest paths with each value.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 5]], f = AssociationThread[VertexList[g], RandomInteger[{-9, 9}, VertexCount[g]]]},
  {density = InfraMeasurement[g, InfraIntegral[f, InfraSegment[p, q]], "ValueDensity"]},
  BarChart[Values[density], ChartLabels -> Keys[density]]]
```

Over a region the integral is the sum over its support: the integral of 1 over a ball is its volume.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small"]},
  {ball = InfraBall[First @ GraphCenter[g], 3]},
  {InfraMeasurement[g, InfraIntegral[1 &, ball], "Value"], InfraMeasurement[g, ball, "CountingMeasure"]}]
```

## Scope

A ray and a line have many ends. The integral of a differential has one value per pair of ends.

```wl
SeedRandom[2];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2]], f = AssociationThread[VertexList[g], RandomInteger[{-9, 9}, VertexCount[g]]]},
  {InfraSubstrateHighlight[g, {InfraHalfLine[p, q], p, q}],
   Length @ InfraMeasurement[g, InfraIntegral[InfraDifferential[f], InfraHalfLine[p, q]], "ValueDensity"],
   InfraMeasurement[g, InfraHalfLine[p, q], "Cardinality"]}]
```

Any head whose `"Graph"` is a directed acyclic graph is integrated along its chains. Here a head named in this example gives the chains of the light-cone lattice from (0, 0) to (6, 6): the differential of *f(i, j) = i j* has the value 36 on all 924 of them.

```wl
ClearAll[chainsHead];
chainsHead /: InfraMeasurement[graph_Graph, chainsHead[p_, q_], "Graph"] :=
  TransitiveReductionGraph @ Subgraph[graph, Intersection[VertexOutComponent[graph, {p}], VertexInComponent[graph, {q}]]];
With[
  {lattice = Graph[Flatten[Table[{i, j}, {i, 0, 6}, {j, 0, 6}], 1],
     Flatten @ Table[{If[i < 6, DirectedEdge[{i, j}, {i + 1, j}], Nothing], If[j < 6, DirectedEdge[{i, j}, {i, j + 1}], Nothing]}, {i, 0, 6}, {j, 0, 6}]]},
  Normal @ InfraMeasurement[lattice, InfraIntegral[InfraDifferential[Apply[Times]], chainsHead[{0, 0}, {6, 6}]], "ValueDensity"]]
```

## Properties and Relations

The mean along a family is the mean of the value density, and the cardinality its total.

```wl
SeedRandom[3];
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small"]},
  {p = First @ GraphCenter[g]},
  {line = InfraInfiniteLine[p, RandomInfraPoint[g, InfraShell[p, 2]]], f = AssociationThread[VertexList[g], RandomInteger[{-9, 9}, VertexCount[g]]]},
  {density = InfraMeasurement[g, InfraIntegral[f, line], "ValueDensity"]},
  {InfraMeasurement[g, InfraIntegral[f, line], "Mean"] == Total[Keys[density] Values[density]] / Total[density],
   InfraMeasurement[g, InfraIntegral[f, line], "Cardinality"] == Total[density] == InfraMeasurement[g, line, "Cardinality"]}]
```

Gauss: the integral of the codifferential over a region is the flux through its boundary.

```wl
SeedRandom[4];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small"]},
  {omega = AssociationThread[DirectedEdge @@@ EdgeList[g], RandomInteger[{-5, 5}, EdgeCount[g]]], region = InfraShell[First @ GraphCenter[g], {2, 4}]},
  {InfraMeasurement[g, InfraIntegral[InfraCodifferential[omega], region], "Value"], InfraMeasurement[g, InfraIntegral[omega, region], "Flux"]}]
```

The uniform-chain antiderivative from an origin is the mean along the shortest paths from it, and the zeta antiderivative the sum over the interval.

```wl
SeedRandom[5];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small"]},
  {c = First @ GraphCenter[g], f = AssociationThread[VertexList[g], RandomInteger[{-9, 9}, VertexCount[g]]]},
  {q = RandomInfraPoint[g, InfraShell[c, 4]]},
  {InfraMeasurement[g, InfraAntiderivative[f, Method -> "UniformChain", "Origin" -> c], "Function"][q] == InfraMeasurement[g, InfraIntegral[f, InfraSegment[c, q]], "Mean"],
   InfraMeasurement[g, InfraAntiderivative[f, "Origin" -> c], "Function"][q] == InfraMeasurement[g, InfraIntegral[f, InfraMeasurement[g, InfraSegment[c, q], "VertexDensity"]], "Value"]}]
```

## Possible Issues

On a directed acyclic graph a 1-form lives on the links. A walk along an implied edge, which a longer chain also joins, finds no value there and counts 0: integrate along the chains of the order, as the heads of a causal set do.

A polyline is not a family of alternatives, and its integral stays unevaluated. Integrate its pieces one by one.

```wl
With[
  {g = GridGraph[{5, 5}]},
  {Head @ InfraMeasurement[g, InfraIntegral[#^2 &, InfraSegment[1, 13, 25]], "Value"],
   InfraMeasurement[g, InfraIntegral[#^2 &, InfraSegment @@ #], "Value"] & /@ {{1, 13}, {13, 25}}}]
```
