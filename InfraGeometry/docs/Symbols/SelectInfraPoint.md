---
Template: Symbol
Name: SelectInfraPoint
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/SelectInfraPoint
---

## Usage

`SelectInfraPoint[graph, vertices]` draws one vertex from the bundle under graph distance.

`SelectInfraPoint[graph, vertices, n]` returns exactly n or $Failed; UpTo[n] returns up to n; All returns the whole filtered pool.

## Details & Options

Operator form SelectInfraPoint[graph, n, opts][vertices].

Options:

| Option | Values |
|---|---|
| `mirror FindInfraPoint` | "From", "Distance", "MaxCliques" -- ; the bundle may be a vertex list or any set-like Infra* wrapper |
