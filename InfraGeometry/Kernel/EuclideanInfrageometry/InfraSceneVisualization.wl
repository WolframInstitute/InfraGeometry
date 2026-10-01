Package["WolframInstitute`InfraGeometry`"]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraSceneVisualization *)

PackageExport[$InfraPointColor]
PackageExport[$InfraSegmentColor]
PackageExport[$InfraLineColor]
PackageExport[$InfraShellColor]
PackageExport[$InfraBallColor]
PackageExport[$InfraPlaneColor]
PackageExport[$InfraCircleColor]
PackageExport[$InfraRayColor]
PackageExport[$InfraTopologyColor]
PackageExport[$InfraPalette]
PackageExport[$InfraStrikeOutPalette]
PackageExport[$InfraPointSizes]
PackageExport[$InfraAccentPointSize]
PackageScope[$infraColors]
PackageScope[$InfraOpacityRange]
PackageScope[$InfraEdgeThickness]
PackageScope[$InfraPointSize]
PackageScope[$InfraSceneImageSize]
PackageScope[infraInk]
PackageScope[parseHighlightStyle]
PackageScope[normalizeHighlightSpec]

$infraColors = <|
  "Point"    -> RGBColor[ 0.95, 0.08, 0.08 ],
  "Segment"  -> RGBColor[ 0.92, 0.45, 0.30 ],
  "Line"     -> RGBColor[ 0.78, 0.35, 0.22 ],
  "Shell"    -> RGBColor[ 0.30, 0.70, 0.50 ],
  "Ball"     -> RGBColor[ 0.55, 0.80, 0.65 ],
  "Plane"    -> RGBColor[ 0.55, 0.45, 0.80 ],
  "Circle"   -> RGBColor[ 0.20, 0.55, 0.65 ],
  "Ray"      -> RGBColor[ 0.95, 0.65, 0.45 ],
  "Path"     -> RGBColor[ 0.85, 0.62, 0.32 ],
  "Topology" -> RGBColor[ 0.85, 0.55, 0.75 ]
|>;

$InfraPointColor    = $infraColors[ "Point" ];
$InfraSegmentColor  = $infraColors[ "Segment" ];
$InfraLineColor     = $infraColors[ "Line" ];
$InfraShellColor    = $infraColors[ "Shell" ];
$InfraBallColor     = $infraColors[ "Ball" ];
$InfraPlaneColor    = $infraColors[ "Plane" ];
$InfraCircleColor   = $infraColors[ "Circle" ];
$InfraRayColor      = $infraColors[ "Ray" ];
$InfraWalkColor     = $infraColors[ "Path" ];
$InfraTopologyColor = $infraColors[ "Topology" ];

$InfraPalette := Dataset @ KeyValueMap[
  { name, color } |-> <|
    "Primitive" -> name,
    "Color" -> color,
    "Symbol" -> "$Infra" <> name <> "Color" |>,
  $infraColors ]

$InfraOpacityRange  = { 0.40, 1.0 };
$InfraEdgeThickness = 9.0;
$InfraPointSize     = 6;

$InfraPointSizes      = <| Small -> 4, Medium -> 7, Large -> 10 |>;
$InfraAccentPointSize = 12;

$InfraSceneImageSize = Medium;

$InfraStrikeOutPalette := ColorData[ 112, "ColorList" ];

resolveArrowSpec[ spec_ ] := Replace[ spec, {
  Automatic | None | False -> None,
  True :> Arrowheads[ Medium ],
  a_Arrowheads :> a,
  other_ :> Arrowheads[ other ] } ]

