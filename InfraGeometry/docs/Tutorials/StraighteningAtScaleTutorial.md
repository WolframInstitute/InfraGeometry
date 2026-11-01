---
Template: TechNote
Name: StraighteningAtScaleTutorial
Title: Straightening at a Scale
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/tutorial/StraighteningAtScaleTutorial
Keywords: [geodesic, infra-scale, germ, extension, beam, most visited, straightness, segment, tiling, Archimedean tiling]
RelatedGuides: [EuclideanInfrageometry]
---

- A **germ** is a shortest path, here of eight edges ending at the centre of the graph. We extend it forward by ten steps.
- A walk is a **geodesic at infra-scale** $r$ when every $r + 1$ consecutive vertices of it form a shortest path. The observer checks straightness only within a horizon of $r$ steps; at scale $\infty$ the whole walk is a shortest path.
- The **beam** of the germ at scale $r$ is the set of all geodesics at scale $r$ that extend the germ. A **most visited** member is one that maximizes the sum of the vertex and edge densities of the beam along it.
- The question: from which scale $r^*$ on is the most visited member of the beam a **segment**, a shortest path between its ends? We answer it on three Archimedean lattices: the trihexagonal tiling $\{3, 6, 3, 6\}$, the truncated square tiling $\{4, 8, 8\}$ and the rhombitrihexagonal tiling $\{3, 4, 6, 4\}$, each the ball of radius 14 about a vertex.
- The pictures keep the embedding of the substrate so that the reader sees the plane; only the chord deviation below uses it.

## Setup

```wl
Needs["WolframInstitute`InfraGeometry`"]
```

## The beam at a scale

- Each picture is one lattice at one scale: the rows are the trihexagonal, the truncated square and the rhombitrihexagonal tiling, the columns the scales $r = 3$ and $r = 6$.
- The beam is orange and the most visited members are red, all of them; the germ is drawn last.

```wl
GraphicsGrid @ Table[
  With[
    {g = Graph[TessellationNeighborhoodGraph[config, 14], Sequence @@ InfraSubstrateStyle["Large"]]},
    {c = First @ GraphCenter[g]},
    {germ = First @ RandomInfraSegment[ g, InfraSegment[First @ Keys @ InfraMeasurement[ g, InfraShell[ c, 8 ], "VertexDensity" ], c], 1, RandomSeeding -> 1 ]},
    {walks = RandomInfraGeodesic[g, germ, r, {10}, All]},
    InfraSubstrateHighlight[g, {
      walks -> StandardOrange,
      SelectInfraWalk[g, walks, All, "From" -> "MostVisited"] -> StandardRed,
      InfraWalk[germ] -> StandardOrange},
      "ThicknessRange" -> {1, 3}]],
  {config, {{3, 6, 3, 6}, {4, 8, 8}, {3, 4, 6, 4}}},
  {r, {3, 6}}]
```

- At scale 3 the beam spreads over a wide region; its members end at 194, 49 and 131 vertices. Every member starts at the germ, so the density is highest there, and the most visited member is the one that stays near the germ: it circles around the end of the germ, on a hexagon, an octagon and a hexagon. A geodesic at a small scale may revisit a vertex, and these members do.
- At scale 6 the members end at 31, 19 and 22 vertices, and the most visited members run straight away from the germ on all three lattices.
- The straight members need not continue the germ's direction: they turn by 30° to 43° on the trihexagonal tiling, by 1° or 36° on the truncated square tiling and by 15° on the rhombitrihexagonal tiling. A lattice keeps a direction only up to the cone of its lattice directions.

## The scale of straightness

- Two readouts of the most visited members, for every scale $r = 2, \ldots, 10$, each the worst over the ties. The extension is a member without the germ.
- The **excess** of an extension is its length minus the distance between its ends. It is zero exactly when the extension is a segment, so the threshold $r^*$ is the scale where the excess first vanishes.
- The **chord deviation** is the largest distance of the extension's vertices from the chord joining its ends, read in the plane. The edges of the three tilings have length 1, so it is in units of the edge length.

```wl
With[
  {readouts = Table[
    With[
      {g = TessellationNeighborhoodGraph[config, 14]},
      {c = First @ GraphCenter[g], d = GraphDistanceMatrix[g], xy = AssociationThread[VertexList[g], GraphEmbedding[g]]},
      {germ = First @ RandomInfraSegment[ g, InfraSegment[First @ Keys @ InfraMeasurement[ g, InfraShell[ c, 8 ], "VertexDensity" ], c], 1, RandomSeeding -> 1 ]},
      Table[
        With[
          {walks = RandomInfraGeodesic[g, germ, r, {10}, All]},
          {ext = Drop[Last /@ Sort @ VertexList @ #, Length[germ] - 1] & /@ SelectInfraWalk[g, walks, All, "From" -> "MostVisited"]},
          {{r, Max[Length[#] - 1 - d[[VertexIndex[g, First @ #], VertexIndex[g, Last @ #]]] & /@ ext]},
           {r, Max[Max[RegionDistance[Line[Lookup[xy, {First @ #, Last @ #}]], Lookup[xy, #]]] & /@ ext]}}],
        {r, 2, 10}]],
    {config, {{3, 6, 3, 6}, {4, 8, 8}, {3, 4, 6, 4}}}]},
  GraphicsRow[{
    ListLinePlot[readouts[[All, All, 1]], PlotRange -> All, AxesLabel -> {Text["r"], Text["excess"]},
      PlotLegends -> Text /@ {"trihexagonal", "truncated square", "rhombitrihexagonal"}],
    ListLinePlot[readouts[[All, All, 2]], PlotRange -> All, AxesLabel -> {Text["r"], Text["deviation"]},
      PlotLegends -> Text /@ {"trihexagonal", "truncated square", "rhombitrihexagonal"}]}]]
```

- Below the threshold the most visited extension is far from a segment; at the threshold the excess drops to zero and stays there. The most visited member jumps from a walk near the germ to a segment.
- The trihexagonal tiling straightens first, at $r^* = 4$, then the rhombitrihexagonal tiling at $r^* = 5$, then the truncated square tiling at $r^* = 6$.
- On the rhombitrihexagonal tiling the deviation falls at the threshold to a floor of 0.8, the staircase of a segment off the lattice directions. On the truncated square tiling it falls to 1.2 at the threshold and settles at 2.0. On the trihexagonal tiling it grows after the threshold, from 1.6 to 2.5: a straight extension zigzags farther from its chord than the bent one.

## Open questions

- [[ The inextensible geodesic at scale $r$ as an object: the infinite walks of the window graph from the germ's window. Is its most visited member eventually a ray at every scale above $r^*$, and how does $r^*$ depend on the length of the germ? ]]
- [[ The loss of direction on a lattice: the straight members follow the cone, not the germ. Does a mesh or a sprinkling, with no preferred directions, restore the germ's direction at large scales? ]]
