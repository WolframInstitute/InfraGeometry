Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: Experimental :: InfraPolyline *)

(* the fewest geodesic legs with knots on the walk, each leg a shortest path of length <= MaxLength: a List of directed path graphs on the
   substrate vertices, consecutive legs sharing their knot, so the walk is a member of the polyline InfraSegment[k1, ..., km] on its knots -- the
   knots are a fact about the subdivision, not about the walk, so they are kept as the leg ends rather than dissolved into one graph *)

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
