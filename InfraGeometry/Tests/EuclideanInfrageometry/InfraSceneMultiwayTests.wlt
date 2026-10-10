ClearAll[ unmergedSceneReference, quotientExplorerRecords ]

unmergedSceneReference[ declarations_List, initial_Association, test_ : ( bindings |-> True ) ] :=
  Module[ { queue = { { { }, KeySort[ initial ] } }, nodes = { { { }, KeySort[ initial ] } },
      events = { }, current, ready, group, fixed, candidates, bindings, done, next, outcome, ordinal, terminals = { } },
    While[ queue =!= { },
      current = First[ queue ];
      queue = Rest[ queue ];
      done = First[ current ];
      bindings = Last[ current ];
      ready = Complement[ Range[ Length[ declarations ] ], done ];
      If[ ready === { }, terminals = Append[ terminals, bindings ],
        group = Min[ declarations[[ ready, 1 ]] ];
        ready = Select[ ready, id |-> declarations[[ id, 1 ]] === group &&
          ( ContainsAll[ Keys[ bindings ], declarations[[ id, 2 ]] ] || ContainsAll[ Keys[ bindings ], declarations[[ id, 3 ]] ] ) ];
        Do[
          fixed = ContainsAll[ Keys[ bindings ], declarations[[ id, 2 ]] ];
          candidates = If[ fixed, { None }, declarations[[ id, 4 ]][ bindings ] ];
          Do[
            ordinal = If[ fixed, None, index ];
            next = If[ fixed, bindings, KeySort @ Join[ bindings,
              AssociationThread[ declarations[[ id, 2 ]], If[ Length[ declarations[[ id, 2 ]] ] === 1,
                { candidates[[ index ]] }, candidates[[ index ]] ] ] ] ];
            outcome = Which[
              ! AllTrue[ Intersection[ Keys[ bindings ], declarations[[ id, 2 ]] ], name |-> next[ name ] === bindings[ name ] ],
                "FixedConflict", ! TrueQ[ test[ next ] ], "AssertionFalse", fixed, "Fixed", True, "Accepted" ];
            events = Append[ events, { current, id, ordinal,
              If[ MemberQ[ { "Fixed", "Accepted" }, outcome ], { Sort[ Append[ done, id ] ], next }, None ], outcome } ];
            If[ MemberQ[ { "Fixed", "Accepted" }, outcome ],
              queue = Append[ queue, { Sort[ Append[ done, id ] ], next } ];
              nodes = Append[ nodes, { Sort[ Append[ done, id ] ], next } ] ],
            { index, Length[ candidates ] } ], { id, ready } ] ] ];
    <| "TreeNodes" -> Length[ nodes ], "States" -> Sort @ DeleteDuplicates[ nodes ],
      "Events" -> Sort @ DeleteDuplicates[ events ], "Instances" -> Sort @ DeleteDuplicates[ terminals ] |> ]

quotientExplorerRecords[ data_ ] :=
  With[ { keys = Map[ state |-> { state[ "Completed" ], KeySort[ state[ "Bindings" ] ] }, data[ "States" ] ] },
    <| "States" -> Sort[ Values[ keys ] ], "Events" -> Sort @ Map[
        event |-> { keys[ event[ "Source" ] ], event[ "Construction" ], event[ "CandidateIndex" ],
          If[ event[ "Target" ] === None, None, keys[ event[ "Target" ] ] ], event[ "Outcome" ] }, Values[ data[ "Events" ] ] ],
      "Instances" -> Sort[ First /@ data[ "Instances" ] ] |> ]

VerificationTest[
  With[ { graph = PathGraph[ Range[ 3 ] ],
      scene = InfraScene[ { p, q }, { InfraStep[ { p == InfraMidpoint[ 1, 3 ], q == InfraMidpoint[ 1, 1 ] } ] } ] },
    { reference = unmergedSceneReference[ {
        { 1, { p }, { }, bindings |-> RandomInfraMidpoint[ graph, InfraMidpoint[ 1, 3 ], All ] },
        { 1, { q }, { }, bindings |-> RandomInfraMidpoint[ graph, InfraMidpoint[ 1, 1 ], All ] } }, <| |> ],
      observed = quotientExplorerRecords[ InfraSceneMultiway[ scene, graph ] ] },
    { reference[ "TreeNodes" ], Length[ reference[ "States" ] ], Length[ reference[ "Events" ] ],
      KeyDrop[ reference, "TreeNodes" ] === observed } ],
  { 5, 4, 4, True }, TestID -> "multiway-independent-unmerged-diamond-reference"
]

VerificationTest[
  With[ { graph = PathGraph[ { 1, 2 } ],
      scene = InfraScene[ { p, q, r }, { InfraStep[ { p == InfraPoint[], q == InfraPoint[] } ],
        InfraStep[ { r == InfraMidpoint[ p, p ] } ], p < q } ] },
    { reference = unmergedSceneReference[ {
        { 1, { p }, { }, bindings |-> VertexList[ graph ] },
        { 1, { q }, { }, bindings |-> VertexList[ graph ] },
        { 2, { r }, { p }, bindings |-> RandomInfraMidpoint[ graph, InfraMidpoint[ bindings[ p ], bindings[ p ] ], All ] } },
        <| |>, bindings |-> ! ContainsAll[ Keys[ bindings ], { p, q } ] || bindings[ p ] < bindings[ q ] ],
      observed = quotientExplorerRecords[ InfraSceneMultiway[ scene, graph ] ] },
    KeyDrop[ reference, "TreeNodes" ] === observed ],
  True, TestID -> "multiway-independent-unmerged-branches-groups-and-rejected-trials"
]

