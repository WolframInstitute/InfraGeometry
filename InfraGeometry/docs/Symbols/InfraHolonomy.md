---
Template: Symbol
Name: InfraHolonomy
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraHolonomy
SeeAlso: [InfraFibration, InfraSection, InfraConnection, InfraTotalGraph]
RelatedGuides: [InfraFiberBundles]
---

## Usage

`InfraHolonomy[fib, conn, loop]` gives the transport around a closed walk as Cycles on the positions of the fiber over its first vertex.

## Basic Examples

A random connection of the displacement bundle of a grid, transported around a square.

```wl
With[
  {g = GridGraph[{4, 4}]},
  {fib = InfraDisplacementBundle[g, 2]},
  {conn = (SeedRandom[1]; RandomInfraConnection[fib])},
  InfraHolonomy[fib, conn, {6, 7, 11, 10, 6}]]
```
