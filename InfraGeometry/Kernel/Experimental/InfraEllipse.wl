Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: Experimental :: InfraEllipse *)

(* an ellipse for foci {p1, p2} is a simple cycle in the induced subgraph on { v : cMin <= d(p1, v) + d(p2, v) <= cMax }, returned as a directed
   cycle graph on the substrate vertices; the count-less call is one ellipse, a bounded count and All a List of them -- closed walks have no acyclic
   union to carry them.  The family is carried by the FindCycle length sweep, which materialises every shorter cycle first; there is no elliptic
   pool, the circle's carrier having no two-focus analogue.  One class under every next-vertex function, which orders or thins the cycles within a
   length grade *)

Options[ RandomInfraEllipse ] = {
  Properties           -> { "Separating", "Shortest" },
  "NextVertexFunction" -> Automatic
}

RandomInfraEllipse[ graph_Graph, foci : { _, _ }, c_,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /; SubsetQ[ First /@ Options[ RandomInfraEllipse ], First /@ { opts } ] &&
    SubsetQ[ { "Separating", "Shortest" }, OptionValue[ RandomInfraEllipse, { opts }, Properties ] ] &&
    ( count =!= All || OptionValue[ RandomInfraEllipse, { opts }, "NextVertexFunction" ] =!= RandomChoice ) :=
  With[ {
      properties = OptionValue[ RandomInfraEllipse, { opts }, Properties ],
      nextFn     = If[ count === All &&
          OptionValue[ RandomInfraEllipse, { opts }, "NextVertexFunction" ] === Automatic,
        Identity, OptionValue[ RandomInfraEllipse, { opts }, "NextVertexFunction" ] ] },
    With[ { branch = cands |-> Which[
              cands === { } || nextFn === Identity, cands,
              nextFn === Automatic, RandomSample @ cands,
              True, Replace[ nextFn @ cands,
                chosen_ /; MemberQ[ cands, Verbatim @ chosen ] :> { chosen } ] ],
            needed = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ] },
      { results = Apply[
          { foci0, c0 } |-> With[ {
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
                        matching = Select[ branch[ First /@ # & /@ FindCycle[ levelGraph, { k }, All ] ], vertsTest ] },
                      If[ matching =!= { } && ( tied || Length[ accumulated ] + Length[ matching ] >= needed ),
                        Throw[ Join[ accumulated, matching ], RandomInfraEllipse ],
                        Join[ accumulated, matching ] ] ],
                    { }, Range[ 3, VertexCount @ levelGraph ] ],
                  RandomInfraEllipse ] ],
          Tuples[ { { foci }, Replace[ c, { fam_Association :> Keys @ fam, other_ :> { other } } ] } ], { 1 } ] },
      With[ { reps = DeleteDuplicates[ Graph[ #, DirectedEdge @@@ Partition[ #, 2, 1, 1 ] ] & /@ DeleteDuplicates @ Flatten[ results, 1 ] ] },
          Switch[ count,
            Automatic, First[ reps, { } ],
            All,       reps,
            _UpTo,     Take[ reps, count ],
            _,         If[ Length @ reps < count, { }, Take[ reps, count ] ] ] ] ] ]

(* cycle is an ellipse iff it is a cyclic path whose vertex set is an elliptic shell, the band InfraQuadric[{p1, p2}, {c, c}] of some foci; a
   pair whose sum is not constant on the cycle is passed over before the band is read *)

InfraEllipseQ[ graph_Graph, ws : { __Graph } ] :=
  AllTrue[ ws, InfraEllipseQ[ graph, # ] & ]

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
    With[ { rows = GraphDistanceMatrix[ graph ][[ All, VertexIndex[ graph, # ] & /@ verts ]], vlist = VertexList @ graph },
      AnyTrue[ Subsets[ Range @ Length @ vlist, { 2 } ],
        Apply[ { i, j } |-> Equal @@ ( rows[[ i ]] + rows[[ j ]] ) &&
          Union @ verts === Keys @ InfraMeasurement[ graph,
            InfraQuadric[ vlist[[ { i, j } ]], { 1, 1 } ( rows[[ i, 1 ]] + rows[[ j, 1 ]] ) ], "VertexDensity" ] ] ] ]
  ]

InfraEllipseQ[ _Graph, cycle_List ] /; Length[ cycle ] < 3 :=
  False

RandomInfraEllipse[ graph_Graph, InfraEllipse[ foci : { _, _ }, level_, geometryOpts___Rule ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic,
    opts : OptionsPattern[] ] /; SubsetQ[ First /@ Options[ RandomInfraEllipse ], First /@ { opts } ] &&
    SubsetQ[ First /@ Options[ RandomInfraEllipse ], First /@ { opts, geometryOpts } ] :=
  RandomInfraEllipse[ graph, foci, level, count, opts, geometryOpts ]
