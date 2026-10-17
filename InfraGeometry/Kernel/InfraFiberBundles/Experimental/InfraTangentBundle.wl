Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: InfraFiberBundles :: Experimental :: InfraTangentBundle *)

(* The ideas are InfraGaugeTheory's (Kernel/TangentBundle.wl, CotangentBundle.wl at e5dc83b, whose germ bundles InfraGaugeTheory keeps);
   the ray and displacement bundles are new here *)

InfraRays[ g_Graph, p_, r_Integer?NonNegative ] :=
  With[ { dist = AssociationThread[ VertexList @ g, GraphDistance[ g, p ] ] },
    Nest[
      rays |-> Catenate[ ( w |-> Append[ w, # ] & /@ Select[ AdjacencyList[ g, Last @ w ], Lookup[ dist, Key @ # ] == Length @ w & ] ) /@ rays ],
      { { p } },
      r ] ]

(* The vertexwise rule: two tuples of base vertices are adjacent iff at every position their entries are equal or adjacent,
   so the adjacency matrix is the product over positions of the sparse closeness matrix restricted to the tuples *)

InfraTotalGraph[ InfraTangentBundle[ g_Graph, r_Integer?Positive ] ] :=
  With[ { rays = Catenate[ InfraRays[ g, #, r ] & /@ VertexList @ g ] },
    If[ rays === { }, Graph[ { }, { } ], With[
      { close = AdjacencyMatrix @ g + IdentityMatrix[ VertexCount @ g, SparseArray ], indices = Map[ VertexIndex[ g, # ] &, rays, { 2 } ] },
      { adjacency = UpperTriangularize[ Times @@ ( close[[ #, # ]] & /@ Transpose @ indices ), 1 ] },
      Graph[ rays, UndirectedEdge @@@ Map[ rays[[ # ]] &, Sort @ adjacency[ "NonzeroPositions" ], { 2 } ] ] ] ] ]

InfraTotalGraph[ InfraCotangentBundle[ g_Graph, r_Integer?Positive ] ] :=
  With[ { tangent = InfraTotalGraph @ InfraTangentBundle[ g, r ] },
    Graph[ Reverse /@ VertexList @ tangent, Map[ Reverse, EdgeList @ tangent, { 2 } ] ] ]

InfraTotalGraph[ InfraDisplacementBundle[ g_Graph, r_Integer?Positive ] ] :=
  With[ { indices = If[ VertexCount @ g === 0, { }, Position[ GraphDistanceMatrix @ g, r, { 2 } ] ] },
    If[ indices === { }, Graph[ { }, { } ], With[
      { close = AdjacencyMatrix @ g + IdentityMatrix[ VertexCount @ g, SparseArray ], pairs = Part[ VertexList @ g, # ] & /@ indices },
      { adjacency = UpperTriangularize[ close[[ First /@ indices, First /@ indices ]] close[[ Last /@ indices, Last /@ indices ]], 1 ] },
      Graph[ pairs, UndirectedEdge @@@ Map[ pairs[[ # ]] &, Sort @ adjacency[ "NonzeroPositions" ], { 2 } ] ] ] ] ]

InfraFibrationAssociation[ InfraTangentBundle[ g_Graph, r_Integer?Positive ] ] :=
  AssociationMap[ First, Catenate[ InfraRays[ g, #, r ] & /@ VertexList @ g ] ]

(* A covector at p is a ray arriving at p, the reversal of a ray leaving p *)

InfraFibrationAssociation[ InfraCotangentBundle[ g_Graph, r_Integer?Positive ] ] :=
  AssociationMap[ Last, Reverse /@ Catenate[ InfraRays[ g, #, r ] & /@ VertexList @ g ] ]

InfraFibrationAssociation[ InfraDisplacementBundle[ g_Graph, r_Integer?Positive ] ] :=
  AssociationMap[ First, Part[ VertexList @ g, # ] & /@ If[ VertexCount @ g === 0, { }, Position[ GraphDistanceMatrix @ g, r, { 2 } ] ] ]

InfraFibration[ fib : ( _InfraTangentBundle | _InfraCotangentBundle | _InfraDisplacementBundle ) ] :=
  InfraFibration[ InfraTotalGraph @ fib, InfraFibrationAssociation @ fib ]

(* Materialize a model's total graph once before applying the structural predicates. *)

InfraFibrationQ[ fib : ( InfraTangentBundle[ _Graph, _Integer?Positive ] |
    InfraCotangentBundle[ _Graph, _Integer?Positive ] | InfraDisplacementBundle[ _Graph, _Integer?Positive ] ) ] :=
  InfraFibrationQ[ InfraFibration[ fib ] ]

InfraFiberBundleQ[ fib : ( InfraTangentBundle[ _Graph, _Integer?Positive ] |
    InfraCotangentBundle[ _Graph, _Integer?Positive ] | InfraDisplacementBundle[ _Graph, _Integer?Positive ] ) ] :=
  InfraFiberBundleQ[ InfraFibration[ fib ] ]

InfraBundleMorphism[ InfraTangentBundle[ g_Graph, r_Integer ], InfraDisplacementBundle[ h_Graph, r_Integer ] ] /;
    Sort @ VertexList @ g === Sort @ VertexList @ h && Sort[ Sort /@ EdgeList @ g ] === Sort[ Sort /@ EdgeList @ h ] :=
  ray |-> { First @ ray, Last @ ray }

InfraBundleMorphism[ InfraTangentBundle[ g_Graph, r_Integer ], InfraTangentBundle[ h_Graph, s_Integer ] ] /;
    0 < s < r && Sort @ VertexList @ g === Sort @ VertexList @ h && Sort[ Sort /@ EdgeList @ g ] === Sort[ Sort /@ EdgeList @ h ] :=
  ray |-> Take[ ray, s + 1 ]

InfraBundleMorphism[ InfraTangentBundle[ g_Graph, r_Integer ], InfraCotangentBundle[ h_Graph, r_Integer ] ] /;
    Sort @ VertexList @ g === Sort @ VertexList @ h && Sort[ Sort /@ EdgeList @ g ] === Sort[ Sort /@ EdgeList @ h ] :=
  Reverse

InfraBundleMorphism[ InfraCotangentBundle[ g_Graph, r_Integer ], InfraTangentBundle[ h_Graph, r_Integer ] ] /;
    Sort @ VertexList @ g === Sort @ VertexList @ h && Sort[ Sort /@ EdgeList @ g ] === Sort[ Sort /@ EdgeList @ h ] :=
  Reverse
