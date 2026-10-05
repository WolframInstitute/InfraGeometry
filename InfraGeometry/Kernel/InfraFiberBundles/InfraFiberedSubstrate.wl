Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: InfraFiberBundles :: InfraFiberedSubstrate *)

InfraFiberedSubstrate[ ] :=
  <|
    "Trivial" -> { "CycleProductBundle", "GridProductBundle" },
    "Covering" -> { "CycleDoubleCover", "MoebiusLadderCover", "TriangularTorusDoubleCover" },
    "Tangent" -> { "GridTangentBundle", "TriangularTorusTangentBundle", "OctahedronTangentBundle", "SphereMeshTangentBundle" },
    "Displacement" -> { "GridDisplacementBundle", "TriangularTorusDisplacementBundle", "OctahedronDisplacementBundle", "SphereMeshDisplacementBundle" },
    "NonBundle" -> { "BranchedCycleFibration", "BranchedGridFibration" }
  |>

InfraFiberedSubstrate[ All ] :=
  Catenate @ Values @ InfraFiberedSubstrate[ ]

InfraFiberedSubstrate[ name_String /; MemberQ[ InfraFiberedSubstrate[ All ], name ] ] :=
  InfraFiberedSubstrate[ name, "Medium" ]

InfraFiberedSubstrate[ name_String /; MemberQ[ InfraFiberedSubstrate[ All ], name ], size_ ] :=
  With[
    { spec = Switch[ name,
        _?( StringEndsQ[ #, "TangentBundle" | "DisplacementBundle" ] & ), With[
          { base = Switch[ StringDelete[ name, "TangentBundle" | "DisplacementBundle" ],
              "Grid", GridGraph[ size /. { "Small" -> { 4, 4 }, "Medium" -> { 8, 8 }, "Large" -> { 16, 16 } } ],
              "TriangularTorus", InfraSubstrate[ "TriangularTorusGraph", size /. { "Small" -> { 6, 6 }, "Medium" -> { 10, 10 }, "Large" -> { 20, 15 } }, "KeepCoordinates" -> True ],
              "Octahedron", EdgeDelete[ CompleteGraph[ 6 ], { 1 <-> 4, 2 <-> 5, 3 <-> 6 } ],
              "SphereMesh", InfraSubstrate[ "SphereMeshGraph", size, "KeepCoordinates" -> True ] ] },
          If[ StringEndsQ[ name, "TangentBundle" ], InfraTangentBundle[ base, 2 ], InfraDisplacementBundle[ base, 1 ] ] ],
        (* two sheets over a cycle: the rungs make the fiber an edge, and the lift of the edge n <-> 1 swaps the sheets on a cover *)
        "CycleProductBundle" | "CycleDoubleCover" | "MoebiusLadderCover", With[
          { n = size /. { "Small" -> 8, "Medium" -> 16, "Large" -> 32 } },
          { CycleGraph @ n, Join[
              If[ name === "CycleDoubleCover", { }, UndirectedEdge[ { #, 1 }, { #, 2 } ] & /@ Range @ n ],
              Catenate @ Table[
                UndirectedEdge[ { i, sheet }, { Mod[ i + 1, n, 1 ], If[ i == n && name =!= "CycleProductBundle", 3 - sheet, sheet ] } ],
                { i, n }, { sheet, 2 } ] ] } ],
        "GridProductBundle", With[
          { base = GridGraph[ size /. { "Small" -> { 4, 4 }, "Medium" -> { 8, 8 }, "Large" -> { 16, 16 } } ] },
          { base, Join[
              Catenate @ Map[ p |-> UndirectedEdge @@@ { { { p, 1 }, { p, 2 } }, { { p, 2 }, { p, 3 } }, { { p, 3 }, { p, 1 } } }, VertexList @ base ],
              Catenate @ Table[ UndirectedEdge[ { First @ edge, k }, { Last @ edge, k } ], { edge, EdgeList @ base }, { k, 3 } ] ] } ],
        (* the m x n torus is covered twice by the 2m x n torus, column i over column Mod[i, m] *)
        "TriangularTorusDoubleCover", With[
          { dims = size /. { "Small" -> { 6, 6 }, "Medium" -> { 10, 10 }, "Large" -> { 20, 15 } } },
          { m = First @ dims },
          { InfraSubstrate[ "TriangularTorusGraph", dims, "KeepCoordinates" -> True ],
            Map[ v |-> { { Mod[ First @ v, m ], Last @ v }, Quotient[ First @ v, m ] + 1 },
              EdgeList @ TorusTessellation[ { 2 m, Last @ dims }, "Triangular" ], { 2 } ] } ],
        (* one vertex over one colour class of the base, an edge over the other, adjacent fibers joined completely *)
        "BranchedCycleFibration" | "BranchedGridFibration", With[
          { base = If[ name === "BranchedCycleFibration",
              CycleGraph[ size /. { "Small" -> 8, "Medium" -> 16, "Large" -> 32 } ],
              GridGraph[ size /. { "Small" -> { 4, 4 }, "Medium" -> { 8, 8 }, "Large" -> { 16, 16 } } ] ] },
          { fibers = AssociationThread[ VertexList @ base,
              MapThread[ { p, d } |-> Table[ { p, k }, { k, 1 + Mod[ d, 2 ] } ], { VertexList @ base, GraphDistance[ base, First @ VertexList @ base ] } ] ] },
          { base, Join[
              UndirectedEdge @@@ Select[ Values @ fibers, Length @ # == 2 & ],
              Catenate @ Map[ edge |-> UndirectedEdge @@@ Tuples[ { fibers @ First @ edge, fibers @ Last @ edge } ], EdgeList @ base ] ] } ] ] },
    (* each fiber sits on a small circle around its base vertex, its first vertex pointing away from the centre of the base *)
    Replace[ spec, { base_Graph, edges_List } :> With[
      { vertices = VertexList @ Graph @ edges, coordinates = AssociationThread[ VertexList @ base, GraphEmbedding @ base ] },
      { centre = Mean @ Values @ coordinates, scale = Min[ EuclideanDistance @@ ( coordinates /@ List @@ # ) & /@ EdgeList @ base ] / 3 },
      InfraFibration[
        Graph[ vertices, edges,
          VertexCoordinates -> Catenate @ KeyValueMap[
            { p, fiber } |-> Thread[ fiber -> ( coordinates[ p ] + scale PadRight[ #, Length @ centre ] & /@ If[ Length @ fiber == 1, { { 0, 0 } },
              CirclePoints[ { 1, Arg[ Complex @@ Take[ coordinates[ p ] - centre, 2 ] ] }, Length @ fiber ] ] ) ],
            GroupBy[ vertices, First ] ] ],
        AssociationMap[ First, vertices ] ] ] ] ]
