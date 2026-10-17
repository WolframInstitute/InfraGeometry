Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: InfraFiberBundles :: InfraFiberedGraphViewer *)

Options[ InfraFiberedGraphViewer ] = Options[ InfraFiberedGraphHighlight ]

InfraFiberedGraphViewer[ fib : _[ _Graph, __ ], opts : OptionsPattern[] ] /;
    AllTrue[ { opts }, MatchQ[ #, _Rule | _RuleDelayed ] & ] :=
  InfraFiberedGraphViewer[ fib, { }, opts ]

InfraFiberedGraphViewer[ fib : _[ _Graph, __ ], object : Except[ _List | _Rule | _RuleDelayed ], opts : OptionsPattern[] ] :=
  InfraFiberedGraphViewer[ fib, { object }, opts ]

InfraFiberedGraphViewer[ fib : _[ _Graph, __ ], items_List, opts : OptionsPattern[] ] /;
    GraphQ[ InfraTotalGraph[ fib ] ] && AssociationQ[ InfraFibrationAssociation[ fib ] ] &&
      SubsetQ[ First /@ Options[ InfraFiberedGraphViewer ], First /@ Flatten[ { opts } ] ] &&
      MemberQ[ { "CircularFiber", "3DFiber", "HighlightFiber" }, OptionValue[ InfraFiberedGraphViewer, { opts }, Method ] ] &&
      MatchQ[ OptionValue[ InfraFiberedGraphViewer, { opts }, "BaseVertexCoordinates" ], Automatic | _Association ] &&
      ( OptionValue[ InfraFiberedGraphViewer, { opts }, "BaseVertexCoordinates" ] === Automatic ||
        With[ { coordinates = OptionValue[ InfraFiberedGraphViewer, { opts }, "BaseVertexCoordinates" ] },
          AllTrue[ VertexList @ InfraBaseGraph[ fib ],
            KeyExistsQ[ coordinates, # ] && MatchQ[ Lookup[ coordinates, Key @ # ], { _?NumericQ, _?NumericQ } ] & ] ] ) &&
      MatchQ[ OptionValue[ InfraFiberedGraphViewer, { opts }, "FiberRadius" ], Automatic | _?Positive ] :=
  Module[ { structures },
    With[ { total = InfraTotalGraph @ fib, projection = InfraFibrationAssociation @ fib, base = InfraBaseGraph @ fib },
      structures[ object_ ] :=
        Which[
          VertexQ[ total, object ], { },
          MatchQ[ object, _InfraSection | _InfraConnection ], { object },
          MatchQ[ object, Style[ _, __ ] | _Rule ], structures @ First @ object,
          ListQ[ object ], Catenate[ structures /@ object ],
          True, { } ];
      With[ { objects = Catenate[ structures /@ items ] },
        { sections = First /@ Cases[ objects, _InfraSection ], connections = First /@ Cases[ objects, _InfraConnection ] },
        { baseCoordinates = Replace[ OptionValue[ InfraFiberedGraphViewer, { opts }, "BaseVertexCoordinates" ],
        Automatic :> AssociationThread[ VertexList @ base,
          GraphEmbedding @ Graph[ base, GraphLayout -> OptionValue[ InfraFiberedGraphViewer, { opts }, "BaseGraphLayout" ] ] ] ] },
    { drawing = InfraFiberedGraphHighlight[ fib, { }, "BaseVertexCoordinates" -> baseCoordinates, opts ] },
    { coordinates = GraphEmbedding @ drawing, literal = InfraFibration[ drawing, projection ] },
    DynamicModule[ { hovered = { } },
      Column[ {
        Row[ {
          EventHandler[
            Dynamic[
              With[ { selectedVertices = Which[
                    hovered === { }, { },
                    First @ hovered === "Vertex", { Last @ hovered },
                    True, List @@ Last @ hovered ] },
                { overlays = If[ hovered === { }, { }, Join[
                    If[ First @ hovered === "Vertex",
                      { Style[ InfraFiber[ literal, Last @ hovered ], StandardYellow, Opacity[ .7 ] ] }, { } ],
                    ( Style[ InfraSection @ KeyTake[ #, selectedVertices ], StandardOrange, AbsolutePointSize[ 10 ] ] & /@ sections ),
                    If[ First @ hovered === "Edge",
                      ( edges |-> Style[ InfraConnection @ Select[ edges,
                          Sort @ Lookup[ projection, Key /@ List @@ # ] === Sort @ selectedVertices & ],
                          StandardPurple, AbsoluteThickness[ 4 ] ] ) /@ connections, { } ] ] ] },
                { highlighted = InfraFiberedGraphHighlight[ literal, Join[ items, overlays ],
                    Method -> "HighlightFiber", "BaseVertexCoordinates" -> baseCoordinates, VertexCoordinates -> coordinates, opts ] },
                { shapes = Replace[ VertexShapeFunction /. Options[ highlighted, VertexShapeFunction ], {
                      rules_List :> Association @ Cases[ rules, _Rule ], _ -> <| |> } ],
                  defaultShape = Replace[ OptionValue[ InfraFiberedGraphViewer, { opts }, VertexShapeFunction ], {
                    function_Function :> function,
                    function : Except[ Automatic | None | Inherited, _Symbol ] :> function,
                    _ :> If[ Length @ First[ coordinates, { 0, 0 } ] === 3,
                      Sphere[ #1, Max @ Flatten @ { #3 } ] &, Disk[ #1, #3 ] & ] } ] },
                Graph[ highlighted, VertexShapeFunction -> Map[
                  vertex |-> With[ { shape = Lookup[ shapes, Key @ vertex, defaultShape ], vertex = vertex },
                    vertex -> ( Annotation[ shape[ ## ], { "TotalVertex", vertex }, "Mouse" ] & ) ],
                  VertexList @ highlighted ] ] ],
              TrackedSymbols :> { hovered } ],
            { "MouseMoved" :> With[ { annotation = MouseAnnotation[ ] },
                If[ MatchQ[ annotation, { "TotalVertex", _ } ],
                  hovered = { "Vertex", Lookup[ projection, Key @ Last @ annotation ] } ] ],
              "MouseExited" :> ( hovered = { } ) }, PassEventsDown -> True ],
          Spacer[ 20 ],
          EventHandler[
            Dynamic[
              Graph[ base, VertexCoordinates -> Normal @ baseCoordinates,
                VertexStyle -> If[ MatchQ[ hovered, { "Vertex", _ } ], { Last @ hovered -> StandardYellow }, { } ],
                EdgeStyle -> If[ MatchQ[ hovered, { "Edge", _ } ], { Last @ hovered -> StandardPurple }, { } ],
                VertexShapeFunction -> ( Annotation[ Disk[ #1, #3 ], { "BaseVertex", #2 }, "Mouse" ] & ),
                EdgeShapeFunction -> ( Annotation[ Line[ #1 ], { "BaseEdge", #2 }, "Mouse" ] & ),
                Sequence @@ FilterRules[ Flatten[ { opts } ],
                  { ImageSize, Background, BaseStyle, LabelStyle, VertexLabels, EdgeLabels, PlotLabel } ] ],
              TrackedSymbols :> { hovered } ],
            { "MouseMoved" :> With[ { annotation = MouseAnnotation[ ] },
                Which[
                  MatchQ[ annotation, { "BaseVertex", _ } ], hovered = { "Vertex", Last @ annotation },
                  MatchQ[ annotation, { "BaseEdge", _ } ], hovered = { "Edge", Last @ annotation },
                  True, hovered = { } ] ],
              "MouseExited" :> ( hovered = { } ) }, PassEventsDown -> True ]
        } ],
        Dynamic[ Which[
          hovered === { }, "Hover a vertex to inspect its fiber, or a base edge to inspect section and connection edges.",
          First @ hovered === "Vertex", Row[ { "Fiber over ", Last @ hovered } ],
          True, Row[ { "Lifts over ", Last @ hovered } ] ], TrackedSymbols :> { hovered } ]
      } ] ] ] ] ]
