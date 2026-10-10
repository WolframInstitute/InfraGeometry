Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraSceneInteractive *)

PackageScope[ geodesicGraph ]
PackageScope[ geodesicCycleGraph ]

$InfraSegmentSelectOptions = { None, "Central", "Peripheral", "EmbeddingClosest" }

$InfraCircleSelectOptions = { None, "Central", "Peripheral",
  "MinLength", "MaxLength", "EmbeddingClosest" }

SetAttributes[ PointViewer, HoldRest ]

PointViewer[ g_Graph, sym_: None ] :=
  With[ { diam = GraphDiameter[ g ],
          regions = <| "Random" -> VertexList[ g ], "Center" -> GraphCenter[ g ], "Periphery" -> GraphPeriphery[ g ] |> },
    Manipulate[
      seed;
      With[ { pts = RandomInfraPoint[ g, regions[ region ], UpTo[ n ], "MaxCliques" -> 100,
          "PairwiseDistance" -> Switch[ separation, "None", None, "Max", "Max", "Range", distRange ] ] },
        If[ sym =!= None, sym = pts ];
        InfraSubstrateHighlight[ g, { InfraDensity[ g, pts ] } ] ],
      Grid[ {
        { Control[ { { n, 1, "Points" }, ControlType -> InputField } ],
          Control[ { { region, "Random", "Region" }, { "Random", "Center", "Periphery" } } ] },
        { Control[ { { separation, "None", "Separation" }, { "None", "Max", "Range" } } ],
          Control[ { { distRange, { 0, diam }, "Distance" }, 0, diam, 1,
            ControlType -> IntervalSlider, Enabled -> Dynamic[ separation === "Range" ] } ] }
      }, Alignment -> Center, ItemSize -> { { Scaled[ 0.5 ], Scaled[ 0.5 ] } } ],
      { { seed, 0 }, None },
      Button[ "Resample", seed++ ],
      TrackedSymbols :> { seed, n, region, separation, distRange },
      SaveDefinitions -> True
    ]
  ]

SegmentViewer[ g_Graph ] :=
  With[ {
      initPts     = RandomSample[ VertexList[ g ], 2 ],
      nearestFunc = Nearest[ GraphEmbedding[ g ] -> VertexList[ g ] ],
      selOpts     = $InfraSegmentSelectOptions },
    Manipulate[
      seed;
      With[ {
          segments = If[ sel === None || p1 === p2 || GraphDistance[ g, p1, p2 ] === Infinity, {},
            Take[
              applySelectOption[ g, RandomInfraSegment[ g, p1, p2, All ],
                sel, False, <| "Endpoints" -> { p1, p2 } |> ],
              UpTo[ n ] ] ] },
        EventHandler[
          HighlightGraph[
            InfraSubstrateHighlight[ g, { If[ sel === None, InfraSegment[ p1, p2 ], geodesicGraph /@ segments ] } ],
            { Style[ p1, Directive[ $InfraStrikeOutPalette[[ 2 ]], AbsolutePointSize[ 16 ] ] ],
              Style[ p2, Directive[ $InfraStrikeOutPalette[[ 2 ]], AbsolutePointSize[ 16 ] ] ] } ],
          { "MouseClicked" :> With[ { mp = MousePosition[ "Graphics" ] },
            If[ mp =!= None,
              With[ { clicked = First @ nearestFunc[ mp ] },
                p1 = p2; p2 = clicked; seed++ ] ] ] },
          PassEventsDown -> True
        ]
      ],
      { { p1, initPts[[ 1 ]] }, None },
      { { p2, initPts[[ 2 ]] }, None },
      { { seed, 0 }, None },
      { { n, 12, "Segments" }, 1, 12, 1, Appearance -> "Labeled" },
      { { sel, None, "Select (ambiguity resolver)" }, selOpts, ControlType -> SetterBar },
      Button[ "Resample", With[ { pts = RandomSample[ VertexList[ g ], 2 ] },
        p1 = pts[[ 1 ]]; p2 = pts[[ 2 ]]; seed++ ] ],
      TrackedSymbols :> { p1, p2, seed, n, sel },
      SaveDefinitions -> True
    ]
  ]

