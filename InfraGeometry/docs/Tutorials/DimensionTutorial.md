---
Template: TechNote
Name: DimensionTutorial
Title: Dimension
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/tutorial/DimensionTutorial
Keywords: [dimension, volume growth, ball cover, box dimension, doubling, Sierpinski triangle, Menger carpet]
RelatedGuides: [InfraTopology, RiemannianInfrageometry]
RelatedTutorials: [VolumeMeasurementTutorial]
---

- Dimension describes how a region grows when its scale grows. We read it from vertex volumes and ball covers.
- The graph distance supplies the scale. The drawing supplies no measurement.
- These are readings over finite windows. The lattice scale, the boundary and the shape of the balls can bias them.

## Setup

```wl
Needs[ "WolframInstitute`InfraGeometry`" ]
```

The plane mesh, square tiling and Sierpinski triangle use the large roster size; the Menger carpet uses medium. The reference dimensions of the fractals come from their self-similar pieces and scale factors. The carpet is planar; its reference is not the dimension of the Menger sponge.

```wl
SeedRandom[ 2 ];
dimensionSubstrates = Apply[
  { name, size, reference } |-> With[
    { graph = InfraSubstrate[ name, size, "KeepCoordinates" -> True ] },
    { centre = First @ GraphCenter[ graph ], radius = Floor[ 4 GraphRadius[ graph ] / 5 ] },
    <| "Name" -> name, "Graph" -> graph, "Centre" -> centre, "Radius" -> radius,
      "Reference" -> reference |> ],
  { { "SquareMeshGraph", "Large", 2 }, { "SquareTilingGraph", "Large", 2 },
    { "SierpinskiTriangleGraph", "Large", Log[ 3 ] / Log[ 2 ] },
    { "MengerCarpetGraph", "Medium", Log[ 8 ] / Log[ 3 ] } }, { 1 } ];
GraphicsGrid[ Partition[
  Map[ data |-> Labeled[ data[ "Graph" ], data[ "Name" ] ], dimensionSubstrates ], 2 ] ]
```

## Volume growth

- Write $V(s)=|B_s(c)|$ for the number of vertices in the closed ball about a centre.
- If $V(s)$ is proportional to $s^d$, its log-log slope is $d$.
- [LogDifferenceQuotients]() reads successive slopes. [DimensionCurvatureFit]() fits their dimension and curvature over a chosen window; [VolumeGrowthObservables]() chooses a window for the Riemannian probes.

The growth dimension once, on the plane mesh: the quotients and the fitted curve. Small radii see individual layers; large radii see the boundary. The fit is a reading over the selected window.

```wl
SeedRandom[ 2 ];
With[
  { graph = dimensionSubstrates[[ 1 ]][ "Graph" ], centre = dimensionSubstrates[[ 1 ]][ "Centre" ] },
  { observables = VolumeGrowthObservables[ graph, centre, "Measure" -> "CountingMeasure" ] },
  { window = observables[ "BallWindow" ], quotients = observables[ "BallLogDifferenceQuotients" ] },
  { points = Table[ { r, quotients[[ r ]] }, { r, window[[ 1 ]], window[[ 2 ]] } ] },
  { fit = DimensionCurvatureFit[ points ] },
  Column[ {
    Show[
      ListPlot[ points, AxesLabel -> { "r", "q" }, PlotRange -> All ],
      Plot[ fit[ "Dimension" ] - fit[ "ScalarCurvature" ] r ( r + 1 ) / ( 3 ( fit[ "Dimension" ] + 2 ) ),
        { r, window[[ 1 ]], window[[ 2 ]] } ] ],
    fit } ] ]
```

## Covering a region

- Let $N_r(T)$ be the least number of closed balls of radius $r$ covering the target vertices $T$. Their centres may be anywhere in the graph.
- [FindBallCover]() gives the centres. [BallCoverNumber]() gives their number. The default method finds a smallest cover; the greedy method gives an upper bound.
- We first find an exact cover on a small square tiling. The target is gray and each covering ball has its own colour.

```wl
SeedRandom[ 2 ];
With[
  { graph = InfraSubstrate[ "SquareTilingGraph", "Small", "KeepCoordinates" -> True ] },
  { target = FindInfraRepresentative[ graph, InfraBall[ First @ GraphCenter[ graph ], 4 ] ], radius = 2 },
  { centres = FindBallCover[ graph, radius, target ] },
  Column[ {
    InfraSubstrateHighlight[ graph, Join[ { target -> StandardGray },
      MapIndexed[ { centre, index } |-> InfraBall[ centre, radius ] -> ColorData[ 97 ][ First[ index ] ], centres ],
      { centres -> StandardRed } ] ],
    <| "Radius" -> radius, "Exact count" -> BallCoverNumber[ graph, radius, target ],
      "Covers target" -> BallCoverQ[ graph, radius, centres, target ] |> } ] ]
```

