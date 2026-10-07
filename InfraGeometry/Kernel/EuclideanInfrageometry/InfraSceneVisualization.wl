Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraSceneVisualization *)

PackageScope[ $InfraStrikeOutPalette ]
PackageScope[ $InfraPointSizes ]
PackageScope[ $InfraAccentPointSize ]
PackageScope[ $InfraOpacityRange ]
PackageScope[ $InfraEdgeThickness ]
PackageScope[ $InfraPointSize ]
PackageScope[ infraInk ]
PackageScope[ parseHighlightStyle ]
PackageScope[ normalizeHighlightSpec ]

$InfraOpacityRange  = { 0.40, 1.0 }
$InfraEdgeThickness = 9.0
$InfraPointSize     = 6

$InfraPointSizes      = <| Small -> 4, Medium -> 7, Large -> 10 |>
$InfraAccentPointSize = 12

$InfraStrikeOutPalette :=
  ColorData[ 112, "ColorList" ]

resolveArrowSpec[ spec_ ] :=
  Replace[ spec, {
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
    "ThicknessRange" :> $InfraEdgeThickness,
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
        { } -> _ ] },
    { objectEntries = MapIndexed[
        { item, idx } |-> With[ {
            ink    = infraInk[ graph, First @ item ],
            record = parseHighlightStyle[ Last @ item, ranges ] },
          { mass = Max[ Values @ ink[ "VertexDensity" ], Values @ ink[ "EdgeDensity" ] ] },
          <| "Verts"  -> ink[ "VertexDensity" ] / mass,
             "Edges"  -> ink[ "EdgeDensity" ] / mass,
             "Faint"  -> If[ ink[ "EdgeDensity" ] === <| |>,
               UndirectedEdge @@ Sort[ List @@ # ] & /@ EdgeList @ Subgraph[ graph, Keys @ ink[ "VertexDensity" ] ], { } ],
             "Walk"   -> ink[ "Walk" ],
             "Knots"  -> ink[ "Knots" ],
             "Color"  -> Lookup[ record, "Color", palette[[ 1 + Mod[ First @ idx - 1, Length @ palette ] ]] ],
             "Record" -> Append[ record, "PointSizeRange" -> Replace[ record[ "PointSizeRange" ],
               Automatic :> If[ ink[ "EdgeDensity" ] === <| |>, $InfraPointSize, None ] ] ] |> ],
        objects ] },
    { entries = Join[ objectEntries,
        MapIndexed[
          { e, k } |-> With[ { record = parseHighlightStyle[ Automatic, ranges ], knots = KeySort @ Counts @ e[ "Knots" ] },
            <| "Verts" -> knots / Max @ knots, "Edges" -> <| |>, "Faint" -> { }, "Walk" -> None, "Knots" -> { },
               "Color" -> palette[[ 1 + Mod[ Length @ objectEntries + First @ k - 1, Length @ palette ] ]],
               "Record" -> Append[ record,
                 "PointSizeRange" -> Replace[ record[ "PointSizeRange" ], Automatic :> $InfraPointSize ] ] |> ],
          Select[ objectEntries, #[ "Knots" ] =!= { } & ] ] ] },
    { vMasses = Merge[ ( e |-> ( { e[ "Color" ], #, e[ "Record" ] } & /@ e[ "Verts" ] ) ) /@ entries, Identity ],
      eMasses = Merge[ ( e |-> ( { e[ "Color" ], #, e[ "Record" ] } & /@ e[ "Edges" ] ) ) /@ entries, Identity ],
      fMasses = Merge[ ( e |-> AssociationMap[ { e[ "Color" ], e[ "Record" ] } &, e[ "Faint" ] ] ) /@ entries, Identity ] },
    { lerp  = { spec, w } |-> If[ ListQ @ spec, spec[[ 1 ]] + ( spec[[ 2 ]] - spec[[ 1 ]] ) w, spec w ],
      blend = cs |-> {
        Replace[ DeleteDuplicates @ cs[[ All, 1 ]], { { c_ } :> c, _ :> Blend[ cs[[ All, 1 ]], cs[[ All, 2 ]] ] } ],
        Min[ 1, Total @ cs[[ All, 2 ]] ],
        cs[[ -1, 3 ]] } },
      {
          edgeData = Join[
            KeyValueMap[
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
            KeyValueMap[
              { ue, cs } |-> With[ { rec = cs[[ -1, 2 ]] },
                <|
                  "EdgeStyle" -> ( ue -> Directive[
                      Replace[ DeleteDuplicates @ cs[[ All, 1 ]], { { c_ } :> c, colors_ :> Blend @ colors } ],
                      Sequence @@ If[ rec[ "OpacityRange" ] === None, { }, { Opacity[ First @ Flatten @ { rec[ "OpacityRange" ] } ] } ],
                      Sequence @@ List @@ rec[ "EdgeDir" ],
                      Sequence @@ If[ rec[ "EdgeStyle" ] === None, { }, { rec[ "EdgeStyle" ] } ] ] ),
                  "EdgeShapeFunction" -> If[ rec[ "EdgeShapeFunction" ] === None, Nothing,
                    ue -> rec[ "EdgeShapeFunction" ] ]
                |> ],
              KeyDrop[ fMasses, Keys @ eMasses ] ] ],
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
    MatchQ[ x, ( InfraSegment | InfraRay | InfraLine | InfraCircle | InfraArc )[ __ ] ],
      With[ {
          edges  = KeySort @ GroupBy[ Normal @ InfraMeasurement[ graph, x, "EdgeDensity" ],
            ( UndirectedEdge @@ Sort[ List @@ First @ # ] & ) -> Last, Total ],
          member = If[ InfraMeasurement[ graph, x, "Cardinality" ] == 1, FindInfraRepresentative[ graph, x ], None ] },
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
