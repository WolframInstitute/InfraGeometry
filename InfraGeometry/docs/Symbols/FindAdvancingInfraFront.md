---
Template: Symbol
Name: FindAdvancingInfraFront
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindAdvancingInfraFront
Keywords: [wavefront, wave equation, foliation, shell, reflection at the rim, Huygens]
SeeAlso: [InfraShell, InfraSphere, InfraBall, InfraBoundary]
---

## Usage

<code>[FindAdvancingInfraFront]()[*g*, *origin*, *k*]</code> gives the fronts *S₀*, *S₁*, …, *Sₖ* of a wave started at *origin*, each a sorted vertex list.

## Details & Options

The wave starts with *S₀ = S₋₁* = the origin. Each vertex *u* of *Sᵢ* steps to its neighbours *w* with *d(w, Sᵢ₋₁) = d(u, Sᵢ₋₁) + 1*. Where there is none, it steps back to its neighbours with *d(w, Sᵢ₋₁) = d(u, Sᵢ₋₁) − 1*, and where there is neither it stays. *Sᵢ₊₁* is the set of all these steps.

The rule is second order: the next front depends on the last two, as in the wave equation.

While the front moves freely it is the shell: *Sᵢ = {v : d(origin, v) = i}*. On the Small square grid this holds up to *i = 4* and on the Small square mesh up to *i = 5*, the distance from the centre to the nearest vertex with no neighbour farther away.

At the rim the front reflects. Unlike the shells, which are empty past the eccentricity, the fronts never empty.

The origin can be a vertex, a vertex list or a density.

## Basic Examples

The front at step 8 from the centre. It has reflected off the rim and runs back inward. On the mesh the shell of radius 8 is empty, past the eccentricity 6:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    InfraSubstrateHighlight[g, {Last @ FindAdvancingInfraFront[g, c, 8], c}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The sizes of the fronts and of the shells on the grid. They agree up to step 4; the shells end at the eccentricity 9, the fronts go on:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  ListLinePlot[{Length /@ FindAdvancingInfraFront[g, c, 12],
    Table[InfraMeasurement[g, InfraShell[c, r], "CountingMeasure"], {r, 0, 12}]},
    DataRange -> {0, 12}, PlotMarkers -> Automatic, PlotLegends -> {"front", "shell"}]]
```

## Scope

A front from a vertex list, a shortest path of length 2. At step 3 it is the shell of the path, the vertices at distance 3 from it:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {path = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], RandomSeeding -> 1]},
  {front = Last @ FindAdvancingInfraFront[g, path, 3]},
  InfraSubstrateHighlight[g, {front, path},
    PlotLabel -> (front == Sort @ Keys @ InfraMeasurement[g, InfraShell[path, 3], "VertexDensity"]),
    ImageSize -> Medium]]
```

## Properties and Relations

While the front moves freely it is the shell:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small"]}, {c = First @ GraphCenter[g]},
    {fronts = FindAdvancingInfraFront[g, c, 8]},
    Table[fronts[[i + 1]] == Sort @ Keys @ InfraMeasurement[g, InfraShell[c, i], "VertexDensity"], {i, 0, 8}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```
