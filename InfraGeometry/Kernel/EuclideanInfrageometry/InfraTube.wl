Package[ "WolframInstitute`InfraGeometry`" ]

Options[ RandomInfraTube ] = { Method -> "Balls", "NextVertexFunction" -> Automatic }

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraTube *)

(* the tube { v : min_i ( d(a_i, v) - r_i ) <= 0 } along the core a_1, ..., a_m; a band profile { s_i, t_i } keeps the v with
   min_i ( d(a_i, v) - t_i ) <= 0 <= min_i ( d(a_i, v) - s_i ), the outer tube less the open inner one, and a constant band { s, t } is
   { v : s <= d(v, core) <= t } *)

InfraMeasurement[ graph_Graph, InfraTube[ core_, s : _?NumericQ | Infinity ], "VertexDensity" ] :=
  With[
    { support = Keys @ If[ VertexQ[ graph, core ] || MatchQ[ core, _List | _Association | _Graph ],
        InfraDensity[ graph, core ],
        InfraMeasurement[ graph, core, "VertexDensity" ] ] },
    AssociationThread[ Union @ VertexList @ NeighborhoodGraph[ graph, support, Floor @ Min[ s, VertexCount @ graph ] ], 1 ] ]

InfraMeasurement[ graph_Graph, InfraTube[ core_, { s : _?NumericQ | Infinity, t : _?NumericQ | Infinity } ], "VertexDensity" ] :=
  AssociationThread[
    Complement[
      Keys @ InfraMeasurement[ graph, InfraTube[ core, t ], "VertexDensity" ],
      If[ s > 0, Keys @ InfraMeasurement[ graph, InfraTube[ core, Ceiling[ s ] - 1 ], "VertexDensity" ], { } ] ],
    1 ]

InfraMeasurement[ graph_Graph, InfraTube[ core_, profile_ ], "VertexDensity" ] :=
  InfraMeasurement[ graph, InfraTube[ core, profile, Method -> "Balls" ], "VertexDensity" ]

(* "Sliced" reads the profile at the nearest axis vertex, the discrete foot of the perpendicular, a tie lying in every nearest slice.  Past each
   end of an open axis the neighbours v of the end with d(v, a_k) == k along the axis prolong it as a geodesic, and a v nearer a prolongation
   than the axis is cut off, which makes the ends flat.  The prolongation goes straight on: the end a_1 is the only common neighbour of v and
   a_2, so no sideways turn of an l^1 geodesic counts.  Both methods are one pass over the distance rows of the axis *)

