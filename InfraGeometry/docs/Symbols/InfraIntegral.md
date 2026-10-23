---
Template: Symbol
Name: InfraIntegral
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraIntegral
Keywords: [integral, line integral, region, value density, multi-object, fundamental theorem, flux, Gauss theorem, family of walks]
SeeAlso: [InfraDifferential, InfraCodifferential, InfraAntiderivative, InfraMeasurement, InfraSegment, InfraBall]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[InfraIntegral]()[*f*, *obj*]</code> is the integral of the 0-form or 1-form *f* over the object *obj*: one sum over a region, or one sum along each member of a family of walks.

## Details & Options

Over a region *R* the integral of a 0-form is *Σ f(v)*, the sum over the vertices *v* of *R*. Along a walk *γ = (v₀, …, vₖ)* a 0-form gives *Σ f(vᵢ)*, both ends included, and a 1-form gives *Σ ω(vᵢ₋₁ → vᵢ)*.

The domain is any object that [InfraMeasurement]() reads:

| *obj* | Integral |
|---|---|
| a region: a ball, shell, tube, a vertex, a vertex list, a density | one value, the sum over its support |
| a family of walks: a segment, ray, line, open arc | one value per member, a source-to-sink path of its `"Graph"` |

Polylines, closed arcs and circles are not families of alternative walks, and their integrals stay unevaluated.

*f* is a 0-form, an [Association]() *v* -> *x* or a function applied to each vertex, or a 1-form, an [Association]() `DirectedEdge[u, v] -> x` read antisymmetrically. A missing key counts as 0. <code>[InfraDifferential]()[*h*]</code> is read as a 1-form; [InfraCodifferential](), [InfraAntiderivative]() and [InfraDerivative]() as 0-forms.

Along a family of walks the integral is itself a multi-object, one value per member. [InfraMeasurement]() reads:

| Reading | Region | Family of walks |
|---|---|---|
| `"Value"` | the sum over the support | the common value of the members, or the sorted list of their distinct values |
| `"ValueDensity"` | `<\|value -> 1\|>` | `<\|x -> number of members whose integral is x\|>` |
| `"Mean"` | the value | the mean over the members |
| `"Cardinality"` | 1 | the number of members |
| `"Flux"` | for a 1-form, its values on the edges entering the region minus those on the edges leaving it | — |

`All` gives the readings that apply.

The fundamental theorem: *∫ df = f(q) − f(p)* along every walk from *p* to *q*, so the integral of a differential along a segment has one value.

## Basic Examples

The integral of a differential along a segment. Each of its shortest paths has the integral *f(q) − f(p)*, so the value density is one atom, carrying all of them:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
    {q = RandomInfraPoint[g, InfraShell[p, 5], RandomSeeding -> 1], f = Mod[#^2, 11] &},
    InfraSubstrateHighlight[g, {InfraSegment[p, q], p, q},
      PlotLabel -> InfraMeasurement[g, InfraIntegral[InfraDifferential[f], InfraSegment[p, q]], "ValueDensity"]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The integral of a function along the same segment of the grid takes many values. Its value density counts the shortest paths with each value:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 5], RandomSeeding -> 1]},
  {density = InfraMeasurement[g, InfraIntegral[Mod[#, 4] &, InfraSegment[p, q]], "ValueDensity"]},
  BarChart[Values[density], ChartLabels -> Keys[density]]]
```

Over a region the integral is the sum over its support. The integral of 1 over a ball is its counting measure:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small"]}, {ball = InfraBall[First @ GraphCenter[g], 3]},
    {InfraMeasurement[g, InfraIntegral[1 &, ball], "Value"], InfraMeasurement[g, ball, "CountingMeasure"]}],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Scope

A ray has many far ends. Along each member the integral of a differential is *f(end) − f(p)*, so the value density has one atom per value of *f* at the far ends:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
    {ray = InfraHalfLine[p, RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]], f = Mod[#^2, 11] &},
    InfraSubstrateHighlight[g, {ray, p},
      PlotLabel -> InfraMeasurement[g, InfraIntegral[InfraDifferential[f], ray], "ValueDensity"]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Properties and Relations

The mean along a family is the mean of its value density, and the cardinality is the total of the density:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {p = First @ GraphCenter[g]},
  {ray = InfraHalfLine[p, RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]]},
  {integral = InfraIntegral[Mod[#^2, 11] &, ray]},
  {density = InfraMeasurement[g, integral, "ValueDensity"]},
  {InfraMeasurement[g, integral, "Mean"] == Total[Keys[density] Values[density]] / Total[density],
   InfraMeasurement[g, integral, "Cardinality"] == Total[density]}]
```

Gauss: the integral of the codifferential over a region is the flux into it:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {region = InfraShell[First @ GraphCenter[g], {2, 4}]},
  {omega = AssociationMap[Mod[3 First[#] + Last[#], 7] - 3 &, DirectedEdge @@@ EdgeList[g]]},
  {InfraMeasurement[g, InfraIntegral[InfraCodifferential[omega], region], "Value"],
   InfraMeasurement[g, InfraIntegral[omega, region], "Flux"]}]
```

From an origin *c*, the zeta antiderivative at *q* is the integral over the support of the segment from *c* to *q*, and the uniform-chain antiderivative is the mean along the segment:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g], f = Mod[#^2, 11] &},
  {q = RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 1]},
  {InfraMeasurement[g, InfraAntiderivative[f, "Origin" -> c], "Function"][q] ==
     InfraMeasurement[g, InfraIntegral[f, InfraMeasurement[g, InfraSegment[c, q], "VertexDensity"]], "Value"],
   InfraMeasurement[g, InfraAntiderivative[f, Method -> "UniformChain", "Origin" -> c], "Function"][q] ==
     InfraMeasurement[g, InfraIntegral[f, InfraSegment[c, q]], "Mean"]}]
```

## Possible Issues

A polyline is not a family of alternatives, and its integral stays unevaluated. Integrate its pieces one by one:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {a = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 1]},
  {b = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 2]},
  {Head @ InfraMeasurement[g, InfraIntegral[Mod[#^2, 11] &, InfraSegment[a, c, b]], "Value"],
   InfraMeasurement[g, InfraIntegral[Mod[#^2, 11] &, InfraSegment @@ #], "Value"] & /@ {{a, c}, {c, b}}}]
```
