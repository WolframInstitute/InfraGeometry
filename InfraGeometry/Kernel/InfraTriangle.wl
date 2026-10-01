Package["WolframInstitute`InfraGeometry`"]

FindInfraTriangle::badmethod = "Method `1` is not supported by FindInfraTriangle.";

Options[ FindInfraTriangle ] = { Method -> Automatic };

FindInfraTriangle[ graph_Graph, vertices_List /; Length[ vertices ] === 3,
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] :=
  With[ { methodSpec = Replace[ OptionValue[ FindInfraTriangle, { opts }, Method ], Automatic :> If[ count === All, "Exhaustive", "Greedy" ] ] },
    If[ ! MatchQ[ Replace[ methodSpec, { m_String, ___ } :> m ], "Exhaustive" | "Greedy" | "RandomGreedy" ],
      Message[ FindInfraTriangle::badmethod, methodSpec ]; $Failed,
      FindInfraPolygon[ graph, vertices, count, Method -> methodSpec ] ] ]

InfraTriangleQ[ graph_Graph, polys : { { __Graph } .. } ] :=
  AllTrue[ polys, InfraTriangleQ[ graph, # ] & ]

InfraTriangleQ[ graph_Graph, sides : { _Graph, _Graph, _Graph } ] :=
  InfraPolygonQ[ graph, sides ]

InfraTriangleQ[ _Graph, _ ] := False

dispatchConstruction[ graph_Graph, InfraTriangle[ verts_List, opts___Rule ] ] :=
  capBranches[
    polylineToVertexSeq /@ FindInfraTriangle[ graph, verts, All,
      Sequence @@ FilterRules[ { opts }, Options[ FindInfraTriangle ] ] ],
    extractBranches[ { opts } ] ]
