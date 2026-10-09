---
Template: Symbol
Name: FindInfraRegularPolygon
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraRegularPolygon
---

## Usage

`FindInfraRegularPolygon[graph, As, n]` returns {InfraPolygon[{poly}]} for a length-n cyclic vertex sequence whose k-diagonal distances satisfy As[[k]] (slot grammar: Integer exact, {lo, hi} constant in range, Automatic any constant; Length[As] <= Floor[n/2]); count / UpTo[count] / All controls multiplicity.

## Details & Options

Options:

| Option | Values |
|---|---|
| `Properties` | {} |
| `"NextVertexFunction"` | Identity (default), RandomSample, any function on the candidate cycles |
| `"From"` | All (default), v, v -> r |
