---
Template: Symbol
Name: InfraCovariantDerivative
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraCovariantDerivative
SeeAlso: [InfraDisplacementBundle, InfraConnection, InfraParallelTransport, InfraHolonomy, FindInfraLeviCivitaConnection, InfraHolonomyAngle, InfraSection]
RelatedGuides: [InfraFiberBundles]
---

## Usage

`InfraCovariantDerivative[InfraDisplacementBundle[g, r], conn, InfraSection[s], walk]` gives <|p -> x, ...|>: for each step p -> q of walk, conn carries s[q] back to p, the arrow from s[p] to that image is carried to p by the Levi-Civita transports at its own length, and x is the endpoint nearest to p, x == p for zero.

## Details & Options

Options:

| Option | Values |
|---|---|
| `Method` | "Arclength" (default): the angle between two directions at p is their distance in the graph with the open ball of radius r around p deleted, over r; "Alexandrov": the comparison angle of the polar form |

The arrow is carried by the Levi-Civita transports whatever conn is, so for a conn other than FindInfraLeviCivitaConnection the result mixes the two connections.