The same construction on the larger substrates, now with greedy covers. The target radius is a fixed fraction of the graph radius, and the covering radius a fraction of the target radius.

```wl
SeedRandom[ 2 ];
GraphicsGrid[ Partition[ Map[
  data |-> With[
    { graph = data[ "Graph" ], centre = data[ "Centre" ], targetRadius = data[ "Radius" ] },
    { radius = Max[ 1, Floor[ targetRadius / 3 ] ], target = FindInfraRepresentative[ graph, InfraBall[ centre, targetRadius ] ] },
    { centres = FindBallCover[ graph, radius, target, Method -> "Greedy" ] },
    Labeled[
      InfraSubstrateHighlight[ graph, Join[ { target -> StandardGray },
        MapIndexed[ { point, index } |-> InfraBall[ point, radius ] -> ColorData[ 97 ][ First[ index ] ], centres ],
        { centres -> StandardRed } ] ],
      Row[ { data[ "Name" ], ": ", Length[ centres ], " balls, radius ", radius } ] ] ],
  dimensionSubstrates ], 2 ] ]
```

## Two covering slopes

- **Box reading.** Fix $T=B_\rho(c)$ and vary the covering radius. A $d$-dimensional region needs approximately $r^{-d}$ balls.
- On a lattice a ball volume is a polynomial in $r+1/2$. We use this shifted radius for the box slope. Using $r$ at these small radii gives a lower reading.
- **Growth at a fixed resolution.** Fix the covering radius and grow $B_s(c)$. Its covering count is the volume measured in balls of that radius. At radius zero this is exactly the vertex count.
- We fit one least-squares slope over each window. Successive quotients of integer covering counts jump and can vanish on plateaux.

The profiles below are computed with greedy covers. The box window ends at half the target radius; the growth window starts beyond the first few layers. The vertex-volume slope uses exactly the growth window.

```wl
logSlope[ scales_, counts_ ] :=
  Coefficient[ Fit[ Transpose[ { Log[ N[ scales ] ], Log[ N[ counts ] ] } ], { 1, x }, x ], x ]
```

```wl
SeedRandom[ 2 ];
dimensionProfiles = Map[
  data |-> With[
    { graph = data[ "Graph" ], centre = data[ "Centre" ], radius = data[ "Radius" ] },
    { boxRadii = Range[ Floor[ radius / 2 ] ], growthRadii = Range[ 3, radius ],
      target = FindInfraRepresentative[ graph, InfraBall[ centre, radius ] ] },
    { boxCounts = Map[ r |-> BallCoverNumber[ graph, r, target, Method -> "Greedy" ], boxRadii ],
      growthCounts = Map[ s |-> BallCoverNumber[ graph, 1,
        FindInfraRepresentative[ graph, InfraBall[ centre, s ] ], Method -> "Greedy" ], growthRadii ],
      volumes = Map[ s |-> Length @ FindInfraRepresentative[ graph, InfraBall[ centre, s ] ], growthRadii ] },
    Join[ data, <| "BoxRadii" -> boxRadii, "BoxCounts" -> boxCounts,
      "GrowthRadii" -> growthRadii, "GrowthCounts" -> growthCounts, "Volumes" -> volumes,
      "Box" -> -logSlope[ boxRadii + 1/2, boxCounts ], "UnshiftedBox" -> -logSlope[ boxRadii, boxCounts ],
      "Growth" -> logSlope[ growthRadii, growthCounts ], "VertexVolume" -> logSlope[ growthRadii, volumes ] |> ] ],
  dimensionSubstrates ];
GraphicsGrid[ Map[
  data |-> {
    ListLogLogPlot[ Transpose[ { data[ "BoxRadii" ] + 1/2, data[ "BoxCounts" ] } ],
      Joined -> True, AxesLabel -> { "r + 1/2", "cover count" }, PlotLabel -> data[ "Name" ] ],
    ListLogLogPlot[ { Transpose[ { data[ "GrowthRadii" ], data[ "GrowthCounts" ] } ],
      Transpose[ { data[ "GrowthRadii" ], data[ "Volumes" ] } ] }, Joined -> True,
      PlotLegends -> { "radius-one cover", "vertex volume" }, AxesLabel -> { "s", "count" } ] },
  dimensionProfiles ] ]
```

The normalized profiles against a horizontal target line: the box count multiplied by the shifted radius to the reference dimension, and the growth counts divided by the radius to that dimension. A flat profile supports the reference exponent over that window.

