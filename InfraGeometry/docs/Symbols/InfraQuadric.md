---
Template: Symbol
Name: InfraQuadric
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraQuadric
Keywords: [quadric, ellipse, ellipsoid, hyperbola, elliptic shell, foci, region, symbolic object]
SeeAlso: [InfraBall, InfraShell, InfraSegment, InfraEllipse, InfraMeasurement, RandomInfraQuadric, InfraMemberQ]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraQuadric]()[{*p_1*, …, *p_k*}, *c*]</code> is the solid of the vertices whose distances to the foci *p_i* sum to at most *c*. It is a symbolic object; [InfraMeasurement]() and [RandomInfraQuadric]() evaluate it on a graph.

<code>[InfraQuadric]()[*foci*, {*lo*, *hi*}]</code> is the band *lo ≤ Σ d(p_i, v) ≤ hi*.

<code>[InfraQuadric]()[*foci*, *c*, {*w_1*, …, *w_k*}]</code> uses the signed sum *Σ w_i d(p_i, v)*.

## Details & Options

Definition: the quadric of the foci *p_1, …, p_k* and the level *c* is *{v : Σ_i w_i d(p_i, v) ≤ c}*, the weights all 1 when omitted. A pair *{lo, hi}* for the level is the band *{v : lo ≤ Σ_i w_i d(p_i, v) ≤ hi}*.

Each focus is read as the centre of [InfraBall]() is: a vertex, or a density, whose distance is the distance to its vertices.

| Foci | Weights | Solid |
|---|---|---|
| one | 1 | the ball; the band *{r, r}* is the shell |
| two | 1, 1 | the ellipse; the band *{c, c}* is the elliptic shell |
| two | 1, −1 | a hyperbola branch; the band *{0, 0}* is the bisector |
| *k* | any | the general quadric |

On a path graph the band *{d(p, q), d(p, q)}* about two foci is the interval between them.

On the square grid the signed quadric degenerates as the *ℓ¹* metric does: with the foci *(2, 4)* and *(6, 4)* of the *7 × 7* grid, *d(p, v) − d(q, v) = |x − 2| − |x − 6|*, so a branch is a straight column.

A weight list of the wrong length leaves the call unevaluated.

The head computes nothing. A quadric has one member, the vertex set. [InfraMeasurement]() reads `"VertexDensity"`, `"EdgeDensity"`, `"Cardinality"`, `"Faithful"` and `"Subgraph"`, and the two measures; the sum is read off one distance matrix.

## Basic Examples

The elliptic shell of two points at distance 6, on the irregular mesh, the square grid and the hexagonal tiling, with the band of slack 2.

```wl
SeedRandom[1];
Row[Table[
  With[
    {g = InfraSubstrate[name, "Large", "KeepCoordinates" -> True]},
    {first = First @ GraphCenter[g]},
    {second = First @ Sort @ Select[VertexList[g], GraphDistance[g, first, #] == 6 &]},
    {n = GraphDistance[g, first, second]},
    {shell = InfraQuadric[{first, second}, {n + 2, n + 2}]},
    Labeled[
      InfraSubstrateHighlight[g, {shell, {first, second}}, "PointSizeRange" -> 17],
      Length @ Replace[ shell, { token_InfraPoint :> RandomInfraPoint[ g, token ], token_InfraSegment :> RandomInfraSegment[ g, token ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token ], token_InfraCircle :> RandomInfraCircle[ g, token ], token_InfraArc :> RandomInfraArc[ g, token ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token ], token_InfraPlane :> RandomInfraPlane[ g, token ], token_InfraBall :> RandomInfraBall[ g, token ], token_InfraShell :> RandomInfraShell[ g, token ], token_InfraSphere :> RandomInfraSphere[ g, token ], token_InfraTube :> RandomInfraTube[ g, token ], token_InfraCylinder :> RandomInfraCylinder[ g, token ], token_InfraCone :> RandomInfraCone[ g, token ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token ], token_InfraBallHull :> RandomInfraBallHull[ g, token ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token ], token_InfraQuadric :> RandomInfraQuadric[ g, token ], token_InfraWalk :> RandomInfraWalk[ g, token ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token ], token_InfraEllipse :> RandomInfraEllipse[ g, token ], token_InfraIntersection :> RandomInfraIntersection[ g, token ], token_InfraUnion :> RandomInfraUnion[ g, token ], token_InfraRay :> RandomInfraHalfLine[ g, token ], token_InfraLine :> RandomInfraInfiniteLine[ g, token ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token ] } ]]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]]
```

The elliptic shell of two corners of a small grid, and a hyperbola branch, which on the square grid is a straight column.

```wl
GraphicsRow[{
  InfraSubstrateHighlight[GridGraph[{4, 4}], {InfraQuadric[{2, 15}, {4, 4}], {2, 15}}],
  InfraSubstrateHighlight[GridGraph[{7, 7}], {InfraQuadric[{11, 39}, {2, 2}, {1, -1}], {11, 39}}]}]
```

## Properties and Relations

One focus is the ball, and with the band *{r, r}* the shell.

```wl
SeedRandom[1];
With[
  {g = GridGraph[{7, 7}]},
  {RandomInfraQuadric[ g, InfraQuadric[{20}, 3] ] === RandomInfraBall[ g, InfraBall[20, 3] ],
   RandomInfraQuadric[ g, InfraQuadric[{20}, {3, 3}] ] === RandomInfraShell[ g, InfraShell[20, 3] ]}]
```

On a path graph the quadric of the level *d(p, q)* is the interval between the foci.

```wl
Keys @ InfraMeasurement[PathGraph[Range[9]], InfraQuadric[{3, 7}, {4, 4}], "VertexDensity"]
```

The quadric about two foci contains the tube about the interval between them: a vertex within *s* of the interval has slack at most *2 s*.

```wl
SeedRandom[1];
With[
  {g = GridGraph[{7, 7}]},
  {tube = RandomInfraTube[ g, InfraTube[InfraSegment[8, 42], 1] ]},
  SubsetQ[RandomInfraQuadric[ g, InfraQuadric[{8, 42}, GraphDistance[g, 8, 42] + 2] ], tube]]
```
