Package[ "WolframInstitute`InfraGeometry`" ]

(* the fewest geodesic legs with knots on the walk, each leg a shortest path of length <= MaxLength.  A polyline is its legs: a List of directed path
   graphs on the substrate vertices, consecutive legs sharing their knot -- the knots are a fact about the subdivision, not about the walk, so they
   are kept as the leg ends rather than dissolved into one graph *)

Options[ FindInfraPolylineSubdivision ] = { "MaxLength" -> Infinity }

FindInfraPolylineSubdivision[ _Graph, path_List, OptionsPattern[] ] /; Length[ path ] < 2 :=
  { }

FindInfraPolylineSubdivision[ graph_Graph, path_List, OptionsPattern[] ] :=
  With[ { maxLength = OptionValue[ "MaxLength" ], n = Length[ path ] },
    { knots = Append[
        First @ Fold[
          { state, i } |-> With[ { d = GraphDistance[ graph, path[[ Last @ state ]], path[[ i ]] ] },
            If[ d > maxLength || i - Last @ state != d, { Append[ First @ state, i - 1 ], i - 1 }, state ] ],
          { { 1 }, 1 },
          Range[ 2, n ] ],
        n ] },
    MapThread[ { a, b } |-> PathGraph[ path[[ a ;; b ]], DirectedEdges -> True ], { Most @ knots, Rest @ knots } ] ]

InfraPolylineQ[ graph_Graph, polys : { { ___Graph } .. } ] :=
  AllTrue[ polys, InfraPolylineQ[ graph, # ] & ]

InfraPolylineQ[ _Graph, { } ] :=
  True

InfraPolylineQ[ graph_Graph, legs : { __Graph } ] :=
  With[ { seqs = ( w |-> With[ { vs = VertexList @ w },
        If[ AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
          Last /@ SortBy[ vs, First ],
          Reap[ DepthFirstScan[ w,
            SelectFirst[ vs, If[ DirectedGraphQ @ w, VertexInDegree[ w, # ] == 0, VertexDegree[ w, # ] == 1 ] &, First @ vs ],
            { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] ] ] ) /@ legs },
    AllTrue[ seqs, InfraSegmentQ[ graph, # ] & ] &&
    AllTrue[ Partition[ seqs, 2, 1 ], pair |-> Last[ pair[[ 1 ]] ] === First[ pair[[ 2 ]] ] ] ]

InfraPolylineQ[ _Graph, _ ] :=
  False

dispatchConstruction[ graph_Graph, InfraPolyline[ path_, opts___Rule ] ] :=
  capBranches[
    { FindInfraPolylineSubdivision[ graph, path,
        Sequence @@ FilterRules[ { opts }, Options[ FindInfraPolylineSubdivision ] ] ] },
    extractBranches[ { opts } ] ]
