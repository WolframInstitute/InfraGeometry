ClearAll[ scenePlotA, scenePlotB, scenePlotC, scenePlotSide, scenePlotSet, scenePlotExtra, scenePlotStyle, scenePlotVertex ]

scenePlotScene = InfraScene[ { scenePlotA, scenePlotB, scenePlotC, scenePlotSide, scenePlotSet }, {
	scenePlotA == InfraPoint[], scenePlotB == InfraPoint[], scenePlotC == InfraPoint[],
	scenePlotSide == InfraSegment[ scenePlotA, scenePlotB ], scenePlotSet == InfraBall[ scenePlotA, 1 ] } ]

scenePlotInstance = InfraSceneInstance[ <| scenePlotA -> 1, scenePlotB -> 3, scenePlotC -> 4,
	scenePlotSide -> { 1, 2, 3 }, scenePlotSet -> { 1, 2, 3 }, scenePlotExtra -> 2 |> ]

SetAttributes[ scenePlotItems, HoldFirst ]
scenePlotItems[ call_ ] := Block[ { InfraSubstrateHighlight },
	InfraSubstrateHighlight[ _Graph, items_List, ___ ] := items;
	call ]

VerificationTest[
	Options[ InfraScenePlot ] === Options[ InfraSubstrateHighlight ],
	True,
	TestID -> "InfraScenePlot-inherits-renderer-options"
]

VerificationTest[
	scenePlotItems[ InfraScenePlot[ scenePlotScene, CycleGraph[ 4 ], scenePlotInstance ] ],
	{ <| 1 -> 1 |>, <| 3 -> 1 |>, <| 4 -> 1 |>, InfraWalk[ { 1, 2, 3 } ], <| 1 -> 1, 2 -> 1, 3 -> 1 |> },
	TestID -> "InfraScenePlot-declaration-order-typed-walk-set-no-extra-binding"
]

VerificationTest[
	scenePlotItems[ InfraScenePlot[ scenePlotScene, CycleGraph[ 4 ], InfraSceneInstance[ <| scenePlotB -> 3 |> ] ] ],
	{ <| 3 -> 1 |> },
	TestID -> "InfraScenePlot-default-partial-instance"
]

VerificationTest[
	scenePlotItems[ InfraScenePlot[ scenePlotScene, CycleGraph[ 4 ], scenePlotInstance,
		{ scenePlotSide, InfraSegment[ scenePlotA, scenePlotB ], scenePlotExtra } ] ],
	{ InfraWalk[ { 1, 2, 3 } ], InfraSegment[ 1, 3 ], <| 2 -> 1 |> },
	TestID -> "InfraScenePlot-saved-side-versus-full-family-and-initial-binding"
]

VerificationTest[
	scenePlotItems[ InfraScenePlot[ scenePlotScene, CycleGraph[ 4 ], scenePlotInstance,
		{ { scenePlotSide, scenePlotSet } } ] ],
	{ { InfraWalk[ { 1, 2, 3 } ], <| 1 -> 1, 2 -> 1, 3 -> 1 |> } },
	TestID -> "InfraScenePlot-nested-collection-preserves-declared-kinds"
]

VerificationTest[
	With[ { instance = InfraSceneInstance[ <| scenePlotA -> 1, scenePlotB -> 3, scenePlotC -> 4 |> ] },
		scenePlotItems[ InfraScenePlot[ scenePlotScene, CycleGraph[ 4 ], instance,
			{ InfraSegment[ scenePlotA, scenePlotB ], InfraSegment[ scenePlotB, scenePlotC ], InfraSegment[ scenePlotC, scenePlotA ] } ] ] ],
	{ InfraSegment[ 1, 3 ], InfraSegment[ 3, 4 ], InfraSegment[ 4, 1 ] },
	TestID -> "InfraScenePlot-triangle-full-families-from-point-only-instance"
]

VerificationTest[
	With[ { instance = InfraSceneInstance[ <| scenePlotA -> 1, scenePlotB -> 3 |> ] },
		{ Head[ InfraScenePlot[ scenePlotScene, CycleGraph[ 4 ], instance, { scenePlotSide } ] ],
			Head[ InfraScenePlot[ scenePlotScene, CycleGraph[ 4 ], instance, { scenePlotVertex } ] ] } ],
	{ InfraScenePlot, InfraScenePlot },
	TestID -> "InfraScenePlot-requested-missing-and-unknown-name-stay-unevaluated"
]