```wl
GraphicsGrid[ Map[
  data |-> With[
    { box = data[ "BoxCounts" ] ( data[ "BoxRadii" ] + 1/2 ) ^ data[ "Reference" ],
      growth = data[ "GrowthCounts" ] / data[ "GrowthRadii" ] ^ data[ "Reference" ],
      volume = data[ "Volumes" ] / data[ "GrowthRadii" ] ^ data[ "Reference" ] },
    { Show[
        ListPlot[ Transpose[ { data[ "BoxRadii" ], box / First[ box ] } ], Joined -> True,
          PlotLabel -> data[ "Name" ], AxesLabel -> { "r", "normalized box" }, PlotRange -> All ],
        Plot[ 1, { r, First @ data[ "BoxRadii" ], Last @ data[ "BoxRadii" ] }, PlotStyle -> Dashed ] ],
      Show[
        ListPlot[ { Transpose[ { data[ "GrowthRadii" ], growth / First[ growth ] } ],
          Transpose[ { data[ "GrowthRadii" ], volume / First[ volume ] } ] }, Joined -> True,
          PlotLegends -> { "cover", "vertices" }, AxesLabel -> { "s", "normalized growth" }, PlotRange -> All ],
        Plot[ 1, { s, First @ data[ "GrowthRadii" ], Last @ data[ "GrowthRadii" ] }, PlotStyle -> Dashed ] ] } ],
  dimensionProfiles ] ]
```

## Readings at this resolution

The table compares the slopes with the reference dimensions. The carpet has a shorter scale window than the other examples. The cover slopes are readings from greedy upper bounds, not certified estimates of the least-cover slopes.

```wl
Grid[ Prepend[
  Map[ data |-> Join[ { data[ "Name" ] },
    Map[ value |-> NumberForm[ N[ value ], { 4, 2 } ],
      Lookup[ data, { "Reference", "Box", "UnshiftedBox", "Growth", "VertexVolume" } ] ] ], dimensionProfiles ],
  { "Substrate", "Reference", "Box (shifted)", "Box (unshifted)", "Cover growth", "Vertex growth" } ],
  Frame -> All ]
```

## Doubling sees the shape of a ball

- A different reading covers $B_{2r}(c)$ by balls of radius $r$ and takes the base-two logarithm of the count.
- The square tiling admits a small exact cover. The mesh uses more balls in the greedy cover even though both substrates have planar growth dimension.
- A Euclidean disc cannot tile a doubled disc without overlap. Doubling sees this covering overhead as well as the dimension. The greedy mesh count is an upper bound; it does not prove that no smaller cover exists.

The exact square-tiling counts and the greedy mesh counts, computed over interior scales. The pictures show one scale, with each ball in its own colour.

```wl
SeedRandom[ 2 ];
With[
  { square = InfraSubstrate[ "SquareTilingGraph", "Small", "KeepCoordinates" -> True ],
    mesh = dimensionSubstrates[[ 1 ]][ "Graph" ] },
  { cases = { { square, "Square tiling", "Exhaustive", Range[ 1, 3 ] },
      { mesh, "Plane mesh", "Greedy", Range[ 2, 8 ] } } },
  Column[ {
    Grid[ Prepend[ Join @@ Apply[
      { graph, name, method, radii } |-> Map[
        r |-> With[
          { target = FindInfraRepresentative[ graph, InfraBall[ First @ GraphCenter[ graph ], 2 r ] ] },
          { count = BallCoverNumber[ graph, r, target, Method -> method ] },
          { name, method, r, count, NumberForm[ N[ Log[ 2, count ] ], { 4, 2 } ] } ], radii ], cases, { 1 } ],
      { "Substrate", "Method", "r", "Cover count", "log2 count" } ], Frame -> All ],
    GraphicsRow[ Apply[
      { graph, name, method, radii } |-> With[
        { r = radii[[ 2 ]], centre = First @ GraphCenter[ graph ] },
        { target = FindInfraRepresentative[ graph, InfraBall[ centre, 2 r ] ] },
        { centres = FindBallCover[ graph, r, target, Method -> method ] },
        Labeled[ InfraSubstrateHighlight[ graph, Join[ { target -> StandardGray },
          MapIndexed[ { point, index } |-> InfraBall[ point, r ] -> ColorData[ 97 ][ First[ index ] ], centres ],
          { centres -> StandardRed } ] ], name ] ], cases, { 1 } ] ] } ] ]
```

## Related readings

- [Volume Measurement](paclet:WolframInstitute/InfraGeometry/tutorial/VolumeMeasurementTutorial) compares counting and Riemannian measures of balls, shells and tubes.
- [MetricDimension]() is a different graph invariant: the size of a resolving set, whose distance coordinates distinguish the vertices.
