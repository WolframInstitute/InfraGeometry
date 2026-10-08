BeginTestSection["ExampleGraphs"]

(* Moved from RiemannianTests.wlt on 2026-10-05, when the tests were split by kernel file (APISurfaceCleanup T9) *)

(* ===================== Example graphs: Sierpinski & Bethe ===================== *)

(* trivalent Sierpinski graph: 3-simplex K_4 truncated n-1 times; 4*3^(n-1) vertices,
   3-regular at every generation (n=1 is K_4, n=2 the truncated tetrahedron) *)
VerificationTest[
  Table[ { VertexCount @ SierpinskiGraph[ n ], EdgeCount @ SierpinskiGraph[ n ], Union @ VertexDegree @ SierpinskiGraph[ n ] }, { n, 1, 4 } ],
  Table[ { 4 * 3^( n - 1 ), 6 * 3^( n - 1 ), { 3 } }, { n, 1, 4 } ],
  TestID -> "Sierpinski-trivalent-truncation"
]

VerificationTest[ IsomorphicGraphQ[ SierpinskiGraph[ 1 ], CompleteGraph[ 4 ] ], True, TestID -> "Sierpinski-seed-is-3-simplex" ]
VerificationTest[ IsomorphicGraphQ[ SierpinskiGraph[ 2 ], PolyhedronData[ "TruncatedTetrahedron", "SkeletonGraph" ] ], True, TestID -> "Sierpinski-level-2-is-truncated-tetrahedron" ]
VerificationTest[ { ConnectedGraphQ @ SierpinskiGraph[ 4 ], PlanarGraphQ @ SierpinskiGraph[ 4 ] }, { True, True }, TestID -> "Sierpinski-connected-planar" ]

(* BetheGraph[n, z]: n shells, coordination z; all interior vertices z-valent, only the
   depth-n boundary 1-valent; vertex count 1 + z((z-1)^n - 1)/(z-2) *)
VerificationTest[
  { KeySort @ Counts @ VertexDegree @ BetheGraph[ 3, 3 ], Max @ VertexDegree @ BetheGraph[ 4, 3 ] },
  { <| 1 -> 12, 3 -> 10 |>, 3 },
  TestID -> "Bethe-coordination-regular"
]

VerificationTest[ VertexCount @ BetheGraph[ 4, 3 ], 1 + 3 ( ( 3 - 1 )^4 - 1 )/( 3 - 2 ), TestID -> "Bethe-vertex-count-formula" ]
VerificationTest[ TreeGraphQ @ BetheGraph[ 3, 4 ], True, TestID -> "Bethe-is-tree" ]

(* BranchingSequenceTree[b]: spherically symmetric tree, b[[l+1]] children at depth l;
   shell sizes are FoldList[Times, 1, b], constant b is CompleteKaryTree *)
VerificationTest[
  Values @ KeySort @ Counts[ First /@ VertexList @ BranchingSequenceTree[ { 2, 3, 2 } ] ],
  FoldList[ Times, 1, { 2, 3, 2 } ],
  TestID -> "BranchingSequenceTree-shell-sizes"
]

VerificationTest[ IsomorphicGraphQ[ BranchingSequenceTree[ { 2, 2, 2 } ], CompleteKaryTree[ 4, 2 ] ], True, TestID -> "BranchingSequenceTree-constant-is-CompleteKaryTree" ]

