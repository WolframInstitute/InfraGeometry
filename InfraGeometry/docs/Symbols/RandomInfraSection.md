---
Template: Symbol
Name: RandomInfraSection
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraSection
Keywords: [random section, random vector field]
SeeAlso: [InfraSection, InfraSectionQ, InfraContinuousSectionQ, FindInfraSection, RandomInfraFibration, RandomInfraConnection]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[RandomInfraSection]()[*fib*]</code> gives an [InfraSection]() choosing a random total vertex in every fiber of *fib*.

## Details & Options

- [SeedRandom]() in front of the call gives the same section again.
- The section is not continuous in general; [FindInfraSection]() gives continuous ones.

## Basic Examples

A random vector field at scale 2 on the grid: one ray of length 2 at every vertex.

```wl
With[
  {fib = InfraFiberedSubstrate["GridTangentBundle", "Small"]},
  {field = (SeedRandom[1]; RandomInfraSection[fib])},
  InfraSubstrateHighlight[First @ fib, InfraWalk /@ Values @ First @ field]]
```

A random section of the prism is a section, and it is continuous only if it stays on one sheet.

```wl
With[
  {fib = InfraFiberedSubstrate["CycleProductBundle", "Small"]},
  {total = InfraTotalGraph[fib]},
  {section = (SeedRandom[1]; RandomInfraSection[fib])},
  {InfraSubstrateHighlight[total, {InfraDensity[total, Values @ First @ section]}], InfraSectionQ[fib, section], InfraContinuousSectionQ[fib, section]}]
```
