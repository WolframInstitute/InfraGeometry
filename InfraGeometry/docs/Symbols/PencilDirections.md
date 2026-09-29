---
Template: Symbol
Name: PencilDirections
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/PencilDirections
Keywords: [pencil, ray, direction, unit tangent sphere]
SeeAlso: [PencilCardinality, FindInfraRay, InfraRayQ, LineCount, SameDirectionQ, UniqueCollinearQ]
RelatedGuides: [Experimental]
---

## Usage

<code>[PencilDirections]()[*g*, *O*]</code> gives the pencil at *O*: every ray from *O* in *g*, as a list of vertex sequences.

## Details & Options

The pencil at a vertex *O* is the set of rays from *O* — the graph's analogue of the unit tangent sphere, one element per direction. A ray leaves *O* through exactly one neighbour, so the pencil is the union of <code>[FindInfraRay]()[*g*, *O*, *w*, All]</code> over the neighbours *w* of *O*. It is computed as <code>[FindInfraRay]()[*g*, *O*, *O*, All]</code>, the rays from *O* with *O* as its own direction.

Every element starts at *O* and satisfies [InfraRayQ](). Opposite rays are distinct elements; [SameDirectionQ]() is the predicate that identifies them.

There is no pencil object. [PencilCardinality]() gives the size of the pencil without enumerating it.

## Basic Examples

The pencil at the middle of a path has two rays, one to each leaf.

```wl
PencilDirections[PathGraph[Range[7]], 4]
```

On the 6-cycle both rays from 1 end at the antipode.

```wl
PencilDirections[CycleGraph[6], 1]
```

From the centre of a 3 × 3 grid eight rays leave, two through each neighbour, each ending at a corner.

```wl
PencilDirections[GridGraph[{3, 3}], 5]
```

## Properties and Relations

Every element of the pencil starts at *O* and is a ray.

```wl
With[
  {g = GridGraph[{3, 3}]},
  AllTrue[PencilDirections[g, 5], First[#] === 5 && InfraRayQ[g, #] &]]
```

[PencilCardinality]() counts the same set without enumerating it.

```wl
With[
  {g = HypercubeGraph[3]},
  {Length @ PencilDirections[g, 1], PencilCardinality[g, 1]}]
```

The pencil is the family of rays with the origin as its own direction.

```wl
Sort @ PencilDirections[CycleGraph[6], 1] === Sort @ FindInfraRay[CycleGraph[6], 1, 1, All]
```