VerificationTest[
  With[ { graph = CompleteGraph[ 4 ], scene = InfraScene[ { p, q }, { { p, q } == InfraSegment[ { 1, 2 }, { 3, 4 } ] } ] },
    { reference = unmergedSceneReference[ {
        { 1, { p, q }, { }, bindings |-> RandomInfraSegment[ graph, InfraSegment[ { 1, 2 }, { 3, 4 } ], All ] } }, <| p -> 1 |> ],
      observed = quotientExplorerRecords[ InfraSceneMultiway[ scene, graph, <| p -> 1 |> ] ] },
    KeyDrop[ reference, "TreeNodes" ] === observed ],
  True, TestID -> "multiway-independent-unmerged-partial-tuple-reference"
]

VerificationTest[
  With[ { graph = PathGraph[ Range[ 3 ] ],
      scene = InfraScene[ { p, q }, { InfraStep[ { p == InfraMidpoint[ 1, 3 ], q == InfraMidpoint[ 1, 1 ] } ] } ] },
    { reference = unmergedSceneReference[ {
        { 1, { p }, { }, bindings |-> { 2 } }, { 1, { q }, { }, bindings |-> { 1 } } }, <| p -> 2 |> ],
      observed = quotientExplorerRecords[ InfraSceneMultiway[ scene, graph, <| p -> 2 |> ] ] },
    KeyDrop[ reference, "TreeNodes" ] === observed ],
  True, TestID -> "multiway-independent-unmerged-fixed-skip-reference"
]

VerificationTest[
  With[ { scene = InfraScene[ { p, q }, { InfraStep[ { p == InfraPoint[] } ], InfraStep[ { q == InfraMidpoint[ p, p ] } ] } ],
      graph = PathGraph[ { 1, 2 } ] },
    Map[ steps |-> Sort[ InfraSceneMultiway[ scene, graph, "Steps" -> steps ][ "Instances" ] ] ===
      Sort[ RandomInfraInstance[ scene, graph, All, <| |>, "Steps" -> steps ] ], { 0, 1, 2, All } ] ],
  { True, True, True, True }, TestID -> "multiway-all-group-boundaries-agree-with-sampler"
]

VerificationTest[
  With[ { scene = InfraScene[ { p, q }, { InfraStep[ { q == InfraMidpoint[ p, p ], p == InfraPoint[] } ] } ] },
    { data = InfraSceneMultiway[ scene, PathGraph[ { 1, 2 } ] ] },
    { Lookup[ Values[ data[ "Events" ] ], "Construction" ], Length[ data[ "Instances" ] ], data[ "Completeness" ][ "Scene" ] } ],
  { { 2, 2, 1, 1 }, 2, True }, TestID -> "multiway-dependent-constructions-in-one-manual-group"
]

VerificationTest[
  Head[ InfraSceneMultiway[ InfraScene[ { p, q }, { InfraStep[ { p == InfraMidpoint[ q, q ], q == InfraPoint[] } ] } ],
    PathGraph[ { 1, 2 } ] ] ],
  InfraSceneMultiway, TestID -> "multiway-rejects-sampler-order-violating-manual-group"
]

VerificationTest[
  Head[ InfraSceneMultiway[ InfraScene[ { p, q }, { p == InfraMidpoint[ q, q ], q == InfraMidpoint[ p, p ] } ],
    PathGraph[ { 1, 2 } ] ] ],
  InfraSceneMultiway, TestID -> "multiway-rejects-actual-dependency-cycle"
]

VerificationTest[
  With[ { label = { p, InfraLine[ 1, 2 ], InfraDistance[ 1, 2 ] } },
    { graph = Graph[ { label }, { } ], scene = InfraScene[ { p }, { p == InfraMidpoint[ label, label ] } ] },
    { data = InfraSceneMultiway[ scene, graph ] },
    { data[ "Schedule" ][ 1 ][ "Dependencies" ], data[ "Instances" ], data[ "Completeness" ][ "Scene" ] } ],
  { { }, { InfraSceneInstance[ <| p -> { p, InfraLine[ 1, 2 ], InfraDistance[ 1, 2 ] } |> ] }, True },
  TestID -> "multiway-literal-self-containing-label-is-not-cycle"
]

VerificationTest[
  Map[ hypotheses |-> Head[ InfraSceneMultiway[ InfraScene[ { p, q }, hypotheses ], PathGraph[ { 1, 2 } ] ] ], {
    { p == InfraPoint[], p == InfraMidpoint[ 1, 1 ] },
    { { p, q } == InfraSegment[ 1, 2 ], p == InfraPoint[] },
    { InfraStep[ { p == InfraPoint[] } ], q == InfraPoint[] },
    { InfraStep[ { p == InfraPoint[] } ], InfraStep[ { p == InfraMidpoint[ 1, 1 ] } ] } } ],
  ConstantArray[ InfraSceneMultiway, 4 ], TestID -> "multiway-rejects-preloss-duplicate-and-mixed-schedules"
]

