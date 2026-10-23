BeginTestSection["InfraSphere"]

(* the band B = { v != c : r <= d(c, v) <= s }; T separates when every path from c to { v : d(c, v) > s } meets T *)
sphereBand[ g_, c_, { r_, s_ } ] := Select[ DeleteCases[ VertexList[ g ], c ], r <= GraphDistance[ g, c, # ] <= s & ]

sphereSeparatesQ[ g_, c_, s_, t_ ] := AllTrue[ VertexComponent[ VertexDelete[ g, t ], c ], GraphDistance[ g, c, # ] <= s & ]

(* the brute-force oracle: the inclusion-minimal members of the subsets of B that separate (and are connected) *)
sphereOracle[ g_, c_, band_, connected_ ] :=
  With[ { admissible = Select[ Subsets[ sphereBand[ g, c, band ] ],
      t |-> ( ! connected || ConnectedGraphQ @ Subgraph[ g, t ] ) && sphereSeparatesQ[ g, c, Last @ band, t ] ] },
    Sort[ Sort /@ Fold[ { minimal, t } |-> If[ AnyTrue[ minimal, SubsetQ[ t, # ] & ], minimal, Append[ minimal, t ] ], { }, admissible ] ] ]

$sphereCases := {
  { GridGraph[ { 5, 5 } ], 13, { { 1, 1 }, { 1, 2 }, { 2, 2 }, { 2, 3 } } },
  { GridGraph[ { 5, 5 } ], 7, { { 1, 2 }, { 2, 3 } } },
  { PetersenGraph[ ], 1, { { 1, 1 }, { 1, 2 }, { 2, 2 } } },
  { InfraSubstrate[ "SquareMeshGraph", "Small" ], 5, { { 1, 1 }, { 2, 2 } } },
  { IndexGraph @ GraphProduct[ CycleGraph[ 3 ], CycleGraph[ 3 ], "Cartesian" ], 1, { { 1, 1 }, { 1, 2 } } } }

(* ===== The walls: Properties -> {"Separating", "Connected"} ===== *)

VerificationTest[
  Flatten @ Table[ With[ { g = case[[ 1 ]], c = case[[ 2 ]] },
      RandomInfraSphere[ g, c, band, All ] === sphereOracle[ g, c, band, True ] ], { case, $sphereCases }, { band, case[[ 3 ]] } ],
  ConstantArray[ True, 13 ],
  TestID -> "RandomInfraSphere-All-is-every-wall-of-the-band"
]

VerificationTest[
  Flatten @ Table[ With[ { g = case[[ 1 ]], c = case[[ 2 ]] },
      RandomInfraSphere[ g, c, band, All, Properties -> { "Separating" } ] === sphereOracle[ g, c, band, False ] ],
    { case, $sphereCases }, { band, case[[ 3 ]] } ],
  ConstantArray[ True, 13 ],
  TestID -> "RandomInfraSphere-Separating-All-is-every-minimal-separator"
]

(* the 3 x 3 torus: about 1 the shell of radius 1 is two edges, not connected; the band {1, 2} is everything, so the empty set separates *)
VerificationTest[
  With[ { g = IndexGraph @ GraphProduct[ CycleGraph[ 3 ], CycleGraph[ 3 ], "Cartesian" ] },
    { RandomInfraSphere[ g, 1, 1, All ], RandomInfraSphere[ g, 1, { 1, 2 }, All ], Length @ RandomInfraSphere[ g, 1, 1, All, Properties -> { "Separating" } ] } ],
  { { }, { { } }, 1 },
  TestID -> "RandomInfraSphere-3x3-torus"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    { walls = Join[ RandomInfraSphere[ g, 13, { 1, 2 }, All ], RandomInfraSphere[ g, 13, { 2, 3 }, All ] ] },
    AllTrue[ Range[ 30 ], s |-> MemberQ[ walls, RandomInfraSphere[ g, 13, { 1, 2 }, RandomSeeding -> s ] ] &&
      MemberQ[ walls, RandomInfraSphere[ g, 13, { 2, 3 }, RandomSeeding -> s ] ] ] ],
  True,
  TestID -> "RandomInfraSphere-every-greedy-draw-is-a-wall"
]

VerificationTest[
  With[ { g = PetersenGraph[ ], m = InfraSubstrate[ "SquareMeshGraph", "Small" ] },
    { AllTrue[ RandomInfraSphere[ g, 1, { 1, 2 }, UpTo[ 5 ], RandomSeeding -> 3 ], MemberQ[ sphereOracle[ g, 1, { 1, 2 }, True ], # ] & ],
      AllTrue[ RandomInfraSphere[ m, 5, 2, UpTo[ 5 ], RandomSeeding -> 3 ], MemberQ[ sphereOracle[ m, 5, { 2, 2 }, True ], # ] & ] } ],
  { True, True },
  TestID -> "RandomInfraSphere-greedy-draws-on-Petersen-and-mesh-are-walls"
]

VerificationTest[
  With[ { g = InfraSubstrate[ "SquareGridGraph", "Small" ] },
    { draws = RandomInfraSphere[ g, 45, { 3, 4 }, 4, RandomSeeding -> 1 ] },
    { Length @ draws, DuplicateFreeQ @ draws,
      Sort @ RandomInfraSphere[ GridGraph[ { 5, 5 } ], 13, { 1, 2 }, UpTo[ 100 ], RandomSeeding -> 1 ] === RandomInfraSphere[ GridGraph[ { 5, 5 } ], 13, { 1, 2 }, All ],
      RandomInfraSphere[ GridGraph[ { 5, 5 } ], 13, { 1, 2 }, 5 ] } ],
  { 4, True, True, { } },
  TestID -> "RandomInfraSphere-a-count-gives-distinct-walls"
]

VerificationTest[
  With[ { g = InfraSubstrate[ "SquareGridGraph", "Small" ] },
    { RandomInfraSphere[ g, 45, { 2, 3 }, RandomSeeding -> 7 ] === RandomInfraSphere[ g, 45, { 2, 3 }, RandomSeeding -> 7 ],
      RandomInfraSphere[ g, 45, { 2, 3 }, 3, RandomSeeding -> "a" ] === RandomInfraSphere[ g, 45, { 2, 3 }, 3, RandomSeeding -> "a" ],
      Length @ DeleteDuplicates @ Table[ RandomInfraSphere[ g, 45, { 3, 4 }, RandomSeeding -> s ], { s, 10 } ] > 1 } ],
  { True, True, True },
  TestID -> "RandomInfraSphere-seeded-reproducible-and-varies"
]

VerificationTest[
  With[ { g = InfraSubstrate[ "SquareGridGraph", "Small" ] },
    { wall = RandomInfraSphere[ g, 45, { 2, 3 }, "NextVertexFunction" -> Identity ] },
    { ends = Pick[ wall, VertexDegree[ Subgraph[ g, wall ], # ] & /@ wall, 1 ] },
    { Length @ wall, ConnectedGraphQ @ Subgraph[ g, wall ],
      PathGraphQ @ Subgraph[ g, wall ] && GraphDistance[ g, First @ ends, Last @ ends ] == 2, sphereSeparatesQ[ g, 45, 3, wall ],
      SubsetQ[ sphereBand[ g, 45, { 2, 3 } ], wall ], InfraMemberQ[ g, InfraSphere[ 45, { 2, 3 } ], wall ] } ],
  { 15, True, True, True, True, True },
  TestID -> "RandomInfraSphere-Small-grid-band-2-3-is-a-15-vertex-zigzag-loop"
]

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    { first = RandomInfraSphere[ g, 6, { 1, 2 }, "NextVertexFunction" -> Identity ] },
    { first === RandomInfraSphere[ g, 6, { 1, 2 }, "NextVertexFunction" -> Identity, RandomSeeding -> 99 ],
      { first } === RandomInfraSphere[ g, 6, { 1, 2 }, 1, "NextVertexFunction" -> Identity ],
      MemberQ[ RandomInfraSphere[ g, 6, { 1, 2 }, All ], first ] } ],
  { True, True, True },
  TestID -> "RandomInfraSphere-Identity-is-deterministic"
]

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ], props = Properties -> { "Separating", "Connected" } },
    RandomInfraSphere[ g, 6, { 1, 2 }, All, props ] === RandomInfraSphere[ g, 6, { 1, 2 }, All, props, "NextVertexFunction" -> RandomSample ] ],
  True,
  TestID -> "RandomInfraSphere-All-is-the-class-in-any-order"
]

VerificationTest[
  Table[ With[ { g = InfraSubstrate[ name, size ] }, { c = First @ GraphCenter[ g ] },
      First @ AbsoluteTiming[ RandomInfraSphere[ g, c, { 3, 4 }, RandomSeeding -> 1 ] ] < 1 ],
    { name, { "SquareGridGraph", "SquareMeshGraph" } }, { size, { "Small", "Medium" } } ],
  { { True, True }, { True, True } },
  TestID -> "RandomInfraSphere-one-draw-is-quick"
]

VerificationTest[
  Length @ RandomInfraSphere[ GridGraph[ { 4, 4 } ], 6, { 1, 2 }, All,
    Properties -> { "Separating" }, "NextVertexFunction" -> ( RandomSample[ #, UpTo[ 1 ] ] & ) ] >= 1,
  True,
  TestID -> "RandomInfraSphere-one-branch-per-node-runs"
]

VerificationTest[
  With[ { g = InfraSubstrate[ "SquareGridGraph", "Small" ] },
    { RandomInfraSphere[ g, 45, 3, RandomSeeding -> 1 ], Length @ RandomInfraSphere[ g, 45, 3, Properties -> { "Separating" }, RandomSeeding -> 1 ] } ],
  { { }, 12 },
  TestID -> "RandomInfraSphere-grid-shell-separates-but-is-no-wall"
]

(* ===== The head: a family read through the exhaustive search ===== *)

(* T is a wall iff it lies in the band, is connected and separates, and no vertex can leave it with both kept *)
sphereWallQ[ g_, c_, band_, t_ ] :=
  With[ { okQ = u |-> ConnectedGraphQ @ Subgraph[ g, u ] && sphereSeparatesQ[ g, c, Last @ band, u ] },
    SubsetQ[ sphereBand[ g, c, band ], t ] && okQ[ t ] && NoneTrue[ t, v |-> okQ[ DeleteCases[ t, v ] ] ] ]

VerificationTest[
  With[ { g = GridGraph[ { 7, 7 } ] },
    { members = RandomInfraSphere[ g, InfraSphere[ 25, { 2, 3 } ], All ] },
    { Length @ members, AllTrue[ members, t |-> sphereWallQ[ g, 25, { 2, 3 }, t ] ] } ],
  { 12, True },
  TestID -> "InfraSphere-7x7-members-are-walls"
]

VerificationTest[
  With[ { g = InfraSubstrate[ "HexagonalTilingGraph", "Small" ] },
    { c = First @ GraphCenter[ g ] },
    { members = RandomInfraSphere[ g, InfraSphere[ c, { 2, 4 } ], UpTo[ 3 ] ] },
    { Length @ members, AllTrue[ members, t |-> sphereWallQ[ g, c, { 2, 4 }, t ] ] } ],
  { 3, True },
  TestID -> "InfraSphere-hexagonal-members-are-walls"
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
  Replace[
    With[ { g = GridGraph[ { 5, 5 } ] },
    { Keys @ InfraMeasurement[ g, InfraSphere[ 13, { 1, 2 } ], All ],
      InfraMeasurement[ g, InfraSphere[ 13, { 1, 2 } ], "Faithful" ] } ],
    HoldPattern[ InfraMeasurement[ _Graph, _, "Faithful" ] ] :> Missing[ "NotCertified" ], { 0, Infinity } ],
  { { "Faithful", "Cardinality", "VertexDensity", "EdgeDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure" },
    Missing[ "NotCertified" ] },
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
    { BlockRandom[ RandomInfraSphere[ g, InfraSphere[ 13, { 1, 2 } ], RandomSeeding -> None ], RandomSeeding -> 1 ] ===
        BlockRandom[ RandomInfraSphere[ g, 13, { 1, 2 }, RandomSeeding -> None ], RandomSeeding -> 1 ],
      RandomInfraSphere[ g, InfraSphere[ 13, { 1, 2 } ], All, RandomSeeding -> None ] === RandomInfraSphere[ g, 13, { 1, 2 }, All, RandomSeeding -> None ],
      SubsetQ[ RandomInfraSphere[ g, 13, { 1, 2 }, All, RandomSeeding -> None ], BlockRandom[ RandomInfraSphere[ g, InfraSphere[ 13, { 1, 2 } ], 3, RandomSeeding -> None ], RandomSeeding -> 1 ] ],
      Sort @ RandomInfraSphere[ g, InfraSphere[ 13, { 1, 2 } ], All, "NextVertexFunction" -> Identity, RandomSeeding -> None ] ===
        Sort @ RandomInfraSphere[ g, 13, { 1, 2 }, All, RandomSeeding -> None ] } ],
  { True, True, True, True },
  TestID -> "InfraSphere-representative-translates-the-sampler-options"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    RandomInfraSphere[ g, 13, 2, All, Properties -> { } ] === { Keys @ InfraMeasurement[ g, InfraShell[ 13, 2 ], "VertexDensity" ] } ],
  True,
  TestID -> "RandomInfraSphere-without-Properties-is-the-level-set"
]

VerificationTest[
  Head @ InfraSubstrateHighlight[ GridGraph[ { 5, 5 } ], { InfraSphere[ 13, { 1, 2 } ], RandomInfraSphere[ GridGraph[ { 5, 5 } ], InfraSphere[ 13, { 1, 2 } ] ] } ],
  Graph,
  TestID -> "InfraSphere-draws"
]

(* the members of a sphere are its walls; the whole band separates but is not minimal, a disconnected separator is no member *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    { AllTrue[ RandomInfraSphere[ g, InfraSphere[ 13, { 1, 2 } ], All ], InfraMemberQ[ g, InfraSphere[ 13, { 1, 2 } ], # ] & ],
      InfraMemberQ[ g, InfraSphere[ 13, { 1, 2 } ], Reverse @ { 8, 9, 12, 14, 17, 18, 19 } ],
      InfraMemberQ[ g, InfraSphere[ 13, { 1, 2 } ], Keys @ InfraMeasurement[ g, InfraShell[ 13, { 1, 2 } ], "VertexDensity" ] ],
      InfraMemberQ[ g, InfraSphere[ 13, 1 ], { 8, 12, 14, 18 } ] } ],
  { True, True, False, False },
  TestID -> "InfraMemberQ-sphere-members-are-its-walls"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    Sort @ Select[ Subsets[ sphereBand[ g, 13, { 1, 2 } ], { 6, 8 } ], InfraMemberQ[ g, InfraSphere[ 13, { 1, 2 } ], # ] & ] ===
      Sort @ Select[ RandomInfraSphere[ g, 13, { 1, 2 }, All ], 6 <= Length[ # ] <= 8 & ] ],
  True,
  TestID -> "InfraMemberQ-sphere-agrees-with-the-family"
]

EndTestSection[]
