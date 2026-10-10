---
Template: Symbol
Name: InfraRayQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraRayQ
Keywords: [ray, half-line, shortest path, inextensible, predicate]
SeeAlso: [InfraRay, RandomInfraRay, InfraSegmentQ, InfraLineQ]
RelatedGuides: [Experimental]
---

## Usage

<code>[InfraRayQ]()[*g*, *ray*]</code> tests whether *ray* is a ray in *g*: a shortest path from its own first vertex that cannot be prolonged past its last.

<code>[InfraRayQ]()[*g*, {*ray1*, …}]</code> tests every ray of a list, such as the one <code>[RandomInfraRay]()[*g*, *O*, *v*, All]</code> returns.

## Details & Options

This is the legacy compatibility spelling. New code uses `InfraHalfLineQ`.

Two conditions, and the asymmetry between them is the whole definition:

| Condition | Why |
|---|---|
| the sequence is a shortest path | a ray is straight, so [InfraSegmentQ]() must hold |
| no neighbour of the last vertex sits one step farther from the first | the far end is inextensible |

Inextensibility is required **only at the far end**. The origin is an endpoint by fiat — that is exactly what distinguishes a ray from a line ([InfraLineQ]() asks for inextensibility at both ends), and it means a ray may start anywhere, not only at a peripheral vertex.

Sequences shorter than two vertices are `False`: a single vertex has no direction.

The predicate is the companion of [RandomInfraRay](), which prolongs a shortest path outward until no neighbour prolongs it, so every ray that finder returns satisfies it.

## Basic Examples

On a path the whole graph is a ray from either end.

```wl
InfraRayQ[PathGraph[Range[5]], {1, 2, 3, 4, 5}]
```

A proper initial segment is not — it can still be prolonged.

```wl
InfraRayQ[PathGraph[Range[5]], {1, 2, 3}]
```

But a ray need not begin at the periphery. This one starts in the middle and runs to the leaf.

```wl
InfraRayQ[PathGraph[Range[5]], {3, 4, 5}]
```

## Properties and Relations

Every ray [RandomInfraRay]() produces satisfies the predicate; the list is accepted as a whole.

```wl
SeedRandom[1];
With[
  {g = GridGraph[{5, 5}]},
  InfraRayQ[g, RandomInfraRay[g, 1, 13, All]]]
```

Dropping the far vertex breaks inextensibility, so the truncation is no longer a ray.

```wl
SeedRandom[1];
With[
  {g = GridGraph[{5, 5}]},
  {ray = RandomInfraRay[g, 1, 13]},
  {InfraRayQ[g, ray], InfraRayQ[g, Most @ ray]}]
```

A ray is a shortest path that stops only because it must; a walk right round a cycle is not a shortest path at all.

```wl
InfraRayQ[CycleGraph[6], {1, 2, 3, 4, 5, 6}]
```

Every ray of a pencil satisfies the predicate.

```wl
SeedRandom[1];
With[
  {g = GridGraph[{3, 3}]},
  AllTrue[RandomInfraRay[g, 5, 5, All], InfraRayQ[g, #] &]]
```
