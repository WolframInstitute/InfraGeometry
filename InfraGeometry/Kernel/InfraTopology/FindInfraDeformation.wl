Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: InfraTopology :: FindInfraDeformation *)

Options[ FindInfraDeformation ] = {
  "NullHomotopicCycles" -> { 3, 4 },
  "MaxMoves" -> Infinity,
  "MaxStates" -> 1000,
  Method -> Automatic
}

FindInfraDeformation[ graph_Graph,
    object : InfraDeformation[ reference : { __ }, excessSpec_, objectOptions : OptionsPattern[ InfraDeformation ] ],
    target_List, opts : OptionsPattern[ FindInfraDeformation ] ] /;
    SubsetQ[ Keys @ Options @ FindInfraDeformation, Keys @ { opts } ] &&
      TrueQ[ InfraMemberQ[ graph, object, target ] ] &&
      MatchQ[ OptionValue[ FindInfraDeformation, { opts }, Method ], Automatic | "Exhaustive" ] &&
      MatchQ[ OptionValue[ FindInfraDeformation, { opts }, "MaxMoves" ], Infinity | _Integer?NonNegative ] &&
      MatchQ[ OptionValue[ FindInfraDeformation, { opts }, "MaxStates" ], _Integer?Positive ] :=
  With[ { result = With[
      { radius = OptionValue[ InfraDeformation, { objectOptions }, "TubeRadius" ],
        maximum = Replace[ excessSpec, { { k_ } :> k, { _, high_ } :> high, UpTo[ k_ ] :> k } ],
        faces = OptionValue[ FindInfraDeformation, { opts }, "NullHomotopicCycles" ],
        moveLimit = OptionValue[ FindInfraDeformation, { opts }, "MaxMoves" ],
        stateLimit = OptionValue[ FindInfraDeformation, { opts }, "MaxStates" ],
        method = OptionValue[ FindInfraDeformation, { opts }, Method ] },
      { tube = NeighborhoodGraph[ graph, reference, Min[ radius, VertexCount @ graph ] ],
        validFaces = ListQ[ faces ] && (
          AllTrue[ faces, MatchQ[ #, _Integer?( n |-> n >= 3 ) ] & ] ||
          AllTrue[ faces, face |-> ListQ[ face ] && Length[ face ] >= 3 && DuplicateFreeQ[ face ] &&
            AllTrue[ face, VertexQ[ graph, # ] & ] &&
            AllTrue[ Partition[ face, 2, 1, 1 ], EdgeQ[ graph, UndirectedEdge @@ # ] & ] ] ) },
      If[ validFaces,
        With[ { selectedFaces = If[ AllTrue[ faces, IntegerQ ], faces,
            Select[ faces, face |-> AllTrue[ face, VertexQ[ tube, # ] & ] ] ] },
          { certificate = FindInfraHomotopy[ tube, reference, target,
            "NullHomotopicCycles" -> selectedFaces, "MaxLength" -> Length[ reference ] + maximum,
            "MaxMoves" -> moveLimit, "MaxStates" -> stateLimit, Method -> method ] },
          If[ MatchQ[ certificate, { __Graph } ],
            With[ { chain = ( Last /@ SortBy[ VertexList[ # ], First ] & ) /@ certificate },
              If[ First[ chain ] === reference && Last[ chain ] === target && Length[ chain ] - 1 <= moveLimit &&
                  AllTrue[ chain, walk |-> DuplicateFreeQ[ walk ] &&
                    Length[ walk ] <= Length[ reference ] + maximum &&
                    First[ walk ] === First[ reference ] && Last[ walk ] === Last[ reference ] &&
                    AllTrue[ walk, VertexQ[ tube, # ] & ] &&
                    AllTrue[ Partition[ walk, 2, 1 ], EdgeQ[ tube, UndirectedEdge @@ # ] & ] ],
                chain, None ] ],
            None ] ],
        None ] ] },
    result /; ListQ[ result ] ]