VerificationTest[
  Head[ InfraSceneMultiway[ InfraScene[ { p, q }, { InfraStep[ { q == InfraMidpoint[ p, p ] } ],
    InfraStep[ { p == InfraPoint[] } ] } ], PathGraph[ { 1, 2 } ] ] ],
  InfraSceneMultiway, TestID -> "multiway-rejects-dependency-in-later-group"
]

VerificationTest[
  With[ { scene = InfraScene[ { p, input }, { p == InfraMidpoint[ input, input ] } ] },
    { data = InfraSceneMultiway[ scene, PathGraph[ { 1, 2 } ] ] },
    { data[ "Instances" ], data[ "Layers" ][ 0 ][ "Complete" ], data[ "Completeness" ][ "Scene" ],
      data[ "Completeness" ][ "Reasons" ], First[ data[ "Diagnostics" ] ][ "Dependencies" ] } ],
  { { }, True, False, { "UnboundInput" }, { input } }, TestID -> "multiway-missing-external-input-is-unbound"
]

VerificationTest[
  With[ { scene = InfraScene[ { p, input }, { p == InfraMidpoint[ input, input ] } ] },
    { data = InfraSceneMultiway[ scene, PathGraph[ { 1, 2 } ], <| input -> 2 |> ] },
    { data[ "Instances" ], data[ "Completeness" ][ "Scene" ] } ],
  { { InfraSceneInstance[ <| input -> 2, p -> 2 |> ] }, True }, TestID -> "multiway-initial-only-input-is-preserved"
]

VerificationTest[
  With[ { scene = InfraScene[ { p }, { p == InfraPoint[], p < 0 } ] },
    { data = InfraSceneMultiway[ scene, PathGraph[ { 1, 2 } ], <| p -> 1 |> ] },
    { data[ "Root" ], data[ "States" ], data[ "Events" ], VertexCount[ data[ "StateGraph" ] ],
      data[ "Instances" ], data[ "Completeness" ][ "Scene" ], data[ "Layers" ][ 1 ][ "Complete" ] } ],
  { None, <| |>, <| |>, 0, { }, True, True }, TestID -> "multiway-rejected-root-is-completely-empty"
]

VerificationTest[
  With[ { scene = InfraScene[ { p }, { p == InfraPoint[], p < 0, InfraGeometricAssertion[ { p }, "Unknown" ] } ] },
    { data = InfraSceneMultiway[ scene, PathGraph[ { 1, 2 } ] ] },
    { Length[ data[ "States" ] ], Lookup[ Values[ data[ "Events" ] ], "Outcome" ],
      data[ "Completeness" ][ "Scene" ], data[ "Instances" ] } ],
  { 1, { "AssertionFalse", "AssertionFalse" }, True, { } }, TestID -> "multiway-false-rejection-dominates-unsupported-assertion"
]

VerificationTest[
  With[ { scene = InfraScene[ { p, q }, { InfraStep[ { } ], InfraStep[ { p == InfraPoint[] } ],
      InfraStep[ { } ], InfraStep[ { q == InfraMidpoint[ p, p ] } ], InfraStep[ { } ] } ] },
    { data = InfraSceneMultiway[ scene, PathGraph[ { 1, 2 } ] ] },
    { Lookup[ Values[ data[ "StepLayers" ] ], "Depth" ], data[ "States" ][ 1 ][ "Group" ],
      DeleteDuplicates[ Lookup[ Values[ data[ "States" ] ], "Group" ] ], data[ "Completeness" ][ "Scene" ] } ],
  { { 0, 0, 1, 1, 2, 2 }, 2, { 2, 4, 6 }, True }, TestID -> "multiway-empty-groups-advance-without-events"
]

VerificationTest[
  With[ { scene = InfraScene[ { p, q }, { InfraStep[ { p == InfraPoint[] } ], InfraStep[ { q == InfraPoint[] } ] } ] },
    { data = InfraSceneMultiway[ scene, PathGraph[ { 1, 2 } ], "MaxDepth" -> 0 ] },
    { Keys[ data[ "Layers" ] ], Lookup[ Values[ data[ "StepLayers" ] ], "Complete" ],
      data[ "Completeness" ][ "Reasons" ], data[ "Instances" ] } ],
  { { 0 }, { True, False, False }, { "DepthLimit" }, { } }, TestID -> "multiway-depth-zero-retains-only-root-and-empty-step-observations"
]

VerificationTest[
  With[ { scene = InfraScene[ { p }, { p == InfraPoint[] } ] },
    Map[ limits |-> With[ { data = InfraSceneMultiway[ scene, PathGraph[ { 1, 2 } ], Sequence @@ limits ] },
      { Length[ data[ "States" ] ], Length[ data[ "Events" ] ], data[ "Completeness" ][ "Scene" ] } ], {
        { "MaxStates" -> 3, "MaxEvents" -> 2, "MaxCandidates" -> 2 }, { "MaxEvents" -> 0 },
        { "MaxCandidates" -> 0 }, { "MaxStates" -> 1 } } ] ],
  { { 3, 2, True }, { 1, 0, False }, { 1, 0, False }, { 1, 0, False } }, TestID -> "multiway-all-exact-cap-boundaries"
]

