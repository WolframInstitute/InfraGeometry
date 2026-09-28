---
Template: Symbol
Name: FindInfraGoldenSection
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraGoldenSection
---

## Usage

`FindInfraGoldenSection[graph, p1, p2]` gives the density <|v -> m, ...|> of the vertices at the golden index 1 + (n-1)/GoldenRatio along every geodesic from p1 to p2, m counting the geodesics.

`FindInfraGoldenSection[graph, {walk1, ...}]` and `FindInfraGoldenSection[graph, walk]` use the supplied walks — vertex lists or walk graphs.

## Details & Options

Options:

| Option | Values |
|---|---|
| `Method` | "Metric" (default), "Embedding" |
| `"Tolerance"` | -- |
