---
Template: Symbol
Name: ExtendInfraWalk
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/ExtendInfraWalk
---

## Usage

`ExtendInfraWalk[graph, seed, kspec]` continues a seed walk -- a vertex list or a walk graph -- in the class cut by the Properties rules (default {"Simple"}) until a stopping condition or the budget kspec (UpTo[k], {k}, {lo, hi}, Infinity; edges added per growing side) stops it.

## Details & Options

Options "InfraScale", Properties, "StoppingCondition", "NextVertexFunction", "Direction". The next-vertex function is that of FindInfraWalk.