VerificationTest[
  With[ { scene = InfraScene[ { p }, { p == InfraPoint[], p < 0 } ] },
    { data = InfraSceneMultiway[ scene, PathGraph[ { 1, 2 } ], "MaxStates" -> 1 ] },
    { Length[ data[ "States" ] ], Length[ data[ "Events" ] ], data[ "Completeness" ][ "Scene" ] } ],
  { 1, 2, True }, TestID -> "multiway-saturated-state-cap-still-admits-rejected-events"
]

VerificationTest[
  With[ { scene = InfraScene[ { p }, { p == InfraPoint[] } ] },
    { data = InfraSceneMultiway[ scene, PathGraph[ { 1, 2 } ], <| p -> 1 |>, "MaxCandidates" -> 0 ] },
    { Lookup[ Values[ data[ "Events" ] ], "Outcome" ], data[ "Statistics" ][ "Candidates" ],
      First[ data[ "Expansions" ] ][ "PoolSize" ], data[ "Completeness" ][ "Scene" ] } ],
  { { "Fixed" }, 0, 0, True }, TestID -> "multiway-fixed-skip-consumes-event-but-no-candidates"
]

VerificationTest[
  With[ { scene = InfraScene[ { p, q }, { InfraStep[ { p == InfraMidpoint[ 1, 2 ] } ], InfraStep[ { q == InfraPoint[] } ] } ] },
    { data = InfraSceneMultiway[ scene, PathGraph[ { 1, 2 } ] ] },
    { Lookup[ Values[ data[ "Layers" ] ], "States" ], Lookup[ Values[ data[ "Layers" ] ], "Complete" ],
      data[ "Completeness" ][ "Scene" ] } ],
  { { { 1 }, { }, { } }, { True, True, True }, True }, TestID -> "multiway-completely-empty-layer-propagates-certificate"
]

VerificationTest[
  With[ { scene = InfraScene[ { p }, { p == InfraMidpoint[ 1, 2, "Unknown" -> 1 ] } ] },
    { data = InfraSceneMultiway[ scene, PathGraph[ { 1, 2 } ] ] },
    { data[ "Layers" ][ 0 ][ "Complete" ], data[ "Layers" ][ 1 ][ "Complete" ],
      First[ data[ "Expansions" ] ][ "PoolSize" ], data[ "Completeness" ][ "Reasons" ] } ],
  { True, False, Missing[ "Unknown" ], { "Unsupported" } }, TestID -> "multiway-unsupported-pool-does-not-invalidate-known-root"
]

VerificationTest[
  Map[ selector |-> Head[ InfraSceneMultiway[
      InfraScene[ { p }, { p == InfraPoint[ "NextVertexFunction" -> selector ] } ], PathGraph[ { 1, 2 } ] ] ],
    { RandomChoice, RandomSample, ( vertices |-> Reverse[ vertices ] ) } ],
  ConstantArray[ InfraSceneMultiway, 3 ], TestID -> "multiway-stochastic-and-callback-selectors-are-excluded"
]

VerificationTest[
  With[ { graph = PathGraph[ Range[ 3 ] ], scene = InfraScene[ { w }, { w == InfraSegment[ 1, 3, 1 ] } ] },
    { data = InfraSceneMultiway[ scene, graph ] },
    { data[ "States" ][ 2 ][ "Bindings" ][ w ], Length[ data[ "States" ][ 2 ][ "Bindings" ][ w ] ] - 1,
      data[ "Schedule" ][ 1 ][ "Kinds" ] } ],
  { { 1, 2, 3, 2, 1 }, 4, { "Walk" } }, TestID -> "multiway-ordered-walk-repetition-is-saved-exactly"
]

VerificationTest[
  With[ { graph = Graph[ { InfraBall[ 1, "Select" -> RandomChoice ], { 2, 1 } }, { } ],
      scene = InfraScene[ { p }, { p == InfraPoint[] } ] },
    { data = InfraSceneMultiway[ scene, graph ] },
    { Sort[ First /@ data[ "Instances" ] ], data[ "Completeness" ][ "Scene" ] } ],
  { Sort[ { <| p -> InfraBall[ 1, "Select" -> RandomChoice ] |>, <| p -> { 2, 1 } |> } ], True },
  TestID -> "multiway-infra-headed-and-list-point-labels-remain-literal"
]

VerificationTest[
  With[ { graph = PathGraph[ Range[ 3 ] ], scene = InfraScene[ { region }, { region == InfraBall[ 2, 1 ] } ] },
    { data = InfraSceneMultiway[ scene, graph, <| region -> { 3, 1, 2, 1 } |> ] },
    { data[ "InitialBindings" ], data[ "Instances" ], data[ "Schedule" ][ 1 ][ "Kinds" ] } ],
  { <| region -> { 1, 2, 3 } |>, { InfraSceneInstance[ <| region -> { 1, 2, 3 } |> ] }, { "VertexSet" } },
  TestID -> "multiway-only-declared-set-bindings-normalize"
]

