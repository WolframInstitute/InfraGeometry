(* Smoke tests: every Manipulate-based viewer constructs without throwing
   on a small grid graph. We do not exercise the interactive controls. *)

VerificationTest[
  FreeQ[ PointViewer[ GridGraph[ { 3, 3 } ] ], $Failed ],
  True,
  TestID -> "PointViewer-constructs"
]

VerificationTest[
  FreeQ[ SegmentViewer[ GridGraph[ { 3, 3 } ] ], $Failed ],
  True,
  TestID -> "SegmentViewer-constructs"
]

VerificationTest[
  FreeQ[ ShellViewer[ GridGraph[ { 3, 3 } ] ], $Failed ],
  True,
  TestID -> "ShellViewer-constructs"
]

VerificationTest[
  FreeQ[ CircleViewer[ GridGraph[ { 3, 3 } ] ], $Failed ],
  True,
  TestID -> "CircleViewer-constructs"
]

VerificationTest[
  With[ { g = PathGraph[ Range[ 5 ] ], scene = InfraScene[ { p }, { p == InfraPoint[] } ] },
    FreeQ[ InfraSceneViewer[ scene, g ], $Failed ]
  ],
  True,
  TestID -> "InfraSceneViewer-constructs"
]

savedViewerSnapshot[ data_, depth_: 0, state_: None, filter_: <| |>, choices_: <| |>, navigation_: "Event depth" ] :=
  Block[ {
      WolframInstitute`InfraGeometry`InfraSceneInteractive`PackagePrivate`navigation = navigation,
      WolframInstitute`InfraGeometry`InfraSceneInteractive`PackagePrivate`boundary = depth,
      WolframInstitute`InfraGeometry`InfraSceneInteractive`PackagePrivate`selectedState = state,
      WolframInstitute`InfraGeometry`InfraSceneInteractive`PackagePrivate`restriction = filter,
      WolframInstitute`InfraGeometry`InfraSceneInteractive`PackagePrivate`incomingChoices = choices },
    ReleaseHold[ First @ Cases[ InfraSceneViewer[ data ],
      HoldPattern[ Dynamic[ body_With, ___ ] ] :> HoldComplete[ body ], Infinity ] ] /.
      HoldPattern[ Dynamic[ expression_, ___ ] ] :> expression ]

savedViewerField[ snapshot_, label_ ] :=
  First @ Cases[ snapshot, Row[ { text_, value_ } ] /; text === label :> value, Infinity ]

savedViewerInk[ data_, depth_: 0, state_: None ] :=
  Block[ { InfraSubstrateHighlight },
    InfraSubstrateHighlight[ _, items_List, ___ ] := savedInk[ items ];
    First @ Cases[ savedViewerSnapshot[ data, depth, state ], savedInk[ items_ ] :> items, Infinity ] ]

savedDiamond = InfraSceneMultiway[
  InfraScene[ { savedP, savedQ }, { InfraStep[ {
    savedP == InfraMidpoint[ 1, 3 ], savedQ == InfraMidpoint[ 1, 1 ] } ] } ], PathGraph[ Range[ 3 ] ] ];
savedPointPair = InfraSceneMultiway[ InfraScene[ { savedP, savedQ },
  { InfraStep[ { savedP == InfraPoint[ ], savedQ == InfraPoint[ ] } ] } ], PathGraph[ { 1, 2 } ] ];
savedPending = InfraSceneMultiway[ InfraScene[ { savedP, savedQ },
  { InfraStep[ { savedP == InfraPoint[ ] } ], InfraStep[ { savedQ == InfraPoint[ ] } ], savedP < savedQ } ],
  PathGraph[ { 1, 2 } ], "Steps" -> 1 ];
savedUnsupported = InfraSceneMultiway[ InfraScene[ { savedP },
  { savedP == InfraPoint[ ], InfraGeometricAssertion[ { savedP }, "NotRegistered" ] } ], PathGraph[ { 1, 2 } ] ];
