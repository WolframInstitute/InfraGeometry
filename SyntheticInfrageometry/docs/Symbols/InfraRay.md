---
Template: Symbol
Name: InfraRay
Context: WolframInstitute`SyntheticInfrageometry`
ContextPath: [WolframInstitute`Infrageometry`]
Paclet: WolframInstitute/SyntheticInfrageometry
URI: WolframInstitute/SyntheticInfrageometry/ref/InfraRay
Keywords: [ray, half-line, direction, pool, wrapper]
SeeAlso: [FindInfraRay, InfraRayQ, PencilDirections, InfraLine, InfraSegment]
RelatedGuides: [EuclideanGeometryGuide]
---

## Usage

<code>[InfraRay]()[*g*, *o*, *v*]</code> is the pool of rays from *o* through *v* on the graph *g* as one object: every geodesic from *o* through *v* that cannot be prolonged past its last vertex, carried as one DAG with source *o*.

<code>[InfraRay]()[*g*, *o*]</code> is the pencil at *o*: every ray from *o*.

<code>[InfraRay]()[*o*, *v*]</code> inside an [InfraScene]() is the ray construction token; [FindInfraRay]() is the search.

`ray[[i]]`, `ray[[i ;; j]]` and `Normal[ray]` enumerate the rays in canonical order; `ray["Multiplicity"]`, `ray["InfraDensity"]`, `ray["Length"]` (the lengths present, since rays end on several layers), `ray["Graph"]` read the DAG.

## Details & Options

[FindInfraRay]() returns the enumerated form for a bounded count and the pool form for `All`. Every ray begins at the base vertex *O*; rays to different sinks differ in length, so `["Length"]` on the pool lists one length per ray, read off the sink layers and the path counts rather than by enumeration.

Accessors on either form:

| Accessor | Gives |
|---|---|
| `["Realizations"]` | the rays as vertex sequences; on the pool `["Realizations", n]`, `UpTo[n]` or `All` enumerates lazily |
| `["Length"]` | one edge count per ray |
| `["Multiplicity"]` | how many rays the object holds |
| `["Measure"]` | the per-vertex occupation, the fraction of rays through each vertex |
| `["Graph"]` | the DAGs of the pool |
| `["Vertices"]` | the vertices covered |
| `["First"]` | one ray |

Rendered like [InfraSegment]() by [InfraSceneHighlight]() — sequential-edge semantics.

Inside an [InfraScene](), <code>[InfraRay]()[*O*, *v*]</code> names a ray to be solved for.

## Basic Examples

`All` gives the pool: one DAG carrying the five rays from 6 through 7 on the grid.

```wl
With[
  {rays = FindInfraRay[GridGraph[{4, 4}], 6, 7, All]},
  {Length @ rays["Graph"], rays["Multiplicity"], rays["Length"]}]
```

A bounded count gives the enumerated form.

```wl
FindInfraRay[GridGraph[{4, 4}], 6, 7, 2, Method -> "Greedy"]
```

## Properties and Relations

The origin lies on every ray, so its measure is 1.

```wl
FindInfraRay[GridGraph[{4, 4}], 6, 7, All]["Measure"][6]
```