VerificationTest[
  With[ { scene = InfraScene[ { p }, { p == InfraPoint[] } ], graph = PathGraph[ { 1, 2 } ] },
    { data = InfraSceneMultiway[ scene, graph ] },
    { Sort[ Keys[ data ] ], AllTrue[ Values[ data[ "States" ] ], state |->
        Sort[ Keys[ state ] ] === Sort[ { "Bindings", "Completed", "Depth", "Group", "Assertions", "IncomingEvents" } ] ],
      AllTrue[ Values[ data[ "Events" ] ], event |-> Sort[ Keys[ event ] ] ===
        Sort[ { "Source", "Target", "Construction", "Group", "CandidateIndex", "Candidate", "Outcome", "Assertions" } ] ],
      data[ "Options" ][ "PoolAcquisition" ], data[ "Substrate" ] === graph } ],
  { Sort[ { "Scene", "Substrate", "InitialBindings", "Options", "Schedule", "Root", "States", "Events", "StateGraph", "Layers",
      "StepLayers", "Instances", "Expansions", "Frontier", "Diagnostics", "Completeness", "Statistics" } ], True, True, "EagerAll", True },
  TestID -> "multiway-output-schema-and-immutable-inputs"
]

VerificationTest[
  With[ { scene = InfraScene[ { p }, { p == InfraPoint[] } ], graph = PathGraph[ { 1, 2 } ] },
    Map[ option |-> Head[ InfraSceneMultiway[ scene, graph, option ] ], {
      "Steps" -> -1, "MaxDepth" -> -1, "MaxStates" -> 0, "MaxEvents" -> -1,
      "MaxCandidates" -> 1.5, "MaxTime" -> 0, "Unknown" -> 1 } ] ],
  ConstantArray[ InfraSceneMultiway, 7 ], TestID -> "multiway-unsupported-limit-arguments-stay-unevaluated"
]

VerificationTest[
  With[ { scene = InfraScene[ { p }, { p == InfraPoint[] } ] },
    Map[ graph |-> Head[ InfraSceneMultiway[ scene, graph ] ], {
      PathGraph[ { 1, 2 }, DirectedEdges -> True ], Graph[ { 1, 2 }, { UndirectedEdge[ 1, 2 ] }, EdgeWeight -> { 2 } ] } ] ],
  { InfraSceneMultiway, InfraSceneMultiway }, TestID -> "multiway-unsupported-substrate-domain-stays-unevaluated"
]

VerificationTest[
  With[ { scene = InfraScene[ { p }, { p == InfraPoint[] } ] },
    { data = InfraSceneMultiway[ scene, PathGraph[ { 1, 2 } ] ] },
    { Head[ InfraBranchialGraph[ data, -1 ] ], Head[ InfraBranchialGraph[ data, 2 ] ], Head[ InfraBranchialGraph[ data, 1.5 ] ] } ],
  { InfraBranchialGraph, InfraBranchialGraph, InfraBranchialGraph }, TestID -> "branchial-unrecorded-and-invalid-depth-stays-unevaluated"
]

VerificationTest[
  With[ { data = <| "States" -> <| 1 -> <| "Depth" -> 0 |>, 2 -> <| "Depth" -> 1 |>, 3 -> <| "Depth" -> 1 |>,
        4 -> <| "Depth" -> 2 |>, 5 -> <| "Depth" -> 2 |> |>,
      "Layers" -> <| 2 -> <| "States" -> { 4, 5 }, "Complete" -> True |> |>, "Frontier" -> { },
      "Events" -> AssociationThread[ Range[ 6 ], Map[ pair |->
        <| "Source" -> First[ pair ], "Target" -> Last[ pair ], "Outcome" -> "Accepted" |>,
        { { 1, 2 }, { 1, 3 }, { 2, 4 }, { 3, 5 }, { 2, 5 }, { 2, 4 } } ] ] |> },
    { projected = InfraBranchialGraph[ data, 2 ] },
    { VertexList[ projected[ "Graph" ] ], EdgeList[ projected[ "Graph" ] ], projected[ "Witnesses" ], projected[ "Complete" ] } ],
  { { 4, 5 }, { UndirectedEdge[ 4, 5 ] }, <| UndirectedEdge[ 4, 5 ] -> { 2 } |>, True },
  TestID -> "branchial-immediate-parent-witnesses-ignore-duplicate-events"
]

VerificationTest[
  Internal`InheritedBlock[ { RandomInfraPoint },
    RandomInfraPoint[ graph_Graph, InfraPoint[ "DuplicateFixture" ], All ] := { 1, 1 };
    With[ { data = InfraSceneMultiway[ InfraScene[ { p }, { p == InfraPoint[ "DuplicateFixture" ] } ],
        PathGraph[ { 1, 2 } ], "MaxStates" -> 2, "MaxEvents" -> 2, "MaxCandidates" -> 2 ] },
      { Length[ data[ "States" ] ], Length[ data[ "Events" ] ], data[ "States" ][ 2 ][ "IncomingEvents" ],
        Lookup[ Values[ data[ "Events" ] ], "CandidateIndex" ], EdgeCount[ data[ "StateGraph" ] ], data[ "Completeness" ][ "Scene" ] } ] ],
  { 2, 2, { 1, 2 }, { 1, 2 }, 1, True }, TestID -> "multiway-duplicate-candidates-retain-parallel-events-under-saturated-state-cap"
]

VerificationTest[
  Internal`InheritedBlock[ { RandomInfraBall },
    RandomInfraBall[ graph_Graph, InfraBall[ "SetFixture" ], All ] := { { 3, 1, 1 }, { 1, 3 } };
    With[ { data = InfraSceneMultiway[ InfraScene[ { region }, { region == InfraBall[ "SetFixture" ] } ],
        PathGraph[ Range[ 3 ] ] ] },
      { Length[ data[ "States" ] ], Length[ data[ "Events" ] ], data[ "Instances" ],
        Lookup[ Values[ data[ "Events" ] ], "Candidate" ] } ] ],
  { 2, 2, { InfraSceneInstance[ <| region -> { 1, 3 } |> ] }, { { 3, 1, 1 }, { 1, 3 } } },
  TestID -> "multiway-declared-set-normalization-merges-bindings-preserving-raw-candidates"
]

