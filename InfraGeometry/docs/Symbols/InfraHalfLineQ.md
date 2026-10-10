---
Template: Symbol
Name: InfraHalfLineQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraHalfLineQ
Keywords: [ray, half-line, shortest path, inextensible, predicate]
SeeAlso: [InfraHalfLine, RandomInfraHalfLine, InfraSegmentQ, InfraInfiniteLineQ]
RelatedGuides: [Experimental]
---

## Usage

<code>[InfraHalfLineQ]()[*g*, *ray*]</code> tests whether *ray* is a ray in *g*: a shortest path from its own first vertex that cannot be prolonged past its last.

<code>[InfraHalfLineQ]()[*g*, {*ray1*, …}]</code> tests every ray of a list, such as the one <code>[RandomInfraHalfLine]()[*g*, *O*, *v*, All]</code> returns.

## Details & Options

Two conditions, and the asymmetry between them is the whole definition:

| Condition | Why |
|---|---|
| the sequence is a shortest path | a ray is straight, so [InfraSegmentQ]() must hold |
| no neighbour of the last vertex sits one step farther from the first | the far end is inextensible |

Inextensibility is required **only at the far end**. The origin is an endpoint by fiat — that is exactly what distinguishes a ray from a line ([InfraInfiniteLineQ]() asks for inextensibility at both ends), and it means a ray may start anywhere, not only at a peripheral vertex.

Sequences shorter than two vertices are `False`: a single vertex has no direction.

The predicate is the companion of [RandomInfraHalfLine](), which prolongs a shortest path outward until no neighbour prolongs it, so every ray that finder returns satisfies it.

## Basic Examples

On a path the whole graph is a ray from either end.

```wl
InfraHalfLineQ[PathGraph[Range[5]], {1, 2, 3, 4, 5}]
```

A proper initial segment is not — it can still be prolonged.

```wl
InfraHalfLineQ[PathGraph[Range[5]], {1, 2, 3}]
```

But a ray need not begin at the periphery. This one starts in the middle and runs to the leaf.

```wl
InfraHalfLineQ[PathGraph[Range[5]], {3, 4, 5}]
```

## Properties and Relations

Every ray [RandomInfraHalfLine]() produces satisfies the predicate; the list is accepted as a whole.

```wl
SeedRandom[1];
With[
  {g = GridGraph[{5, 5}]},
  InfraHalfLineQ[g, RandomInfraHalfLine[g, 1, 13, All]]]
```

Dropping the far vertex breaks inextensibility, so the truncation is no longer a ray.

```wl
SeedRandom[1];
With[
  {g = GridGraph[{5, 5}]},
  {ray = RandomInfraHalfLine[g, 1, 13]},
  {InfraHalfLineQ[g, ray], InfraHalfLineQ[g, Most @ ray]}]
```

A ray is a shortest path that stops only because it must; a walk right round a cycle is not a shortest path at all.

```wl
InfraHalfLineQ[CycleGraph[6], {1, 2, 3, 4, 5, 6}]
```

Every ray of a pencil satisfies the predicate.

```wl
SeedRandom[1];
With[
  {g = GridGraph[{3, 3}]},
  AllTrue[RandomInfraHalfLine[g, 5, 5, All], InfraHalfLineQ[g, #] &]]
```