VerificationTest[
	With[ { graph = VertexReplace[ Graph[ Range[ 4 ], {} ], { 1 -> { 1, 2 }, 2 -> scenePlotVertex[ _Integer ],
		3 -> ( scenePlotA -> scenePlotB ), 4 -> Style[ scenePlotA, Red ] } ] },
		scenePlotItems[ InfraScenePlot[ scenePlotScene, graph,
			InfraSceneInstance[ <| scenePlotA -> { 1, 2 }, scenePlotB -> scenePlotVertex[ _Integer ] |> ],
			{ scenePlotA, scenePlotB, scenePlotA -> scenePlotB, Style[ scenePlotA, Red ] } ] ] ],
	{ <| { 1, 2 } -> 1 |>, <| scenePlotVertex[ _Integer ] -> 1 |>,
		<| ( scenePlotA -> scenePlotB ) -> 1 |>, <| Style[ scenePlotA, Red ] -> 1 |> },
	TestID -> "InfraScenePlot-list-pattern-rule-style-vertex-labels-remain-literal"
]

VerificationTest[
	With[ { graph = Graph[ { scenePlotVertex[ scenePlotB ], 2 }, {} ] },
		scenePlotItems[ InfraScenePlot[ scenePlotScene, graph,
			InfraSceneInstance[ <| scenePlotA -> scenePlotVertex[ scenePlotB ], scenePlotB -> 2 |> ], { scenePlotA } ] ] ],
	{ <| scenePlotVertex[ scenePlotB ] -> 1 |> },
	TestID -> "InfraScenePlot-inserted-binding-is-opaque"
]

VerificationTest[
	scenePlotItems[ InfraScenePlot[ scenePlotScene, CycleGraph[ 4 ],
		InfraSceneInstance[ <| scenePlotA -> 1, scenePlotB -> 3, scenePlotSide -> { 1, 2, 3 }, scenePlotStyle -> Red |> ],
		{ Directive[ scenePlotStyle ], Style[ scenePlotSide, scenePlotStyle ], scenePlotSide -> scenePlotStyle } ] ],
	{ Directive[ scenePlotStyle ], Style[ InfraWalk[ { 1, 2, 3 } ], scenePlotStyle ], InfraWalk[ { 1, 2, 3 } ] -> scenePlotStyle },
	TestID -> "InfraScenePlot-only-object-payloads-resolve-in-style-grammar"
]

VerificationTest[
	{ Head[ InfraScenePlot[ scenePlotScene, CycleGraph[ 4 ],
		InfraSceneInstance[ <| scenePlotExtra -> { 1, 2, 3 } |> ], { scenePlotExtra } ] ],
		scenePlotItems[ InfraScenePlot[ scenePlotScene, CycleGraph[ 4 ],
			InfraSceneInstance[ <| scenePlotExtra -> { 1, 2, 3 } |> ], { InfraWalk[ scenePlotExtra ] } ] ] },
	{ InfraScenePlot, { InfraWalk[ { 1, 2, 3 } ] } },
	TestID -> "InfraScenePlot-undeclared-list-requires-explicit-walk-interpretation"
]

VerificationTest[
	With[ { plot = InfraScenePlot[ scenePlotScene, CycleGraph[ 4 ], scenePlotInstance,
		{ Style[ scenePlotSide, Blue ] }, ImageSize -> 321, ImageSize -> 432, PlotLabel -> "Saved" ] },
		{ Head[ plot ], ImageSize /. Options[ plot ], PlotLabel /. Options[ plot ] } ],
	{ Graph, 321, "Saved" },
	TestID -> "InfraScenePlot-style-rendering-and-native-first-option-precedence"
]

VerificationTest[
	With[ { defaults = Options[ InfraScenePlot ] },
		SetOptions[ InfraScenePlot, ImageSize -> 234 ];
		With[ { sizes = Map[ plot |-> ImageSize /. Options[ plot ], {
			InfraScenePlot[ scenePlotScene, CycleGraph[ 4 ], scenePlotInstance ],
			InfraScenePlot[ scenePlotScene, CycleGraph[ 4 ], scenePlotInstance, ImageSize -> 345 ] } ] },
			Options[ InfraScenePlot ] = defaults;
			sizes ] ],
	{ 234, 345 },
	TestID -> "InfraScenePlot-SetOptions-defaults-and-explicit-override"
]

VerificationTest[
	With[ { graph = Graph[ Range[ 4 ], { 1 <-> 2, 2 <-> 3, 3 <-> 4, 4 <-> 1 } ] },
		SeedRandom[ 745 ];
		With[ { expected = RandomInteger[ 10^6, 6 ] },
			SeedRandom[ 745 ];
			InfraScenePlot[ scenePlotScene, graph, scenePlotInstance, { InfraSegment[ scenePlotA, scenePlotB ] } ];
			RandomInteger[ 10^6, 6 ] === expected ] ],
	True,
	TestID -> "InfraScenePlot-ambient-random-sequence-preserved-with-layout"
]

