Package[ "WolframInstitute`InfraGeometry`" ]

Options[ FindInfraTriangle ] = { Method -> Automatic }

FindInfraTriangle[ graph_Graph, vertices_List /; Length[ vertices ] === 3,
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    MatchQ[ OptionValue[ FindInfraTriangle, { opts }, Method ], Automatic | "Exhaustive" | "Greedy" | "RandomGreedy" | { "Exhaustive", ___ } ] :=
  FindInfraPolygon[ graph, vertices, count,
    Method -> Replace[ OptionValue[ FindInfraTriangle, { opts }, Method ], Automatic :> If[ count === All, "Exhaustive", "Greedy" ] ] ]

InfraTriangleQ[ graph_Graph, polys : { { __Graph } .. } ] :=
  AllTrue[ polys, InfraTriangleQ[ graph, # ] & ]

InfraTriangleQ[ graph_Graph, sides : { _Graph, _Graph, _Graph } ] :=
  InfraPolygonQ[ graph, sides ]

InfraTriangleQ[ _Graph, _ ] :=
  False

FindInfraRepresentative[ graph_Graph, InfraTriangle[ verts_List, opts___Rule ],
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, mods___ ] :=
  Replace[
    FindInfraTriangle[ graph, verts, count,
      Sequence @@ searchMethod[ mods ], Sequence @@ FilterRules[ { opts }, Options[ FindInfraTriangle ] ] ],
    { legs : { __Graph } :> polylineToVertexSeq @ legs, triangles_List :> polylineToVertexSeq /@ triangles } ]
