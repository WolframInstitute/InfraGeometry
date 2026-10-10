BeginTestSection["InfraScene"]

geodesicGraph      = WolframInstitute`InfraGeometry`PackageScope`geodesicGraph;
geodesicCycleGraph = WolframInstitute`InfraGeometry`PackageScope`geodesicCycleGraph;
infraSpread        = WolframInstitute`InfraGeometry`PackageScope`infraSpread;

(* ===== Scene Construction ===== *)

VerificationTest[
  Head @ InfraScene[{p, q}, {p == InfraPoint[], q == InfraPoint[]}],
  InfraScene,
  TestID -> "InfraScene-construction"
]

(* ===== RandomInfraInstance ===== *)

VerificationTest[
  With[{
    scene = InfraScene[{p}, {p == InfraPoint[]}],
    g = PathGraph[Range[5]]
  },
    MatchQ[RandomInfraInstance[ scene, g, All ], {__InfraSceneInstance}]
  ],
  True,
  TestID -> "RandomInfraInstance-returns-list-of-instances"
]

VerificationTest[
  With[{
    scene = InfraScene[{p}, {p == InfraPoint[]}],
    g = PathGraph[Range[5]]
  },
    Length[RandomInfraInstance[ scene, g, All ]] >= 1
  ],
  True,
  TestID -> "RandomInfraInstance-nonempty"
]

VerificationTest[
  With[{
    scene = InfraScene[{p, q, s}, {
      p == InfraPoint[],
      q == InfraPoint[],
      s == InfraSegment[p, q]
    }],
    g = PathGraph[Range[5]]
  },
    AllTrue[RandomInfraInstance[ scene, g, All ], MatchQ[InfraSceneInstance[_Association]]]
  ],
  True,
  TestID -> "RandomInfraInstance-instances-wrap-associations"
]

VerificationTest[
  With[{
    scene = InfraScene[{p}, {p == InfraPoint[]}],
    g = PathGraph[Range[5]]
  },
    Length[RandomInfraInstance[ scene, g, All ]] == 5
  ],
  True,
  TestID -> "RandomInfraInstance-no-pruning-all-branches"
]

VerificationTest[
  With[{
    scene = InfraScene[{p}, {p == InfraPoint[]}],
    g = PathGraph[Range[5]]
  },
    Length[RandomInfraInstance[ scene, g, All, "NextVertexFunction" -> (Take[#, UpTo[1]] &) ]] >= 1
  ],
  True,
  TestID -> "RandomInfraInstance-pruning-at-least-one-survives"
]

(* ===== Fixed Vertex ===== *)

VerificationTest[
  With[{
    scene = InfraScene[{p}, {p == InfraPoint[3]}],
    g = PathGraph[Range[5]]
  },
    With[{instances = RandomInfraInstance[ scene, g, All ]},
      Length[instances] == 1 && instances[[1]][[1]][p] == 3
    ]
  ],
  True,
  TestID -> "RandomInfraInstance-fixed-vertex"
]

(* ===== InfraDistance Assertion ===== *)

VerificationTest[
  With[{
    scene = InfraScene[{p, q, s}, {
      p == InfraPoint[],
      q == InfraPoint[],
      s == InfraSegment[p, q],
      InfraDistance[p, q] >= 3
    }],
    g = PathGraph[Range[5]]
  },
    AllTrue[RandomInfraInstance[ scene, g, All ],
      inst |-> GraphDistance[g, inst[[1]][p], inst[[1]][q]] >= 3]
  ],
  True,
  TestID -> "RandomInfraInstance-InfraDistance-assertion"
]

(* ===== InfraSegmentQ Assertion ===== *)

VerificationTest[
  With[{
    scene = InfraScene[{p, q, s}, {
      p == InfraPoint[],
      q == InfraPoint[],
      s == InfraSegment[p, q],
      InfraSegmentQ[s]
    }],
    g = PathGraph[Range[5]]
  },
    AllTrue[RandomInfraInstance[ scene, g, All ],
      inst |-> InfraSegmentQ[g, inst[[1]][s]]]
  ],
  True,
  TestID -> "RandomInfraInstance-InfraSegmentQ-assertion"
]

(* ===== InfraShell with FindInfraShell ===== *)

VerificationTest[
  With[{
    scene = InfraScene[{p, c}, {
      p == InfraPoint[1],
      c == InfraShell[p, 2]
    }],
    g = PetersenGraph[]
  },
    With[{instances = RandomInfraInstance[ scene, g, All ]},
      Length[instances] >= 1 &&
      AllTrue[instances, inst |-> ListQ[inst[[1]][c]] && Length[inst[[1]][c]] >= 3]
    ]
  ],
  True,
  TestID -> "RandomInfraInstance-InfraShell-FindInfraShell"
]

(* ===== InfraPlane with FindInfraBisectingHyperplane ===== *)

VerificationTest[
  With[{
    scene = InfraScene[{a, b, h}, {
      a == InfraPoint[1],
      b == InfraPoint[5],
      h == InfraPlane[a, b]
    }],
    g = PathGraph[Range[5]]
  },
    With[{instances = RandomInfraInstance[ scene, g, All ]},
      Length[instances] >= 1 &&
      AllTrue[instances, inst |-> ListQ[inst[[1]][h]] && MemberQ[inst[[1]][h], 3]]
    ]
  ],
  True,
  TestID -> "RandomInfraInstance-InfraPlane-FindInfraBisectingHyperplane"
]

(* InfraPlane[p1, p2, {lo, hi}] threads the window through to FindInfraBisectingHyperplane.
   On PathGraph[6], 1 to 6 has odd distance; the strict {0, 0} bisector is empty
   so the no-window form yields no instances, while {-1, 1} recovers {3} and {4}. *)
VerificationTest[
  With[{
    scene = InfraScene[{a, b, h}, {
      a == InfraPoint[1],
      b == InfraPoint[6],
      h == InfraPlane[a, b, {-1, 1}]
    }],
    g = PathGraph[Range[6]]
  },
    Sort @ DeleteDuplicates[#[[1]][h] & /@ RandomInfraInstance[ scene, g, All ]]
  ],
  {{3}, {4}},
  TestID -> "RandomInfraInstance-InfraPlane-window"
]

(* ===== InfraCircle ===== *)

VerificationTest[
  With[{
    scene = InfraScene[{p, c}, {
      p == InfraPoint[6],
      c == InfraCircle[p, {1, 2}]
    }],
    g = GridGraph[{4, 4}]
  },
    With[{instances = RandomInfraInstance[ scene, g, All ]},
      Length[instances] >= 1 &&
      AllTrue[instances, inst |-> ListQ[inst[[1]][c]] && Length[inst[[1]][c]] >= 3]
    ]
  ],
  True,
  TestID -> "RandomInfraInstance-InfraCircle"
]

(* ===== the closed polyline: the polygon token ===== *)

(* the triangle on three bound corners is the closed polyline through them, one branch per
   member: the diagonal side of the 3x3 grid gives six *)
VerificationTest[
  With[{scene = InfraScene[{a, b, c, t}, {t == InfraSegment[a, b, c, a]}], g = GridGraph[{3, 3}]},
    {instances = RandomInfraInstance[ scene, g, All, <|a -> 1, b -> 3, c -> 9|> ]},
    {Length[instances], AllTrue[instances, inst |-> InfraMemberQ[g, InfraSegment[1, 3, 9, 1], inst[[1]][t]]]}],
  {6, True},
  TestID -> "RandomInfraInstance-closed-polyline-is-the-polygon-token"
]

(* ===== InfraStep ===== *)

VerificationTest[
  With[{
    scene = InfraScene[{a, b, s}, {
      InfraStep[{a == InfraPoint[], b == InfraPoint[]}, "pick points"],
      InfraStep[{s == InfraSegment[a, b]}, "draw segment"]
    }],
    g = PathGraph[Range[5]]
  },
    scene["ManualSteps"] === True &&
    scene["Steps"] === {{a, b}, {s}} &&
    scene["Labels"] === {"pick points", "draw segment"}
  ],
  True,
  TestID -> "InfraStep-scene-construction"
]

VerificationTest[
  With[{
    scene = InfraScene[{a, b, s}, {
      InfraStep[{a == InfraPoint[], b == InfraPoint[]}],
      InfraStep[{s == InfraSegment[a, b]}]
    }],
    g = PathGraph[Range[5]]
  },
    AllTrue[RandomInfraInstance[ scene, g, All ], MatchQ[InfraSceneInstance[_Association]]]
  ],
  True,
  TestID -> "InfraStep-RandomInfraInstance"
]

VerificationTest[
  With[{
    sceneManual = InfraScene[{p, q, s}, {
      InfraStep[{p == InfraPoint[], q == InfraPoint[]}],
      InfraStep[{s == InfraSegment[p, q]}]
    }],
    sceneAuto = InfraScene[{p, q, s}, {
      p == InfraPoint[], q == InfraPoint[], s == InfraSegment[p, q]
    }],
    g = PathGraph[Range[5]]
  },
    Length[RandomInfraInstance[ sceneManual, g, All ]] == Length[RandomInfraInstance[ sceneAuto, g, All ]]
  ],
  True,
  TestID -> "InfraStep-same-results-as-auto"
]

VerificationTest[
  With[{
    scene = InfraScene[{a, b, s}, {
      InfraStep[{a == InfraPoint[], b == InfraPoint[]}],
      InfraStep[{s == InfraSegment[a, b]}],
      InfraDistance[a, b] >= 3
    }],
    g = PathGraph[Range[5]]
  },
    AllTrue[RandomInfraInstance[ scene, g, All ],
      inst |-> GraphDistance[g, inst[[1]][a], inst[[1]][b]] >= 3]
  ],
  True,
  TestID -> "InfraStep-global-assertion"
]

(* ===== Initial Bindings ===== *)

VerificationTest[
  With[{
    scene = InfraScene[{p, q, s}, {
      p == InfraPoint[], q == InfraPoint[], s == InfraSegment[p, q]
    }],
    g = PathGraph[Range[5]]
  },
    AllTrue[RandomInfraInstance[ scene, g, All, <|p -> 1|> ],
      inst |-> inst[[1]][p] == 1]
  ],
  True,
  TestID -> "RandomInfraInstance-initial-bindings-fix-point"
]

VerificationTest[
  With[{
    scene = InfraScene[{p, q, s}, {
      p == InfraPoint[], q == InfraPoint[], s == InfraSegment[p, q]
    }],
    g = PathGraph[Range[5]]
  },
    Length[RandomInfraInstance[ scene, g, All, <|p -> 1, q -> 5|> ]] <
    Length[RandomInfraInstance[ scene, g, All ]]
  ],
  True,
  TestID -> "RandomInfraInstance-initial-bindings-reduce-branches"
]

VerificationTest[
  With[{
    scene = InfraScene[{p, q, s}, {
      p == InfraPoint[], q == InfraPoint[], s == InfraSegment[p, q]
    }],
    g = PathGraph[Range[5]]
  },
    With[{instances = RandomInfraInstance[ scene, g, All, <|p -> 1, q -> 5|> ]},
      Length[instances] >= 1 &&
      AllTrue[instances, inst |-> inst[[1]][p] == 1 && inst[[1]][q] == 5]
    ]
  ],
  True,
  TestID -> "RandomInfraInstance-initial-bindings-both-fixed"
]

VerificationTest[
  With[{
    scene = InfraScene[{p, q, s}, {
      p == InfraPoint[], q == InfraPoint[], s == InfraSegment[p, q]
    }],
    g = PathGraph[Range[5]]
  },
    With[{
      step1 = RandomInfraInstance[ scene, g, All, "Steps" -> 1 ],
      fixed = RandomInfraInstance[ scene, g, All, "Steps" -> 1 ][[1, 1]]
    },
      With[{step2 = RandomInfraInstance[ scene, g, All, fixed, "Steps" -> 2 ]},
        AllTrue[step2,
          inst |-> inst[[1]][p] == fixed[p] && inst[[1]][q] == fixed[q]]
      ]
    ]
  ],
  True,
  TestID -> "RandomInfraInstance-fix-and-advance"
]


(* ===== InfraSceneInstance accessor ===== *)

VerificationTest[
  With[{
    scene = InfraScene[{p, q, s}, {
      p == InfraPoint[], q == InfraPoint[], s == InfraSegment[p, q]
    }],
    g = PathGraph[Range[5]]
  },
    With[{inst = First @ RandomInfraInstance[ scene, g, All ]},
      InfraSceneInstance[inst, p] === inst[[1]][p]
    ]
  ],
  True,
  TestID -> "InfraSceneInstance-accessor-wrapped-single-symbol"
]

VerificationTest[
  With[{
    scene = InfraScene[{p, q, s}, {
      p == InfraPoint[], q == InfraPoint[], s == InfraSegment[p, q]
    }],
    g = PathGraph[Range[5]]
  },
    With[{inst = First @ RandomInfraInstance[ scene, g, All ]},
      InfraSceneInstance[inst, {p, q, s}] === {inst[[1]][p], inst[[1]][q], inst[[1]][s]}
    ]
  ],
  True,
  TestID -> "InfraSceneInstance-accessor-wrapped-symbol-list"
]

VerificationTest[
  With[{
    scene = InfraScene[{p, q, s}, {
      p == InfraPoint[], q == InfraPoint[], s == InfraSegment[p, q]
    }],
    g = PathGraph[Range[5]]
  },
    With[{inst = First @ RandomInfraInstance[ scene, g, All ]},
      InfraSceneInstance[inst[[1]], p] === inst[[1]][p]
    ]
  ],
  True,
  TestID -> "InfraSceneInstance-accessor-bare-association-single-symbol"
]

VerificationTest[
  With[{
    scene = InfraScene[{p, q, s}, {
      p == InfraPoint[], q == InfraPoint[], s == InfraSegment[p, q]
    }],
    g = PathGraph[Range[5]]
  },
    With[{inst = First @ RandomInfraInstance[ scene, g, All ]},
      InfraSceneInstance[inst[[1]], {p, q, s}] === {inst[[1]][p], inst[[1]][q], inst[[1]][s]}
    ]
  ],
  True,
  TestID -> "InfraSceneInstance-accessor-bare-association-symbol-list"
]

(* ===== InfraDistance top-level form ===== *)

(* Bare vertex pair: behaves like GraphDistance. *)
VerificationTest[
  InfraDistance[GridGraph[{3, 3}], 1, 9],
  4,
  TestID -> "InfraDistance-bare-bare"
]

(* Bare vertex paired with a singleton multiset. *)
VerificationTest[
  InfraDistance[GridGraph[{3, 3}], <| 1 -> 1 |>, 9],
  4,
  TestID -> "InfraDistance-bare-multiset-singleton"
]

(* Two multi-vertex InfraPoints: default aggregation is Min over the
   cross-product of realisations.  d(1,9)=4, d(1,7)=2, d(3,9)=2, d(3,7)=4
   -> Min = 2. *)
VerificationTest[
  InfraDistance[GridGraph[{3, 3}], <| 1 -> 1, 3 -> 1 |>, <| 7 -> 1, 9 -> 1 |>],
  2,
  TestID -> "InfraDistance-InfraPoint-Min-default"
]

(* Same arguments under "Aggregation" -> Max gives the diameter, 4. *)
VerificationTest[
  InfraDistance[GridGraph[{3, 3}], <| 1 -> 1, 3 -> 1 |>, <| 7 -> 1, 9 -> 1 |>,
    "Aggregation" -> Max],
  4,
  TestID -> "InfraDistance-InfraPoint-Max"
]

(* Mean over the four pair distances = 3. *)
VerificationTest[
  InfraDistance[GridGraph[{3, 3}], <| 1 -> 1, 3 -> 1 |>, <| 7 -> 1, 9 -> 1 |>,
    "Aggregation" -> Mean],
  3,
  TestID -> "InfraDistance-InfraPoint-Mean"
]

(* a walk graph's vertex set is what the distance is taken over.  Segment
   {1,2,3} to vertex 9 in GridGraph[{3,3}]: min over {d(1,9), d(2,9), d(3,9)}
   = min(4, 3, 2) = 2. *)
VerificationTest[
  InfraDistance[GridGraph[{3, 3}], geodesicGraph @ {1, 2, 3}, 9],
  2,
  TestID -> "InfraDistance-walk-graph"
]

(* a set: the distance from vertex 1 is the min over its vertices. *)
VerificationTest[
  InfraDistance[GridGraph[{3, 3}], {2, 4, 6, 8}, 1],
  1,
  TestID -> "InfraDistance-set"
]

(* RandomInfraPoint returns bare vertices; InfraDistance accepts one directly,
   so callers never index into a wrapper. *)
VerificationTest[
  With[{g = GridGraph[{3, 3}], fp = First @ RandomInfraPoint[GridGraph[{3, 3}], 1]},
    InfraDistance[g, fp, 9] === GraphDistance[g, fp, 9]
  ],
  True,
  TestID -> "InfraDistance-RandomInfraPoint-no-extraction"
]

(* a polyline is its List of legs.  On PathGraph[Range[7]] the polyline
   1-2-3 / 3-4-5 has vertex set {1..5}; nearest reach from vertex 7 is via 5,
   distance 2. *)
VerificationTest[
  InfraDistance[ PathGraph @ Range @ 7, geodesicGraph /@ { { 1, 2, 3 }, { 3, 4, 5 } }, 7 ],
  2,
  TestID -> "InfraDistance-polyline-legs"
]

(* a cycle graph reads through its closed walk.  On CycleGraph[6] the closed
   walk {2,3,4,2} has vertex set {2,3,4}; nearest distance to vertex 1 is
   d(1,2) = 1. *)
VerificationTest[
  InfraDistance[ CycleGraph[ 6 ], geodesicCycleGraph @ { 2, 3, 4, 2 }, 1 ],
  1,
  TestID -> "InfraDistance-cycle-graph"
]

(* a set against a density.  On PathGraph[Range[5]] the set {2,3,4} is at
   distance 1, 2, 3 from vertex 1; Min = 1. *)
VerificationTest[
  InfraDistance[ PathGraph @ Range @ 5, { 2, 3, 4 }, <| 1 -> 1 |> ],
  1,
  TestID -> "InfraDistance-set-against-a-density"
]

(* two multisets.  On PathGraph[Range[5]]
   the pair ({2,3}, {4,5}) has pairwise distances (2, 3, 1, 2); Min = 1. *)
VerificationTest[
  InfraDistance[ PathGraph @ Range @ 5,
    <| 2 -> 1, 3 -> 1 |>,
    <| 4 -> 1, 5 -> 1 |> ],
  1,
  TestID -> "InfraDistance-multiset-multiset"
]

(* Symmetry: InfraDistance[g, p, q] == InfraDistance[g, q, p] for any two
   multi-realisation arguments under any aggregator over the pairwise matrix. *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ], p = <| 1 -> 1, 3 -> 1 |>, q = <| 7 -> 1, 9 -> 1 |> },
    And @@ Map[
      agg |-> InfraDistance[ g, p, q, "Aggregation" -> agg ] ===
              InfraDistance[ g, q, p, "Aggregation" -> agg ],
      { Min, Max, Mean } ]
  ],
  True,
  TestID -> "InfraDistance-symmetry-Min-Max-Mean"
]


(* ===== InfraIntersection / InfraUnion (standalone) ===== *)

(* the operators are graph-first, like every other public function here, and return
   the sorted vertex List on every shape *)

VerificationTest[
  InfraIntersection[ CompleteGraph @ 7,
    geodesicGraph @ { 1, 2, 3, 4 },
    geodesicGraph @ { 1, 5, 6, 3, 7 } ],
  { 1, 3 },
  TestID -> "InfraIntersection-two-walks-vertex-set"
]

VerificationTest[
  InfraIntersection[ CompleteGraph @ 6,
    geodesicGraph /@ { { 1, 2, 3 }, { 1, 4, 3 } },
    geodesicGraph @ { 3, 5, 6 } ],
  { 3 },
  TestID -> "InfraIntersection-bundle-union-then-intersect"
]

VerificationTest[
  InfraIntersection[ CompleteGraph @ 5,
    <| 1 -> 1, 2 -> 1, 3 -> 1 |>,
    geodesicGraph @ { 2, 3, 4 },
    { 3, 4, 5 } ],
  { 3 },
  TestID -> "InfraIntersection-variadic-mixed-shapes"
]

VerificationTest[
  InfraUnion[ CompleteGraph @ 4,
    <| 1 -> 1, 2 -> 1 |>,
    geodesicGraph @ { 3, 4 } ],
  { 1, 2, 3, 4 },
  TestID -> "InfraUnion-mixed-shapes"
]

(* Symbolic args stay inert so InfraScene hypotheses are not perturbed. *)
VerificationTest[
  Head @ InfraIntersection[ s1, s2 ],
  InfraIntersection,
  TestID -> "InfraIntersection-symbolic-args-inert"
]

(* A scene constructor is not a realisation: InfraCircle[c, r] names a circle
   whose vertex set exists only after dispatch, so folding it here would
   answer with the empty set before the graph is known. *)
VerificationTest[
  Head @ InfraIntersection[ InfraCircle[ ctr1, 2 ], InfraCircle[ ctr2, 2 ] ],
  InfraIntersection,
  TestID -> "InfraIntersection-scene-constructor-args-inert"
]


(* ===== Euclid I.1 ===== *)

(* The equilateral-triangle construction: the apexes are the vertices lying on
   both circles of radius d(a, b) centred at a and at b.  On PetersenGraph[]
   with a = 1, b = 7 (d = 2) that intersection is {5, 9, 10}. *)
VerificationTest[
  With[ { g = PetersenGraph[ ],
          scene = InfraScene[ { ea, eb, ec }, {
            ec == InfraIntersection[
              InfraCircle[ ea, InfraDistance[ ea, eb ] ],
              InfraCircle[ eb, InfraDistance[ ea, eb ] ] ] } ] },
    Sort @ DeleteDuplicates[
      #[[ 1 ]][ ec ] & /@ RandomInfraInstance[ scene, g, All, <| ea -> 1, eb -> 7 |> ] ]
  ],
  { 5, 9, 10 },
  TestID -> "RandomInfraInstance-EuclidI1-apexes"
]

(* Each apex is equidistant from both foci, at exactly the base length. *)
VerificationTest[
  With[ { g = PetersenGraph[ ],
          scene = InfraScene[ { ea, eb, ec }, {
            ec == InfraIntersection[
              InfraCircle[ ea, InfraDistance[ ea, eb ] ],
              InfraCircle[ eb, InfraDistance[ ea, eb ] ] ] } ] },
    With[ { apexes = #[[ 1 ]][ ec ] & /@ RandomInfraInstance[ scene, g, All, <| ea -> 1, eb -> 7 |> ] },
      apexes =!= { } &&
      AllTrue[ apexes,
        v |-> GraphDistance[ g, 1, v ] == GraphDistance[ g, 7, v ] == GraphDistance[ g, 1, 7 ] ]
    ]
  ],
  True,
  TestID -> "RandomInfraInstance-EuclidI1-equilateral"
]

(* The scene agrees with the intersection of the two circles' representatives taken by hand. *)
VerificationTest[
  With[ { g = PetersenGraph[ ],
          scene = InfraScene[ { ea, eb, ec }, {
            ec == InfraIntersection[
              InfraCircle[ ea, InfraDistance[ ea, eb ] ],
              InfraCircle[ eb, InfraDistance[ ea, eb ] ] ] } ] },
    Sort @ DeleteDuplicates[
      #[[ 1 ]][ ec ] & /@ RandomInfraInstance[ scene, g, All, <| ea -> 1, eb -> 7 |> ] ] ===
    Sort @ Quiet @ Intersection[
      Union @@ RandomInfraCircle[ g, InfraCircle[ 1, GraphDistance[ g, 1, 7 ] ], All ],
      Union @@ RandomInfraCircle[ g, InfraCircle[ 7, GraphDistance[ g, 1, 7 ] ], All ] ]
  ],
  True,
  TestID -> "RandomInfraInstance-EuclidI1-agrees-with-the-circles"
]


(* ===== Undecidable assertions ===== *)

(* An Infra*Q head the scene cannot inject the graph into would reject every
   branch silently; the scene refuses to build instead. *)
VerificationTest[
  MatchQ[ InfraScene[ { ua, uc }, { InfraPointQ[ ua ], uc == InfraPoint[ ] } ], InfraScene[ _List, _List ] ],
  True,
  TestID -> "InfraScene-unknown-assertion-head-refused"
]

(* A real predicate outside the scene table is refused on the same grounds. *)
VerificationTest[
  MatchQ[ InfraScene[ { ua, us }, {
    InfraStep[ { ua == InfraPoint[ ] } ], InfraGeodesicQ[ us ] } ], InfraScene[ _List, _List ] ],
  True,
  TestID -> "InfraScene-unknown-assertion-head-refused-manual-steps"
]

(* Heads in the table are untouched by the guard. *)
VerificationTest[
  Head @ InfraScene[ { ka, kb, ks }, {
    ka == InfraPoint[ ], kb == InfraPoint[ ], ks == InfraSegment[ ka, kb ],
    InfraSegmentQ[ ks ], InfraDistance[ ka, kb ] >= 3 } ],
  InfraScene,
  TestID -> "InfraScene-known-assertion-heads-accepted"
]

(* A known head at an arity the table has no rule for misses its rewrite and
   stays inert, exactly like an unknown head -- so it is refused the same way. *)
VerificationTest[
  MatchQ[ InfraScene[ { ya, yb, ys }, {
    ys == InfraSegment[ ya, yb ], InfraSegmentQ[ ys, 2 ] } ], InfraScene[ _List, _List ] ],
  True,
  TestID -> "InfraScene-known-head-wrong-arity-refused"
]


(* ===== Structural invariants ===== *)

(* An exported symbol with no definitions of any kind can only be a scene token:
   an assertion head, a construction constructor, or the step container.  The
   symbols below are exactly those.  The five Euclidean object heads -- InfraSegment,
   InfraRay, InfraLine, InfraCircle, InfraArc -- rejoined the list on 2026-09-26
   (EuclideanInertHeads): the heads themselves are always inert now, with no clause of
   their own at any arity -- every behaviour lives on InfraMeasurement, NamedConstructionSampler
   and dispatchConstruction instead.  One more means a symbol was exported with a usage
   message and no meaning, which is how InfraPlaneQ hid. *)
VerificationTest[
  Select[ Names[ "WolframInstitute`InfraGeometry`*" ],
    n |-> AllTrue[
      { DownValues, UpValues, SubValues, OwnValues, FormatValues, NValues },
      f |-> ReleaseHold @ Map[ f, ToExpression[ n, InputForm, Hold ] ] === { } ] ],
  (* InflatedVertex is not a scene token: it is the inert label InflateGraph stamps on the
     copies it makes.  It arrived with ExampleGraphs.wl in the paclet split (T2a).  Nor is
     InfraSection and InfraConnection, the inert maps read by the section and connection functions
     (InfraFibrations T2), nor InfraTangentBundle, InfraCotangentBundle and InfraDisplacementBundle,
     the fibration constructions read by InfraTotalGraph and InfraFibrationAssociation (InfraFibrations T3).
     InfraFibration left the list in T3: its one-argument form converts a construction.  The hull heads InfraBallHull and
     InfraConvexHull joined it with APISurfaceCleanup T4, region heads read like InfraBall, and InfraSolidOfRevolution replaced
     InfraRevolution in T5; InfraQuadric replaced the elliptic-shell token in T6. *)
  { "InflatedVertex",
    "InfraArc", "InfraBall", "InfraBallHull", "InfraCircle", "InfraCone", "InfraConnection", "InfraConvexHull",
    "InfraCotangentBundle", "InfraCylinder",
    "InfraDisplacementBundle", "InfraEllipse", "InfraGeodesic", "InfraHalfLine", "InfraInfiniteLine",
    "InfraIntersectQ", "InfraLine", "InfraPlane", "InfraPoint",
    "InfraPolygon", "InfraQuadric", "InfraRay", "InfraRegularPolygon", "InfraSection", "InfraSegment",
    "InfraShell", "InfraSolidOfRevolution", "InfraSphere", "InfraStep", "InfraTangentBundle", "InfraTube", "InfraWalk", "Undetermined" },
  TestID -> "InfraScene-valueless-exports-are-scene-tokens"
]

(* And each is a live token, not a leftover: the assertion head is
   accepted by the guard, the constructor is dispatched into vertex sets, and the
   container carries a manual step. *)
VerificationTest[
  Head @ InfraScene[ { ta, tb }, { InfraIntersectQ[ ta, tb ] } ],
  InfraScene,
  TestID -> "InfraScene-token-InfraIntersectQ-is-an-assertion-head"
]

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    And @@ ( inst |-> With[ { vs = inst[[ 1 ]][ tr ] },
        SubsetQ[ vs, { 1, 2, 3, 4 } ] && SubsetQ[ VertexList @ g, vs ] ] ) /@
      RandomInfraInstance[ InfraScene[ { tr }, { tr == InfraSolidOfRevolution[ { 1, 2, 3, 4 }, 1 ] } ], g, All ] ],
  True,
  TestID -> "InfraScene-token-InfraSolidOfRevolution-is-a-constructor"
]

(* InfraMemberQ is a decidable assertion: the solid's one member passes as itself and fails against another solid *)
VerificationTest[
  With[ { g = GridGraph[ { 7, 7 } ] },
    Length @ RandomInfraInstance[ InfraScene[ { s }, { s == InfraCylinder[ { 1, 2, 3 }, 1 ], InfraMemberQ[ #, s ] } ], g, All ] & /@
      { InfraCylinder[ { 1, 2, 3 }, 1 ], InfraTube[ { 1, 2, 3 }, 1 ] } ],
  { 1, 0 },
  TestID -> "InfraScene-InfraMemberQ-is-an-assertion"
]

VerificationTest[
  With[ { scene = InfraScene[ { sa, sb }, {
      InfraStep[ { sa == InfraPoint[ ] } ],
      InfraStep[ { sb == InfraPoint[ ] } ] } ] },
    scene[ "ManualSteps" ] === True && scene[ "Steps" ] === { { sa }, { sb } } ],
  True,
  TestID -> "InfraScene-token-InfraStep-carries-a-step"
]

(* Every scene assertion delegates to a named predicate.  InfraPlaneQ was the
   one entry whose semantics lived inlined in the rule table instead of behind a
   name, which is why InfraPlane was the only level set with no *Q at all. *)
VerificationTest[
  With[ { heldRHS = Cases[
      WolframInstitute`InfraGeometry`PackageScope`sceneAssertionRules[ Null ],
      RuleDelayed[ _, rhs_ ] :> Hold[ rhs ] ] },
    { Select[ heldRHS, ! MatchQ[ #, Hold[ _Symbol[ ___ ] ] ] & ],
      Select[ Extract[ #, { 1, 0 } ] & /@ heldRHS,
        Context[ # ] =!= "System`" &&
          ! MemberQ[ Names[ "WolframInstitute`InfraGeometry`*" ],
            SymbolName[ # ] ] & ] } ],
  { { }, { } },
  TestID -> "InfraScene-assertion-rules-delegate-to-named-predicates"
]


(* ===== The scene reads vertex sets by shape, not by AtomQ ===== *)

(* InfraIntersection inside a scene resolves each operand to its vertex set through
   the anchor rule.  On a list-labelled substrate the wrapper-era reading -- a bare
   vertex is AtomQ -- split every vertex into its coordinates *)
VerificationTest[
  With[{g = TessellationGraph[{4, 4}, 2]},
    {c = First @ VertexList @ g},
    Sort @ InfraIntersection[ g, RandomInfraBall[ g, InfraBall[c, 1] ], RandomInfraBall[ g, InfraBall[c, 2] ] ] ===
      Sort @ RandomInfraBall[ g, InfraBall[c, 1] ]],
  True,
  TestID -> "InfraIntersection-on-a-list-labelled-substrate"
]

(* the same through the scene engine: the intersection of two balls about one
   centre is the smaller ball, and every binding is a substrate vertex *)
VerificationTest[
  With[{g = TessellationGraph[{4, 4}, 2]},
    {c = First @ VertexList @ g},
    {scene = InfraScene[{p}, {p == InfraIntersection[InfraBall[c, 1], InfraBall[c, 2]]}]},
    {instances = RandomInfraInstance[ scene, g, All ]},
    AllTrue[instances, VertexQ[g, InfraSceneInstance[#, p]] &] &&
      Sort[InfraSceneInstance[#, p] & /@ instances] === Sort @ RandomInfraBall[ g, InfraBall[c, 1] ]],
  True,
  TestID -> "InfraScene-intersection-binds-substrate-vertices"
]


(* the union token: every vertex of either of two named balls is one branch, and
   the branches are exactly the union of the two balls taken by hand *)
VerificationTest[
  With[{g = GridGraph[{5, 5}]},
    {scene = InfraScene[{ba, bb, m}, {ba == InfraBall[7, 1], bb == InfraBall[9, 1], m == InfraUnion[ba, bb]}]},
    Sort[InfraSceneInstance[#, m] & /@ RandomInfraInstance[ scene, g, All ]] ===
      Union[RandomInfraBall[ g, InfraBall[7, 1] ], RandomInfraBall[ g, InfraBall[9, 1] ]]],
  True,
  TestID -> "InfraScene-union-token-binds-every-vertex-of-either"
]

(* the meet is contained in the union, scene for scene *)
VerificationTest[
  With[{g = GridGraph[{5, 5}]},
    {meet = InfraScene[{ba, bb, m}, {ba == InfraBall[7, 1], bb == InfraBall[9, 1], m == InfraIntersection[ba, bb]}],
     join = InfraScene[{ba, bb, m}, {ba == InfraBall[7, 1], bb == InfraBall[9, 1], m == InfraUnion[ba, bb]}]},
    {ps = InfraSceneInstance[#, m] & /@ RandomInfraInstance[ meet, g, All ], qs = InfraSceneInstance[#, m] & /@ RandomInfraInstance[ join, g, All ]},
    ps =!= {} && SubsetQ[qs, ps] && Length[qs] > Length[ps]],
  True,
  TestID -> "InfraScene-meet-inside-union"
]

(* Euclid I.1 with the union in place of the meet: every vertex at distance d(a, b)
   from a or from b, the two circles taken by hand *)
VerificationTest[
  With[{g = PetersenGraph[]},
    {scene = InfraScene[{ea, eb, ec}, {
       ec == InfraUnion[InfraCircle[ea, InfraDistance[ea, eb]], InfraCircle[eb, InfraDistance[ea, eb]]]}]},
    Sort @ DeleteDuplicates[InfraSceneInstance[#, ec] & /@
        RandomInfraInstance[ scene, g, All, <|ea -> 1, eb -> 7|> ]] ===
      Sort @ Quiet @ Union[
        Union @@ RandomInfraCircle[ g, InfraCircle[1, GraphDistance[g, 1, 7]], All ],
        Union @@ RandomInfraCircle[ g, InfraCircle[7, GraphDistance[g, 1, 7]], All ]]],
  True,
  TestID -> "InfraScene-union-of-two-circles-agrees-with-the-circles"
]

(* "EmbeddingClosest" on a segment keeps the geodesic nearest the straight line through its endpoints *)
VerificationTest[
  With[{d = ({ graph, token } |-> ( instance |-> instance[[ 1 ]][ syntheticTarget ] ) /@ RandomInfraInstance[ InfraScene[ { syntheticTarget }, { syntheticTarget == token } ], graph, All ]), g = GridGraph[{5, 5}]},
    {Length @ d[g, InfraSegment[1, 25]], d[g, InfraSegment[1, 25, "Select" -> "EmbeddingClosest"]]}],
  {70, {{1, 2, 7, 8, 13, 14, 19, 20, 25}}},
  TestID -> "InfraScene-select-embedding-closest-segment"
]

VerificationTest[
  BlockRandom[
    With[ { scene = InfraScene[ { p }, { p == InfraPoint[] } ], graph = PathGraph[ Range[ 5 ] ] },
      { MatchQ[ RandomInfraInstance[ scene, graph ], InfraSceneInstance[ _Association ] ],
        Length @ RandomInfraInstance[ scene, graph, 1 ],
        InfraSceneInstance[ RandomInfraInstance[ scene, graph, <| p -> 3 |> ], p ] } ],
    RandomSeeding -> 41 ],
  { True, 1, 3 },
  TestID -> "RandomInfraInstance-default-one-count-list-initial-association"
]

VerificationTest[
  With[ { scene = InfraScene[ { p }, { p == InfraPoint[] } ], graph = PathGraph[ Range[ 8 ] ] },
    With[ { samples = Table[ BlockRandom[ RandomInfraInstance[ scene, graph ], RandomSeeding -> seed ], { seed, 12 } ] },
      { samples === Table[ BlockRandom[ RandomInfraInstance[ scene, graph ], RandomSeeding -> seed ], { seed, 12 } ],
        Length @ DeleteDuplicates[ samples ] > 1,
        AllTrue[ samples, instance |-> VertexQ[ graph, InfraSceneInstance[ instance, p ] ] ] } ] ],
  { True, True, True },
  TestID -> "RandomInfraInstance-reproducible-varied-admissible"
]

VerificationTest[
  BlockRandom[
    With[ { scene = InfraScene[ { p }, { p == InfraPoint[] } ], graph = PathGraph[ Range[ 5 ] ] },
      With[ { three = RandomInfraInstance[ scene, graph, 3 ], upto = RandomInfraInstance[ scene, graph, UpTo[ 8 ] ] },
        { Length @ three, DuplicateFreeQ @ three, Length @ upto, DuplicateFreeQ @ upto,
          RandomInfraInstance[ scene, graph, 6 ], RandomInfraInstance[ scene, graph, 0 ],
          RandomInfraInstance[ scene, graph, 0, "Steps" -> 0 ], RandomInfraInstance[ scene, graph, UpTo[ 0 ] ] } ] ],
    RandomSeeding -> 41 ],
  { 3, True, 5, True, { }, { }, { }, { } },
  TestID -> "RandomInfraInstance-distinct-counts-shortage-zero"
]

VerificationTest[
  With[ { scene = InfraScene[ { p }, { p == InfraPoint[ 1 ], p > 2 } ], graph = PathGraph[ Range[ 5 ] ] },
    BlockRandom[ { RandomInfraInstance[ scene, graph ], RandomInfraInstance[ scene, graph, UpTo[ 3 ] ],
      RandomInfraInstance[ scene, graph, All ] }, RandomSeeding -> 41 ] ],
  { { }, { }, { } },
  TestID -> "RandomInfraInstance-impossible-scene"
]

VerificationTest[
  With[ { scene = InfraScene[ { p, q }, { p == InfraPoint[], q == InfraIntersection[ InfraShell[ p, 3 ], InfraShell[ p, 3 ] ] } ],
          graph = PathGraph[ Range[ 4 ] ] },
    AllTrue[ Range[ 20 ], seed |->
      With[ { instance = BlockRandom[ RandomInfraInstance[ scene, graph ], RandomSeeding -> seed ] },
        MatchQ[ instance, InfraSceneInstance[ _Association ] ] &&
          GraphDistance[ graph, Sequence @@ InfraSceneInstance[ instance, { p, q } ] ] == 3 ] ] ],
  True,
  TestID -> "RandomInfraInstance-backtracks-from-empty-construction"
]

VerificationTest[
  With[ { scene = InfraScene[ { p, q }, { p == InfraPoint[], q == InfraIntersection[ InfraShell[ p, 1 ], InfraShell[ p, 1 ] ], p >= 3 } ],
          graph = PathGraph[ Range[ 4 ] ] },
    InfraSceneInstance[ RandomInfraInstance[ scene, graph, "NextVertexFunction" -> Identity ], { p, q } ] ],
  { 3, 2 },
  TestID -> "RandomInfraInstance-backtracks-after-bound-assertion"
]

VerificationTest[
  With[ { scene = InfraScene[ { p, q }, { p == InfraPoint[], q == InfraIntersection[ InfraShell[ p, 2 ], InfraShell[ p, 2 ] ], p < q } ],
          graph = PathGraph[ Range[ 3 ] ] },
    { InfraSceneInstance[ #, p ] & /@ RandomInfraInstance[ scene, graph, All, "Steps" -> 1 ],
      InfraSceneInstance[ #, { p, q } ] & /@ RandomInfraInstance[ scene, graph, All ] } ],
  { { 1, 2, 3 }, { { 1, 3 } } },
  TestID -> "RandomInfraInstance-partial-steps-defer-unbound-assertions"
]

VerificationTest[
  With[ { scene = InfraScene[ { p, q }, { { p, q } == InfraSegment[ { 1, 2 }, { 3, 4 } ] } ],
          graph = CompleteGraph[ 4 ] },
    { InfraSceneInstance[ #, { p, q } ] & /@ RandomInfraInstance[ scene, graph, All, <| p -> 1 |> ],
      RandomInfraInstance[ scene, graph, All, <| p -> 4 |> ] } ],
  { { { 1, 3 }, { 1, 4 } }, { } },
  TestID -> "RandomInfraInstance-partly-fixed-tuple-preserved"
]

VerificationTest[
  With[ { scene = InfraScene[ { p, q }, { { p, q } == InfraSegment[ { 1, 2 }, { 3, 4 } ] } ],
          graph = CompleteGraph[ 4 ] },
    InfraSceneInstance[ RandomInfraInstance[ scene, graph, <| p -> 1, q -> 3 |> ], { p, q } ] ],
  { 1, 3 },
  TestID -> "RandomInfraInstance-fully-fixed-tuple"
]

VerificationTest[
  With[ { scene = InfraScene[ { p }, { p == InfraPoint[] } ], graph = PathGraph[ Range[ 5 ] ] },
    { InfraSceneInstance[ #, p ] & /@ RandomInfraInstance[ scene, graph, All ],
      RandomInfraInstance[ scene, graph, "NextVertexFunction" -> Identity ] ===
        First @ RandomInfraInstance[ scene, graph, All ],
      BlockRandom[ RandomInfraInstance[ scene, graph, All ]; RandomInteger[ 1000000 ], RandomSeeding -> 41 ] ===
        BlockRandom[ RandomInteger[ 1000000 ], RandomSeeding -> 41 ],
      BlockRandom[ RandomInfraInstance[ scene, graph, 3, "NextVertexFunction" -> Identity ];
        RandomInteger[ 1000000 ], RandomSeeding -> 41 ] ===
        BlockRandom[ RandomInteger[ 1000000 ], RandomSeeding -> 41 ] } ],
  { { 1, 2, 3, 4, 5 }, True, True, True },
  TestID -> "RandomInfraInstance-All-Identity-deterministic-no-random-draw"
]

VerificationTest[
  With[ { scene = InfraScene[ { p, q }, { p == InfraPoint[], q == InfraIntersection[ InfraShell[ p, 3 ], InfraShell[ p, 3 ] ] } ],
          graph = PathGraph[ Range[ 4 ] ] },
    { Head @ RandomInfraInstance[ scene, graph, All, "NextVertexFunction" -> RandomChoice ],
      MemberQ[ Table[ BlockRandom[ RandomInfraInstance[ scene, graph, "NextVertexFunction" -> RandomChoice ],
        RandomSeeding -> seed ], { seed, 20 } ], { } ] } ],
  { RandomInfraInstance, True },
  TestID -> "RandomInfraInstance-RandomChoice-one-route-refuses-All"
]

VerificationTest[
  With[ { scene = InfraScene[ { p }, { p == InfraPoint[], p > 2 } ], graph = PathGraph[ Range[ 4 ] ] },
    { RandomInfraInstance[ scene, graph, "NextVertexFunction" -> (Take[ #, UpTo[ 1 ] ] &) ],
      InfraSceneInstance[ RandomInfraInstance[ scene, graph, "NextVertexFunction" -> Identity ], p ] } ],
  { { }, 3 },
  TestID -> "RandomInfraInstance-pruned-failure-is-local-to-retained-tree"
]

VerificationTest[
  With[ { scene = InfraScene[ { p, q }, { p == InfraPoint[], q == InfraIntersection[ InfraShell[ p, 1 ], InfraShell[ p, 1 ] ] } ],
          graph = PathGraph[ Range[ 4 ] ] },
    With[ { partial = RandomInfraInstance[ scene, graph, All, "Steps" -> 1 ] },
      With[ { fixed = First[ partial ][[ 1 ]] },
        { Length @ partial,
          InfraSceneInstance[ #, { p, q } ] & /@ RandomInfraInstance[ scene, graph, All, fixed, "Steps" -> 2 ],
          RandomInfraInstance[ scene, graph, All, "Steps" -> 1 ] === partial } ] ] ],
  { 4, { { 1, 2 } }, True },
  TestID -> "RandomInfraInstance-viewer-partial-fix-advance-stable"
]

VerificationTest[
  With[ { scene = InfraScene[ { p }, { p == InfraPoint[] } ], graph = PathGraph[ Range[ 2 ] ] },
    { Length @ RandomInfraInstance[ scene, graph, All, "NextVertexFunction" -> (Join[ #, # ] &) ],
      RandomInfraInstance[ scene, graph, 3, "NextVertexFunction" -> (Join[ #, # ] &) ] } ],
  { 2, { } },
  TestID -> "RandomInfraInstance-repeated-extensions-do-not-count-as-distinct"
]

VerificationTest[
  With[ { scene = InfraScene[ { p, q, a, b, c, d },
            { p == InfraPoint[], q == InfraPoint[], a == InfraPoint[], b == InfraPoint[], c == InfraPoint[], d == InfraPoint[] } ],
          graph = PathGraph[ Range[ 20 ] ] },
    MatchQ[ TimeConstrained[ BlockRandom[ RandomInfraInstance[ scene, graph ], RandomSeeding -> 41 ], 10 ],
      InfraSceneInstance[ bindings_Association /; Length[ bindings ] == 6 ] ] ],
  True,
  TestID -> "RandomInfraInstance-bounded-search-avoids-full-branch-product"
]

VerificationTest[
  With[ { scene = InfraScene[ { p, q }, { p == InfraPoint[], q == InfraPoint[], p > 3 } ],
          graph = PathGraph[ Range[ 3 ] ] },
    BlockRandom[
      RandomInfraInstance[ scene, graph, <| p -> 1 |> ]; RandomInteger[ 1000000 ], RandomSeeding -> 41 ] ===
      BlockRandom[ RandomInteger[ 1000000 ], RandomSeeding -> 41 ] ],
  True,
  TestID -> "RandomInfraInstance-bound-assertions-reject-before-further-draws"
]

EndTestSection[]
