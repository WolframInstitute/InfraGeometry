Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraSceneViewer *)

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
          "PairwiseDistance" -> Switch[ separation, "None", None, "Max", "Max", "Range", distRange ], RandomSeeding -> None ] },
        If[ sym =!= None, sym = pts ];
        InfraSubstrateHighlight[ g, { InfraMeasurement[ g, pts, "VertexDensity" ] } ] ],
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
              applySelectOption[ g, RandomInfraSegment[ g, p1, p2, All, RandomSeeding -> None ],
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
              Properties -> properties, RandomSeeding -> None ] ] },
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
              applySelectOption[ g, RandomInfraCircle[ g, InfraCircle[ p, r ], All, RandomSeeding -> None ],
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

InfraSceneViewer[ scene_InfraScene, graph_Graph, init : _Association : <| |>, opts : OptionsPattern[ ] ] :=
  With[ {
      nSteps   = Length @ scene[ "Steps" ],
      steps    = scene[ "Steps" ],
      labels   = scene[ "Labels" ],
      objects  = scene[ "Objects" ],
      imgW     = OptionValue[ InfraSceneViewer, { opts }, ImageSize ],
      hlOpts   = FilterRules[ Join[ { opts }, Options[ InfraSceneViewer ] ], Options[ InfraSubstrateHighlight ] ],
      lineCol  = LightDarkSwitched[ GrayLevel[ .8 ], GrayLevel[ .35 ] ],
      mutedCol = LightDarkSwitched[ GrayLevel[ .55 ], GrayLevel[ .6 ] ],
      objStep  = Association @@ Flatten[ MapIndexed[
        { syms, i } |-> ( ( # -> First[ i ] ) & /@ Flatten[ { syms } ] ), scene[ "Steps" ] ] ] },
    { stepText = k |-> Row[ { "step ", k, "/", nSteps,
        If[ labels[[ k ]] === None, "", Row[ { ": ", labels[[ k ]] } ] ] } ] },
    DynamicModule[ {
        step = 1, branch = 1, mode = "Branch", menuQ = False,
        fixStack = { }, hiddenSteps = { },
        shown = { }, shownStep = 1, deadQ = False },
      With[ {
          effInit = ( Join[ init, Sequence @@ fixStack[[ All, 2 ]] ] ) &,
          shownQ  = obj |-> ! MemberQ[ hiddenSteps, objStep[ obj ] ] },
        {
          refresh = (
            With[ { new = RandomInfraSceneInstance[ scene, graph, All, effInit[ ], "Steps" -> step ] },
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
            refresh[ ] ),
          toggleHidden = k |-> (
            hiddenSteps = If[ MemberQ[ hiddenSteps, k ], DeleteCases[ hiddenSteps, k ], Append[ hiddenSteps, k ] ] ),
          togglePin = k |-> (
            If[ MemberQ[ fixStack[[ All, 1 ]], k ],
              fixStack = Select[ fixStack, First[ # ] < k & ],
              If[ k <= shownStep && shown =!= { },
                fixStack = SortBy[ Append[ fixStack, { k, KeySelect[ shown[[ Min[ branch, Length @ shown ], 1 ]],
                  key |-> objStep[ key ] <= k ] } ], First ] ] ];
            refresh[ ] ) },
        refresh[ ];
        Framed[
          Column[ {
            Pane[ Dynamic @ Grid[ { {
                Grid[ { {
                  pill[ {
                    iconButton[ chevron[ 1, step > 1 ], goStep[ step - 1 ] ],
                    stepText[ step ],
                    iconButton[ chevron[ -1, step < nSteps ], goStep[ step + 1 ] ] }, True ],
                  iconButton[ eyeIcon[ MemberQ[ hiddenSteps, step ] ], toggleHidden[ step ] ] } },
                  Spacings -> { .6, 0 }, Alignment -> { Left, Center } ],
                iconButton[ barIcon[ menuGlyph, menuQ ], menuQ = ! menuQ ] } },
              Alignment -> { { Left, Right }, Center }, ItemSize -> { { Scaled[ .78 ], Scaled[ .22 ] }, Automatic } ],
              ImageSize -> imgW, FrameMargins -> { { 8, 8 }, { 5, 5 } } ],
            Overlay[ {
              Dynamic @ If[ shown === { },
                InfraSubstrateHighlight[ graph, { }, Sequence @@ hlOpts, ImageSize -> imgW ],
                InfraSubstrateHighlight[ graph,
                  If[ mode === "Diffuse",
                    With[ { boundKeys = Keys @ First[ shown ][[ 1 ]] },
                      ( obj |-> With[ { reps = DeleteDuplicates[ #[[ 1 ]][ obj ] & /@ shown ] },
                          If[ AllTrue[ reps, pointQ[ graph, # ] & ], KeySort @ Counts @ reps, reps ] ] ) /@
                      Select[ objects, MemberQ[ boundKeys, # ] && shownQ[ # ] & ] ],
                    Values @ KeySelect[ shown[[ Min[ branch, Length @ shown ], 1 ]], shownQ ] ],
                  Sequence @@ hlOpts, ImageSize -> imgW ] ],
              Dynamic @ If[ ! menuQ, "",
                Pane[ Framed[
                  Style[ Grid[ Table[ With[ { k = k }, {
                      Item[ iconButton[ Row[ { Style[ StringRiffle[ ToString /@ Flatten[ { steps[[ k ]] } ], ", " ], Bold ], "  ",
                          Style[ Replace[ labels[[ k ]], None -> "" ], mutedCol ] } ], goStep[ k ] ],
                        Background -> If[ k === step, LightDarkSwitched[ GrayLevel[ .93 ], GrayLevel[ .3 ] ], None ] ],
                      iconButton[ eyeIcon[ MemberQ[ hiddenSteps, k ] ], toggleHidden[ k ] ],
                      iconButton[ barIcon[ pinGlyph, MemberQ[ fixStack[[ All, 1 ]], k ], k <= shownStep ], togglePin[ k ] ] } ],
                    { k, nSteps } ],
                    Alignment -> { { Left, Center, Center }, Center }, Spacings -> { { 0, 1.5, .4 }, .5 } ],
                    12, FontFamily -> "Helvetica", LightDarkSwitched[ GrayLevel[ .15 ], White ] ],
                  Background -> LightDarkSwitched[ White, GrayLevel[ .2 ] ], FrameStyle -> lineCol,
                  RoundingRadius -> 6, FrameMargins -> 6 ],
                  ImageMargins -> { { 0, 8 }, { 0, 6 } } ] ] },
              All, 2, Alignment -> { Right, Top } ],
            Pane[ Dynamic @ Grid[ { {
                If[ deadQ,
                  alertChip[ Row[ { "does not exist \[LongDash] showing step ", shownStep } ] ],
                  With[ { n = Length @ shown, enabledQ = mode === "Branch" && Length @ shown > 1 },
                    pill[ {
                      If[ enabledQ, iconButton[ chevron[ 1, True ], branch = Max[ branch - 1, 1 ] ], chevron[ 1, False ] ],
                      If[ mode === "Diffuse", "all", Row[ { "branch ", Min[ branch, Max[ n, 1 ] ], "/", n } ] ],
                      If[ enabledQ, iconButton[ chevron[ -1, True ], branch = Min[ branch + 1, Max[ n, 1 ] ] ], chevron[ -1, False ] ] },
                      enabledQ ] ] ],
                Grid[ { {
                  iconButton[ barIcon[ pinGlyph, MemberQ[ fixStack[[ All, 1 ]], step ], step <= shownStep ], togglePin[ step ] ],
                  iconButton[ barIcon[ stackGlyph, mode === "Diffuse" ], mode = If[ mode === "Diffuse", "Branch", "Diffuse" ] ] } },
                  Spacings -> { .4, 0 } ] } },
              Alignment -> { { Left, Right }, Center }, ItemSize -> { { Scaled[ .78 ], Scaled[ .22 ] }, Automatic } ],
              ImageSize -> imgW, FrameMargins -> { { 8, 8 }, { 5, 5 } } ]
          }, Spacings -> 0, Dividers -> { None, { 2 -> lineCol, 3 -> lineCol } } ],
          FrameStyle -> lineCol, Background -> LightDarkSwitched[ White, GrayLevel[ .12 ] ],
          RoundingRadius -> 4, FrameMargins -> 0 ]
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

barIcon[ glyph_, activeQ_ : False, enabledQ_ : True ] :=
  makeIcon[ If[ enabledQ, glyph, { LightDarkSwitched[ GrayLevel[ .72 ], GrayLevel[ .45 ] ], glyph } ], "both", 1.3, 1.1,
    If[ activeQ,
      LightDarkSwitched[ Lighter[ StandardBlue, .8 ], Darker[ StandardBlue, .45 ] ],
      LightDarkSwitched[ GrayLevel[ .93 ], GrayLevel[ .3 ] ] ] ]

eyeGlyph = { Circle[ { 0, 0 }, { .7, .45 } ], Disk[ { 0, 0 }, .18 ] }

eyeIcon[ hiddenQ_ ] :=
  barIcon[ If[ hiddenQ, { eyeGlyph, Line[ { { -.8, -.55 }, { .8, .55 } } ] }, eyeGlyph ] ]

menuGlyph = Line /@ { { { -.55, .4 }, { .55, .4 } }, { { -.55, 0 }, { .55, 0 } }, { { -.55, -.4 }, { .55, -.4 } } }

pinGlyph = { Line[ { { 0, -.05 }, { 0, -.75 } } ],
  Polygon[ { { -.22, .7 }, { .22, .7 }, { .16, .3 }, { .4, -.05 }, { -.4, -.05 }, { -.16, .3 } } ] }

stackGlyph = { Line[ { { -.65, .14 }, { 0, .48 }, { .65, .14 }, { 0, -.2 }, { -.65, .14 } } ],
  Line[ { { -.65, -.2 }, { 0, -.54 }, { .65, -.2 } } ] }

chevron[ dir_, enabledQ_ ] :=
  Graphics[ { If[ enabledQ, StandardBlue, LightDarkSwitched[ GrayLevel[ .72 ], GrayLevel[ .45 ] ] ],
      AbsoluteThickness[ 1.6 ], CapForm[ "Round" ], JoinForm[ "Round" ],
      Line[ { { dir .3, .9 }, { -dir .3, 0 }, { dir .3, -.9 } } ] },
    ImageSize -> { 12, 15 }, AspectRatio -> Full, PlotRange -> { { -.8, .8 }, { -1.1, 1.1 } } ]

pill[ content_List, enabledQ_ ] :=
  Framed[
    Style[ Grid[ { content }, Spacings -> { .5, 0 }, Alignment -> { Center, Center } ], 12, FontFamily -> "Helvetica", LineBreakWithin -> False,
      If[ enabledQ, LightDarkSwitched[ GrayLevel[ .15 ], White ], LightDarkSwitched[ GrayLevel[ .6 ], GrayLevel[ .5 ] ] ] ],
    Background -> LightDarkSwitched[ GrayLevel[ .96 ], GrayLevel[ .22 ] ],
    FrameStyle -> LightDarkSwitched[ GrayLevel[ If[ enabledQ, .75, .86 ] ], GrayLevel[ .4 ] ],
    RoundingRadius -> 11, FrameMargins -> { { 6, 6 }, { 2, 2 } }, ContentPadding -> False ]

alertChip[ content_ ] :=
  Framed[
    Style[ content, 12, FontFamily -> "Helvetica", StandardRed ],
    Background -> LightDarkSwitched[ Lighter[ StandardRed, 0.9 ], GrayLevel[ .25 ] ],
    FrameStyle -> StandardRed, RoundingRadius -> 11,
    FrameMargins -> { { 10, 10 }, { 3, 3 } }, ContentPadding -> False ]

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
