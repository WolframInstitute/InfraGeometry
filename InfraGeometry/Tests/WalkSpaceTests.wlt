BeginTestSection["WalkSpace"]

walkGraph       = walk |-> PathGraph[ MapIndexed[ { First @ #2, #1 } &, walk ], DirectedEdges -> True ];
closedWalkGraph = walk |-> With[ { core = MapIndexed[ { First @ #2, #1 } &, If[ Length[ walk ] >= 2 && First @ walk === Last @ walk, Most @ walk, walk ] ] },
  Graph[ core, DirectedEdge @@@ Partition[ core, 2, 1, 1 ] ] ];
geodesicGraph   = WolframInstitute`InfraGeometry`PackageScope`geodesicGraph;
walkSequence    = WolframInstitute`InfraGeometry`PackageScope`walkSequence;
infraSpread     = WolframInstitute`InfraGeometry`PackageScope`infraSpread;
walkSeq[ w_Graph ] := Last /@ VertexList[ w ]
walkSeqs[ w_Graph ] := { walkSeq @ w }
walkSeqs[ ws_List ] := walkSeq /@ ws

(* ===== Sublist invariants under default n = All ===== *)

VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ], paths = (FindInfraSegment[ GridGraph[ { 3, 3 } ], 1, 9, All ]) },
    SubsetQ[ paths, SelectInfraWalk[ g, paths, All, "From" -> "Center" ] ]
  ],
  True,
  TestID -> "SelectInfraWalk-Center-pool-is-sublist"
]

VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ], paths = (FindInfraSegment[ GridGraph[ { 3, 3 } ], 1, 9, All ]) },
    SubsetQ[ paths, SelectInfraWalk[ g, paths, All, "From" -> "Periphery" ] ]
  ],
  True,
  TestID -> "SelectInfraWalk-Periphery-pool-is-sublist"
]

(* "MostVisited" (longest additive-weight path under geodesic-occupation weights)
   selects the same set of most-visited geodesics whether the family arrives as bare
   vertex lists or as walk graphs -- the two SelectInfraWalk code paths must agree *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ { paths = FindInfraSegment[ g, 1, 25, All ] },
      Sort[ SelectInfraWalk[ g, paths, All, "From" -> "MostVisited" ] ] ===
      Sort[ walkSequence /@ SelectInfraWalk[ g, geodesicGraph /@ paths, All,
        "From" -> "MostVisited" ] ] ]
  ],
  True,
  TestID -> "SelectInfraWalk-MostVisited-list-and-graph-forms-agree"
]

VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ], paths = (FindInfraSegment[ GridGraph[ { 3, 3 } ], 1, 9, All ]) },
    SubsetQ[ paths, EmbeddingClosest[ g, paths, { 1, 9 } ] ]
  ],
  True,
  TestID -> "EmbeddingClosest-returns-sublist"
]

(* Arbitrary-curve reference: a bare list of >= 3 plane points picks the
   best-approximating bundle element (a sublist of the input). *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ], paths = (FindInfraSegment[ GridGraph[ { 3, 3 } ], 1, 9, All ]) },
    SubsetQ[ paths, EmbeddingClosest[ g, paths, { { 0, 0 }, { 1, 1 }, { 2, 2 } } ] ]
  ],
  True,
  TestID -> "EmbeddingClosest-curve-list-returns-sublist"
]

(* a bundle of walk graphs selects on its vertex sequences and comes back as the graphs picked *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ], bare = (FindInfraSegment[ GridGraph[ { 3, 3 } ], 1, 9, All ]) },
    { picked = EmbeddingClosest[ g, walkGraph /@ bare, Line[ { { 0, 0 }, { 1, 1 }, { 2, 2 } } ] ] },
    MatchQ[ picked, { __Graph } ] && SubsetQ[ bare, walkSeqs @ picked ]
  ],
  True,
  TestID -> "EmbeddingClosest-walk-graphs-return-graphs"
]

(* FindEmbeddingClosestPath: generative snap of a curve to a walk graph whose
   vertex sequence is a connected walk (consecutive vertices adjacent), tracing
   the curve under the embedding. *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ { p = FindEmbeddingClosestPath[ g, Line[ GraphEmbedding[ g ][[ { 1, 13, 25 } ]] ] ] },
      GraphQ[ p ] &&
      AllTrue[ Partition[ walkSeq @ p, 2, 1 ], EdgeQ[ g, UndirectedEdge @@ # ] & ]
    ]
  ],
  True,
  TestID -> "FindEmbeddingClosestPath-traces-connected-walk"
]

(* ===== Count contract: strict n, UpTo, All ===== *)

VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ], paths = (FindInfraSegment[ GridGraph[ { 3, 3 } ], 1, 9, All ]) },
    Length @ SelectInfraWalk[ g, paths, 1, "From" -> "Center" ]
  ],
  1,
  TestID -> "SelectInfraWalk-strict-n-1"
]

VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ], paths = (FindInfraSegment[ GridGraph[ { 3, 3 } ], 1, 9, All ]) },
    Length @ SelectInfraWalk[ g, paths, UpTo[ 3 ], "From" -> "Center" ] <= 3
  ],
  True,
  TestID -> "SelectInfraWalk-UpTo-soft"
]

VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ], paths = (FindInfraSegment[ GridGraph[ { 3, 3 } ], 1, 9, All ]) },
    SelectInfraWalk[ g, paths, 99 ]
  ],
  { },
  TestID -> "SelectInfraWalk-strict-overcount-fails"
]

VerificationTest[
  SelectInfraWalk[ GridGraph[ { 3, 3 } ], { }, 1 ],
  { },
  TestID -> "SelectInfraWalk-empty-strict-fails"
]

VerificationTest[
  SelectInfraWalk[ GridGraph[ { 3, 3 } ], { }, All ],
  { },
  TestID -> "SelectInfraWalk-empty-All-empty"
]

(* ===== Default count = 1, matches FindInfraPoint ===== *)

VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ], paths = (FindInfraSegment[ GridGraph[ { 3, 3 } ], 1, 9, All ]) },
    Length @ SelectInfraWalk[ g, paths ]
  ],
  1,
  TestID -> "SelectInfraWalk-default-n-is-1"
]

(* ===== Operator form ===== *)

VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ], paths = FindInfraSegment[ GridGraph[ { 3, 3 } ], 1, 9, All ] },
    SubsetQ[ paths, SelectInfraWalk[ g, All, "From" -> "Center" ][ paths ] ]
  ],
  True,
  TestID -> "SelectInfraWalk-operator-form-runs"
]

VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ], paths = (FindInfraSegment[ GridGraph[ { 3, 3 } ], 1, 9, All ]) },
    SelectInfraWalk[ g, paths, All, "From" -> "Center", "Metric" -> "Hausdorff" ] ===
      ( SelectInfraWalk[ g, All, "From" -> "Center", "Metric" -> "Hausdorff" ][ paths ] )
  ],
  True,
  TestID -> "SelectInfraWalk-operator-form-options-agree"
]

(* ===== the shape of the pool comes back ===== *)

VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ],
          walks = geodesicGraph /@ FindInfraSegment[ GridGraph[ { 3, 3 } ], 1, 9, All ] },
    MatchQ[ SelectInfraWalk[ g, walks, All, "From" -> "Center" ], { __Graph } ]
  ],
  True,
  TestID -> "SelectInfraWalk-preserves-the-path-graph-form"
]

(* a circle's representative family is a plain List of cyclic vertex lists (EuclideanInertHeads),
   so SelectInfraWalk keeps that shape rather than a walk-graph form *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ],
          cycles = FindInfraRepresentative[ GridGraph[ { 4, 4 } ], InfraCircle[ 6, { 1, 2 } ], All ] },
    MatchQ[ SelectInfraWalk[ g, cycles, All, "From" -> "Center" ], { { __Integer } .. } ]
  ],
  True,
  TestID -> "SelectInfraWalk-preserves-the-vertex-list-form"
]

(* ===== Length-1 / empty input ===== *)

VerificationTest[
  SelectInfraWalk[ GridGraph[ { 3, 3 } ], { { 1, 2, 3 } }, All, "From" -> "Center" ],
  { { 1, 2, 3 } },
  TestID -> "SelectInfraWalk-Center-singleton-identity"
]

VerificationTest[
  SelectInfraWalk[ GridGraph[ { 3, 3 } ], { { 1, 2, 3 } }, All, "From" -> "Periphery", "Metric" -> "Hausdorff" ],
  { { 1, 2, 3 } },
  TestID -> "SelectInfraWalk-Periphery-singleton-identity"
]

VerificationTest[
  EmbeddingClosest[ GridGraph[ { 3, 3 } ], { { 1, 2, 3 } }, { 1, 3 } ],
  { { 1, 2, 3 } },
  TestID -> "EmbeddingClosest-singleton-identity"
]

(* ===== SelectInfraWalk length-based pool selectors ===== *)

VerificationTest[
  SelectInfraWalk[ GridGraph[ { 3, 3 } ], { { 1, 2, 3, 4, 5 }, { 1, 2, 3 }, { 1, 2, 3, 4 } }, All,
    "From" -> "MinLength", "Cyclic" -> True ],
  { { 1, 2, 3 } },
  TestID -> "SelectInfraWalk-MinLength-picks-min"
]

VerificationTest[
  SelectInfraWalk[ GridGraph[ { 3, 3 } ], { { 1, 2, 3, 4, 5 }, { 1, 2, 3 }, { 1, 2, 3, 4 } }, All,
    "From" -> "MaxLength", "Cyclic" -> True ],
  { { 1, 2, 3, 4, 5 } },
  TestID -> "SelectInfraWalk-MaxLength-picks-max"
]

VerificationTest[
  SelectInfraWalk[ GridGraph[ { 3, 3 } ], { { 1, 2, 3 }, { 4, 5, 6 }, { 1, 2, 3, 4 } }, All,
    "From" -> "MinLength", "Cyclic" -> True ],
  { { 1, 2, 3 }, { 4, 5, 6 } },
  TestID -> "SelectInfraWalk-MinLength-keeps-ties"
]

(* ===== Metric option carries through ===== *)

VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ], paths = (FindInfraSegment[ GridGraph[ { 3, 3 } ], 1, 9, All ]) },
    Length[ paths ] > 1 &&
      AllTrue[ { "Hausdorff", "Frechet", "MeanFrechet" },
        m |-> SubsetQ[ paths, SelectInfraWalk[ g, paths, All, "From" -> "Center", "Metric" -> m ] ] ]
  ],
  True,
  TestID -> "SelectInfraWalk-Center-all-metrics-return-sublists"
]

(* ===== MostVisited pool ===== *)

VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ], paths = (FindInfraSegment[ GridGraph[ { 3, 3 } ], 1, 9, All ]) },
    SubsetQ[ paths, SelectInfraWalk[ g, paths, All, "From" -> "MostVisited" ] ]
  ],
  True,
  TestID -> "SelectInfraWalk-MostVisited-returns-sublist"
]

VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ], paths = (FindInfraSegment[ GridGraph[ { 3, 3 } ], 1, 9, All ]) },
    Length @ SelectInfraWalk[ g, paths, All, "From" -> "MostVisited" ] >= 1
  ],
  True,
  TestID -> "SelectInfraWalk-MostVisited-non-empty"
]

VerificationTest[
  With[ { g = PathGraph[ Range @ 5 ], wrapped = FindInfraSegment[ PathGraph[ Range @ 5 ], 1, 5, All ] },
    SelectInfraWalk[ g, wrapped, All, "From" -> "MostVisited" ] === wrapped
  ],
  True,
  TestID -> "SelectInfraWalk-MostVisited-unique-segment-passthrough"
]

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ], cycles = FindInfraRepresentative[ GridGraph[ { 4, 4 } ], InfraCircle[ 6, { 1, 2 } ], All ] },
    SubsetQ[ cycles, SelectInfraWalk[ g, cycles, All, "From" -> "MostVisited", "Cyclic" -> True ] ]
  ],
  True,
  TestID -> "SelectInfraWalk-MostVisited-returns-sublist"
]

(* ===== Bottleneck pool: max-min bundle occupation of vertices + edges ===== *)

VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ], paths = (FindInfraSegment[ GridGraph[ { 3, 3 } ], 1, 9, All ]) },
    With[ { vC = Counts @ Catenate @ paths,
            eC = Counts @ Catenate @ ( Sort /@ Partition[ #, 2, 1 ] & /@ paths ) },
      With[ { scores = Min @ Join[ Lookup[ vC, #, 0 ], Lookup[ eC, Sort /@ Partition[ #, 2, 1 ], 0 ] ] & /@ paths },
        Sort @ SelectInfraWalk[ g, paths, All, "From" -> "Bottleneck" ] ===
          Sort @ Pick[ paths, Thread[ scores == Max @ scores ] ]
      ]
    ]
  ],
  True,
  TestID -> "SelectInfraWalk-Bottleneck-maximin-occupation"
]

(* ===== Distance constraint: Max k-clique in path-space ===== *)

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ], paths = (FindInfraSegment[ GridGraph[ { 4, 4 } ], 1, 16, All ]) },
    Length @ SelectInfraWalk[ g, paths, 2, "Distance" -> "Max" ]
  ],
  2,
  TestID -> "SelectInfraWalk-Distance-Max-strict-2"
]

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ], paths = (FindInfraSegment[ GridGraph[ { 4, 4 } ], 1, 16, All ]) },
    SubsetQ[ paths, SelectInfraWalk[ g, paths, UpTo[ 3 ], "Distance" -> "Max" ] ]
  ],
  True,
  TestID -> "SelectInfraWalk-Distance-Max-UpTo-3-sublist"
]

(* ===== "From" anchor -> spec ===== *)

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ], paths = (FindInfraSegment[ GridGraph[ { 4, 4 } ], 1, 16, All ]) },
    With[ { ref = First @ paths,
            others = SelectInfraWalk[ g, paths, All, "From" -> ( First @ paths -> "Max" ) ] },
      SubsetQ[ paths, others ]
    ]
  ],
  True,
  TestID -> "SelectInfraWalk-From-anchor-Max-returns-sublist"
]

(* ===== Empty pool returns empty ===== *)

VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    SelectInfraWalk[ g, { }, All ]
  ],
  { },
  TestID -> "SelectInfraWalk-empty-All-passthrough"
]

(* ===== SprayGraph ===== *)

VerificationTest[
  GraphQ @ SprayGraph[ PathGraph[ Range[ 5 ] ], { { 1, 5 } } ],
  True,
  TestID -> "SprayGraph-returns-graph"
]

VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    EdgeCount @ SprayGraph[ g, { { 1, 9 } }, "PathThickness" -> Infinity ] >
    EdgeCount @ SprayGraph[ g, { { 1, 9 } }, "PathThickness" -> 0 ]
  ],
  True,
  TestID -> "SprayGraph-thickness-grows"
]

VerificationTest[
  DirectedGraphQ @ SprayGraph[ CycleGraph[ 6 ], { { 1, 4 } }, "Directed" -> False ],
  False,
  TestID -> "SprayGraph-undirected"
]

VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    SubsetQ[ VertexList[ g ], VertexList @ SprayGraph[ g, { { 1, 9 }, { 3, 7 } } ] ]
  ],
  True,
  TestID -> "SprayGraph-multi-pair"
]

(* ===== PathSubgraph ===== *)

VerificationTest[
  VertexCount @ PathSubgraph[ PathGraph[ Range[ 6 ] ], 1, 5 ],
  5,
  TestID -> "PathSubgraph-default-is-geodesic"
]

VerificationTest[
  With[ { g = CycleGraph[ 6 ] },
    EdgeCount @ PathSubgraph[ g, 1, 3, UpTo[ 2 ] ] <
    EdgeCount @ PathSubgraph[ g, 1, 3, UpTo[ 4 ] ]
  ],
  True,
  TestID -> "PathSubgraph-length-cap-monotone"
]

VerificationTest[
  EdgeCount @ PathSubgraph[ CycleGraph[ 5 ], 1, 3, All ],
  5,
  TestID -> "PathSubgraph-all-on-2-connected"
]

VerificationTest[
  With[ { g = GraphDisjointUnion[ PathGraph[ { 1, 2 } ], PathGraph[ { 3, 4 } ] ] },
    EdgeCount @ PathSubgraph[ g, 1, 4 ]
  ],
  0,
  TestID -> "PathSubgraph-disconnected-empty"
]

VerificationTest[
  VertexList @ PathSubgraph[ PathGraph[ Range[ 4 ] ], 2, 2 ],
  { 2 },
  TestID -> "PathSubgraph-self-loop"
]

VerificationTest[
  DirectedGraphQ @ PathSubgraph[ CycleGraph[ 6 ], 1, 4, All, "Directed" -> False ],
  False,
  TestID -> "PathSubgraph-undirected"
]

VerificationTest[
  With[ { g = CycleGraph[ 6 ] },
    EdgeCount @ PathSubgraph[ g, 1, 4, 3 ] === EdgeCount @ PathSubgraph[ g, 1, 4, UpTo[ 3 ] ]
  ],
  True,
  TestID -> "PathSubgraph-integer-equals-UpTo"
]

(* ===== SelectInfraWalk -- {"Min", scoreFn} / {"Max", scoreFn} selectors ===== *)

(* scoreFn is a user-supplied path-aggregated function; pool keeps positions
   where scoreFn is extremal.  degSumScore[path] is a synthetic test scorer
   (sum of edge-degree-sums along the walk). *)

VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ],
          paths = (FindInfraSegment[ GridGraph[ { 3, 3 } ], 1, 9, All ]),
          degSumScore = path |-> Total[
            ( VertexDegree[ GridGraph[ { 3, 3 } ], #[[ 1 ]] ] +
              VertexDegree[ GridGraph[ { 3, 3 } ], #[[ 2 ]] ] & ) /@
              Partition[ path, 2, 1 ] ] },
    MemberQ[ paths, First @ SelectInfraWalk[ g, paths, 1, "From" -> { "Min", degSumScore } ] ]
  ],
  True,
  TestID -> "SelectInfraWalk-Min-returns-member-of-bundle"
]

VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ],
          segment = FindInfraSegment[ GridGraph[ { 3, 3 } ], 1, 9, All ],
          degSumScore = path |-> Total[
            ( VertexDegree[ GridGraph[ { 3, 3 } ], #[[ 1 ]] ] +
              VertexDegree[ GridGraph[ { 3, 3 } ], #[[ 2 ]] ] & ) /@
              Partition[ path, 2, 1 ] ] },
    MatchQ[ SelectInfraWalk[ g, segment, 1, "From" -> { "Min", degSumScore } ], { { __Integer } } ]
  ],
  True,
  TestID -> "SelectInfraWalk-Min-on-a-family-keeps-the-vertex-list-form"
]

VerificationTest[
  Module[ { g = GridGraph[ { 3, 3 } ], paths, scoreFn, scores, picked },
    paths = FindInfraSegment[ g, 1, 9, All ];
    scoreFn = path |-> Total[
      ( VertexDegree[ g, #[[ 1 ]] ] + VertexDegree[ g, #[[ 2 ]] ] & ) /@
        Partition[ path, 2, 1 ] ];
    scores = scoreFn /@ paths;
    picked = First @ SelectInfraWalk[ g, paths, 1, "From" -> { "Min", scoreFn } ];
    scoreFn[ picked ] == Min[ scores ]
  ],
  True,
  TestID -> "SelectInfraWalk-Min-score-equals-min"
]

VerificationTest[
  Module[ { g = GridGraph[ { 3, 3 } ], paths, scoreFn, scores, picked },
    paths = FindInfraSegment[ g, 1, 9, All ];
    scoreFn = path |-> Total[
      ( VertexDegree[ g, #[[ 1 ]] ] + VertexDegree[ g, #[[ 2 ]] ] & ) /@
        Partition[ path, 2, 1 ] ];
    scores = scoreFn /@ paths;
    picked = First @ SelectInfraWalk[ g, paths, 1, "From" -> { "Max", scoreFn } ];
    scoreFn[ picked ] == Max[ scores ]
  ],
  True,
  TestID -> "SelectInfraWalk-Max-score-equals-max"
]

VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ],
          paths = (FindInfraSegment[ GridGraph[ { 3, 3 } ], 1, 9, All ]),
          degSumScore = path |-> Total[
            ( VertexDegree[ GridGraph[ { 3, 3 } ], #[[ 1 ]] ] +
              VertexDegree[ GridGraph[ { 3, 3 } ], #[[ 2 ]] ] & ) /@
              Partition[ path, 2, 1 ] ] },
    Length @ SelectInfraWalk[ g, paths, UpTo[ 3 ], "From" -> { "Min", degSumScore } ] <= 3
  ],
  True,
  TestID -> "SelectInfraWalk-Min-UpTo-soft"
]

VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ],
          paths = (FindInfraSegment[ GridGraph[ { 3, 3 } ], 1, 9, All ]),
          degSumScore = path |-> Total[
            ( VertexDegree[ GridGraph[ { 3, 3 } ], #[[ 1 ]] ] +
              VertexDegree[ GridGraph[ { 3, 3 } ], #[[ 2 ]] ] & ) /@
              Partition[ path, 2, 1 ] ] },
    SubsetQ[ paths, SelectInfraWalk[ g, paths, All, "From" -> { "Min", degSumScore } ] ]
  ],
  True,
  TestID -> "SelectInfraWalk-Min-All-returns-subset"
]

VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ],
          segment = FindInfraSegment[ GridGraph[ { 3, 3 } ], 1, 9, All ],
          degSumScore = path |-> Total[
            ( VertexDegree[ GridGraph[ { 3, 3 } ], #[[ 1 ]] ] +
              VertexDegree[ GridGraph[ { 3, 3 } ], #[[ 2 ]] ] & ) /@
              Partition[ path, 2, 1 ] ] },
    MatchQ[ SelectInfraWalk[ g, 1, "From" -> { "Min", degSumScore } ] @ segment, { { __Integer } } ]
  ],
  True,
  TestID -> "SelectInfraWalk-Min-operator-form-keeps-the-shape"
]

VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ],
          degSumScore = path |-> Total[
            ( VertexDegree[ GridGraph[ { 3, 3 } ], #[[ 1 ]] ] +
              VertexDegree[ GridGraph[ { 3, 3 } ], #[[ 2 ]] ] & ) /@
              Partition[ path, 2, 1 ] ] },
    With[ { picked = SelectInfraWalk[ g, InfraMeasurement[ g, InfraSegment[ 1, 9 ], "Graph" ], 1,
              "From" -> { "Min", degSumScore } ] },
      MatchQ[ picked, { _Graph } ] && MemberQ[ FindInfraSegment[ g, 1, 9, All ], walkSequence @ First @ picked ] ]
  ],
  True,
  TestID -> "SelectInfraWalk-Min-on-a-DAG-returns-a-path-graph"
]

(* ===== the interval DAG against its enumerated geodesics ===== *)

(* the most-visited geodesics of the DAG are those of the enumerated family *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    Sort[ walkSequence /@ SelectInfraWalk[ g, InfraMeasurement[ g, InfraSegment[ 1, 25 ], "Graph" ], All,
      "From" -> "MostVisited" ] ] ===
    Sort[ SelectInfraWalk[ g, FindInfraSegment[ g, 1, 25, All ], All, "From" -> "MostVisited" ] ]
  ],
  True,
  TestID -> "SelectInfraWalk-MostVisited-DAG-equals-enumeration"
]

VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    With[ { segs = EmbeddingClosest[ g, { 1, 9 } ] @ SelectInfraWalk[ g, All, "From" -> "Center" ] @
        FindInfraSegment[ g, 1, 9, All ] },
      Length[ segs ] >= 1 && AllTrue[ segs, Length[ # ] == 5 && InfraSegmentQ[ g, # ] & ] ]
  ],
  True,
  TestID -> "SelectInfraWalk-EmbeddingClosest-chained-operator-form"
]


EndTestSection[]


BeginTestSection["SelectInfraPoint"]
VerificationTest[
  SubsetQ[ Range[ 5 ], #& /@ SelectInfraPoint[ PathGraph[ Range[ 5 ] ], Range[ 5 ], All, "From" -> "Center" ] ],
  True,
  TestID -> "SelectInfraPoint-Center-pool-is-sublist"
]

VerificationTest[
  #& /@ SelectInfraPoint[ PathGraph[ Range[ 5 ] ], Range[ 5 ], All, "From" -> "Center" ],
  { 3 },
  TestID -> "SelectInfraPoint-Center-on-PathGraph-picks-middle"
]

VerificationTest[
  Sort[ #& /@ SelectInfraPoint[ PathGraph[ Range[ 5 ] ], Range[ 5 ], All, "From" -> "Periphery" ] ],
  { 1, 5 },
  TestID -> "SelectInfraPoint-Periphery-on-PathGraph-picks-endpoints"
]

VerificationTest[
  Length @ SelectInfraPoint[ PathGraph[ Range[ 5 ] ], Range[ 5 ], 1, "From" -> "Center" ],
  1,
  TestID -> "SelectInfraPoint-strict-n-1"
]

VerificationTest[
  Length @ SelectInfraPoint[ PathGraph[ Range[ 5 ] ], Range[ 5 ], UpTo[ 3 ] ] <= 3,
  True,
  TestID -> "SelectInfraPoint-UpTo-soft"
]

VerificationTest[
  SelectInfraPoint[ PathGraph[ Range[ 5 ] ], Range[ 5 ], 99 ],
  { },
  TestID -> "SelectInfraPoint-strict-overcount-fails"
]

VerificationTest[
  SelectInfraPoint[ PathGraph[ Range[ 5 ] ], { }, 1 ],
  { },
  TestID -> "SelectInfraPoint-empty-strict-fails"
]

VerificationTest[
  SelectInfraPoint[ PathGraph[ Range[ 5 ] ], { }, All ],
  { },
  TestID -> "SelectInfraPoint-empty-All-empty"
]

VerificationTest[
  Length @ SelectInfraPoint[ PathGraph[ Range[ 5 ] ], Range[ 5 ] ],
  1,
  TestID -> "SelectInfraPoint-default-n-is-1"
]

VerificationTest[
  Sort @ SelectInfraPoint[ PathGraph[ Range[ 5 ] ], <| 1 -> 1, 2 -> 1, 3 -> 1, 4 -> 1, 5 -> 1 |>, All ],
  Range[ 5 ],
  TestID -> "SelectInfraPoint-returns-vertex-list"
]

VerificationTest[
  Sort[ #& /@ SelectInfraPoint[ PathGraph[ Range[ 5 ] ], All, "From" -> "Periphery" ][ Range[ 5 ] ] ],
  { 1, 5 },
  TestID -> "SelectInfraPoint-operator-form"
]

VerificationTest[
  Length @ SelectInfraPoint[ PathGraph[ Range[ 5 ] ], Range[ 5 ], 2, "Distance" -> "Max" ],
  2,
  TestID -> "SelectInfraPoint-Distance-Max-strict-2"
]

VerificationTest[
  SubsetQ[ Range[ 5 ],
    #& /@ SelectInfraPoint[ PathGraph[ Range[ 5 ] ], Range[ 5 ], All, "From" -> ( 3 -> 2 ) ] ],
  True,
  TestID -> "SelectInfraPoint-anchor-distance-pool-is-sublist"
]


(* ===== InfraDeformationSize ===== *)

(* the number of reference edges a deformation replaces *)
VerificationTest[
  { InfraDeformationSize[ { 1, 2, 5 }, { 1, 3, 5 } ],
    InfraDeformationSize[ { 1, 2, 5 }, { 1, 4, 2, 5 } ],
    InfraDeformationSize[ { 1, 2, 5 }, { 1, 2, 4, 2, 5 } ] },
  { 2, 1, 0 },
  TestID -> "InfraDeformationSize-counts-replaced-reference-edges"
]

(* a deformation sharing a prefix and a suffix with the reference replaces only
   the edges between them *)
VerificationTest[
  With[ { ref = Range[ 6 ] },
    { InfraDeformationSize[ ref, { 1, 2, 3, 9, 5, 6 } ],
      InfraDeformationSize[ ref, { 1, 2, 8, 9, 5, 6 } ],
      InfraDeformationSize[ ref, ref ] }
  ],
  { 2, 3, 0 },
  TestID -> "InfraDeformationSize-is-the-replaced-window"
]

(* bundle form: one number per realisation *)
VerificationTest[
  InfraDeformationSize[ { 1, 2, 5 },
    walkGraph /@ { { 1, 3, 5 }, { 1, 4, 2, 5 }, { 1, 2, 4, 2, 5 } } ],
  { 2, 1, 0 },
  TestID -> "InfraDeformationSize-maps-over-a-bundle"
]

(* the invariant composes as a walk-space score: grouping and extremising by it
   happen at the call site, not through an option *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ], ref = { 1, 2, 3, 6, 9 },
          ws = walkGraph /@ { { 1, 2, 3, 6, 9 }, { 1, 2, 5, 6, 9 }, { 1, 4, 7, 8, 9 } } },
    { InfraDeformationSize[ ref, ws ],
      With[ { picked = SelectInfraWalk[ g, ws, All,
                "From" -> { "Min", w |-> InfraDeformationSize[ ref, w ] } ] },
        Union[ InfraDeformationSize[ ref, picked ] ] ===
          { Min @ InfraDeformationSize[ ref, ws ] } ] }
  ],
  { { 0, 2, 4 }, True },
  TestID -> "InfraDeformationSize-drives-SelectInfraWalk-at-the-call-site"
]


(* the spray carries the base graph's embedding, so figures carved out of it
   stay aligned with the substrate *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    With[ { spray = SprayGraph[ g, 1 ] },
      Sort @ Cases[ Options[ spray, VertexCoordinates ], _ -> vc_ :> Length @ vc ] =!= { } &&
        VertexList[ spray ] === VertexList[ g ] ]
  ],
  True,
  TestID -> "SprayGraph-keeps-base-coordinates"
]

(* FindInfraCommonPoint accepts the compact geodesic-DAG segment form *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    With[ { s1 = FindInfraSegment[ g, 1, 9 , All], s2 = FindInfraSegment[ g, 3, 7 , All] },
      Sort[ FindInfraCommonPoint[ g, { s1, s2 } ] ] ===
        Sort @ Intersection[
          Union @@ FindInfraSegment[ g, 1, 9, All ],
          Union @@ FindInfraSegment[ g, 3, 7, All ] ] ]
  ],
  True,
  TestID -> "FindInfraCommonPoint-accepts-DAG-segments"
]

(* a vertex is the natural single source of a spray; a vertex list and a
   multiset are the multi-source forms *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    { SprayGraph[ g, 1 ] === SprayGraph[ g, 1 ],
      SprayGraph[ g, { 1, 4 } ] === SprayGraph[ g, <| 1 -> 1, 4 -> 1 |> ] } ],
  { True, True },
  TestID -> "SprayGraph-accepts-vertices-and-multisets"
]
(* ===== "From" validation ===== *)

(* An unrecognised "From" selector is refused rather than silently read as the
   whole bundle.  "MinCurvature" / "MaxCurvature" were replaced by
   {"Min", scoreFn} / {"Max", scoreFn}, so they are the names a reader is most
   likely to copy from older prose. *)

(* Refusing a legitimate selector would be worse than the silence it replaces:
   every admissible "From" shape must still produce a pool. *)

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    { paths = walkSeqs @ FindInfraWalk[ g, 1, 13, UpTo[ 6 ], All ] },
    FreeQ[
      SelectInfraWalk[ g, paths, All, "From" -> # ] & /@
        { All, "Center", "Periphery", "MostVisited", "Bottleneck", "MinLength", "MaxLength",
          First[ paths ] -> 2, { "Min", Length }, { "Max", Length } },
      _SelectInfraWalk ]
  ],
  True,
  TestID -> "SelectInfraWalk-From-vocabulary-not-refused"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    FreeQ[
      SelectInfraPoint[ g, Range[ 25 ], All, "From" -> # ] & /@
        { All, "Random", "Center", "Periphery", 7, 3 -> 2, { 2, 3, 4 }, <| 2 -> 1, 5 -> 1, 7 -> 1 |> },
      _SelectInfraPoint ]
  ],
  True,
  TestID -> "SelectInfraPoint-From-vocabulary-not-refused"
]


(* ===== the ray graph past q: the geodesic extensions of p -> q beyond q ===== *)

(* on C_6 the extensions of 1 -> 2 beyond 2 are 2 -> 3 -> 4: vertex 5 is excluded, d(1, 5) = 2 < 1 + d(2, 5) = 4 *)
VerificationTest[
  With[ { ray = InfraMeasurement[ CycleGraph[ 6 ], InfraRay[ 1, 2 ], "Graph" ] },
    { ext = Subgraph[ ray, VertexOutComponent[ ray, 2 ] ] },
    { Sort @ VertexList @ ext, Sort @ EdgeList @ ext } ],
  { { 2, 3, 4 }, { DirectedEdge[ 2, 3 ], DirectedEdge[ 3, 4 ] } },
  TestID -> "InfraRay-past-q-C6"
]

(* the vertex set is the distance condition, and every directed path from q is a geodesic that stays geodesic behind p *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ], p1 = 6, p2 = 7 },
    { ray = InfraMeasurement[ g, InfraRay[ p1, p2 ], "Graph" ] },
    { ext = Subgraph[ ray, VertexOutComponent[ ray, p2 ] ] },
    Sort @ VertexList @ ext ===
      Sort @ Select[ VertexList @ g,
        GraphDistance[ g, p1, # ] == GraphDistance[ g, p1, p2 ] + GraphDistance[ g, p2, # ] & ] &&
    AllTrue[ infraSpread @ ext,
      w |-> First[ w ] === p2 && InfraSegmentQ[ g, w ] &&
        GraphDistance[ g, p1, Last @ w ] == GraphDistance[ g, p1, p2 ] + Length[ w ] - 1 ]
  ],
  True,
  TestID -> "InfraRay-past-q-GridGraph-geodesic-extensions"
]

(* the sinks of the ray graph are the inextensible ray ends *)
VerificationTest[
  With[ { ray = InfraMeasurement[ GridGraph[ { 3, 3 } ], InfraRay[ 5, 6 ], "Graph" ] },
    Sort @ Select[ VertexList @ ray, VertexOutDegree[ ray, # ] == 0 & ] ],
  { 3, 9 },
  TestID -> "InfraRay-past-q-sinks-are-ray-ends"
]

(* two anchors through one point: one ray graph each, ending at the opposite corner *)
VerificationTest[
  Map[ ray |-> Select[ VertexList @ ray, VertexOutDegree[ ray, # ] == 0 & ],
    InfraMeasurement[ GridGraph[ { 3, 3 } ], { InfraRay[ 1, 5 ], InfraRay[ 3, 5 ] }, "Graph" ] ],
  { { 9 }, { 7 } },
  TestID -> "InfraRay-past-q-two-anchors"
]

EndTestSection[]
