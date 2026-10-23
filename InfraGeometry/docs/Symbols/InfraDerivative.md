---
Template: Symbol
Name: InfraDerivative
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraDerivative
Keywords: [derivative, Moebius function, Moebius inversion, incidence algebra, finite difference, wave operator, Euler characteristic, causal set, directed acyclic graph]
SeeAlso: [InfraAntiderivative, InfraDifferential, InfraIntegral, InfraMeasurement, SprayGraph]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[InfraDerivative]()[*F*]</code> is the derivative of the vertex function *F*, the inverse of the zeta antiderivative: the Möbius inversion *f(v) = Σ μ(u, v) F(u)*, the sum over the *u ⪯ v*.

<code>[InfraDerivative]()[*F*, [Method]() -> *m*]</code> is the inverse of <code>[InfraAntiderivative]()[*f*, [Method]() -> *m*]</code>.

## Details & Options

The derivative of a method with kernel *K* is the antiderivative with the inverse kernel *K⁻¹*. It inverts [InfraAntiderivative]() exactly, on both sides.

The options [Method](), `"Origin"` and `"Direction"` are those of [InfraAntiderivative](), with the same defaults and the same order on the substrate.

A path kernel *K = (1 − W)⁻¹* has the inverse *1 − W*, a finite difference over the links into *v*: *(DF)(v) = F(v) − Σ W(u, v) F(u)*, the sum over the links *u ⋖ v*. For `"PathCount"` it is *F(v)* minus the sum of *F* just below *v*.

The `"Zeta"` kernel is the zeta function of the order, and its inverse is the Möbius function *μ*. The Möbius derivative reaches past the links: it is local exactly when every interval of the order is a chain. On an interval that is not a chain, all of whose proper subintervals are chains, *μ* is the number of atoms minus 1. The smallest such interval is the diamond, with *μ* = 1 from the bottom to the top.

| Reading | Value |
|---|---|
| `"Function"` | the derivative, an [Association]() *v* -> *(DF)(v)* |
| `"Kernel"` | the [Association]() `{u, v} -> K⁻¹(u, v)` of the nonzero values; for `"Zeta"` the Möbius function |

`All` gives both. An unknown method, an undirected graph without an origin or a directed graph with a cycle leaves the reading unevaluated.

## Basic Examples

The Möbius function *μ(c, v)* of the order from the centre *c*, the derivative of the indicator of *c*. Negative values are drawn as rings. On the grid it is −1 on the four neighbours and 1 on the four diagonal vertices, whose intervals are squares with two atoms. On the mesh a vertex at distance 2 has *μ* = 2: its interval has three atoms:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {mu = InfraMeasurement[g, InfraDerivative[<|c -> 1|>, "Origin" -> c], "Function"]},
    InfraSubstrateHighlight[g, {mu, c}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The Möbius function of the diamond *1 < 2, 3 < 4*. It reaches from the top past the links to the bottom:

```wl
InfraMeasurement[Graph[{1 -> 2, 1 -> 3, 2 -> 4, 3 -> 4}], InfraDerivative[0 &], "Kernel"]
```

The zeta and the path-count derivative of the same function differ at the top by its value at the bottom:

```wl
With[{diamond = Graph[{1 -> 2, 1 -> 3, 2 -> 4, 3 -> 4}]}, {f = <|1 -> 2, 2 -> 3, 3 -> 5, 4 -> 7|>},
  Table[InfraMeasurement[diamond, InfraDerivative[f, Method -> m], "Function"], {m, {"Zeta", "PathCount"}}]]
```

## Properties and Relations

The derivative undoes the antiderivative from the centre, for every method:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small"]}, {c = First @ GraphCenter[g]},
    {f = AssociationMap[Mod[#^2, 11] &, VertexList[g]]},
    AllTrue[{"Zeta", "PathCount", "BackwardRandomWalk", "UniformChain", "ForwardRandomWalk"},
      InfraMeasurement[g, InfraDerivative[InfraAntiderivative[f, Method -> #, "Origin" -> c], Method -> #, "Origin" -> c],
        "Function"] === f &]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

On the product order of *Z²*, the light-cone lattice, the Möbius derivative is the mixed second difference *F(i, j) − F(i − 1, j) − F(i, j − 1) + F(i − 1, j − 1)*, in the null coordinates *i*, *j* the discrete wave operator:

```wl
With[{lattice = RelationGraph[MemberQ[{{1, 0}, {0, 1}}, #2 - #1] &, Tuples[Range[0, 4], 2]]},
  {bigF = AssociationThread[VertexList[lattice], Prime[Range[25]]]},
  {box = {1, -1, -1, 1} . Lookup[bigF, {#, # - {1, 0}, # - {0, 1}, # - {1, 1}}, 0] &},
  InfraMeasurement[lattice, InfraDerivative[bigF], "Function"] === AssociationMap[box, VertexList[lattice]]]
```

P. Hall's theorem: the Möbius derivative of 1 at *v* is *1 − χ*, *χ* the Euler characteristic of the order complex of the strict past of *v*. Over the crown *1, 2 < 3, 4 < 5* that complex is a circle, *χ* = 0, and the value at the top is 1:

```wl
InfraMeasurement[Graph[{1 -> 3, 1 -> 4, 2 -> 3, 2 -> 4, 3 -> 5, 4 -> 5}], InfraDerivative[1 &], "Function"]
```

The path derivatives are local: their kernels live on the diagonal and the links. The Möbius kernel also has the pair {1, 5}, whose interval holds two chains:

```wl
With[{dag = Graph[{1 -> 2, 2 -> 3, 1 -> 3, 1 -> 4, 4 -> 5, 3 -> 5, 5 -> 6, 1 -> 6, 7 -> 5}]},
  {local = Join[List @@@ EdgeList[TransitiveReductionGraph[dag]], {#, #} & /@ VertexList[dag]]},
  Table[m -> Complement[Keys @ InfraMeasurement[dag, InfraDerivative[0 &, Method -> m], "Kernel"], local],
    {m, {"Zeta", "PathCount", "BackwardRandomWalk", "UniformChain", "ForwardRandomWalk"}}]]
```

The backward random walk and the uniform chain kill the constants away from the minimal elements: the derivative of 1 is the indicator of the minimal elements 1 and 7:

```wl
With[{dag = Graph[{1 -> 2, 2 -> 3, 1 -> 3, 1 -> 4, 4 -> 5, 3 -> 5, 5 -> 6, 1 -> 6, 7 -> 5}]},
  Table[m -> InfraMeasurement[dag, InfraDerivative[1 &, Method -> m], "Function"],
    {m, {"BackwardRandomWalk", "UniformChain"}}]]
```