VerificationTest[
	Block[ { RandomInfraSceneInstance, InfraSceneMultiway, InfraSceneViewer, RandomInfraSegment },
		RandomInfraSceneInstance[ ___ ] := Throw[ "scene sampler" ];
		InfraSceneMultiway[ ___ ] := Throw[ "scene explorer" ];
		InfraSceneViewer[ ___ ] := Throw[ "scene viewer" ];
		RandomInfraSegment[ ___ ] := Throw[ "segment enumeration" ];
		Catch[ Head[ InfraScenePlot[ scenePlotScene, CycleGraph[ 4 ], scenePlotInstance,
			{ InfraSegment[ scenePlotA, scenePlotB ] } ] ] ] ],
	Graph,
	TestID -> "InfraScenePlot-multi-member-family-does-not-solve-or-enumerate"
]

VerificationTest[
	With[ { scene = InfraScene[ { scenePlotA, scenePlotB, scenePlotSide }, {
		scenePlotA == InfraPoint[], scenePlotB == InfraPoint[], scenePlotSide == InfraSegment[ scenePlotA, scenePlotB ],
		InfraMemberQ[ scenePlotSide, 2 ] } ] },
		scenePlotItems[ InfraScenePlot[ scene, CycleGraph[ 4 ], scenePlotInstance,
			{ scenePlotSide, InfraSegment[ scenePlotA, scenePlotB ] } ] ] ],
	{ InfraWalk[ { 1, 2, 3 } ], InfraSegment[ 1, 3 ] },
	TestID -> "InfraScenePlot-explicit-family-not-restricted-by-side-assertions"
]

VerificationTest[
	Head[ InfraScenePlot[ scenePlotScene, CycleGraph[ 4 ], scenePlotInstance, {} ] ],
	Graph,
	TestID -> "InfraScenePlot-empty-explicit-display-is-substrate"
]

VerificationTest[
	scenePlotItems[ InfraScenePlot[ scenePlotScene, CycleGraph[ 4 ], scenePlotInstance,
		{ InfraTube[ InfraSegment[ scenePlotA, scenePlotB ], Infinity ],
			InfraTube[ InfraSegment[ scenePlotA, scenePlotB ], scenePlotA |-> 1 + scenePlotA ] } ] ],
	{ InfraTube[ InfraSegment[ 1, 3 ], Infinity ], InfraTube[ InfraSegment[ 1, 3 ], scenePlotA |-> 1 + scenePlotA ] },
	TestID -> "InfraScenePlot-literal-infinite-and-functional-geometry-parameters"
]

VerificationTest[
	Map[ object |-> With[ { plot = InfraScenePlot[ scenePlotScene, CycleGraph[ 4 ], scenePlotInstance, { object } ] },
		Length[ Cases[ EdgeStyle /. Options[ plot ], _UndirectedEdge -> _, Infinity ] ] ],
		{ scenePlotSide, InfraSegment[ scenePlotA, scenePlotB ] } ],
	{ 2, 4 },
	TestID -> "InfraScenePlot-selected-walk-edges-versus-complete-cycle-interval"
]

VerificationTest[
	scenePlotItems[ InfraScenePlot[ scenePlotScene, Graph[ { scenePlotA, 1, 2 }, {} ],
		InfraSceneInstance[ <| scenePlotA -> 2 |> ], { scenePlotA } ] ],
	{ <| 2 -> 1 |> },
	TestID -> "InfraScenePlot-exact-binding-precedes-literal-vertex"
]

VerificationTest[
	With[ { graph = GridGraph[ { 3, 3 }, VertexStyle -> Red, VertexSize -> 0.17 ],
		instance = InfraSceneInstance[ <| scenePlotSide -> { 1, 2, 3, 6, 9 } |> ] },
		{ direct = InfraSubstrateHighlight[ graph, { InfraWalk[ { 1, 2, 3, 6, 9 } ] } ],
			plot = InfraScenePlot[ scenePlotScene, graph, instance, { scenePlotSide } ] },
		{ Options[ plot, GraphLayout ] === Options[ direct, GraphLayout ],
			Options[ plot, VertexStyle ] === Options[ direct, VertexStyle ],
			Options[ plot, VertexSize ] === Options[ direct, VertexSize ],
			Options[ plot, FormatType ] === Options[ direct, FormatType ] } ],
	{ True, True, True, True },
	TestID -> "InfraScenePlot-defaults-preserve-native-layout-styling-and-format"
]
