---
Template: Symbol
Name: Undetermined
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/Undetermined
Keywords: [faithful, circle, arc, hypothesis, uncertified]
SeeAlso: [InfraMeasurement, InfraCircle, InfraArc]
RelatedGuides: [EuclideanGeometryGuide]
---

## Usage

`Undetermined` is the value of <code>[InfraMeasurement]()[*graph*, *obj*, "Faithful"]</code> on a head whose graph is faithful — its chains are exactly its intended members — only under a hypothesis this paclet does not certify.

## Details & Options

Every Euclidean head has a graph, and "Faithful" states whether every chain of that graph is genuinely a member of the head and every member a chain of it. For a segment, a ray or a line this is a proved theorem and `"Faithful"` is `True`. For [InfraCircle]() and [InfraArc]() the analogous statement needs a geometric hypothesis on the substrate — for the circle the winding functional (W) and the one-run hypothesis (T), for the arc (W) together with *p* and *q* lying on a common circle — that no computation here checks, so the honest answer is neither `True` nor `False` but `Undetermined`: the question is open on this call, not answered no.

`Undetermined` carries no further structure; it is a plain symbol, not a function.

## Basic Examples

The circle's "Faithful" is always `Undetermined`, whatever the substrate.

```wl
With[
  {g = GridGraph[{5, 5}]},
  {cir = InfraCircle[13, "Radius" -> {2, 3}]},
  InfraMeasurement[g, cir, "Faithful"]
]
```