savedBounded = InfraSceneMultiway[ savedDiamond[ "Scene" ], savedDiamond[ "Substrate" ], "MaxEvents" -> 3 ];
savedFixed = InfraSceneMultiway[ savedPointPair[ "Scene" ], savedPointPair[ "Substrate" ], <| savedP -> 1 |> ];
savedLabels = InfraSceneMultiway[ InfraScene[ { savedP }, { savedP == InfraPoint[ ] } ],
  Graph[ { { }, { 1, 2 }, { 3, 4 } }, { UndirectedEdge[ { }, { 1, 2 } ], UndirectedEdge[ { 1, 2 }, { 3, 4 } ] } ] ];

VerificationTest[ Head[ InfraSceneViewer[ savedDiamond ] ], DynamicModule, TestID -> "SavedViewer-overload" ]
VerificationTest[ InfraSceneViewer[ <| "States" -> <| |> |> ], InfraSceneViewer[ <| "States" -> <| |> |> ],
  TestID -> "SavedViewer-unsupported-record-unevaluated" ]
VerificationTest[ Head[ InfraSceneViewer[ savedDiamond, "UnknownOption" -> True ] ], InfraSceneViewer,
  TestID -> "SavedViewer-unsupported-option-unevaluated" ]
VerificationTest[ savedViewerField[ savedViewerSnapshot[ savedDiamond, 2, 4 ], "Bindings: " ],
  <| savedP -> 2, savedQ -> 1 |>, TestID -> "SavedViewer-saved-terminal-bindings" ]
VerificationTest[ savedViewerField[ savedViewerSnapshot[ savedDiamond, 1, 2 ], "Bindings: " ],
  <| savedP -> 2 |>, TestID -> "SavedViewer-event-layer-navigation" ]
VerificationTest[ savedViewerField[ savedViewerSnapshot[ savedDiamond, 1, 4, <| |>, <| |>, "Group boundary" ], "Bindings: " ],
  <| savedP -> 2, savedQ -> 1 |>, TestID -> "SavedViewer-group-boundary-uses-StepLayers" ]
VerificationTest[ savedViewerField[ savedViewerSnapshot[ savedDiamond, 2, 4 ], "History event IDs: " ],
  { 1, 3 }, TestID -> "SavedViewer-first-incoming-history" ]
VerificationTest[ savedViewerField[ savedViewerSnapshot[ savedDiamond, 2, 4, <| |>, <| 4 -> 4 |> ], "History event IDs: " ],
  { 2, 4 }, TestID -> "SavedViewer-alternate-incoming-history" ]
VerificationTest[ Last @ First @ Cases[ savedViewerSnapshot[ savedDiamond, 2, 4, <| |>, <| 4 -> 4 |> ],
    Grid[ rows_List, ___ ] :> rows, Infinity ],
  { PopupMenu[ 4, { 3, 4 } ], 3, 4, 1, 1, 2, "Accepted" }, TestID -> "SavedViewer-history-shows-saved-candidate" ]
VerificationTest[ savedViewerField[ savedViewerSnapshot[ savedDiamond, 1, 2 ], "Branchial neighbors: " ],
  { 3 }, TestID -> "SavedViewer-immediate-branchial-neighbors" ]
VerificationTest[ savedViewerField[ savedViewerSnapshot[ savedDiamond, 1, 2 ], "Common-parent witnesses: " ],
  <| UndirectedEdge[ 2, 3 ] -> { 1 } |>, TestID -> "SavedViewer-branchial-witnesses" ]
VerificationTest[ ! FreeQ[ savedViewerSnapshot[ savedDiamond, 2, 4 ], "Complete" ], True,
  TestID -> "SavedViewer-complete-layer-label" ]
VerificationTest[ ! FreeQ[ savedViewerSnapshot[ savedBounded, 2, 4 ], "Partial exploration" ], True,
  TestID -> "SavedViewer-missing-incoming-event-partial-label" ]
VerificationTest[ ! FreeQ[ savedViewerSnapshot[ savedBounded, 2, 4 ], "EventLimit" ], True,
  TestID -> "SavedViewer-actual-boundary-reason" ]
