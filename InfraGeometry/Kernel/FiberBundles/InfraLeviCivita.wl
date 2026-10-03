Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: FiberBundles :: InfraLeviCivita *)

(* Ported from InfraGaugeTheory Kernel/LeviCivita.wl and VectorTransport.wl at e5dc83b; InfraGaugeTheory keeps its own copy *)

(* Over each base edge p ~ q the transport is the injection of direction spheres S_r(p) -> S_r(q) that best matches their angle structures
   (metric compatibility) with the radial cone through q pinned to its straightest continuations (geodesics auto-parallel);
   among the best injections the one moving the germs least is kept, and only its lifts that are edges of the total graph *)

Options[ FindInfraLeviCivitaConnection ] = { Method -> "Arclength" }

FindInfraLeviCivitaConnection[ InfraDisplacementBundle[ g_Graph, r_Integer?Positive ], opts : OptionsPattern[] ] /;
    MatchQ[ OptionValue[ FindInfraLeviCivitaConnection, { opts }, Method ], "Arclength" | "Alexandrov" ] :=
  With[ { method = OptionValue[ Method ], dm = GraphDistanceMatrix @ g, index = AssociationThread[ VertexList @ g, Range @ VertexCount @ g ] },
    { d = { a, b } |-> dm[[ index @ a, index @ b ]], spheres = AssociationMap[ p |-> Pick[ VertexList @ g, dm[[ index @ p ]], r ], VertexList @ g ] },
    { grams = AssociationMap[
        p |-> If[ method === "Alexandrov",
          Outer[ InfraScalarProduct[ g, p, #1, #2 ] &, spheres @ p, spheres @ p, 1 ],
          (* InfraAngle's arc measure from one punched graph per sphere: per-pair InfraAngle calls dominated the 10 x 10 torus at scale 2 *)
          With[ { punched = VertexDelete[ g, Pick[ VertexList @ g, Thread[ dm[[ index @ p ]] < r ] ] ] },
            { positions = VertexIndex[ punched, # ] & /@ spheres @ p },
            ( GraphDistance[ punched, # ] & /@ spheres @ p )[[ All, positions ]] / r /. Infinity -> 2 VertexCount @ g ] ],
        VertexList @ g ] },
    { transport = { p, q } |-> With[ { sp = spheres @ p, sq = spheres @ q, gp = grams @ p, gq = grams @ q, s = d[ p, q ] },
        { transposed = Length @ sp > Length @ sq, back = Select[ Range @ Length @ sq, d[ p, sq[[ # ]] ] == r - s & ] },
        (* a germ u through q continues to the germs w extending the ray q -> u, farthest from p and, under the arc metric,
           from the backward cone *)
        { continuations = iu |-> With[ { extensions = Select[ Range @ Length @ sq, d[ sp[[ iu ]], sq[[ # ]] ] == s & ] },
            { candidates = MaximalBy[ extensions, d[ p, sq[[ # ]] ] & ] },
            If[ method === "Arclength" && back =!= { }, MaximalBy[ candidates, Total @ gq[[ #, back ]] & ], candidates ] ] },
        (* the injections of the smaller sphere into the larger consistent with the pins {iu, {iw, ...}},
           a pin fixing germ iu of S_r(p) to one of the iw *)
        { injections = pins |-> Catenate @ Map[
            partial |-> With[ { free = Complement[ Range @ Min[ Length @ sp, Length @ sq ], partial[[ All, 1 ]] ] },
              Values @ KeySort @ AssociationThread[ Join[ partial[[ All, 1 ]], free ], Join[ partial[[ All, 2 ]], # ] ] & /@
                Permutations[ Complement[ Range @ Max[ Length @ sp, Length @ sq ], partial[[ All, 2 ]] ], { Length @ free } ] ],
            Select[
              Tuples[ ( pin |-> If[ transposed, { #, First @ pin } & /@ Last @ pin, { First @ pin, # } & /@ Last @ pin ] ) /@ pins ],
              DuplicateFreeQ[ #[[ All, 1 ]] ] && DuplicateFreeQ[ #[[ All, 2 ]] ] & ] ] },
        { pins = DeleteCases[ { #, continuations @ # } & /@ Select[ Range @ Length @ sp, d[ q, sp[[ # ]] ] == r - s & ], { _, { } } ] },
        { pinned = If[ pins === { }, { }, injections @ pins ] },
        (* without a satisfiable cone, the single bond germ nearest q is pinned to the germs straightest from p *)
        { matchings = If[ pinned =!= { }, pinned,
            With[ { straight = MinimalBy[ Range @ Length @ sq, InfraScalarProduct[ g, q, sq[[ # ]], p ] & ],
                    backward = First @ MinimalBy[ Range @ Length @ sq, d[ p, sq[[ # ]] ] & ] },
              injections @ { { First @ MinimalBy[ Range @ Length @ sp, d[ q, sp[[ # ]] ] & ],
                If[ method === "Arclength", MaximalBy[ straight, gq[[ backward, # ]] & ], straight ] } } ] ] },
        { maps = If[ transposed, AssociationThread[ sp[[ # ]], sq ], AssociationThread[ sp, sq[[ # ]] ] ] & /@
            MinimalBy[ matchings, m |-> Total @ Flatten @ If[ transposed, ( gq - gp[[ m, m ]] ) ^ 2, ( gp - gq[[ m, m ]] ) ^ 2 ] ] },
        If[ maps === { }, { },
          UndirectedEdge[ { p, First @ # }, { q, Last @ # } ] & /@
            Select[ Normal @ First @ MinimalBy[ maps, map |-> Total @ KeyValueMap[ d, map ] ], d @@ # <= 1 & ] ] ] },
    InfraConnection @ Catenate[ transport @@@ Select[ EdgeList @ g, spheres @ First @ # =!= { } && spheres @ Last @ # =!= { } & ] ] ]

(* The rotation of the direction sphere as a fraction of its full turn, the shortest closed tour through the sphere under the same angle *)

Options[ InfraHolonomyAngle ] = { Method -> "Arclength" }

InfraHolonomyAngle[ fib : InfraDisplacementBundle[ g_Graph, r_Integer?Positive ], conn_InfraConnection, loop : { p_, ___, p_ },
    OptionsPattern[] ] :=
  With[ { method = OptionValue[ Method ] },
    { angle = { u, w } |-> InfraAngle[ g, { u, p, w }, Method -> method ],
          moved = Select[ Normal @ InfraParallelTransport[ fib, conn, loop ], First @ # =!= Last @ # & ] },
    If[ moved === { }, 0,
      2 Pi Mean[ angle[ Last @ First @ #, Last @ Last @ # ] & /@ moved ] /
        First @ FindShortestTour[ Pick[ VertexList @ g, GraphDistance[ g, p ], r ], DistanceFunction -> angle ] ] ]

(* For a step p -> q the value at q is transported back to p; the arrow from the value at p to that image is carried to p along a shortest
   path by the Levi-Civita connection at its own length, and its endpoint is the derivative, p itself the zero vector *)

Options[ InfraCovariantDerivative ] = { Method -> "Arclength" }

InfraCovariantDerivative[ fib : InfraDisplacementBundle[ g_Graph, r_Integer?Positive ], conn_InfraConnection, InfraSection[ s_Association ],
    walk_List, OptionsPattern[] ] :=
  With[ { method = OptionValue[ Method ] },
    AssociationThread[ Most @ walk,
      MapThread[
        { p, q } |-> With[ { b = Lookup[ s, Key @ p, Missing[ ] ], c = Lookup[ s, Key @ q, Missing[ ] ] },
          { image = Lookup[ InfraParallelTransport[ fib, conn, { q, p } ], Key @ c, Missing[ ] ] },
          Which[
            MissingQ @ image || MissingQ @ b, Missing[ ],
            image === b, p,
            True, With[ { arrow = InfraDisplacementBundle[ g, GraphDistance[ g, Last @ b, Last @ image ] ] },
              { lc = FindInfraLeviCivitaConnection[ arrow, Method -> method ] },
              { transport = InfraParallelTransport[ arrow, lc, FindShortestPath[ g, Last @ b, p ] ] },
              Replace[ Lookup[ transport, Key @ { Last @ b, Last @ image }, Missing[ ] ], { _, x_ } :> x ] ] ] ],
        { Most @ walk, Rest @ walk } ] ] ]

(* theta_{x, v}( {x, v} -> {y, w} ) = <v, y>_x, the polar pairing of the vector x -> v with the base displacement x -> y *)

InfraCanonicalOneForm[ g_Graph, vector : { _, __ }, { y_, ___ } ] :=
  InfraScalarProduct[ g, First @ vector, Last @ vector, y ]
