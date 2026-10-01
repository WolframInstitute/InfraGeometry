Package["WolframInstitute`InfraGeometry`"]

Options[ FindInfraHomotopy ] = {
  Method                -> "Exhaustive",
  "FreeHomotopy"        -> False,
  "NullHomotopicCycles" -> { 1, 2, 3 },
  "MaxLength"           -> Automatic,
  "MaxMoves"            -> Infinity
};

FindInfraHomotopy[ graph_Graph, a_, b_,
    count : ( _Integer | UpTo[ _Integer ] | All ) : Automatic, opts : OptionsPattern[] ] /;
    MatchQ[ OptionValue[ FindInfraHomotopy, { opts }, Method ], Automatic | "Exhaustive" | "Greedy" | { "Exhaustive" | "Greedy", ___ } ] :=
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
                  { neighboursOf = If[ canonicalize,
                      p |-> Catenate[ moves /@ ( lp |-> If[ Length @ lp <= 1, { lp },
                          DeleteDuplicates @ Table[ ( r |-> Append[ r, First @ r ] ) @ RotateLeft[ Most @ lp, k ], { k, 0, Length @ lp - 2 } ] ] ) @
                        closeUp @ p ],
                      moves ],
                    score = w |-> ( dMat |-> Max[ Min /@ dMat, Min /@ Transpose @ dMat ] ) @
                      Outer[ GraphDistance[ graph, #1, #2 ] &, DeleteDuplicates @ w, DeleteDuplicates @ targetW ] },
                  Switch[ Replace[ spec, { mm_String, ___ } :> mm ],
                    "Exhaustive",
                      With[ { parent = First @ NestWhile[
                          state |-> With[ { grown = Fold[
                              { acc, p } |-> Fold[
                                { accp, q } |-> If[ ! KeyExistsQ[ accp, q ] && Length @ q <= maxLen, Append[ accp, q -> p ], accp ],
                                acc,
                                canon /@ neighboursOf @ p ],
                              First @ state,
                              state[[ 2 ]] ] },
                            { grown, Drop[ Keys @ grown, Length @ First @ state ], state[[ 3 ]] + 1 } ],
                          { <| startW -> None |>, { startW }, 0 },
                          state |-> ! KeyExistsQ[ First @ state, targetW ] && state[[ 2 ]] =!= { } && state[[ 3 ]] < maxMoves ] },
                        If[ KeyExistsQ[ parent, targetW ], { Reverse @ Most @ NestWhileList[ parent, targetW, # =!= None & ] }, { } ] ],
                    "Greedy",
                      With[ { chain = First @ NestWhile[
                          state |-> With[ { nbrs = Select[ DeleteDuplicates[ canon /@ neighboursOf @ Last @ First @ state ],
                                ! KeyExistsQ[ state[[ 2 ]], # ] && Length @ # <= maxLen & ] },
                            { best = If[ nbrs === { }, None, First @ SortBy[ nbrs, { score, Length, Identity } ] ] },
                            If[ best === None || score @ best >= score @ Last @ First @ state && best =!= targetW,
                              { First @ state, state[[ 2 ]], True },
                              { Append[ First @ state, best ], Append[ state[[ 2 ]], best -> True ], False } ] ],
                          With[ { current = canon @ startW }, { { current }, <| current -> True |>, False } ],
                          state |-> ! Last @ state && Length @ First @ state - 1 < maxMoves && Last @ First @ state =!= targetW ] },
                        If[ Last @ chain =!= targetW, { }, { chain } ] ] ] ] ] ],
          Tuples[ { spread @ a, spread @ b } ] ],
        r_ :> With[ { reps = DeleteDuplicates[ Map[ shape, DeleteDuplicates @ Flatten[ r, 1 ], { 2 } ] ] },
            Switch[ count,
              Automatic, First[ reps, { } ],
              All,       reps,
              _UpTo,     Take[ reps, count ],
              _,         If[ Length @ reps < count, { }, Take[ reps, count ] ] ] ] ] /; closedQ === closedOf @ b ]

Options[ FindInfraHomotopyRepresentativeHomotopy ] = {
  Method                -> "Exhaustive",
  "FreeHomotopy"        -> False,
  "NullHomotopicCycles" -> { 1, 2, 3 },
  "MaxLength"           -> Automatic,
  "MaxMoves"            -> Infinity
};

FindInfraHomotopyRepresentativeHomotopy[ graph_Graph, obj_,
    count : ( _Integer | UpTo[ _Integer ] | All ) : Automatic, opts : OptionsPattern[] ] :=
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
    { neighboursOf = If[ canonicalize,
        p |-> Catenate[ moves /@ ( lp |-> If[ Length @ lp <= 1, { lp },
            DeleteDuplicates @ Table[ ( r |-> Append[ r, First @ r ] ) @ RotateLeft[ Most @ lp, k ], { k, 0, Length @ lp - 2 } ] ] ) @
          closeUp @ p ],
        moves ] },
    With[ { reps = DeleteDuplicates[ Map[ shape, DeleteDuplicates @ Catenate @ Map[
        walk |-> With[ { startW = coerce @ walk },
          { maxLen = OptionValue[ FindInfraHomotopyRepresentativeHomotopy, { opts }, "MaxLength" ] /.
              Automatic :> Length @ startW + 2 * Max[ 3, Length /@ cycles ] },
          { parent = First @ NestWhile[
              state |-> With[ { grown = Fold[
                  { acc, p } |-> Fold[
                    { accp, q } |-> If[ ! KeyExistsQ[ accp, q ] && Length @ q <= maxLen, Append[ accp, q -> p ], accp ],
                    acc,
                    canon /@ neighboursOf @ p ],
                  First @ state,
                  state[[ 2 ]] ] },
                { grown, Drop[ Keys @ grown, Length @ First @ state ], state[[ 3 ]] + 1 } ],
              { <| startW -> None |>, { startW }, 0 },
              state |-> state[[ 2 ]] =!= { } && state[[ 3 ]] < maxMoves ] },
          With[ { minLen = Min[ Length /@ Keys @ parent ] },
            Map[ m |-> Reverse @ Most @ NestWhileList[ parent, m, # =!= None & ],
              Select[ Keys @ parent, Length @ # == minLen & ] ] ] ],
        spread @ obj ], { 2 } ] ] },
      Switch[ count,
        Automatic, First[ reps, { } ],
        All,       reps,
        _UpTo,     Take[ reps, count ],
        _,         If[ Length @ reps < count, { }, Take[ reps, count ] ] ] ] ]

Options[ FindInfraHomotopyRepresentative ] = {
  Method                -> "Exhaustive",
  "FreeHomotopy"        -> False,
  "NullHomotopicCycles" -> { 1, 2, 3 },
  "MaxLength"           -> Automatic,
  "MaxMoves"            -> Infinity
};

FindInfraHomotopyRepresentative[ graph_Graph, obj_,
    count : ( _Integer | UpTo[ _Integer ] | All ) : All, opts : OptionsPattern[] ] :=
  With[ { reps = DeleteDuplicates[ Last /@ FindInfraHomotopyRepresentativeHomotopy[ graph, obj, All, opts ] ] },
    Switch[ count,
      Automatic, First[ reps, { } ],
      All,       reps,
      _UpTo,     Take[ reps, count ],
      _,         If[ Length @ reps < count, { }, Take[ reps, count ] ] ] ]

Options[ HomotopicQ ] = {
  Method                -> "Exhaustive",
  "FreeHomotopy"        -> False,
  "NullHomotopicCycles" -> { 1, 2, 3 },
  "MaxLength"           -> Automatic,
  "MaxMoves"            -> Infinity
};

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
    AllTrue[ Tuples[ { spread @ a, spread @ b } ],
        pair |-> MatchQ[ pair, { _List, _List } ] &&
          FindInfraHomotopy[ graph, Sequence @@ If[ closedQ, loopOf /@ pair, pair ], Method -> "Exhaustive", opts ] =!= { } ] /; closedQ === closedOf @ b ]

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

HomotopyMoveType[ walk1_List, walk2_List ] :=
  Which[
    Length[ walk2 ] < Length[ walk1 ], "Contract",
    Length[ walk2 ] > Length[ walk1 ], "Extend",
    True,                              "Lateral"
  ]

HomotopyMoveType[ w1_Graph, w2_Graph ] :=
  HomotopyMoveType[ VertexList @ w1, VertexList @ w2 ]

HomotopyMoveTypes[ arg_List ] /; MatchQ[ arg, { __Graph } | { { __Graph } .. } ] || AllTrue[ arg, MatchQ[ _List ] ] := Which[
  MatchQ[ arg, { __Graph } ],           MapThread[ HomotopyMoveType, { Most @ arg, Rest @ arg } ],
  MatchQ[ arg, { { __Graph } .. } ],    HomotopyMoveTypes /@ arg,
  AllTrue[ arg, MatchQ[ _List ] ],      MapThread[ HomotopyMoveType, { Most @ arg, Rest @ arg } ] ]
