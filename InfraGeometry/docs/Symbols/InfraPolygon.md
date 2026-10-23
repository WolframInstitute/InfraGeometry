---
Template: Symbol
Name: InfraPolygon
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraPolygon
Keywords: [regular polygon, legacy]
SeeAlso: [InfraRegularPolygon, RandomInfraRegularPolygon, InfraRegularPolygonQ]
---

## Usage

<code>[InfraPolygon]()[{*a1*, …, *am*}, *n*]</code> is the older name of <code>[InfraRegularPolygon]()[{*a1*, …, *am*}, *n*]</code>.

## Details & Options

[InfraPolygon]() and [InfraRegularPolygon]() stand for the same family of regular polygons. New code uses [InfraRegularPolygon]().

## Basic Examples

The two names give the same polygon:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  SameQ @@ Table[RandomInfraRegularPolygon[g, token[{2, Automatic}, 4], "From" -> 45, RandomSeeding -> 1],
    {token, {InfraPolygon, InfraRegularPolygon}}]]
```