(* radial symmetry: every vertex at a given depth has the same degree *)
VerificationTest[
  With[ { g = BranchingSequenceTree[ { 3, 2, 2 } ] },
    AllTrue[ GroupBy[ VertexList @ g, First, Union[ VertexDegree[ g, # ] & /@ # ] & ], Length @ # == 1 & ] ],
  True,
  TestID -> "BranchingSequenceTree-radial"
]

(* ===================== Inflation ===================== *)

(* Rewritten by GraphInflation T1 (2026-10-08): one amount and two counts, four edge kinds, a simple graph *)

(* the amounts fix the counts: k new vertices over each vertex, one spoke each, m vertical edges in
   each fiber and h horizontal edges over each base edge, so V = |V| + k |V| and
   E = |E| + k |V| + m |V| + h |E|; on the 3 x 3 grid 9 + 18 vertices and 12 + 18 + 9 + 24 edges *)
VerificationTest[
  With[ { h = ( SeedRandom[ 1 ]; InflateGraph[ GridGraph[ { 3, 3 } ], 2, "VerticalEdges" -> 1, "HorizontalEdges" -> 2 ] ) },
    { VertexCount @ h, EdgeCount @ h } ],
  { 27, 63 },
  TestID -> "InflateGraph-counts-from-amounts"
]

(* a count beyond the candidates takes them all: the one pair of a fiber of two, the four pairs of two fibers of two *)
VerificationTest[
  EdgeCount @ InflateGraph[ GridGraph[ { 3, 3 } ], 2, "VerticalEdges" -> 5, "HorizontalEdges" -> 10 ],
  12 + 18 + 9 + 4 * 12,
  TestID -> "InflateGraph-counts-capped"
]

(* the default is one new vertex over every vertex and one horizontal edge over every edge: the prism over g *)
VerificationTest[
  IsomorphicGraphQ[ InflateGraph[ CycleGraph[ 5 ] ], GraphProduct[ CycleGraph[ 5 ], PathGraph[ { 1, 2 } ] ] ],
  True,
  TestID -> "InflateGraph-default-is-prism"
]

(* no repeated edge and no loop, whatever the draws *)
VerificationTest[
  AllTrue[ Range[ 5 ],
    seed |-> ( SeedRandom[ seed ];
      SimpleGraphQ @ InflateGraph[ GridGraph[ { 4, 4 } ], { 1, 3 }, "VerticalEdges" -> { 0, 3 }, "HorizontalEdges" -> { 0, 9 } ] ) ],
  True,
  TestID -> "InflateGraph-simple"
]

(* the base is the subgraph induced on its vertices, and a fiber vertex meets the base only at its own vertex *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    { h = ( SeedRandom[ 2 ]; InflateGraph[ g, { 1, 3 }, "VerticalEdges" -> 2, "HorizontalEdges" -> 3 ] ) },
    { Sort[ Sort /@ EdgeList @ Subgraph[ h, VertexList @ g ] ] === Sort[ Sort /@ EdgeList @ g ],
      AllTrue[ Cases[ VertexList @ h, _InflatedVertex ], u |-> Intersection[ AdjacencyList[ h, u ], VertexList @ g ] === { First @ u } ] } ],
  { True, True },
  TestID -> "InflateGraph-base-recoverable"
]

(* every edge is of one of four kinds: a base edge, a spoke from a vertex to its fiber, a vertical
   edge inside a fiber, a horizontal edge between the fibers over a base edge *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    { h = ( SeedRandom[ 3 ]; InflateGraph[ g, 2, "VerticalEdges" -> 1, "HorizontalEdges" -> 2 ] ) },
    { kind = edge |-> Replace[ List @@ edge, {
        { InflatedVertex[ v_, _ ], InflatedVertex[ v_, _ ] } :> "Vertical",
        { InflatedVertex[ p_, _ ], InflatedVertex[ q_, _ ] } /; EdgeQ[ g, UndirectedEdge[ p, q ] ] :> "Horizontal",
        { v_, InflatedVertex[ v_, _ ] } | { InflatedVertex[ v_, _ ], v_ } :> "Spoke",
        { p_, q_ } /; EdgeQ[ g, UndirectedEdge[ p, q ] ] :> "Base",
        _ -> "Other" } ] },
    KeySort @ Counts[ kind /@ EdgeList @ h ] ],
  <| "Base" -> 24, "Horizontal" -> 48, "Spoke" -> 32, "Vertical" -> 16 |>,
  TestID -> "InflateGraph-four-kinds"
]

(* the fiber sizes are drawn per vertex from the range *)
VerificationTest[
  With[ { h = ( SeedRandom[ 3 ]; InflateGraph[ CycleGraph[ 20 ], { 1, 4 } ] ) },
    MinMax @ Values @ Counts @ Cases[ VertexList @ h, InflatedVertex[ v_, _ ] :> v ] ],
  { 1, 4 },
  TestID -> "InflateGraph-fiber-size-range"
]

(* a range of vertical edges is drawn per fiber, a range of horizontal edges per base edge: the counts
   vary over the fibers and over the base edges and stay in their ranges *)
VerificationTest[
  With[ { g = CycleGraph[ 12 ] },
    { h = ( SeedRandom[ 4 ]; InflateGraph[ g, 3, "VerticalEdges" -> { 0, 3 }, "HorizontalEdges" -> { 0, 9 } ] ) },
    { vertical = Lookup[ Counts @ Cases[ EdgeList @ h, UndirectedEdge[ InflatedVertex[ v_, _ ], InflatedVertex[ v_, _ ] ] :> v ], VertexList @ g, 0 ] },
    { horizontal = Lookup[
        Counts @ Cases[ EdgeList @ h, UndirectedEdge[ InflatedVertex[ p_, _ ], InflatedVertex[ q_, _ ] ] /; p =!= q :> Sort @ { p, q } ],
        Sort /@ List @@@ EdgeList @ g, 0 ] },
    { Length @ Union @ vertical > 1, SubsetQ[ Range[ 0, 3 ], vertical ], Length @ Union @ horizontal > 1, SubsetQ[ Range[ 0, 9 ], horizontal ] } ],
  { True, True, True, True },
  TestID -> "InflateGraph-per-fiber-per-edge-draws"
]

(* the same seed draws the same inflation, another seed another *)
VerificationTest[
  With[ { draw = seed |-> ( SeedRandom[ seed ];
      InflateGraph[ GridGraph[ { 4, 4 } ], { 1, 3 }, "VerticalEdges" -> { 0, 2 }, "HorizontalEdges" -> { 0, 4 } ] ) },
    { draw[ 5 ] === draw[ 5 ], draw[ 5 ] === draw[ 6 ] } ],
  { True, False },
  TestID -> "InflateGraph-seed"
]

(* the fiber over v lies on a circle about v of radius a third of the shortest base edge, in the base
   embedding's own dimension; a lone fiber vertex is offset too *)
VerificationTest[
  With[ { g = Graph[ GridGraph[ { 3, 3, 3 } ], VertexCoordinates -> Reverse /@ Tuples[ Range @ 3, { 3 } ] ] },
    { offsets = h |-> With[ { coordinates = AssociationThread[ VertexList @ h, GraphEmbedding @ h ] },
        KeyValueMap[ { u, x } |-> x - coordinates @ First @ u, KeySelect[ coordinates, MatchQ[ _InflatedVertex ] ] ] ] },
    { Union[ Length /@ offsets @ InflateGraph[ g, 3 ] ],
      Max @ Abs[ Norm /@ offsets @ InflateGraph[ g, 3 ] - 1/3 ] < 10^-9,
      Max @ Abs[ Norm /@ offsets @ InflateGraph[ g ] - 1/3 ] < 10^-9 } ],
  { { 3 }, True, True },
  TestID -> "InflateGraph-circle-placement"
]

(* inflating an inflated graph nests the names over the fiber vertices and numbers on over the base
   vertices, so no new vertex takes an old name: 3, 6 and 12 vertices over the triangle *)
VerificationTest[
  With[ { h = InflateGraph[ InflateGraph[ CycleGraph[ 3 ] ] ] },
    { VertexCount @ h, Length @ Cases[ VertexList @ h, InflatedVertex[ _InflatedVertex, 1 ] ], Cases[ VertexList @ h, InflatedVertex[ 1, _ ] ], SimpleGraphQ @ h } ],
  { 12, 3, { InflatedVertex[ 1, 1 ], InflatedVertex[ 1, 2 ] }, True },
  TestID -> "InflateGraph-nesting"
]

(* Graph options reach the graph *)
VerificationTest[
  Options[ InflateGraph[ CycleGraph[ 4 ], 1, VertexLabels -> "Name" ], VertexLabels ],
  { VertexLabels -> { "Name" } },
  TestID -> "InflateGraph-graph-options"
]

EndTestSection[]
