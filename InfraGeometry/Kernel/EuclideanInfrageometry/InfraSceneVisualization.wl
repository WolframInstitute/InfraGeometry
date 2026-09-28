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


(* ===================== Palette ===================== *)

(* the one place an object colour is written down; a literal rather than a shipped asset, so $InfraPointColor does not depend on file I/O at load time *)

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
(* at 14 a single-realisation point swallowed several mesh cells on a Medium plane *)
$InfraPointSize     = 6;

(* one absolute value per class, independent of the graph, with three-pixel gaps so the classes stay distinguishable; the accent is a separate role, not a class *)
$InfraPointSizes      = <| Small -> 4, Medium -> 7, Large -> 10 |>;
$InfraAccentPointSize = 12;

$InfraSceneImageSize = Medium;

(* colours belong to the ORDER objects are added to a scene, not to object types *)
$InfraStrikeOutPalette := ColorData[ 112, "ColorList" ];


(* ===================== Per-object style spec ===================== *)

(* True resolves to Arrowheads[Medium], a symbolic size that scales with the plot rather than with the stroke *)
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
        (* an object's own arrowhead, True on and False off: caught here so it reaches the stroke instead of being buried in a vertex/edge Directive, where it would do nothing *)
        ( a : ( _Arrowheads | True | False ) ) :> Append[ rec, "Arrowheads" -> resolveArrowSpec[ a ] ],
        c_?ColorQ :> Append[ rec, "Color" -> c ],
        d_ :> MapAt[ Append[ #, d ] &, MapAt[ Append[ #, d ] &, rec, "VertexDir" ], "EdgeDir" ]
      } ],
      Join[ defaults, <|
        "VertexDir" -> { }, "EdgeDir" -> { }, "EdgeStyle" -> None,
        "EdgeShapeFunction" -> None, "VertexSize" -> None, "VertexShapeFunction" -> None |> ],
      normalizeHighlightSpec @ spec ],
    (* an explicit appearance directive supersedes the matching count-driven diffusion: suppress the *Range so the user's value is the only one emitted on that channel *)
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


(* ===================== InfraHighlightGraph ===================== *)

(* a channel value is None, a scalar base measure t -- a fuzzy object distributes it as t * count/norm, conserving the total measure across realisations -- or a {min, max} envelope interpolated by weight, whose floor keeps rare elements visible *)
Options[ InfraHighlightGraph ] = Join[
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

InfraHighlightGraph[ graph_Graph, obj : Except[_List], opts : OptionsPattern[] ] :=
  InfraHighlightGraph[ graph, { obj }, opts ]

(* the cumulative density of the objects: each object's vertex and edge density divided by its heaviest mass, summed at every element and capped at 1, the colour the blend of the objects' colours weighted by those masses *)
InfraHighlightGraph[ graph_Graph, items_List, opts : OptionsPattern[] ] :=
  Module[ { ranges, palette, objects, entries, vMasses, eMasses },

    ranges = <|
      "OpacityRange"   -> OptionValue[ "OpacityRange" ],
      "ThicknessRange" -> OptionValue[ "ThicknessRange" ],
      "PointSizeRange" -> OptionValue[ "PointSizeRange" ],
      "Arrowheads"     -> resolveArrowSpec @ OptionValue[ "Arrowheads" ] |>;

    palette = Replace[ OptionValue[ "Palette" ], {
      Automatic :> $InfraStrikeOutPalette,
      c : Except[ _List ] :> { c } } ];

    (* a Directive styles every object after it until the next one, as in Graphics; obj -> style and Style[obj, ...] add to it for that object alone *)
    objects = DeleteCases[
      Last @ Fold[
        { state, item } |-> Replace[ item, {
          d_Directive          :> { List @@ d, Last @ state },
          Style[ obj_, dirs__ ] :> { First @ state, Append[ Last @ state, obj -> Join[ First @ state, { dirs } ] ] },
          ( obj_ -> spec_ )    :> { First @ state, Append[ Last @ state, obj -> Join[ First @ state, normalizeHighlightSpec @ spec ] ] },
          obj_                 :> { First @ state, Append[ Last @ state, obj -> First @ state ] } } ],
        { { }, { } },
        items ],
      ( $Failed | { } ) -> _ ];

    entries = MapIndexed[
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
      objects ];

    (* the knots of a leg chain ride on top of its stroke as one more point density; appended last, so no listed object's palette slot moves *)
    entries = Join[ entries,
      Cases[ entries, e_Association /; e[ "Knots" ] =!= { } :>
        With[ { record = parseHighlightStyle[ Automatic, ranges ], knots = KeySort @ Counts @ e[ "Knots" ] },
          <| "Verts" -> knots / Max @ knots, "Edges" -> <| |>, "Walk" -> None, "Knots" -> { },
             "Color" -> $InfraPointColor,
             "Record" -> Append[ record,
               "PointSizeRange" -> Replace[ record[ "PointSizeRange" ], Automatic :> $InfraPointSize ] ] |> ] ] ];

    vMasses = Merge[ ( e |-> ( { e[ "Color" ], #, e[ "Record" ] } & /@ e[ "Verts" ] ) ) /@ entries, Identity ];
    eMasses = Merge[ ( e |-> ( { e[ "Color" ], #, e[ "Record" ] } & /@ e[ "Edges" ] ) ) /@ entries, Identity ];

    (* colour and opacity ride per-element Style[] specs; thickness and point size are rerouted to top-level EdgeStyle / VertexShapeFunction, which HighlightGraph silently ignores inside Style[] *)
    With[ {
        lerp  = { spec, w } |-> If[ ListQ @ spec, spec[[ 1 ]] + ( spec[[ 2 ]] - spec[[ 1 ]] ) w, spec w ],
        blend = cs |-> {
          Replace[ DeleteDuplicates @ cs[[ All, 1 ]], { { c_ } :> c, _ :> Blend[ cs[[ All, 1 ]], cs[[ All, 2 ]] ] } ],
          Min[ 1, Total @ cs[[ All, 2 ]] ],
          cs[[ -1, 3 ]] } },
      {
          (* all edge styling rides top-level EdgeStyle: HighlightGraph gives a highlight Style priority over EdgeStyle and drops AbsoluteThickness inside it, so an edge listed both ways renders at default thickness *)
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
                (* point sizing is rerouted to a top-level VertexShapeFunction, since HighlightGraph drops it inside Style[] specs *)
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
        (* a walk is one stroke: HighlightGraph draws each edge separately with a butt cap and ignores a CapForm / JoinForm in the edge directive, so a bend leaves a wedge of background bitten out of the ribbon.  Each maximal run of equal-styled consecutive steps is redrawn as one joined Line, carried by the EdgeShapeFunction of its first unclaimed edge; each edge takes at most one rule, since Graph keeps only the first *)
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
  ]


(* ===================== The ink ===================== *)

(* every object as a vertex density <| v -> m |> and an edge density <| UndirectedEdge[v, w] -> m |>, with the vertex order of an object that has one member and the knots of a leg chain.  The branches are ordered because a vertex label may itself be a List *)

infraInk[ graph_Graph, x_ ] := Which[
  (* a vertex or a density: its own mass *)
  VertexQ[ graph, x ] || AssociationQ[ x ],
    <| "VertexDensity" -> InfraDensity[ graph, x ], "EdgeDensity" -> <| |>, "Walk" -> None, "Knots" -> { } |>,
  (* one walk: visit counts, a closed walk's return not counted again, and traversal counts of its steps *)
  MatchQ[ x, InfraWalk[ _List ] ] && ! VertexQ[ graph, First @ x ],
    With[ { walk = First @ x },
      <| "VertexDensity" -> InfraDensity[ graph, If[ Length @ walk > 1 && First @ walk === Last @ walk, Most @ walk, walk ] ],
         "EdgeDensity"   -> KeySort @ Counts[ UndirectedEdge @@ Sort @ # & /@ Partition[ walk, 2, 1 ] ],
         "Walk"          -> walk,
         "Knots"         -> { } |> ],
  (* heads on heads: their vertex density *)
  MatchQ[ x, ( InfraIntersection | InfraUnion )[ __ ] ],
    <| "VertexDensity" -> InfraMeasurement[ graph, x, "VertexDensity" ], "EdgeDensity" -> <| |>, "Walk" -> None, "Knots" -> { } |>,
  (* a Euclidean head: its measurements, the two directions of an edge summed; one member keeps its order, closed when its closing step carries mass *)
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
  (* a walk graph, a cycle graph or a DAG: its occupation, read off its one walk when it has one *)
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
  (* a leg chain -- consecutive open legs sharing their endpoint -- is the walk through its legs, with its knots *)
  MatchQ[ x, { _Graph, __Graph } ] && NoneTrue[ x, closedWalkQ ] &&
    AllTrue[ Partition[ walkSequence /@ x, 2, 1 ], Last @ First @ # === First @ Last @ # & ],
    With[ { knots = Prepend[ Last @ walkSequence @ # & /@ x, First @ walkSequence @ First @ x ] },
      Append[ infraInk[ graph, InfraWalk @ polylineToVertexSeq @ x ],
        "Knots" -> If[ First @ knots === Last @ knots, Most @ knots, knots ] ] ],
  (* a region: a unit mass on its vertices and on the edges of its induced subgraph *)
  ListQ[ x ] && AllTrue[ x, VertexQ[ graph, # ] & ],
    <| "VertexDensity" -> InfraDensity[ graph, x ],
       "EdgeDensity"   -> KeySort @ Counts[ UndirectedEdge @@ Sort[ List @@ # ] & /@ EdgeList @ Subgraph[ graph, x ] ],
       "Walk"          -> None,
       "Knots"         -> { } |>,
  (* a bundle or a family: the sum of its members, summed by GroupBy as InfraDensity sums them *)
  MatchQ[ x, { ( _Graph | _List ) .. } ],
    With[ { members = infraInk[ graph, # ] & /@ x },
      <| "VertexDensity" -> KeySort @ GroupBy[ Catenate[ Normal @ #[ "VertexDensity" ] & /@ members ], First -> Last, Total ],
         "EdgeDensity"   -> KeySort @ GroupBy[ Catenate[ Normal @ #[ "EdgeDensity" ] & /@ members ], First -> Last, Total ],
         "Walk"          -> If[ Length @ members == 1, First[ members ][ "Walk" ], None ],
         "Knots"         -> Catenate[ #[ "Knots" ] & /@ members ] |> ] ]
