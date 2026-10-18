BeginTestSection[ "BallCover" ]

VerificationTest[
	{ BallCoverNumber[ CycleGraph[ 7 ], 2 ], BallCoverNumber[ PetersenGraph[] ], BallCoverNumber[ CompleteGraph[ 3 ], 1 ] },
	{ 2, 3, 1 },
	TestID -> "BallCoverNumber-known-domination-numbers"
]

VerificationTest[
	With[ { graph = CycleGraph[ 7 ] },
		{ BallCoverQ[ graph, 2, FindBallCover[ graph, 2 ] ], BallCoverQ[ graph, 1, { 1 } ] } ],
	{ True, False },
	TestID -> "BallCoverQ-feasibility-not-optimality"
]

VerificationTest[
	With[ { graph = GraphData[ "CuboctahedralGraph" ] },
		{ cover = FindBallCover[ graph, 1, Method -> "Greedy" ] },
		{ BallCoverNumber[ graph, 1 ], Length[ cover ], BallCoverQ[ graph, 1, cover ] } ],
	{ 3, 4, True },
	TestID -> "FindBallCover-greedy-is-feasible-upper-bound"
]

VerificationTest[
	With[ { graph = CycleGraph[ 4 ] },
		{ BallCoverNumber[ graph, 1, Method -> "IntegerLinearProgramming" ], BallCoverNumber[ graph, 1, Method -> "Exhaustive" ] } ],
	{ 2, 2 },
	TestID -> "BallCoverNumber-exact-methods-agree"
]

VerificationTest[
	With[ { graph = CompleteGraph[ 3 ] },
		And[
			MatchQ[ FindBallCover[ graph, 1, Method -> "Symmetric" ], _FindBallCover ],
			MatchQ[ FindBallCover[ graph, 1, Method -> "Unknown" ], _FindBallCover ],
			MatchQ[ BallCoverNumber[ graph, 1, Method -> "Greedy" ], _BallCoverNumber ],
			MatchQ[ BallCoverNumber[ graph, 1, Method -> "Symmetric" ], _BallCoverNumber ],
			MatchQ[ BallCoverNumber[ graph, 1, Method -> "Unknown" ], _BallCoverNumber ] ] ],
	True,
	TestID -> "BallCover-unsupported-methods-stay-symbolic"
]

VerificationTest[
	With[ { graph = CycleGraph[ 4 ] },
		And[
			MatchQ[ FindBallCover[ graph, 1, All, All, Method -> "Greedy" ], _FindBallCover ],
			MatchQ[ FindBallCover[ graph, 1, All, 1, Method -> "Greedy" ], _FindBallCover ],
			MatchQ[ FindBallCover[ graph, 1, All, 0, Method -> "Greedy" ], _FindBallCover ],
			MatchQ[ FindBallCover[ graph, 1, All, UpTo[ 0 ], Method -> "Greedy" ], _FindBallCover ] ] ],
	True,
	TestID -> "FindBallCover-greedy-refuses-every-explicit-count"
]

VerificationTest[
	With[ { graph = CompleteGraph[ 3 ] },
		{ FindBallCover[ graph, 1, All, All ], Length[ FindBallCover[ graph, 1, All, 1 ] ], FindBallCover[ graph, 1, All, 4 ],
			FindBallCover[ graph, 1, All, UpTo[ 4 ] ], FindBallCover[ graph, 1, All, 0 ], FindBallCover[ graph, 1, All, UpTo[ 0 ] ] } ],
	{ { { 1 }, { 2 }, { 3 } }, 1, { }, { { 1 }, { 2 }, { 3 } }, { }, { } },
	TestID -> "FindBallCover-count-contract"
]

VerificationTest[
	With[ { graph = CompleteGraph[ 3 ] },
		{ IntegerQ[ First[ FindBallCover[ graph, 1 ] ] ], FindBallCover[ graph, 1, 2, All ], BallCoverNumber[ graph, 0, 2 ] } ],
	{ True, { { 1 }, { 2 }, { 3 } }, 1 },
	TestID -> "FindBallCover-third-position-is-target-not-count"
]