InfraMeasurement[ graph_Graph, InfraTube[ core_, profile_, Method -> method : "Balls" | "Sliced" ], "VertexDensity" ] /;
    method === "Balls" || VertexQ[ graph, core ] || ListQ @ core || GraphQ @ core && PathGraphQ @ core :=
  With[
    { n = VertexCount @ graph,
      walk = Which[
        VertexQ[ graph, core ], { core },
        ListQ @ core, core,
        GraphQ @ core && PathGraphQ @ core && AllTrue[ VertexList @ core, MatchQ[ { _Integer, _ } ] ] &&
          Sort[ First /@ VertexList @ core ] === Range @ VertexCount @ core,
          Last /@ SortBy[ VertexList @ core, First ],
        GraphQ @ core && PathGraphQ @ core, If[ AcyclicGraphQ @ core, #, Append[ #, First @ # ] ] & @ FindHamiltonianPath @ core,
        MatchQ[ core, _Association | _Graph ], Keys @ InfraDensity[ graph, core ],
        True, Keys @ InfraMeasurement[ graph, core, "VertexDensity" ] ] },
    { cyclic = Length @ walk > 1 && First @ walk === Last @ walk },
    { axis = If[ cyclic, Most @ walk, walk ] },
    { m = Length @ axis, dm = Clip[ GraphDistanceMatrix @ graph, { 0, n + 1 } ] },
    { rows = dm[[ VertexIndex[ graph, # ] & /@ axis ]],
      bands = Replace[
        Which[
          MatchQ[ profile, _?NumericQ | Infinity | { _?NumericQ | Infinity, _?NumericQ | Infinity } ], ConstantArray[ profile, m ],
          ListQ @ profile, profile,
          True, profile /@ Range @ m ],
        r : Except[ _List ] :> { 0, r }, { 1 } ] },
    { ends = If[ method === "Balls" || cyclic || m < 2, { },
        Join[
          Select[ AdjacencyList[ graph, First @ axis ], v |->
            rows[[ All, VertexIndex[ graph, v ] ]] == Range @ m &&
              Intersection[ AdjacencyList[ graph, v ], AdjacencyList[ graph, axis[[ 2 ]] ] ] === { First @ axis } ],
          Select[ AdjacencyList[ graph, Last @ axis ], v |->
            Reverse @ rows[[ All, VertexIndex[ graph, v ] ]] == Range @ m &&
              Intersection[ AdjacencyList[ graph, v ], AdjacencyList[ graph, axis[[ -2 ]] ] ] === { Last @ axis } ] ] ] },
    { near = Min /@ Transpose @ Join[ rows, dm[[ VertexIndex[ graph, # ] & /@ ends ]] ] },
    If[ m == 0, <| |>,
      AssociationThread[
        Sort @ Pick[ VertexList @ graph,
          If[ method === "Balls",
            Sign[ Total @ MapThread[ { row, band } |-> UnitStep[ Min[ Last @ band, n ] - row ], { rows, bands } ] ] *
              Times @@ MapThread[ { row, band } |-> UnitStep[ row - First @ band ], { rows, bands } ],
            Sign @ Total @ MapThread[
              { row, band } |-> ( 1 - Unitize[ row - near ] ) UnitStep[ row - First @ band ] UnitStep[ Min[ Last @ band, n ] - row ],
              { rows, bands } ] ],
          1 ],
        1 ] ] ]

InfraMeasurement[ graph_Graph, tube : InfraTube[ _, _ ] | InfraTube[ _, _, Method -> ( "Balls" | "Sliced" ) ], "EdgeDensity" ] :=
  AssociationThread[ EdgeList @ Subgraph[ graph, Keys @ InfraMeasurement[ graph, tube, "VertexDensity" ] ], 1 ]

InfraMeasurement[ _Graph, InfraTube[ _, _, ___Rule ], "Cardinality" ] :=
  1

InfraMeasurement[ _Graph, InfraTube[ _, _, ___Rule ], "Faithful" ] :=
  True

InfraMeasurement[ graph_Graph, tube : InfraTube[ _, _ ] | InfraTube[ _, _, Method -> ( "Balls" | "Sliced" ) ], All ] :=
  InfraMeasurement[ graph, tube,
    { "Faithful", "Cardinality", "VertexDensity", "EdgeDensity", "Subgraph",
      "CountingMeasure", "RiemannianMeasure" } ]

RandomInfraTube[ graph_Graph, tube : InfraTube[ _, _ ] | InfraTube[ _, _, Method -> ( "Balls" | "Sliced" ) ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /; SubsetQ[ { "NextVertexFunction" }, First /@ { opts } ] &&
    ( OptionValue[ RandomInfraTube, { opts }, "NextVertexFunction" ] =!= RandomChoice || count =!= All ) :=
  With[ { members = Keys @ InfraMeasurement[ graph, tube, "VertexDensity" ],
          nextFn = OptionValue[ RandomInfraTube, { opts }, "NextVertexFunction" ] },
    { ordered = { members } },
    Which[
      count === Automatic, members,
      count === All,       { members },
      nextFn === Identity, If[ IntegerQ @ count && Length @ ordered < count, { }, Take[ ordered, count ] ],
      IntegerQ @ count && Length @ ordered < count, { },
      True, RandomSample[ ordered, count ] ] ]

InfraMemberQ[ graph_Graph, tube : InfraTube[ _, _ ] | InfraTube[ _, _, Method -> ( "Balls" | "Sliced" ) ], vs_List ] :=
  Union @ vs === Keys @ InfraMeasurement[ graph, tube, "VertexDensity" ]

(* the named solids are sliced profiles of the tube, flat at the ends: the cylinder a constant radius or band, the cone the radius
   slope (i - 1) with its apex at the first axis vertex, the solid of revolution any profile *)

InfraMeasurement[ graph_Graph, ( head : InfraCylinder | InfraCone | InfraSolidOfRevolution )[ axis_, profile_, opts___Rule ], prop_ ] :=
  InfraMeasurement[ graph,
    InfraTube[ axis, If[ head === InfraCone, i |-> profile ( i - 1 ), profile ], Method -> Lookup[ { opts }, Method, "Sliced" ] ],
    prop ]


InfraMemberQ[ graph_Graph, ( head : InfraCylinder | InfraCone | InfraSolidOfRevolution )[ axis_, profile_, opts___Rule ], vs_List ] :=
  InfraMemberQ[ graph,
    InfraTube[ axis, If[ head === InfraCone, i |-> profile ( i - 1 ), profile ], Method -> Lookup[ { opts }, Method, "Sliced" ] ],
    vs ]

Options[ RandomInfraCylinder ] = { Method -> "Sliced", "NextVertexFunction" -> Automatic }

RandomInfraCylinder[ graph_Graph, InfraCylinder[ axis_, profile_, geometryOpts___Rule ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic,
    opts : OptionsPattern[] ] /;
    SubsetQ[ { Method }, First /@ { geometryOpts } ] &&
    SubsetQ[ First /@ Options[ RandomInfraCylinder ], First /@ { opts } ] :=
  RandomInfraTube[ graph,
    InfraTube[ axis, profile, Method -> Lookup[ { opts, geometryOpts }, Method, "Sliced" ] ], count,
    "NextVertexFunction" -> OptionValue[ RandomInfraCylinder, { opts }, "NextVertexFunction" ] ]

RandomInfraCylinder[ graph_Graph, axis_, profile_,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic,
    opts : OptionsPattern[] ] /; ! MatchQ[ axis, _InfraCylinder ] &&
    SubsetQ[ First /@ Options[ RandomInfraCylinder ], First /@ { opts } ] :=
  RandomInfraCylinder[ graph, InfraCylinder[ axis, profile, Method -> OptionValue[ Method ] ], count,
    "NextVertexFunction" -> OptionValue[ "NextVertexFunction" ] ]

Options[ RandomInfraCone ] = { Method -> "Sliced", "NextVertexFunction" -> Automatic }

RandomInfraCone[ graph_Graph, InfraCone[ axis_, profile_, geometryOpts___Rule ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic,
    opts : OptionsPattern[] ] /;
    SubsetQ[ { Method }, First /@ { geometryOpts } ] &&
    SubsetQ[ First /@ Options[ RandomInfraCone ], First /@ { opts } ] :=
  RandomInfraTube[ graph,
    InfraTube[ axis, i |-> profile ( i - 1 ), Method -> Lookup[ { opts, geometryOpts }, Method, "Sliced" ] ], count,
    "NextVertexFunction" -> OptionValue[ RandomInfraCone, { opts }, "NextVertexFunction" ] ]

RandomInfraCone[ graph_Graph, axis_, profile_,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic,
    opts : OptionsPattern[] ] /; ! MatchQ[ axis, _InfraCone ] &&
    SubsetQ[ First /@ Options[ RandomInfraCone ], First /@ { opts } ] :=
  RandomInfraCone[ graph, InfraCone[ axis, profile, Method -> OptionValue[ Method ] ], count,
    "NextVertexFunction" -> OptionValue[ "NextVertexFunction" ] ]

Options[ RandomInfraSolidOfRevolution ] = { Method -> "Sliced", "NextVertexFunction" -> Automatic }

RandomInfraSolidOfRevolution[ graph_Graph, InfraSolidOfRevolution[ axis_, profile_, geometryOpts___Rule ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic,
    opts : OptionsPattern[] ] /;
    SubsetQ[ { Method }, First /@ { geometryOpts } ] &&
    SubsetQ[ First /@ Options[ RandomInfraSolidOfRevolution ], First /@ { opts } ] :=
  RandomInfraTube[ graph,
    InfraTube[ axis, profile, Method -> Lookup[ { opts, geometryOpts }, Method, "Sliced" ] ], count,
    "NextVertexFunction" -> OptionValue[ RandomInfraSolidOfRevolution, { opts }, "NextVertexFunction" ] ]

RandomInfraSolidOfRevolution[ graph_Graph, axis_, profile_,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic,
    opts : OptionsPattern[] ] /; ! MatchQ[ axis, _InfraSolidOfRevolution ] &&
    SubsetQ[ First /@ Options[ RandomInfraSolidOfRevolution ], First /@ { opts } ] :=
  RandomInfraSolidOfRevolution[ graph, InfraSolidOfRevolution[ axis, profile, Method -> OptionValue[ Method ] ], count,
    "NextVertexFunction" -> OptionValue[ "NextVertexFunction" ] ]

RandomInfraTube[ graph_Graph, core_, profile_,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic,
    opts : OptionsPattern[] ] /; ! MatchQ[ First @ { core, profile }, _InfraTube ] &&
    SubsetQ[ First /@ Options[ RandomInfraTube ], First /@ { opts } ] :=
  RandomInfraTube[ graph, InfraTube[ core, profile, Method -> OptionValue[ Method ] ], count,
    "NextVertexFunction" -> OptionValue[ "NextVertexFunction" ] ]
