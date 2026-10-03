Package[ "WolframInstitute`InfraGeometry`" ]

Options[ FindInfraTriangle ] = { "NextVertexFunction" -> Identity }

FindInfraTriangle[ graph_Graph, vertices_List /; Length[ vertices ] === 3,
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] :=
  FindInfraPolygon[ graph, vertices, count, "NextVertexFunction" -> OptionValue[ FindInfraTriangle, { opts }, "NextVertexFunction" ] ]

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