VerificationTest[
	With[ { graph = StarGraph[ 4 ] },
		{ FindBallCover[ graph, 1, { 2, 3, 4 } ], BallCoverNumber[ graph, 1, { 2, 3, 4 } ],
			BallCoverNumber[ Subgraph[ graph, { 2, 3, 4 } ], 1 ] } ],
	{ { 1 }, 1, 3 },
	TestID -> "BallCover-target-allows-outside-centres"
]

VerificationTest[
	With[ { graph = Graph[ Catenate @ Table[ UndirectedEdge @@@ Partition[ Join[ { "c" }, Table[ { arm, i }, { i, 4 } ], { "h" } ], 2, 1 ],
		{ arm, 3 } ] ] },
		{ target = InfraBall[ "c", 4 ] },
		{ density = InfraMeasurement[ graph, target, "VertexDensity" ] },
		{ BallCoverNumber[ graph, 2, target ], BallCoverNumber[ Subgraph[ graph, Keys[ density ] ], 2 ] } ],
	{ 2, 3 },
	TestID -> "BallCover-ambient-ball-and-induced-ball-have-different-numbers"
]

VerificationTest[
	With[ { graph = PathGraph[ Range[ 7 ] ] },
		{ BallCoverNumber[ graph, 1, InfraBall[ 4, 2 ] ], BallCoverNumber[ graph, 1, { 2, 3, 4, 5, 6 } ],
			BallCoverNumber[ graph, 1, <| 2 -> 0, 3 -> 3, 4 -> -1, 5 -> 1, 6 -> 9 |> ],
			BallCoverNumber[ graph, 1, Subgraph[ graph, { 2, 3, 4, 5, 6 } ] ] } ],
	{ 2, 2, 2, 2 },
	TestID -> "BallCover-target-carriers-have-equal-support"
]

VerificationTest[
	With[ { graph = CycleGraph[ 4 ] },
		{ FindBallCover[ graph, 0 ], BallCoverNumber[ graph, 0 ], BallCoverQ[ graph, 0, { 1, 2, 3, 4 } ],
			BallCoverQ[ graph, 0, { 1, 2, 3 } ] } ],
	{ { 1, 2, 3, 4 }, 4, True, False },
	TestID -> "BallCover-radius-zero"
]

VerificationTest[
	With[ { graph = CycleGraph[ 3 ] },
		{ BallCoverNumber[ graph, 1, <| |> ], FindBallCover[ graph, 1, <| |> ], FindBallCover[ graph, 1, <| |>, 1 ],
			FindBallCover[ graph, 1, <| |>, 2 ], FindBallCover[ graph, 1, <| |>, UpTo[ 1 ] ], FindBallCover[ graph, 1, <| |>, All ],
			BallCoverQ[ graph, 1, { }, <| |> ], BallCoverQ[ graph, 1, { } ] } ],
	{ 0, { }, { { } }, { }, { { } }, { { } }, True, False },
	TestID -> "BallCover-empty-target-has-one-empty-minimum"
]

VerificationTest[
	With[ { graph = Graph[ { }, { } ] },
		{ BallCoverNumber[ graph ], FindBallCover[ graph ], FindBallCover[ graph, 1, All, All ], BallCoverQ[ graph, 1, { } ] } ],
	{ 0, { }, { { } }, True },
	TestID -> "BallCover-empty-graph"
]

VerificationTest[
	With[ { graph = PathGraph[ Range[ 4 ] ] },
		And[
			MatchQ[ FindBallCover[ graph, -1 ], _FindBallCover ], MatchQ[ FindBallCover[ graph, 1.5 ], _FindBallCover ],
			MatchQ[ BallCoverNumber[ graph, -1 ], _BallCoverNumber ], MatchQ[ BallCoverQ[ graph, -1, { 1 } ], _BallCoverQ ],
			MatchQ[ FindBallCover[ graph, 1, { 8 } ], _FindBallCover ],
			MatchQ[ BallCoverNumber[ graph, 1, <| 8 -> 0 |> ], _BallCoverNumber ],
			MatchQ[ BallCoverQ[ graph, 1, { 8 } ], _BallCoverQ ],
			MatchQ[ BallCoverQ[ graph, 1, { 1 }, { 8 } ], _BallCoverQ ] ] ],
	True,
	TestID -> "BallCover-unsupported-radii-and-foreign-vertices"
]

