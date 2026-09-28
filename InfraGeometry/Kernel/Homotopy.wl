Package["WolframInstitute`InfraGeometry`"]



(* ===================== The chain shape ===================== *)

(* a homotopy is a CHAIN of walks, and a walk is a Graph, so a chain is { w1, ..., wm } -- a List of directed path graphs for an open homotopy, of directed cycles for a closed one.  HighlightGraph takes it directly, Length is the number of moves plus one, First and Last are its ends.  The InfraHomotopy head is gone with the other payload wrappers: ["Realizations"] is the List a bounded count or All already returns, ["Mass"] is Length, and ["Weights"] was always all-ones *)

(* the homotopy class is read off the shape and one option.  An open walk -- a vertex list or a path graph -- is a path with its endpoints fixed, slid by "FreeHomotopy"; a closed walk -- a cycle graph, a circle included -- is a loop with its base point fixed, quotiented by rotation into the free loop by "FreeHomotopy", whose canonical form is the lex-least rotation of the cyclic core.  Both arguments of a two-walk question must be open or both closed *)


(* ===================== FindInfraHomotopy ===================== *)


FindInfraHomotopy::mismatch  = "The first walk is `1` and the second `2`; both must be open or both closed.";
FindInfraHomotopy::badmethod = "Method `1` is not supported by FindInfraHomotopy.";

Options[ FindInfraHomotopy ] = {
  Method                -> "Exhaustive",
  "FreeHomotopy"        -> False,
  "NullHomotopicCycles" -> { 1, 2, 3 },
  "MaxLength"           -> Automatic,
  "MaxMoves"            -> Infinity
};