VerificationTest[ ! FreeQ[ savedViewerSnapshot[ savedPending, 1, 2 ], "Undecided: assertions are pending at this state." ],
  True, TestID -> "SavedViewer-pending-prefix-is-undecided" ]
VerificationTest[ ! FreeQ[ savedViewerSnapshot[ savedUnsupported, 1, 2 ],
    "Undecided: an unsupported assertion blocks this state." ], True, TestID -> "SavedViewer-unsupported-not-solution" ]
VerificationTest[ ! FreeQ[ savedViewerSnapshot[ savedUnsupported, 1, 2 ],
    "Branchial edges have saved witnesses; missing edges are undecided." ], True,
  TestID -> "SavedViewer-incomplete-missing-edge-not-negative" ]
VerificationTest[ savedViewerField[ savedViewerSnapshot[ savedPointPair, 2, None, <| savedP -> 1 |> ], "Bindings: " ][ savedP ],
  1, TestID -> "SavedViewer-binding-restriction-filters-saved-states" ]
VerificationTest[ ! FreeQ[ savedViewerSnapshot[ savedPointPair, 2, None, <| savedP -> 1 |> ], "Filtered view: " ],
  True, TestID -> "SavedViewer-filtered-view-visible" ]
VerificationTest[ ! FreeQ[ savedViewerSnapshot[ savedFixed, 2, None, <| savedP -> 2 |> ],
    "No matching saved states at this boundary." ], True, TestID -> "SavedViewer-filter-never-overwrites-fixed-input" ]
VerificationTest[ savedFixed[ "InitialBindings" ], <| savedP -> 1 |>, TestID -> "SavedViewer-fixed-input-preserved" ]
VerificationTest[ savedViewerInk[ savedLabels, 1, 2 ], { <| { } -> 1 |> },
  TestID -> "SavedViewer-empty-list-point-is-one-point" ]
VerificationTest[ savedViewerInk[ savedLabels, 1, 3 ], { <| { 1, 2 } -> 1 |> },
  TestID -> "SavedViewer-list-valued-point-intact" ]
VerificationTest[ ! FreeQ[ savedViewerSnapshot[ savedLabels, 1, None, <| savedP -> { 1, 2 } |> ],
    <| savedP -> { 1, 2 } |> ], True, TestID -> "SavedViewer-list-label-literal-filter" ]
VerificationTest[ savedViewerInk[ InfraSceneMultiway[ InfraScene[ { savedW },
    { savedW == InfraInfiniteLine[ 2, 2 ] } ], PathGraph[ Range[ 3 ] ] ], 1, 2 ],
  { InfraWalk[ { 1, 2, 3 } ] }, TestID -> "SavedViewer-ordered-walk-declared-carrier" ]
VerificationTest[ savedViewerInk[ InfraSceneMultiway[ InfraScene[ { savedW },
    { savedW == InfraWalk[ 1, 2, 1, 2, 3 ] } ], PathGraph[ Range[ 3 ] ] ], 1, 2 ],
  { InfraWalk[ { 1, 2, 1, 2, 3 } ] }, TestID -> "SavedViewer-repeated-walk-not-support" ]
VerificationTest[ savedViewerInk[ InfraSceneMultiway[ InfraScene[ { savedSet },
    { savedSet == InfraBall[ 2, 1 ] } ], PathGraph[ Range[ 3 ] ] ], 1, 2 ],
  { <| 1 -> 1, 2 -> 1, 3 -> 1 |> }, TestID -> "SavedViewer-set-not-inferred-as-walk" ]
VerificationTest[ savedViewerInk[ InfraSceneMultiway[ InfraScene[ { savedSet },
    { savedSet == InfraShell[ 2, 3 ] } ], PathGraph[ Range[ 3 ] ] ], 1, 2 ],
  { <| |> }, TestID -> "SavedViewer-empty-set-retained" ]
VerificationTest[ With[ { data = InfraSceneMultiway[ InfraScene[ { savedCycle },
      { savedCycle == InfraEllipse[ { 1, 3 }, 2, Properties -> { } ] } ], CycleGraph[ 4 ] ] },
    SameQ[ First @ savedViewerInk[ data, 1, 2 ], data[ "States" ][ 2 ][ "Bindings" ][ savedCycle ] ] ],
  True, TestID -> "SavedViewer-Graph-carrier-preserved" ]
