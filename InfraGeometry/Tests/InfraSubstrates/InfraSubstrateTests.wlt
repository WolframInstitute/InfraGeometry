BeginTestSection["InfraSubstrate"]

(* Moved from RiemannianTests.wlt on 2026-10-05, when the tests were split by kernel file (APISurfaceCleanup T9) *)

(* ===================== Ambient styles ===================== *)

VerificationTest[
    InfraSubstrateStyle[],
    <|"Default" -> {"Default", "Small", "Medium", "Large"}, "Custom" -> {}|>,
    TestID -> "InfraSubstrateStyle-association"
]

VerificationTest[
    InfraSubstrateStyle[All],
    {"Default", "Small", "Medium", "Large"},
    TestID -> "InfraSubstrateStyle-names"
]

(* a style is one dot: at a fixed image size the same style renders the same on-screen radius
   on a 6-cycle, a 144-vertex grid and a tree, because the scaled size is a fraction of the
   picture.  The default sizing is a fraction of the graph's own nearest-neighbour spacing
   instead, and when the size was written as an undocumented VertexSize spec it silently fell
   back to that, every substrate drawing its own dot between 2.5 and 12.8 pixels -- a ratio of
   5, against the 1.3 the scaled sizes hold here *)
VerificationTest[
    With[{radius = g |-> Median @ Values @ ComponentMeasurements[
        ColorNegate @ Binarize[ColorConvert[Rasterize[Show[
              Graph[Graph[g, Sequence @@ InfraSubstrateStyle["Small"]], EdgeStyle -> Opacity[0]],
              ImageSize -> 200], "Image", Background -> White], "Grayscale"], 0.97],
        "EquivalentDiskRadius"]},
      {radii = radius /@ {CycleGraph[6], GridGraph[{12, 12}], KaryTree[40], PetersenGraph[]}},
      Max[radii] / Min[radii] < 1.5],
    True,
    TestID -> "InfraSubstrateStyle-one-dot-per-graph"
]

(* ===================== InfraSubstrate ===================== *)

(* an unknown name is a non-match: the call stays as typed, silently *)
VerificationTest[
    Quiet[
      {Head @ InfraSubstrate["Plane", "Medium"], Head @ InfraSubstrate["Plane"],
       Head @ InfraSubstrateCode["Plane", "Medium"], Head @ InfraFiberedSubstrate["Plane", "Small"]},
      All],
    {InfraSubstrate, InfraSubstrate, InfraSubstrateCode, InfraFiberedSubstrate},
    TestID -> "InfraSubstrate-unknown-name-unevaluated"
]

VerificationTest[
    {InfraSubstrate["Plane", "Medium"], InfraSubstrate["Plane"],
     InfraSubstrateCode["Plane", "Medium"], InfraFiberedSubstrate["Plane", "Small"]},
    {InfraSubstrate["Plane", "Medium"], InfraSubstrate["Plane"],
     InfraSubstrateCode["Plane", "Medium"], InfraFiberedSubstrate["Plane", "Small"]},
    TestID -> "InfraSubstrate-unknown-name-no-message"
]

