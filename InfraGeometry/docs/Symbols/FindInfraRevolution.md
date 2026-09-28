---
Template: Symbol
Name: FindInfraRevolution
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraRevolution
---

## Usage

`FindInfraRevolution[graph, axis, profile]` returns InfraObject[set] for the rotational vertex set around axis with the given radius profile (NumericQ constant, List, Association, or callable).

## Details & Options

Options:

| Option | Values |
|---|---|
| `"Form"` | "Solid" (default), "Surface" |
| `Method` | "Voronoi" (default), "PerpendicularBisector", "Balls" |
