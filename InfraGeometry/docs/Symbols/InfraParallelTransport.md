---
Template: Symbol
Name: InfraParallelTransport
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraParallelTransport
SeeAlso: [InfraFibration, InfraSection, InfraConnection, InfraTotalGraph]
RelatedGuides: [InfraFiberBundles]
---

## Usage

`InfraParallelTransport[fib, conn, walk]` gives the transport <|x -> y, ...|> along walk of the fiber over its first vertex; blocked vertices are dropped.

`InfraParallelTransport[InfraDisplacementBundle[g, r], walk]` gives the Levi-Civita transports along walk, a list with one transport for each choice among the best angle-isometries over its edges.
