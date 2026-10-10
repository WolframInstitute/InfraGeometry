---
Template: Symbol
Name: InfraEqualQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraEqualQ
---

## Usage

`InfraEqualQ[graph, a, b]` tests equality of two supported graph objects via their diffusion diagrams (vertex -> total-occurrence multisets).

## Details & Options

Options:

| Option | Values |
|---|---|
| `Method` | "Diffuse" (default; \|A cap B\| > \|A delta B\|, equivalently weighted Jaccard > 1/2) \| "Overlap" (at least one common vertex) \| "Set" (vertex sets identical) \| "Multiset" (diffusion diagrams identical) |
