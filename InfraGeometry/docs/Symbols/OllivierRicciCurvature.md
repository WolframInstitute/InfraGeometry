---
Template: Symbol
Name: OllivierRicciCurvature
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/OllivierRicciCurvature
Keywords: [Ollivier-Ricci curvature, coarse Ricci curvature, Wasserstein distance, earth mover's distance, optimal transport, discrete curvature]
SeeAlso: [EffectiveResistance, TessellationCurvature, DisplacementPlot]
RelatedGuides: [Experimental]
---

## Usage

<code>[OllivierRicciCurvature]()[*g*]</code> gives the association of every edge {*u*, *v*} of *g* with its Ollivier–Ricci curvature κ(*u*, *v*) = 1 − *W*₁(μᵤ, μᵥ), where μₓ is the uniform measure on the neighbours of *x*.

## Details & Options

Definition: for an edge {*u*, *v*}, κ(*u*, *v*) = 1 − *W*₁(μᵤ, μᵥ)/*d*(*u*, *v*), with *d*(*u*, *v*) = 1. Here μₓ is the uniform probability on the neighbours of *x*, with no mass on *x* itself, and *W*₁ is the earth mover's distance: the least cost Σ π(*x*, *y*) *d*(*x*, *y*) of a coupling π of μᵤ and μᵥ. Each edge costs one [LinearOptimization]().

Every neighbour of *u* lies within distance 3 of every neighbour of *v*, so −2 ≤ κ, and κ < 1. The curvature is positive where the two neighbourhoods are close, as across triangles, and negative where they are far apart, as in a tree.

On the complete graph with *n* vertices κ = (*n* − 2)/(*n* − 1). On a tree, κ(*u*, *v*) = −2(1 − 1/deg *u* − 1/deg *v*) where this is negative, and 0 elsewhere.

The values are machine numbers from a linear program, with the rounding noise of one: an exact 0 may come out as 10⁻¹⁶. The marginals are machine numbers on purpose, the program being twenty times as fast as with exact ones.

## Basic Examples

The curvature of every edge of the square, hexagonal and triangular tilings, blue where it is positive, gray where it is 0 and red where it is negative, and its values. Away from the rim it is 0 on the square and triangular tilings and −2/3 on the hexagonal one.

```wl
With[
  {graphs = InfraSubstrate[#, "Small", "KeepCoordinates" -> True] & /@ {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}},
  {curvatures = OllivierRicciCurvature /@ graphs},
  {GraphicsRow[MapThread[
     {g, kappa} |-> InfraSubstrateHighlight[g, KeyValueMap[{edge, k} |-> InfraWalk[List @@ edge] -> Blend[{StandardRed, StandardGray, StandardBlue}, (k + 1)/2], kappa]],
     {graphs, curvatures}]],
   Union[Rationalize[Values[#], 10^-9]] & /@ curvatures}]
```

The curvature of the edges at the centre of the tilings by *q* triangles at each vertex, against their combinatorial curvature, [TessellationCurvature](). Both are positive below 6 triangles, 0 at 6 and negative above.

```wl
With[
  {curvatures = Table[
     With[
       {g = TessellationNeighborhoodGraph[{3, q}, 3]},
       {c = First @ GraphCenter[g]},
       {q, First @ Union @ Rationalize[Values @ KeySelect[OllivierRicciCurvature[g], MemberQ[#, c] &], 10^-9]}],
     {q, 3, 9}]},
  {ListLinePlot[{curvatures, Table[{q, TessellationCurvature[{3, q}]}, {q, 3, 9}]},
    PlotLegends -> {"Ollivier-Ricci", "combinatorial"}, AxesLabel -> {"q", "curvature"}], Last /@ curvatures}]
```

## Scope

The five Platonic solids. Every edge of a solid has the same curvature: 2/3 on the tetrahedron, 1/2 on the octahedron, 1/5 on the icosahedron, 0 on the cube and −1/3 on the dodecahedron.

```wl
With[
  {solids = {CompleteGraph[4], GraphData["OctahedralGraph"], GraphData["IcosahedralGraph"], HypercubeGraph[3], GraphData["DodecahedralGraph"]}},
  {GraphicsRow[solids], Union[Rationalize[Values[OllivierRicciCurvature[#]], 10^-9]] & /@ solids}]
```

## Properties and Relations

On a tree the curvature of an edge depends only on the degrees of its ends, −2(1 − 1/deg *u* − 1/deg *v*) where this is negative and 0 elsewhere: on the binary tree, −2/3 between two inner vertices, −1/3 at the root and 0 at the leaves.

```wl
With[
  {g = KaryTree[15]},
  {kappa = OllivierRicciCurvature[g]},
  {InfraSubstrateHighlight[g, KeyValueMap[{edge, k} |-> InfraWalk[List @@ edge] -> Blend[{StandardRed, StandardGray, StandardBlue}, (k + 1)/2], kappa]],
   Union[Rationalize[Values[kappa], 10^-9]],
   Max[Abs[Values[kappa] - (Min[0, -2 (1 - 1/VertexDegree[g, First[#]] - 1/VertexDegree[g, Last[#]])] & /@ Keys[kappa])]] < 10^-9}]
```

On the complete graph with *n* vertices the curvature is (*n* − 2)/(*n* − 1): the neighbourhoods of the two ends of an edge differ only in the two ends, so a mass 1/(*n* − 1) moves one step.

```wl
With[
  {g = CompleteGraph[6]},
  {g, Table[Union[Rationalize[Values[OllivierRicciCurvature[CompleteGraph[n]]], 10^-9]] == {(n - 2)/(n - 1)}, {n, 3, 9}]}]
```

## Possible Issues

The values are machine numbers, and an exact 0 may come out as a tiny one. On the triangular tiling 71 of the 138 edges of curvature 0, orange, have 1.1 × 10⁻¹⁶; compare with a tolerance, or [Rationalize]() as here.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {kappa = OllivierRicciCurvature[g]},
  {InfraSubstrateHighlight[g, InfraWalk[List @@ #] -> StandardOrange & /@ Keys[Select[kappa, 0 < Abs[#] < 10^-10 &]]],
   Counts[Values[Select[kappa, Abs[#] < 10^-10 &]]]}]
```

On a small closed surface the neighbourhoods of an edge can meet around the surface. The Klein quartic is a quotient of the tiling by seven triangles at each vertex, but its curvature is 1/7, while on the tiling it is −2/7.

```wl
With[
  {g = TessellationGraph[{3, 7}]},
  {g, Union[Rationalize[Values[OllivierRicciCurvature[g]], 10^-9]]}]
```