VerificationTest[
	With[ { graph = CycleGraph[ 3 ] },
		And[
			MatchQ[ FindBallCover[ graph, 1, "UnknownOption" -> 1 ], _FindBallCover ],
			MatchQ[ BallCoverNumber[ graph, 1, "UnknownOption" -> 1 ], _BallCoverNumber ],
			MatchQ[ FindBallCover[ graph, 1, All, -1 ], _FindBallCover ],
			MatchQ[ FindBallCover[ graph, 1, All, Automatic ], _FindBallCover ],
			MatchQ[ FindBallCover[ graph, 1, All, 0, Method -> "Unknown" ], _FindBallCover ],
			MatchQ[ FindBallCover[ graph, 1, <| 8 -> 0 |>, 0 ], _FindBallCover ] ] ],
	True,
	TestID -> "BallCover-count-zero-does-not-bypass-contract"
]

VerificationTest[
	With[ { graph = Graph[ { 1, 2 }, { DirectedEdge[ 1, 2 ] } ], weighted = Graph[ { UndirectedEdge[ 1, 2 ] }, EdgeWeight -> { 2 } ] },
		And[
			MatchQ[ FindBallCover[ graph, 1 ], _FindBallCover ], MatchQ[ BallCoverNumber[ graph, 1 ], _BallCoverNumber ],
			MatchQ[ BallCoverQ[ graph, 1, { 1 } ], _BallCoverQ ], MatchQ[ FindBallCover[ weighted, 1 ], _FindBallCover ] ] ],
	True,
	TestID -> "BallCover-directed-and-weighted-input-out-of-scope"
]

VerificationTest[
	With[ { vertices = { { }, { 1, 2 }, { { 1 } }, Blank[ Integer ], All, "end" } },
		{ graph = PathGraph[ vertices ] },
		{ FindBallCover[ graph, 0, { } ], FindBallCover[ graph, 0, { 1, 2 } ], FindBallCover[ graph, 0, Blank[ Integer ] ],
			FindBallCover[ graph, 0, <| All -> 0 |> ], FindBallCover[ graph, 0, <| |> ],
			BallCoverQ[ graph, 0, { Blank[ Integer ] }, Blank[ Integer ] ],
			BallCoverQ[ graph, 0, { All }, <| All -> 1 |> ], BallCoverQ[ graph, 0, { All }, { } ] } ],
	{ { { } }, { { 1, 2 } }, { Blank[ Integer ] }, { All }, { }, True, True, False },
	TestID -> "BallCover-literal-list-pattern-and-All-labels"
]

VerificationTest[
	With[ { graph = CycleGraph[ 5 ] },
		And[
			BallCoverNumber[ graph, 1, Method -> "Exhaustive", Method -> "Greedy" ] === 2,
			MatchQ[ BallCoverNumber[ graph, 1, Method -> "Greedy", Method -> "Exhaustive" ], _BallCoverNumber ],
			BallCoverNumber[ graph, 1, { { Method -> "IntegerLinearProgramming" } } ] === 2 ] ],
	True,
	TestID -> "BallCover-first-option-wins-and-nested-option-lists"
]

VerificationTest[
	With[ { graph = PathGraph[ Range[ 4 ] ] },
		{ expected = BlockRandom[ SeedRandom[ 518 ]; RandomInteger[ 10^9, 3 ] ] },
		BlockRandom[
			SeedRandom[ 518 ];
			FindBallCover[ graph, 1 ]; FindBallCover[ graph, 1, Method -> "Greedy" ];
			FindBallCover[ graph, 1, All, All ]; BallCoverNumber[ graph, 1 ]; BallCoverQ[ graph, 1, { 2, 4 } ];
			RandomInteger[ 10^9, 3 ] === expected ] ],
	True,
	TestID -> "BallCover-finders-do-not-consume-random-state"
]

