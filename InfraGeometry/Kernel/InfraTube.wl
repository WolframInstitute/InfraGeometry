Package[ "WolframInstitute`InfraGeometry`" ]

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
   than the axis is cut off, which makes the ends flat.  Both methods are one pass over the distance rows of the axis *)

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
          Select[ AdjacencyList[ graph, First @ axis ], v |-> rows[[ All, VertexIndex[ graph, v ] ]] == Range @ m ],
          Select[ AdjacencyList[ graph, Last @ axis ], v |-> Reverse @ rows[[ All, VertexIndex[ graph, v ] ]] == Range @ m ] ] ] },
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

InfraMeasurement[ graph_Graph, tube : InfraTube[ _, _, ___Rule ], "EdgeDensity" ] :=
  AssociationThread[ EdgeList @ Subgraph[ graph, Keys @ InfraMeasurement[ graph, tube, "VertexDensity" ] ], 1 ]

InfraMeasurement[ _Graph, InfraTube[ _, _, ___Rule ], "Cardinality" ] :=
  1

InfraMeasurement[ _Graph, InfraTube[ _, _, ___Rule ], "Faithful" ] :=
  True

InfraMeasurement[ graph_Graph, tube : InfraTube[ _, _, ___Rule ], All ] :=
  InfraMeasurement[ graph, tube,
    { "Faithful", "Cardinality", "VertexDensity", "EdgeDensity", "Subgraph",
      "CountingMeasure", "RiemannianMeasure" } ]

FindInfraRepresentative[ graph_Graph, tube : InfraTube[ _, _, ___Rule ],
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, mods___ ] :=
  takeRepresentatives[ { Keys @ InfraMeasurement[ graph, tube, "VertexDensity" ] }, count, mods ]

InfraMemberQ[ graph_Graph, tube : InfraTube[ _, _, ___Rule ], vs_List ] :=
  Union @ vs === Keys @ InfraMeasurement[ graph, tube, "VertexDensity" ]

(* the named solids are sliced profiles of the tube, flat at the ends: the cylinder a constant radius or band, the cone the radius
   slope (i - 1) with its apex at the first axis vertex, the solid of revolution any profile *)

InfraMeasurement[ graph_Graph, ( head : InfraCylinder | InfraCone | InfraSolidOfRevolution )[ axis_, profile_, opts___Rule ], prop_ ] :=
  InfraMeasurement[ graph,
    InfraTube[ axis, If[ head === InfraCone, i |-> profile ( i - 1 ), profile ], Method -> Lookup[ { opts }, Method, "Sliced" ] ],
    prop ]

FindInfraRepresentative[ graph_Graph, ( head : InfraCylinder | InfraCone | InfraSolidOfRevolution )[ axis_, profile_, opts___Rule ],
    args___ ] :=
  FindInfraRepresentative[ graph,
    InfraTube[ axis, If[ head === InfraCone, i |-> profile ( i - 1 ), profile ], Method -> Lookup[ { opts }, Method, "Sliced" ] ],
    args ]

InfraMemberQ[ graph_Graph, ( head : InfraCylinder | InfraCone | InfraSolidOfRevolution )[ axis_, profile_, opts___Rule ], vs_List ] :=
  InfraMemberQ[ graph,
    InfraTube[ axis, If[ head === InfraCone, i |-> profile ( i - 1 ), profile ], Method -> Lookup[ { opts }, Method, "Sliced" ] ],
    vs ]
