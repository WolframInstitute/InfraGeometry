Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: FiberBundles :: InfraFibration *)

(* Ported from InfraGaugeTheory Kernel/FiberedGraph.wl at e5dc83b; InfraGaugeTheory keeps its own copy *)

InfraTotalGraph[ InfraFibration[ total_Graph, _ ] ] :=
  total

InfraFibrationAssociation[ InfraFibration[ total_Graph, proj_ ] ] :=
  AssociationMap[ proj, VertexList @ total ]

InfraBaseGraph[ fib : _[ _Graph, __ ] ] :=
  With[ { proj = InfraFibrationAssociation @ fib, total = InfraTotalGraph @ fib },
    Graph[ DeleteDuplicates @ Values @ proj,
      DeleteDuplicates @ Select[ UndirectedEdge @@ Sort[ proj /@ List @@ # ] & /@ EdgeList @ total, #[[ 1 ]] =!= #[[ 2 ]] & ] ] ]

InfraFiber[ fib : _[ _Graph, __ ], p_ ] :=
  Subgraph[ InfraTotalGraph @ fib, Keys @ Select[ InfraFibrationAssociation @ fib, # === p & ] ]

InfraFibers[ fib : _[ _Graph, __ ] ] :=
  With[ { proj = InfraFibrationAssociation @ fib, total = InfraTotalGraph @ fib },
    Subgraph[ total, # ] & /@ GroupBy[ Keys @ proj, proj ] ]

InfraFibrationQ[ fib : _[ _Graph, __ ] ] :=
  With[ { proj = InfraFibrationAssociation @ fib, total = InfraTotalGraph @ fib },
    { base = InfraBaseGraph @ InfraFibration[ total, proj ] },
    AllTrue[ VertexList @ total, x |-> SubsetQ[ proj /@ AdjacencyList[ total, x ], AdjacencyList[ base, proj @ x ] ] ] ]

(* Local triviality over the closed ball B(p, 1): with exactly one lift of every base edge, the horizontal edges over the ball form a covering of
   it, and the covering is trivial iff each of its components projects injectively, i.e. iff every loop in the ball has trivial holonomy *)

InfraFiberBundleQ[ fib : _[ _Graph, __ ] ] :=
  With[ { proj = InfraFibrationAssociation @ fib, total = InfraTotalGraph @ fib },
    { base = InfraBaseGraph @ InfraFibration[ total, proj ], preimages = GroupBy[ Keys @ proj, proj ] },
    { fibers = Values[ Subgraph[ total, # ] & /@ preimages ] },
    AllTrue[ Rest @ fibers, IsomorphicGraphQ[ First @ fibers, # ] & ] &&
      AllTrue[ VertexList @ total,
        x |-> Sort @ DeleteCases[ proj /@ AdjacencyList[ total, x ], proj @ x ] === Sort @ AdjacencyList[ base, proj @ x ] ] &&
      AllTrue[ VertexList @ base,
        p |-> With[ { over = Catenate[ preimages /@ VertexList @ NeighborhoodGraph[ base, p ] ] },
          AllTrue[
            ConnectedComponents @ Graph[ over, Select[ EdgeList @ Subgraph[ total, over ], proj @ #[[ 1 ]] =!= proj @ #[[ 2 ]] & ] ],
            DuplicateFreeQ[ proj /@ # ] & ] ] ] ]

Options[ RandomInfraFibration ] = {
  "VerticalVertices" -> 1,
  "VerticalEdges" -> 0,
  "HorizontalEdgesRadius" -> 1,
  "HorizontalEdgesDensity" -> 1,
  "IsomorphicFibers" -> False
}

RandomInfraFibration[ base_Graph, opts : OptionsPattern[] ] :=
  With[ { draw = spec |-> If[ ListQ @ spec, RandomReal @ spec, spec ], iso = TrueQ @ OptionValue[ "IsomorphicFibers" ] },
    { sizes = If[ iso,
        ConstantArray[ Round @ draw @ OptionValue[ "VerticalVertices" ], VertexCount @ base ],
        Table[ Round @ draw @ OptionValue[ "VerticalVertices" ], VertexCount @ base ] ] },
    { fibers = AssociationThread[ VertexList @ base, MapThread[ { p, n } |-> ( { p, # } & /@ Range @ n ), { VertexList @ base, sizes } ] ] },
    { template = n |-> With[ { m = Min[ Max[ 0, Round @ draw @ OptionValue[ "VerticalEdges" ] ], n ( n - 1 ) / 2 ] },
        If[ n > 1 && m > 0, EdgeList @ RandomGraph[ { n, m } ], { } ] ] },
    { shared = If[ iso, template @ First[ sizes, 0 ], None ] },
    { vertical = Catenate @ Map[
        fiber |-> Replace[ If[ iso, shared, template @ Length @ fiber ], Thread[ Range @ Length @ fiber -> fiber ], { 2 } ],
        Values @ fibers ] },
    { dist = GraphDistanceMatrix @ base, radius = Max[ 0, Round @ draw @ OptionValue[ "HorizontalEdgesRadius" ] ] },
    { pairs = Select[ Subsets[ Range @ VertexCount @ base, { 2 } ], dist[[ #[[ 1 ]], #[[ 2 ]] ]] <= radius & ] },
    (* the fiber vertex i over p meets j over q iff i / n1 and j / n2 nearly agree: a diagonal matching, widened by the density *)
    { horizontal = Catenate @ Map[
        pair |-> With[ { f1 = fibers @ VertexList[ base ][[ First @ pair ]], f2 = fibers @ VertexList[ base ][[ Last @ pair ]] },
          { n1 = Length @ f1, n2 = Length @ f2, density = draw @ OptionValue[ "HorizontalEdgesDensity" ] },
          UndirectedEdge[ f1[[ First @ # ]], f2[[ Last @ # ]] ] & /@
            Select[ Tuples[ { Range @ n1, Range @ n2 } ], Mod[ First[ # ] n2 - Last[ # ] n1, n1 n2 ] < density Max[ n1, n2 ] & ] ],
        pairs ] },
    { coordinates = AssociationThread[ VertexList @ base, GraphEmbedding @ base ] },
    { scale = Min[ 1, EuclideanDistance @@ ( coordinates /@ List @@ # ) & /@ EdgeList @ base ] / 3 },
    { vertices = Catenate @ Values @ fibers },
    InfraFibration[
      Graph[ vertices, Join[ vertical, horizontal ],
        VertexCoordinates -> Catenate @ KeyValueMap[
          { p, fiber } |-> Thread[ fiber -> ( coordinates[ p ] + scale # & /@ If[ Length @ fiber == 1, { { 0, 0 } }, CirclePoints @ Length @ fiber ] ) ],
          fibers ] ],
      AssociationMap[ First, vertices ] ] ]

InfraBundleMorphismQ[ fib1 : _[ _Graph, __ ], fib2 : _[ _Graph, __ ], map_, baseMap_ : Identity ] :=
  With[ { total1 = InfraTotalGraph @ fib1, total2 = InfraTotalGraph @ fib2, proj1 = InfraFibrationAssociation @ fib1, proj2 = InfraFibrationAssociation @ fib2 },
    { close = { a, b } |-> a === b || EdgeQ[ total2, UndirectedEdge[ a, b ] ] },
    AllTrue[ VertexList @ total1, Lookup[ proj2, Key[ map @ # ] ] === baseMap[ proj1 @ # ] & ] &&
      AllTrue[ EdgeList @ total1, close @@ ( map /@ List @@ # ) & ] ]