VerificationTest[
    AllTrue[InfraSubstrate[All], GraphQ @ InfraSubstrate[#, "Small"] &],
    True,
    TestID -> "InfraSubstrate-roster-still-graphs"
]

(* the grid substrate is the grid with its rim contour removed: no edge joins two rim
   vertices, the whiskers stay, the corners fall off *)
VerificationTest[
    With[{int = InfraSubstrate["SquareGridGraph", {9, 9}]},
      {rim = Pick[VertexList @ #, Thread[VertexDegree @ # < 4]] & @ GridGraph[{9, 9}]},
      {IsomorphicGraphQ[Subgraph[int, Complement[VertexList @ int, rim]], GridGraph[{7, 7}]],
       Select[EdgeList @ int, SubsetQ[rim, List @@ #] &] === {},
       VertexCount @ int,
       IsomorphicGraphQ[int, BoundarylessGraph[GridGraph[{9, 9}], Method -> "MaxDegree"]]}],
    {True, True, 77, True},
    TestID -> "InfraSubstrate-grid-exact"
]

(* the strip of a tiling patch deletes exactly the edges joining two degree-deficient
   vertices of the full patch, then the vertices this isolates *)
VerificationTest[
    With[{full = TessellationNeighborhoodGraph[{3, 6}, 6], int = InfraSubstrate["TriangularTilingGraph", "Small"]},
      {rim = GraphExteriorBoundary[full, Method -> "MaxDegree"]},
      {SubsetQ[VertexList @ full, VertexList @ int],
       Select[EdgeList @ int, SubsetQ[rim, List @@ #] &] === {},
       ConnectedGraphQ @ int}],
    {True, True, True},
    TestID -> "InfraSubstrate-interior-tiling-strip"
]

(* a substrate is bare combinatorics by default; "KeepCoordinates" -> True draws the grid
   at its own lattice coordinates *)
VerificationTest[
    {Options[InfraSubstrate["SquareGridGraph", {9, 9}], VertexCoordinates] === {VertexCoordinates -> Automatic},
     SubsetQ[Tuples[Range @ 9, {2}], Round /@ GraphEmbedding @ InfraSubstrate["SquareGridGraph", {9, 9}, "KeepCoordinates" -> True]]},
    {True, True},
    TestID -> "InfraSubstrate-bare-coordinates"
]

(* a boundaryless or intrinsic-boundary substrate keeps every vertex *)
VerificationTest[
    {VertexCount @ InfraSubstrate["BinaryTreeGraph", 63], VertexCount @ InfraSubstrate["CompleteGraph", "Small"]},
    {63, 10},
    TestID -> "InfraSubstrate-boundaryless-full"
]

(* the mesh patch is connected and pendant-free, and its kept coordinates lie in the unit square *)
VerificationTest[
    With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
      {ConnectedGraphQ @ g, Min @ VertexDegree @ g >= 2,
       AllTrue[GraphEmbedding @ g, 0 <= Min @ # && Max @ # <= 1 &]}],
    {True, True, True},
    TestID -> "InfraSubstrate-plane-mesh"
]

(* the square torus is the 4-regular Cayley graph of Z_m x Z_n *)
VerificationTest[
    With[{g = InfraSubstrate["SquareTorusGraph", {8, 6}]},
      {VertexCount @ g, Union @ VertexDegree @ g, GraphDiameter @ g}],
    {48, {4}, 7},
    TestID -> "InfraSubstrate-torus-square"
]

(* diluted tree: branch 2 exactly at depths Ceiling[k^(1/alpha)], so the shell at depth r has 2^#{branch depths <= r} vertices *)
VerificationTest[
    With[{g = InfraSubstrate["DilutedTreeGraph", {1/2, 20}]},
      {shells = Values @ KeySort @ Counts @ GraphDistance[g, {0, 1}]},
      shells === Table[2^Length @ Select[Union @ Select[Ceiling[Range[20]^2], LessEqualThan @ 20], LessEqualThan @ r], {r, 0, 20}]],
    True,
    TestID -> "InfraSubstrate-diluted-growth"
]

(* a registry universe is named by its wm number and its size is a generation count, so the size
   and the count it stands for must give the same graph *)
VerificationTest[
    With[{named = InfraSubstrate["wm6655", "Small"], raw = InfraSubstrate["wm6655", 7]},
      {VertexList @ named === VertexList @ raw, EdgeList @ named === EdgeList @ raw, ConnectedGraphQ @ named}],
    {True, True, True},
    TestID -> "InfraSubstrate-registry-universe"
]

(* every patch substrate is a connected graph at every named size *)
VerificationTest[
    AllTrue[{"SquareMeshGraph", "TriangularTilingGraph", "SquareTilingGraph", "HexagonalTilingGraph"},
      ConnectedGraphQ @ InfraSubstrate[#, "Small"] &],
    True,
    TestID -> "InfraSubstrate-patches-connected"
]

(* the interior of a tiling patch carries the valence the tiling prescribes *)
VerificationTest[
    Max @ VertexDegree @ InfraSubstrate[#, "Small"] & /@ {"TriangularTilingGraph", "SquareTilingGraph", "HexagonalTilingGraph"},
    {6, 4, 3},
    TestID -> "InfraSubstrate-tiling-valence"
]

(* the three named sizes are increasing *)
VerificationTest[
    AllTrue[{"TriangularTilingGraph", "SquareTilingGraph", "HexagonalTilingGraph", "SquareGridGraph", "CubicGridGraph",
             "SquareTorusGraph", "BinaryTreeGraph", "SierpinskiTriangleGraph", "MengerCarpetGraph", "MengerSpongeGraph", "UniformLengthSphereGraph"},
      name |-> OrderedQ[VertexCount /@ Map[InfraSubstrate[name, #] &, {"Small", "Medium", "Large"}]]],
    True,
    TestID -> "InfraSubstrate-sizes-increase"
]

(* the sphere mesh honours its size: the {"Area" -> m} + PrecisionGoal spec form is the one
   DiscretizeRegion respects on Sphere[], and every vertex sits on the unit sphere *)
VerificationTest[
    With[{small = InfraSubstrate["SphereMeshGraph", "Small", "KeepCoordinates" -> True],
          medium = InfraSubstrate["SphereMeshGraph", "Medium", "KeepCoordinates" -> True]},
      {VertexCount[small] < VertexCount[medium],
       Max[Abs[Norm /@ GraphEmbedding[small] - 1]] < 1.*^-6}],
    {True, True},
    TestID -> "InfraSubstrate-sphere-mesh-sizes"
]

(* "Inflate" inflates any substrate: the base survives as the induced subgraph, two new vertices
   over every vertex and one horizontal edge over every edge give 3 |V| vertices and 2 |E| + 2 |V|
   edges, the fibers carry coordinates of the substrate's own dimension, and the draw is governed by
   the seed, so the same seed re-draws the same inflation *)
VerificationTest[
    With[{bare = InfraSubstrate["CubicGridGraph", "Small"]},
      {inf = (SeedRandom[2]; InfraSubstrate["CubicGridGraph", "Small", "Inflate" -> 2, "KeepCoordinates" -> True])},
      {IsomorphicGraphQ[Subgraph[inf, VertexList @ bare], bare],
       {VertexCount @ inf, EdgeCount @ inf} === {3 VertexCount @ bare, 2 EdgeCount @ bare + 2 VertexCount @ bare},
       VertexCount @ InfraSubstrate["CubicGridGraph", "Small", "Inflate" -> 4] === 5 VertexCount @ bare,
       Union[Length /@ GraphEmbedding @ inf],
       AllTrue[GraphEmbedding @ inf, VectorQ[#, NumericQ] &],
       EdgeList @ inf === EdgeList @ (SeedRandom[2]; InfraSubstrate["CubicGridGraph", "Small", "Inflate" -> 2, "KeepCoordinates" -> True])}],
    {True, True, True, {3}, True, True},
    TestID -> "InfraSubstrate-inflate-any-substrate"
]

(* "Inflate" -> k is InflateGraph[g, k], k a number or a {min, max} range, and "Inflate" -> {k, opts}
   passes the two controls: two vertices and one vertical edge in every fiber and no horizontal edge
   add 3 |V| edges and keep the fibers apart; {opts} alone keeps one vertex over every vertex *)
VerificationTest[
    SeedRandom[1]; With[{base = InfraSubstrate["SquareTilingGraph", "Small"]},
      {fibers = g |-> Length /@ GroupBy[Cases[VertexList @ g, InflatedVertex[v_, _] :> v], Identity]},
      {apart = InfraSubstrate["SquareTilingGraph", "Small", "Inflate" -> {2, "VerticalEdges" -> 1, "HorizontalEdges" -> 0}]},
      {Union @ Values @ fibers @ InfraSubstrate["SquareTilingGraph", "Small", "Inflate" -> 2],
       MinMax @ Values @ fibers @ InfraSubstrate["SquareTilingGraph", "Small", "Inflate" -> {1, 3}],
       MinMax @ Values @ fibers @ InfraSubstrate["SquareTilingGraph", "Small", "Inflate" -> {{1, 3}, "HorizontalEdges" -> 0}],
       Union @ Values @ fibers @ InfraSubstrate["SquareTilingGraph", "Small", "Inflate" -> {"HorizontalEdges" -> 0}],
       EdgeCount @ apart - EdgeCount @ base === 3 VertexCount @ base,
       Cases[EdgeList @ apart, UndirectedEdge[InflatedVertex[a_, _], InflatedVertex[b_, _]] /; a =!= b] === {}}],
    {{2}, {1, 3}, {1, 3}, {1}, True, True},
    TestID -> "InfraSubstrate-inflate-option-forms"
]

(* the three named sizes draw three distinct dots, and inflating does not merge any two of
   them: the vertex-count fallback saturates at the "Large" look, so deferring an inflated
   substrate to it would give "Medium" and "Large" one size *)
VerificationTest[
    With[{dot = opts |-> VertexSize /. Options[InfraSubstrate["SquareTilingGraph", Sequence @@ opts], VertexSize]},
      {DuplicateFreeQ[dot /@ {{"Small"}, {"Medium"}, {"Large"}}],
       DuplicateFreeQ[dot /@ {{"Small", "Inflate" -> 2}, {"Medium", "Inflate" -> 2}, {"Large", "Inflate" -> 2}}],
       dot[{"Small"}] === dot[{"Small", "Inflate" -> 2}]}],
    {True, True, True},
    TestID -> "InfraSubstrate-sizes-keep-distinct-dots"
]

(* a random substrate is seeded from outside, like any other draw: the same SeedRandom recovers
   the same graph, a different one draws a different graph, and a call consumes the stream like
   any other draw.  UniformLengthSphere is the probe because its relaxation is genuinely
   random -- the lattice, tiling, mesh and Wolfram-model lines are deterministic *)
VerificationTest[
    With[{draw = seed |-> (SeedRandom[seed]; InfraSubstrate["UniformLengthSphereGraph", "Small"])},
      {draw[1] === draw[1], draw[1] =!= draw[77],
       SeedRandom[5]; InfraSubstrate["UniformLengthSphereGraph", "Small"] =!= InfraSubstrate["UniformLengthSphereGraph", "Small"]}],
    {True, True, True},
    TestID -> "InfraSubstrate-seeded-from-outside"
]

(* the emitted code is the code that runs, without the backdrop style: it is held, so seeding
   and then ReleaseHold gives the graph InfraSubstrate draws at that seed with the "Default"
   style (building the code itself realizes the graph once, so the seed goes after the build),
   and it is readable -- no size table left uncollapsed, no symbol carrying
   a private context, none carrying the $ that ReplaceAll leaves on a rewritten local.  The six
   round-trip cases cover the shapes: a bare tiling line, a mesh line whose table hangs off a
   rule, a line with an embedded helper, one with no coordinate clause, an inflated line with
   kept coordinates, and one inflated with its controls *)
VerificationTest[
    With[{cases = {{"SquareTilingGraph", "Small"}, {"SquareMeshGraph", "Small"}, {"SquareTorusGraph", "Small"},
                   {"wm6655", "Small"}, {"CubicGridGraph", "Small", "Inflate" -> 2, "KeepCoordinates" -> True},
                   {"SquareTilingGraph", "Small", "Inflate" -> {{1, 2}, "VerticalEdges" -> 1, "HorizontalEdges" -> {0, 2}}}}},
      {roster = Map[name |-> InfraSubstrateCode[name, "Small"], InfraSubstrate[All]]},
      {Map[spec |-> (SeedRandom[3]; InfraSubstrate @@ Insert[spec, "Default", 3]), cases] ===
         Map[spec |-> With[{code = InfraSubstrateCode @@ spec}, SeedRandom[3]; ReleaseHold[code]], cases],
       Union[Head /@ roster],
       Cases[roster, s_Symbol /; StringEndsQ[Context @ Unevaluated @ s, "`PackagePrivate`"], Infinity, Heads -> True],
       Cases[roster, s_Symbol /; StringEndsQ[SymbolName @ Unevaluated @ s, "$"], Infinity, Heads -> True],
       Cases[roster, HoldPattern[ReplaceAll[_, _]], Infinity]}],
    {True, {HoldForm}, {}, {}, {}},
    TestID -> "InfraSubstrateCode-round-trips"
]

(* the styles are named by size and the option list splices into any graph construction; the
   two-argument form is per substrate and falls back to the size default, so a custom look for
   one substrate is one more definition *)
VerificationTest[
    {InfraSubstrateStyle["SquareMeshGraph", "Small"] === InfraSubstrateStyle["Small"],
     InfraSubstrateStyle["wm6655", "Large"] === InfraSubstrateStyle["Large"],
     InfraSubstrateStyle["SquareTorusGraph", "Default"],
     Sort[First /@ InfraSubstrateStyle["Large"]],
     Options[Graph[GridGraph[{5, 5}], Sequence @@ InfraSubstrateStyle["Small"]], EdgeStyle][[1, 2]] =!= Automatic},
    {True, True, {}, {EdgeStyle, VertexSize, VertexStyle}, True},
    TestID -> "InfraSubstrateStyle-palette"
]

(* the roster is classified by what a substrate models; the flat list carries every name *)
VerificationTest[
    With[{classes = InfraSubstrate[], names = InfraSubstrate[All]},
      {Keys @ classes,
       Length @ names >= 24,
       SubsetQ[names, {"SquareMeshGraph", "SquareTilingGraph", "SquareTorusGraph", "wm6655", "UniformLengthSphereGraph",
         "MengerCarpetGraph", "MengerSpongeGraph"}]}],
    {{"OpenManifold", "ClosedManifold", "Fractal", "Exotic", "WolframModel"}, True, True},
    TestID -> "InfraSubstrate-roster"
]

(* the roster construction is deterministic given the random state: two fresh (unmemoized)
   builds of the same raw size spec agree vertex for vertex *)
VerificationTest[
    With[{seed = Hash @ {"SquareMeshGraph", 0.013}},
      {g1 = (SeedRandom[seed]; InfraSubstrate["SquareMeshGraph", 0.013]),
       g2 = (SeedRandom[seed]; InfraSubstrate["SquareMeshGraph", 0.013])},
      {VertexList @ g1 === VertexList @ g2, EdgeList @ g1 === EdgeList @ g2}],
    {True, True},
    TestID -> "InfraSubstrate-seeded-generation"
]

(* MaxDegree rim trim: the boundary is the degree-deficient rim; its contour edges go,
   rim vertices with an inward edge stay as whiskers, the rest are dropped as isolated.
   11x11 grid: 9x9 interior + 36 whiskers; 7^3 cube: 5^3 interior + 150 face whiskers
   (the edge and corner vertices have no interior neighbour and fall off) *)
VerificationTest[
  {VertexCount[BoundarylessGraph[GridGraph[{11, 11}], Method -> "MaxDegree"]],
   VertexCount[BoundarylessGraph[GridGraph[{7, 7, 7}], Method -> "MaxDegree"]]},
  {117, 275},
  TestID -> "BoundarylessGraph-MaxDegree-lattice-interior"
]

EndTestSection[]
