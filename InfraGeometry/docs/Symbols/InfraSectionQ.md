---
Template: Symbol
Name: InfraSectionQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSectionQ
Keywords: [section, fibration, projection]
SeeAlso: [InfraSection, InfraContinuousSectionQ, RandomInfraSection, FindInfraSection, InfraFibrationAssociation]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[InfraSectionQ]()[*fib*, [InfraSection]()[*s*]]</code> tests whether <code>*s*[*p*]</code> lies over *p* for every key *p* of *s*.

## Basic Examples

A random section of the prism picks one of the two sheets over every vertex of the cycle.

```wl
With[
  {fib = InfraFiberedSubstrate["CycleProductBundle", "Small"]},
  {total = InfraTotalGraph[fib]},
  {section = (SeedRandom[1]; RandomInfraSection[fib])},
  {InfraSubstrateHighlight[total, {InfraDensity[total, Values @ First @ section]}], InfraSectionQ[fib, section]}]
```

A map that sends 1 to a vertex over 2 is not a section.

```wl
With[
  {fib = InfraFiberedSubstrate["CycleProductBundle", "Small"]},
  {total = InfraTotalGraph[fib]},
  {wrong = InfraSection[<|1 -> {2, 1}|>]},
  {InfraSubstrateHighlight[total, {InfraDensity[total, Values @ First @ wrong]}], InfraSectionQ[fib, wrong]}]
```
