Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: InfraFiberBundles :: InfraConnection *)

(* Ported from InfraGaugeTheory Kernel/Connections.wl at e5dc83b; InfraGaugeTheory keeps its own copy *)

InfraConnectionQ[ fib : _[ _Graph, __ ], InfraConnection[ edges_List ] ] :=
  With[ { proj = InfraFibrationAssociation @ fib, total = InfraTotalGraph @ fib },
    { connection = Graph[ VertexList @ total, edges ] },
    AllTrue[ edges, EdgeQ[ total, # ] && proj @ First @ # =!= proj @ Last @ # & ] &&
      AllTrue[ VertexList @ total,
        x |-> Sort[ proj /@ AdjacencyList[ connection, x ] ] === Sort @ DeleteCases[ DeleteDuplicates[ proj /@ AdjacencyList[ total, x ] ], proj @ x ] ] ]

(* Every walk in the connection graph projects to a base walk with the same transport, so the holonomy of every loop is trivial
   iff no walk joins two vertices of one fiber, i.e. iff every horizontal leaf projects injectively *)

InfraFlatConnectionQ[ fib : _[ _Graph, __ ], conn : InfraConnection[ edges_List ] ] :=
  With[ { proj = InfraFibrationAssociation @ fib },
    InfraConnectionQ[ fib, conn ] && AllTrue[ ConnectedComponents @ Graph[ Keys @ proj, edges ], DuplicateFreeQ[ Lookup[ proj, # ] ] & ] ]

RandomInfraConnection[ fib : _[ _Graph, __ ] ] :=
  With[ { proj = InfraFibrationAssociation @ fib, total = InfraTotalGraph @ fib },
    { horizontal = Select[ EdgeList @ total, proj[ #[[ 1 ]] ] =!= proj[ #[[ 2 ]] ] & ] },
    InfraConnection @ Catenate[ FindIndependentEdgeSet @ Graph @ RandomSample @ # & /@ Values @ GroupBy[ horizontal, Sort[ proj /@ List @@ # ] & ] ] ]

FindInfraHorizontalLift[ fib : _[ _Graph, __ ], InfraConnection[ edges_List ], start_, walk_List, count : ( _Integer | UpTo[ _Integer ] | All ) ] :=
  With[ { proj = InfraFibrationAssociation @ fib },
    { connection = Graph[ Keys @ proj, edges ] },
    { lifts = Fold[
        { partial, q } |-> Catenate @ Map[ lift |-> ( Append[ lift, # ] & /@ Select[ AdjacencyList[ connection, Last @ lift ], proj @ # === q & ] ), partial ],
        If[ Lookup[ proj, Key @ start ] === First @ walk, { { start } }, { } ],
        Rest @ walk ] },
    Replace[ count, { All -> lifts, UpTo[ n_ ] :> Take[ lifts, UpTo[ n ] ], n_Integer :> If[ Length @ lifts >= n, Take[ lifts, n ], { } ] } ] ]

InfraParallelTransport[ fib : _[ _Graph, __ ], InfraConnection[ edges_List ], walk_List ] :=
  With[ { proj = InfraFibrationAssociation @ fib },
    { connection = Graph[ Keys @ proj, edges ] },
    { step = { x, q } |-> First[ Select[ AdjacencyList[ connection, x ], proj @ # === q & ], Missing[ ] ] },
    DeleteMissing @ AssociationMap[
      x |-> Fold[ If[ MissingQ @ #1, #1, step[ #1, #2 ] ] &, x, Rest @ walk ],
      Keys @ Select[ proj, # === First @ walk & ] ] ]

InfraHolonomy[ fib : _[ _Graph, __ ], conn_InfraConnection, loop : { p_, ___, p_ } ] :=
  With[ { transport = InfraParallelTransport[ fib, conn, loop ], fiber = Keys @ Select[ InfraFibrationAssociation @ fib, # === p & ] },
    PermutationCycles @ Lookup[ AssociationThread[ fiber, Range @ Length @ fiber ], Values @ transport ] /; Sort @ Values @ transport === Sort @ fiber ]