parseHighlightStyle[ spec_, defaults_Association ] :=
  Replace[
    Fold[
      { rec, elem } |-> Replace[ elem, {
        ( VertexStyle         -> v_ ) :> MapAt[ Append[ #, v ] &, rec, "VertexDir" ],
        ( VertexSize          -> v_ ) :> Append[ rec, "VertexSize" -> v ],
        ( VertexShapeFunction -> v_ ) :> Append[ rec, "VertexShapeFunction" -> v ],
        ( EdgeStyle           -> v_ ) :> Append[ rec, "EdgeStyle" -> v ],
        ( EdgeShapeFunction   -> v_ ) :> Append[ rec, "EdgeShapeFunction" -> v ],
        ( ( k : "OpacityRange" | "ThicknessRange" | "PointSizeRange" ) -> v_ ) :> Append[ rec, k -> v ],
        ( d : ( _Thickness | _AbsoluteThickness | Thick | Thin | _Dashing | Dashed | Dotted | DotDashed ) ) :>
          MapAt[ Append[ #, d ] &, rec, "EdgeDir" ],
        ( d : ( _PointSize | _AbsolutePointSize ) ) :>
          MapAt[ Append[ #, d ] &, rec, "VertexDir" ],
        ( a : ( _Arrowheads | True | False ) ) :> Append[ rec, "Arrowheads" -> resolveArrowSpec[ a ] ],
        c_?ColorQ :> Append[ rec, "Color" -> c ],
        d_ :> MapAt[ Append[ #, d ] &, MapAt[ Append[ #, d ] &, rec, "VertexDir" ], "EdgeDir" ]
      } ],
      Join[ defaults, <|
        "VertexDir" -> { }, "EdgeDir" -> { }, "EdgeStyle" -> None,
        "EdgeShapeFunction" -> None, "VertexSize" -> None, "VertexShapeFunction" -> None |> ],
      normalizeHighlightSpec @ spec ],
    r_Association :> With[ {
        edgeThick  = ! FreeQ[ { r[ "EdgeDir" ], r[ "EdgeStyle" ] },
          Thickness | AbsoluteThickness | Thick | Thin ],
        vertPtSize = ! FreeQ[ r[ "VertexDir" ], _PointSize | _AbsolutePointSize ] || r[ "VertexSize" ] =!= None,
        anyOpacity = ! FreeQ[ { r[ "VertexDir" ], r[ "EdgeDir" ], r[ "EdgeStyle" ] }, _Opacity ] },
      Join[ r, <|
        "VertexDir" -> Directive @@ r[ "VertexDir" ],
        "EdgeDir"   -> Directive @@ r[ "EdgeDir" ],
        If[ edgeThick,  "ThicknessRange" -> None, Nothing ],
        If[ vertPtSize, "PointSizeRange" -> None, Nothing ],
        If[ anyOpacity, "OpacityRange"   -> None, Nothing ] |> ] ] ]

normalizeHighlightSpec[ Automatic ]          := { }
normalizeHighlightSpec[ list_List ]          := list
normalizeHighlightSpec[ Directive[ d___ ] ]  := { d }
normalizeHighlightSpec[ x_ ]                 := { x }

Options[ InfraSubstrateHighlight ] = Join[
  {
    "OpacityRange"   :> $InfraOpacityRange,
    "ThicknessRange" :> $InfraEdgeThickness,
    "PointSizeRange" -> Automatic,
    "Arrowheads"     -> Automatic,
    "Palette"        -> Automatic,
    ImageSize        :> $InfraSceneImageSize
  },
  Options[ HighlightGraph ]
];

InfraSubstrateHighlight[ graph_Graph, obj : Except[_List], opts : OptionsPattern[] ] :=
  InfraSubstrateHighlight[ graph, { obj }, opts ]

InfraSubstrateHighlight[ graph_Graph, items_List, opts : OptionsPattern[] ] :=
  With[ {
      ranges = <|
        "OpacityRange"   -> OptionValue[ "OpacityRange" ],
        "ThicknessRange" -> OptionValue[ "ThicknessRange" ],
        "PointSizeRange" -> OptionValue[ "PointSizeRange" ],
        "Arrowheads"     -> resolveArrowSpec @ OptionValue[ "Arrowheads" ] |>,
      palette = Replace[ OptionValue[ "Palette" ], {
        Automatic :> $InfraStrikeOutPalette,
        c : Except[ _List ] :> { c } } ],
      objects = DeleteCases[
        Last @ Fold[
          { state, item } |-> Replace[ item, {
            d_Directive          :> { List @@ d, Last @ state },
            Style[ obj_, dirs__ ] :> { First @ state, Append[ Last @ state, obj -> Join[ First @ state, { dirs } ] ] },
            ( obj_ -> spec_ )    :> { First @ state, Append[ Last @ state, obj -> Join[ First @ state, normalizeHighlightSpec @ spec ] ] },
            obj_                 :> { First @ state, Append[ Last @ state, obj -> First @ state ] } } ],
          { { }, { } },
          items ],
        { } -> _ ] },
    { objectEntries = MapIndexed[
        { item, idx } |-> With[ {
            ink    = infraInk[ graph, First @ item ],
            record = parseHighlightStyle[ Last @ item, ranges ] },
          { mass = Max[ Values @ ink[ "VertexDensity" ], Values @ ink[ "EdgeDensity" ] ] },
          <| "Verts"  -> ink[ "VertexDensity" ] / mass,
             "Edges"  -> ink[ "EdgeDensity" ] / mass,
             "Walk"   -> ink[ "Walk" ],
             "Knots"  -> ink[ "Knots" ],
             "Color"  -> Lookup[ record, "Color", palette[[ 1 + Mod[ First @ idx - 1, Length @ palette ] ]] ],
             "Record" -> Append[ record, "PointSizeRange" -> Replace[ record[ "PointSizeRange" ],
               Automatic :> If[ ink[ "EdgeDensity" ] === <| |>, $InfraPointSize, None ] ] ] |> ],
        objects ] },
    { entries = Join[ objectEntries,
        Cases[ objectEntries, e_Association /; e[ "Knots" ] =!= { } :>
          With[ { record = parseHighlightStyle[ Automatic, ranges ], knots = KeySort @ Counts @ e[ "Knots" ] },
            <| "Verts" -> knots / Max @ knots, "Edges" -> <| |>, "Walk" -> None, "Knots" -> { },
               "Color" -> $InfraPointColor,
               "Record" -> Append[ record,
                 "PointSizeRange" -> Replace[ record[ "PointSizeRange" ], Automatic :> $InfraPointSize ] ] |> ] ] ] },
    { vMasses = Merge[ ( e |-> ( { e[ "Color" ], #, e[ "Record" ] } & /@ e[ "Verts" ] ) ) /@ entries, Identity ],
      eMasses = Merge[ ( e |-> ( { e[ "Color" ], #, e[ "Record" ] } & /@ e[ "Edges" ] ) ) /@ entries, Identity ] },
    { lerp  = { spec, w } |-> If[ ListQ @ spec, spec[[ 1 ]] + ( spec[[ 2 ]] - spec[[ 1 ]] ) w, spec w ],
      blend = cs |-> {
        Replace[ DeleteDuplicates @ cs[[ All, 1 ]], { { c_ } :> c, _ :> Blend[ cs[[ All, 1 ]], cs[[ All, 2 ]] ] } ],
        Min[ 1, Total @ cs[[ All, 2 ]] ],
        cs[[ -1, 3 ]] } },
      {
          edgeData = KeyValueMap[
            { ue, cs } |-> With[ { el = blend @ cs },
              { color = el[[ 1 ]], w = el[[ 2 ]], rec = el[[ 3 ]] },
              { oList = If[ rec[ "OpacityRange" ] === None, { },
                  { Opacity[ lerp[ rec[ "OpacityRange" ], w ] ] } ],
                tList = If[ rec[ "ThicknessRange" ] === None, { },
                  { AbsoluteThickness[ lerp[ rec[ "ThicknessRange" ], w ] ] } ],
                eDirs = List @@ rec[ "EdgeDir" ] },
              <|
                "EdgeStyle" -> ( ue -> Directive[ color, Sequence @@ oList, Sequence @@ tList, Sequence @@ eDirs,
                    Sequence @@ If[ rec[ "EdgeStyle" ] === None, { }, { rec[ "EdgeStyle" ] } ] ] ),
                "EdgeShapeFunction" -> If[ rec[ "EdgeShapeFunction" ] === None, Nothing,
                  ue -> rec[ "EdgeShapeFunction" ] ]
              |> ],
            eMasses ],
          vertexData = KeyValueMap[
            { v, cs } |-> With[ { el = blend @ cs },
              { color = el[[ 1 ]], w = el[[ 2 ]], rec = el[[ 3 ]] },
              { oList = If[ rec[ "OpacityRange" ] === None, { },
                  { Opacity[ lerp[ rec[ "OpacityRange" ], w ] ] } ],
                vDirs = List @@ rec[ "VertexDir" ] },
              Which[
                rec[ "VertexShapeFunction" ] =!= None,
                  <| "VSF" -> ( v -> rec[ "VertexShapeFunction" ] ) |>,
                rec[ "PointSizeRange" ] =!= None || ! FreeQ[ vDirs, _AbsolutePointSize | _PointSize ],
                  With[ { body = Flatten[ { color, oList,
                      If[ rec[ "PointSizeRange" ] === None, { },
                        { AbsolutePointSize[ lerp[ rec[ "PointSizeRange" ], w ] ] } ], vDirs } ] },
                    <| "VSF" -> ( v -> ( Append[ body, Point[ #1 ] ] & ) ) |> ],
                True,
                  <| "Style" -> Style[ v, Directive[ color, Sequence @@ oList, Sequence @@ vDirs ] ],
                     "VSize" -> If[ rec[ "VertexSize" ] === None, Nothing, v -> rec[ "VertexSize" ] ] |>
              ] ],
            vMasses ] },
        {
          coords    = AssociationThread[ VertexList @ graph -> GraphEmbedding @ graph ],
          edgeStyle = Association @ Cases[ edgeData, kv_Association :> kv[ "EdgeStyle" ] ]
        },
        {
          strokes = Catenate @ Cases[ entries,
            e_Association /; e[ "Record" ][ "EdgeShapeFunction" ] === None && ListQ[ e[ "Walk" ] ] && Length[ e[ "Walk" ] ] >= 2 :>
              With[ {
                  runs = Select[ SplitBy[ Partition[ e[ "Walk" ], 2, 1 ], edgeStyle[ UndirectedEdge @@ Sort @ # ] & ],
                    Length[ # ] >= 2 & ] },
                MapIndexed[
                  { steps, position } |-> { UndirectedEdge @@ Sort @ # & /@ steps,
                              coords /@ Prepend[ Last /@ steps, First @ First @ steps ],
                              First[ position ] === Length[ runs ],
                              e[ "Record" ][ "Arrowheads" ] },
                  runs ] ] ]
        },
        {
          joinRules = Last @ Fold[
            { state, stroke } |-> Replace[ DeleteDuplicates @ Select[ First @ stroke, ! KeyExistsQ[ First @ state, # ] & ], {
                { } -> state,
                fresh_ :> {
                  Join[ First @ state, AssociationThread[ fresh -> True ] ],
                  Join[ Last @ state,
                    { First @ fresh -> ( { JoinForm[ "Round" ],
                        If[ stroke[[ 4 ]] =!= None && stroke[[ 3 ]],
                          Sequence @@ { stroke[[ 4 ]], Arrow @ stroke[[ 2 ]] },
                          Line @ stroke[[ 2 ]] ] } & ) },
                    ( # -> ( { } & ) ) & /@ Rest @ fresh ] } } ],
            { <| |>, { } },
            strokes ]
        },

        HighlightGraph[ graph,
          Cases[ vertexData, kv_Association /; KeyExistsQ[ kv, "Style" ] :> kv[ "Style" ] ],
          Sequence @@ DeleteCases[ {
            EdgeStyle           -> DeleteCases[ Cases[ edgeData,   kv_Association :> kv[ "EdgeStyle" ] ], Nothing ],
            EdgeShapeFunction   -> Join[ DeleteCases[ Cases[ edgeData, kv_Association :> kv[ "EdgeShapeFunction" ] ], Nothing ], joinRules ],
            VertexShapeFunction -> Cases[ vertexData, kv_Association /; KeyExistsQ[ kv, "VSF" ] :> kv[ "VSF" ] ],
            VertexSize          -> DeleteCases[ Cases[ vertexData, kv_Association /; KeyExistsQ[ kv, "VSize" ] :> kv[ "VSize" ] ], Nothing ]
          }, _ -> { } ],
          FilterRules[ { opts }, Options @ HighlightGraph ],
          ImageSize -> OptionValue[ ImageSize ] ]
    ]

infraInk[ graph_Graph, x_ ] := Which[
  VertexQ[ graph, x ] || AssociationQ[ x ],
    <| "VertexDensity" -> InfraDensity[ graph, x ], "EdgeDensity" -> <| |>, "Walk" -> None, "Knots" -> { } |>,
  MatchQ[ x, InfraWalk[ _List ] ] && ! VertexQ[ graph, First @ x ],
    With[ { walk = First @ x },
      <| "VertexDensity" -> InfraDensity[ graph, If[ Length @ walk > 1 && First @ walk === Last @ walk, Most @ walk, walk ] ],
         "EdgeDensity"   -> KeySort @ Counts[ UndirectedEdge @@ Sort @ # & /@ Partition[ walk, 2, 1 ] ],
         "Walk"          -> walk,
         "Knots"         -> { } |> ],
  MatchQ[ x, ( InfraIntersection | InfraUnion )[ __ ] ],
    <| "VertexDensity" -> InfraMeasurement[ graph, x, "VertexDensity" ], "EdgeDensity" -> <| |>, "Walk" -> None, "Knots" -> { } |>,
  MatchQ[ x, ( InfraSegment | InfraRay | InfraLine | InfraCircle | InfraArc )[ __ ] ],
    With[ {
        edges  = KeySort @ GroupBy[ Normal @ InfraMeasurement[ graph, x, "EdgeDensity" ],
          ( UndirectedEdge @@ Sort[ List @@ First @ # ] & ) -> Last, Total ],
        member = If[ InfraMeasurement[ graph, x, "Cardinality" ] == 1, InfraVertexList[ graph, x ], None ] },
      <| "VertexDensity" -> InfraMeasurement[ graph, x, "VertexDensity" ],
         "EdgeDensity"   -> edges,
         "Walk"          -> If[ ListQ @ member && Length @ member > 2 &&
             KeyExistsQ[ edges, UndirectedEdge @@ Sort @ { Last @ member, First @ member } ],
           Append[ member, First @ member ], member ],
         "Knots"         -> { } |> ],
  GraphQ[ x ],
    With[ { walk = Which[
        closedWalkQ @ x,                     closeWalk @ walkSequence @ x,
        positionSpelledQ @ x || PathGraphQ @ x, walkSequence @ x,
        True,                                None ] },
      <| "VertexDensity" -> InfraDensity[ graph, x ],
         "EdgeDensity"   -> If[ walk === None,
           KeySort @ GroupBy[ Normal @ GeodesicEdgeOccupation @ x, ( UndirectedEdge @@ Sort[ List @@ First @ # ] & ) -> Last, Total ],
           KeySort @ Counts[ UndirectedEdge @@ Sort @ # & /@ Partition[ walk, 2, 1 ] ] ],
         "Walk"          -> walk,
         "Knots"         -> { } |> ],
  MatchQ[ x, { _Graph, __Graph } ] && NoneTrue[ x, closedWalkQ ] &&
    AllTrue[ Partition[ walkSequence /@ x, 2, 1 ], Last @ First @ # === First @ Last @ # & ],
    With[ { knots = Prepend[ Last @ walkSequence @ # & /@ x, First @ walkSequence @ First @ x ] },
      Append[ infraInk[ graph, InfraWalk @ polylineToVertexSeq @ x ],
        "Knots" -> If[ First @ knots === Last @ knots, Most @ knots, knots ] ] ],
  ListQ[ x ] && AllTrue[ x, VertexQ[ graph, # ] & ],
    <| "VertexDensity" -> InfraDensity[ graph, x ],
       "EdgeDensity"   -> KeySort @ Counts[ UndirectedEdge @@ Sort[ List @@ # ] & /@ EdgeList @ Subgraph[ graph, x ] ],
       "Walk"          -> None,
       "Knots"         -> { } |>,
  MatchQ[ x, { __ } ],
    With[ { members = infraInk[ graph, # ] & /@ x },
      <| "VertexDensity" -> KeySort @ GroupBy[ Catenate[ Normal @ #[ "VertexDensity" ] & /@ members ], First -> Last, Total ],
         "EdgeDensity"   -> KeySort @ GroupBy[ Catenate[ Normal @ #[ "EdgeDensity" ] & /@ members ], First -> Last, Total ],
         "Walk"          -> If[ Length @ members == 1, First[ members ][ "Walk" ], None ],
         "Knots"         -> Catenate[ #[ "Knots" ] & /@ members ] |> ] ]