VerificationTest[ BlockRandom[ SeedRandom[ 159 ]; With[ { expected = RandomInteger[ 10^9 ] },
    SeedRandom[ 159 ]; InfraSceneViewer[ savedDiamond ]; savedViewerSnapshot[ savedDiamond, 2, 4 ];
    savedViewerSnapshot[ savedDiamond, 2, 4, <| savedP -> 2 |>, <| 4 -> 4 |> ]; RandomInteger[ 10^9 ] === expected ] ],
  True, TestID -> "SavedViewer-navigation-and-redraw-RNG-neutral" ]
VerificationTest[ With[ { before = savedDiamond }, savedViewerSnapshot[ savedDiamond, 2, 4, <| |>, <| 4 -> 4 |> ];
    before === savedDiamond ], True, TestID -> "SavedViewer-saved-record-immutable" ]
VerificationTest[ Block[ { RandomInfraInstance, RandomInfraPoint, RandomInfraMidpoint, InfraSceneMultiway },
    RandomInfraInstance[ ___ ] := Throw[ "SamplerCalled" ]; RandomInfraPoint[ ___ ] := Throw[ "SamplerCalled" ];
    RandomInfraMidpoint[ ___ ] := Throw[ "SamplerCalled" ]; InfraSceneMultiway[ ___ ] := Throw[ "ExplorerCalled" ];
    Catch[ Head[ savedViewerSnapshot[ savedDiamond, 2, 4 ] ] ] ], Column,
  TestID -> "SavedViewer-redraw-never-samples-or-explores" ]
VerificationTest[ GraphQ[ InfraSubstrateHighlight[ PathGraph[ Range[ 3 ] ], { InfraMidpoint[ 1, 3 ] } ] ],
  True, TestID -> "SavedViewer-midpoint-family-public-renderer" ]
VerificationTest[ GraphQ[ InfraSubstrateHighlight[ CycleGraph[ 4 ], { InfraPerpendicularBisector[ 1, 3 ] } ] ],
  True, TestID -> "SavedViewer-bisector-family-public-renderer" ]
VerificationTest[ GraphQ[ InfraSubstrateHighlight[ PathGraph[ Range[ 3 ] ], { InfraRegionNearest[ { 1, 3 }, 2 ] } ] ],
  True, TestID -> "SavedViewer-nearest-family-public-renderer" ]
VerificationTest[ With[ { data = InfraSceneMultiway[ InfraScene[ { savedP }, { savedP == InfraMidpoint[ 1, 2 ] } ],
      PathGraph[ { 1, 2 } ] ] }, ! FreeQ[ savedViewerSnapshot[ data, 1 ], "This layer is exhaustively empty." ] ],
  True, TestID -> "SavedViewer-decided-empty-layer" ]

VerificationTest[ { savedViewerField[ savedViewerSnapshot[ savedLabels, 1, 2, <| savedP -> { } |> ], "Branchial neighbors: " ],
    savedViewerField[ savedViewerSnapshot[ savedLabels, 1, 2, <| savedP -> { } |> ], "Common-parent witnesses: " ] },
  { { }, <| |> }, TestID -> "SavedViewer-restriction-filters-branchial-context" ]

VerificationTest[ Block[ {
    WolframInstitute`InfraGeometry`InfraSceneInteractive`PackagePrivate`navigation = "Event depth",
    WolframInstitute`InfraGeometry`InfraSceneInteractive`PackagePrivate`boundary = 0 },
  ! FreeQ[ ToBoxes[ ReleaseHold @ First @ Cases[ InfraSceneViewer[ savedDiamond ],
    HoldPattern[ Dynamic[ menu_PopupMenu, ___ ] ] :> HoldComplete[ menu ], Infinity ] ], _PopupMenuBox ] ],
  True, TestID -> "SavedViewer-boundary-menu-boxes-as-control" ]
