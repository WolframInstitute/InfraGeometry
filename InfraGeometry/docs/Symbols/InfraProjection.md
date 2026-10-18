---
Template: Symbol
Name: InfraProjection
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraProjection
Keywords: [projection, association, literal vertex, fibered graph]
SeeAlso: [InfraFiberedGraph, InfraTotalSpace, InfraBaseSpace, InfraFibrationAssociation, InfraFibers]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraProjection]()[*fib*]</code> gives the projection of *fib* as an association from total vertices to base vertices.

## Details & Options

- An association projection must cover exactly the total vertices. A function projection is evaluated on each total vertex.
- Every vertex label is one literal key, including a list or an expression containing a pattern.
- Use <code>[Lookup]()[*projection*, [Key]()[*vertex*]]</code> to read one literal vertex, and <code>[Lookup]()[*projection*, [Key]() /@ *vertices*]</code> for an ordered vertex list.
- The Experimental tangent and displacement models project to the first vertex of a ray or pair. The cotangent model projects to the last vertex of its reversed ray.
- [InfraFibrationAssociation]() is the compatibility spelling.

## Basic Examples

A projection with list-valued total vertices.

```wl
SeedRandom[ 7 ];
With[ { total = GraphProduct[ CycleGraph[ 4 ], PathGraph[ { 1, 2 } ], "Cartesian" ] },
  { fib = InfraFiberedGraph[ total, First ] },
  { InfraFiberedGraphHighlight[ fib, { InfraFiber[ fib, 1 ] } ],
    Lookup[ InfraProjection[ fib ], Key[ { 1, 2 } ] ] } ]
```
