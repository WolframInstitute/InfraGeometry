BeginTestSection["InfraWalk"]

(* the generic class: no cusp, no third visit, no self-tangency *)
genericRules = { { "Simple", 2 }, w |-> Count[ w, Last @ w ] <= 2 && WalkSingularities[ w ][ "SelfTangencies" ] === { } };

walkGraph       = walk |-> PathGraph[ MapIndexed[ { First @ #2, #1 } &, walk ], DirectedEdges -> True ];
closedWalkGraph = walk |-> With[ { core = MapIndexed[ { First @ #2, #1 } &, If[ Length[ walk ] >= 2 && First @ walk === Last @ walk, Most @ walk, walk ] ] },
  Graph[ core, DirectedEdge @@@ Partition[ core, 2, 1, 1 ] ] ];
walkSeq[ w_Graph ] := Last /@ VertexList[ w ]
(* count-less returns ONE walk graph and a bounded count a List of them, so the
   sequence reader takes either shape *)
walkSeqs[ w_Graph ] := { walkSeq @ w }
walkSeqs[ ws_List ] := walkSeq /@ ws
(* an endpoint is a stopping condition: each walk stops at its first arrival
   at q, and the walks that end there are a Select *)
stopAt[ q_ ] := "StoppingCondition" -> ( Last[ # ] === q & )
endingAt[ ws_List, q_ ] := Select[ ws, Last @ Last @ VertexList @ # === q & ]

(* ===================== The walk shape ===================== *)

(* a walk is a directed path graph on position pairs {i, v}: its edge count is
   the length, Last /@ VertexList its vertex sequence, and every walk of the
   class comes back as one such graph *)
VerificationTest[
  With[ { ws = endingAt[ FindInfraWalk[ GridGraph[ { 3, 3 } ], 1, UpTo[ 4 ], All, stopAt[ 9 ], Properties -> { "Simple" } ], 9 ] },
    { MatchQ[ ws, { __Graph } ],
      AllTrue[ ws, PathGraphQ[ # ] && DirectedGraphQ[ # ] && AcyclicGraphQ[ # ] & ],
      AllTrue[ ws, First /@ VertexList[ # ] === Range @ VertexCount @ # & ],
      Union[ EdgeCount /@ ws ],
      Sort @ walkSeqs @ ws === Sort @ FindPath[ GridGraph[ { 3, 3 } ], 1, 9, 4, All ] } ],
  { True, True, True, { 4 }, True },
  TestID -> "walk-is-a-path-graph-on-position-pairs"
]

(* a walk that revisits is still a path graph, since positions never repeat *)
VerificationTest[
  With[ { w = walkGraph @ { 1, 2, 1, 2, 3 } },
    { PathGraphQ @ w, VertexCount @ w, EdgeCount @ w, walkSeq @ w } ],
  { True, 5, 4, { 1, 2, 1, 2, 3 } },
  TestID -> "walk-graph-revisits-keep-positions"
]

(* a closed walk is a directed cycle on its core; the constant loop is one
   vertex with a self-loop *)
VerificationTest[
  With[ { c = closedWalkGraph @ { 1, 2, 3, 1 }, k = closedWalkGraph @ { 7 } },
    { AcyclicGraphQ @ c, VertexCount @ c, EdgeCount @ c, walkSeq @ c, LoopFreeGraphQ @ k, walkSeq @ k } ],
  { False, 3, 3, { 1, 2, 3 }, False, { 7 } },
  TestID -> "closed-walk-is-a-cycle-graph"
]

(* the bundle of two walks is their GraphUnion, a DAG layered by position *)
VerificationTest[
  With[ { u = GraphUnion[ walkGraph @ { 1, 2, 3 }, walkGraph @ { 1, 4, 3 } ] },
    { AcyclicGraphQ @ u, VertexCount @ u, EdgeCount @ u } ],
  { True, 4, 4 },
  TestID -> "walk-bundle-is-GraphUnion"
]

(* the predicates read a walk graph and a vertex list alike *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ], w = { 2, 5, 4, 7, 8, 5, 6 } },
    { InfraWalkQ[ g, walkGraph @ w ],
      InfraGenericQ[ g, walkGraph @ w ] === InfraGenericQ[ g, w ],
      WalkSingularities[ walkGraph @ w ] === WalkSingularities[ w ],
      InfraGeodesicQ[ g, walkGraph @ { 1, 2, 3 } ] } ],
  { True, True, True, True },
  TestID -> "walk-graph-reads-as-its-vertex-list"
]

(* a bare integer is no budget, so the call stays unevaluated; the budget is UpTo[k] *)
VerificationTest[
  { MatchQ[ FindInfraWalk[ PathGraph[ Range[ 5 ] ], 1, 2, All, Properties -> { "Simple" } ], _FindInfraWalk ],
    walkSeqs @ FindInfraWalk[ PathGraph[ Range[ 5 ] ], 1, UpTo[ 2 ], All, Properties -> { "Simple" } ] },
  { True, { { 1, 2, 3 } } },
  TestID -> "FindInfraWalk-bare-integer-is-no-budget"
]

(* ===================== FindInfraWalk ===================== *)

(* a vertex is the one-vertex germ, grown until stuck; on the path graph the
   one maximal simple walk from 1 is the full path *)
VerificationTest[
  walkSeqs @ FindInfraWalk[ PathGraph[ Range[ 5 ] ], 1, Properties -> { "Simple" } ],
  { { 1, 2, 3, 4, 5 } },
  TestID -> "FindInfraWalk-pointed-default-witness"
]

(* growth stops at the budget: kspec counts edges *)
VerificationTest[
  walkSeqs @ FindInfraWalk[ PathGraph[ Range[ 5 ] ], 1, UpTo[ 2 ], All, Properties -> { "Simple" } ],
  { { 1, 2, 3 } },
  TestID -> "FindInfraWalk-pointed-budget"
]

(* from an interior vertex the maximal simple walks run both ways *)
VerificationTest[
  Sort @ walkSeqs @ FindInfraWalk[ PathGraph[ Range[ 5 ] ], 3, Infinity, All, Properties -> { "Simple" } ],
  Sort[ { { 3, 2, 1 }, { 3, 4, 5 } } ],
  TestID -> "FindInfraWalk-pointed-maximal-both-ways"
]

VerificationTest[
  Sort @ walkSeqs @ FindInfraWalk[ PathGraph[ Range[ 5 ] ], <| 1 -> 1, 2 -> 1 |>, UpTo[ 3 ], All, Properties -> { "Simple" } ],
  Sort[ { { 1, 2, 3, 4 }, { 2, 1 }, { 2, 3, 4, 5 } } ],
  TestID -> "FindInfraWalk-pointed-multi-source-spread"
]

(* the vertex and the one-vertex walk are the same germ: they agree on every
   budget and count *)
VerificationTest[
  { FindInfraWalk[ CycleGraph[ 6 ], { 1 }, UpTo[ 4 ], All, Properties -> { "Simple" } ] === FindInfraWalk[ CycleGraph[ 6 ], 1, UpTo[ 4 ], All,
      Properties -> { "Simple" } ],
    FindInfraWalk[ GridGraph[ { 3, 3 } ], { 5 }, { 2 }, 3, Properties -> { "Simple" } ] === FindInfraWalk[ GridGraph[ { 3, 3 } ], 5, { 2 }, 3,
        Properties -> { "Simple" } ],
    FindInfraWalk[ GridGraph[ { 4, 4 } ], { 6 }, Properties -> { "Simple" } ] === FindInfraWalk[ GridGraph[ { 4, 4 } ], 6,
        Properties -> { "Simple" } ] },
  { True, True, True },
  TestID -> "FindInfraWalk-one-vertex-germ-is-the-point"
]

(* under "BothSides" a germ grows at both ends, the budget counted per side:
   from the corner edge {1, 2} of the 4-by-4 grid *)
VerificationTest[
  Sort @ walkSeqs @ FindInfraWalk[ GridGraph[ { 4, 4 } ], { 1, 2 }, UpTo[ 2 ], All, Properties -> { "Simple" }, "Direction" -> "BothSides" ],
  Sort[ { { 6, 5, 1, 2, 3, 4 }, { 6, 5, 1, 2, 3, 7 }, { 9, 5, 1, 2, 3, 4 }, { 9, 5, 1, 2, 3, 7 },
    { 9, 5, 1, 2, 6, 7 }, { 9, 5, 1, 2, 6, 10 }, { 1, 2, 6, 5 } } ],
  TestID -> "FindInfraWalk-walk-germ-grows-both-sides"
]

(* a germ is a vertex before it is a vertex list: on the list-labelled square
   torus the vertex {1, 1} is one point, not the walk 1, 1, and a list of such
   vertices is a walk *)
VerificationTest[
  With[ { g = InfraSubstrate[ "SquareTorusGraph", "Small" ] },
    { ws = FindInfraWalk[ g, { 1, 1 }, UpTo[ 2 ], All, Properties -> { "Simple" } ],
      reps = FindInfraRepresentative[ g, InfraGeodesic[ { { 1, 1 }, { 2, 1 } }, 2 ], 2 ] },
    { Length @ ws, ws === FindInfraWalk[ g, { { 1, 1 } }, UpTo[ 2 ], All, Properties -> { "Simple" } ],
      AllTrue[ walkSeqs @ ws, First[ # ] === { 1, 1 } & ],
      Length @ FindInfraGeodesic[ g, { 1, 1 }, 2, UpTo[ 2 ], All ],
      Length @ reps,
      AllTrue[ reps, w |-> InfraGeodesicQ[ g, w, 2 ] && SequenceCount[ w, { { 1, 1 }, { 2, 1 } } ] === 1 ] } ],
  { 12, True, True, 12, 2, True },
  TestID -> "FindInfraWalk-list-labelled-vertex-is-one-point"
]

(* an endpoint is a stopping condition: each walk stops at its first arrival
   at q, and the walks ending at q are a Select *)
VerificationTest[
  walkSeqs @ endingAt[ FindInfraWalk[ PathGraph[ Range[ 5 ] ], 1, Infinity, All, stopAt[ 5 ], Properties -> { "Simple" } ], 5 ],
  { { 1, 2, 3, 4, 5 } },
  TestID -> "FindInfraWalk-endpoint-is-a-stopping-condition"
]

(* corner to corner on the 4-by-4 grid: the arrivals are the simple paths of
   FindPath under "Simple", and 800 generic walks, each visiting the endpoint
   once, under no cusp, no third visit and no self-tangency; a vertex visited at
   most twice bounds a walk on 16 vertices by 31 edges *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    { simple  = endingAt[ FindInfraWalk[ g, 1, Infinity, All, stopAt[ 16 ], Properties -> { "Simple" } ], 16 ],
      generic = endingAt[ FindInfraWalk[ g, 1, UpTo[ 31 ], All, stopAt[ 16 ], Properties -> genericRules ], 16 ] },
    { Sort @ walkSeqs @ simple === Sort @ FindPath[ g, 1, 16, Infinity, All ],
      Length @ generic,
      AllTrue[ walkSeqs @ generic, w |-> InfraGenericQ[ g, w ] && Count[ w, 16 ] === 1 ] } ],
  { True, 800, True },
  TestID -> "FindInfraWalk-endpoint-spelling-simple-and-generic"
]

VerificationTest[
  Length @ endingAt[ FindInfraWalk[ GridGraph[ { 3, 3 } ], 1, UpTo[ 4 ], All, stopAt[ 9 ], Properties -> { "Simple" } ], 9 ],
  Length @ FindPath[ GridGraph[ { 3, 3 } ], 1, 9, 4, All ],
  TestID -> "FindInfraWalk-All-matches-Wolfram-FindPath"
]

VerificationTest[
  MatchQ[
    FindInfraWalk[ GridGraph[ { 3, 3 } ], 1, UpTo[ 4 ], All, Properties -> { "Simple" } ],
    { __Graph } ],
  True,
  TestID -> "FindInfraWalk-output-shape"
]

VerificationTest[
  AllTrue[
    walkSeqs @ FindInfraWalk[ GridGraph[ { 3, 3 } ], 1, UpTo[ 4 ], All, Properties -> { "Simple" } ],
    p |-> InfraWalkQ[ GridGraph[ { 3, 3 } ], p ] ],
  True,
  TestID -> "FindInfraWalk-all-paths-pass-InfraWalkQ"
]

VerificationTest[
  walkSeqs @ FindInfraWalk[ PathGraph[ Range[ 5 ] ], 1, { 4 }, 1, Properties -> { "Simple" } ],
  { { 1, 2, 3, 4, 5 } },
  TestID -> "FindInfraWalk-exact-length-spec"
]

(* "Simple" is FindPath's class exactly, at every length *)
VerificationTest[
  Length @ endingAt[ FindInfraWalk[ GridGraph[ { 3, 3 } ], 1, { 4, 6 }, All, stopAt[ 9 ], Properties -> { "Simple" } ], 9 ],
  Length @ FindPath[ GridGraph[ { 3, 3 } ], 1, 9, { 4, 6 }, All ],
  TestID -> "FindInfraWalk-range-length-spec"
]

(* the crossing count is an invariant, never a class option: the exhaustive
   spelling filters the cusp-free class {"Simple", 2} -- on CycleGraph[4]
   every non-backtracking walk is a pure rotation, so the length-6 walks
   1 -> 3 have exactly 3 arrivals at a visited vertex, no walk has exactly 1,
   and "Simple" is empty at this length (a simple walk on C4 has at most
   3 edges).  These walks pass 3 before ending there, so they are reached
   with the exact budget and a Select, not with a first-arrival condition *)
VerificationTest[
  With[ { g = CycleGraph[ 4 ] },
    { reps = Select[ walkSeqs @ FindInfraWalk[ g, 1, { 6 }, All, Properties -> { { "Simple", 2 } } ], Last[ # ] === 3 & ] },
    { Select[ walkSeqs @ FindInfraWalk[ g, 1, { 6 }, All, Properties -> { "Simple" } ], Last[ # ] === 3 & ],
      Select[ reps, Length[ # ] - Length[ DeleteDuplicates @ # ] === 1 & ],
      Sort @ Select[ reps, Length[ # ] - Length[ DeleteDuplicates @ # ] === 3 & ] } ],
  { { }, { }, Sort[ { { 1, 2, 3, 4, 1, 2, 3 }, { 1, 4, 3, 2, 1, 4, 3 } } ] },
  TestID -> "FindInfraWalk-crossing-count-exhaustive-spelling"
]

(* the pointed random walk stopped at its first self-intersection: the tip is
   the one doubled vertex -- drawn under the ambient seed.  A simple walk
   cannot self-intersect, so the generic class is asked for *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    { w = BlockRandom[
        First @ walkSeqs @ FindInfraWalk[ g, 1, UpTo[ 20 ], Properties -> genericRules,
            "StoppingCondition" -> ( Length[ # ] - Length[ DeleteDuplicates @ # ] >= 1 & ),
          "NextVertexFunction" -> RandomSample ],
        RandomSeeding -> 7 ] },
    { First[ w ] === 1, Count[ w, Last @ w ] === 2,
      Length[ w ] - Length[ DeleteDuplicates[ w ] ] === 1 } ],
  { True, True, True },
  TestID -> "FindInfraWalk-random-walk-stops-at-first-crossing"
]

(* a bounded count is the certified lazy descent: the
   instances are genuine, distinct members of the exhaustive class, exactly as
   many as asked *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    { class = walkSeqs @ FindInfraWalk[ g, 1, { 6 }, All, Properties -> { "Simple" } ] },
    { got = walkSeqs @ FindInfraWalk[ g, 1, { 6 }, 3, Properties -> { "Simple" } ] },
    Length[ got ] === 3 && DuplicateFreeQ[ got ] && SubsetQ[ class, got ] ],
  True,
  TestID -> "FindInfraWalk-Automatic-greedy-members-of-class"
]

(* "Simple" is the census filter DuplicateFreeQ over the bare walk class, and
   the generic class -- no cusp, no third visit, no self-tangency -- widens it:
   on the 3-by-3 grid at length <= 8 it strictly exceeds the simple paths (the
   degree-4 centre supports an isolated crossing) and is exactly
   InfraGenericQ's filter over the bare class *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    { bare    = walkSeqs @ endingAt[ FindInfraWalk[ g, 1, UpTo[ 8 ], All, stopAt[ 9 ], Properties -> { } ], 9 ],
      simple  = walkSeqs @ endingAt[ FindInfraWalk[ g, 1, UpTo[ 8 ], All, stopAt[ 9 ], Properties -> { "Simple" } ], 9 ],
      generic = walkSeqs @ endingAt[ FindInfraWalk[ g, 1, UpTo[ 8 ], All, stopAt[ 9 ], Properties -> genericRules ], 9 ] },
    { Sort @ simple === Sort @ Select[ bare, DuplicateFreeQ ],
      SubsetQ[ generic, simple ] && AnyTrue[ generic, ! DuplicateFreeQ[ # ] & ],
      Sort @ generic === Sort @ Select[ bare, InfraGenericQ[ g, # ] & ] } ],
  { True, True, True },
  TestID -> "FindInfraWalk-default-class-is-simple-Generic-opt-in"
]

(* Properties -> {} is the bare walk class: backtracking walks are members,
   and a walk may pass through q and return to end there, which the exact
   budget and a Select reach *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    { reps = Select[ walkSeqs @ FindInfraWalk[ g, 1, { 6 }, All, Properties -> { } ], Last[ # ] === 9 & ] },
    AnyTrue[ reps, ! InfraImmersedQ[ g, # ] & ] &&
    AnyTrue[ reps, Count[ #, 9 ] >= 2 & ] ],
  True,
  TestID -> "FindInfraWalk-empty-properties-bare-walk-class"
]

VerificationTest[
  walkSeqs @ FindInfraWalk[ PathGraph[ Range[ 5 ] ], 1, Infinity, UpTo[ 10 ], Properties -> { "Simple" } ],
  { { 1, 2, 3, 4, 5 } },
  TestID -> "FindInfraWalk-UpTo-no-failure"
]

VerificationTest[
  FindInfraWalk[ PathGraph[ Range[ 5 ] ], 1, Infinity, 7, Properties -> { "Simple" } ],
  { },
  TestID -> "FindInfraWalk-strict-shortfall-Failed"
]

(* the condition is not read on a one-vertex germ, and a simple walk never
   returns: no walk ends at its own start *)
VerificationTest[
  walkSeqs @ endingAt[ FindInfraWalk[ PathGraph[ Range[ 5 ] ], 3, Infinity, All, stopAt[ 3 ], Properties -> { "Simple" } ], 3 ],
  { },
  TestID -> "FindInfraWalk-endpoint-at-the-germ"
]

(* ===================== Multi-anchor spread ===================== *)

VerificationTest[
  Sort[ #[[ { 1, -1 } ]] & /@
    walkSeqs @ endingAt[ FindInfraWalk[ PathGraph[ Range[ 5 ] ], <| 1 -> 1, 2 -> 1 |>, Infinity, All, stopAt[ 5 ],
        Properties -> { "Simple" } ], 5 ] ],
  Sort[ { { 1, 5 }, { 2, 5 } } ],
  TestID -> "FindInfraWalk-multi-source-spread"
]

(* ===================== InfraGeodesicQ: the scale ladder ===================== *)

(* The ladder is exact at both ends: scale 1 is the walk class, scale Infinity
   the segment class. *)

VerificationTest[
  With[ { g = CycleGraph[ 6 ], w = { 1, 2, 3, 4, 5, 6, 1 } },
    { InfraGeodesicQ[ g, w, 1 ], InfraWalkQ[ g, w ],
      InfraGeodesicQ[ g, { 1, 2, 3, 4 }, Infinity ], InfraSegmentQ[ g, { 1, 2, 3, 4 } ] }
  ],
  { True, True, True, True },
  TestID -> "InfraGeodesicQ-ladder-ends"
]

(* A walk that winds all the way around C6 is minimizing at every scale <= 3
   (each window is a shortest path) and fails beyond it. *)
VerificationTest[
  InfraGeodesicQ[ CycleGraph[ 6 ], { 1, 2, 3, 4, 5, 6, 1 }, # ] & /@ { 1, 2, 3, 4, Infinity },
  { True, True, True, False, False },
  TestID -> "InfraGeodesicQ-winding-walk-scale-threshold"
]

(* Doubling back fails already at scale 2: d(1, 1) == 0, not 2. *)
VerificationTest[
  { InfraGeodesicQ[ PathGraph[ Range[ 5 ] ], { 1, 2, 1 }, 1 ],
    InfraGeodesicQ[ PathGraph[ Range[ 5 ] ], { 1, 2, 1 }, 2 ] },
  { True, False },
  TestID -> "InfraGeodesicQ-backtrack-fails-at-scale-2"
]

(* A non-walk (non-adjacent consecutive vertices) is no geodesic at any scale. *)
VerificationTest[
  InfraGeodesicQ[ PathGraph[ Range[ 5 ] ], { 1, 3, 5 }, Infinity ],
  False,
  TestID -> "InfraGeodesicQ-non-walk-rejected"
]


(* ===================== FindInfraGeodesic ===================== *)

(* Scale Infinity, the rule "Shortest" on the whole walk, is exactly the segment class:
   the arrivals at 9 are the geodesics from 1 to 9. *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    Sort @ walkSeqs @ endingAt[ FindInfraGeodesic[ g, 1, Infinity, Infinity, All, stopAt[ 9 ] ], 9 ] ===
      Sort @ FindInfraSegment[ g, 1, 9, All ]
  ],
  True,
  TestID -> "FindInfraGeodesic-scale-Infinity-is-the-segment-class"
]

(* Finder and predicate agree: every realisation is a geodesic at the scale asked for. *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    With[ { walks = walkSeqs @ endingAt[ FindInfraGeodesic[ g, 1, 2, Infinity, All, stopAt[ 16 ],
              Properties -> { "Simple" } ], 16 ] },
      walks =!= { } && AllTrue[ walks, w |-> InfraGeodesicQ[ g, w, 2 ] ]
    ]
  ],
  True,
  TestID -> "FindInfraGeodesic-realisations-pass-InfraGeodesicQ"
]

(* Scale-2 minimizing simple walks on C6 from 1 to 4 are the two geodesics: a shorter local
   window cannot be met by winding the long way round. *)
VerificationTest[
  Sort @ walkSeqs @ endingAt[ FindInfraGeodesic[ CycleGraph[ 6 ], 1, 2, Infinity, All, stopAt[ 4 ],
    Properties -> { "Simple" } ], 4 ],
  Sort[ { { 1, 2, 3, 4 }, { 1, 6, 5, 4 } } ],
  TestID -> "FindInfraGeodesic-scale-2-cycle-geodesics"
]

(* a next-vertex function only chooses among admissible candidates, so it can only
   refine: its output is a subset of the class it selects from. *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    SubsetQ[
      Sort @ FindInfraSegment[ g, 1, 9, All ],
      Sort @ walkSeqs @ endingAt[ FindInfraGeodesic[ g, 1, Infinity, Infinity, All, stopAt[ 9 ],
          "NextVertexFunction" -> MinimalBy[ w |-> -GraphDistance[ g, w[[ -2 ]], Last @ w ] ] ], 9 ] ]
  ],
  True,
  TestID -> "FindInfraGeodesic-NextVertexFunction-refines-the-class"
]

(* A constant score discriminates nothing, so the function is vacuous. *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    Sort @ walkSeqs @ endingAt[ FindInfraGeodesic[ g, 1, Infinity, Infinity, All, stopAt[ 9 ], "NextVertexFunction" -> MinimalBy[ 1 & ] ], 9 ] ===
      Sort @ FindInfraSegment[ g, 1, 9, All ]
  ],
  True,
  TestID -> "FindInfraGeodesic-constant-selector-is-vacuous"
]

(* Minimising the degree sum keeps the two boundary geodesics of the grid: the
   interior vertex 5 costs more than any boundary step. *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    Sort @ walkSeqs @ endingAt[ FindInfraGeodesic[ g, 1, Infinity, Infinity, All, stopAt[ 9 ],
      "NextVertexFunction" -> MinimalBy[ w |-> VertexDegree[ g, w[[ -2 ]] ] + VertexDegree[ g, w[[ -1 ]] ] ] ], 9 ]
  ],
  Sort[ { { 1, 2, 3, 6, 9 }, { 1, 4, 7, 8, 9 } } ],
  TestID -> "FindInfraGeodesic-MinimalBy-degree-sum-hugs-the-boundary"
]

(* At scale 1 the window is an edge -- the last vertex and the candidate -- so an
   edge function ports as w |-> f @@ w.  A law that only accepts two-vertex
   windows keeps the whole bare walk class exactly when that is so. *)
VerificationTest[
  With[ { g = CycleGraph[ 6 ] },
    Sort @ walkSeqs @ FindInfraGeodesic[ g, 1, 1, { 3 }, All,
      Properties -> { { w |-> Length[ w ] == 2, 1 } } ] ===
      Sort @ walkSeqs @ FindInfraWalk[ g, 1, { 3 }, All, Properties -> { } ]
  ],
  True,
  TestID -> "FindInfraGeodesic-scale-1-window-is-an-edge"
]

(* A bare predicate is a custom local law; True keeps the whole class. *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    Sort @ walkSeqs @ FindInfraGeodesic[ g, 1, 1, { 4 }, All, Properties -> { "Simple", { True &, 1 } } ] ===
      Sort @ walkSeqs @ FindInfraWalk[ g, 1, { 4 }, All, Properties -> { "Simple" } ]
  ],
  True,
  TestID -> "FindInfraGeodesic-bare-predicate-True-keeps-the-class"
]

(* the least window defect on the square with a chord: the straightest walks to 3 are
   the two two-step walks, not the chord route. *)
VerificationTest[
  With[ { g = Graph[ { 1 <-> 2, 2 <-> 3, 3 <-> 4, 4 <-> 1, 2 <-> 4 } ] },
    Sort @ walkSeqs @ endingAt[ FindInfraGeodesic[ g, 1, 2, Infinity, All, stopAt[ 3 ], Properties -> { "Simple" },
      "NextVertexFunction" -> { MinimalBy[ w |-> Length[ w ] - 1 - GraphDistance[ g, First @ w, Last @ w ] ], 2 } ], 3 ] ],
  Sort[ { { 1, 2, 3 }, { 1, 4, 3 } } ],
  TestID -> "FindInfraGeodesic-least-defect-pull-apart"
]

(* kspec bounds the sweep depth, and an exact-length spec is honoured. *)
VerificationTest[
  With[ { walks = walkSeqs @ FindInfraGeodesic[ CycleGraph[ 6 ], 1, 1, { 5 }, All ] },
    walks =!= { } && DeleteDuplicates[ Length[ # ] - 1 & /@ walks ] === { 5 }
  ],
  True,
  TestID -> "FindInfraGeodesic-kspec-bounds-the-sweep"
]

(* on the 6-cycle the generic walks 1 -> 4 are exactly the two geodesics
   (anything longer repeats an edge or returns to an endpoint); a vertex
   visited at most twice bounds them by 11 edges *)
VerificationTest[
  Sort @ walkSeqs @ endingAt[ FindInfraGeodesic[ CycleGraph[ 6 ], 1, 1, UpTo[ 11 ], All, stopAt[ 4 ],
    Properties -> genericRules ], 4 ],
  Sort @ { { 1, 2, 3, 4 }, { 1, 6, 5, 4 } },
  TestID -> "FindInfraGeodesic-Generic-bounds-the-class"
]

(* the pointed geodesic: the maximal minimizing walks from 1 are the two
   geodesics to the antipode *)
VerificationTest[
  Sort @ walkSeqs @ FindInfraGeodesic[ CycleGraph[ 6 ], 1, Infinity, Infinity, All ],
  Sort[ { { 1, 2, 3, 4 }, { 1, 6, 5, 4 } } ],
  TestID -> "FindInfraGeodesic-pointed-maximal-minimizing"
]

(* at scale 1 every step minimizes, so the budget is the only stop: all 2^3
   walks of length 3 from the germ *)
VerificationTest[
  Length @ walkSeqs @ FindInfraGeodesic[ CycleGraph[ 6 ], 1, 1, { 3 }, All ],
  8,
  TestID -> "FindInfraGeodesic-pointed-scale-1-budget-class"
]

(* under a finite-scale rule a walk may pass through q and return to end
   there: the exact budget and a Select reach it, a first-arrival condition
   would cut it at the first pass *)
VerificationTest[
  AnyTrue[ Select[ walkSeqs @ FindInfraGeodesic[ CycleGraph[ 6 ], 1, 1, { 5 }, All ], Last[ # ] === 4 & ],
    Count[ #, 4 ] >= 2 & ],
  True,
  TestID -> "FindInfraGeodesic-exact-budget-reaches-later-arrivals"
]

(* the canonical order is deterministic; a random tie-break varies with the ambient seed. *)
VerificationTest[
  With[ { g = GridGraph[ { 6, 6 } ],
          f = w |-> VertexDegree[ GridGraph[ { 6, 6 } ], w[[ -2 ]] ] +
                    VertexDegree[ GridGraph[ { 6, 6 } ], w[[ -1 ]] ] },
    FindInfraGeodesic[ g, 1, Infinity, Infinity, 1, "NextVertexFunction" -> MinimalBy[ f ] ] ===
      FindInfraGeodesic[ g, 1, Infinity, Infinity, 1, "NextVertexFunction" -> MinimalBy[ f ] ]
  ],
  True,
  TestID -> "FindInfraGeodesic-canonical-order-deterministic"
]

VerificationTest[
  With[ { g = GridGraph[ { 6, 6 } ],
          f = w |-> VertexDegree[ GridGraph[ { 6, 6 } ], w[[ -2 ]] ] +
                    VertexDegree[ GridGraph[ { 6, 6 } ], w[[ -1 ]] ] },
    Length @ DeleteDuplicates @ Table[
      BlockRandom[
        First @ walkSeqs @ FindInfraGeodesic[ g, 1, Infinity, Infinity, 1, "NextVertexFunction" -> MinimalBy[ f ] /* RandomSample ],
        RandomSeeding -> s ],
      { s, 1, 8 } ]
  ],
  _Integer?( # > 1 & ),
  SameTest -> MatchQ,
  TestID -> "FindInfraGeodesic-random-tie-break-varies-across-seeds"
]

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    BlockRandom[
      Length @ walkSeqs @ FindInfraGeodesic[ g, 1, Infinity, Infinity, All, "NextVertexFunction" -> ( RandomSample[ #, UpTo[ 1 ] ] & ) ],
      RandomSeeding -> 42 ]
  ],
  1,
  TestID -> "FindInfraGeodesic-pruning-one-branch-per-node"
]


(* ===================== FindInfraGeodesic is FindInfraWalk with "Shortest" ===================== *)

(* the geodesic finder is the general finder with {"Shortest", scale} first
   among the rules; its Properties -> { } is the "Shortest" class, and the bare
   class at scale 1 is FindInfraWalk's Properties -> { } *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ], c = CycleGraph[ 6 ] },
    { Sort @ walkSeqs @ FindInfraGeodesic[ g, 1, 2, UpTo[ 6 ], All, Properties -> { "Simple" } ] ===
        Sort @ walkSeqs @ FindInfraWalk[ g, 1, UpTo[ 6 ], All,
          Properties -> { { "Shortest", 2 }, "Simple" } ],
      Sort @ walkSeqs @ FindInfraGeodesic[ c, 1, 3, { 6 }, All, Properties -> { { "Simple", 2 } } ] ===
        Sort @ walkSeqs @ FindInfraWalk[ c, 1, { 6 }, All,
          Properties -> { { "Shortest", 3 }, { "Simple", 2 } } ],
      Sort @ walkSeqs @ FindInfraGeodesic[ g, 1, 1, { 6 }, All ] ===
        Sort @ walkSeqs @ FindInfraWalk[ g, 1, { 6 }, All, Properties -> { } ] } ],
  { True, True, True },
  TestID -> "FindInfraGeodesic-is-FindInfraWalk-with-Shortest"
]

(* the window is the horizon of the rule: the walk winding once round
   C6 is minimizing in every window of 3 vertices with the next one and fails
   at 4, so the finder emits it at scale 3 and not at 4 -- exactly
   InfraGeodesicQ's threshold *)
VerificationTest[
  With[ { g = CycleGraph[ 6 ], winding = { 1, 2, 3, 4, 5, 6, 1 } },
    { MemberQ[ walkSeqs @ FindInfraWalk[ g, 1, { 6 }, All,
          Properties -> { { "Shortest", # }, { "Simple", 2 } } ], winding ],
      InfraGeodesicQ[ g, winding, # ] } & /@ { 2, 3, 4, Infinity } ],
  { { True, True }, { True, True }, { False, False }, { False, False } },
  TestID -> "FindInfraWalk-Shortest-window-semantics"
]

(* a geodesic between two points is an endpoint condition on the geodesics
   from the first: from the centre of the 9-by-9 grid the arrivals at 61 are
   the segment class from 41 to 61 *)
VerificationTest[
  With[ { g = GridGraph[ { 9, 9 } ] },
    Sort @ walkSeqs @ endingAt[ FindInfraGeodesic[ g, 41, Infinity, Infinity, All, stopAt[ 61 ] ], 61 ] ===
      Sort @ FindInfraSegment[ g, 41, 61, All ] ],
  True,
  TestID -> "FindInfraGeodesic-endpoint-from-the-centre"
]

(* the argument after the germ is the scale, also when it names a vertex:
   the simple geodesics from 1 at scale 3 on C6 run round to the far side and
   do not stop at 3 *)
VerificationTest[
  With[ { g = CycleGraph[ 6 ] },
    { Sort @ walkSeqs @ FindInfraGeodesic[ g, 1, 3, Infinity, All, Properties -> { "Simple" } ] ===
        Sort @ walkSeqs @ FindInfraWalk[ g, 1, Infinity, All,
          Properties -> { { "Shortest", 3 }, "Simple" } ],
      Sort @ walkSeqs @ FindInfraGeodesic[ g, 1, 3, Infinity, All, Properties -> { "Simple" } ] } ],
  { True, { { 1, 2, 3, 4, 5, 6 }, { 1, 6, 5, 4, 3, 2 } } },
  TestID -> "FindInfraGeodesic-scale-naming-a-vertex-is-a-scale"
]

(* the three-argument form grows the germ 1 at scale 3 with no budget *)
VerificationTest[
  walkSeqs @ FindInfraGeodesic[ CycleGraph[ 6 ], 1, 3, Properties -> { "Simple" } ],
  { { 1, 2, 3, 4, 5, 6 } },
  TestID -> "FindInfraGeodesic-three-argument-form-is-pointed"
]


(* ===================== Walk germs ===================== *)

(* on a walk germ too the geodesic finder is the general finder with
   {"Shortest", scale} added to the rules *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    Sort @ walkSeqs @ FindInfraGeodesic[ g, { 4, 5 }, 2, UpTo[ 3 ], All, Properties -> { "Simple" }, "Direction" -> "BothSides" ] ===
      Sort @ walkSeqs @ FindInfraWalk[ g, { 4, 5 }, UpTo[ 3 ], All,
        Properties -> { { "Shortest", 2 }, "Simple" }, "Direction" -> "BothSides" ] ],
  True,
  TestID -> "FindInfraGeodesic-walk-germ-is-FindInfraWalk-with-Shortest"
]

(* the extensions of a germ at a scale are geodesics at that scale, so a germ
   that is not one has none: the backtrack 41, 42, 41 fails at scale 2, the
   U-turn 1, 2, 5, 4 on the 3 x 3 grid passes at 2 and fails at 3 *)
VerificationTest[
  With[ { g = GridGraph[ { 9, 9 } ], h = GridGraph[ { 3, 3 } ] },
    { FindInfraGeodesic[ g, { 41, 42, 41 }, 2, { 2 }, All, "Direction" -> "BothSides" ],
      FindInfraGeodesic[ g, { 41, 42, 41 }, 2, { 2 }, "Direction" -> "BothSides" ],
      FindInfraGeodesic[ g, { 41, 42, 41 }, Infinity, UpTo[ 2 ], All, "Direction" -> "BothSides" ],
      FindInfraWalk[ g, { 41, 42, 41 }, { 2 }, All, Properties -> { { "Shortest", 2 } }, "Direction" -> "BothSides" ],
      FindInfraGeodesic[ h, { 1, 2, 5, 4 }, 3, UpTo[ 2 ], All, "Direction" -> "BothSides" ],
      With[ { exts = walkSeqs @ FindInfraGeodesic[ h, { 1, 2, 5, 4 }, 2, UpTo[ 2 ], All, "Direction" -> "BothSides" ] },
        exts =!= { } && AllTrue[ exts, w |-> InfraGeodesicQ[ h, w, 2 ] ] ] } ],
  { { }, { }, { }, { }, { }, True },
  TestID -> "FindInfraGeodesic-non-geodesic-germ-has-no-extension"
]

(* both sides grown from a germ shorter than the scale meet in a window the
   two sides cannot see alone; it is re-checked, so every extension of one
   vertex at both ends is a geodesic -- without the check 23, 32, 41, 32, 23
   comes back at scale 2 *)
VerificationTest[
  With[ { g = GridGraph[ { 9, 9 } ] },
    Table[
      With[ { exts = walkSeqs @ FindInfraGeodesic[ g, seed, sc, { 2 }, All, "Direction" -> "BothSides" ] },
        exts =!= { } && AllTrue[ exts, w |-> InfraGeodesicQ[ g, w, sc ] ] ],
      { seed, { { 41 }, { 41, 42 } } }, { sc, { 2, 3, 4 } } ] ],
  { { True, True, True }, { True, True, True } },
  TestID -> "FindInfraGeodesic-BothSides-short-germ-joins-as-a-geodesic"
]

(* under "Simple" the growth is bounded by itself: a simple walk
   cannot revisit, so kspec Infinity is legal and the two-sided growth of a
   middle edge is the whole path *)
VerificationTest[
  walkSeqs @ FindInfraWalk[ PathGraph[ Range[ 5 ] ], { 2, 3 }, Properties -> { "Simple" }, "Direction" -> "BothSides" ],
  { { 1, 2, 3, 4, 5 } },
  TestID -> "FindInfraWalk-walk-germ-default-simple-bounds-the-class"
]

VerificationTest[
  walkSeqs @ FindInfraGeodesic[ PathGraph[ Range[ 5 ] ], { 3, 4 }, Infinity, UpTo[ 1 ], 1, Properties -> { "Simple" },
    "Direction" -> "Forward" ],
  { { 3, 4, 5 } },
  TestID -> "FindInfraGeodesic-PathGraph-forward"
]

VerificationTest[
  walkSeqs @ FindInfraGeodesic[ PathGraph[ Range[ 5 ] ], { 3, 4 }, Infinity, UpTo[ 2 ], 1, Properties -> { "Simple" },
    "Direction" -> "Backward" ],
  { { 1, 2, 3, 4 } },
  TestID -> "FindInfraGeodesic-PathGraph-backward"
]

(* a one-vertex germ grows forward by default; "BothSides" gives the geodesics through it *)
VerificationTest[
  Sort @ walkSeqs @ FindInfraGeodesic[ PathGraph[ Range[ 5 ] ], { 3 }, Infinity, Infinity, All,
      Properties -> { "Simple" }, "Direction" -> "BothSides" ],
  Sort[ { { 1, 2, 3, 4, 5 }, { 5, 4, 3, 2, 1 } } ],
  TestID -> "FindInfraGeodesic-PathGraph-both-unbudgeted"
]

VerificationTest[
  Sort @ walkSeqs @ FindInfraGeodesic[ CycleGraph[ 6 ], FindInfraSegment[ CycleGraph[ 6 ], 1, 4, All ],
      Infinity, UpTo[ 0 ], All, Properties -> { "Simple" } ],
  Sort[ { { 1, 2, 3, 4 }, { 1, 6, 5, 4 } } ],
  TestID -> "FindInfraGeodesic-bundle-of-segments-spread"
]

VerificationTest[
  Sort @ walkSeqs @ FindInfraGeodesic[ CycleGraph[ 6 ], { 1 }, Infinity, UpTo[ 2 ], All, Properties -> { "Simple" },
      "NextVertexFunction" -> MinimalBy[ w |-> Length[ w ] - 1 - GraphDistance[ CycleGraph[ 6 ], First @ w, Last @ w ] ],
      "Direction" -> "Forward" ],
  Sort[ { { 1, 2, 3 }, { 1, 6, 5 } } ],
  TestID -> "FindInfraGeodesic-CycleGraph-least-defect-forward"
]

VerificationTest[
  AllTrue[
    walkSeqs @ FindInfraGeodesic[ GridGraph[ { 3, 3 } ], { 1 }, Infinity, UpTo[ 3 ], All, Properties -> { "Simple" },
      "Direction" -> "Forward" ],
    p |-> InfraWalkQ[ GridGraph[ { 3, 3 } ], p ] ],
  True,
  TestID -> "FindInfraGeodesic-all-extensions-pass-InfraWalkQ"
]

VerificationTest[
  MatchQ[
    FindInfraGeodesic[ GridGraph[ { 3, 3 } ], { 1, 2 }, Infinity, UpTo[ 2 ], All, "Direction" -> "BothSides" ],
    { __Graph } ],
  True,
  TestID -> "FindInfraGeodesic-output-shape"
]

VerificationTest[
  Length @
    ( walkSeqs @ FindInfraGeodesic[ PathGraph[ Range[ 7 ] ], { 4, 5 }, Infinity, UpTo[ 2 ], 1,
      Properties -> { "Simple" },
      "Direction" -> "Forward" ] )[[ 1 ]],
  4,
  TestID -> "FindInfraGeodesic-budget-truncation"
]

(* a bundle germ: each of its walks is grown, each with its own
   relative budget *)
VerificationTest[
  Sort @ walkSeqs @ FindInfraGeodesic[ PathGraph[ Range[ 7 ] ],
      walkGraph /@ { { 3 }, { 5 } }, Infinity, UpTo[ 1 ], All, Properties -> { "Simple" },
      "Direction" -> "Forward" ],
  Sort[ { { 3, 2 }, { 3, 4 }, { 5, 4 }, { 5, 6 } } ],
  TestID -> "FindInfraGeodesic-bundle-germ"
]

(* Dead-end freeze: forward growth of the right endpoint freezes *)
VerificationTest[
  walkSeqs @ FindInfraGeodesic[ PathGraph[ Range[ 5 ] ], { 4, 5 }, Infinity, UpTo[ 5 ], 1, Properties -> { "Simple" },
    "Direction" -> "Forward" ],
  { { 4, 5 } },
  TestID -> "FindInfraGeodesic-dead-end-freeze"
]

VerificationTest[
  walkSeqs @ FindInfraGeodesic[ PathGraph[ Range[ 5 ] ], { 2, 3 }, Infinity, Infinity, 1,
    Properties -> { "Simple" }, "Direction" -> "BothSides" ],
  { { 1, 2, 3, 4, 5 } },
  TestID -> "FindInfraGeodesic-BothSides-extends-segment-to-line"
]

(* on "BothSides" the budget counts edges added per growing side -- outer
   steps -- so kspec 1 buys one symmetric step *)
VerificationTest[
  walkSeqs @ FindInfraGeodesic[ PathGraph[ Range[ 5 ] ], { 3, 4 }, Infinity, UpTo[ 1 ], 1,
    Properties -> { "Simple" }, "Direction" -> "BothSides" ],
  { { 2, 3, 4, 5 } },
  TestID -> "FindInfraGeodesic-BothSides-symmetric-one-step"
]

(* a frozen side stops paying: at kspec 2 the live side keeps growing one
   edge per step, four edges added in total *)
VerificationTest[
  walkSeqs @ FindInfraGeodesic[ PathGraph[ Range[ 5 ] ], { 3, 4 }, Infinity, UpTo[ 2 ], 1,
    Properties -> { "Simple" }, "Direction" -> "BothSides" ],
  { { 1, 2, 3, 4, 5 } },
  TestID -> "FindInfraGeodesic-BothSides-budget-per-side"
]

(* Asymmetric tail: forward freezes immediately, backward keeps growing one
   edge per step until it reaches vertex 1 *)
VerificationTest[
  walkSeqs @ FindInfraGeodesic[ PathGraph[ Range[ 5 ] ], { 4, 5 }, Infinity, UpTo[ 5 ], 1,
    Properties -> { "Simple" }, "Direction" -> "BothSides" ],
  { { 1, 2, 3, 4, 5 } },
  TestID -> "FindInfraGeodesic-BothSides-asymmetric-tail"
]

(* the two-sided Cartesian is re-checked as a whole geodesic: without the
   joined "Shortest" filter C6 emits {5, 6, 1, 2, 3}, with d(5, 3) = 2 *)
VerificationTest[
  AllTrue[
    walkSeqs @ FindInfraGeodesic[ CycleGraph[ 6 ], { 1 }, Infinity, Infinity, All, "Direction" -> "BothSides" ],
    w |-> InfraGeodesicQ[ CycleGraph[ 6 ], w ] ],
  True,
  TestID -> "FindInfraGeodesic-BothSides-joined-Shortest-filter"
]

(* the two sides move independently: in C4 no joint step survives the joined
   "Shortest" filter -- {4, 1, 2, 3} has d(4, 3) = 1 -- and the maximal
   geodesics through the edge {1, 2} are reached one side at a time *)
VerificationTest[
  Sort @ walkSeqs @ FindInfraGeodesic[ CycleGraph[ 4 ], { 1, 2 }, Infinity, Infinity, All, "Direction" -> "BothSides" ],
  Sort[ { { 1, 2, 3 }, { 4, 1, 2 } } ],
  TestID -> "FindInfraGeodesic-BothSides-single-side-move"
]

(* the two L-shaped lines carrying the top row of a 4x4 grid: each needs the
   row extended on one side only *)
VerificationTest[
  Sort @ walkSeqs @ FindInfraGeodesic[ GridGraph[ { 4, 4 } ], { 1, 2, 3, 4 }, Infinity, Infinity,
    All, "Direction" -> "BothSides" ],
  Sort[ { { 1, 2, 3, 4, 8, 12, 16 }, { 13, 9, 5, 1, 2, 3, 4 } } ],
  TestID -> "FindInfraGeodesic-BothSides-grid-row-L-lines"
]

(* at scale Infinity the two-sided growth of a geodesic is the class of lines
   through it: the walk engine and FindInfraLine agree, here on a torus where
   the two ends interact *)
VerificationTest[
  With[ { g = TorusGraph[ { 4, 5 } ], unoriented = w |-> Sort[ { w, Reverse @ w } ] },
    Sort[ unoriented /@ walkSeqs @ FindInfraGeodesic[ g, { 1, 2 }, Infinity, Infinity, All, "Direction" -> "BothSides" ] ] ===
    Sort[ unoriented /@ FindInfraLine[ g, { 1, 2 }, All ] ] ],
  True,
  TestID -> "FindInfraGeodesic-BothSides-agrees-with-FindInfraLine"
]

(* an unbudgeted growth is maximal: growing a returned line again returns it *)
VerificationTest[
  AllTrue[
    walkSeqs @ FindInfraGeodesic[ CycleGraph[ 6 ], { 1, 2 }, Infinity, Infinity, All, "Direction" -> "BothSides" ],
    w |-> walkSeqs @ FindInfraGeodesic[ CycleGraph[ 6 ], w, Infinity, Infinity, All ] === { w } ],
  True,
  TestID -> "FindInfraGeodesic-BothSides-extension-is-maximal"
]

(* kspec bounds the edges added per side, not the moves taken: at kspec 1 the
   only walk both capped and maximal is the symmetric one, the one-sided
   {3, 4, 5} and {4, 5, 6} still having room to grow *)
VerificationTest[
  walkSeqs @ FindInfraGeodesic[ PathGraph[ Range[ 7 ] ], { 4, 5 }, Infinity, UpTo[ 1 ], All,
    Properties -> { "Simple" }, "Direction" -> "BothSides" ],
  { { 3, 4, 5, 6 } },
  TestID -> "FindInfraGeodesic-BothSides-budget-caps-each-side"
]

(* exact kspec on both sides: a budget the graph cannot pay returns nothing *)
VerificationTest[
  walkSeqs @ FindInfraWalk[ PathGraph[ Range[ 6 ] ], { 3, 4 }, { 10 }, All, Properties -> { "Simple" }, "Direction" -> "BothSides" ],
  { },
  TestID -> "FindInfraWalk-BothSides-exact-kspec-unreachable"
]

(* exact relative kspec: the branch frozen after one added edge fails {2} *)
VerificationTest[
  walkSeqs @ FindInfraGeodesic[ PathGraph[ Range[ 5 ] ], { 4 }, Infinity, { 2 }, All, Properties -> { "Simple" },
    "Direction" -> "Forward" ],
  { { 4, 3, 2 } },
  TestID -> "FindInfraGeodesic-exact-kspec-drops-short-freeze"
]

(* a stopping condition on a class that may self-intersect: the winding walk
   stops at its first return.  The direction is "Forward" by default, also
   on a walk germ *)
VerificationTest[
  walkSeqs @ FindInfraWalk[ CycleGraph[ 6 ], { 1, 2 }, UpTo[ 20 ], 1,
    Properties -> { { "Simple", 2 } }, "StoppingCondition" -> ( Length[ # ] - Length[ DeleteDuplicates @ # ] >= 1 & ) ],
  { { 1, 2, 3, 4, 5, 6, 1 } },
  TestID -> "FindInfraWalk-stopping-condition-on-a-walk-germ"
]

(* a delay is the condition read on the walk without its last edges: two
   further edges after the first arrival at a visited vertex *)
VerificationTest[
  walkSeqs @ FindInfraWalk[ CycleGraph[ 6 ], { 1, 2 }, UpTo[ 20 ], 1, Properties -> { { "Simple", 2 } },
    "StoppingCondition" -> ( With[ { w = Drop[ #, -2 ] }, Length[ w ] - Length[ DeleteDuplicates @ w ] >= 1 ] & ) ],
  { { 1, 2, 3, 4, 5, 6, 1, 2, 3 } },
  TestID -> "FindInfraWalk-walk-germ-stopping-condition-delay"
]

(* events replay over the germ: a deadline that already passed inside the
   germ returns it unextended *)
VerificationTest[
  walkSeqs @ FindInfraWalk[ CycleGraph[ 6 ], { 1, 2, 3, 4, 5, 6, 1 }, UpTo[ 10 ], 1, Properties -> { { "Simple", 2 } },
    "StoppingCondition" -> ( Length[ # ] - Length[ DeleteDuplicates @ # ] >= 1 & ),
    "Direction" -> "Forward" ],
  { { 1, 2, 3, 4, 5, 6, 1 } },
  TestID -> "FindInfraWalk-events-replay-over-the-germ"
]

(* under "Simple" no arrival at a visited vertex can happen: the
   condition never fires and the walk runs to its budget *)
VerificationTest[
  Sort @ walkSeqs @ FindInfraWalk[ PathGraph[ Range[ 5 ] ], { 3 }, UpTo[ 5 ], All, Properties -> { "Simple" },
      "StoppingCondition" -> ( Length[ # ] - Length[ DeleteDuplicates @ # ] >= 1 & ),
      "Direction" -> "Forward" ],
  Sort[ { { 3, 2, 1 }, { 3, 4, 5 } } ],
  TestID -> "FindInfraWalk-germ-dead-event-runs-to-the-budget"
]

VerificationTest[
  FindInfraGeodesic[ PathGraph[ Range[ 5 ] ], { 3 }, Infinity, Infinity, 99,
    Properties -> { "Simple" }, "Direction" -> "BothSides" ],
  { },
  TestID -> "FindInfraGeodesic-germ-strict-shortfall"
]

VerificationTest[
  BlockRandom[
    With[ { r = FindInfraGeodesic[ GridGraph[ { 3, 3 } ], { 1 }, Infinity, UpTo[ 4 ], 1, Properties -> { "Simple" },
        "NextVertexFunction" -> RandomSample,
        "Direction" -> "Forward" ] },
      MatchQ[ r, { _Graph } ] && VertexCount[ First @ r ] == 5 ],
    RandomSeeding -> 7 ],
  True,
  TestID -> "FindInfraGeodesic-RandomSample-forward-trajectory"
]

VerificationTest[
  BlockRandom[
    MatchQ[
      FindInfraGeodesic[ GridGraph[ { 3, 3 } ], { 5 }, Infinity, UpTo[ 4 ], 1,
        Properties -> { "Simple" }, "NextVertexFunction" -> RandomSample, "Direction" -> "BothSides" ],
      { _Graph } ],
    RandomSeeding -> 7 ],
  True,
  TestID -> "FindInfraGeodesic-RandomSample-BothSides-trajectory"
]


(* ===================== The next-vertex function ===================== *)

(* First keeps the first candidate of the canonical order and never backtracks:
   from a vertex it is the default witness, the first leaf of the descent;
   with an endpoint it reaches the target only when the first branch does,
   which the grid's first branch 1, 2, 3, 4, 8, 7, ... does not *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    { FindInfraWalk[ g, 1, UpTo[ 6 ], Properties -> { "Simple" }, "NextVertexFunction" -> First ] === FindInfraWalk[ g, 1, UpTo[ 6 ],
        Properties -> { "Simple" } ],
      endingAt[ FindInfraWalk[ g, 1, { 6 }, All, stopAt[ 16 ], Properties -> { "Simple" }, "NextVertexFunction" -> First ], 16 ] } ],
  { True, { } },
  TestID -> "FindInfraWalk-First-is-the-first-branch"
]

(* RandomChoice is the random walk: one admissible step at a time, no
   backtracking, so a count is that many independent runs, and All is no count *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    { one = BlockRandom[ FindInfraWalk[ g, 13, UpTo[ 6 ], Properties -> { "Simple" }, "NextVertexFunction" -> RandomChoice ], RandomSeeding -> 2 ],
      three = BlockRandom[ FindInfraWalk[ g, 13, UpTo[ 6 ], 3, Properties -> { "Simple" },
          "NextVertexFunction" -> RandomChoice ], RandomSeeding -> 2 ] },
    { GraphQ @ one && InfraWalkQ[ g, walkSeq @ one ] && DuplicateFreeQ[ walkSeq @ one ],
      Length @ three, AllTrue[ walkSeqs @ three, First[ # ] === 13 && DuplicateFreeQ[ # ] & ],
      MatchQ[ FindInfraWalk[ g, 13, UpTo[ 6 ], All, Properties -> { "Simple" }, "NextVertexFunction" -> RandomChoice ], _FindInfraWalk ] } ],
  { True, 3, True, True },
  TestID -> "FindInfraWalk-RandomChoice-is-the-random-walk"
]

(* the five walks of a count are five runs, not five branches of one descent:
   over twenty seeds their first steps are not always equal *)
VerificationTest[
  With[ { g = GridGraph[ { 9, 9 } ] },
    { firsts = Table[ BlockRandom[
        walkSeqs[ FindInfraWalk[ g, 41, UpTo[ 8 ], 5, Properties -> { "Simple" }, "NextVertexFunction" -> RandomChoice ] ][[ All, 2 ]],
        RandomSeeding -> seed ], { seed, 20 } ] },
    { AllTrue[ firsts, Length[ # ] == 5 & ], AnyTrue[ firsts, ! SameQ @@ # & ] } ],
  { True, True },
  TestID -> "FindInfraWalk-RandomChoice-count-is-independent-runs"
]

(* the random walk straightened: the window defect is the number of edges the
   window wastes against a shortest path.  Forbidding a defect above 1 in the last
   eight steps, or drawing the next vertex with weight Exp[ -2 defect ], carries the
   walk farther from its start per edge than the uniform draw, in the mean over
   forty seeds *)
VerificationTest[
  With[ { g = GridGraph[ { 24, 24 } ], k = 30, r = 8, start = 300 },
    { defect = w |-> Length[ w ] - 1 - GraphDistance[ g, First @ w, Last @ w ],
      stretch = w |-> N[ GraphDistance[ g, First @ w, Last @ w ] / ( Length[ w ] - 1 ) ] },
    { draw = rules |-> Mean @ Table[
        BlockRandom[ stretch @ walkSeq @ FindInfraWalk[ g, start, UpTo[ k ], Properties -> rules, "NextVertexFunction" -> RandomChoice ],
          RandomSeeding -> seed ],
        { seed, 40 } ] },
    { uniform = draw[ { "Simple" } ] },
    { draw[ { "Simple", { w |-> defect[ w ] <= 1, r } } ] > uniform,
      draw[ { "Simple", { "Shortest", r, Exp[ -2 ] } } ] > uniform } ],
  { True, True },
  TestID -> "FindInfraWalk-random-walk-straightened-by-the-window-defect"
]


(* ===================== InfraWalk scene-DSL constructor ===================== *)

VerificationTest[
  With[{
    scene = InfraScene[ { path }, { path == InfraWalk[ 1, 2, 3 ] } ],
    g = PathGraph[ Range[ 5 ] ]
  },
    With[{ instances = FindInfraScene[ scene, g ] },
      Length[ instances ] == 1 && instances[[ 1 ]][[ 1 ]][ path ] === { 1, 2, 3 }
    ]
  ],
  True,
  TestID -> "InfraWalk-scene-DSL-bare-chain"
]

(* No edge between 1 and 3 on P5 => empty result. *)
VerificationTest[
  With[{
    scene = InfraScene[ { path }, { path == InfraWalk[ 1, 3 ] } ],
    g = PathGraph[ Range[ 5 ] ]
  },
    FindInfraScene[ scene, g ]
  ],
  { },
  TestID -> "InfraWalk-scene-DSL-no-edge-empty"
]

(* Non-simple chain 1-2-1 on P3 is kept (no DuplicateFreeQ filter). *)
VerificationTest[
  With[{
    scene = InfraScene[ { path }, { path == InfraWalk[ 1, 2, 1 ] } ],
    g = PathGraph[ Range[ 3 ] ]
  },
    With[{ instances = FindInfraScene[ scene, g ] },
      Length[ instances ] == 1 && instances[[ 1 ]][[ 1 ]][ path ] === { 1, 2, 1 }
    ]
  ],
  True,
  TestID -> "InfraWalk-scene-DSL-non-simple-kept"
]

(* the graph carries what the accessors used to: the length is the edge count,
   the ends are read off the vertex sequence, and the end multiset is Counts *)
VerificationTest[
  With[ { reps = { { 1, 2, 4 }, { 5, 6, 4 }, { 7, 8, 9 } } },
    { ws = walkGraph /@ reps },
    { EdgeCount /@ ws, walkSeqs @ ws === reps,
      KeySort @ Counts[ Last /@ walkSeqs @ ws ] }
  ],
  { { 2, 2, 2 }, True, <| 4 -> 2, 9 -> 1 |> },
  TestID -> "walk-graph-length-ends-and-end-multiset"
]

(* kspec bounds the walk-space sweep itself: past kmax the bare walk class is
   infinite, so the enumeration must terminate. *)
VerificationTest[
  With[ { walks = Select[ walkSeqs @ FindInfraWalk[ CycleGraph[ 4 ], 1, { 6 }, All, Properties -> { } ], Last[ # ] === 3 & ] },
    walks =!= { } && AllTrue[ walks,
      w |-> Length[ w ] - 1 == 6 && First[ w ] == 1 && Last[ w ] == 3 &&
        AllTrue[ Partition[ w, 2, 1 ], Apply[ EdgeQ[ CycleGraph[ 4 ], UndirectedEdge[ #1, #2 ] ] & ] ] ]
  ],
  True,
  TestID -> "FindInfraWalk-property-sweep-depth-bounded"
]

(* the first walk of the endpoint spelling is the first branch of the
   descent, not a geodesic; the geodesic witness is FindInfraGeodesic's *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    { EdgeCount /@ endingAt[ FindInfraWalk[ g, 1, Infinity, 1, stopAt[ 16 ], Properties -> { "Simple" } ], 16 ],
      EdgeCount /@ FindInfraGeodesic[ g, 1, Infinity, Infinity, 1 ] } ],
  { { 12 }, { 6 } },
  TestID -> "FindInfraWalk-endpoint-witness-is-the-first-branch"
]

(* bare k means at most k: same class as the explicit {0, k} range *)
VerificationTest[
  Sort @ walkSeqs @ FindInfraWalk[ GridGraph[ { 3, 3 } ], 1, UpTo[ 6 ], All,
    Properties -> { } ],
  Sort @ walkSeqs @ FindInfraWalk[ GridGraph[ { 3, 3 } ], 1, { 0, 6 }, All,
    Properties -> { } ],
  TestID -> "FindInfraWalk-bare-k-at-most-both-paths"
]

(* a lower length bound must not be starved by the early-stop count *)
VerificationTest[
  Length @ walkSeqs @ FindInfraWalk[ GridGraph[ { 3, 3 } ], 1, { 8 }, 2,
    Properties -> { } ],
  2,
  TestID -> "FindInfraWalk-exact-length-strict-count"
]

(* lazy DFS, one instance; "Simple" bounds the unconstrained descent
   by itself. *)
VerificationTest[
  walkSeqs @ FindInfraWalk[ PathGraph[ Range[ 5 ] ], 1, Infinity, 1, Properties -> { "Simple" } ],
  { { 1, 2, 3, 4, 5 } },
  TestID -> "FindInfraWalk-unconstrained-canonical-witness"
]

(* a bounded kspec in canonical order: from the high end of the path graph
   the one walk runs down to vertex 1. *)
VerificationTest[
  walkSeqs @ FindInfraWalk[ PathGraph[ Range[ 5 ] ], 5, UpTo[ 4 ], 1, Properties -> { "Simple" } ],
  { { 5, 4, 3, 2, 1 } },
  TestID -> "FindInfraWalk-canonical-bounded-succeeds"
]


(* ===================== The method ladder ===================== *)

(* The lazy descent is COMPLETE, so every finite count is exact: from vertex 1
   on CycleGraph[4] there are exactly 2 immersed walks of length 6 (the two
   rotations), and asking for k of them in the canonical order
   returns k distinct genuine ones for every k <= 2.  Asking for 3 is the
   honest $Failed. *)
VerificationTest[
  With[ { g = CycleGraph[ 4 ] },
    { whole = walkSeqs @ FindInfraWalk[ g, 1, { 6 }, All, Properties -> { { "Simple", 2 } } ] },
    { AllTrue[ Range[ 1, Length @ whole ],
        k |-> With[ { got = walkSeqs @ FindInfraWalk[ g, 1, { 6 }, k, Properties -> { { "Simple", 2 } } ] },
          Length[ got ] === k && DuplicateFreeQ[ got ] && SubsetQ[ whole, got ] &&
          AllTrue[ got, w |-> InfraWalkQ[ g, w ] && Length[ w ] - 1 === 6 ] ] ],
      FindInfraWalk[ g, 1, { 6 }, Length[ whole ] + 1, Properties -> { { "Simple", 2 } } ] } ],
  { True, { } },
  TestID -> "FindInfraWalk-finite-count-is-exact"
]

(* Count-coupling: the count-less call is one instance -- a genuine member of the
   class, and the class itself is bigger.  This is what makes exponential
   enumeration opt-in. *)
VerificationTest[
  With[ { g = CycleGraph[ 4 ] },
    { one = walkSeqs @ FindInfraWalk[ g, 1, { 6 }, Properties -> { { "Simple", 2 } } ] },
    { Length @ one === 1,
      InfraWalkQ[ g, First @ one ] && Length[ First @ one ] - 1 === 6,
      Length @ walkSeqs @ FindInfraWalk[ g, 1, { 6 }, All, Properties -> { { "Simple", 2 } } ] > 1 } ],
  { True, True, True },
  TestID -> "FindInfraWalk-countless-is-one-instance"
]

(* RandomSample moves which walks come out first, never which
   exist: the random descent is as complete as the deterministic one, so a
   strict count is still exact and All still recovers the class. *)
VerificationTest[
  With[ { g = CycleGraph[ 4 ] },
    { class = Sort @ walkSeqs @ FindInfraWalk[ g, 1, { 6 }, All, Properties -> { { "Simple", 2 } } ] },
    { Sort @ walkSeqs @ FindInfraWalk[ g, 1, { 6 }, All, Properties -> { { "Simple", 2 } },
          "NextVertexFunction" -> RandomSample ] === class,
      Union @ Table[
        Length @ walkSeqs @ FindInfraWalk[ g, 1, { 6 }, 2, Properties -> { { "Simple", 2 } } ],
        { 20 } ],
      SubsetQ[ class,
        walkSeqs @ FindInfraWalk[ g, 1, { 6 }, 2, Properties -> { { "Simple", 2 } } ] ] } ],
  { True, { 2 }, True },
  TestID -> "FindInfraWalk-RandomSample-is-complete"
]

(* a bounded count is the deterministic descent: the default witness is
   reproducible without a seed and is the explicit Identity one *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    { FindInfraWalk[ g, 1, { 6 }, Properties -> { "Simple" } ] === FindInfraWalk[ g, 1, { 6 }, Properties -> { "Simple" } ],
      FindInfraWalk[ g, 1, { 6 }, Properties -> { "Simple" } ] ===
        FindInfraWalk[ g, 1, { 6 }, Properties -> { "Simple" }, "NextVertexFunction" -> Identity ] } ],
  { True, True },
  TestID -> "FindInfraWalk-default-is-deterministic"
]

(* RandomSample draws the witness from the ambient random state -- SeedRandom
   reproduces it, and the seeds disagree *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    { BlockRandom[ walkSeqs @ FindInfraWalk[ g, 1, { 6 }, Properties -> { "Simple" }, "NextVertexFunction" -> RandomSample ],
        RandomSeeding -> 3 ] ===
      BlockRandom[ walkSeqs @ FindInfraWalk[ g, 1, { 6 }, Properties -> { "Simple" }, "NextVertexFunction" -> RandomSample ],
        RandomSeeding -> 3 ],
      Length @ Union @ Table[
        First @ walkSeqs @ FindInfraWalk[ g, 1, { 6 }, Properties -> { "Simple" }, "NextVertexFunction" -> RandomSample ],
        { 30 } ] > 1 } ],
  { True, True },
  TestID -> "FindInfraWalk-RandomSample-witness-is-ambient-seeded"
]

(* the count-less default is the canonical witness of the Identity order: from
   the corner of the grid one maximal geodesic, running to the far corner *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    { w = walkSeq @ FindInfraGeodesic[ g, 1, Infinity ] },
    { Length[ w ] - 1 == GraphDistance[ g, 1, 16 ], Last @ w,
      FindInfraGeodesic[ g, 1, Infinity ] === FindInfraGeodesic[ g, 1, Infinity, "NextVertexFunction" -> Identity ] } ],
  { True, 16, True },
  TestID -> "FindInfraGeodesic-countless-default-is-a-geodesic"
]


(* ===================== Stopping conditions ===================== *)

(* the deadline arithmetic is exact: on the single edge the walk can only
   bounce, so its first arrival at a visited vertex is the third vertex, and
   the condition read without the last two vertices grants two further edges *)
VerificationTest[
  { walkSeqs @ FindInfraWalk[ PathGraph[ { 1, 2 } ], 1, UpTo[ 9 ], Properties -> { },
      "StoppingCondition" -> ( Length[ # ] - Length[ DeleteDuplicates @ # ] >= 1 & ) ],
    walkSeqs @ FindInfraWalk[ PathGraph[ { 1, 2 } ], 1, UpTo[ 9 ], Properties -> { },
      "StoppingCondition" -> ( With[ { w = Drop[ #, -2 ] }, Length[ w ] - Length[ DeleteDuplicates @ w ] >= 1 ] & ) ] },
  { { { 1, 2, 1 } }, { { 1, 2, 1, 2, 1 } } },
  TestID -> "FindInfraWalk-stopping-delay-arithmetic"
]

(* n counts arrivals at visited vertices, whichever vertex: the bounce's
   second arrival is its fourth vertex *)
VerificationTest[
  walkSeqs @ FindInfraWalk[ PathGraph[ { 1, 2 } ], 1, UpTo[ 9 ], Properties -> { },
    "StoppingCondition" -> ( Length[ # ] - Length[ DeleteDuplicates @ # ] >= 2 & ) ],
  { { 1, 2, 1, 2 } },
  TestID -> "FindInfraWalk-stopping-count-second-arrival"
]

(* the second firing, on the generic class: two isolated double points *)
VerificationTest[
  With[ { g = GridGraph[ { 6, 6 } ] },
    { w = BlockRandom[
        First @ walkSeqs @ FindInfraWalk[ g, 1, UpTo[ 200 ], Properties -> genericRules,
            "StoppingCondition" -> ( Length[ # ] - Length[ DeleteDuplicates @ # ] >= 2 & ),
          "NextVertexFunction" -> RandomSample ],
        RandomSeeding -> 1 ] },
    Length[ w ] - Length[ DeleteDuplicates @ w ] ],
  2,
  TestID -> "FindInfraWalk-stopping-count-second-firing"
]

(* a condition awaiting a self-intersection the constraints exclude warns and
   runs to the budget *)
VerificationTest[
  walkSeqs @ FindInfraWalk[ PathGraph[ Range[ 5 ] ], 1, Properties -> { "Simple" },
    "StoppingCondition" -> ( Length[ # ] - Length[ DeleteDuplicates @ # ] >= 1 & ) ],
  { { 1, 2, 3, 4, 5 } },
  TestID -> "FindInfraWalk-dead-event-warns"
]

(* the endpoint is one stopping condition among many, and one predicate
   carries several: a walk touching 5 stops there and never reaches 9 *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    { reps = walkSeqs @ endingAt[ FindInfraWalk[ g, 1, UpTo[ 8 ], All, Properties -> { "Simple" },
        "StoppingCondition" -> ( Last[ # ] === 9 || MemberQ[ #, 5 ] & ) ], 9 ] },
    reps =!= { } && AllTrue[ reps, FreeQ[ #, 5 ] & ] ],
  True,
  TestID -> "FindInfraWalk-endpoint-and-predicate-in-one-condition"
]

(* ===================== WalkSingularities ===================== *)

(* a simple path is free of every singularity *)
VerificationTest[
  WalkSingularities[ { 1, 2, 5, 8, 9 } ],
  <| "SelfIntersections" -> { }, "SelfTangencies" -> { }, "Cusps" -> { } |>,
  TestID -> "WalkSingularities-simple-path-empty"
]

(* the retraced arc around an apex is one cusp block, however deep; its
   coincidences are self-intersections, not a repeated arc *)
VerificationTest[
  WalkSingularities[ { 6, 5, 4, 3, 2, 3, 4, 7 } ],
  <| "SelfIntersections" -> { { 3, 7 }, { 4, 6 } }, "SelfTangencies" -> { },
     "Cusps" -> { { 3, 4, 5, 6, 7 } } |>,
  TestID -> "WalkSingularities-deep-cusp-one-block"
]

(* a walk revisiting a tree edge: the fold is one cusp, nothing else *)
VerificationTest[
  WalkSingularities[ { 2, 1, 3, 1, 4 } ],
  <| "SelfIntersections" -> { { 2, 4 } }, "SelfTangencies" -> { }, "Cusps" -> { { 2, 3, 4 } } |>,
  TestID -> "WalkSingularities-tree-fold-is-a-cusp"
]

(* an arc re-run in the same direction: both intervals ascend *)
VerificationTest[
  WalkSingularities[ { 1, 2, 5, 6, 3, 2, 5, 8 } ][ "SelfTangencies" ],
  { { { 2, 3 }, { 6, 7 } } },
  TestID -> "WalkSingularities-direct-tangency"
]

(* an arc retraced in reverse: the second interval descends *)
VerificationTest[
  WalkSingularities[ { 3, 2, 5, 8, 7, 4, 5, 2, 1 } ][ "SelfTangencies" ],
  { { { 2, 3 }, { 8, 7 } } },
  TestID -> "WalkSingularities-inverse-tangency"
]

(* an isolated double visit is a self-intersection and nothing else *)
VerificationTest[
  WalkSingularities[ { 2, 5, 4, 7, 8, 5, 6 } ],
  <| "SelfIntersections" -> { { 2, 6 } }, "SelfTangencies" -> { }, "Cusps" -> { } |>,
  TestID -> "WalkSingularities-double-visit"
]

(* a triple point is a self-intersection group of three positions *)
VerificationTest[
  WalkSingularities[ { 0, 1, 2, 3, 1, 4, 5, 1, 6 } ],
  <| "SelfIntersections" -> { { 2, 5, 8 } }, "SelfTangencies" -> { }, "Cusps" -> { } |>,
  TestID -> "WalkSingularities-triple-point"
]

(* winding twice round a loop repeats the arc, the intervals overlapping at
   one parameter *)
VerificationTest[
  WalkSingularities[ { 1, 2, 3, 1, 2, 3, 1 } ],
  <| "SelfIntersections" -> { { 1, 4, 7 }, { 2, 5 }, { 3, 6 } },
     "SelfTangencies" -> { { { 1, 4 }, { 4, 7 } } }, "Cusps" -> { } |>,
  TestID -> "WalkSingularities-open-winding"
]

(* an arc traversed three times is one group of three intervals *)
VerificationTest[
  WalkSingularities[ { 0, 1, 2, 5, 1, 2, 6, 1, 2, 7 } ][ "SelfTangencies" ],
  { { { 2, 3 }, { 5, 6 }, { 8, 9 } } },
  TestID -> "WalkSingularities-arc-traversed-thrice"
]

(* bouncing on one edge: three overlapping cusp blocks, and the fold arc
   re-run in the same direction *)
VerificationTest[
  WalkSingularities[ { 1, 2, 1, 2, 1 } ],
  <| "SelfIntersections" -> { { 1, 3, 5 }, { 2, 4 } }, "SelfTangencies" -> { { { 1, 3 }, { 3, 5 } } },
     "Cusps" -> { { 1, 2, 3 }, { 1, 2, 3, 4, 5 }, { 3, 4, 5 } } |>,
  TestID -> "WalkSingularities-bounce"
]

(* the same closed sequence: coincident endpoints as an open list, clean as a loop *)
VerificationTest[
  { WalkSingularities[ { 1, 2, 3, 4, 5, 6, 1 } ][ "SelfIntersections" ],
    WalkSingularities[ closedWalkGraph /@ { { 1, 2, 3, 4, 5, 6, 1 } } ] },
  { { { 1, 7 } }, { <| "SelfIntersections" -> { }, "SelfTangencies" -> { }, "Cusps" -> { } |> } },
  TestID -> "WalkSingularities-loop-closes-endpoint-coincidence"
]

(* wraparound on closed heads: the doubled edge folds at both vertices, each
   block cut where it would wrap onto itself *)
VerificationTest[
  WalkSingularities[ closedWalkGraph /@ { { 1, 2, 1 } } ][[ 1, "Cusps" ]],
  { { 1 }, { 2 } },
  TestID -> "WalkSingularities-loop-wraparound-cusps"
]

(* a doubled interval folds at both ends: two cusp blocks, positions in
   cyclic order *)
VerificationTest[
  WalkSingularities[ closedWalkGraph /@ { { 1, 2, 5, 2, 1 } } ][[ 1 ]],
  <| "SelfIntersections" -> { { 2, 4 } }, "SelfTangencies" -> { }, "Cusps" -> { { 4, 1, 2 }, { 2, 3, 4 } } |>,
  TestID -> "WalkSingularities-doubled-interval-two-cusps"
]

(* a periodic core is the multiply covered loop: one repeated arc tiling the cycle *)
VerificationTest[
  WalkSingularities[ closedWalkGraph /@ { { 1, 2, 3, 1, 2, 3, 1 } } ][[ 1 ]],
  <| "SelfIntersections" -> { { 1, 4 }, { 2, 5 }, { 3, 6 } },
     "SelfTangencies" -> { { { 1, 3 }, { 4, 6 } } }, "Cusps" -> { } |>,
  TestID -> "WalkSingularities-multiply-covered-loop"
]

(* figure-eight based at the cut vertex of the bowtie: one double visit *)
VerificationTest[
  WalkSingularities[ closedWalkGraph /@ { { 1, 2, 3, 4, 5, 3, 1 } } ][[ 1 ]],
  <| "SelfIntersections" -> { { 3, 6 } }, "SelfTangencies" -> { }, "Cusps" -> { } |>,
  TestID -> "WalkSingularities-figure-eight"
]

(* a repeated arc across the wrap of a closed core is read in lifted
   positions, mod m *)
VerificationTest[
  WalkSingularities[ closedWalkGraph /@ { { 3, 7, 1, 2, 3, 4, 5, 6, 2, 3 } } ][[ 1 ]],
  <| "SelfIntersections" -> { { 1, 5 }, { 4, 9 } }, "SelfTangencies" -> { { { 4, 5 }, { 9, 10 } } },
     "Cusps" -> { } |>,
  TestID -> "WalkSingularities-loop-wrapped-arc"
]

(* an arc retraced in reverse on a closed core *)
VerificationTest[
  WalkSingularities[ closedWalkGraph /@ { { 5, 2, 3, 6, 7, 8, 9, 3, 2, 4, 5 } } ][[ 1 ]],
  <| "SelfIntersections" -> { { 2, 9 }, { 3, 8 } }, "SelfTangencies" -> { { { 2, 3 }, { 9, 8 } } },
     "Cusps" -> { } |>,
  TestID -> "WalkSingularities-loop-inverse-tangency"
]

(* ===================== InfraImmersedQ / InfraGenericQ ===================== *)

(* hierarchy walk > immersed > generic on one crossing walk *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ], w = { 2, 5, 4, 7, 8, 5, 6 } },
    { InfraWalkQ[ g, w ], InfraImmersedQ[ g, w ], InfraGenericQ[ g, w ] } ],
  { True, True, True },
  TestID -> "InfraGenericQ-crossing-is-generic"
]

(* a self-tangency is immersed but not generic *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ], w = { 3, 2, 5, 8, 7, 4, 5, 2, 1 } },
    { InfraImmersedQ[ g, w ], InfraGenericQ[ g, w ] } ],
  { True, False },
  TestID -> "InfraGenericQ-tangency-not-generic"
]

(* a cusp breaks immersion *)
VerificationTest[
  InfraImmersedQ[ Graph[ { 1 <-> 2, 1 <-> 3, 1 <-> 4 } ], { 2, 1, 3, 1, 4 } ],
  False,
  TestID -> "InfraImmersedQ-cusp-not-immersed"
]

VerificationTest[
  { InfraImmersedQ[ GridGraph[ { 3, 3 } ], walkGraph /@ { { 1, 2, 5 }, { 1, 2, 1 } } ],
    InfraImmersedQ[ GridGraph[ { 3, 3 } ], walkGraph /@ { { 1, 2, 5 }, { 2, 5, 8 } } ] },
  { False, True },
  TestID -> "InfraImmersedQ-wrapper-AllTrue"
]

(* a self-crossing walk on the square torus grid is generic *)
VerificationTest[
  With[ { g = Graph[ Flatten @ Table[ UndirectedEdge[ { i, j }, # ] & /@
        { { Mod[ i + 1, 4 ], j }, { i, Mod[ j + 1, 4 ] } }, { i, 0, 3 }, { j, 0, 3 } ] ],
      w = { { 1, 2 }, { 2, 2 }, { 2, 1 }, { 3, 1 }, { 3, 2 }, { 2, 2 }, { 2, 3 } } },
    { WalkSingularities[ w ][ "SelfIntersections" ], InfraGenericQ[ g, w ] } ],
  { { { 2, 6 } }, True },
  TestID -> "InfraGenericQ-torus-grid-crossing"
]

(* open endpoint coincidence is an incidence, the closed heads are clean *)
VerificationTest[
  { InfraGenericQ[ CycleGraph[ 6 ], { 1, 2, 3, 4, 5, 6, 1 } ],
    InfraGenericQ[ CycleGraph[ 6 ], closedWalkGraph /@ { { 1, 2, 3, 4, 5, 6, 1 } } ],
    InfraGenericQ[ CycleGraph[ 6 ], closedWalkGraph /@ { { 1, 2, 3, 4, 5, 6 } } ] },
  { False, True, True },
  TestID -> "InfraGenericQ-open-vs-closed-endpoint"
]

(* the closing step of a string must be a graph edge *)
VerificationTest[
  InfraGenericQ[ CycleGraph[ 6 ], closedWalkGraph /@ { { 1, 2, 3 } } ],
  False,
  TestID -> "InfraGenericQ-string-wrap-edge-checked"
]

(* a multiply covered loop is not generic *)
VerificationTest[
  InfraGenericQ[ Graph[ { 1 <-> 2, 2 <-> 3, 3 <-> 1, 3 <-> 4, 4 <-> 5, 5 <-> 3 } ],
    closedWalkGraph /@ { { 1, 2, 3, 1, 2, 3, 1 } } ],
  False,
  TestID -> "InfraGenericQ-multiple-cover-not-generic"
]

(* the default FindInfraWalk class (simple paths) is generic *)
VerificationTest[
  AllTrue[ walkSeqs @ FindInfraWalk[ GridGraph[ { 3, 3 } ], 1, UpTo[ 4 ], All, Properties -> { "Simple" } ],
    w |-> InfraGenericQ[ GridGraph[ { 3, 3 } ], w ] ],
  True,
  TestID -> "InfraGenericQ-simple-paths-are-generic"
]

(* ===================== Singularity classes ===================== *)

(* each singularity class is a rule: "Simple" the census filter DuplicateFreeQ,
   {"Simple", 2} no cusp, and the rarer classes predicates on WalkSingularities,
   each exactly its filter over the bare walk class *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    { bare = walkSeqs @ FindInfraWalk[ g, 1, { 6 }, All ] },
    { class = rule |-> Sort @ walkSeqs @ FindInfraWalk[ g, 1, { 6 }, All, Properties -> { rule } ] },
    { class[ "Simple" ] === Sort @ Select[ bare, DuplicateFreeQ ],
      class[ { "Simple", 2 } ] === Sort @ Select[ bare, WalkSingularities[ # ][ "Cusps" ] === { } & ],
      class[ w |-> Count[ w, Last @ w ] <= 2 ] === Sort @ Select[ bare, Max[ Counts @ # ] <= 2 & ],
      class[ w |-> WalkSingularities[ w ][ "SelfTangencies" ] === { } ] ===
        Sort @ Select[ bare, WalkSingularities[ # ][ "SelfTangencies" ] === { } & ] } ],
  { True, True, True, True },
  TestID -> "singularity-classes-equal-census-filters"
]

(* only a hard bare "Simple" or "Shortest" bounds the class, so only they admit
   an unbounded budget: a windowed rule, a soft rule or a predicate does not *)
VerificationTest[
  With[ { g = PathGraph[ Range[ 4 ] ] },
    { MatchQ[ FindInfraWalk[ g, 1, Infinity, All, Properties -> { w |-> Count[ w, Last @ w ] <= 2 } ], _FindInfraWalk ],
      MatchQ[ FindInfraWalk[ g, 1, Infinity, All, Properties -> { { "Simple", 3 } } ], _FindInfraWalk ],
      MatchQ[ FindInfraWalk[ g, 1, Infinity, All, Properties -> { { "Simple", Infinity, 0.5 } } ], _FindInfraWalk ],
      walkSeqs @ FindInfraWalk[ g, 1, Infinity, All, Properties -> { { "Simple", Infinity } } ],
      walkSeqs @ FindInfraWalk[ g, 1, Infinity, All, Properties -> { "Shortest" } ] } ],
  { True, True, True, { { 1, 2, 3, 4 } }, { { 1, 2, 3, 4 } } },
  TestID -> "only-a-bare-hard-rule-bounds-the-class"
]

(* ===================== InfraWalkCrossingQ ===================== *)

(* straight through the centre of the 3-by-3 grid twice, once along each
   axis: the passes separate each other on the shell {1, 2}, a transverse
   crossing at scale 1; the ambient point, its multiset and the position pair
   all name it *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ], w = { 1, 4, 5, 6, 9, 8, 5, 2, 3 } },
    { InfraWalkCrossingQ[ g, w, 5, 1 ], InfraWalkCrossingQ[ g, w, 5, 1 ],
      InfraWalkCrossingQ[ g, w, { 3, 7 }, 1 ] } ],
  { True, True, True },
  TestID -> "InfraWalkCrossingQ-straight-crossing-is-transverse"
]

(* two corner turns at the centre kiss on the shell: a double visit the
   census cannot tell from a crossing, and the sphere can *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ], w = { 1, 2, 5, 4, 7, 8, 5, 6, 9 } },
    { InfraGenericQ[ g, w ], InfraWalkCrossingQ[ g, w, 5, 1 ] } ],
  { True, False },
  TestID -> "InfraWalkCrossingQ-corner-kiss-is-not-a-crossing"
]

(* a pass has to leave the shell for its radial arc to cut it: a walk ending
   on the sphere resolves nothing *)
VerificationTest[
  InfraWalkCrossingQ[ GridGraph[ { 3, 3 } ], { 4, 5, 6, 9, 8, 5, 2 }, 5, 1 ],
  False,
  TestID -> "InfraWalkCrossingQ-truncated-pass-unresolved"
]

(* a point visited three times is no crossing *)
VerificationTest[
  InfraWalkCrossingQ[ GridGraph[ { 3, 3 } ], { 2, 5, 4, 1, 2, 5, 8, 7, 4, 5, 6 }, 5, 1 ],
  False,
  TestID -> "InfraWalkCrossingQ-triple-point-is-no-crossing"
]

(* the wrapper answers for all its realisations *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    { InfraWalkCrossingQ[ g,
        walkGraph /@ { { 1, 4, 5, 6, 9, 8, 5, 2, 3 }, { 3, 6, 5, 4, 1, 2, 5, 8, 7 } }, 5, 1 ],
      InfraWalkCrossingQ[ g,
        walkGraph /@ { { 1, 4, 5, 6, 9, 8, 5, 2, 3 }, { 1, 2, 5, 4, 7, 8, 5, 6, 9 } }, 5, 1 ] } ],
  { True, False },
  TestID -> "InfraWalkCrossingQ-wrapper-AllTrue"
]

(* on the square torus grid the walk turns W -> S and E -> N at {2, 2}:
   generic, not a crossing; list-valued labels take the position pair *)
VerificationTest[
  With[ { g = Graph[ Flatten @ Table[ UndirectedEdge[ { i, j }, # ] & /@
        { { Mod[ i + 1, 4 ], j }, { i, Mod[ j + 1, 4 ] } }, { i, 0, 3 }, { j, 0, 3 } ] ],
      w = { { 0, 2 }, { 1, 2 }, { 2, 2 }, { 2, 1 }, { 3, 1 }, { 3, 2 }, { 2, 2 }, { 2, 3 }, { 2, 0 } } },
    { InfraGenericQ[ g, w ], InfraWalkCrossingQ[ g, w, { 3, 7 }, 1 ] } ],
  { True, False },
  TestID -> "InfraWalkCrossingQ-torus-corner-kiss"
]

(* on a larger grid the straight crossing holds at scales 1 and 2 and is
   unresolved at scale 3, where the passes never leave the ball; two corner
   turns are no crossing at any scale *)
VerificationTest[
  With[ { g = GridGraph[ { 7, 7 } ],
      straight = { 4, 11, 18, 25, 32, 39, 46, 47, 48, 41, 34, 27, 26, 25, 24, 23, 22 },
      corners = { 4, 11, 18, 25, 24, 23, 22, 29, 36, 43, 44, 45, 46, 39, 32, 25, 26, 27, 28 } },
    { InfraWalkCrossingQ[ g, straight, 25, # ] & /@ { 1, 2, 3 },
      InfraWalkCrossingQ[ g, corners, 25, # ] & /@ { 1, 2 } } ],
  { { True, True, False }, { False, False } },
  TestID -> "InfraWalkCrossingQ-grid-scales"
]

(* in three dimensions the shell minus two radial cuts stays connected: no
   double point is a crossing *)
VerificationTest[
  InfraWalkCrossingQ[ GridGraph[ { 5, 5, 5 } ],
    { 61, 62, 63, 64, 65, 90, 115, 114, 113, 88, 63, 38, 13 }, 63, 1 ],
  False,
  TestID -> "InfraWalkCrossingQ-three-dimensions-no-crossing"
]

(* on a triangulated patch, where the exact sphere is itself a cycle, the
   straight crossing and a diagonal one are transverse at scales 1 and 2 *)
VerificationTest[
  With[ { g = EdgeAdd[ GridGraph[ { 7, 7 } ],
        UndirectedEdge[ #, # + 8 ] & /@ Select[ Range[ 42 ], Mod[ #, 7 ] != 0 & ] ],
      straight = { 4, 11, 18, 25, 32, 39, 46, 47, 48, 41, 34, 27, 26, 25, 24, 23, 22 },
      diagonal = { 4, 11, 18, 25, 32, 39, 46, 47, 48, 41, 33, 25, 17, 9, 1 } },
    { InfraWalkCrossingQ[ g, straight, 25, # ] & /@ { 1, 2 },
      InfraWalkCrossingQ[ g, diagonal, 25, # ] & /@ { 1, 2 } } ],
  { { True, True }, { True, True } },
  TestID -> "InfraWalkCrossingQ-triangulated-patch"
]

(* a figure eight through the centre of the 5-by-5 grid, both passes
   straight: a crossing on the closed heads too *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    { InfraWalkCrossingQ[ g, closedWalkGraph /@ { { 13, 14, 19, 18, 13, 8, 7, 12, 13 } }, 13, 1 ],
      InfraWalkCrossingQ[ g, closedWalkGraph /@ { { 13, 14, 19, 18, 13, 8, 7, 12 } }, 13, 1 ] } ],
  { True, True },
  TestID -> "InfraWalkCrossingQ-figure-eight-loop"
]

(* InfraGeodesic head: the representatives are the simple geodesics grown on
   both sides of the germ, returned as vertex lists *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    Sort @ FindInfraRepresentative[ g, InfraGeodesic[ { 6, 7 }, Infinity ], All ] ===
      Sort @ walkSeqs @ FindInfraGeodesic[ g, { 6, 7 }, Infinity, Infinity, All,
        Properties -> { "Simple" }, "Direction" -> "BothSides" ] ],
  True,
  TestID -> "InfraGeodesic-representatives-are-FindInfraGeodesic-BothSides"
]

(* a one-vertex germ is grown on both sides too: through the centre of the
   5-by-5 grid run 144 maximal geodesics, against 24 grown forward from it *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    { Length @ FindInfraRepresentative[ g, InfraGeodesic[ { 13 }, Infinity ], All ],
      Length @ FindInfraGeodesic[ g, 13, Infinity, Infinity, All ] } ],
  { 144, 24 },
  TestID -> "InfraGeodesic-one-vertex-germ-runs-both-ways"
]

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    { Length @ FindInfraRepresentative[ g, InfraGeodesic[ { 6, 7 }, Infinity ], 2 ],
      MatchQ[ FindInfraRepresentative[ g, InfraGeodesic[ { 6, 7 }, Infinity ] ], { __Integer } ],
      MemberQ[ FindInfraRepresentative[ g, InfraGeodesic[ { 6, 7 }, Infinity ], All ],
        FindInfraRepresentative[ g, InfraGeodesic[ { 6, 7 }, Infinity ], 1, "RandomChoice" ][[ 1 ]] ] } ],
  { 2, True, True },
  TestID -> "InfraGeodesic-count-and-random-choice"
]

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    { members = FindInfraRepresentative[ g, InfraGeodesic[ { 6, 7 }, Infinity ], All ] },
    InfraDensity[ g, members ] === KeySort @ Counts @ Catenate @ members ],
  True,
  TestID -> "InfraGeodesic-members-InfraDensity"
]

(* the representative of a germ at a finite scale is a simple geodesic at that scale: without the
   simple class the budget Infinity would leave the class unbounded and the call unevaluated *)
VerificationTest[
  With[ { g = GridGraph[ { 6, 6 } ] },
    { one = FindInfraRepresentative[ g, InfraGeodesic[ { 1 }, 2 ] ],
      some = FindInfraRepresentative[ g, InfraGeodesic[ { 1, 2 }, 3 ], 3 ] },
    { InfraGeodesicQ[ g, one, 2 ] && DuplicateFreeQ[ one ],
      Length[ some ] === 3 && AllTrue[ some, InfraGeodesicQ[ g, #, 3 ] && DuplicateFreeQ[ # ] && SequenceCount[ #, { 1, 2 } ] === 1 & ] } ],
  { True, True },
  TestID -> "InfraGeodesic-representative-at-finite-scale-is-simple"
]

(* ===================== The window graph of InfraGeodesic ===================== *)

(* the vertex sequences of the walks of k edges from the germ's window: the germ, then the last vertex of each window *)
windowWalks[ g_Graph, germ_List, scale_, k_Integer ] :=
  With[ { wg = InfraMeasurement[ g, InfraGeodesic[ germ, scale ], "Graph" ] },
    { out = GroupBy[ EdgeList @ wg, First -> Last ] },
    Sort @ Map[
      walk |-> Join[ germ, If[ scale === Infinity, Rest @ walk, Last /@ Rest @ walk ] ],
      Nest[ walks |-> Catenate[ ( walk |-> ( Append[ walk, # ] & ) /@ Lookup[ out, Key @ Last @ walk, { } ] ) /@ walks ],
        { { If[ scale === Infinity, Last @ germ, Take[ germ, -Min[ scale, Length @ germ ] ] ] } }, k ] ] ]

(* the walks of the window graph from the germ's window are exactly the scale-r geodesics extending the germ forward, revisits included *)
VerificationTest[
  With[ { g = GridGraph[ { 9, 9 } ] },
    Table[
      windowWalks[ g, germ, scale, 5 ] ===
        Sort[ Last /@ VertexList[ # ] & /@ FindInfraGeodesic[ g, germ, scale, { 5 }, All, Properties -> { }, "Direction" -> "Forward" ] ],
      { germ, { { 41 }, { 41, 42, 51 } } }, { scale, { 2, 3, Infinity } } ] ],
  { { True, True, True }, { True, True, True } },
  TestID -> "InfraGeodesic-window-graph-walks-are-the-finder-geodesics"
]

(* the window graph has no budget, so its cycles are the closed geodesics: at scale 2 the squares of the grid, at scale 1 the grid itself
   with both orientations of every edge *)
VerificationTest[
  With[ { g = GridGraph[ { 9, 9 } ] },
    { AcyclicGraphQ @ InfraMeasurement[ g, InfraGeodesic[ { 41, 42 }, 2 ], "Graph" ],
      { VertexCount @ #, EdgeCount @ # } & @ InfraMeasurement[ g, InfraGeodesic[ { 41, 42 }, 1 ], "Graph" ] } ],
  { False, { 81, 288 } },
  TestID -> "InfraGeodesic-window-graph-has-cycles"
]

(* at scale Infinity the window is the last vertex: from a vertex germ the graph is the pencil's ray DAG, from a longer germ the part of
   the ray DAG of its ends reachable from its last vertex *)
VerificationTest[
  With[ { g = GridGraph[ { 9, 9 } ],
          sameQ = { a, b } |-> Sort @ VertexList @ a === Sort @ VertexList @ b && Sort @ EdgeList @ a === Sort @ EdgeList @ b },
    { ray = InfraMeasurement[ g, InfraRay[ 41, 51 ], "Graph" ] },
    { sameQ[ InfraMeasurement[ g, InfraGeodesic[ { 41 }, Infinity ], "Graph" ], InfraMeasurement[ g, InfraRay[ 41, 41 ], "Graph" ] ],
      sameQ[ InfraMeasurement[ g, InfraGeodesic[ { 41, 42, 51 }, Infinity ], "Graph" ], Subgraph[ ray, VertexOutComponent[ ray, 51 ] ] ] } ],
  { True, True },
  TestID -> "InfraGeodesic-window-graph-at-Infinity-is-the-ray-graph"
]

(* a germ that is no geodesic at the scale has no window graph *)
VerificationTest[
  With[ { g = GridGraph[ { 9, 9 } ] },
    { MatchQ[ InfraMeasurement[ g, InfraGeodesic[ { 41, 42, 41 }, 2 ], "Graph" ], _InfraMeasurement ],
      MatchQ[ InfraMeasurement[ g, InfraGeodesic[ { 41, 43 }, 2 ], "Graph" ], _InfraMeasurement ] } ],
  { True, True },
  TestID -> "InfraGeodesic-window-graph-non-geodesic-germ-unevaluated"
]


(* ===== Refused calls stay unevaluated ===== *)

(* the cusp-free class {"Simple", 2} is infinite -- winding a long cycle never cusps -- so an unbounded kspec is a non-match *)
VerificationTest[
  MatchQ[ FindInfraWalk[ GridGraph[ { 4, 4 } ], 1, Infinity, 1, Properties -> { { "Simple", 2 } } ], _FindInfraWalk ],
  True,
  TestID -> "FindInfraWalk-pointed-unbounded-unevaluated"
]

VerificationTest[
  MatchQ[ FindInfraWalk[ GridGraph[ { 3, 3 } ], { 1, 2 }, Infinity, 1, Properties -> { { "Simple", 2 } },
      "Direction" -> "BothSides" ], _FindInfraWalk ],
  True,
  TestID -> "FindInfraWalk-walk-germ-unbounded-unevaluated"
]

(* the argument after the germ is the scale: at a scale naming a vertex, the
   class "Shortest" at a finite scale is unbounded, so kspec Infinity is
   refused -- there is no two-point reading *)
VerificationTest[
  MatchQ[ FindInfraGeodesic[ GridGraph[ { 9, 9 } ], 41, 61, Infinity, All ], _FindInfraGeodesic ],
  True,
  TestID -> "FindInfraGeodesic-vertex-after-the-germ-is-a-scale"
]

(* "Shortest" at a finite scale does not bound the class *)
VerificationTest[
  MatchQ[ FindInfraGeodesic[ CycleGraph[ 6 ], { 1 }, 2 ], _FindInfraGeodesic ],
  True,
  TestID -> "FindInfraGeodesic-unbounded-finite-scale-unevaluated"
]

(* under "BothSides" the condition reads the whole walk, both tips: on the
   middle row of the 7-by-7 grid the walk through {24, 25} stops at whichever
   tip arrives first, at 22 on the left or at 28 on the right *)
VerificationTest[
  With[ { g = GridGraph[ { 7, 7 } ] },
    { ws = walkSeqs @ FindInfraWalk[ g, { 24, 25 }, Infinity, All, Properties -> { "Shortest" }, "Direction" -> "BothSides",
        "StoppingCondition" -> ( First[ # ] === 22 || Last[ # ] === 28 & ) ] },
    { ws =!= { },
      AllTrue[ ws, Count[ Most @ Rest @ #, 22 | 28 ] == 0 & ],
      MemberQ[ ws, { 22, 23, 24, 25, 26, 27 } ], MemberQ[ ws, { 23, 24, 25, 26, 27, 28 } ] } ],
  { True, True, True, True },
  TestID -> "FindInfraWalk-BothSides-condition-reads-both-tips"
]

(* ===================== Rules: a window and a weight ===================== *)

(* the blog's controlled randomness, one line per walk: nine steps from the
   centre of the square mesh, the straightness at window 5 weighted by p; at
   p = 1 the rule is soft and indifferent, so Automatic draws the uniform walk,
   not the canonical one, which goes back and forth on one edge *)
VerificationTest[
  With[ { g = InfraSubstrate[ "SquareMeshGraph", "Medium", "KeepCoordinates" -> True ] },
    { c = ( SeedRandom[ 1 ]; RandomInfraPoint[ g, GraphCenter[ g ] ] ) },
    { ws = Table[ BlockRandom[ FindInfraWalk[ g, c, UpTo[ 9 ], Properties -> { { "Shortest", 5, p } } ], RandomSeeding -> 3 ],
        { p, { 1, 0.3, 0.01 } } ] },
    { AllTrue[ ws, GraphQ ], EdgeCount /@ ws, AllTrue[ walkSeq /@ ws, First[ # ] === c && InfraWalkQ[ g, # ] & ],
      Length @ DeleteDuplicates @ walkSeq @ First @ ws > 2 } ],
  { True, { 9, 9, 9 }, True, True },
  TestID -> "FindInfraWalk-soft-shortest-one-line-per-walk"
]

(* the walk that rarely crosses itself, every weight soft: at p = 0.01 a
   return is rare, at p = 1 every walk weighs alike *)
VerificationTest[
  With[ { g = InfraSubstrate[ "SquareMeshGraph", "Medium", "KeepCoordinates" -> True ] },
    { c = ( SeedRandom[ 1 ]; RandomInfraPoint[ g, GraphCenter[ g ] ] ) },
    { ws = Table[ BlockRandom[ walkSeq @ FindInfraWalk[ g, c, UpTo[ 12 ], Properties -> { { "Simple", Infinity, p } },
        "NextVertexFunction" -> RandomChoice ], RandomSeeding -> 3 ], { p, { 0.01, 0.1, 1 } } ] },
    { Length[ # ] - Length[ DeleteDuplicates @ # ] & /@ ws, AllTrue[ ws, InfraWalkQ[ g, # ] & ] } ],
  { { 0, 0, 3 }, True },
  TestID -> "FindInfraWalk-soft-simple-rarely-crosses"
]

(* a rule is any energy of the window: the walk pulled toward q by the weight
   p^d(tip, q) at window 1 ends nearer q than the uniform random walk, in the
   mean over forty seeds *)
VerificationTest[
  With[ { g = GridGraph[ { 20, 20 } ], start = 1, q = 400 },
    { endDistance = rules |-> Mean @ Table[
        BlockRandom[ GraphDistance[ g, Last @ walkSeq @ FindInfraWalk[ g, start, UpTo[ 20 ], Properties -> rules,
          "NextVertexFunction" -> RandomChoice ], q ], RandomSeeding -> seed ], { seed, 40 } ] },
    endDistance[ { { w |-> GraphDistance[ g, Last @ w, q ], 1, 0.3 } } ] < endDistance[ { } ] ],
  True,
  TestID -> "FindInfraWalk-energy-function-pulls-toward-a-point"
]

(* a predicate is the 0/1 energy: the predicate at window 2 gives the walks
   2.0.2 gave with its global window at 2 *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    Sort @ walkSeqs @ FindInfraWalk[ g, 13, { 4 }, All,
      Properties -> { "Simple", { w |-> VertexDegree[ g, First @ w ] + VertexDegree[ g, Last @ w ] >= 7, 2 } } ] ],
  { { 13, 8, 3, 2, 7 }, { 13, 8, 3, 4, 9 }, { 13, 8, 7, 2, 3 }, { 13, 8, 7, 6, 11 }, { 13, 8, 7, 12, 11 }, { 13, 8, 7, 12, 17 },
    { 13, 8, 9, 4, 3 }, { 13, 8, 9, 10, 15 }, { 13, 8, 9, 14, 15 }, { 13, 8, 9, 14, 19 }, { 13, 12, 7, 2, 3 }, { 13, 12, 7, 6, 11 },
    { 13, 12, 7, 8, 3 }, { 13, 12, 7, 8, 9 }, { 13, 12, 11, 6, 7 }, { 13, 12, 11, 16, 17 }, { 13, 12, 17, 16, 11 }, { 13, 12, 17, 18, 19 },
    { 13, 12, 17, 18, 23 }, { 13, 12, 17, 22, 23 }, { 13, 14, 9, 4, 3 }, { 13, 14, 9, 8, 3 }, { 13, 14, 9, 8, 7 }, { 13, 14, 9, 10, 15 },
    { 13, 14, 15, 10, 9 }, { 13, 14, 15, 20, 19 }, { 13, 14, 19, 18, 17 }, { 13, 14, 19, 18, 23 }, { 13, 14, 19, 20, 15 },
    { 13, 14, 19, 24, 23 }, { 13, 18, 17, 12, 7 }, { 13, 18, 17, 12, 11 }, { 13, 18, 17, 16, 11 }, { 13, 18, 17, 22, 23 },
    { 13, 18, 19, 14, 9 }, { 13, 18, 19, 14, 15 }, { 13, 18, 19, 20, 15 }, { 13, 18, 19, 24, 23 }, { 13, 18, 23, 22, 17 },
    { 13, 18, 23, 24, 19 } },
  TestID -> "FindInfraWalk-windowed-predicate-is-the-2.0.2-class"
]

(* no combination of rule and order is refused: Identity and a function order
   ignore the weights, so a soft rule under them gives the walks of the hard
   rules alone; and the soft "Stretched" weighs as the soft "Shortest", the two
   energies differing by a constant on each step *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    { soft = { order, rules } |-> FindInfraWalk[ g, 6, { 4 }, 5, Properties -> rules, "NextVertexFunction" -> order ] },
    { soft[ Identity, { "Simple", { "Shortest", 3, 0.3 } } ] === soft[ Identity, { "Simple" } ],
      soft[ Reverse, { "Simple", { "Shortest", 3, 0.3 } } ] === soft[ Reverse, { "Simple" } ],
      Table[ BlockRandom[ soft[ order, { "Simple", { "Stretched", 3, 0.3 } } ], RandomSeeding -> seed ] ===
          BlockRandom[ soft[ order, { "Simple", { "Shortest", 3, 0.3 } } ], RandomSeeding -> seed ],
        { order, { Automatic, RandomSample, RandomChoice } }, { seed, 3 } ] } ],
  { True, True, ConstantArray[ True, { 3, 3 } ] },
  TestID -> "FindInfraWalk-no-rule-and-order-is-refused"
]

(* the removed spellings are non-matches: the global window, the old rule
   names, the automatic direction and the integer and delayed conditions *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    MatchQ[ #, _FindInfraWalk ] & /@ {
      FindInfraWalk[ g, 1, { 3 }, "InfraScale" -> 2 ],
      FindInfraWalk[ g, 1, { 3 }, Properties -> { "Minimizing" } ],
      FindInfraWalk[ g, 1, { 3 }, Properties -> { "Immersed" } ],
      FindInfraWalk[ g, 1, { 3 }, Properties -> { "Generic" } ],
      FindInfraWalk[ g, 1, { 3 }, Properties -> { "Exclude" -> "Cusps" } ],
      FindInfraWalk[ g, { 1, 2 }, { 3 }, "Direction" -> Automatic ],
      FindInfraWalk[ g, 1, { 3 }, "StoppingCondition" -> 1 ],
      FindInfraWalk[ g, 1, { 3 }, "StoppingCondition" -> { Last[ # ] === 4 &, "Delay" -> 1 } ] } ],
  { True, True, True, True, True, True, True, True },
  TestID -> "FindInfraWalk-removed-spellings-unevaluated"
]

(* "Stretched" keeps the candidates farthest from the window start among those
   the hard rules before it left: with All it is the class the order
   MaximalBy[w |-> d(First @ w, Last @ w)] gave on 2.0.2 at the window 3,
   246 of the 2730 simple walks of five edges from the centre of the
   triangular tiling *)
VerificationTest[
  With[ { t = InfraSubstrate[ "TriangularTilingGraph", "Small" ] },
    { c = First @ GraphCenter @ t },
    { stretched = Sort @ walkSeqs @ FindInfraWalk[ t, c, { 5 }, All, Properties -> { "Simple", { "Stretched", 3 } } ],
      ordered = Sort @ walkSeqs @ FindInfraWalk[ t, c, { 5 }, All, Properties -> { "Simple" },
        "NextVertexFunction" -> { MaximalBy[ w |-> GraphDistance[ t, First @ w, Last @ w ] ], 3 } ] },
    { Length @ stretched, stretched === ordered, Take[ stretched, 3 ] } ],
  { 246, True, { { 2, 1, 6, 17, 34, 57 }, { 2, 1, 6, 17, 34, 58 }, { 2, 1, 6, 17, 35, 47 } } },
  TestID -> "FindInfraWalk-Stretched-is-the-farthest-order"
]

(* "Simple" at a window forbids a return only within it: round a hexagon of
   the hexagonal tiling the walk comes back after six edges, which window 3 and
   window 5 admit and window 6 and the bare rule refuse *)
VerificationTest[
  With[ { h = InfraSubstrate[ "HexagonalTilingGraph", "Small" ] },
    { c = First @ GraphCenter @ h },
    { closed = rules |-> Count[ walkSeqs @ FindInfraWalk[ h, c, { 6 }, All, Properties -> rules ], w_ /; Last @ w === c ] },
    closed /@ { { { "Simple", 3 } }, { { "Simple", 5 } }, { { "Simple", 6 } }, { "Simple" } } ],
  { 6, 6, 0, 0 },
  TestID -> "FindInfraWalk-windowed-Simple-admits-the-hexagon"
]

(* a soft rule never changes the class, only its order: under All every
   order gives the class of the hard rules alone *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    { class = Sort @ walkSeqs @ FindInfraWalk[ g, 6, { 4 }, All, Properties -> { "Simple" }, "NextVertexFunction" -> Identity ] },
    BlockRandom[
      Sort @ walkSeqs @ FindInfraWalk[ g, 6, { 4 }, All, Properties -> { "Simple", { "Shortest", 3, 0.3 } }, "NextVertexFunction" -> # ] === class,
      RandomSeeding -> 5 ] & /@ { Identity, Automatic, RandomSample } ],
  { True, True, True },
  TestID -> "FindInfraWalk-soft-rule-keeps-the-class"
]

(* p = 1 is soft and weighs every candidate alike: under a seed it is the plain
   RandomSample, written or as Automatic; and the weighted permutation still
   backtracks, so an exact budget finds a walk wherever the canonical order does *)
VerificationTest[
  With[ { g = GridGraph[ { 12, 12 } ] },
    { BlockRandom[ FindInfraWalk[ g, 66, UpTo[ 8 ], 3, Properties -> { "Simple", { "Shortest", 3, 1 } }, "NextVertexFunction" -> RandomSample ],
        RandomSeeding -> 4 ] ===
        BlockRandom[ FindInfraWalk[ g, 66, UpTo[ 8 ], 3, Properties -> { "Simple", { "Shortest", 3, 1 } } ], RandomSeeding -> 4 ] ===
        BlockRandom[ FindInfraWalk[ g, 66, UpTo[ 8 ], 3, Properties -> { "Simple" }, "NextVertexFunction" -> RandomSample ], RandomSeeding -> 4 ],
      AllTrue[ Tuples[ { { 1, 66, 144 }, { 10, 40 } } ], Apply[ { v, k } |->
        GraphQ @ FindInfraWalk[ g, v, { k }, Properties -> { "Simple" } ] ===
          GraphQ @ BlockRandom[ FindInfraWalk[ g, v, { k }, Properties -> { "Simple", { "Shortest", 4, 0.3 } } ], RandomSeeding -> 6 ] ] ] } ],
  { True, True },
  TestID -> "FindInfraWalk-weight-one-is-uniform-and-exact-budgets-are-met"
]

(* the physicist's walk on the 30-by-30 grid, forty seeds, thirty steps: the
   end-to-end distance per edge falls as the straightness at window 8 is
   weighted more weakly, and the self-intersections rise as they cost less *)
VerificationTest[
  With[ { g = GridGraph[ { 30, 30 } ], start = 435 },
    { mean = { rules, f } |-> Mean @ Table[
        BlockRandom[ f @ walkSeq @ FindInfraWalk[ g, start, UpTo[ 30 ], Properties -> rules, "NextVertexFunction" -> RandomChoice ],
          RandomSeeding -> seed ], { seed, 40 } ],
      stretch = w |-> N[ GraphDistance[ g, First @ w, Last @ w ] / ( Length[ w ] - 1 ) ],
      crossings = w |-> Length[ w ] - Length[ DeleteDuplicates @ w ] },
    { Greater @@ ( mean[ { { "Shortest", 8, # } }, stretch ] & /@ { 0.01, 0.3, 1 } ),
      Less @@ ( mean[ { { "Simple", Infinity, # } }, crossings ] & /@ { 0, 0.1, 1 } ) } ],
  { True, True },
  TestID -> "FindInfraWalk-soft-rules-interpolate"
]

(* "Forward" is the default for every germ: a two-vertex germ grows after its
   last vertex only; "Backward" grows before its first *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    { fwd = walkSeqs @ FindInfraWalk[ g, { 1, 2 }, UpTo[ 2 ], All, Properties -> { "Simple" } ],
      bwd = walkSeqs @ FindInfraWalk[ g, { 1, 2 }, UpTo[ 2 ], All, Properties -> { "Simple" }, "Direction" -> "Backward" ] },
    { AllTrue[ fwd, Take[ #, 2 ] === { 1, 2 } & ], AllTrue[ bwd, Take[ #, -2 ] === { 1, 2 } & ],
      Sort @ bwd === Sort[ Reverse /@ walkSeqs @ FindInfraWalk[ g, { 2, 1 }, UpTo[ 2 ], All, Properties -> { "Simple" } ] ] } ],
  { True, True, True },
  TestID -> "FindInfraWalk-Forward-default-for-every-germ"
]

(* the straightening tutorial's beams on the square tiling: FindInfraGeodesic
   with All returns the class 2.0.2 returned, at every scale (count and hash
   of the sorted vertex sequences) *)
VerificationTest[
  With[ { g = ( SeedRandom[ 2 ]; InfraSubstrate[ "SquareTilingGraph", "Large", "KeepCoordinates" -> True ] ) },
    { c = First @ GraphCenter @ g },
    { germ = First @ FindInfraRepresentative[ g, InfraSegment[ First @ FindInfraShell[ g, c, 8 ], c ], 1 ] },
    { walks = Sort @ walkSeqs @ FindInfraGeodesic[ g, germ, 2, { 10 }, All ] },
    { Length @ walks, Hash @ walks } ],
  { 59049, 4937401386186909691 },
  TestID -> "FindInfraGeodesic-tutorial-beam-scale-2"
]

VerificationTest[
  With[ { g = ( SeedRandom[ 2 ]; InfraSubstrate[ "SquareTilingGraph", "Large", "KeepCoordinates" -> True ] ) },
    { c = First @ GraphCenter @ g },
    { germ = First @ FindInfraRepresentative[ g, InfraSegment[ First @ FindInfraShell[ g, c, 8 ], c ], 1 ] },
    { walks = Sort @ walkSeqs @ FindInfraGeodesic[ g, germ, 3, { 10 }, All ] },
    { Length @ walks, Hash @ walks } ],
  { 5741, 1211033947011603389 },
  TestID -> "FindInfraGeodesic-tutorial-beam-scale-3"
]

VerificationTest[
  With[ { g = ( SeedRandom[ 2 ]; InfraSubstrate[ "SquareTilingGraph", "Large", "KeepCoordinates" -> True ] ) },
    { c = First @ GraphCenter @ g },
    { germ = First @ FindInfraRepresentative[ g, InfraSegment[ First @ FindInfraShell[ g, c, 8 ], c ], 1 ] },
    { walks = Sort @ walkSeqs @ FindInfraGeodesic[ g, germ, 4, { 10 }, All ] },
    { Length @ walks, Hash @ walks } ],
  { 2296, 7425623505775655544 },
  TestID -> "FindInfraGeodesic-tutorial-beam-scale-4"
]

VerificationTest[
  With[ { g = ( SeedRandom[ 2 ]; InfraSubstrate[ "SquareTilingGraph", "Large", "KeepCoordinates" -> True ] ) },
    { c = First @ GraphCenter @ g },
    { germ = First @ FindInfraRepresentative[ g, InfraSegment[ First @ FindInfraShell[ g, c, 8 ], c ], 1 ] },
    { walks = Sort @ walkSeqs @ FindInfraGeodesic[ g, germ, 5, { 10 }, All ] },
    { Length @ walks, Hash @ walks } ],
  { 1496, 1532773979078602271 },
  TestID -> "FindInfraGeodesic-tutorial-beam-scale-5"
]

VerificationTest[
  With[ { g = ( SeedRandom[ 2 ]; InfraSubstrate[ "SquareTilingGraph", "Large", "KeepCoordinates" -> True ] ) },
    { c = First @ GraphCenter @ g },
    { germ = First @ FindInfraRepresentative[ g, InfraSegment[ First @ FindInfraShell[ g, c, 8 ], c ], 1 ] },
    { walks = Sort @ walkSeqs @ FindInfraGeodesic[ g, germ, Infinity, { 10 }, All ] },
    { Length @ walks, Hash @ walks } ],
  { 1024, 2474424299912191782 },
  TestID -> "FindInfraGeodesic-tutorial-beam-scale-Infinity"
]

EndTestSection[]
