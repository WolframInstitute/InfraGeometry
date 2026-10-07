---
Template: Symbol
Name: EffectiveResistance
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/EffectiveResistance
Keywords: [effective resistance, resistance distance, Klein-Randic, electrical network, Laplacian pseudoinverse, Foster's theorem, commute time]
SeeAlso: [ResistanceCoordinates, ResistanceQ, OllivierRicciCurvature, GraphEccentricities]
RelatedGuides: [Experimental]
---

## Usage

<code>[EffectiveResistance]()[*g*, *u*, *v*]</code> gives the effective resistance *R*(*u*, *v*) between the vertices *u* and *v* of *g*, every edge a unit resistor.

<code>[EffectiveResistance]()[*g*]</code> gives the matrix of all the effective resistances, in the order of [VertexList]().

<code>[EffectiveResistance]()[*g*, *vs*]</code> gives the matrix on the vertex list *vs*.

## Details & Options

Definition: with *L* the Laplacian of *g*, [KirchhoffMatrix](), and *L*⁺ its pseudoinverse, *R*(*u*, *v*) = (*e*ᵤ − *e*ᵥ)ᵀ *L*⁺ (*e*ᵤ − *e*ᵥ) = *L*⁺ᵤᵤ + *L*⁺ᵥᵥ − 2*L*⁺ᵤᵥ, the resistance distance of Klein and Randić. It is the voltage between *u* and *v* when every edge is a unit resistor and a unit current enters at *u* and leaves at *v*.

*R* is a metric, and *R* ≤ *d*, with equality on a tree, where the current has one path. Adding an edge does not increase any resistance. On a connected graph the resistances of the edges add up to *n* − 1, for *n* vertices (Foster), and the expected commute time of the random walk between *u* and *v* is 2|*E*| *R*(*u*, *v*).

The resistances are the squared distances of the points of [ResistanceCoordinates](). The values are machine numbers.

## Basic Examples

On the square tiling the ball of radius 5 about the centre, blue, is a square. The vertices within resistance 1.15 of the centre, green, are as many, 61, and they form a round disk.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {fromCentre = EffectiveResistance[g][[VertexIndex[g, c]]]},
  {disk = Pick[VertexList[g], Thread[fromCentre <= 1.15]], graphBall = FindInfraRepresentative[g, InfraBall[c, 5]]},
  {GraphicsRow[{InfraSubstrateHighlight[g, {AssociationThread[graphBall, 1] -> StandardBlue}], InfraSubstrateHighlight[g, {AssociationThread[disk, 1] -> StandardGreen}]}],
   Length /@ {graphBall, disk}}]
```

The resistance from the centre against the distance on the square, hexagonal and triangular tilings and on a binary tree. On the tree they are equal; on the tilings the resistance grows far more slowly, as in the plane, where it grows like the logarithm of the distance.

```wl
ListPlot[
  Table[
    With[
      {c = First @ GraphCenter[g]},
      Table[{GraphDistance[g, c, v], EffectiveResistance[g, c, v]}, {v, VertexList[g]}]],
    {g, Append[InfraSubstrate[#, "Small"] & /@ {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}, KaryTree[31]]}],
  PlotLegends -> {"square", "hexagonal", "triangular", "binary tree"}, AxesLabel -> {"d", "R"}]
```

## Scope

The whole matrix: on the 12-cycle *R*(*u*, *v*) = *k*(12 − *k*)/12 for vertices *k* steps apart, the two arcs carrying the current in parallel.

```wl
With[
  {g = CycleGraph[12]},
  {resistances = EffectiveResistance[g]},
  {MatrixPlot[resistances], Max[Abs[resistances - Table[With[{k = Abs[i - j]}, k (12 - k)/12], {i, 12}, {j, 12}]]] < 10^-9}]
```

The matrix on a vertex list: the four corners of the square tiling, red, each held by one edge.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {corners = Select[VertexList[g], VertexDegree[g, #] == 1 &]},
  {InfraSubstrateHighlight[g, {corners -> StandardRed}], MatrixForm[EffectiveResistance[g, corners]]}]
```

## Properties and Relations

The resistance of every edge of the square, hexagonal and triangular tilings, blue near 0 and red at 1, where an edge is a bridge. The resistances of the edges add up to one less than the number of vertices (Foster). Away from the rim an edge has resistance near 1/2, 2/3 and 1/3, two over the degree.

```wl
With[
  {graphs = InfraSubstrate[#, "Small", "KeepCoordinates" -> True] & /@ {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}},
  {edgeResistances = Table[
     With[
       {resistances = EffectiveResistance[g]},
       AssociationMap[resistances[[VertexIndex[g, First[#]], VertexIndex[g, Last[#]]]] &, EdgeList[g]]],
     {g, graphs}]},
  {GraphicsRow[MapThread[
     {g, edgeValues} |-> InfraSubstrateHighlight[g, KeyValueMap[{edge, r} |-> InfraWalk[List @@ edge] -> Blend[{StandardBlue, StandardRed}, r], edgeValues]],
     {graphs, edgeResistances}]],
   MapThread[{Total[Values[#1]], VertexCount[#2] - 1} &, {edgeResistances, graphs}]}]
```

## Possible Issues

On a graph with several components the pseudoinverse still gives a finite number between two components, though no current can flow and the resistance is infinite.

```wl
With[
  {g = GraphUnion[PathGraph[{1, 2, 3}], PathGraph[{4, 5}]]},
  {g, EffectiveResistance[g, 1, 3], EffectiveResistance[g, 1, 4]}]
```
