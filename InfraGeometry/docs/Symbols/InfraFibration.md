---
Template: Symbol
Name: InfraFibration
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraFibration
Keywords: [fibered graph, older name, InfraFiberedGraph]
SeeAlso: [InfraFiberedGraph, InfraFibrationQ, InfraTotalSpace, InfraBaseSpace, InfraProjection]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraFibration]()[*total*, *proj*]</code> is the older name of <code>[InfraFiberedGraph]()[*total*, *proj*]</code>, the fibered graph with total graph *total* and projection *proj*.

<code>[InfraFibration]()[*model*]</code> gives the fibered graph of a construction such as <code>[InfraDisplacementBundle]()[*g*, *r*]</code> under this name.

## Details & Options

Use [InfraFiberedGraph]() in new code. Every function that reads a fibered graph accepts both heads and gives the same result.

The name does not mean the lifting property holds. [InfraFibrationQ]() tests it.

## Basic Examples

The cycle of length 8 over the cycle of length 4, with the fiber over 1:

```wl
With[{fib = InfraFibration[CycleGraph[8], v |-> Mod[v, 4, 1]]},
  InfraFiberedGraphHighlight[fib, {InfraFiber[fib, 1]}, ImageSize -> Medium]]
```

## Properties and Relations

The readers do not see the head:

```wl
With[{old = InfraFibration[CycleGraph[8], v |-> Mod[v, 4, 1]]}, {new = InfraFiberedGraph[First @ old, Last @ old]},
  {InfraFibers[old] === InfraFibers[new], InfraProjection[old] === InfraProjection[new], InfraFibrationQ[old]}]
```

A construction gives a literal object under either name:

```wl
With[{model = InfraDisplacementBundle[GridGraph[{4, 4}], 1]},
  {Head @ InfraFibration[model], InfraFibers[InfraFibration[model]] === InfraFibers[InfraFiberedGraph[model]]}]
```
