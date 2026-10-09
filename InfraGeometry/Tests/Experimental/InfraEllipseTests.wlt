BeginTestSection["InfraEllipse"]

walkSequence = WolframInstitute`InfraGeometry`PackageScope`walkSequence;

(* ===== RandomInfraEllipse: default Properties -> {"Separating", "Shortest"} =====

   Default returns the shortest separating cycle around both foci, as a directed
   cycle graph on the substrate.  A separating cycle requires a non-empty near
   region {sum < cMin}, so c must be > d(p1, p2).  On the 7x7 grid, foci {25, 12}
   are at distance 3 and band {4, 8} gives a non-degenerate level surface that
   supports genuine elliptic loops. *)

VerificationTest[
  With[ { g = GridGraph[ { 7, 7 } ] },
    With[ { cyc = walkSequence @ RandomInfraEllipse[ g, { 25, 12 }, { 4, 8 } ] },
      Length[ cyc ] >= 4 &&
      AllTrue[ Partition[ Append[ cyc, First @ cyc ], 2, 1 ],
        EdgeQ[ g, UndirectedEdge @@ # ] & ]
    ]
  ],
  True,
  TestID -> "RandomInfraEllipse-default-returns-separating-cycle"
]

(* Cycle vertices lie inside the level band *)
VerificationTest[
  With[ {
      g = GridGraph[ { 7, 7 } ],
      dm = GraphDistanceMatrix @ GridGraph[ { 7, 7 } ] },
    With[ { cyc = VertexList @ RandomInfraEllipse[ g, { 25, 12 }, { 4, 8 } ] },
      AllTrue[ cyc, 4 <= dm[[ 25, # ]] + dm[[ 12, # ]] <= 8 & ]
    ]
  ],
  True,
  TestID -> "RandomInfraEllipse-default-cycle-in-level-band"
]

(* Cycle separates near region from far region in the original graph *)
VerificationTest[
  With[ {
      g = GridGraph[ { 7, 7 } ],
      dm = GraphDistanceMatrix @ GridGraph[ { 7, 7 } ] },
    With[ { cyc = VertexList @ RandomInfraEllipse[ g, { 25, 12 }, { 4, 8 } ] },
      With[ {
          near = Select[ VertexList @ g, dm[[ 25, # ]] + dm[[ 12, # ]] < 4 & ],
          far  = Select[ VertexList @ g, dm[[ 25, # ]] + dm[[ 12, # ]] > 8 & ] },
        near =!= { } && far =!= { } &&
        GraphDistance[ VertexDelete[ g, cyc ], First @ near, First @ far ] === Infinity
      ]
    ]
  ],
  True,
  TestID -> "RandomInfraEllipse-default-cycle-separates-near-from-far"
]

(* Properties -> {} reverts to "any simple cycle in level set" *)
VerificationTest[
  VertexCount @ RandomInfraEllipse[ GridGraph[ { 4, 4 } ], { 2, 15 }, 4, Properties -> { } ],
  4,
  TestID -> "RandomInfraEllipse-NoProperties-Grid4x4-shortest-cycle-length-4"
]

VerificationTest[
  SubsetQ[
    { 2, 3, 6, 7, 10, 11, 14, 15 },
    VertexList @ RandomInfraEllipse[ GridGraph[ { 4, 4 } ], { 2, 15 }, 4, Properties -> { } ]
  ],
  True,
  TestID -> "RandomInfraEllipse-NoProperties-Grid4x4-cycle-in-level-set"
]

(* All cycles returned with All are within the level set *)
VerificationTest[
  AllTrue[
    RandomInfraEllipse[ GridGraph[ { 4, 4 } ], { 2, 15 }, 4, All, Properties -> { } ],
    SubsetQ[ { 2, 3, 6, 7, 10, 11, 14, 15 }, VertexList @ # ] &
  ],
  True,
  TestID -> "RandomInfraEllipse-NoProperties-Grid4x4-all-cycles-in-level-set"
]

(* Cycles sorted by length ascending *)
VerificationTest[
  With[ {
      shortest = VertexCount @ RandomInfraEllipse[ GridGraph[ { 4, 4 } ], { 2, 15 }, 4, Properties -> { } ],
      allLengths = VertexCount /@
        RandomInfraEllipse[ GridGraph[ { 4, 4 } ], { 2, 15 }, 4, All, Properties -> { } ] },
    shortest <= Min @ allLengths
  ],
  True,
  TestID -> "RandomInfraEllipse-NoProperties-Grid4x4-sorted-by-length"
]

(* Default "Shortest": all returned ties share the minimum length *)
VerificationTest[
  Apply[ SameQ,
    VertexCount /@ RandomInfraEllipse[ GridGraph[ { 7, 7 } ], { 25, 12 }, { 4, 8 }, All ] ],
  True,
  TestID -> "RandomInfraEllipse-default-Shortest-ties-equal-length"
]

(* Empty level set -> $Failed for count=1 *)
VerificationTest[
  RandomInfraEllipse[ PathGraph[ Range[ 5 ] ], { 1, 3 }, 100, 1 ],
  { },
  TestID -> "RandomInfraEllipse-empty-level-set"
]

(* Level set with no cycle (path, not a cycle) -> $Failed for count=1 *)
VerificationTest[
  RandomInfraEllipse[ PathGraph[ Range[ 5 ] ], { 1, 3 }, 2, 1 ],
  { },
  TestID -> "RandomInfraEllipse-PathGraph-no-cycle-in-level-set"
]

(* ===== InfraEllipseQ ===== *)

(* A 4-cycle in the inner strip of GridGraph[{4,4}] is an ellipse, read as a cycle graph and as its vertex sequence *)
VerificationTest[
  With[ { cycle = RandomInfraEllipse[ GridGraph[ { 4, 4 } ], { 2, 15 }, 4, Properties -> { } ] },
    { InfraEllipseQ[ GridGraph[ { 4, 4 } ], cycle ], InfraEllipseQ[ GridGraph[ { 4, 4 } ], walkSequence @ cycle ] }
  ],
  { True, True },
  TestID -> "InfraEllipseQ-Grid4x4-found-cycle-true"
]

(* A path is not an ellipse *)
VerificationTest[
  InfraEllipseQ[ GridGraph[ { 4, 4 } ], { 1, 2, 3, 4 } ],
  False,
  TestID -> "InfraEllipseQ-Grid4x4-path-false"
]

(* Short cycle: length < 3 is not an ellipse *)
VerificationTest[
  InfraEllipseQ[ CycleGraph[ 6 ], { 1, 2 } ],
  False,
  TestID -> "InfraEllipseQ-too-short-false"
]

(* ===== RandomInfraEllipse on the Method ladder ===== *)

(* a count-less call is one witness, as on every ladder symbol; All is the whole grade *)
VerificationTest[
  { GraphQ @ RandomInfraEllipse[ GridGraph[ { 4, 4 } ], { 2, 15 }, 4, Properties -> { } ],
    Length @ RandomInfraEllipse[ GridGraph[ { 4, 4 } ], { 2, 15 }, 4, All, Properties -> { } ] },
  { True, 6 },
  TestID -> "RandomInfraEllipse-countless-is-one-witness"
]

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ],
          all = RandomInfraEllipse[ GridGraph[ { 4, 4 } ], { 2, 15 }, 4, All, Properties -> { } ] },
    RandomInfraEllipse[ g, { 2, 15 }, 4, Properties -> { }, "NextVertexFunction" -> Identity ] === First @ all ],
  True,
  TestID -> "RandomInfraEllipse-Identity-preserves-first-member"
]

VerificationTest[
  Length @ DeleteDuplicates @ Table[
    BlockRandom[ RandomInfraEllipse[ GridGraph[ { 4, 4 } ], { 2, 15 }, 4, Properties -> { } ],
      RandomSeeding -> s ],
    { s, 1, 8 } ] > 1,
  True,
  TestID -> "RandomInfraEllipse-default-varies-across-seeds"
]

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    BlockRandom[ RandomInfraEllipse[ g, { 2, 15 }, 4, Properties -> { } ], RandomSeeding -> 23 ] ===
      BlockRandom[ RandomInfraEllipse[ g, { 2, 15 }, 4, Properties -> { } ], RandomSeeding -> 23 ] ],
  True,
  TestID -> "RandomInfraEllipse-default-is-seeded"
]

EndTestSection[]
