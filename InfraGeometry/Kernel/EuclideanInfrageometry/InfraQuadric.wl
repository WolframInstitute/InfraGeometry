Package[ "WolframInstitute`InfraGeometry`" ]

Options[ RandomInfraQuadric ] = { "NextVertexFunction" -> Automatic }

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraQuadric *)

(* the band { v : lo <= Sum_i w_i d(a_i, v) <= hi } with d(a_i, v) the distance to the anchor's vertices, as InfraBall reads its centre; a bare
   c is the solid { v : Sum_i w_i d(a_i, v) <= c }, the weights all 1 when omitted.  One focus is the ball, two the ellipse, {c, c} the elliptic
   shell, the weights {1, -1} a hyperbola branch *)

InfraMeasurement[ graph_Graph, InfraQuadric[ foci_List, c_ ], "VertexDensity" ] :=
  InfraMeasurement[ graph, InfraQuadric[ foci, c, ConstantArray[ 1, Length @ foci ] ], "VertexDensity" ]

InfraMeasurement[ graph_Graph, InfraQuadric[ foci_List, c : Except[ _List ], weights_List ], "VertexDensity" ] :=
  InfraMeasurement[ graph, InfraQuadric[ foci, { -Infinity, c }, weights ], "VertexDensity" ]

InfraMeasurement[ graph_Graph, InfraQuadric[ foci_List, { lo_, hi_ }, weights_List ], "VertexDensity" ] /; Length @ weights == Length @ foci :=
  With[ { dm = GraphDistanceMatrix @ graph },
    { sums = weights . Map[ focus |-> Min /@ Transpose @ dm[[ VertexIndex[ graph, # ] & /@ Keys @ InfraDensity[ graph, focus ] ]], foci ] },
    AssociationThread[ Sort @ Pick[ VertexList @ graph, Thread[ lo <= sums <= hi ] ], 1 ] ]

InfraMeasurement[ graph_Graph, quadric : InfraQuadric[ _List, _, ___ ], "EdgeDensity" ] :=
  AssociationThread[ EdgeList @ Subgraph[ graph, Keys @ InfraMeasurement[ graph, quadric, "VertexDensity" ] ], 1 ]

InfraMeasurement[ _Graph, InfraQuadric[ _List, _, ___ ], "Cardinality" ] :=
  1

InfraMeasurement[ _Graph, InfraQuadric[ _List, _, ___ ], "Faithful" ] :=
  True

InfraMeasurement[ graph_Graph, quadric : InfraQuadric[ _List, _, ___ ], All ] :=
  InfraMeasurement[ graph, quadric,
    { "Faithful", "Cardinality", "VertexDensity", "EdgeDensity", "Subgraph",
      "CountingMeasure", "RiemannianMeasure" } ]

RandomInfraQuadric[ graph_Graph, quadric : InfraQuadric[ _List, _ ] | InfraQuadric[ _List, _, _List ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /; SubsetQ[ First /@ Options[ RandomInfraQuadric ], First /@ { opts } ] &&
    ( OptionValue[ RandomInfraQuadric, { opts }, "NextVertexFunction" ] =!= RandomChoice || count =!= All ) :=
  With[ { members = Keys @ InfraMeasurement[ graph, quadric, "VertexDensity" ],
          nextFn = OptionValue[ RandomInfraQuadric, { opts }, "NextVertexFunction" ] },
    { ordered = { members } },
    Which[
      count === Automatic, members,
      count === All,       ordered,
      nextFn === Identity, If[ IntegerQ @ count && Length @ ordered < count, { }, Take[ ordered, count ] ],
      IntegerQ @ count && Length @ ordered < count, { },
      True, RandomSample[ ordered, count ] ] ]

InfraMemberQ[ graph_Graph, quadric : InfraQuadric[ _List, _, ___ ], vs_List ] :=
  Union @ vs === Keys @ InfraMeasurement[ graph, quadric, "VertexDensity" ]

RandomInfraQuadric[ graph_Graph, foci_List, level_,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic,
    opts : OptionsPattern[] ] /; ! MatchQ[ First @ { foci, level }, _InfraQuadric ] &&
    SubsetQ[ First /@ Options[ RandomInfraQuadric ], First /@ { opts } ] :=
  RandomInfraQuadric[ graph, InfraQuadric[ foci, level ], count,
    "NextVertexFunction" -> OptionValue[ "NextVertexFunction" ] ]

RandomInfraQuadric[ graph_Graph, foci_List, level_, weights_List,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic,
    opts : OptionsPattern[] ] /; ! MatchQ[ First @ { foci, level, weights }, _InfraQuadric ] &&
    SubsetQ[ First /@ Options[ RandomInfraQuadric ], First /@ { opts } ] :=
  RandomInfraQuadric[ graph, InfraQuadric[ foci, level, weights ], count,
    "NextVertexFunction" -> OptionValue[ "NextVertexFunction" ] ]
