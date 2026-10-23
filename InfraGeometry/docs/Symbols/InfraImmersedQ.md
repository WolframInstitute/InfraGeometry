---
Template: Symbol
Name: InfraImmersedQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraImmersedQ
Keywords: [immersion, immersed curve, cusp, backtrack, non-backtracking walk, walk, test]
SeeAlso: [InfraWalkQ, InfraGenericQ, WalkSingularities, RandomInfraWalk, InfraGeodesicQ]
---

## Usage

<code>[InfraImmersedQ]()[*g*, *walk*]</code> gives `True` if *walk* is a walk in *g* without a cusp: it never steps straight back.

## Details & Options

A walk *v₀*, …, *vₖ* is immersed when it is a walk and *vᵢ₋₁ ≠ vᵢ₊₁* for every inner position *i*. This is the non-backtracking walk, the graph analogue of an immersed curve: one that may cross itself but never reverses.

A cusp is the place where *vᵢ₋₁ = vᵢ₊₁*; [WalkSingularities]() lists the cusps under `"Cusps"`.

*walk* is a vertex list, a walk graph, a list of walk graphs, a directed acyclic graph, or a cycle graph. A cycle graph is a closed walk and is tested round the cycle, at its first vertex too.

On the square grid, away from the rim, a vertex starts *4ᵏ* walks of *k* edges and *4 · 3ᵏ⁻¹* immersed ones.

## Basic Examples

A random walk steps back; the walk that may not step back is immersed:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {walk = RandomInfraWalk[g, c, {10}, Properties -> props, RandomSeeding -> 3]},
    InfraSubstrateHighlight[g, {walk, c}, PlotLabel -> InfraImmersedQ[g, walk]]],
  {props, {{}, {{"Simple", 2}}}}]
```

A step back is a cusp:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {InfraImmersedQ[g, {44, 45, 46}], InfraImmersedQ[g, {44, 45, 44}]}]
```

## Scope

A cycle graph is a closed walk. Round a unit square it is immersed; there and back along one edge it is not:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {InfraImmersedQ[g, Graph[{45 -> 46, 46 -> 56, 56 -> 55, 55 -> 45}]],
   InfraImmersedQ[g, Graph[{45 -> 46, 46 -> 45}]]}]
```

## Properties and Relations

The walks of 1 to 4 edges from the centre of the grid, and the immersed ones among them, *4ᵏ* and *4 · 3ᵏ⁻¹*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Table[{Length[#], Count[#, w_ /; InfraImmersedQ[g, w]]} & @ RandomInfraWalk[g, c, {k}, All], {k, 4}]]
```
