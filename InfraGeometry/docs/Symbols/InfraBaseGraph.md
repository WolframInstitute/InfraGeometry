---
Template: Symbol
Name: InfraBaseGraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraBaseGraph
Keywords: [base graph, base space, fibered graph]
SeeAlso: [InfraBaseSpace, InfraFiberedGraph, InfraTotalSpace, InfraProjection]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraBaseGraph]()[*fib*]</code> is another name for <code>[InfraBaseSpace]()[*fib*]</code>, the base graph of the fibered graph *fib*.

## Details & Options

The base has the projected vertices, and *p ≠ q* are adjacent iff some total edge joins the fiber over *p* to the fiber over *q*. [InfraBaseSpace]() has the details.

## Basic Examples

The base of the displacement bundle of the square grid, under both names:

```wl
With[{fib = InfraDisplacementBundle[InfraSubstrate["SquareGridGraph", "Small"], 1]},
  InfraBaseGraph[fib] === InfraBaseSpace[fib]]
```
