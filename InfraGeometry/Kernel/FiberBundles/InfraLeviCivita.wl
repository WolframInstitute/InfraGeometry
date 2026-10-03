Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: FiberBundles :: InfraLeviCivita *)

(* Ported from InfraGaugeTheory Kernel/LeviCivita.wl and VectorTransport.wl at e5dc83b; InfraGaugeTheory keeps its own copy *)

(* InfraGaugeTheory's InfraParallelTransport[g, walk, r]. Over each step p -> q the transports are the injections of direction spheres
   S_r(p) -> S_r(q) that best match their angle structures (metric compatibility) with the radial cone through q pinned to its
   straightest continuations (geodesics auto-parallel); every composite along the walk, deduplicated, in InfraGaugeTheory's order *)

Options[ InfraParallelTransport ] = { Method -> "Arclength" }

InfraParallelTransport[ InfraDisplacementBundle[ graph_Graph, r_Integer?Positive ], walk : { __ }, opts : OptionsPattern[] ] /;
    MatchQ[ OptionValue[ InfraParallelTransport, { opts }, Method ], "Arclength" | "Alexandrov" ] :=
  With[ { method = OptionValue[ Method ], distanceMatrix = GraphDistanceMatrix @ graph },
    { distance = { a, b } |-> distanceMatrix[[ VertexIndex[ graph, a ], VertexIndex[ graph, b ] ]] },
    (* the direction sphere S_r(p) with its angle matrix: under "Arclength" the distance in the graph with the open ball B_{<r}(p)
       deleted, over r, pairs it disconnects at the common value 2 |V| / r; under "Alexandrov" the polar form <u, w>_p *)
    { directions = AssociationMap[
        p |-> With[ { sphere = Pick[ VertexList @ graph, distanceMatrix[[ VertexIndex[ graph, p ] ]], r ] },
          { sphere,
            If[ method === "Alexandrov",
              Outer[ ( distance[ p, #1 ] ^ 2 + distance[ p, #2 ] ^ 2 - distance[ #1, #2 ] ^ 2 ) / 2 &, sphere, sphere, 1 ],
              (* one punched graph and one row per sphere vertex: per-pair InfraAngle calls dominated the 10 x 10 torus at scale 2 *)
              With[ { punched = VertexDelete[ graph, Pick[ VertexList @ graph, Thread[ distanceMatrix[[ VertexIndex[ graph, p ] ]] < r ] ] ] },
                ( ( GraphDistance[ punched, # ] & /@ sphere )[[ All, VertexIndex[ punched, # ] & /@ sphere ]] /. Infinity -> 2 VertexCount @ graph ) /
                  r ] ] } ],
        Union @ walk ] },
    { transports = Apply[
        { p, q } |-> With[ { sphereP = First @ directions @ p, sphereQ = First @ directions @ q, anglesP = Last @ directions @ p,
                             anglesQ = Last @ directions @ q, stepLength = distance[ p, q ] },
          { transposed = Length @ sphereP > Length @ sphereQ,
            smallerSize = Min[ Length @ sphereP, Length @ sphereQ ], largerSize = Max[ Length @ sphereP, Length @ sphereQ ],
            backwardCone = Select[ Range @ Length @ sphereQ, distance[ p, sphereQ[[ # ]] ] == r - stepLength & ] },
          (* a germ u through q continues to the germs w extending the ray q -> u, farthest from p and, under the arc metric, from the
             backward cone *)
          { continuations = germP |-> With[
              { extensions = MaximalBy[ Select[ Range @ Length @ sphereQ, distance[ sphereP[[ germP ]], sphereQ[[ # ]] ] == stepLength & ],
                  distance[ p, sphereQ[[ # ]] ] & ] },
              If[ method === "Arclength" && backwardCone =!= { }, MaximalBy[ extensions, Total @ anglesQ[[ #, backwardCone ]] & ], extensions ] ],
            (* the injections of the smaller sphere into the larger consistent with the pins {germP, {germQ, ...}}, each partial choice
               completed by every injection of the free positions, a pin of the transposed case fixing the value germP *)
            injections = pins |-> Catenate @ Map[
              partial |-> With[ { freePositions = Complement[ Range @ smallerSize, partial[[ All, 1 ]] ] },
                Lookup[ AssociationThread[ Join[ partial[[ All, 1 ]], freePositions ], Join[ partial[[ All, 2 ]], # ] ], Range @ smallerSize ] & /@
                  Permutations[ Complement[ Range @ largerSize, partial[[ All, 2 ]] ], { Length @ freePositions } ] ],
              Select[
                Tuples[ ( pin |-> If[ transposed, { #, First @ pin } & /@ Last @ pin, { First @ pin, # } & /@ Last @ pin ] ) /@ pins ],
                DuplicateFreeQ[ #[[ All, 1 ]] ] && DuplicateFreeQ[ #[[ All, 2 ]] ] & ] ] },
          { pins = DeleteCases[ { #, continuations @ # } & /@ Select[ Range @ Length @ sphereP, distance[ q, sphereP[[ # ]] ] == r - stepLength & ],
              { _, { } } ] },
          { pinned = If[ pins === { }, { }, injections @ pins ] },
          (* without a satisfiable cone, the bond germ nearest q is pinned to the germs straightest from p *)
          { matchings = Which[
              sphereP === { } || sphereQ === { }, { },
              pinned =!= { }, pinned,
              True, With[ { straight = MinimalBy[ Range @ Length @ sphereQ,
                              ( distance[ q, sphereQ[[ # ]] ] ^ 2 + stepLength ^ 2 - distance[ sphereQ[[ # ]], p ] ^ 2 ) / 2 & ],
                            backward = First @ MinimalBy[ Range @ Length @ sphereQ, distance[ p, sphereQ[[ # ]] ] & ] },
                injections @ { { First @ MinimalBy[ Range @ Length @ sphereP, distance[ q, sphereP[[ # ]] ] & ],
                  If[ method === "Arclength", MaximalBy[ straight, anglesQ[[ backward, # ]] & ], straight ] } } ] ] },
          If[ transposed, AssociationThread[ sphereP[[ # ]], sphereQ ], AssociationThread[ sphereP, sphereQ[[ # ]] ] ] & /@
            MinimalBy[ matchings, matching |-> Total @ Flatten @ If[ transposed, ( anglesQ - anglesP[[ matching, matching ]] ) ^ 2,
              ( anglesP - anglesQ[[ matching, matching ]] ) ^ 2 ] ] ],
        Partition[ walk, 2, 1 ], { 1 } ] },
    DeleteDuplicates @ Map[
      chain |-> Association @ KeyValueMap[ { u, w } |-> { First @ walk, u } -> { Last @ walk, w },
        DeleteMissing @ AssociationThread[ First @ directions @ First @ walk,
          Fold[ Lookup[ #2, Key /@ #1, Missing[ ] ] &, First @ directions @ First @ walk, chain ] ] ],
      Tuples @ transports ] ]

(* InfraGaugeTheory's FindInfraLeviCivitaConnection: the first transport over each base edge; a lift u -> w with d(u, w) > 1 is not an
   edge of the displacement bundle and is dropped *)

Options[ FindInfraLeviCivitaConnection ] = { Method -> "Arclength" }

FindInfraLeviCivitaConnection[ fib : InfraDisplacementBundle[ graph_Graph, r_Integer?Positive ], opts : OptionsPattern[] ] /;
    MatchQ[ OptionValue[ FindInfraLeviCivitaConnection, { opts }, Method ], "Arclength" | "Alexandrov" ] :=
  InfraConnection @ Catenate @ Map[
    edge |-> With[ { transports = InfraParallelTransport[ fib, List @@ edge, Method -> OptionValue[ Method ] ] },
      If[ transports === { }, { },
        UndirectedEdge @@@ Select[ Normal @ First @ transports,
          Last @ First @ # === Last @ Last @ # || EdgeQ[ graph, UndirectedEdge[ Last @ First @ #, Last @ Last @ # ] ] & ] ] ],
    EdgeList @ graph ]

(* InfraGaugeTheory's holonomy angle: the mean angle between each moved direction and its image, dropped directions ignored, hence
   unsigned; the form without a connection takes the least over the Levi-Civita transports, as InfraGaugeTheory's InfraHolonomyAngle *)

Options[ InfraHolonomyAngle ] = { Method -> "Arclength" }

InfraHolonomyAngle[ fib : InfraDisplacementBundle[ graph_Graph, r_Integer?Positive ], conn_InfraConnection, loop : { base_, ___, base_ },
    opts : OptionsPattern[] ] /;
    MatchQ[ OptionValue[ InfraHolonomyAngle, { opts }, Method ], "Arclength" | "Alexandrov" ] :=
  With[ { punched = VertexDelete[ graph, Pick[ VertexList @ graph, Thread[ GraphDistance[ graph, base ] < r ] ] ],
          moved = Select[ Normal @ InfraParallelTransport[ fib, conn, loop ], First @ # =!= Last @ # & ] },
    { angle = If[ OptionValue[ Method ] === "Alexandrov",
        { u, w } |-> ArcCos @ Clip[ 1 - GraphDistance[ graph, u, w ] ^ 2 / ( 2 r ^ 2 ), { -1, 1 } ],
        { u, w } |-> ( GraphDistance[ punched, u, w ] /. Infinity -> 2 VertexCount @ graph ) / r ] },
    If[ moved === { }, 0, Mean[ angle[ Last @ First @ #, Last @ Last @ # ] & /@ moved ] ] ]

InfraHolonomyAngle[ fib : InfraDisplacementBundle[ graph_Graph, r_Integer?Positive ], loop : { base_, ___, base_ }, opts : OptionsPattern[] ] /;
    MatchQ[ OptionValue[ InfraHolonomyAngle, { opts }, Method ], "Arclength" | "Alexandrov" ] :=
  With[ { punched = VertexDelete[ graph, Pick[ VertexList @ graph, Thread[ GraphDistance[ graph, base ] < r ] ] ] },
    { angle = If[ OptionValue[ Method ] === "Alexandrov",
        { u, w } |-> ArcCos @ Clip[ 1 - GraphDistance[ graph, u, w ] ^ 2 / ( 2 r ^ 2 ), { -1, 1 } ],
        { u, w } |-> ( GraphDistance[ punched, u, w ] /. Infinity -> 2 VertexCount @ graph ) / r ] },
    Min @ Map[
      transport |-> With[ { moved = Select[ Normal @ transport, First @ # =!= Last @ # & ] },
        If[ moved === { }, 0, Mean[ angle[ Last @ First @ #, Last @ Last @ # ] & /@ moved ] ] ],
      InfraParallelTransport[ fib, loop, Method -> OptionValue[ Method ] ] ] ]

(* InfraGaugeTheory's InfraCovariantDerivative. For a step p -> q, conn carries s[q] back to p; the arrow from s[p] to that image is
   carried to p along a shortest path by the Levi-Civita transports at its own length, and the endpoint nearest to p is the derivative,
   p itself the zero vector *)

Options[ InfraCovariantDerivative ] = { Method -> "Arclength" }

InfraCovariantDerivative[ fib : InfraDisplacementBundle[ graph_Graph, r_Integer?Positive ], conn_InfraConnection,
    InfraSection[ section_Association ], walk_List, opts : OptionsPattern[] ] /;
    MatchQ[ OptionValue[ InfraCovariantDerivative, { opts }, Method ], "Arclength" | "Alexandrov" ] :=
  AssociationThread[ Most @ walk,
    MapThread[
      { p, q } |-> With[ { valueAtP = Lookup[ section, Key @ p, Missing[ ] ],
                           transported = Lookup[ InfraParallelTransport[ fib, conn, { q, p } ], Key @ Lookup[ section, Key @ q, Missing[ ] ],
                             Missing[ ] ] },
        Which[
          MissingQ @ valueAtP || MissingQ @ transported, Missing[ ],
          transported === valueAtP, p,
          True, With[ { arrowLength = GraphDistance[ graph, Last @ valueAtP, Last @ transported ],
                        returnPath = FindShortestPath[ graph, Last @ valueAtP, p ] },
            { endpoints = Last /@ Lookup[
                InfraParallelTransport[ InfraDisplacementBundle[ graph, arrowLength ], returnPath, Method -> OptionValue[ Method ] ],
                Key @ { Last @ valueAtP, Last @ transported }, Nothing ] },
            First[ SortBy[ DeleteDuplicates @ endpoints, GraphDistance[ graph, p, # ] & ], Missing[ ] ] ] ] ],
      { Most @ walk, Rest @ walk } ] ]

(* theta_{x, v}( {x, v} -> {y, w} ) = <v, y>_x, the polar pairing of the vector x -> v with the base displacement x -> y *)

InfraCanonicalOneForm[ g_Graph, vector : { _, __ }, { y_, ___ } ] :=
  InfraScalarProduct[ g, First @ vector, Last @ vector, y ]
