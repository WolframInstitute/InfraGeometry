Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraSceneVisualization *)

PackageScope[ $InfraStrikeOutPalette ]
PackageScope[ $InfraPointSizes ]
PackageScope[ $InfraAccentPointSize ]
PackageScope[ $InfraOpacityRange ]
PackageScope[ $InfraEdgeThickness ]
PackageScope[ $InfraRangeTop ]
PackageScope[ infraInk ]
PackageScope[ parseHighlightStyle ]
PackageScope[ normalizeHighlightSpec ]

$InfraOpacityRange  = { 0.40, 1.0 }
$InfraEdgeThickness = 1.
$InfraRangeTop      = <| "ThicknessRange" -> 4, "PointSizeRange" -> 3 |>

$InfraPointSizes      = <| Small -> 4, Medium -> 7, Large -> 10 |>
$InfraAccentPointSize = 12

$InfraStrikeOutPalette :=
  ColorData[ 112, "ColorList" ]

resolveArrowSpec[ spec_ ] :=
  Replace[ spec, {
    Automatic | None | False -> None,
    True -> True,
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
        absThick = Cases[ r[ "EdgeDir" ], AbsoluteThickness[ t_ ] :> t ],
        absPoint = Cases[ r[ "VertexDir" ], AbsolutePointSize[ s_ ] :> s ],
        edgeDir  = DeleteCases[ r[ "EdgeDir" ], _AbsoluteThickness ],
        vertDir  = DeleteCases[ r[ "VertexDir" ], _AbsolutePointSize ] },
      { edgeThick  = ! FreeQ[ { edgeDir, r[ "EdgeStyle" ] }, Thickness | AbsoluteThickness | Thick | Thin ],
        vertPtSize = ! FreeQ[ vertDir, _PointSize | _AbsolutePointSize ] || r[ "VertexSize" ] =!= None,
        anyOpacity = ! FreeQ[ { r[ "VertexDir" ], r[ "EdgeDir" ], r[ "EdgeStyle" ] }, _Opacity ] },
      Join[ r, <|
        "VertexDir"      -> Directive @@ vertDir,
        "EdgeDir"        -> Directive @@ edgeDir,
        "ThicknessRange" -> Which[ edgeThick, None, absThick =!= { }, Last @ absThick, True, r[ "ThicknessRange" ] ],
        "PointSizeRange" -> Which[ vertPtSize, None, absPoint =!= { }, Last @ absPoint, True, r[ "PointSizeRange" ] ],
        If[ anyOpacity, "OpacityRange" -> None, Nothing ] |> ] ] ]

normalizeHighlightSpec[ Automatic ]          :=
  { }
normalizeHighlightSpec[ list_List ]          :=
  list
normalizeHighlightSpec[ Directive[ d___ ] ]  :=
  { d }
normalizeHighlightSpec[ x_ ]                 :=
  { x }

Options[ InfraSubstrateHighlight ] = Join[
  {
    "OpacityRange"   :> $InfraOpacityRange,
    "ThicknessRange" -> Automatic,
    "PointSizeRange" -> Automatic,
    "Arrowheads"     -> Automatic,
    "Palette"        -> Automatic
  },
  Options[ HighlightGraph ]
]

