BeginTestSection["InfraSphere"]

(* the brute-force sphere: every subset S of the band L = { v != c : r <= d(c, v) <= s } that separates c from { v : d(c, v) > s }
   and has no separating subset S - v; under "Connected" the connected ones among them *)
sphereOracle[ g_Graph, c_, r_, properties_ ] :=
  With[ { range = Replace[ r, d_?NumericQ :> { d, d } ], dist = AssociationThread[ VertexList[ g ], GraphDistance[ g, c ] ] },
    { band = Select[ VertexList[ g ], v |-> v =!= c && range[[ 1 ]] <= dist[ v ] <= range[[ 2 ]] ],
      exterior = Select[ VertexList[ g ], v |-> dist[ v ] > range[[ 2 ]] ] },
    { separatesQ = set |-> ! IntersectingQ[ VertexComponent[ VertexDelete[ g, set ], c ], exterior ] },
    Sort[ Sort /@ Select[ Subsets[ band ], set |-> separatesQ[ set ] && NoneTrue[ set, v |-> separatesQ[ DeleteCases[ set, v ] ] ] &&
      ( ! MemberQ[ properties, "Connected" ] || set =!= { } && ConnectedGraphQ @ Subgraph[ g, set ] ) ] ] ]

sphereCases = Join[
  Flatten[ Table[ { GridGraph[ { 5, 5 } ], c, b }, { c, { 13, 7, 1 } }, { b, { 1, 2, 3, { 0, 1 }, { 1, 2 } } } ], 1 ],
  { { GridGraph[ { 5, 5 } ], 1, { 2, 3 } }, { GridGraph[ { 5, 5 } ], 7, { 2, 3 } } },
  Table[ { PetersenGraph[ ], 1, b }, { b, { 0, 1, 2, { 0, 1 }, { 1, 2 } } } ],
  Table[ { InfraSubstrate[ "SquareMeshGraph", "Small" ], 5, b }, { b, { 1, 2, { 0, 1 } } } ] ];

(* ===== the class: minimal separators of the centre from the exterior inside the band ===== *)

VerificationTest[
  Select[ sphereCases, Apply[ { g, c, b } |->
    Sort @ RandomInfraSphere[ g, c, b, All, Properties -> { "Separating" } ] =!= sphereOracle[ g, c, b, { "Separating" } ] ] ],
  { },
  TestID -> "RandomInfraSphere-Separating-is-every-minimal-separator-in-the-band"
]

VerificationTest[
  Select[ sphereCases, Apply[ { g, c, b } |->
    Sort @ RandomInfraSphere[ g, c, b, All, Properties -> { "Separating", "Connected" } ] =!=
      sphereOracle[ g, c, b, { "Separating", "Connected" } ] ] ],
  { },
  TestID -> "RandomInfraSphere-Separating-Connected-is-every-connected-minimal-separator-in-the-band"
]