ShellViewer[ g_Graph ] :=
  With[ {
      initPt      = RandomChoice[ VertexList[ g ] ],
      nearestFunc = Nearest[ GraphEmbedding[ g ] -> VertexList[ g ] ],
      diam        = Max[ GraphDiameter[ g ], 2 ] },
    Manipulate[
      seed;
      With[ {
          shells = If[ r < 1, {},
            RandomInfraSphere[ g, p, r, UpTo[ n ], "NextVertexFunction" -> Identity,
              Properties -> properties ] ] },
        EventHandler[
          HighlightGraph[
            InfraSubstrateHighlight[ g, { shells } ],
            { Style[ p, Directive[ $InfraStrikeOutPalette[[ 2 ]], AbsolutePointSize[ 16 ] ] ] } ],
          { "MouseClicked" :> With[ { mp = MousePosition[ "Graphics" ] },
            If[ mp =!= None,
              With[ { clicked = First @ nearestFunc[ mp ] }, p = clicked; seed++ ] ] ] },
          PassEventsDown -> True
        ]
      ],
      { { p, initPt }, None },
      { { seed, 0 }, None },
      { { r, Max[ 1, Round[ diam / 3 ] ], "Radius" }, 1, diam, 1, Appearance -> "Labeled" },
      { { n, 12, "Shells" }, 1, 12, 1, Appearance -> "Labeled" },
      { { properties, { }, "Properties" },
        { { } -> "Level set", { "Separating" } -> "Separating", { "Separating", "Connected" } -> "Sep+Conn" },
        ControlType -> SetterBar },
      Button[ "Resample", p = RandomChoice[ VertexList[ g ] ]; seed++ ],
      TrackedSymbols :> { p, seed, r, n, properties },
      SaveDefinitions -> True
    ]
  ]

CircleViewer[ g_Graph ] :=
  With[ {
      initPt      = RandomChoice[ VertexList[ g ] ],
      nearestFunc = Nearest[ GraphEmbedding[ g ] -> VertexList[ g ] ],
      selOpts     = $InfraCircleSelectOptions,
      diam        = Max[ GraphDiameter[ g ], 2 ] },
    Manipulate[
      seed;
      With[ {
          circles = If[ sel === None || r < 1, {},
            Take[
              applySelectOption[ g, RandomInfraCircle[ g, InfraCircle[ p, r ], All ],
                sel, True, <| "Center" -> p, "Radius" -> r |> ],
              UpTo[ n ] ] ] },
        EventHandler[
          HighlightGraph[
            InfraSubstrateHighlight[ g, { If[ sel === None, InfraCircle[ p, r ], geodesicCycleGraph /@ circles ] } ],
            { Style[ p, Directive[ $InfraStrikeOutPalette[[ 2 ]], AbsolutePointSize[ 16 ] ] ] } ],
          { "MouseClicked" :> With[ { mp = MousePosition[ "Graphics" ] },
            If[ mp =!= None,
              With[ { clicked = First @ nearestFunc[ mp ] }, p = clicked; seed++ ] ] ] },
          PassEventsDown -> True
        ]
      ],
      { { p, initPt }, None },
      { { seed, 0 }, None },
      { { r, Max[ 1, Round[ diam / 3 ] ], "Radius" }, 1, diam, 1, Appearance -> "Labeled" },
      { { n, 12, "Circles" }, 1, 12, 1, Appearance -> "Labeled" },
      { { sel, None, "Select (ambiguity resolver)" }, selOpts, ControlType -> SetterBar },
      Button[ "Resample", p = RandomChoice[ VertexList[ g ] ]; seed++ ],
      TrackedSymbols :> { p, seed, r, n, sel },
      SaveDefinitions -> True
    ]
  ]

Options[ InfraSceneViewer ] = {
  "OpacityRange"   :> $InfraOpacityRange,
  "ThicknessRange" -> Automatic,
  "PointSizeRange" -> Automatic,
  ImageSize        -> 500
}

