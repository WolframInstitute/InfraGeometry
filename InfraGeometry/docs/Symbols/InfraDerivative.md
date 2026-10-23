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

<code>[InfraDerivative]()[*F*]</code> is the derivative of the vertex function *F*, the inverse of the zeta antiderivative: the Möbius inversion *f(v) = Σ_(u ⪯ v) μ(u, v) F(u)*. It is a symbolic object; [InfraMeasurement]() evaluates it on a graph.

<code>[InfraDerivative]()[*F*, [Method]() -> *m*]</code> is the inverse of <code>[InfraAntiderivative]()[*f*, [Method]() -> *m*]</code>.

## Details & Options

Definition: the derivative of a method with kernel *K* is the antiderivative with the inverse kernel, *D_K = I_(K^(−1))*, so that *D_K I_K f = f* and *I_K D_K F = F* exactly.

It takes the options of [InfraAntiderivative](), `Method`, `"Origin"` and `"Direction"`, with the same defaults and the same order on the substrate.

A path kernel *K = (1 − W)^(−1)* has the local inverse *1 − W*: *(D F)(v) = F(v) − Σ_(u ⋖ v) W(u, v) F(u)*, a finite difference over the links into *v*. For `"PathCount"` it is *F(v)* minus the sum of *F* over the vertices just below *v*.

The `"Zeta"` kernel is the zeta function of the order, and its inverse is the Möbius function *μ*. The Möbius derivative is local exactly when every interval of the order is a chain. An interval that is not a chain, with every proper subinterval a chain, has two or more atoms; with *c* atoms, *μ = c − 1 ≠ 0* there. The smallest case is the diamond, where *μ* of the bottom and the top is 1.

| Reading | Value |
|---|---|
| `"Function"` | the derivative, an [Association]() *v* -> *(D F)(v)* in the order of `VertexList` |
| `"Kernel"` | the inverse kernel, an [Association]() `{u, v} -> K^(-1)(u, v)` over the pairs *u ⪯ v* with a nonzero value; for `"Zeta"` the Möbius function |

`All` gives both. An unknown method or option, an undirected graph without an origin, or a directed graph with a cycle leaves the reading unevaluated.

## Basic Examples

The Möbius function of the diamond *1 < 2, 3 < 4*: it reaches from the top past the links to the bottom.

```wl
Normal @ InfraMeasurement[Graph[{1, 2, 3, 4}, {1 -> 2, 1 -> 3, 2 -> 4, 3 -> 4}], InfraDerivative[0 &], "Kernel"]
```

The zeta and the path-count derivative of the same function differ at the top by its value at the bottom.

```wl
With[
  {diamond = Graph[{1, 2, 3, 4}, {1 -> 2, 1 -> 3, 2 -> 4, 3 -> 4}], f = <|1 -> 2, 2 -> 3, 3 -> 5, 4 -> 7|>},
  Normal /@ {InfraMeasurement[diamond, InfraDerivative[f], "Function"], InfraMeasurement[diamond, InfraDerivative[f, Method -> "PathCount"], "Function"]}]
```

The derivative undoes the antiderivative from the centre of the discretized plane, the square grid and the hexagonal tiling, for every method.

```wl
SeedRandom[1];
Table[
  With[
    {g = InfraSubstrate[name, "Small"]},
    {c = First @ GraphCenter[g], f = AssociationThread[VertexList[g], RandomInteger[{-9, 9}, VertexCount[g]]]},
    AllTrue[{"Zeta", "PathCount", "BackwardRandomWalk", "UniformChain", "ForwardRandomWalk"},
      InfraMeasurement[g, InfraDerivative[InfraAntiderivative[f, Method -> #, "Origin" -> c], Method -> #, "Origin" -> c], "Function"] === f &]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]
```

## Properties and Relations

On the product order of *Z²*, the light-cone lattice, the Möbius derivative is the mixed second difference *F(i, j) − F(i − 1, j) − F(i, j − 1) + F(i − 1, j − 1)*: in the null coordinates *i*, *j* the discrete wave operator.

```wl
With[
  {lattice = Graph[Flatten[Table[{i, j}, {i, 0, 4}, {j, 0, 4}], 1],
     Flatten @ Table[{If[i < 4, DirectedEdge[{i, j}, {i + 1, j}], Nothing], If[j < 4, DirectedEdge[{i, j}, {i, j + 1}], Nothing]}, {i, 0, 4}, {j, 0, 4}]]},
  {bigF = AssociationThread[VertexList[lattice], Prime[Range[25]]]},
  InfraMeasurement[lattice, InfraDerivative[bigF], "Function"] ===
    AssociationMap[Lookup[bigF, Key[#], 0] - Lookup[bigF, Key[# - {1, 0}], 0] - Lookup[bigF, Key[# - {0, 1}], 0] + Lookup[bigF, Key[# - {1, 1}], 0] &, VertexList[lattice]]]
```

P. Hall's theorem: the Möbius derivative of 1 at *v* is *1 − χ*, *χ* the Euler characteristic of the order complex of the strict past of *v*. Over a crown, whose order complex is a circle, it is 1.

```wl
With[
  {crown = Graph[Range[5], {1 -> 3, 1 -> 4, 2 -> 3, 2 -> 4, 3 -> 5, 4 -> 5}]},
  Normal @ InfraMeasurement[crown, InfraDerivative[1 &], "Function"]]
```

The path derivatives are local: their kernels live on the diagonal and the links. The Möbius derivative is local only where no two chains share their ends.

```wl
With[
  {dag = Graph[Range[6], {1 -> 2, 2 -> 3, 1 -> 4, 4 -> 5, 3 -> 5, 5 -> 6}]},
  {links = List @@@ EdgeList[TransitiveReductionGraph[dag]]},
  Table[m -> AllTrue[Keys @ InfraMeasurement[dag, InfraDerivative[0 &, Method -> m], "Kernel"], SameQ @@ # || MemberQ[links, #] &],
    {m, {"Zeta", "PathCount", "BackwardRandomWalk", "UniformChain", "ForwardRandomWalk"}}]]
```

`"BackwardRandomWalk"` and `"UniformChain"` kill the constants away from the minimal elements: the derivative of 1 is the indicator of the minimal elements.

```wl
SeedRandom[2];
With[
  {dag = Graph[Range[8], DirectedEdge @@@ (Sort /@ RandomSample[Subsets[Range[8], {2}], 12])]},
  {Values @ InfraMeasurement[dag, InfraDerivative[1 &, Method -> "BackwardRandomWalk"], "Function"],
   Values @ InfraMeasurement[dag, InfraDerivative[1 &, Method -> "UniformChain"], "Function"], Boole @ Thread[VertexInDegree[dag] == 0]}]
```