VerificationTest[
  Table[ With[ { g = InfraSubstrate[ name, "Small" ] }, { c = First @ GraphCenter[ g ] },
      { separating = RandomInfraSphere[ g, c, b, All, Properties -> { "Separating" } ] },
      { Length @ separating, RandomInfraSphere[ g, c, b, All ] === Select[ separating, ConnectedGraphQ @ Subgraph[ g, # ] & ] } ],
    { name, { "SquareGridGraph", "SquareMeshGraph" } }, { b, { { 1, 2 }, { 2, 3 } } } ],
  { { { 16, True }, { 161, True } }, { { 60, True }, { 2100, True } } },
  TestID -> "RandomInfraSphere-Connected-filters-the-minimal-separators"
]

(* the square grid is 4-connected: a connected separating ring has a removable corner, so no minimal separator of a band is connected *)
VerificationTest[
  With[ { g = InfraSubstrate[ "SquareGridGraph", "Small" ] }, { c = First @ GraphCenter[ g ] },
    { Length /@ { RandomInfraSphere[ g, c, { 3, 4 }, All, Properties -> { "Separating" } ], RandomInfraSphere[ g, c, { 3, 4 }, All ] },
      Union[ Length /@ RandomInfraSphere[ g, c, { 2, 3 }, All, Properties -> { "Separating" } ] ] } ],
  { { 1102, 0 }, { 8, 9, 10, 11, 12 } },
  TestID -> "RandomInfraSphere-grid-has-no-connected-minimal-separator"
]

(* on the mesh a shell of radius 1 to 4 about the centre is a ring, and it is its own unique sphere *)
VerificationTest[
  With[ { g = InfraSubstrate[ "SquareMeshGraph", "Small" ] },
    Table[ RandomInfraSphere[ g, 5, r, All ] === { Keys @ InfraMeasurement[ g, InfraShell[ 5, r ], "VertexDensity" ] }, { r, 1, 4 } ] ],
  { True, True, True, True },
  TestID -> "RandomInfraSphere-mesh-shell-is-its-own-sphere"
]

(* a connected separating set of the 5 x 5 grid band {1, 2} with no removable vertex keeping it connected and separating strictly
   contains a minimal separator; none of the sixteen minimal separators is connected *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    { band = Select[ VertexList[ g ], 1 <= GraphDistance[ g, 13, # ] <= 2 & ],
      exterior = Select[ VertexList[ g ], GraphDistance[ g, 13, # ] > 2 & ] },
    { admissibleQ = set |-> set =!= { } && ConnectedGraphQ @ Subgraph[ g, set ] &&
        ! IntersectingQ[ VertexComponent[ VertexDelete[ g, set ], 13 ], exterior ] },
    { peeled = Select[ Subsets[ band ], set |-> admissibleQ[ set ] && NoneTrue[ set, v |-> admissibleQ[ DeleteCases[ set, v ] ] ] ],
      minimal = RandomInfraSphere[ g, 13, { 1, 2 }, All, Properties -> { "Separating" } ] },
    { Length @ peeled, Length @ minimal, RandomInfraSphere[ g, 13, { 1, 2 }, All ],
      AllTrue[ peeled, set |-> ! MemberQ[ minimal, set ] && AnyTrue[ minimal, SubsetQ[ set, # ] & ] ] } ],
  { 4, 16, { }, True },
  TestID -> "RandomInfraSphere-connected-irreducible-separators-are-not-minimal"
]

(* ===== edge cases ===== *)

(* the band of radii 1 and 2 of the Petersen graph is everything but the centre: the empty set separates the centre from nothing *)
VerificationTest[
  { RandomInfraSphere[ PetersenGraph[ ], 1, { 1, 2 }, All, Properties -> { "Separating" } ], RandomInfraSphere[ PetersenGraph[ ], 1, { 1, 2 }, All ],
    RandomInfraSphere[ PathGraph[ Range[ 4 ] ], 2, 0, All, Properties -> { "Separating" } ],
    RandomInfraSphere[ PathGraph[ Range[ 5 ] ], 3, 1, All ] },
  { { { } }, { }, { }, { } },
  TestID -> "RandomInfraSphere-empty-exterior-and-no-separator"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    RandomInfraSphere[ g, 13, 2, All, Properties -> { } ] === { Keys @ InfraMeasurement[ g, InfraShell[ 13, 2 ], "VertexDensity" ] } ],
  True,
  TestID -> "RandomInfraSphere-without-Properties-is-the-level-set"
]

(* ===== counts and sampling ===== *)

VerificationTest[
  With[ { g = InfraSubstrate[ "SquareMeshGraph", "Small" ] },
    { all = RandomInfraSphere[ g, 5, { 1, 2 }, All ] },
    { all === Sort @ all, MemberQ[ all, RandomInfraSphere[ g, 5, { 1, 2 }, RandomSeeding -> 1 ] ],
      Length @ RandomInfraSphere[ g, 5, { 1, 2 }, 5, RandomSeeding -> 1 ],
      SubsetQ[ all, RandomInfraSphere[ g, 5, { 1, 2 }, 5, RandomSeeding -> 1 ] ],
      Length @ RandomInfraSphere[ g, 5, { 1, 2 }, UpTo[ 100 ], RandomSeeding -> 1 ], RandomInfraSphere[ g, 5, { 1, 2 }, 61, RandomSeeding -> 1 ],
      RandomInfraSphere[ g, 5, { 1, 2 }, "NextVertexFunction" -> Identity ] === First @ all } ],
  { True, True, 5, True, 60, { }, True },
  TestID -> "RandomInfraSphere-All-sorted-counts-and-Identity"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ], opts = Sequence[ Properties -> { "Separating" } ] },
    { RandomInfraSphere[ g, 13, { 1, 2 }, 3, opts, RandomSeeding -> 4 ] === RandomInfraSphere[ g, 13, { 1, 2 }, 3, opts, RandomSeeding -> 4 ],
      BlockRandom[ RandomInfraSphere[ g, 13, { 1, 2 }, opts, RandomSeeding -> None ], RandomSeeding -> 4 ] ===
        RandomInfraSphere[ g, 13, { 1, 2 }, opts, RandomSeeding -> 4 ],
      Sort @ RandomInfraSphere[ g, 13, { 1, 2 }, All, opts, "NextVertexFunction" -> RandomSample, RandomSeeding -> 4 ] ===
        RandomInfraSphere[ g, 13, { 1, 2 }, All, opts ] } ],
  { True, True, True },
  TestID -> "RandomInfraSphere-seeded-reproducible"
]

(* one draw is uniform over the class: 800 seeded draws from the sixteen minimal separators of the 5 x 5 grid hit each 50 +- 25 times *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    { draws = Table[ RandomInfraSphere[ g, 13, { 1, 2 }, Properties -> { "Separating" }, RandomSeeding -> s ], { s, 800 } ] },
    { Sort @ DeleteDuplicates @ draws === RandomInfraSphere[ g, 13, { 1, 2 }, All, Properties -> { "Separating" } ],
      AllTrue[ Counts @ draws, 25 <= # <= 75 & ] } ],
  { True, True },
  TestID -> "RandomInfraSphere-one-draw-is-uniform-over-the-class"
]

VerificationTest[
  Length @ RandomInfraSphere[ GridGraph[ { 4, 4 } ], 6, { 1, 2 }, All,
    Properties -> { "Separating" }, "NextVertexFunction" -> ( RandomSample[ #, UpTo[ 1 ] ] & ), RandomSeeding -> 1 ],
  1,
  TestID -> "RandomInfraSphere-NextVertexFunction-chooses-the-members"
]

(* ===== the head: a family read through the exhaustive search ===== *)

VerificationTest[
  With[ { g = InfraSubstrate[ "HexagonalTilingGraph", "Small" ] },
    { c = First @ GraphCenter[ g ] },
    { members = RandomInfraSphere[ g, InfraSphere[ c, { 2, 4 } ], UpTo[ 3 ], Properties -> { "Separating" }, RandomSeeding -> 1 ],
      band = Select[ VertexList[ g ], 2 <= GraphDistance[ g, c, # ] <= 4 & ],
      exterior = Select[ VertexList[ g ], GraphDistance[ g, c, # ] > 4 & ] },
    { separatesQ = set |-> ! IntersectingQ[ VertexComponent[ VertexDelete[ g, set ], c ], exterior ] },
    { Length @ members,
      AllTrue[ members, set |-> SubsetQ[ band, set ] && separatesQ[ set ] && NoneTrue[ set, v |-> separatesQ[ DeleteCases[ set, v ] ] ] ] } ],
  { 3, True },
  TestID -> "InfraSphere-hexagonal-members-are-minimal-separators"
]

(* on the thin torus C3 x C12 the band {2, 3} has one piece on each side of the centre, so no connected subset of it separates *)
VerificationTest[
  With[ { g = IndexGraph @ GraphProduct[ CycleGraph[ 3 ], CycleGraph[ 12 ], "Cartesian" ] },
    { RandomInfraSphere[ g, 1, { 2, 3 }, All ], RandomInfraSphere[ g, InfraSphere[ 1, { 2, 3 } ] ],
      InfraMeasurement[ g, InfraSphere[ 1, { 2, 3 } ], { "Cardinality", "VertexDensity" } ],
      Min[ Length @ ConnectedComponents @ Subgraph[ g, # ] & /@ RandomInfraSphere[ g, 1, { 2, 3 }, All, Properties -> { "Separating" } ] ] } ],
  { { }, { }, <| "Cardinality" -> 0, "VertexDensity" -> <| |> |>, 2 },
  TestID -> "InfraSphere-wrapped-torus-band-is-empty"
]

VerificationTest[
  With[ { g = InfraSubstrate[ "SquareMeshGraph", "Small" ] },
    { members = RandomInfraSphere[ g, 5, { 1, 2 }, All ] },
    { InfraMeasurement[ g, InfraSphere[ 5, { 1, 2 } ], "Cardinality" ] === Length @ members,
      InfraMeasurement[ g, InfraSphere[ 5, { 1, 2 } ], "VertexDensity" ] === KeySort @ Counts @ Catenate @ members,
      Total @ InfraMeasurement[ g, InfraSphere[ 5, { 1, 2 } ], "EdgeDensity" ] === Total[ EdgeCount @ Subgraph[ g, # ] & /@ members ],
      InfraMeasurement[ g, InfraSphere[ 5, { 1, 2 } ], "CountingMeasure" ] === Length @ Union @ Catenate @ members } ],
  { True, True, True, True },
  TestID -> "InfraSphere-mesh-family-cardinality-and-densities"
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
  With[ { g = InfraSubstrate[ "SquareMeshGraph", "Small" ] },
    { RandomInfraSphere[ g, InfraSphere[ 5, { 1, 2 } ], RandomSeeding -> 1 ] === RandomInfraSphere[ g, 5, { 1, 2 }, RandomSeeding -> 1 ],
      RandomInfraSphere[ g, InfraSphere[ 5, { 1, 2 } ], All ] === RandomInfraSphere[ g, 5, { 1, 2 }, All ],
      RandomInfraSphere[ g, InfraSphere[ 5, { 1, 2 } ], 3, RandomSeeding -> 1 ] === RandomInfraSphere[ g, 5, { 1, 2 }, 3, RandomSeeding -> 1 ],
      RandomInfraSphere[ g, InfraSphere[ 5, { 1, 2 } ], All, Properties -> { "Separating" } ] ===
        RandomInfraSphere[ g, 5, { 1, 2 }, All, Properties -> { "Separating" } ] } ],
  { True, True, True, True },
  TestID -> "InfraSphere-representative-translates-the-sampler-options"
]

VerificationTest[
  Head @ InfraSubstrateHighlight[ InfraSubstrate[ "SquareMeshGraph", "Small" ],
    { InfraSphere[ 5, { 1, 2 } ],
      RandomInfraSphere[ InfraSubstrate[ "SquareMeshGraph", "Small" ], InfraSphere[ 5, { 1, 2 } ], RandomSeeding -> 1 ] } ],
  Graph,
  TestID -> "InfraSphere-draws"
]

(* the members of a sphere are its connected minimal separators; the whole band separates but is not minimal *)
VerificationTest[
  With[ { g = InfraSubstrate[ "SquareMeshGraph", "Small" ] },
    { AllTrue[ RandomInfraSphere[ g, InfraSphere[ 5, { 1, 2 } ], All ], InfraMemberQ[ g, InfraSphere[ 5, { 1, 2 } ], # ] & ],
      InfraMemberQ[ g, InfraSphere[ 5, { 1, 2 } ], Reverse @ Keys @ InfraMeasurement[ g, InfraShell[ 5, 2 ], "VertexDensity" ] ],
      InfraMemberQ[ g, InfraSphere[ 5, { 1, 2 } ], Keys @ InfraMeasurement[ g, InfraShell[ 5, { 1, 2 } ], "VertexDensity" ] ] } ],
  { True, True, False },
  TestID -> "InfraMemberQ-sphere-members-are-its-family"
]

EndTestSection[]