VerificationTest[
  Internal`InheritedBlock[ { RandomInfraPoint },
    RandomInfraPoint[ graph_Graph, InfraPoint[ "SlowFixture" ], All ] := ( Pause[ 1 ]; { 1 } );
    With[ { data = InfraSceneMultiway[ InfraScene[ { p }, { p == InfraPoint[ "SlowFixture" ] } ],
        PathGraph[ { 1, 2 } ], "MaxTime" -> 0.1 ] },
      { data[ "Instances" ], Length[ data[ "Events" ] ], data[ "Completeness" ][ "Scene" ],
        First[ data[ "Frontier" ] ][ "Reason" ], First[ data[ "Expansions" ] ][ "PoolSize" ],
        data[ "Layers" ][ 0 ][ "Complete" ] } ] ],
  { { }, 0, False, "TimeLimit", Missing[ "Unknown" ], True }, TestID -> "multiway-time-limited-pool-is-unknown-not-empty"
]

VerificationTest[
  With[ { scene = InfraScene[ { w }, { w == InfraInfiniteLine[ 2, 2, "Branches" -> 1 ] } ], graph = PathGraph[ Range[ 3 ] ] },
    { data = InfraSceneMultiway[ scene, graph ] },
    { Length[ data[ "Instances" ] ], First[ data[ "Expansions" ] ][ "PoolSize" ],
      First[ data[ "Expansions" ] ][ "SelectedPoolSize" ], First[ Values[ data[ "Events" ] ] ][ "CandidateIndex" ],
      data[ "Completeness" ][ "Scene" ], data[ "Instances" ] === RandomInfraInstance[ scene, graph, All ] } ],
  { 1, 2, 1, 1, True, True }, TestID -> "multiway-declared-branches-preserves-eager-acquisition-cost"
]

VerificationTest[
  Internal`InheritedBlock[ { RandomInfraInfiniteLine },
    RandomInfraInfiniteLine[ graph_Graph, InfraInfiniteLine[ "SelectionFixture" ], All ] :=
      { { 1, 2, 3 }, { 1, 2 }, { 3, 2, 1 } };
    With[ { data = InfraSceneMultiway[ InfraScene[ { w },
          { w == InfraInfiniteLine[ "SelectionFixture", "Select" -> "MinLength" ] } ], PathGraph[ Range[ 3 ] ] ] },
      { data[ "Instances" ], First[ Values[ data[ "Events" ] ] ][ "CandidateIndex" ],
        First[ data[ "Expansions" ] ][ "PoolSize" ], First[ data[ "Expansions" ] ][ "Examined" ],
        data[ "Completeness" ][ "Scene" ] } ] ],
  { { InfraSceneInstance[ <| w -> { 1, 2 } |> ] }, 2, 3, 1, True },
  TestID -> "multiway-select-keeps-original-raw-candidate-ordinal"
]

VerificationTest[
  With[ { graph = PathGraph[ { 1, 2 } ],
      scene = InfraScene[ { p, q }, { InfraStep[ { p == InfraPoint[], q == InfraPoint[] } ] } ] },
    { reference = unmergedSceneReference[ {
        { 1, { p }, { }, bindings |-> VertexList[ graph ] },
        { 1, { q }, { }, bindings |-> VertexList[ graph ] } }, <| |> ], data = InfraSceneMultiway[ scene, graph ] },
    { keys = Map[ state |-> { state[ "Completed" ], state[ "Bindings" ] }, data[ "States" ] ],
      accepted = Select[ reference[ "Events" ], event |-> Last[ event ] === "Accepted" ] },
    AllTrue[ { 0, 1, 2 }, depth |->
      With[ { layer = Select[ reference[ "States" ], state |-> Length[ First[ state ] ] === depth ] },
        { expected = Select[ Subsets[ layer, { 2 } ], pair |-> Intersection[
            First /@ Select[ accepted, event |-> event[[ 4 ]] === pair[[ 1 ]] ],
            First /@ Select[ accepted, event |-> event[[ 4 ]] === pair[[ 2 ]] ] ] =!= { } ],
          observed = ( edge |-> Sort[ keys /@ ( List @@ edge ) ] ) /@ EdgeList[ InfraBranchialGraph[ data, depth ][ "Graph" ] ] },
        Sort[ Sort /@ expected ] === Sort[ observed ] ] ] ],
  True, TestID -> "branchial-independent-unmerged-immediate-parent-reference"
]

VerificationTest[
  With[ { scene = InfraScene[ { p }, { p == InfraPoint[], InfraGeometricAssertion[ { p }, "Unknown" ] } ] },
    { data = InfraSceneMultiway[ scene, PathGraph[ { 1, 2 } ] ] },
    { data[ "Layers" ][ 0 ][ "Complete" ], data[ "Layers" ][ 1 ][ "Complete" ],
      Length[ data[ "States" ] ], Length[ data[ "Events" ] ], data[ "Instances" ] } ],
  { True, False, 3, 2, { } }, TestID -> "multiway-unsupported-extensions-invalidate-successor-certificate"
]

