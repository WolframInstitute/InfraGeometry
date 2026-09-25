Package["WolframInstitute`SyntheticInfrageometry`"]


(* ===================== Sierpinski graph (trivalent) ===================== *)

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


(* ===================== Bethe lattice ===================== *)

(* BetheGraph[n, z] is the finite Bethe lattice / Cayley tree of n shells and coordination
   number z (argument order matching CompleteKaryTree[n, k]): the root branches z ways,
   every other internal node branches z-1 (its remaining edge goes to its parent), so all
   interior vertices are z-valent and only the depth-n boundary is 1-valent.  Distinct
   from the rooted, irregular CompleteKaryTree (root degree k, internal degree k+1).
   Atomic root (NestGraph reads an empty-list seed as an empty vertex set). *)

BetheGraph[ n_Integer, z_Integer, opts : OptionsPattern[ Graph ] ] :=
  NestGraph[ w |-> If[ w === 0, List /@ Range @ z, Append[ w, # ] & /@ Range[ z - 1 ] ], 0, n, opts, DirectedEdges -> False ]


(* ===================== Spherically symmetric tree ===================== *)

(* BranchingSequenceTree[b] is the spherically symmetric (radially homogeneous) rooted
   tree whose offspring count depends only on depth: a vertex at depth l has b[[l+1]]
   children, so all vertices at a given depth share the same degree.  Length[b]+1 levels;
   FoldList[Times, 1, b] vertices per shell.  Constant b is CompleteKaryTree; the
   coordination-fixed cousin is BetheGraph.  Vertices are {depth, position} pairs. *)

BranchingSequenceTree[ b_List, opts : OptionsPattern[ Graph ] ] :=
  NestGraph[
    With[ { l = First @ #, p = Last @ #, c = b[[ First @ # + 1 ]] },
      { l + 1, ( p - 1 ) c + # } & /@ Range @ c ] &,
    { { 0, 1 } }, Length @ b, opts, DirectedEdges -> False ]


(* ===================== Inflation ===================== *)

(* InflateGraph[g] grows a fiber of extra vertices over each vertex of g: every new vertex is joined
   to its base vertex, fibers get "ExtraEdges" internal edges, and random edges are added between
   fibers whose base vertices lie within "Radius" in g.  The base survives as the induced subgraph
   on VertexList[g], so g is recoverable and the perturbation only adds local dimensional noise.
   Each option takes a constant or a {min, max} range sampled per base vertex. *)

Options[ InflateGraph ] = {
  "ExtraVertices" -> { 0, 2 },
  "ExtraEdges"    -> 0,
  "Radius"        -> 1,
  "Density"       -> 1
};

InflateGraph[ g_Graph, opts : OptionsPattern[ { InflateGraph, Graph } ] ] :=
  With[
    { sample = spec |-> Replace[ spec, { k_ ? NumericQ :> Round @ k, { a_, b_ } :> RandomInteger[ { Round @ a, Round @ b } ] } ] },
    { radius = sample @ OptionValue[ InflateGraph, { opts }, "Radius" ],
      density = OptionValue[ InflateGraph, { opts }, "Density" ],
      innerSpec = OptionValue[ InflateGraph, { opts }, "ExtraEdges" ],
      extraSpec = OptionValue[ InflateGraph, { opts }, "ExtraVertices" ] },
    { fibers = AssociationMap[
        v |-> Array[ InflatedVertex[ v, # ] &, sample @ extraSpec ],
        VertexList @ g ] },
    { edges = Join[
        Catenate @ KeyValueMap[ { v, fiber } |-> ( UndirectedEdge[ v, # ] & /@ fiber ), fibers ],
        Catenate @ Map[
          fiber |-> With[ { m = sample @ innerSpec, pairs = Subsets[ fiber, { 2 } ] },
            UndirectedEdge @@@ RandomSample[ pairs, Min[ m, Length @ pairs ] ] ],
          Values @ fibers ],
        Catenate @ Map[
          v |-> With[ { near = VertexList @ NeighborhoodGraph[ g, v, radius ] },
            { reach = Catenate @ Lookup[ fibers, near ] },
            { candidates = DeleteCases[ Tuples[ { fibers @ v, Join[ reach, near ] } ], { x_, x_ } ] },
            UndirectedEdge @@@ RandomSample[
              candidates,
              Min[ RandomInteger @ Round[ density Length[ reach ] / Max[ Length @ near, 1 ] ], Length @ candidates ] ] ],
          VertexList @ g ] ] },
    { coords = AssociationThread[ VertexList @ g, GraphEmbedding @ g ] },
    { jitter = Ball[ ConstantArray[ 0, Length @ First @ coords ],
        0.3 Mean[ EuclideanDistance @@ Lookup[ coords, List @@ # ] & /@ EdgeList @ g ] ] },
    Graph[
      EdgeAdd[ g, edges ],
      Sequence @@ FilterRules[ { opts }, Options @ Graph ],
      VertexCoordinates -> Normal @ Join[
        coords,
        Association @ Catenate @ KeyValueMap[
          { v, fiber } |-> ( # -> coords[ v ] + RandomPoint @ jitter & /@ fiber ),
          fibers ] ] ]
  ]
