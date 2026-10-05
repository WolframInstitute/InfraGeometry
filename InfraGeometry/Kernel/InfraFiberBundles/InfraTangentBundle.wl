Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: InfraFiberBundles :: InfraTangentBundle *)

(* The ideas are InfraGaugeTheory's (Kernel/TangentBundle.wl, CotangentBundle.wl at e5dc83b, whose germ bundles InfraGaugeTheory keeps);
   the ray and displacement bundles are new here *)

InfraRays[ g_Graph, p_, r_Integer?NonNegative ] :=
  With[ { dist = AssociationThread[ VertexList @ g, GraphDistance[ g, p ] ] },
    Nest[
      rays |-> Catenate[ ( w |-> Append[ w, # ] & /@ Select[ AdjacencyList[ g, Last @ w ], dist[ # ] == Length @ w & ] ) /@ rays ],
      { { p } },
      r ] ]

(* The vertexwise rule: two tuples of base vertices are adjacent iff at every position their entries are equal or adjacent,
   so the adjacency matrix is the product over positions of the closeness matrix restricted to the tuples.
   Each total vertex is drawn at its base point, displaced towards the rest of its tuple *)

InfraTotalGraph[ InfraTangentBundle[ g_Graph, r_Integer?Positive ] ] :=
  With[ { rays = Catenate[ InfraRays[ g, #, r ] & /@ VertexList @ g ], close = AdjacencyMatrix @ g + IdentityMatrix[ VertexCount @ g, SparseArray ] },
    { indices = Map[ VertexIndex[ g, # ] &, rays, { 2 } ], coordinates = GraphEmbedding @ g },
    { adjacency = UpperTriangularize[ Times @@ ( close[[ #, # ]] & /@ Transpose @ indices ), 1 ] },
    (* weights 2^i make the offsets of distinct rays on a lattice distinct *)
    { offsets = ( ray |-> ( 2 ^ Range @ r ) . ( # - First @ ray & /@ Rest @ ray ) ) /@ ( coordinates[[ # ]] & /@ indices ) },
    { scale = Min[ EuclideanDistance @@ coordinates[[ List @@ # ]] & /@ EdgeList @ IndexGraph @ g ] / 3 },
    Graph[ rays, UndirectedEdge @@@ Map[ rays[[ # ]] &, Sort @ adjacency[ "NonzeroPositions" ], { 2 } ],
      VertexCoordinates -> coordinates[[ First /@ indices ]] + scale offsets / Max[ Norm /@ offsets ] ] ]

InfraTotalGraph[ InfraCotangentBundle[ g_Graph, r_Integer?Positive ] ] :=
  With[ { tangent = InfraTotalGraph @ InfraTangentBundle[ g, r ] },
    Graph[ Reverse /@ VertexList @ tangent, Map[ Reverse, EdgeList @ tangent, { 2 } ], VertexCoordinates -> GraphEmbedding @ tangent ] ]

InfraTotalGraph[ InfraDisplacementBundle[ g_Graph, r_Integer?Positive ] ] :=
  With[ { indices = Position[ GraphDistanceMatrix @ g, r, { 2 } ], close = AdjacencyMatrix @ g + IdentityMatrix[ VertexCount @ g, SparseArray ] },
    { pairs = Part[ VertexList @ g, # ] & /@ indices, coordinates = GraphEmbedding @ g },
    { adjacency = UpperTriangularize[ close[[ First /@ indices, First /@ indices ]] close[[ Last /@ indices, Last /@ indices ]], 1 ] },
    { offsets = coordinates[[ Last @ # ]] - coordinates[[ First @ # ]] & /@ indices },
    { scale = Min[ EuclideanDistance @@ coordinates[[ List @@ # ]] & /@ EdgeList @ IndexGraph @ g ] / 3 },
    Graph[ pairs, UndirectedEdge @@@ Map[ pairs[[ # ]] &, Sort @ adjacency[ "NonzeroPositions" ], { 2 } ],
      VertexCoordinates -> coordinates[[ First /@ indices ]] + scale offsets / Max[ Norm /@ offsets ] ] ]

InfraFibrationAssociation[ InfraTangentBundle[ g_Graph, r_Integer?Positive ] ] :=
  AssociationMap[ First, Catenate[ InfraRays[ g, #, r ] & /@ VertexList @ g ] ]

(* A covector at p is a ray arriving at p, the reversal of a ray leaving p *)

InfraFibrationAssociation[ InfraCotangentBundle[ g_Graph, r_Integer?Positive ] ] :=
  AssociationMap[ Last, Reverse /@ Catenate[ InfraRays[ g, #, r ] & /@ VertexList @ g ] ]

InfraFibrationAssociation[ InfraDisplacementBundle[ g_Graph, r_Integer?Positive ] ] :=
  AssociationMap[ First, Part[ VertexList @ g, # ] & /@ Position[ GraphDistanceMatrix @ g, r, { 2 } ] ]

InfraFibration[ fib : ( _InfraTangentBundle | _InfraCotangentBundle | _InfraDisplacementBundle ) ] :=
  InfraFibration[ InfraTotalGraph @ fib, InfraFibrationAssociation @ fib ]

InfraBundleMorphism[ InfraTangentBundle[ g_Graph, r_Integer ], InfraDisplacementBundle[ h_Graph, r_Integer ] ] /; sameBaseQ[ g, h ] :=
  ray |-> { First @ ray, Last @ ray }

InfraBundleMorphism[ InfraTangentBundle[ g_Graph, r_Integer ], InfraTangentBundle[ h_Graph, s_Integer ] ] /; 0 < s < r && sameBaseQ[ g, h ] :=
  ray |-> Take[ ray, s + 1 ]

InfraBundleMorphism[ InfraTangentBundle[ g_Graph, r_Integer ], InfraCotangentBundle[ h_Graph, r_Integer ] ] /; sameBaseQ[ g, h ] :=
  Reverse

InfraBundleMorphism[ InfraCotangentBundle[ g_Graph, r_Integer ], InfraTangentBundle[ h_Graph, r_Integer ] ] /; sameBaseQ[ g, h ] :=
  Reverse

sameBaseQ[ g_Graph, h_Graph ] :=
  Sort @ VertexList @ g === Sort @ VertexList @ h && Sort[ Sort /@ EdgeList @ g ] === Sort[ Sort /@ EdgeList @ h ]