InfraSubstrateHighlight[ graph_Graph, obj : Except[ _List ], opts : OptionsPattern[] ] :=
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
        { } -> _ ],
      substrateThickness = First[ Cases[ Options[ graph, EdgeStyle ], AbsoluteThickness[ t_ ] :> t, Infinity ], $InfraEdgeThickness ],
      stored = AssociationThread[ ( UndirectedEdge @@ Sort[ List @@ # ] & /@ EdgeList @ graph ) -> EdgeList @ graph ],
      spread = masses |-> With[ { lo = Min @ Abs @ Values @ masses, hi = Max @ Abs @ Values @ masses },
        ( m |-> { m / hi, If[ hi == lo, 0, ( Abs[ m ] - lo ) / ( hi - lo ) ] } ) /@ masses ] },
    { span = { spec, base, key } |-> Replace[
        Replace[ spec, {
          Automatic -> { base, Automatic },
          { b_, t_ } :> { Replace[ b, Automatic -> base ], t },
          b : Except[ None ] :> { b, Automatic } } ],
        { b_?NumericQ, Automatic } :> { b, $InfraRangeTop[ key ] b } ],
      (* HighlightGraph matches an EdgeShapeFunction rule only in the orientation the graph stores the edge *)
      spell = ue |-> Lookup[ stored, Key @ ue, ue ] },
    { objectEntries = MapIndexed[
        { item, idx } |-> With[ {
            ink    = infraInk[ graph, First @ item ],
            record = parseHighlightStyle[ Last @ item, ranges ] },
          { verts = Select[ ink[ "VertexDensity" ], # != 0 & ] },
          <| "Verts"  -> spread @ verts,
             "Edges"  -> spread @ ink[ "EdgeDensity" ],
             "Faint"  -> If[ ink[ "EdgeDensity" ] === <| |>,
               UndirectedEdge @@ Sort[ List @@ # ] & /@ EdgeList @ Subgraph[ graph, Keys @ verts ], { } ],
             "Walk"   -> ink[ "Walk" ],
             "Knots"  -> ink[ "Knots" ],
             "Color"  -> Lookup[ record, "Color", palette[[ 1 + Mod[ First @ idx - 1, Length @ palette ] ]] ],
             "Record" -> Join[ record, <|
               "ThicknessRange" -> span[ record[ "ThicknessRange" ], substrateThickness, "ThicknessRange" ],
               "PointSizeRange" -> If[ ink[ "EdgeDensity" ] =!= <| |> && FreeQ[ Last @ item, "PointSizeRange" | _AbsolutePointSize ], None,
                 span[ record[ "PointSizeRange" ], Automatic, "PointSizeRange" ] ],
               If[ ListQ @ ink[ "Walk" ] && record[ "OpacityRange" ] =!= None && FreeQ[ Last @ item, "OpacityRange" ],
                 "OpacityRange" -> { 1, 1 }, Nothing ] |> ] |> ],
        objects ] },
    { entries = Join[ objectEntries,
        MapIndexed[
          { e, k } |-> With[ { record = parseHighlightStyle[ Automatic, ranges ] },
            <| "Verts" -> spread @ KeySort @ Counts @ e[ "Knots" ], "Edges" -> <| |>, "Faint" -> { }, "Walk" -> None, "Knots" -> { },
               "Color" -> palette[[ 1 + Mod[ Length @ objectEntries + First @ k - 1, Length @ palette ] ]],
               "Record" -> Join[ record, <|
                 "ThicknessRange" -> span[ record[ "ThicknessRange" ], substrateThickness, "ThicknessRange" ],
                 "PointSizeRange" -> span[ record[ "PointSizeRange" ], Automatic, "PointSizeRange" ] |> ] |> ],
          Select[ objectEntries, #[ "Knots" ] =!= { } & ] ] ] },
    { vMasses = Merge[ ( e |-> ( { e[ "Color" ], #[[ 1 ]], If[ e[ "Record" ][ "PointSizeRange" ] === None, 0, #[[ 2 ]] ], e[ "Record" ] } & /@
        e[ "Verts" ] ) ) /@ entries, Identity ],
      eMasses = Merge[ ( e |-> ( { e[ "Color" ], #[[ 1 ]], #[[ 2 ]], e[ "Record" ] } & /@ e[ "Edges" ] ) ) /@ entries, Identity ],
      fMasses = Merge[ ( e |-> AssociationMap[ { e[ "Color" ], e[ "Record" ] } &, e[ "Faint" ] ] ) /@ entries, Identity ] },
    { lerp  = { spec, w } |-> If[ ListQ @ spec, spec[[ 1 ]] + ( spec[[ 2 ]] - spec[[ 1 ]] ) w, spec w ],
      grow  = { range, r } |-> First @ range + ( Last @ range - First @ range ) r,
      blend = cs |-> {
        Replace[ DeleteDuplicates @ cs[[ All, 1 ]], { { c_ } :> c, _ :> Blend[ cs[[ All, 1 ]], cs[[ All, 2 ]] ] } ],
        Min[ 1, Total @ cs[[ All, 2 ]] ],
        Min[ 1, Total @ cs[[ All, 3 ]] ],
        cs[[ -1, 4 ]] } },
      {
          edgeData = Join[
            KeyValueMap[
              { ue, cs } |-> With[ { el = blend @ cs },
                { color = el[[ 1 ]], w = el[[ 2 ]], r = el[[ 3 ]], rec = el[[ 4 ]] },
                { oList = If[ rec[ "OpacityRange" ] === None, { },
                    { Opacity[ lerp[ rec[ "OpacityRange" ], w ] ] } ],
                  tList = If[ rec[ "ThicknessRange" ] === None, { },
                    { AbsoluteThickness[ grow[ rec[ "ThicknessRange" ], r ] ] } ],
                  eDirs = List @@ rec[ "EdgeDir" ] },
                <|
                  "EdgeStyle" -> ( ue -> Directive[ color, Sequence @@ oList, Sequence @@ tList, Sequence @@ eDirs,
                      Sequence @@ If[ rec[ "EdgeStyle" ] === None, { }, { rec[ "EdgeStyle" ] } ] ] ),
                  "EdgeShapeFunction" -> If[ rec[ "EdgeShapeFunction" ] === None, Nothing,
                    ue -> rec[ "EdgeShapeFunction" ] ]
                |> ],
              eMasses ],
            KeyValueMap[
              { ue, cs } |-> With[ { rec = cs[[ -1, 2 ]] },
                <|
                  "EdgeStyle" -> ( ue -> Directive[
                      Replace[ DeleteDuplicates @ cs[[ All, 1 ]], { { c_ } :> c, colors_ :> Blend @ colors } ],
                      Sequence @@ If[ rec[ "OpacityRange" ] === None, { }, { Opacity[ First @ Flatten @ { rec[ "OpacityRange" ] } ] } ],
                      Sequence @@ If[ rec[ "ThicknessRange" ] === None, { }, { AbsoluteThickness[ First @ rec[ "ThicknessRange" ] ] } ],
                      Sequence @@ List @@ rec[ "EdgeDir" ],
                      Sequence @@ If[ rec[ "EdgeStyle" ] === None, { }, { rec[ "EdgeStyle" ] } ] ] ),
                  "EdgeShapeFunction" -> If[ rec[ "EdgeShapeFunction" ] === None, Nothing,
                    ue -> rec[ "EdgeShapeFunction" ] ]
                |> ],
              KeyDrop[ fMasses, Keys @ eMasses ] ] ],
          vertexData = KeyValueMap[
            { v, cs } |-> With[ {
                shapes = KeyValueMap[
                  { sign, part } |-> With[ { el = blend @ part },
                    { color = el[[ 1 ]], w = el[[ 2 ]], r = el[[ 3 ]], rec = el[[ 4 ]] },
                    { oList = If[ rec[ "OpacityRange" ] === None, { },
                        { Opacity[ lerp[ rec[ "OpacityRange" ], w ] ] } ],
                      vDirs = List @@ rec[ "VertexDir" ],
                      dot   = rec[ "PointSizeRange" ] },
                    { ring = Flatten @ { color, oList,
                        AbsoluteThickness[ First @ Replace[ rec[ "ThicknessRange" ], None -> { substrateThickness } ] ], vDirs } },
                    Which[
                      rec[ "VertexShapeFunction" ] =!= None,
                        <| "VSF" -> ( v -> rec[ "VertexShapeFunction" ] ) |>,
                      ListQ @ dot && First @ dot === Automatic,
                        With[ {
                            body  = Flatten @ { color, oList, vDirs },
                            scale = 1 + ( Replace[ Last @ dot, Automatic -> $InfraRangeTop[ "PointSizeRange" ] ] - 1 ) r },
                          <| "VSF" -> ( v -> If[ sign > 0, Append[ body, Disk[ #1, scale #3 ] ] &, Append[ ring, Circle[ #1, scale #3 ] ] & ] ) |> ],
                      dot =!= None || ! FreeQ[ vDirs, _AbsolutePointSize | _PointSize ],
                        With[ {
                            body   = Flatten[ { color, oList, If[ dot === None, { }, { AbsolutePointSize[ grow[ dot, r ] ] } ], vDirs } ],
                            radius = If[ dot === None, None, Offset[ { 1, 1 } grow[ dot, r ] / 2 ] ] },
                          <| "VSF" -> ( v -> Which[
                              sign > 0,        Append[ body, Point[ #1 ] ] &,
                              radius === None, Append[ ring, Circle[ #1, #3 ] ] &,
                              True,            Append[ ring, Circle[ #1, radius ] ] & ] ) |> ],
                      sign < 0,
                        <| "VSF" -> ( v -> ( Append[ ring, Circle[ #1, #3 ] ] & ) ),
                           "VSize" -> If[ rec[ "VertexSize" ] === None, Nothing, v -> rec[ "VertexSize" ] ] |>,
                      True,
                        <| "Style" -> Style[ v, Directive[ color, Sequence @@ oList, Sequence @@ vDirs ] ],
                           "VSize" -> If[ rec[ "VertexSize" ] === None, Nothing, v -> rec[ "VertexSize" ] ] |>
                    ] ],
                  Reverse @ KeySort @ GroupBy[ cs, Sign @ #[[ 2 ]] & -> ( MapAt[ Abs, #, 2 ] & ) ] ] },
              If[ Length @ shapes == 1, First @ shapes,
                Join[ Join @@ shapes,
                  Replace[ Cases[ shapes, kv_ /; KeyExistsQ[ kv, "VSF" ] :> Last @ kv[ "VSF" ] ], {
                    { dotShape_Function, ringShape_Function } :> <| "VSF" -> ( v -> ( Through[ { dotShape, ringShape }[ ## ] ] & ) ) |>,
                    _ -> <| |> } ] ] ] ],
            vMasses ] },
        {
          coords    = AssociationThread[ VertexList @ graph -> GraphEmbedding @ graph ],
          edgeStyle = Association @ Cases[ edgeData, kv_Association :> kv[ "EdgeStyle" ] ]
        },
        {
          strokes = Catenate @ Cases[ entries,
            e_Association /; e[ "Record" ][ "EdgeShapeFunction" ] === None && ListQ[ e[ "Walk" ] ] && Length[ e[ "Walk" ] ] >= 2 :>
              With[ { runs = SplitBy[ Partition[ e[ "Walk" ], 2, 1 ], edgeStyle[ UndirectedEdge @@ Sort @ # ] & ] },
                MapIndexed[
                  { steps, position } |-> { UndirectedEdge @@ Sort @ # & /@ steps,
                              coords /@ Prepend[ Last /@ steps, First @ First @ steps ],
                              First[ position ] === Length[ runs ],
                              e[ "Record" ][ "Arrowheads" ] },
                  runs ] ] ],
          heads = Merge[ Cases[ entries,
            e_Association /; e[ "Record" ][ "Arrowheads" ] === True && e[ "Record" ][ "EdgeShapeFunction" ] === None &&
              ListQ[ e[ "Walk" ] ] && Length[ e[ "Walk" ] ] >= 2 :>
              Last @ e[ "Walk" ] -> With[ {
                  tip   = coords @ Last @ e[ "Walk" ],
                  style = Lookup[ edgeStyle, UndirectedEdge @@ Sort @ Take[ e[ "Walk" ], -2 ], Directive[ e[ "Color" ] ] ] },
                { u    = Normalize[ tip - coords @ e[ "Walk" ][[ -2 ]] ],
                  size = 5 + 2 First[ Cases[ style, AbsoluteThickness[ t_ ] :> t ], substrateThickness ],
                  ink  = First[ Cases[ style, _?ColorQ ], e[ "Color" ] ] },
                { If[ First @ ColorConvert[ ink, "LAB" ] > 0.6, GrayLevel[ 0.1 ], StandardYellow ], u, { - Last @ u, First @ u }, size } ] ],
            Identity ]
        },
        {
          vertexShapes = Association @ Cases[ vertexData, kv_Association /; KeyExistsQ[ kv, "VSF" ] :> kv[ "VSF" ] ]
        },
        {
          joinRules = Last @ Fold[
            { state, stroke } |-> Replace[ DeleteDuplicates @ Select[ First @ stroke, ! KeyExistsQ[ First @ state, # ] & ], {
                { } -> state,
                fresh_ :> {
                  Join[ First @ state, AssociationThread[ fresh -> True ] ],
                  Join[ Last @ state,
                    { First @ fresh -> ( { JoinForm[ "Round" ], CapForm[ "Round" ],
                        If[ MatchQ[ stroke[[ 4 ]], _Arrowheads ] && stroke[[ 3 ]],
                          Sequence @@ { stroke[[ 4 ]], Arrow @ stroke[[ 2 ]] },
                          Line @ stroke[[ 2 ]] ] } & ) },
                    ( # -> ( { } & ) ) & /@ Rest @ fresh ] } } ],
            { <| |>, { } },
            strokes ]
        },

        HighlightGraph[ graph,
          Cases[ vertexData, kv_Association /; KeyExistsQ[ kv, "Style" ] :> kv[ "Style" ] ],
          Sequence @@ DeleteCases[ {
            EdgeStyle           -> MapAt[ spell, DeleteCases[ Cases[ edgeData,   kv_Association :> kv[ "EdgeStyle" ] ], Nothing ], { All, 1 } ],
            EdgeShapeFunction   -> MapAt[ spell, Join[ DeleteCases[ Cases[ edgeData, kv_Association :> kv[ "EdgeShapeFunction" ] ], Nothing ], joinRules ], { All, 1 } ],
            VertexShapeFunction -> Normal @ Join[ vertexShapes, Association @ KeyValueMap[
              { v, hs } |-> v -> With[ { shape = Lookup[ vertexShapes, Key @ v, Disk[ #1, #3 ] & ], hs = hs },
                { shape[ ## ],
                  ( { fill, u, side, size } |-> With[ { tip = #1 - First[ #3 ] u },
                    { fill, Opacity[ 1 ], EdgeForm[ ], Polygon[ { tip, Offset[ size ( 0.75 side - u ), tip ], Offset[ size ( - 0.75 side - u ), tip ] } ] } ] ) @@@ hs } & ],
              heads ] ],
            VertexSize          -> DeleteCases[ Cases[ vertexData, kv_Association /; KeyExistsQ[ kv, "VSize" ] :> kv[ "VSize" ] ], Nothing ]
          }, _ -> { } ],
          FilterRules[ { opts }, Options @ HighlightGraph ] ]
    ]

(* every member of a closed polyline InfraSegment[p, ..., p] starts and ends at p, which its "VertexDensity" counts twice; the ink counts the
   return once, as it does for a closed walk, or p would be the heaviest vertex and the rest would draw at half strength *)

infraInk[ graph_Graph, x_ ] :=
  Which[
    VertexQ[ graph, x ] || AssociationQ[ x ],
      <| "VertexDensity" -> InfraDensity[ graph, x ], "EdgeDensity" -> <| |>, "Walk" -> None, "Knots" -> { } |>,
    MatchQ[ x, InfraWalk[ _List ] ] && ! VertexQ[ graph, First @ x ],
      With[ { walk = First @ x },
        <| "VertexDensity" -> InfraDensity[ graph, If[ Length @ walk > 1 && First @ walk === Last @ walk, Most @ walk, walk ] ],
           "EdgeDensity"   -> KeySort @ Counts[ UndirectedEdge @@ Sort @ # & /@ Partition[ walk, 2, 1 ] ],
           "Walk"          -> walk,
           "Knots"         -> { } |> ],
    MatchQ[ x, ( InfraBall | InfraShell | InfraSphere )[ _, _ ] |
      ( InfraTube | InfraCylinder | InfraCone | InfraSolidOfRevolution )[ _, _, ___Rule ] |
      ( InfraBallHull | InfraConvexHull | InfraQuadric )[ _, ___ ] | InfraIntersection[ __ ] ],
      <| "VertexDensity" -> InfraMeasurement[ graph, x, "VertexDensity" ], "EdgeDensity" -> <| |>, "Walk" -> None, "Knots" -> { } |>,
    MatchQ[ x, ( InfraSegment | InfraHalfLine | InfraRay | InfraInfiniteLine | InfraLine | InfraCircle | InfraArc )[ __ ] ],
      With[ {
          edges  = KeySort @ GroupBy[ Normal @ InfraMeasurement[ graph, x, "EdgeDensity" ],
            ( UndirectedEdge @@ Sort[ List @@ First @ # ] & ) -> Last, Total ],
          member = If[ InfraMeasurement[ graph, x, "Cardinality" ] == 1, First[ Replace[ x, {
        token_InfraPoint :> RandomInfraPoint[ graph, token, All ],
        token_InfraSegment :> RandomInfraSegment[ graph, token, All ],
        token_InfraHalfLine :> RandomInfraHalfLine[ graph, token, All ],
        token_InfraInfiniteLine :> RandomInfraInfiniteLine[ graph, token, All ],
        token_InfraCircle :> RandomInfraCircle[ graph, token, All ],
        token_InfraArc :> RandomInfraArc[ graph, token, All ],
        token_InfraRegularPolygon :> RandomInfraRegularPolygon[ graph, token, All ],
        token_InfraPlane :> RandomInfraPlane[ graph, token, All ],
        token_InfraBall :> RandomInfraBall[ graph, token, All ],
        token_InfraShell :> RandomInfraShell[ graph, token, All ],
        token_InfraSphere :> RandomInfraSphere[ graph, token, All ],
        token_InfraTube :> RandomInfraTube[ graph, token, All ],
        token_InfraCylinder :> RandomInfraCylinder[ graph, token, All ],
        token_InfraCone :> RandomInfraCone[ graph, token, All ],
        token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ graph, token, All ],
        token_InfraBallHull :> RandomInfraBallHull[ graph, token, All ],
        token_InfraConvexHull :> RandomInfraConvexHull[ graph, token, All ],
        token_InfraQuadric :> RandomInfraQuadric[ graph, token, All ],
        token_InfraWalk :> RandomInfraWalk[ graph, token, All ],
        token_InfraGeodesic :> RandomInfraGeodesic[ graph, token, All ],
        token_InfraEllipse :> RandomInfraEllipse[ graph, token, All ],
        token_InfraIntersection :> RandomInfraIntersection[ graph, token, All ],
        token_InfraUnion :> RandomInfraUnion[ graph, token, All ],
        token_InfraRay :> RandomInfraHalfLine[ graph, token, All ],
        token_InfraLine :> RandomInfraInfiniteLine[ graph, token, All ],
        token_InfraPolygon :> RandomInfraRegularPolygon[ graph, token, All ] } ], None ], None ] },
        <| "VertexDensity" -> If[ MatchQ[ x, InfraSegment[ p_, q__, p_ ] /; AnyTrue[ { q }, # =!= p & ] ],
               KeySort @ DeleteCases[ 0 ] @ Merge[
                 { InfraMeasurement[ graph, x, "VertexDensity" ], <| First @ x -> - InfraMeasurement[ graph, x, "Cardinality" ] |> },
                 Total ],
               InfraMeasurement[ graph, x, "VertexDensity" ] ],
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
             KeySort @ GroupBy[
               With[ { inNbr = GroupBy[ EdgeList @ x, Last -> First ], outNbr = GroupBy[ EdgeList @ x, First -> Last ], order = TopologicalSort @ x },
                 { alpha = Fold[ { a, w } |-> Append[ a, w -> Replace[ Lookup[ inNbr, Key @ w, { } ],
                         { { } -> 1, ps_ :> Total @ Lookup[ a, Key /@ ps ] } ] ], <| |>, order ],
                   beta = Fold[ { a, w } |-> Append[ a, w -> Replace[ Lookup[ outNbr, Key @ w, { } ],
                         { { } -> 1, qs_ :> Total @ Lookup[ a, Key /@ qs ] } ] ], <| |>, Reverse @ order ] },
                 # -> Lookup[ alpha, Key @ First @ # ] Lookup[ beta, Key @ Last @ # ] & /@ EdgeList @ x ],
               ( UndirectedEdge @@ Sort[ List @@ First @ # ] & ) -> Last, Total ],
             KeySort @ Counts[ UndirectedEdge @@ Sort @ # & /@ Partition[ walk, 2, 1 ] ] ],
           "Walk"          -> walk,
           "Knots"         -> { } |> ],
    MatchQ[ x, { _Graph, __Graph } ] && NoneTrue[ x, closedWalkQ ] &&
      AllTrue[ Partition[ walkSequence /@ x, 2, 1 ], Last @ First @ # === First @ Last @ # & ],
      With[ { knots = Prepend[ Last @ walkSequence @ # & /@ x, First @ walkSequence @ First @ x ] },
        Append[ infraInk[ graph, InfraWalk @ polylineToVertexSeq @ x ],
          "Knots" -> If[ First @ knots === Last @ knots, Most @ knots, knots ] ] ],
    ListQ[ x ] && AllTrue[ x, VertexQ[ graph, # ] & ],
      With[ { open = If[ Length @ x > 3 && First @ x === Last @ x, Most @ x, x ] },
        { closes = Length @ open >= 3 && EdgeQ[ graph, UndirectedEdge[ Last @ open, First @ open ] ] },
        If[ Length @ open >= 2 && DuplicateFreeQ @ open && ( open === x || closes ) &&
            AllTrue[ Partition[ open, 2, 1 ], EdgeQ[ graph, UndirectedEdge @@ # ] & ] &&
            EdgeCount @ Subgraph[ graph, open ] == Length @ open - Boole[ ! closes ],
          infraInk[ graph, InfraWalk @ If[ closes, Append[ open, First @ open ], open ] ],
          <| "VertexDensity" -> InfraDensity[ graph, x ], "EdgeDensity" -> <| |>, "Walk" -> None, "Knots" -> { } |> ] ],
    MatchQ[ x, { __ } | InfraUnion[ __ ] ],
      With[ { members = infraInk[ graph, # ] & /@ List @@ x },
        <| "VertexDensity" -> KeySort @ GroupBy[ Catenate[ Normal @ #[ "VertexDensity" ] & /@ members ], First -> Last, Total ],
           "EdgeDensity"   -> If[ MemberQ[ members, m_ /; m[ "EdgeDensity" ] === <| |> ], <| |>,
             KeySort @ GroupBy[ Catenate[ Normal @ #[ "EdgeDensity" ] & /@ members ], First -> Last, Total ] ],
           "Walk"          -> If[ Length @ members == 1, First[ members ][ "Walk" ], None ],
           "Knots"         -> Catenate[ #[ "Knots" ] & /@ members ] |> ] ]
