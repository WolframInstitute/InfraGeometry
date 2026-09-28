---
Template: Symbol
Name: FindSegmentHull
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindSegmentHull
---

## Usage

`FindSegmentHull[graph, S]` returns the smallest superset of S closed under MetricInterval (the segment operator), as a sorted vertex list.

## Details & Options

Options:

| Option | Values |
|---|---|
| `"LineStructure"` | None (default), or an InfraLineStructure / list of lines -- closes under the chosen-geodesic stretch on that fixed family instead of all geodesics |

S is any Infra* object, a list of them, or a bare vertex list.