InfraSceneViewer[ data_Association, opts : OptionsPattern[] ] /;
    ContainsAll[ Keys[ data ], { "Scene", "Substrate", "InitialBindings", "Schedule", "States", "Events",
      "Layers", "StepLayers", "Completeness", "Frontier" } ] && GraphQ[ data[ "Substrate" ] ] &&
    AllTrue[ { "InitialBindings", "Schedule", "States", "Events", "Layers", "StepLayers" },
      key |-> AssociationQ[ data[ key ] ] ] && data[ "Layers" ] =!= <| |> &&
    SubsetQ[ First /@ Options[ InfraSceneViewer ], First /@ { opts } ] :=
  With[ { graph = data[ "Substrate" ], states = data[ "States" ], events = data[ "Events" ],
      kinds = Association @ Catenate[ Map[ entry |-> Normal @ AssociationThread[ entry[ "Targets" ], entry[ "Kinds" ] ],
        Values[ data[ "Schedule" ] ] ] ],
      highlightOptions = FilterRules[ { opts }, Options[ InfraSubstrateHighlight ] ] },
    DynamicModule[ { navigation = "Event depth", boundary = First @ Keys[ data[ "Layers" ] ],
        selectedState = None, restriction = <| |>, incomingChoices = <| |> },
      Column[ {
        Row[ { SetterBar[ Dynamic[ navigation, value |-> ( navigation = value; boundary = 0; selectedState = None ) ],
            { "Event depth", "Group boundary" } ], "  ",
          Dynamic[ PopupMenu[ Dynamic[ boundary, value |-> ( boundary = value; selectedState = None ) ],
            Keys @ If[ navigation === "Event depth", data[ "Layers" ], data[ "StepLayers" ] ] ] ] } ],
        Row[ { "Binding restriction: ", InputField[ Dynamic[ restriction ], Expression ], "  ",
          Button[ "Clear restriction", restriction = <| |> ] } ],
        Dynamic[ With[ { collection = If[ navigation === "Event depth", data[ "Layers" ], data[ "StepLayers" ] ] },
          { layer = Lookup[ collection, Key[ boundary ], First @ Values[ collection ] ] },
          { depth = If[ navigation === "Event depth", boundary, layer[ "Depth" ] ],
            matching = If[ AssociationQ[ restriction ], Select[ layer[ "States" ], id |-> AllTrue[ Keys[ restriction ],
              name |-> KeyExistsQ[ states[ id ][ "Bindings" ], name ] &&
                Lookup[ states[ id ][ "Bindings" ], Key[ name ] ] === Lookup[ restriction, Key[ name ] ] ] ], { } ] },
          { projection = InfraBranchialGraph[ data, depth ] },
          { branchial = Subgraph[ projection[ "Graph" ], matching ],
            witnesses = KeySelect[ projection[ "Witnesses" ], edge |-> ContainsAll[ matching, List @@ edge ] ] },
          selectedState = If[ MemberQ[ matching, selectedState ], selectedState, First[ matching, None ] ];
          Column[ {
            Row[ { If[ TrueQ[ layer[ "Complete" ] ], "Complete", "Partial exploration" ],
              " at ", ToLowerCase[ navigation ], " ", boundary, "; event depth ", depth } ],
            Row[ { "Whole scene: ", Which[ TrueQ[ data[ "Completeness" ][ "Scene" ] ], "Complete",
              ContainsAny[ data[ "Completeness" ][ "Reasons" ], { "Unsupported", "UnboundInput" } ], "Undecided",
              True, "Partial exploration" ] } ],
            If[ data[ "Completeness" ][ "Reasons" ] === { }, Nothing,
              Row[ { "Exploration boundary: ", Row[ data[ "Completeness" ][ "Reasons" ], ", " ] } ] ],
            If[ restriction === <| |>, Nothing, Row[ { "Filtered view: ", restriction } ] ],
            Row[ { "Saved initial bindings: ", data[ "InitialBindings" ] } ],
            If[ data[ "Frontier" ] === { }, Nothing,
              Grid[ Prepend[ Map[ obligation |-> Lookup[ obligation,
                  { "Source", "Construction", "NextCandidate", "Reason" } ], data[ "Frontier" ] ],
                { "Unfinished state", "Construction", "Next candidate", "Reason" } ], Alignment -> Left ] ],
            If[ matching === { },
              Column[ { "No matching saved states at this boundary.",
                If[ TrueQ[ layer[ "Complete" ] ] && restriction === <| |>,
                  "This layer is exhaustively empty.", "This view makes no negative existence claim." ],
                InfraSubstrateHighlight[ graph, { }, Sequence @@ highlightOptions ] } ],
              With[ { state = states[ selectedState ] },
                { historyStates = Reverse @ DeleteCases[ NestWhileList[
                    id |-> With[ { eventID = Lookup[ incomingChoices, Key[ id ],
                        First[ states[ id ][ "IncomingEvents" ], None ] ] },
                      If[ eventID === None, None, events[ eventID ][ "Source" ] ] ],
                    selectedState, id |-> id =!= None, 1, state[ "Depth" ] + 1 ], None ] },
                { history = Map[ id |-> Lookup[ incomingChoices, Key[ id ], First[ states[ id ][ "IncomingEvents" ] ] ],
                    Rest[ historyStates ] ],
                  neighbors = AdjacencyList[ branchial, selectedState ] },
                Column[ {
                  Row[ { "State: ", PopupMenu[ Dynamic[ selectedState ], matching ],
                    "; event depth ", state[ "Depth" ], "; next group ", state[ "Group" ] } ],
                  Row[ { "Bindings: ", state[ "Bindings" ] } ],
                  If[ MemberQ[ Values[ state[ "Assertions" ] ], "Unsupported" ],
                    "Undecided: an unsupported assertion blocks this state.",
                    If[ MemberQ[ Values[ state[ "Assertions" ] ], "Pending" ],
                      "Undecided: assertions are pending at this state.", "Assertions decided." ] ],
                  Row[ { "Assertions: ", state[ "Assertions" ] } ],
                  Row[ {
                    InfraSubstrateHighlight[ graph, KeyValueMap[ { name, representative } |->
                      If[ VertexQ[ graph, representative ], Association[ representative -> 1 ],
                        Switch[ Lookup[ kinds, Key[ name ], "Exact" ],
                        "Point", Association[ representative -> 1 ],
                        "VertexSet", If[ VertexQ[ graph, representative ], Association[ representative -> 1 ],
                          AssociationThread[ representative, ConstantArray[ 1, Length[ representative ] ] ] ],
                        "Walk", If[ ListQ[ representative ] && ! VertexQ[ graph, representative ],
                          InfraWalk[ representative ], representative ],
                        _, representative ] ], state[ "Bindings" ] ], Sequence @@ highlightOptions ],
                    Graph[ branchial, VertexLabels -> "Name", VertexStyle -> { selectedState -> StandardRed } ] } ],
                  Row[ { "Branchial neighbors: ", neighbors } ],
                  If[ TrueQ[ projection[ "Complete" ] ],
                    If[ restriction === <| |>, "Branchial layer complete.", "Saved branchial layer complete; this view is filtered." ],
                    "Branchial edges have saved witnesses; missing edges are undecided." ],
                  Row[ { "Common-parent witnesses: ", witnesses } ],
                  If[ state[ "IncomingEvents" ] === { }, "Initial state: no incoming event.",
                    Row[ { "Incoming event: ", PopupMenu[
                      Dynamic[ Lookup[ incomingChoices, Key[ selectedState ], First[ state[ "IncomingEvents" ] ] ],
                        value |-> ( incomingChoices = Append[ incomingChoices, selectedState -> value ] ) ],
                      state[ "IncomingEvents" ] ] } ] ],
                  Row[ { "History event IDs: ", history } ],
                  Grid[ Prepend[ Map[ id |-> With[ { event = events[ Lookup[ incomingChoices, Key[ id ],
                        First[ states[ id ][ "IncomingEvents" ] ] ] ] },
                      { PopupMenu[ Dynamic[ Lookup[ incomingChoices, Key[ id ], First[ states[ id ][ "IncomingEvents" ] ] ],
                          value |-> ( incomingChoices = Append[ incomingChoices, id -> value ] ) ],
                          states[ id ][ "IncomingEvents" ] ],
                        event[ "Source" ], id, event[ "Construction" ], event[ "CandidateIndex" ],
                        event[ "Candidate" ], event[ "Outcome" ] } ], Rest[ historyStates ] ],
                    { "Event", "From", "To", "Construction", "Candidate index", "Saved candidate", "Outcome" } ],
                    Alignment -> Left ] } ] ] ] }, Alignment -> Left ] ],
          TrackedSymbols :> { navigation, boundary, selectedState, restriction, incomingChoices } ] }, Alignment -> Left ] ] ]

