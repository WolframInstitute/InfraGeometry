Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: InfraSubstrates :: ExampleGraphs *)

(* SierpinskiGraph[n] is the trivalent Sierpinski graph: start from the 3-simplex K_4
   (the tetrahedron) and iterate corner-cutting (truncation) n-1 times.  Each step
   replaces every vertex by a triangle, its three incident edges reattaching to the
   corners -- on a cubic graph this is truncation, so the graph stays 3-regular at every
   generation (4*3^(n-1) vertices; n=2 is the truncated tetrahedron).  Combinatorial
   only; the default 2-D layout is Graph's -- pass VertexCoordinates / GraphLayout (or
   wrap in Graph3D) for the tetrahedral picture. *)

SierpinskiGraph[ n_Integer, opts : OptionsPattern[ Graph ] ] :=
  Graph[
    Nest[
      g |-> Graph[
        Join[
          Flatten @ Table[ UndirectedEdge[ { v, i }, { v, j } ], { v, VertexList @ g }, { i, 1, 2 }, { j, i + 1, 3 } ],
          ( e |-> UndirectedEdge[
              { e[[ 1 ]], First @ FirstPosition[ AdjacencyList[ g, e[[ 1 ]] ], e[[ 2 ]] ] },
              { e[[ 2 ]], First @ FirstPosition[ AdjacencyList[ g, e[[ 2 ]] ], e[[ 1 ]] ] } ] ) /@ EdgeList @ g ] ],
      CompleteGraph[ 4 ], n - 1 ],
    opts ]

BetheGraph[ n_Integer, z_Integer, opts : OptionsPattern[ Graph ] ] :=
  NestGraph[ w |-> If[ w === 0, List /@ Range @ z, Append[ w, # ] & /@ Range[ z - 1 ] ], 0, n, opts, DirectedEdges -> False ]

BranchingSequenceTree[ b_List, opts : OptionsPattern[ Graph ] ] :=
  NestGraph[
    With[ { l = First @ #, p = Last @ #, c = b[[ First @ # + 1 ]] },
      { l + 1, ( p - 1 ) c + # } & /@ Range @ c ] &,
    { { 0, 1 } }, Length @ b, opts, DirectedEdges -> False ]

Options[ InflateGraph ] = { "VerticalEdges" -> 0, "HorizontalEdges" -> 1 }

InflateGraph[ g_Graph, opts : OptionsPattern[ { InflateGraph, Graph } ] ] :=
  InflateGraph[ g, 1, opts ]

InflateGraph[ g_Graph, amount : _?NumericQ | { _?NumericQ, _?NumericQ }, opts : OptionsPattern[ { InflateGraph, Graph } ] ] :=
  With[
    { draw = spec |-> Replace[ spec, { k_?NumericQ :> Round @ k, { a_, b_ } :> RandomInteger[ Round @ { a, b } ] } ] },
    { taken = Counts @ Cases[ VertexList @ g, InflatedVertex[ v_, _ ] :> v ] },
    { fibers = AssociationMap[ v |-> Array[ InflatedVertex[ v, # ] &, draw @ amount, 1 + Lookup[ taken, Key @ v, 0 ] ], VertexList @ g ] },
    { spokes = Catenate @ KeyValueMap[ { v, fiber } |-> ( { v, # } & /@ fiber ), fibers ] },
    { vertical = Union @@ Map[
        fiber |-> RandomSample[ Subsets[ fiber, { 2 } ], UpTo @ draw @ OptionValue[ "VerticalEdges" ] ],
        Values @ fibers ] },
    { horizontal = Union @@ Map[
        edge |-> RandomSample[ Tuples @ Lookup[ fibers, List @@ edge ], UpTo @ draw @ OptionValue[ "HorizontalEdges" ] ],
        EdgeList @ g ] },
    { coordinates = AssociationThread[ VertexList @ g, GraphEmbedding @ g ] },
    { radius = Min[ EuclideanDistance @@ Lookup[ coordinates, List @@ # ] & /@ EdgeList @ g ] / 3 },
    Graph[
      EdgeAdd[ g, UndirectedEdge @@@ Join[ spokes, vertical, horizontal ] ],
      FilterRules[ { opts }, Options @ Graph ],
      VertexCoordinates -> Normal @ Join[
        coordinates,
        Association @ KeyValueMap[
          { v, fiber } |-> Thread[ fiber -> ( coordinates @ v + PadRight[ #, Length @ coordinates @ v ] & /@ CirclePoints[ { radius, Pi / 8. }, Length @ fiber ] ) ],
          fibers ] ] ]
  ]
