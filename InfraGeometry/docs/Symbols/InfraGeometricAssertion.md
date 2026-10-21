---
Template: Symbol
Name: InfraGeometricAssertion
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraGeometricAssertion
SeeAlso: [InfraGeometricTest, InfraScene, InfraMemberQ]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraGeometricAssertion]()[*objects*, *property*]</code> is the statement that *objects* have the geometric *property*, to be decided on a graph.

## Details & Options

The assertion is symbolic. [InfraGeometricTest]() decides it on a graph. In the hypotheses of an [InfraScene]() the scene supplies the graph once the objects are bound, and keeps only the instances where the assertion holds.

| Property | Objects | Holds when |
|---|---|---|
| `"Distinct"` | {*v1*, *v2*, …} | the vertices are pairwise different |
| `"Member"` | {*v*, *obj*} | *v* lies in the support of *obj* |
| `"EqualDistance"` | {{*p*, *q*}, {*r*, *s*}} | *d(p, q) = d(r, s) < ∞* |

An assertion with an unknown property, or with objects not yet bound, is not decided.

## Basic Examples

Two assertions about the centre *a* of the square grid and a vertex *b* at distance 4:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
  {InfraGeometricTest[g, InfraGeometricAssertion[{a, InfraSegment[a, b]}, "Member"]],
   InfraGeometricTest[g, InfraGeometricAssertion[{b, InfraBall[a, 3]}, "Member"]]}]
```

In a scene: the points *p* of the circle of radius 4 about *a* that are as far from *b* as from *a*. They are the apexes of the equilateral triangles on *ab*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
  {scene = InfraScene[{p}, {p == InfraPoint[InfraShell[a, 4]], InfraGeometricAssertion[{{a, p}, {b, p}}, "EqualDistance"]}]},
  {apexes = InfraSceneInstance[#, p] & /@ RandomInfraSceneInstance[scene, g, All]},
  InfraSubstrateHighlight[g, {InfraShell[a, 4], InfraShell[b, 4], apexes, {a, b}}, ImageSize -> Medium]]
```

## Possible Issues

An unknown property is not decided, and the test stays unevaluated:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {a = First @ GraphCenter[g]},
  Head @ InfraGeometricTest[g, InfraGeometricAssertion[{a, a + 1}, "Collinear"]]]
```