VerificationTest[
	AllTrue[
		{ PathGraph[ Range[ 4 ] ], CycleGraph[ 5 ], StarGraph[ 5 ], CompleteGraph[ 4 ], Graph[ Range[ 4 ], { 1 <-> 2, 3 <-> 4 } ] },
		graph |-> AllTrue[ { All, { 1 }, { 1, 3 }, <| |> },
			target |-> AllTrue[ Range[ 0, 2 ], radius |-> With[
				{ targets = If[ target === All, VertexList[ graph ], If[ AssociationQ[ target ], Keys[ target ], target ] ] },
				{ feasible = Select[ Subsets[ VertexList[ graph ] ], centres |-> AllTrue[ targets,
					vertex |-> AnyTrue[ centres, centre |-> GraphDistance[ graph, vertex, centre ] <= radius ] ] ] },
				{ minimum = Min[ Length /@ feasible ] },
				{ expected = Sort @ Select[ feasible, centres |-> Length[ centres ] === minimum ] },
				FindBallCover[ graph, radius, target, All ] === expected && BallCoverNumber[ graph, radius, target ] === minimum ] ] ] ],
	True,
	TestID -> "BallCover-small-family-independent-distance-oracle"
]

VerificationTest[
	With[ { graph = CycleGraph[ 30 ] },
		{ covers = FindBallCover[ graph, 1, All, 1 ] },
		{ Length[ covers ], Length[ First[ covers ] ], BallCoverQ[ graph, 1, First[ covers ] ] } ],
	{ 1, 10, True },
	TestID -> "FindBallCover-explicit-one-retains-single-witness-fast-path"
]

VerificationTest[
	With[ { graph = Graph[ { 4, 3, 2, 1 }, { 1 <-> 2, 2 <-> 3, 3 <-> 4 } ] },
		FindBallCover[ graph, 1, All, All ] ],
	{ { 1, 3 }, { 1, 4 }, { 2, 3 }, { 2, 4 } },
	TestID -> "FindBallCover-family-members-sorted-with-permuted-vertices"
]

VerificationTest[
	With[ { graph = PathGraph[ { -1, 1.5, 2 } ] },
		And[ MatchQ[ FindBallCover[ graph, -1 ], _FindBallCover ], MatchQ[ FindBallCover[ graph, 1.5 ], _FindBallCover ],
			MatchQ[ BallCoverNumber[ graph, -1 ], _BallCoverNumber ], MatchQ[ BallCoverNumber[ graph, 1.5 ], _BallCoverNumber ] ] ],
	True,
	TestID -> "BallCover-invalid-radius-never-reinterpreted-as-target"
]

VerificationTest[
	With[ { graph = PathGraph[ Range[ 5 ] ] },
		{ BallCoverNumber[ graph, 1, InfraHalfLine[ 2, 3 ] ], BallCoverNumber[ graph, 1, InfraRay[ 2, 3 ] ],
			MatchQ[ FindBallCover[ graph, 1, unknownRegion[ 2 ] ], _FindBallCover ] } ],
	{ 2, 2, True },
	TestID -> "BallCover-readable-regions-and-unknown-head"
]

VerificationTest[
	With[ { graph = PathGraph[ { { }, { 1, 2 }, Blank[ Integer ], All, "end" } ] },
		{ BallCoverQ[ graph, 1, FindBallCover[ graph, 1, { } ], { } ],
			BallCoverQ[ graph, 1, FindBallCover[ graph, 1, <| All -> 0 |> ], <| All -> 0 |> ],
			BallCoverNumber[ graph, 1, Blank[ Integer ] ], BallCoverQ[ graph, 1, { { 1, 2 } }, { } ] } ],
	{ True, True, 1, True },
	TestID -> "BallCover-literal-labels-in-nonzero-radius-neighbourhoods"
]

VerificationTest[
	With[ { graph = Graph[ { 1, 2, <| 1 -> 1, 2 -> 1 |> }, { } ] },
		{ FindBallCover[ graph, 0, { 1, 2 }, All ], FindBallCover[ graph, 0, { 1, 2 } ],
			FindBallCover[ graph, 0, <| 1 -> 1, 2 -> 1 |>, All ] } ],
	{ { { 1, 2 } }, { 1, 2 }, { { <| 1 -> 1, 2 -> 1 |> } } },
	TestID -> "BallCover-derived-density-does-not-change-target-interpretation"
]

VerificationTest[
	With[ { vertices = { a -> b, c -> d } },
		{ graph = Graph[ vertices, { } ] },
		{ FindBallCover[ graph, 0, vertices ], BallCoverNumber[ graph, 0, vertices ], BallCoverQ[ graph, 0, vertices, vertices ] } ],
	{ { a -> b, c -> d }, 2, True },
	TestID -> "BallCover-rule-valued-vertex-list-is-a-target"
]

EndTestSection[]
