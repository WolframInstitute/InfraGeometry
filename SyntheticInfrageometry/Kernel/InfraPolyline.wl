Package["WolframInstitute`SyntheticInfrageometry`"]



(* ===================== FindInfraPolylineSubdivision ===================== *)

(* the fewest geodesic legs with knots on the walk, each leg a shortest path of length <= MaxLength.  A polyline is its legs: a List of directed path graphs on the substrate vertices, consecutive legs sharing their knot -- the knots are a fact about the subdivision, not about the walk, so they are kept as the leg ends rather than dissolved into one graph *)

Options[ FindInfraPolylineSubdivision ] = { "MaxLength" -> Infinity };

FindInfraPolylineSubdivision[ _Graph, path_List, OptionsPattern[] ] /; Length[ path ] < 2 :=
  { }

FindInfraPolylineSubdivision[ graph_Graph, path_List, OptionsPattern[] ] :=
  Module[ { maxLength = OptionValue[ "MaxLength" ], n = Length[ path ],
            knots = { 1 }, last = 1, d },
    Do[
      d = GraphDistance[ graph, path[[ last ]], path[[ i ]] ];
      If[ d > maxLength || i - last != d,
        AppendTo[ knots, i - 1 ];
        last = i - 1
      ],
      { i, 2, n } ];
    AppendTo[ knots, n ];
    MapThread[ { a, b } |-> PathGraph[ path[[ a ;; b ]], DirectedEdges -> True ], { Most @ knots, Rest @ knots } ]
  ]


(* ===================== InfraPolylineQ ===================== *)

(* every leg a geodesic in graph, consecutive legs sharing their endpoint *)

InfraPolylineQ[ graph_Graph, polys : { { ___Graph } .. } ] :=
  AllTrue[ polys, InfraPolylineQ[ graph, # ] & ]

InfraPolylineQ[ _Graph, { } ] := True

InfraPolylineQ[ graph_Graph, legs : { __Graph } ] :=
  With[ { seqs = ( w |-> With[ { vs = VertexList @ w },
        If[ AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
          Last /@ SortBy[ vs, First ],
          Reap[ DepthFirstScan[ w,
            SelectFirst[ vs, If[ DirectedGraphQ @ w, VertexInDegree[ w, # ] == 0, VertexDegree[ w, # ] == 1 ] &, First @ vs ],
            { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] ] ] ) /@ legs },
    AllTrue[ seqs, InfraSegmentQ[ graph, # ] & ] &&
    AllTrue[ Partition[ seqs, 2, 1 ], pair |-> Last[ pair[[ 1 ]] ] === First[ pair[[ 2 ]] ] ] ]

InfraPolylineQ[ _Graph, _ ] := False


(* ===================== Scene-DSL constructor ===================== *)

dispatchConstruction[ graph_Graph, InfraPolyline[ path_, opts___Rule ] ] :=
  capBranches[
    { FindInfraPolylineSubdivision[ graph, path,
        Sequence @@ FilterRules[ { opts }, Options[ FindInfraPolylineSubdivision ] ] ] },
    extractBranches[ { opts } ] ]