VerificationTest[
  With[ { graph = PathGraph[ Range[ 3 ] ],
      scene = InfraScene[ { p, q }, { InfraStep[ { p == InfraPoint[] } ], InfraStep[ { q == InfraPoint[] } ], p < q } ] },
    { data = InfraSceneMultiway[ scene, graph, "Steps" -> 1 ] },
    { data[ "Completeness" ], DeleteDuplicates[ Values[ # [ "Assertions" ] ] & /@ Values[ data[ "States" ] ] ],
      AllTrue[ data[ "Frontier" ], obligation |-> obligation[ "Reason" ] === "StepsLimit" ] } ],
  { <| "Requested" -> True, "Scene" -> False, "Reasons" -> { "StepsLimit" } |>, { { "Pending" } }, True },
  TestID -> "multiway-pending-prefix-certifies-requested-boundary-only"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ InfraSceneMultiway[ InfraScene[ { sceneTarget }, { sceneTarget == InfraPoint[] } ], PathGraph[ { 1, 2, 3 } ] ][ "Instances" ],
  { 1, 2, 3 },
  TestID -> "synthetic-t8-dispatch-Point"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ InfraSceneMultiway[ InfraScene[ { sceneTarget }, { sceneTarget == InfraSegment[ 1, 3 ] } ], PathGraph[ { 1, 2, 3 } ] ][ "Instances" ],
  { { 1, 2, 3 } },
  TestID -> "synthetic-t8-dispatch-Segment"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ InfraSceneMultiway[ InfraScene[ { sceneTarget }, { sceneTarget == InfraHalfLine[ 1, 2 ] } ], PathGraph[ { 1, 2, 3 } ] ][ "Instances" ],
  { { 1, 2, 3 } },
  TestID -> "synthetic-t8-dispatch-HalfLine"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ InfraSceneMultiway[ InfraScene[ { sceneTarget }, { sceneTarget == InfraInfiniteLine[ 1, 2 ] } ], PathGraph[ { 1, 2, 3 } ] ][ "Instances" ],
  { { 1, 2, 3 } },
  TestID -> "synthetic-t8-dispatch-InfiniteLine"
]

VerificationTest[
  Sort /@ ( ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ InfraSceneMultiway[ InfraScene[ { sceneTarget }, { sceneTarget == InfraCircle[ 1, 1 ] } ], Graph[ Range[ 5 ], UndirectedEdge @@@ { { 1, 2 }, { 1, 3 }, { 1, 4 }, { 1, 5 }, { 2, 3 }, { 3, 4 }, { 4, 5 }, { 5, 2 } } ] ][ "Instances" ] ),
  { { 2, 3, 4, 5 } },
  TestID -> "synthetic-t8-dispatch-Circle"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ InfraSceneMultiway[ InfraScene[ { sceneTarget }, { sceneTarget == InfraArc[ 1, { 2, 4 } ] } ], Graph[ Range[ 5 ], UndirectedEdge @@@ { { 1, 2 }, { 1, 3 }, { 1, 4 }, { 1, 5 }, { 2, 3 }, { 3, 4 }, { 4, 5 }, { 5, 2 } } ] ][ "Instances" ],
  { { 2, 3, 4 }, { 2, 5, 4 } },
  TestID -> "synthetic-t8-dispatch-Arc"
]

VerificationTest[
  Sort /@ ( ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ InfraSceneMultiway[ InfraScene[ { sceneTarget }, { sceneTarget == InfraRegularPolygon[ { 1, 2 }, 4 ] } ], CycleGraph[ 4 ] ][ "Instances" ] ),
  { { 1, 2, 3, 4 } },
  TestID -> "synthetic-t8-dispatch-RegularPolygon"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ InfraSceneMultiway[ InfraScene[ { sceneTarget }, { sceneTarget == InfraPlane[ 1, 3 ] } ], PathGraph[ { 1, 2, 3 } ] ][ "Instances" ],
  { { 2 } },
  TestID -> "synthetic-t8-dispatch-Plane"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ InfraSceneMultiway[ InfraScene[ { sceneTarget }, { sceneTarget == InfraBall[ 2, 1 ] } ], PathGraph[ { 1, 2, 3 } ] ][ "Instances" ],
  { { 1, 2, 3 } },
  TestID -> "synthetic-t8-dispatch-Ball"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ InfraSceneMultiway[ InfraScene[ { sceneTarget }, { sceneTarget == InfraShell[ 2, 1 ] } ], PathGraph[ { 1, 2, 3 } ] ][ "Instances" ],
  { { 1, 3 } },
  TestID -> "synthetic-t8-dispatch-Shell"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ InfraSceneMultiway[ InfraScene[ { sceneTarget }, { sceneTarget == InfraSphere[ 1, 1 ] } ], PathGraph[ { 1, 2, 3 } ] ][ "Instances" ],
  { { 2 } },
  TestID -> "synthetic-t8-dispatch-Sphere"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ InfraSceneMultiway[ InfraScene[ { sceneTarget }, { sceneTarget == InfraTube[ { 1, 2 }, 0, Method -> "Balls" ] } ], PathGraph[ { 1, 2, 3 } ] ][ "Instances" ],
  { { 1, 2 } },
  TestID -> "synthetic-t8-dispatch-Tube"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ InfraSceneMultiway[ InfraScene[ { sceneTarget }, { sceneTarget == InfraCylinder[ { 1, 2 }, 0, Method -> "Balls" ] } ], PathGraph[ { 1, 2, 3 } ] ][ "Instances" ],
  { { 1, 2 } },
  TestID -> "synthetic-t8-dispatch-Cylinder"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ InfraSceneMultiway[ InfraScene[ { sceneTarget }, { sceneTarget == InfraCone[ { 1, 2 }, 0, Method -> "Balls" ] } ], PathGraph[ { 1, 2, 3 } ] ][ "Instances" ],
  { { 1, 2 } },
  TestID -> "synthetic-t8-dispatch-Cone"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ InfraSceneMultiway[ InfraScene[ { sceneTarget }, { sceneTarget == InfraSolidOfRevolution[ { 1, 2 }, i |-> 0, Method -> "Balls" ] } ], PathGraph[ { 1, 2, 3 } ] ][ "Instances" ],
  { { 1, 2 } },
  TestID -> "synthetic-t8-dispatch-SolidOfRevolution"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ InfraSceneMultiway[ InfraScene[ { sceneTarget }, { sceneTarget == InfraBallHull[ { 2 } ] } ], PathGraph[ { 1, 2, 3 } ] ][ "Instances" ],
  { { 2 } },
  TestID -> "synthetic-t8-dispatch-BallHull"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ InfraSceneMultiway[ InfraScene[ { sceneTarget }, { sceneTarget == InfraConvexHull[ { 1, 3 } ] } ], PathGraph[ { 1, 2, 3 } ] ][ "Instances" ],
  { { 1, 2, 3 } },
  TestID -> "synthetic-t8-dispatch-ConvexHull"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ InfraSceneMultiway[ InfraScene[ { sceneTarget }, { sceneTarget == InfraQuadric[ { 1, 3 }, 2 ] } ], PathGraph[ { 1, 2, 3 } ] ][ "Instances" ],
  { { 1, 2, 3 } },
  TestID -> "synthetic-t8-dispatch-Quadric"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ InfraSceneMultiway[ InfraScene[ { sceneTarget }, { sceneTarget == InfraWalk[ 1, 2, 1 ] } ], PathGraph[ { 1, 2, 3 } ] ][ "Instances" ],
  { { 1, 2, 1 } },
  TestID -> "synthetic-t8-dispatch-Walk"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ InfraSceneMultiway[ InfraScene[ { sceneTarget }, { sceneTarget == InfraGeodesic[ { 1, 2 }, Infinity ] } ], PathGraph[ { 1, 2, 3 } ] ][ "Instances" ],
  { { 1, 2, 3 } },
  TestID -> "synthetic-t8-dispatch-Geodesic"
]

VerificationTest[
  Sort /@ ( VertexList /@ ( ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ InfraSceneMultiway[ InfraScene[ { sceneTarget }, { sceneTarget == InfraEllipse[ { 1, 3 }, 2, Properties -> {} ] } ], CycleGraph[ 4 ] ][ "Instances" ] ) ),
  { { 1, 2, 3, 4 } },
  TestID -> "synthetic-t8-dispatch-Ellipse"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ InfraSceneMultiway[ InfraScene[ { sceneTarget }, { sceneTarget == InfraIntersection[ InfraBall[ 1, 1 ], InfraBall[ 3, 1 ] ] } ], PathGraph[ { 1, 2, 3 } ] ][ "Instances" ],
  { 2 },
  TestID -> "synthetic-t8-dispatch-Intersection"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ InfraSceneMultiway[ InfraScene[ { sceneTarget }, { sceneTarget == InfraUnion[ InfraBall[ 1, 0 ], InfraBall[ 3, 0 ] ] } ], PathGraph[ { 1, 2, 3 } ] ][ "Instances" ],
  { 1, 3 },
  TestID -> "synthetic-t8-dispatch-Union"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ InfraSceneMultiway[ InfraScene[ { sceneTarget }, { sceneTarget == InfraMidpoint[ 1, 3 ] } ], CycleGraph[ 4 ] ][ "Instances" ],
  { 2, 4 },
  TestID -> "synthetic-t8-dispatch-Midpoint"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ InfraSceneMultiway[ InfraScene[ { sceneTarget }, { sceneTarget == InfraPerpendicularBisector[ 1, 2 ] } ], CompleteGraph[ 3 ] ][ "Instances" ],
  { 3 },
  TestID -> "synthetic-t8-dispatch-PerpendicularBisector"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ InfraSceneMultiway[ InfraScene[ { sceneTarget }, { sceneTarget == InfraRegionNearest[ { 1, 3 }, 2 ] } ], CycleGraph[ 4 ] ][ "Instances" ],
  { 1, 3 },
  TestID -> "synthetic-t8-dispatch-RegionNearest"
]


VerificationTest[
  With[ { scene = InfraScene[ { p }, { p == InfraPoint[] } ] },
    Head[ InfraSceneMultiway[ InfraScene[ KeyDrop[ First[ scene ], "ScheduleValidity" ] ], PathGraph[ { 1, 2 } ] ] ] ],
  InfraSceneMultiway, TestID -> "multiway-lossy-descriptor-without-syntax-provenance-stays-unevaluated"
]
