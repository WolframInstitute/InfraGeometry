Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: InfraFiberBundles :: InfraFiberedGraphHighlight *)

Options[ InfraFiberedGraphHighlight ] = DeleteDuplicatesBy[ Join[ {
  Method -> "CircularFiber",
  "BaseGraphLayout" -> Automatic,
  "BaseVertexCoordinates" -> Automatic,
  "FiberRadius" -> Automatic
}, Options[ InfraSubstrateHighlight ], Options[ Graph3D ] ], First ]

InfraFiberedGraphHighlight[ fib : _[ _Graph, __ ], opts : OptionsPattern[] ] /;
    AllTrue[ { opts }, MatchQ[ #, _Rule | _RuleDelayed ] & ] :=
  InfraFiberedGraphHighlight[ fib, { }, opts ]

InfraFiberedGraphHighlight[ fib : _[ _Graph, __ ], object : Except[ _List | _Rule | _RuleDelayed ], opts : OptionsPattern[] ] :=
  InfraFiberedGraphHighlight[ fib, { object }, opts ]

InfraFiberedGraphHighlight[ fib : _[ _Graph, __ ], items_List, opts : OptionsPattern[] ] /;
    GraphQ[ InfraTotalGraph[ fib ] ] && AssociationQ[ InfraFibrationAssociation[ fib ] ] &&
      SubsetQ[ First /@ Options[ InfraFiberedGraphHighlight ], First /@ Flatten[ { opts } ] ] &&
      MemberQ[ { "CircularFiber", "3DFiber", "HighlightFiber" }, OptionValue[ InfraFiberedGraphHighlight, { opts }, Method ] ] &&
      MatchQ[ OptionValue[ InfraFiberedGraphHighlight, { opts }, "BaseVertexCoordinates" ], Automatic | _Association ] &&
      ( OptionValue[ InfraFiberedGraphHighlight, { opts }, "BaseVertexCoordinates" ] === Automatic ||
        With[ { coordinates = OptionValue[ InfraFiberedGraphHighlight, { opts }, "BaseVertexCoordinates" ] },
          AllTrue[ VertexList @ InfraBaseGraph[ fib ],
            KeyExistsQ[ coordinates, # ] && MatchQ[ Lookup[ coordinates, Key @ # ], { _?NumericQ, _?NumericQ } ] & ] ] ) &&
      MatchQ[ OptionValue[ InfraFiberedGraphHighlight, { opts }, "FiberRadius" ], Automatic | _?Positive ] :=
  Module[ { convert, family },
    With[ { total = InfraTotalGraph @ fib, projection = InfraFibrationAssociation @ fib,
            base = InfraBaseGraph @ fib, method = OptionValue[ InfraFiberedGraphHighlight, { opts }, Method ] },
      { fibers = GroupBy[ VertexList @ total, Lookup[ projection, Key @ # ] & ],
        palette = ColorData[ 112, "ColorList" ],
        baseCoordinates = If[ method === "HighlightFiber", <| |>,
          Replace[ OptionValue[ InfraFiberedGraphHighlight, { opts }, "BaseVertexCoordinates" ],
            Automatic :> AssociationThread[ VertexList @ base,
              GraphEmbedding @ Graph[ base,
                GraphLayout -> OptionValue[ InfraFiberedGraphHighlight, { opts }, "BaseGraphLayout" ] ] ] ] ] },
      { radius = If[ method === "HighlightFiber", None,
          Replace[ OptionValue[ InfraFiberedGraphHighlight, { opts }, "FiberRadius" ], Automatic :>
            Min[ Prepend[ Select[
              EuclideanDistance @@ Lookup[ baseCoordinates, Key /@ List @@ # ] & /@ EdgeList @ base, Positive ], 1 ] ] / 3 ] ],
        vertexStyles = Catenate @ MapIndexed[
          { fiber, position } |-> ( # -> Lighter[ palette[[ 1 + Mod[ First @ position - 1, Length @ palette ] ]], .55 ] & /@ fiber ),
          Values @ fibers ] },
      { coordinates = If[ method === "HighlightFiber",
          AssociationThread[ VertexList @ total, GraphEmbedding @ Graph[ total,
            Sequence @@ FilterRules[ Flatten[ { opts } ], Options @ Graph ] ] ],
          Association @ Catenate @ KeyValueMap[
            { point, fiber } |-> With[ { center = Take[ Lookup[ baseCoordinates, Key @ point ], 2 ],
                circle = If[ Length @ fiber === 1, { { 0, 0 } }, CirclePoints @ Length @ fiber ] },
              Thread[ fiber -> If[ method === "3DFiber",
                ( Append[ center, 2 radius ] + radius { First @ #, Last @ # / 3, Last @ # } & /@ circle ),
                ( center + radius # & /@ circle ) ] ] ],
            fibers ] ] },
      family[ object_ ] :=
        Which[
          VertexQ[ total, object ], False,
          MatchQ[ object, _InfraSection | _InfraConnection ], True,
          MatchQ[ object, Style[ _, __ ] | _Rule ], family @ First @ object,
          ListQ[ object ], object =!= { } && AllTrue[ object, family ],
          True, False ];
      convert[ object_ ] :=
        Which[
          VertexQ[ total, object ], { object },
          MatchQ[ object, InfraSection[ _Association ] ],
            { Style[ Subgraph[ total, Values @ First @ object ], "PointSizeRange" -> Automatic ] },
          MatchQ[ object, InfraConnection[ _List ] ], { First @ object },
          MatchQ[ object, Style[ _, __ ] ],
            With[ { styles = Rest[ List @@ object ] },
              Replace[ #, {
                Style[ drawn_, defaults__ ] :> Style[ drawn, defaults, Sequence @@ styles ],
                drawn_ :> Style[ drawn, Sequence @@ styles ] } ] & /@ convert[ First @ object ] ],
          MatchQ[ object, _Rule ],
            With[ { style = Last @ object },
              Replace[ #, {
                Style[ drawn_, defaults__ ] :> drawn -> Join[ { defaults }, Replace[ style, {
                  Directive[ directives___ ] :> { directives }, list_List :> list, other_ :> { other } } ] ],
                drawn_ :> drawn -> style } ] & /@ convert[ First @ object ] ],
          ListQ[ object ] && family[ object ], Catenate[ convert /@ object ],
          True, { object } ];
      With[ { drawing = If[ method === "3DFiber", Graph3D, Graph ][ total,
          Sequence @@ FilterRules[ Flatten[ { opts } ], Options @ Graph3D ],
          VertexCoordinates -> Normal @ coordinates, VertexStyle -> vertexStyles ] },
        InfraSubstrateHighlight[ drawing, Catenate[ convert /@ items ],
          Sequence @@ FilterRules[ Flatten[ { opts } ], Options @ InfraSubstrateHighlight ] ] ] ] ]
