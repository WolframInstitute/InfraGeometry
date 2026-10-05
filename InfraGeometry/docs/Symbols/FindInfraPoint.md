---
Template: Symbol
Name: FindInfraPoint
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraPoint
Keywords: [point, atom, candidate pool, centre, periphery]
SeeAlso: [InfraPoint, InfraDensity, SelectInfraPoint, FindInfraMidpoint, FindClosestInfraPoint]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[FindInfraPoint]()[*g*]</code> gives one point of *g*, as a vertex.

<code>[FindInfraPoint]()[*g*, *n*]</code> gives *n* points, as a vertex list. Exactly *n* or `$Failed`; `UpTo[n]` gives up to *n*; `All` gives every vertex of the pool.

## Details & Options

Definition: a point of *g* drawn from the `"From"` candidate pool.

The count always means **how many points you get**; the `"Distance"` option constrains **which** ones. With a distance condition the returned list is therefore one mutually-constrained tuple — three points pairwise at maximum distance is a joint condition, and a plain vertex list states it without ambiguity.

The whole pool is <code>[FindInfraPoint]()[*g*, All]</code>, a vertex list.

Options:

| Option | Values |
|---|---|
| `"From"` | `"Random"` (default), `"Center"`, `"Periphery"`, `{"Center", cap}`, or `anchor -> spec` |
| `"Distance"` | *d*, `{dMin, dMax}`, `"Max"`, `"Spread"` |
| `"MaxCliques"` | bound on the mutual-distance clique search |

`"Center"` and `"Periphery"` are meant in the graph-eccentricity sense. `"Distance"` imposes a mutual-distance condition on a tuple.

To keep a whole construction interior, not just its anchors, cut the substrate with `CenterGraph[g, k]` and work on that graph: it is the ball of `k` hops about `GraphCenter[g]`, a negative `k` counting back from the radius and `Scaled[q]` taking the fraction `q` of it, and it carries the same vertex labels and coordinates, so the result draws on the original. Restricting `"From"` alone pins only the anchors; a construction with slack spends it outward.

To narrow a bundle you already hold, use [SelectInfraPoint](). It takes the same `"From"` and `"Distance"` vocabulary on a supplied vertex set.

The draw is random: seed with `SeedRandom` before the first call if you need a reproducible figure.

Corresponding notions in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Definition 1 | A point is that of which there is no part. |
| Hilbert | Group I | Points are one of the three primitive kinds of object. |
| Tarski | primitive | Variables range over points. There is no other sort. |
| Birkhoff | Ruler postulate | Points are what the reals coordinate. |

## Basic Examples

One point is a vertex. `SeedRandom` in front fixes the draw.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {p = (SeedRandom[1]; FindInfraPoint[g])},
  {InfraSubstrateHighlight[g, {p}], p}]
```

The calling triple gives a list of vertices: here five of them.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {points = (SeedRandom[1]; FindInfraPoint[g, 5])},
  {InfraSubstrateHighlight[g, {points}], points}]
```

`"From"` selects the metrically special vertices. The centre is one vertex, and the periphery of a patch is its rim.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {centre = FindInfraPoint[g, All, "From" -> "Center"]},
  {periphery = FindInfraPoint[g, All, "From" -> "Periphery"]},
  {InfraSubstrateHighlight[g, {periphery, centre}],
   centre, Length @ periphery}]
```

Keeping a draw off the rim. The balls about the centre are nested: `-1` drops the outer layer, `Scaled[0.4]` keeps the inner 40% of the radius.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  InfraSubstrateHighlight[g,
    {VertexList @ CenterGraph[g, -1],
     VertexList @ CenterGraph[g, Scaled[0.4]]}]]
```

A tuple of three mutually most-distant points.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {corners = (SeedRandom[1]; FindInfraPoint[g, 3, "Distance" -> "Max"])},
  {InfraSubstrateHighlight[g, {corners}], corners}]
```
