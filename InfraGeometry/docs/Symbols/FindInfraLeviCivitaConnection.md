---
Template: Symbol
Name: FindInfraLeviCivitaConnection
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraLeviCivitaConnection
SeeAlso: [InfraDisplacementBundle, InfraConnection, InfraParallelTransport, InfraHolonomy, InfraHolonomyAngle, InfraCovariantDerivative]
RelatedGuides: [InfraFiberBundles]
---

## Usage

`FindInfraLeviCivitaConnection[InfraDisplacementBundle[g, r]]` gives the Levi-Civita InfraConnection: over each edge p -> q of g the first of the best angle-isometries from the directions at p to those at q fixing the geodesics through q, its lifts that are not total edges dropped.

## Details & Options

Options:

| Option | Values |
|---|---|
| `Method` | "Arclength" (default): the angle between two directions at p is their distance in the graph with the open ball of radius r around p deleted, over r; "Alexandrov": the comparison angle of the polar form |

The best angle-isometries over an edge are usually several; the connection keeps the first, as InfraGaugeTheory does. All of them are read by InfraParallelTransport[InfraDisplacementBundle[g, r], walk] and InfraHolonomyAngle[InfraDisplacementBundle[g, r], loop].