(* a chain from a to b of elementary moves -- a consecutive duplicate, a spur, or one arc of a declared face swapped for the complementary arc -- with endpoint slides on a free path and base-point rotation on a free loop.  "Exhaustive" is the breadth-first search of walk-space within "MaxLength", "Greedy" the descent to the neighbour of smallest symmetric Hausdorff distance to b, without backtracking *)
FindInfraHomotopy[ graph_Graph, a_, b_,
    count : ( _Integer | UpTo[ _Integer ] | All ) : Automatic, opts : OptionsPattern[] ] :=
  Module[ { parent, frontier, next, found, layer, chain, current, visited, steps, nbrs, best },
    With[ {
        closedOf = x |-> Replace[ x, { w_Graph | { w_Graph, ___Graph } :> ! LoopFreeGraphQ @ w || ! AcyclicGraphQ @ w, _ -> False } ],
        walksOf = w |-> With[ { vs = VertexList @ w },
          { spelled = AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
            scan = v |-> Reap[ DepthFirstScan[ w, v, { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] },
          Which[
            vs === { }, { },
            ! LoopFreeGraphQ @ w || ! AcyclicGraphQ @ w,
              { If[ First @ # === Last @ #, #, Append[ #, First @ # ] ] & @
                  If[ spelled, Last /@ SortBy[ vs, First ], scan @ First @ vs ] },
            spelled,            { Last /@ SortBy[ vs, First ] },
            EdgeCount @ w == 0, List /@ vs,
            DirectedGraphQ @ w,
              Catenate @ Catenate @ Table[ FindPath[ w, s, t, Infinity, All ],
                { s, Select[ vs, VertexInDegree[ w, # ] == 0 & ] }, { t, Select[ vs, VertexOutDegree[ w, # ] == 0 & ] } ],
            True, { scan @ SelectFirst[ vs, VertexDegree[ w, # ] == 1 &, First @ vs ] } ] ],
        freeHom = TrueQ @ OptionValue[ FindInfraHomotopy, { opts }, "FreeHomotopy" ],
        vN = AssociationMap[ AdjacencyList[ graph, # ] &, VertexList @ graph ],
        closeUp = w |-> If[ First @ w === Last @ w, w, Append[ w, First @ w ] ],
        canonical = w |-> If[ Length @ w <= 1, w,
          ( core |-> First @ Sort @ Table[ RotateLeft[ core, k ], { k, 0, Length @ core - 1 } ] ) @
            If[ First @ w === Last @ w, Most @ w, w ] ] },
      { closedQ = closedOf @ a,
        spread = x |-> Which[
          AssociationQ @ x,             Keys @ x,
          GraphQ @ x,                   walksOf @ x,
          MatchQ[ x, { __Graph } ],     Catenate[ walksOf /@ x ],
          x === { },                    { },
          True,                         { x } ] },
      { slides = ! closedQ && freeHom,
        canonicalize = closedQ && freeHom,
        shape = If[ closedQ,
          w |-> ( core |-> Graph[ core, DirectedEdge @@@ Partition[ core, 2, 1, 1 ] ] ) @
            MapIndexed[ { First @ #2, #1 } &, If[ Length @ w >= 2 && First @ w === Last @ w, Most @ w, w ] ],
          w |-> PathGraph[ MapIndexed[ { First @ #2, #1 } &, w ], DirectedEdges -> True ] ] },
      { canon = If[ canonicalize, canonical, Identity ],
        coerce = w |-> Which[ canonicalize, canonical @ w, closedQ, closeUp @ w, True, w ] },
      If[ closedQ =!= closedOf @ b,
        Message[ FindInfraHomotopy::mismatch, If[ closedQ, "closed", "open" ], If[ closedQ, "open", "closed" ] ]; $Failed,
        Replace[
          Map[ pair |-> With[ { startW = coerce @ pair[[ 1 ]], targetW = coerce @ pair[[ 2 ]] },
              Which[
                startW === targetW, { { startW } },
                ! freeHom && First @ startW =!= First @ targetW, { },
                ! closedQ && ! freeHom && Last @ startW =!= Last @ targetW, { },
                True,
                  With[ {
                      faces = Replace[ OptionValue[ FindInfraHomotopy, { opts }, "NullHomotopicCycles" ], k_Integer :> Range[ k ] ],
                      maxMoves = OptionValue[ FindInfraHomotopy, { opts }, "MaxMoves" ],
                      spec = OptionValue[ FindInfraHomotopy, { opts }, Method ] /. Automatic -> "Exhaustive" },
                    { lengthsQ = AllTrue[ faces, IntegerQ ] },
                    { dupQ  = If[ lengthsQ, MemberQ[ faces, 1 ], AnyTrue[ faces, Length[ # ] == 1 & ] ],
                      spurQ = If[ lengthsQ, MemberQ[ faces, 2 ], AnyTrue[ faces, Length[ # ] == 2 & ] ],
                      cycles = If[ lengthsQ,
                        Catenate[ Map[ First, FindCycle[ graph, { # }, All ], { 2 } ] & /@ Select[ faces, # >= 3 & ] ],
                        Select[ faces, Length[ # ] >= 3 & ] ] },
                    { maxLen = OptionValue[ FindInfraHomotopy, { opts }, "MaxLength" ] /.
                        Automatic :> Max[ Length @ startW, Length @ targetW ] + 2 * Max[ 3, Length /@ cycles ],
                      (* a face (f_1, ..., f_k) read either way round: each cut (s, L) trades the L edges from slot s + 1 for the complementary k - L edges, reversed *)
                      faceMoves = Catenate @ Map[
                        face |-> DeleteDuplicates @ Select[
                          Flatten[ Table[ { c[[ s + 1 ;; s + L + 1 ]], Reverse @ c[[ s + L + 1 ;; s + Length @ face + 1 ]] },
                            { c, { Join[ face, face ], Join[ Reverse @ face, Reverse @ face ] } },
                            { s, 0, Length @ face - 1 }, { L, 0, Length @ face } ], 2 ],
                          #[[ 1 ]] =!= #[[ 2 ]] & ],
                        cycles ] },
                    { moves = p |-> DeleteDuplicates @ Join[
                        If[ dupQ, Join[
                          Table[ Insert[ p, p[[ i ]], i + 1 ], { i, Length @ p } ],
                          Cases[ Range[ Length @ p - 1 ], i_ /; p[[ i ]] === p[[ i + 1 ]] :> Drop[ p, { i + 1 } ] ] ], { } ],
                        If[ spurQ, Join[
                          Catenate @ Table[ ( Join[ p[[ ;; i ]], { #, p[[ i ]] }, p[[ i + 1 ;; ]] ] & ) /@ DeleteCases[ vN[ p[[ i ]] ], p[[ i ]] ],
                            { i, Length @ p } ],
                          Cases[ Range[ Length @ p - 2 ], i_ /; p[[ i ]] === p[[ i + 2 ]] :> Drop[ p, { i + 1, i + 2 } ] ] ], { } ],
                        Catenate @ Map[ mv |-> Table[
                            If[ p[[ i ;; i + Length @ mv[[ 1 ]] - 1 ]] === mv[[ 1 ]],
                              Join[ p[[ ;; i - 1 ]], mv[[ 2 ]], p[[ i + Length @ mv[[ 1 ]] ;; ]] ], Nothing ],
                            { i, Length @ p - Length @ mv[[ 1 ]] + 1 } ], faceMoves ],
                        If[ slides && Length @ p > 0, Join[
                          Append[ p, # ] & /@ vN[ Last @ p ],
                          Prepend[ p, # ] & /@ vN[ First @ p ],
                          If[ Length @ p >= 2, { Most @ p, Rest @ p }, { } ] ], { } ] ] },
                    (* a free loop is moved from every base point of its closed walk, so no rotation-anchored face move is missed *)
                    { neighboursOf = If[ canonicalize,
                        p |-> Catenate[ moves /@ ( lp |-> If[ Length @ lp <= 1, { lp },
                            DeleteDuplicates @ Table[ ( r |-> Append[ r, First @ r ] ) @ RotateLeft[ Most @ lp, k ], { k, 0, Length @ lp - 2 } ] ] ) @
                          closeUp @ p ],
                        moves ],
                      score = w |-> ( dMat |-> Max[ Min /@ dMat, Min /@ Transpose @ dMat ] ) @
                        Outer[ GraphDistance[ graph, #1, #2 ] &, DeleteDuplicates @ w, DeleteDuplicates @ targetW ] },
                    Switch[ Replace[ spec, { mm_String, ___ } :> mm ],
                      "Exhaustive",
                        parent = <| startW -> None |>; frontier = { startW }; found = False; layer = 0;
                        While[ ! found && frontier =!= { } && layer < maxMoves,
                          next = { };
                          Scan[ p |-> Scan[ q |-> If[ ! KeyExistsQ[ parent, q ] && Length @ q <= maxLen,
                                parent[ q ] = p; AppendTo[ next, q ]; If[ q === targetW, found = True ] ],
                              canon /@ neighboursOf @ p ],
                            frontier ];
                          frontier = next; layer++ ];
                        If[ found, { Reverse @ Most @ NestWhileList[ parent, targetW, # =!= None & ] }, { } ],
                      "Greedy",
                        current = canon @ startW; chain = { current }; visited = <| current -> True |>; steps = 0;
                        While[ steps < maxMoves && current =!= targetW,
                          nbrs = Select[ DeleteDuplicates[ canon /@ neighboursOf @ current ],
                            ! KeyExistsQ[ visited, # ] && Length @ # <= maxLen & ];
                          If[ nbrs === { }, Break[ ] ];
                          best = First @ SortBy[ nbrs, { score, Length, Identity } ];
                          If[ score @ best >= score @ current && best =!= targetW, Break[ ] ];
                          AppendTo[ chain, best ]; visited[ best ] = True; current = best; steps++ ];
                        If[ Last @ chain =!= targetW, { }, { chain } ],
                      _,
                        Message[ FindInfraHomotopy::badmethod, spec ]; $Failed ] ] ] ],
            Tuples[ { spread @ a, spread @ b } ] ],
          { r_ /; MemberQ[ r, $Failed ] :> $Failed,
            r_ :> With[ { reps = DeleteDuplicates[ Map[ shape, DeleteDuplicates @ Flatten[ r, 1 ], { 2 } ] ] },
              Switch[ count,
                Automatic, First[ reps, { } ],
                All,       reps,
                _UpTo,     Take[ reps, count ],
                _,         If[ Length @ reps < count, $Failed, Take[ reps, count ] ] ] ] } ] ] ] ]


(* ===================== FindInfraHomotopyRepresentativeHomotopy ===================== *)


Options[ FindInfraHomotopyRepresentativeHomotopy ] = {
  Method                -> "Exhaustive",
  "FreeHomotopy"        -> False,
  "NullHomotopicCycles" -> { 1, 2, 3 },
  "MaxLength"           -> Automatic,
  "MaxMoves"            -> Infinity
};

(* the chains obj -> ... -> m ending at the length-shortest walks m of obj's class, read off the exhausted breadth-first search of walk-space within "MaxLength" *)
FindInfraHomotopyRepresentativeHomotopy[ graph_Graph, obj_,
    count : ( _Integer | UpTo[ _Integer ] | All ) : Automatic, opts : OptionsPattern[] ] :=
  Module[ { parent, frontier, next, layer },
    With[ {
        closedOf = x |-> Replace[ x, { w_Graph | { w_Graph, ___Graph } :> ! LoopFreeGraphQ @ w || ! AcyclicGraphQ @ w, _ -> False } ],
        walksOf = w |-> With[ { vs = VertexList @ w },
          { spelled = AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
            scan = v |-> Reap[ DepthFirstScan[ w, v, { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] },
          Which[
            vs === { }, { },
            ! LoopFreeGraphQ @ w || ! AcyclicGraphQ @ w,
              { If[ First @ # === Last @ #, #, Append[ #, First @ # ] ] & @
                  If[ spelled, Last /@ SortBy[ vs, First ], scan @ First @ vs ] },
            spelled,            { Last /@ SortBy[ vs, First ] },
            EdgeCount @ w == 0, List /@ vs,
            DirectedGraphQ @ w,
              Catenate @ Catenate @ Table[ FindPath[ w, s, t, Infinity, All ],
                { s, Select[ vs, VertexInDegree[ w, # ] == 0 & ] }, { t, Select[ vs, VertexOutDegree[ w, # ] == 0 & ] } ],
            True, { scan @ SelectFirst[ vs, VertexDegree[ w, # ] == 1 &, First @ vs ] } ] ],
        freeHom = TrueQ @ OptionValue[ FindInfraHomotopyRepresentativeHomotopy, { opts }, "FreeHomotopy" ],
        faces = Replace[ OptionValue[ FindInfraHomotopyRepresentativeHomotopy, { opts }, "NullHomotopicCycles" ], k_Integer :> Range[ k ] ],
        maxMoves = OptionValue[ FindInfraHomotopyRepresentativeHomotopy, { opts }, "MaxMoves" ],
        vN = AssociationMap[ AdjacencyList[ graph, # ] &, VertexList @ graph ],
        closeUp = w |-> If[ First @ w === Last @ w, w, Append[ w, First @ w ] ],
        canonical = w |-> If[ Length @ w <= 1, w,
          ( core |-> First @ Sort @ Table[ RotateLeft[ core, k ], { k, 0, Length @ core - 1 } ] ) @
            If[ First @ w === Last @ w, Most @ w, w ] ] },
      { closedQ = closedOf @ obj,
        spread = x |-> Which[
          AssociationQ @ x,             Keys @ x,
          GraphQ @ x,                   walksOf @ x,
          MatchQ[ x, { __Graph } ],     Catenate[ walksOf /@ x ],
          x === { },                    { },
          True,                         { x } ],
        lengthsQ = AllTrue[ faces, IntegerQ ] },
      { slides = ! closedQ && freeHom,
        canonicalize = closedQ && freeHom,
        shape = If[ closedQ,
          w |-> ( core |-> Graph[ core, DirectedEdge @@@ Partition[ core, 2, 1, 1 ] ] ) @
            MapIndexed[ { First @ #2, #1 } &, If[ Length @ w >= 2 && First @ w === Last @ w, Most @ w, w ] ],
          w |-> PathGraph[ MapIndexed[ { First @ #2, #1 } &, w ], DirectedEdges -> True ] ],
        dupQ  = If[ lengthsQ, MemberQ[ faces, 1 ], AnyTrue[ faces, Length[ # ] == 1 & ] ],
        spurQ = If[ lengthsQ, MemberQ[ faces, 2 ], AnyTrue[ faces, Length[ # ] == 2 & ] ],
        cycles = If[ lengthsQ,
          Catenate[ Map[ First, FindCycle[ graph, { # }, All ], { 2 } ] & /@ Select[ faces, # >= 3 & ] ],
          Select[ faces, Length[ # ] >= 3 & ] ] },
      { canon = If[ canonicalize, canonical, Identity ],
        coerce = w |-> Which[ canonicalize, canonical @ w, closedQ, closeUp @ w, True, w ],
        (* a face (f_1, ..., f_k) read either way round: each cut (s, L) trades the L edges from slot s + 1 for the complementary k - L edges, reversed *)
        faceMoves = Catenate @ Map[
          face |-> DeleteDuplicates @ Select[
            Flatten[ Table[ { c[[ s + 1 ;; s + L + 1 ]], Reverse @ c[[ s + L + 1 ;; s + Length @ face + 1 ]] },
              { c, { Join[ face, face ], Join[ Reverse @ face, Reverse @ face ] } },
              { s, 0, Length @ face - 1 }, { L, 0, Length @ face } ], 2 ],
            #[[ 1 ]] =!= #[[ 2 ]] & ],
          cycles ] },
      { moves = p |-> DeleteDuplicates @ Join[
          If[ dupQ, Join[
            Table[ Insert[ p, p[[ i ]], i + 1 ], { i, Length @ p } ],
            Cases[ Range[ Length @ p - 1 ], i_ /; p[[ i ]] === p[[ i + 1 ]] :> Drop[ p, { i + 1 } ] ] ], { } ],
          If[ spurQ, Join[
            Catenate @ Table[ ( Join[ p[[ ;; i ]], { #, p[[ i ]] }, p[[ i + 1 ;; ]] ] & ) /@ DeleteCases[ vN[ p[[ i ]] ], p[[ i ]] ],
              { i, Length @ p } ],
            Cases[ Range[ Length @ p - 2 ], i_ /; p[[ i ]] === p[[ i + 2 ]] :> Drop[ p, { i + 1, i + 2 } ] ] ], { } ],
          Catenate @ Map[ mv |-> Table[
              If[ p[[ i ;; i + Length @ mv[[ 1 ]] - 1 ]] === mv[[ 1 ]],
                Join[ p[[ ;; i - 1 ]], mv[[ 2 ]], p[[ i + Length @ mv[[ 1 ]] ;; ]] ], Nothing ],
              { i, Length @ p - Length @ mv[[ 1 ]] + 1 } ], faceMoves ],
          If[ slides && Length @ p > 0, Join[
            Append[ p, # ] & /@ vN[ Last @ p ],
            Prepend[ p, # ] & /@ vN[ First @ p ],
            If[ Length @ p >= 2, { Most @ p, Rest @ p }, { } ] ], { } ] ] },
      (* a free loop is moved from every base point of its closed walk, so no rotation-anchored face move is missed *)
      { neighboursOf = If[ canonicalize,
          p |-> Catenate[ moves /@ ( lp |-> If[ Length @ lp <= 1, { lp },
              DeleteDuplicates @ Table[ ( r |-> Append[ r, First @ r ] ) @ RotateLeft[ Most @ lp, k ], { k, 0, Length @ lp - 2 } ] ] ) @
            closeUp @ p ],
          moves ] },
      With[ { reps = DeleteDuplicates[ Map[ shape, DeleteDuplicates @ Catenate @ Map[
          walk |-> With[ { startW = coerce @ walk },
            { maxLen = OptionValue[ FindInfraHomotopyRepresentativeHomotopy, { opts }, "MaxLength" ] /.
                Automatic :> Length @ startW + 2 * Max[ 3, Length /@ cycles ] },
            parent = <| startW -> None |>; frontier = { startW }; layer = 0;
            While[ frontier =!= { } && layer < maxMoves,
              next = { };
              Scan[ p |-> Scan[ q |-> If[ ! KeyExistsQ[ parent, q ] && Length @ q <= maxLen,
                    parent[ q ] = p; AppendTo[ next, q ] ],
                  canon /@ neighboursOf @ p ],
                frontier ];
              frontier = next; layer++ ];
            With[ { minLen = Min[ Length /@ Keys @ parent ] },
              Map[ m |-> Reverse @ Most @ NestWhileList[ parent, m, # =!= None & ],
                Select[ Keys @ parent, Length @ # == minLen & ] ] ] ],
          spread @ obj ], { 2 } ] ] },
        Switch[ count,
          Automatic, First[ reps, { } ],
          All,       reps,
          _UpTo,     Take[ reps, count ],
          _,         If[ Length @ reps < count, $Failed, Take[ reps, count ] ] ] ] ] ]


(* ===================== FindInfraHomotopyRepresentative ===================== *)


Options[ FindInfraHomotopyRepresentative ] = {
  Method                -> "Exhaustive",
  "FreeHomotopy"        -> False,
  "NullHomotopicCycles" -> { 1, 2, 3 },
  "MaxLength"           -> Automatic,
  "MaxMoves"            -> Infinity
};

(* the length-shortest walks of obj's homotopy class, the ends of its representative chains, in the shape obj had *)
FindInfraHomotopyRepresentative[ graph_Graph, obj_,
    count : ( _Integer | UpTo[ _Integer ] | All ) : All, opts : OptionsPattern[] ] :=
  With[ { reps = DeleteDuplicates[ Last /@ FindInfraHomotopyRepresentativeHomotopy[ graph, obj, All, opts ] ] },
    Switch[ count,
      Automatic, First[ reps, { } ],
      All,       reps,
      _UpTo,     Take[ reps, count ],
      _,         If[ Length @ reps < count, $Failed, Take[ reps, count ] ] ] ]


(* ===================== HomotopicQ ===================== *)


HomotopicQ::mismatch = FindInfraHomotopy::mismatch;

Options[ HomotopicQ ] = {
  Method                -> "Exhaustive",
  "FreeHomotopy"        -> False,
  "NullHomotopicCycles" -> { 1, 2, 3 },
  "MaxLength"           -> Automatic,
  "MaxMoves"            -> Infinity
};

(* every realisation of a is homotopic to every realisation of b: the breadth-first search of FindInfraHomotopy reaches it, a closed realisation passed as the cycle on its closed walk *)
HomotopicQ[ graph_Graph, a_, b_, opts : OptionsPattern[] ] :=
  With[ {
      closedOf = x |-> Replace[ x, { w_Graph | { w_Graph, ___Graph } :> ! LoopFreeGraphQ @ w || ! AcyclicGraphQ @ w, _ -> False } ],
      walksOf = w |-> With[ { vs = VertexList @ w },
        { spelled = AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
          scan = v |-> Reap[ DepthFirstScan[ w, v, { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] },
        Which[
          vs === { }, { },
          ! LoopFreeGraphQ @ w || ! AcyclicGraphQ @ w,
            { If[ First @ # === Last @ #, #, Append[ #, First @ # ] ] & @
                If[ spelled, Last /@ SortBy[ vs, First ], scan @ First @ vs ] },
          spelled,            { Last /@ SortBy[ vs, First ] },
          EdgeCount @ w == 0, List /@ vs,
          DirectedGraphQ @ w,
            Catenate @ Catenate @ Table[ FindPath[ w, s, t, Infinity, All ],
              { s, Select[ vs, VertexInDegree[ w, # ] == 0 & ] }, { t, Select[ vs, VertexOutDegree[ w, # ] == 0 & ] } ],
          True, { scan @ SelectFirst[ vs, VertexDegree[ w, # ] == 1 &, First @ vs ] } ] ],
      loopOf = w |-> ( core |-> Graph[ core, DirectedEdge @@@ Partition[ core, 2, 1, 1 ] ] ) @
        MapIndexed[ { First @ #2, #1 } &, If[ First @ w === Last @ w, w, Append[ w, First @ w ] ] ] },
    { closedQ = closedOf @ a,
      spread = x |-> Which[
        AssociationQ @ x,             Keys @ x,
        GraphQ @ x,                   walksOf @ x,
        MatchQ[ x, { __Graph } ],     Catenate[ walksOf /@ x ],
        x === { },                    { },
        True,                         { x } ] },
    If[ closedQ =!= closedOf @ b,
      Message[ HomotopicQ::mismatch, If[ closedQ, "closed", "open" ], If[ closedQ, "open", "closed" ] ]; $Failed,
      AllTrue[ Tuples[ { spread @ a, spread @ b } ],
        pair |-> MatchQ[ pair, { _List, _List } ] &&
          FindInfraHomotopy[ graph, Sequence @@ If[ closedQ, loopOf /@ pair, pair ], Method -> "Exhaustive", opts ] =!= { } ] ] ]


(* ===================== NullHomotopicQ ===================== *)

(* a closed walk is null-homotopic iff it is homotopic, as a based loop, to the constant walk at its base point; a vertex list or an open walk graph is read as closed *)

Options[ NullHomotopicQ ] = {
  Method                -> "Exhaustive",
  "FreeHomotopy"        -> False,
  "NullHomotopicCycles" -> { 1, 2, 3 },
  "MaxLength"           -> Automatic,
  "MaxMoves"            -> Infinity
};

NullHomotopicQ[ graph_Graph, cycle_List, opts : OptionsPattern[] ] :=
  With[ { loop = walk |-> ( core |-> Graph[ core, DirectedEdge @@@ Partition[ core, 2, 1, 1 ] ] ) @
            MapIndexed[ { First @ #2, #1 } &, If[ Length @ walk >= 2 && First @ walk === Last @ walk, Most @ walk, walk ] ] },
    HomotopicQ[ graph, loop @ cycle, loop @ { First @ cycle }, opts ] ]

NullHomotopicQ[ graph_Graph, ws : { __Graph }, opts : OptionsPattern[] ] :=
  AllTrue[ ws, NullHomotopicQ[ graph, #, opts ] & ]

NullHomotopicQ[ graph_Graph, w_Graph, opts : OptionsPattern[] ] :=
  AllTrue[
    With[ { vs = VertexList @ w },
      { spelled = AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
        scan = v |-> Reap[ DepthFirstScan[ w, v, { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] },
      Which[
        vs === { }, { },
        ! LoopFreeGraphQ @ w || ! AcyclicGraphQ @ w,
          { If[ First @ # === Last @ #, #, Append[ #, First @ # ] ] & @
              If[ spelled, Last /@ SortBy[ vs, First ], scan @ First @ vs ] },
        spelled,            { Last /@ SortBy[ vs, First ] },
        EdgeCount @ w == 0, List /@ vs,
        DirectedGraphQ @ w,
          Catenate @ Catenate @ Table[ FindPath[ w, s, t, Infinity, All ],
            { s, Select[ vs, VertexInDegree[ w, # ] == 0 & ] }, { t, Select[ vs, VertexOutDegree[ w, # ] == 0 & ] } ],
        True, { scan @ SelectFirst[ vs, VertexDegree[ w, # ] == 1 &, First @ vs ] } ] ],
    NullHomotopicQ[ graph, #, opts ] & ]


(* ===================== Move classification ===================== *)

(* an elementary move replaces one arc of a cycle by the complementary one, so it changes walk length by |newArc| - |oldArc| *)

HomotopyMoveType[ walk1_List, walk2_List ] :=
  Which[
    Length[ walk2 ] < Length[ walk1 ], "Contract",
    Length[ walk2 ] > Length[ walk1 ], "Extend",
    True,                              "Lateral"
  ]

(* a walk graph carries one vertex per position of its sequence -- the cyclic core when it is closed, which shifts both lengths by one and so leaves the comparison alone *)
HomotopyMoveType[ w1_Graph, w2_Graph ] :=
  HomotopyMoveType[ VertexList @ w1, VertexList @ w2 ]

(* one chain -- of walk graphs, or of bare vertex lists -- gives its move sequence; a List of chains gives one sequence each.  The rows are ordered rather than left to DownValue sorting: a List of chains is itself a List of Lists, so it satisfies the vertex-list row too *)
HomotopyMoveTypes[ arg_List ] := Which[
  MatchQ[ arg, { __Graph } ],           MapThread[ HomotopyMoveType, { Most @ arg, Rest @ arg } ],
  MatchQ[ arg, { { __Graph } .. } ],    HomotopyMoveTypes /@ arg,
  AllTrue[ arg, MatchQ[ _List ] ],      MapThread[ HomotopyMoveType, { Most @ arg, Rest @ arg } ],
  True,                                 $Failed ]
