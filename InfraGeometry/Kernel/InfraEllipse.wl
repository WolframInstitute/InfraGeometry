Package["WolframInstitute`InfraGeometry`"]


(* ===================== FindInfraEllipse ===================== *)

(* an ellipse for foci {p1, p2} is a simple cycle in the induced subgraph on { v : cMin <= d(p1, v) + d(p2, v) <= cMax }, returned as a directed cycle graph on the substrate vertices; the count-less call is one ellipse, a bounded count and All a List of them -- closed walks have no acyclic union to carry them.  The family is carried by the FindCycle length sweep, which materialises every shorter cycle first; there is no elliptic pool, the circle's carrier having no two-focus analogue.  One class under every Method: branch orders the ties within a length grade, pruning caps the cycles kept per grade *)

FindInfraEllipse::badproperty = "Property `1` is not supported by FindInfraEllipse.";
FindInfraEllipse::badmethod   = "Method `1` is not supported by FindInfraEllipse.";

Options[ FindInfraEllipse ] = {
  Properties -> { "Separating", "Shortest" },
  Method     -> Automatic
};

FindInfraEllipse[ graph_Graph, foci : { _, _ }, c_,
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] :=
  Catch @ With[ {
      properties = OptionValue[ FindInfraEllipse, { opts }, Properties ],
      methodSpec = Replace[ OptionValue[ FindInfraEllipse, { opts }, Method ], Automatic :> If[ count === All, "Exhaustive", "Greedy" ] ] },
    { methodHead = Replace[ methodSpec, { m_String, ___ } :> m ] },
    If[ ! MatchQ[ methodHead, "Exhaustive" | "Greedy" | "RandomGreedy" ],
      Message[ FindInfraEllipse::badmethod, methodSpec ]; Throw[ $Failed ] ];
    With[ { branch  = If[ methodHead === "RandomGreedy", RandomSample, Identity ],
            pruning = "Pruning" /. Replace[ methodSpec, { { _String, o___ } :> { o }, _ -> { } } ] /. "Pruning" -> Infinity,
            needed  = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ] },
      { results = Apply[
          { foci0, c0 } |-> With[ { unknown = Complement[ properties, { "Separating", "Shortest" } ] },
            If[ unknown =!= { },
              Message[ FindInfraEllipse::badproperty, First @ unknown ]; $Failed,
              With[ {
                  range = Replace[ c0, d_?NumericQ :> { d, d } ],
                  verts = VertexList[ graph ],
                  dm    = GraphDistanceMatrix[ graph ] },
                { idx = AssociationThread[ verts, Range @ Length @ verts ] },
                { sums = dm[[ idx @ foci0[[ 1 ]] ]] + dm[[ idx @ foci0[[ 2 ]] ]] },
                { levelGraph = Subgraph[ graph, Pick[ verts, Thread[ range[[ 1 ]] <= sums <= range[[ 2 ]] ] ] ],
                  nearVerts  = Pick[ verts, Thread[ sums < range[[ 1 ]] ] ],
                  farVerts   = Pick[ verts, Thread[ sums > range[[ 2 ]] ] ] },
                { vertsTest = If[ MemberQ[ properties, "Separating" ],
                    vs |-> nearVerts =!= { } && farVerts =!= { } &&
                           SeparatesQ[ graph, vs, First @ nearVerts, First @ farVerts ],
                    True & ],
                  tied = MemberQ[ properties, "Shortest" ] },
                Catch[
                  Fold[
                    { accumulated, k } |-> With[ {
                        matching = Select[
                          branch @ With[ { cycles = First /@ # & /@ FindCycle[ levelGraph, { k }, All ] },
                            Replace[ pruning, {
                              Infinity      :> cycles,
                              n_Integer     :> If[ Length @ cycles <= n, cycles, RandomSample[ cycles, n ] ],
                              keep_?NumericQ :> If[ cycles === { }, { },
                                With[ { kept = Select[ cycles, RandomReal[ ] < keep & ] },
                                  If[ kept === { }, RandomSample[ cycles, 1 ], kept ] ] ] } ] ],
                          vertsTest ] },
                      If[ matching =!= { } && ( tied || Length[ accumulated ] + Length[ matching ] >= needed ),
                        Throw[ Join[ accumulated, matching ], FindInfraEllipse ],
                        Join[ accumulated, matching ] ] ],
                    { }, Range[ 3, VertexCount @ levelGraph ] ],
                  FindInfraEllipse ] ] ] ],
          Tuples[ { { foci }, Replace[ c, { fam_Association :> Keys @ fam, other_ :> { other } } ] } ], { 1 } ] },
      If[ MemberQ[ results, $Failed ], $Failed,
        With[ { reps = DeleteDuplicates[ Graph[ #, DirectedEdge @@@ Partition[ #, 2, 1, 1 ] ] & /@ DeleteDuplicates @ Flatten[ results, 1 ] ] },
          Switch[ count,
            Automatic, First[ reps, { } ],
            All,       reps,
            _UpTo,     Take[ reps, count ],
            _,         If[ Length @ reps < count, $Failed, Take[ reps, count ] ] ] ] ] ] ]


(* ===================== InfraEllipseQ ===================== *)

(* cycle is an ellipse iff it is a cyclic path whose vertex set is an elliptic shell. *)

InfraEllipseQ[ graph_Graph, ws : { __Graph } ] := AllTrue[ ws, InfraEllipseQ[ graph, # ] & ]

InfraEllipseQ[ graph_Graph, w_Graph ] :=
  With[ { vs = VertexList @ w },
    { spelled = AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
      scan = v |-> Reap[ DepthFirstScan[ w, v, { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] },
    AllTrue[
      Which[
        ! LoopFreeGraphQ @ w || ! AcyclicGraphQ @ w,
          { If[ First @ # === Last @ #, #, Append[ #, First @ # ] ] & @
              If[ spelled, Last /@ SortBy[ vs, First ], scan @ First @ vs ] },
        EdgeCount @ w == 0, List /@ If[ spelled, Last /@ vs, vs ],
        spelled,            { Last /@ SortBy[ vs, First ] },
        DirectedGraphQ @ w,
          Catenate @ Catenate @ Table[ FindPath[ w, s, t, Infinity, All ],
            { s, Select[ vs, VertexInDegree[ w, # ] == 0 & ] }, { t, Select[ vs, VertexOutDegree[ w, # ] == 0 & ] } ],
        True, { scan @ SelectFirst[ vs, VertexDegree[ w, # ] == 1 &, First @ vs ] } ],
      InfraEllipseQ[ graph, # ] & ] ]

InfraEllipseQ[ graph_Graph, cycle_List ] /; Length[ cycle ] >= 3 :=
  With[ {
      closed = If[ First @ cycle === Last @ cycle, cycle, Append[ cycle, First @ cycle ] ] },
    { verts = Most @ closed,
      pairs = Partition[ closed, 2, 1 ] },
    DuplicateFreeQ[ verts ] &&
    AllTrue[ pairs, EdgeQ[ graph, UndirectedEdge @@ # ] & ] &&
    InfraEllipticShellQ[ graph, verts ]
  ]

InfraEllipseQ[ _Graph, cycle_List ] /; Length[ cycle ] < 3 := False
