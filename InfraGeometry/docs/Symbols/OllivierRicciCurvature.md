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

<code>[OllivierRicciCurvature]()[*g*]</code> gives the association of every edge *u* ⟷ *v* of *g* with its Ollivier–Ricci curvature *κ(u, v) = 1 − W₁(μᵤ, μᵥ)*.

## Details & Options

Here *μₓ* is the uniform probability on the neighbours of *x*, with no mass on *x*, and *W₁* is the earth mover's distance: the least cost *Σ π(x, y) d(x, y)* of a coupling *π* of *μᵤ* and *μᵥ*. For an edge *d(u, v) = 1*, so *κ = 1 − W₁/d(u, v)*.

The curvature is positive where the neighbourhoods of the two ends are close, as across triangles, and negative where they are far apart, as on a tree. Every neighbour of *u* is within distance 3 of every neighbour of *v*, so *−2 ≤ κ < 1*.

Closed forms:

| Graph | *κ(u, v)* |
|---|---|
| square lattice, square torus | 0 |
| complete graph *Kₙ* | *(n − 2)/(n − 1)* |
| tree | *−2(1 − 1/deg u − 1/deg v)* where this is negative, 0 elsewhere |

The values are machine numbers from a linear program, and an exact 0 can come out as 10⁻¹⁶.

## Basic Examples

The curvature of every edge, blue where it is positive, gray where it is 0 and red where it is negative. On the square grid it is 0, except −1/2 on the edges whose two ends both have a neighbour on the rim:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {kappa = OllivierRicciCurvature[g]},
    InfraSubstrateHighlight[g,
      KeyValueMap[InfraWalk[List @@ #1] -> Blend[{StandardRed, StandardGray, StandardBlue}, (#2 + 1)/2] &, kappa],
      PlotLabel -> MinMax[Rationalize[Values[kappa], 10^-9]]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

Without a rim the curvature is 0 on the square torus and nonnegative on the sphere mesh:

```wl
Table[MinMax @ Rationalize[Values @ OllivierRicciCurvature[InfraSubstrate[name, "Small"]], 10^-9],
  {name, {"SquareTorusGraph", "SphereMeshGraph"}}]
```

## Scope

The curvature at the centre of the tiling by triangles with *q* at each vertex, against the combinatorial curvature [TessellationCurvature](). Both are positive below 6, 0 at 6 and negative above:

```wl
ListLinePlot[{
   Table[With[{g = TessellationNeighborhoodGraph[{3, q}, 3]}, {c = First @ GraphCenter[g]},
     {q, First @ Rationalize[Values @ KeySelect[OllivierRicciCurvature[g], MemberQ[#, c] &], 10^-9]}],
     {q, 3, 9}],
   Table[{q, TessellationCurvature[{3, q}]}, {q, 3, 9}]},
  PlotMarkers -> Automatic, PlotLegends -> {"Ollivier-Ricci", "combinatorial"}]
```

The five Platonic solids. Every edge has the same curvature: 2/3, 1/2 and 1/5 on the tetrahedron, octahedron and icosahedron, 0 on the cube, −1/3 on the dodecahedron:

```wl
Table[Union @ Rationalize[Values @ OllivierRicciCurvature[g], 10^-9],
  {g, {CompleteGraph[4], CompleteGraph[{2, 2, 2}], GraphData["IcosahedralGraph"], HypercubeGraph[3],
    GraphData["DodecahedralGraph"]}}]
```

## Properties and Relations

On the complete graph the two neighbourhoods differ in the two ends only, and *κ = (n − 2)/(n − 1)*:

```wl
Table[Union @ Rationalize[Values @ OllivierRicciCurvature[CompleteGraph[n]], 10^-9] == {(n - 2)/(n - 1)},
  {n, 3, 9}]
```

On a tree the curvature depends only on the degrees of the two ends. On the binary tree it is −2/3 between two inner vertices, −1/3 at the root and 0 at the leaves:

```wl
With[{g = KaryTree[15]}, {kappa = OllivierRicciCurvature[g]},
  {formula = Min[0, -2 (1 - 1/VertexDegree[g, #[[1]]] - 1/VertexDegree[g, #[[2]]])] & /@ Keys[kappa]},
  {Union @ Rationalize[Values[kappa], 10^-9], Max @ Abs[Values[kappa] - formula] < 10^-9}]
```

## Possible Issues

The values are machine numbers, and an exact 0 can come out as a tiny number. On the square mesh 28 of the 51 edges of curvature 0 carry 1.1 × 10⁻¹⁶; compare with a tolerance or use [Rationalize]():

```wl
With[{kappa = Values @ OllivierRicciCurvature[InfraSubstrate["SquareMeshGraph", "Small"]]},
  Counts @ Select[kappa, Abs[#] < 10^-10 &]]
```

On a small closed surface the neighbourhoods of an edge can meet around the surface. The Klein quartic is a quotient of the tiling by triangles with 7 at each vertex, but its curvature is 1/7, not −2/7:

```wl
Union @ Rationalize[Values @ OllivierRicciCurvature[TessellationGraph[{3, 7}]], 10^-9]
```
