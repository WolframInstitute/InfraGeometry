Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: FiberBundles :: InfraSection *)

(* Ported from InfraGaugeTheory Kernel/Sections.wl at e5dc83b; InfraGaugeTheory keeps its own copy *)

InfraSectionQ[ fib : _[ _Graph, __ ], InfraSection[ section_Association ] ] :=
  With[ { proj = InfraFibrationAssociation @ fib },
    AllTrue[ Normal @ section, Lookup[ proj, Key @ Last @ # ] === First @ # & ] ]

InfraContinuousSectionQ[ fib : _[ _Graph, __ ], InfraSection[ section_Association ] ] :=
  With[ { proj = InfraFibrationAssociation @ fib, total = InfraTotalGraph @ fib },
    AllTrue[ Normal @ section, Lookup[ proj, Key @ Last @ # ] === First @ # & ] &&
      AllTrue[ EdgeList @ Subgraph[ InfraBaseGraph @ InfraFibration[ total, proj ], Keys @ section ],
        EdgeQ[ total, UndirectedEdge @@ Lookup[ section, List @@ # ] ] & ] ]

RandomInfraSection[ fib : _[ _Graph, __ ] ] :=
  With[ { proj = InfraFibrationAssociation @ fib },
    InfraSection[ RandomChoice /@ GroupBy[ Keys @ proj, proj ] ] ]

FindInfraSection[ fib : _[ _Graph, __ ], count : ( _Integer | UpTo[ _Integer ] | All ) ] :=
  With[ { proj = InfraFibrationAssociation @ fib, total = InfraTotalGraph @ fib },
    { base = InfraBaseGraph @ InfraFibration[ total, proj ] },
    (* a continuous section picks one vertex per fiber, adjacent over every base edge: a clique of size |base| in the graph joining
       total vertices over distinct base vertices that are either not adjacent in the base or adjacent in the total graph *)
    { compatible = Graph[ VertexList @ total,
        UndirectedEdge @@@ Select[ Subsets[ VertexList @ total, { 2 } ],
          Apply[ { x, y } |-> proj @ x =!= proj @ y && ( ! EdgeQ[ base, UndirectedEdge[ proj @ x, proj @ y ] ] || EdgeQ[ total, UndirectedEdge[ x, y ] ] ) ] ] ] },
    { sections = InfraSection @ KeyTake[ AssociationThread[ Lookup[ proj, # ], # ], VertexList @ base ] & /@
        FindClique[ compatible, { VertexCount @ base }, Replace[ count, UpTo[ n_ ] :> n ] ] },
    If[ IntegerQ @ count && Length @ sections < count, { }, sections ] ]