InfraSceneViewer[ scene_InfraScene, graph_Graph, init : _Association : <| |>, opts : OptionsPattern[ ] ] :=
  With[ {
      nSteps  = Length @ scene[ "Steps" ],
      labels  = scene[ "Labels" ],
      objects = scene[ "Objects" ],
      imgW    = OptionValue[ InfraSceneViewer, { opts }, ImageSize ],
      hlOpts  = FilterRules[ Join[ { opts }, Options[ InfraSceneViewer ] ], Options[ InfraSubstrateHighlight ] ],
      objStep = Association @@ Flatten[ MapIndexed[
        { syms, i } |-> ( ( # -> First[ i ] ) & /@ Flatten[ { syms } ] ), scene[ "Steps" ] ] ] },
    DynamicModule[ {
        step = 1, branch = 1, mode = "Branch",
        fixStack = { }, hiddenSteps = { },
        shown = { }, shownStep = 1, deadQ = False },
      With[ {
          effInit = ( If[ fixStack === { }, init, Last[ fixStack ][[ 2 ]] ] ) &,
          shownQ  = obj |-> ! MemberQ[ hiddenSteps, objStep[ obj ] ] },
        {
          refresh = (
            With[ { new = RandomInfraInstance[ scene, graph, All, effInit[ ], "Steps" -> step ] },
              If[ new === { },
                deadQ = True,
                deadQ = False;
                shown = new;
                shownStep = step;
                branch = Min[ branch, Length @ new ] ] ] ) & },
        {
          goStep = s |-> (
            step = Clip[ s, { 1, nSteps } ];
            branch = 1;
            refresh[ ] ) },
        refresh[ ];
        Pane[ Column[ {
          Grid[ { {
            Spacer[ 30 ],
            Row[ {
              iconButton[ leftArrowIcon, goStep[ step - 1 ] ], "  ",
              ActionMenu[
                Dynamic @ textChip[ Row[ { "step ", step, "/", nSteps,
                  If[ labels[[ step ]] === None, "", Row[ { ": ", labels[[ step ]] } ] ],
                  "  ", downChevron } ] ],
                Table[
                  Row[ { "step ", k,
                    If[ labels[[ k ]] === None, "", Row[ { ": ", labels[[ k ]] } ] ] } ] :> goStep[ k ],
                  { k, nSteps } ],
                Appearance -> None ],
              "  ", iconButton[ rightArrowIcon, goStep[ step + 1 ] ] } ],
            Dynamic @ iconButton[
              If[ MemberQ[ hiddenSteps, step ], eyeClosedIcon, eyeOpenIcon ],
              If[ MemberQ[ hiddenSteps, step ],
                hiddenSteps = DeleteCases[ hiddenSteps, step ],
                hiddenSteps = Append[ hiddenSteps, step ] ] ]
          } }, Alignment -> { { Center, Center, Right }, Center },
            ItemSize -> { { 2.4, Scaled[ .8 ], 2.4 }, Automatic } ],
          Grid[ { {
            SetterBar[ Dynamic @ mode, { "Branch", "Diffuse" } ],
            Dynamic @ Which[
              deadQ, alertChip[ Row[ { "does not exist \[LongDash] showing step ", shownStep } ] ],
              mode === "Diffuse", textChip[ Row[ { Length @ shown, " branches diffused" } ] ],
              True, Row[ {
                Checkbox[ Dynamic[ MemberQ[ fixStack[[ All, 1 ]], step ],
                  nv |-> (
                    If[ nv,
                      fixStack = Append[ fixStack, { step, shown[[ Min[ branch, Length @ shown ], 1 ]] } ],
                      fixStack = Select[ fixStack, First[ # ] < step & ] ];
                    refresh[ ] ) ] ], " Fixed",
                Spacer[ 14 ],
                iconButton[ leftArrowIcon, branch = Max[ branch - 1, 1 ] ],
                textChip[ Row[ { "branch ", Min[ branch, Max[ Length @ shown, 1 ] ],
                  "/", Length @ shown } ] ],
                iconButton[ rightArrowIcon, branch = Min[ branch + 1, Max[ Length @ shown, 1 ] ] ] } ] ]
          } }, Alignment -> { { Left, Right }, Center },
            ItemSize -> { { Scaled[ .4 ], Scaled[ .6 ] }, Automatic } ],
          Dynamic @ If[ shown === { },
            InfraSubstrateHighlight[ graph, { }, Sequence @@ hlOpts, ImageSize -> imgW ],
            InfraSubstrateHighlight[ graph,
              If[ mode === "Diffuse",
                With[ { boundKeys = Keys @ First[ shown ][[ 1 ]] },
                  ( obj |-> With[ { reps = DeleteDuplicates[ #[[ 1 ]][ obj ] & /@ shown ] },
                      If[ AllTrue[ reps, pointQ[ graph, # ] & ], KeySort @ Counts @ reps, reps ] ] ) /@
                  Select[ objects, MemberQ[ boundKeys, # ] && shownQ[ # ] & ] ],
                Values @ KeySelect[ shown[[ Min[ branch, Length @ shown ], 1 ]], shownQ ] ],
              Sequence @@ hlOpts, ImageSize -> imgW ] ]
        }, Alignment -> Center ], ImageSize -> imgW ]
      ]
    ]
  ]

makeIcon[ icon_, roundedSide_: "both", widthFactor_: 1, heightFactor_: 1,
    background_: LightDarkSwitched[ GrayLevel[ .9 ], GrayLevel[ .3 ] ] ] :=
  Graphics[ {
    { background, Rectangle[ { -widthFactor, -heightFactor }, { widthFactor, heightFactor },
      RoundingRadius -> Switch[ roundedSide, "left", { Left -> .5 }, "right", { Right -> .5 }, "both", .5 ] ] },
    { Thick, StandardBlue, icon } },
    ImageSize -> 20 { widthFactor, heightFactor }, AspectRatio -> Full, PlotRangePadding -> None ]

leftArrowIcon  :=
  makeIcon[ Line[ { { .25, .5 }, { -.25, 0 }, { .25, -.5 } } ], "left", 1, 1.45 ]
rightArrowIcon :=
  makeIcon[ Line[ { { -.25, .5 }, { .25, 0 }, { -.25, -.5 } } ], "right", 1, 1.45 ]

downChevron :=
  Graphics[ { StandardBlue, Thick, CapForm[ "Round" ],
    Line[ { { -1, .35 }, { 0, -.5 }, { 1, .35 } } ] },
    ImageSize -> 11, AspectRatio -> 1, PlotRangePadding -> None ]

eyeGlyph = { Circle[ { 0, 0 }, { .7, .45 } ], Disk[ { 0, 0 }, .18 ] }

eyeOpenIcon   :=
  makeIcon[ eyeGlyph, "both", 1.2, 1 ]
eyeClosedIcon :=
  makeIcon[ { eyeGlyph, Line[ { { -.85, -.6 }, { .85, .6 } } ] }, "both", 1.2, 1,
    LightDarkSwitched[ GrayLevel[ .75 ], GrayLevel[ .22 ] ] ]

textChip[ content_ ] :=
  Framed[
    Style[ content, 13, Bold, FontFamily -> "Helvetica", LightDarkSwitched[ GrayLevel[ .15 ], White ] ],
    Background -> LightDarkSwitched[ GrayLevel[ .9 ], GrayLevel[ .3 ] ],
    FrameStyle -> StandardBlue, RoundingRadius -> 5,
    FrameMargins -> { { 10, 10 }, { 5, 5 } }, ContentPadding -> False ]

alertChip[ content_ ] :=
  Framed[
    Style[ content, 13, Bold, FontFamily -> "Helvetica", StandardRed ],
    Background -> LightDarkSwitched[ Lighter[ StandardRed, 0.9 ], GrayLevel[ .25 ] ],
    FrameStyle -> StandardRed, RoundingRadius -> 5,
    FrameMargins -> { { 10, 10 }, { 5, 5 } }, ContentPadding -> False ]

SetAttributes[ iconButton, HoldRest ]

iconButton[ icon_, action_ ] :=
  MouseAppearance[ EventHandler[ icon, { "MouseClicked" :> action }, PassEventsUp -> False ], "LinkHand" ]

geodesicGraph[ seq_List ] :=
  PathGraph[ seq, DirectedEdges -> True ]
geodesicGraph[ w_Graph ]  :=
  w

geodesicCycleGraph[ seq_List ] :=
  With[ { core = If[ Length[ seq ] >= 2 && First @ seq === Last @ seq, Most @ seq, seq ] },
    Graph[ core, DirectedEdge @@@ Partition[ core, 2, 1, 1 ] ] ]
geodesicCycleGraph[ w_Graph ] :=
  w
