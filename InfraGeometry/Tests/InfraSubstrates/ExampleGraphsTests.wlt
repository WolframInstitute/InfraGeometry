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

(* inflation leaves the base intact: it survives as the induced subgraph on the original vertices *)
VerificationTest[
    SeedRandom[42]; With[{base = GridGraph[{6, 6}]},
      {inf = InflateGraph[base, "ExtraVertices" -> {1, 3}, "ExtraEdges" -> 1]},
      {IsomorphicGraphQ[Subgraph[inf, VertexList @ base], base], VertexCount[inf] > VertexCount[base]}],
    {True, True},
    TestID -> "InflateGraph-base-recoverable"
]

(* every base vertex carries a fiber of the requested size, and each fiber vertex is joined to it *)
VerificationTest[
    SeedRandom[42]; With[{base = CycleGraph[8]},
      {inf = InflateGraph[base, "ExtraVertices" -> 2, "ExtraEdges" -> 0, "Density" -> 0]},
      {VertexCount[inf], AllTrue[VertexList @ base, MemberQ[AdjacencyList[inf, InflatedVertex[#, 1]], #] &]}],
    {24, True},
    TestID -> "InflateGraph-fibers-attached"
]

(* cross-fiber edges only join fibers whose base vertices lie within "Radius" of each other *)
VerificationTest[
    With[{base = GridGraph[{6, 6}]},
      AllTrue[{1, 2, 3},
        Function[r,
          SeedRandom[7];
          AllTrue[
            Cases[EdgeList @ InflateGraph[base, "ExtraVertices" -> 2, "Radius" -> r, "Density" -> 2],
              UndirectedEdge[InflatedVertex[a_, _], InflatedVertex[b_, _]] /; a =!= b :> {a, b}],
            GraphDistance[base, First @ #, Last @ #] <= r &]]]],
    True,
    TestID -> "InflateGraph-radius-respected"
]

(* fiber size is sampled inside the given range, per base vertex *)
VerificationTest[
    SeedRandom[3]; With[{base = CycleGraph[20]},
      {inf = InflateGraph[base, "ExtraVertices" -> {1, 4}]},
      {sizes = Length /@ GroupBy[Cases[VertexList @ inf, InflatedVertex[v_, _] :> v], Identity]},
      {Min @ Values @ sizes >= 1, Max @ Values @ sizes <= 4, Length @ sizes == 20}],
    {True, True, True},
    TestID -> "InflateGraph-fiber-size-range"
]

(* the jitter lives in a ball of the base embedding's own dimension, so a fiber over a 3D base
   gets numeric 3D coordinates within the jitter radius of its base vertex *)
VerificationTest[
    SeedRandom[11]; With[{base = Graph[GridGraph[{4, 4, 4}], VertexCoordinates -> Reverse /@ Tuples[Range @ 4, {3}]]},
      {coords = AssociationThread[VertexList @ #, GraphEmbedding @ #] & @ InflateGraph[base, "ExtraVertices" -> 2]},
      {Union[Length /@ Values @ coords],
       AllTrue[Values @ coords, VectorQ[#, NumericQ] &],
       Max @ KeyValueMap[Norm[#2 - coords[First @ #1]] &, KeySelect[coords, MatchQ[InflatedVertex[_, _]]]] < 0.31}],
    {{3}, True, True},
    TestID -> "InflateGraph-jitter-ambient-dimension"
]

EndTestSection[]
