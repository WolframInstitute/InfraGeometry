---
Template: Symbol
Name: InfraHolonomyAngle
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraHolonomyAngle
SeeAlso: [InfraDisplacementBundle, InfraConnection, InfraParallelTransport, InfraHolonomy, FindInfraLeviCivitaConnection, InfraCovariantDerivative]
RelatedGuides: [InfraFiberBundles]
---

## Usage

`InfraHolonomyAngle[InfraDisplacementBundle[g, r], conn, loop]` gives the unsigned rotation angle of the directions around loop under conn: the mean angle between each moved direction and its image, in arc radians.

`InfraHolonomyAngle[InfraDisplacementBundle[g, r], loop]` gives the least such angle over the Levi-Civita transports of InfraParallelTransport.

## Details & Options

Options:

| Option | Values |
|---|---|
| `Method` | "Arclength" (default): the angle between two directions at p is their distance in the graph with the open ball of radius r around p deleted, over r; "Alexandrov": the comparison angle of the polar form |

The angle is a mean of unsigned angles, so it does not tell the sense of the rotation. The two-argument form is InfraGaugeTheory's InfraHolonomyAngle: the least angle over every choice among the best angle-isometries along the loop.
