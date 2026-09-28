---
Template: Symbol
Name: InfraVolume
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraVolume
---

## Usage

`InfraVolume[g, s]` is the volume of s (a bare vertex list or any Infra* object).

## Details & Options

Options:

| Option | Values |
|---|---|
| `"Measure"` | "FullCount" (default; \|s\|), "WithoutBoundary" (\|s\| minus its inner boundary), "HalfBoundary" (the boundary at weight one half), "Boundary" (the boundary itself) |
| `Method` | "Combinatorial" (default), {"Alexandrov", "Radius" -> r} |
