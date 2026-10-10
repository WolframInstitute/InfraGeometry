BeginTestSection["InfraSphere"]

SeparatesQ = WolframInstitute`InfraGeometry`PackageScope`SeparatesQ;

(* ===== RandomInfraSphere: the peel over the band, moved from FindInfraShell ===== *)

(* Properties -> {"Separating", "Connected"}: minimal connected separators. *)

VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    With[{shells = RandomInfraSphere[g, 6, {1, 2}, All, Properties -> {"Separating", "Connected"}]},
      Length[shells] >= 1 &&
      AllTrue[shells, vs |-> AllTrue[vs, v |-> 1 <= GraphDistance[g, 6, v] <= 2]] &&
      AllTrue[shells, vs |-> ConnectedGraphQ[Subgraph[g, vs]]]
    ]
  ],
  True,
  TestID -> "RandomInfraSphere-Sep-Connected-within-range"
]

VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    With[{shells = RandomInfraSphere[g, 6, {1, 2}, All, Properties -> {"Separating", "Connected"}]},
      AllTrue[shells, vs |-> AllTrue[shells,
        other |-> other === vs || ! (Length[other] < Length[vs] && SubsetQ[vs, other])
      ]]
    ]
  ],
  True,
  TestID -> "RandomInfraSphere-Sep-Connected-minimal"
]

(* Properties -> {"Separating"} alone (no connectedness requirement).
   Every returned vs is inside the level-set range; we don't re-test
   separation here because SeparatingSetQ is PackageScope and the
   admissibility predicate is enforced inside findShellCore. *)

VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    With[{shells = RandomInfraSphere[g, 6, {1, 2}, All, Properties -> {"Separating"}]},
      Length[shells] >= 1 &&
      AllTrue[shells, vs |-> AllTrue[vs, v |-> 1 <= GraphDistance[g, 6, v] <= 2]]
    ]
  ],
  True,
  TestID -> "RandomInfraSphere-Separating-only-no-connected-requirement"
]

(* The count-less call is one certified minimal shell -- the peel run to a leaf.
   Count-less is ONE instance, so the instance is that shell's vertex list. *)

VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    With[{shell = RandomInfraSphere[g, 6, {1, 2},
            Properties -> {"Separating", "Connected"}]},
      MatchQ[shell, {__Integer}] && SeparatesQ[g, shell, 6, 16] ] ],
  True,
  TestID -> "RandomInfraSphere-countless-single-realisation"
]

(* the peel is LAZY, not lossy: it backtracks at each leaf, so a finite count is
   exact and All recovers the whole minimal class in any order. *)

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ], props = Properties -> { "Separating", "Connected" } },
    Sort[ Sort /@ RandomInfraSphere[ g, 6, { 1, 2 }, All, props ] ] ===
      Sort[ Sort /@ RandomInfraSphere[ g, 6, { 1, 2 }, All, props, "NextVertexFunction" -> RandomSample ] ] ],
  True,
  TestID -> "RandomInfraSphere-All-is-the-class-in-any-order"
]

(* RandomSample: the same peel drawn at random instead of in candidate order --
   the default unchanged, seeded reproducible, varies across seeds where the peel
   actually branches. *)

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    BlockRandom[
      RandomInfraSphere[ g, 6, { 1, 2 }, 1, Properties -> { "Separating", "Connected" } ],
      RandomSeeding -> 4 ] ===
    BlockRandom[
      RandomInfraSphere[ g, 6, { 1, 2 }, 1, Properties -> { "Separating", "Connected" } ],
      RandomSeeding -> 4 ]
  ],
  True,
  TestID -> "RandomInfraSphere-default-is-seeded"
]

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ], all = RandomInfraSphere[ GridGraph[ { 4, 4 } ], 6, { 1, 2 }, All ] },
    RandomInfraSphere[ g, 6, { 1, 2 }, "NextVertexFunction" -> Identity ] === First @ all ],
  True,
  TestID -> "RandomInfraSphere-Identity-preserves-first-member"
]

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    BlockRandom[ RandomInfraSphere[ g, 6, { 1, 2 }, 1, Properties -> { "Separating", "Connected" }, "NextVertexFunction" -> RandomSample ], RandomSeeding -> 4 ] ===
      BlockRandom[ RandomInfraSphere[ g, 6, { 1, 2 }, 1, Properties -> { "Separating", "Connected" }, "NextVertexFunction" -> RandomSample ], RandomSeeding -> 4 ]
  ],
  True,
  TestID -> "RandomInfraSphere-RandomSample-seeded-reproducible"
]

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    Length @ DeleteDuplicates @ Table[
      BlockRandom[ First @ RandomInfraSphere[ g, 6, { 1, 2 }, 1, Properties -> { "Separating", "Connected" }, "NextVertexFunction" -> RandomSample ], RandomSeeding -> s ],
      { s, 1, 10 } ]
  ],
  _Integer?( # > 1 & ),
  SameTest -> MatchQ,
  TestID -> "RandomInfraSphere-RandomSample-varies-across-seeds"
]

VerificationTest[
  Length @ RandomInfraSphere[GridGraph[{4, 4}], 6, {1, 2}, All,
    Properties -> {"Separating"}, "NextVertexFunction" -> ( RandomSample[ #, UpTo[ 1 ] ] & )] >= 1,
  True,
  TestID -> "RandomInfraSphere-one-branch-per-node-runs"
]

VerificationTest[
  Length @ DeleteDuplicates @ Table[
    BlockRandom[ RandomInfraSphere[ GridGraph[ { 4, 4 } ], 6, { 1, 2 }, Properties -> { "Separating", "Connected" } ],
      RandomSeeding -> s ],
    { s, 1, 8 } ] > 1,
  True,
  TestID -> "RandomInfraSphere-default-varies-across-seeds"
]


(* ===== The head: a family read through the exhaustive search ===== *)

(* T is admissible iff Subgraph[g, T] is connected and, after deleting T, the component of c lies within the mid-radius and every other vertex beyond it *)
sphereMemberQ[ g_, c_, { r_, s_ }, t_ ] :=
  With[ { rest = VertexDelete[ g, t ], radius = Mean[ { r, s } ] },
    { side = SelectFirst[ ConnectedComponents[ rest ], MemberQ[ #, c ] & ] },
    t =!= { } && ConnectedGraphQ @ Subgraph[ g, t ] && ListQ[ side ] &&
      AllTrue[ side, GraphDistance[ g, c, # ] <= radius & ] &&
      AllTrue[ Complement[ VertexList @ rest, side ], GraphDistance[ g, c, # ] > radius & ] ]

sphereMinimalQ[ g_, c_, band_, t_ ] :=
  sphereMemberQ[ g, c, band, t ] && NoneTrue[ t, v |-> sphereMemberQ[ g, c, band, DeleteCases[ t, v ] ] ]

VerificationTest[
  With[ { g = GridGraph[ { 7, 7 } ] },
    { members = RandomInfraSphere[ g, InfraSphere[ 25, { 2, 3 } ], All ] },
    { Length @ members, AllTrue[ members, t |-> sphereMinimalQ[ g, 25, { 2, 3 }, t ] ],
      AllTrue[ members, t |-> SubsetQ[ FindInfraShell[ g, 25, { 2, 3 } ], t ] ] } ],
  { 12, True, True },
  TestID -> "InfraSphere-7x7-members-connected-separating-minimal"
]

VerificationTest[
  With[ { g = InfraSubstrate[ "HexagonalTilingGraph", "Small" ] },
    { c = First @ GraphCenter[ g ] },
    { members = RandomInfraSphere[ g, InfraSphere[ c, { 2, 4 } ], UpTo[ 3 ] ] },
    { Length @ members, AllTrue[ members, t |-> sphereMinimalQ[ g, c, { 2, 4 }, t ] ] } ],
  { 3, True },
  TestID -> "InfraSphere-hexagonal-members-connected-separating-minimal"
]

(* on the thin torus C3 x C12 the band {2, 3} has one piece on each side of the centre, so no connected subset of it separates *)
VerificationTest[
  With[ { g = IndexGraph @ GraphProduct[ CycleGraph[ 3 ], CycleGraph[ 12 ], "Cartesian" ] },
    { RandomInfraSphere[ g, 1, { 2, 3 }, All ], RandomInfraSphere[ g, InfraSphere[ 1, { 2, 3 } ] ],
      InfraMeasurement[ g, InfraSphere[ 1, { 2, 3 } ], { "Cardinality", "VertexDensity" } ] } ],
  { { }, { }, <| "Cardinality" -> 0, "VertexDensity" -> <| |> |> },
  TestID -> "InfraSphere-wrapped-torus-band-is-empty"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    { members = RandomInfraSphere[ g, 13, { 1, 2 }, All ] },
    { InfraMeasurement[ g, InfraSphere[ 13, { 1, 2 } ], "Cardinality" ] === Length @ members,
      InfraMeasurement[ g, InfraSphere[ 13, { 1, 2 } ], "VertexDensity" ] === KeySort @ Counts @ Catenate @ members,
      Total @ InfraMeasurement[ g, InfraSphere[ 13, { 1, 2 } ], "EdgeDensity" ] === Total[ EdgeCount @ Subgraph[ g, # ] & /@ members ],
      InfraMeasurement[ g, InfraSphere[ 13, { 1, 2 } ], "CountingMeasure" ] === Length @ Union @ Catenate @ members } ],
  { True, True, True, True },
  TestID -> "InfraSphere-5x5-family-cardinality-and-densities"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    { Keys @ InfraMeasurement[ g, InfraSphere[ 13, { 1, 2 } ], All ],
      InfraMeasurement[ g, InfraSphere[ 13, { 1, 2 } ], "Faithful" ] } ],
  { { "Faithful", "Cardinality", "VertexDensity", "EdgeDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure" },
    Undetermined },
  TestID -> "InfraSphere-All-seven-properties-not-faithful"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    { InfraMeasurement[ g, InfraSphere[ 13, { 1, 2 } ], "Graph" ], InfraMeasurement[ g, InfraSphere[ 13, { 1, 2 } ], "Length" ] } ],
  { InfraMeasurement[ GridGraph[ { 5, 5 } ], InfraSphere[ 13, { 1, 2 } ], "Graph" ],
    InfraMeasurement[ GridGraph[ { 5, 5 } ], InfraSphere[ 13, { 1, 2 } ], "Length" ] },
  TestID -> "InfraSphere-Graph-and-Length-stay-unevaluated"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    { BlockRandom[ RandomInfraSphere[ g, InfraSphere[ 13, { 1, 2 } ] ], RandomSeeding -> 1 ] ===
        BlockRandom[ RandomInfraSphere[ g, 13, { 1, 2 } ], RandomSeeding -> 1 ],
      RandomInfraSphere[ g, InfraSphere[ 13, { 1, 2 } ], All ] === RandomInfraSphere[ g, 13, { 1, 2 }, All ],
      SubsetQ[ RandomInfraSphere[ g, 13, { 1, 2 }, All ], BlockRandom[ RandomInfraSphere[ g, InfraSphere[ 13, { 1, 2 } ], 3 ], RandomSeeding -> 1 ] ],
      Sort @ RandomInfraSphere[ g, InfraSphere[ 13, { 1, 2 } ], All, "NextVertexFunction" -> Identity ] ===
        Sort @ RandomInfraSphere[ g, 13, { 1, 2 }, All ] } ],
  { True, True, True, True },
  TestID -> "InfraSphere-representative-translates-the-sampler-options"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    RandomInfraSphere[ g, 13, 2, All, Properties -> { } ] === { FindInfraShell[ g, 13, 2 ] } ],
  True,
  TestID -> "RandomInfraSphere-without-Properties-is-the-level-set"
]

VerificationTest[
  Head @ InfraSubstrateHighlight[ GridGraph[ { 5, 5 } ], { InfraSphere[ 13, { 1, 2 } ], RandomInfraSphere[ GridGraph[ { 5, 5 } ], InfraSphere[ 13, { 1, 2 } ] ] } ],
  Graph,
  TestID -> "InfraSphere-draws"
]

EndTestSection[]
