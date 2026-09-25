Package["WolframInstitute`SyntheticInfrageometry`"]


(* ===================== Pointwise predicates ===================== *)

(* v, w lie in the same direction at O: some ray from O through v contains w.  On lines this was CollinearQ[graph, {O, v, w}] under another name, and it called the two sides of O one direction *)

SameDirectionQ[ graph_Graph, O_, v_, w_ ] :=
  v === w || AnyTrue[
    Catenate[
      ( dag |-> With[ { paths = Catenate @ Catenate @ Table[ FindPath[ dag, src, snk, Infinity, All ],
          { src, Select[ VertexList @ dag, VertexInDegree[ dag, # ] == 0 & ] },
          { snk, Select[ VertexList @ dag, VertexOutDegree[ dag, # ] == 0 & ] } ] },
        If[ AllTrue[ VertexList @ dag, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ VertexList @ dag ] === Range @ VertexCount @ dag,
          Map[ Last, paths, { 2 } ], paths ] ] ) /@
        Replace[ FindInfraRay[ graph, O, v, All ], dag_Graph :> { dag } ] ],
    MemberQ[ #, w ] & ]


(* some canonical line contains every listed vertex *)

CollinearQ[ graph_Graph, verts_List ] :=
  Length[ DeleteDuplicates @ verts ] <= 1 ||
    FindInfraCommonLine[ graph, verts, UpTo[ 1 ] ] =!= { }


(* the listed lines share a common vertex: the dual of collinearity *)

ConcurrentQ[ graph_Graph, lines_List ] :=
  Length[ lines ] <= 1 ||
    Length[ FindInfraCommonPoint[ graph, lines, UpTo[ 1 ] ] ] > 0



(* exactly one canonical line contains every listed vertex *)

UniqueCollinearQ[ graph_Graph, verts_List ] :=
  Length @ FindInfraCommonLine[ graph, verts, UpTo[ 2 ] ] == 1


(* the listed lines share exactly one common vertex *)

UniqueConcurrentQ[ graph_Graph, lines_List ] :=
  Length[ FindInfraCommonPoint[ graph, lines, All ] ] == 1


(* ===================== Whitehead axioms ===================== *)

(* W1: every line has at least three points.
   W2: through any two distinct vertices passes exactly one line.
   W3: if some line through {A, B} meets some line through {C, D}, then
       some line through {A, C} meets some line through {B, D}.        *)

WhiteheadW1Q[ graph_Graph ] :=
  AllTrue[
    DeleteDuplicates @ Catenate[
      ( pair |-> ( l |-> First @ Sort @ { l, Reverse[ l ] } ) /@ Catenate[
          ( dag |-> With[ { paths = Catenate @ Catenate @ Table[ FindPath[ dag, src, snk, Infinity, All ],
              { src, Select[ VertexList @ dag, VertexInDegree[ dag, # ] == 0 & ] },
              { snk, Select[ VertexList @ dag, VertexOutDegree[ dag, # ] == 0 & ] } ] },
            If[ AllTrue[ VertexList @ dag, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ VertexList @ dag ] === Range @ VertexCount @ dag,
              Map[ Last, paths, { 2 } ], paths ] ] ) /@
            Replace[ FindInfraLine[ graph, pair[[ 1 ]], pair[[ 2 ]], All ], dag_Graph :> { dag } ] ] ) /@
        Subsets[ VertexList @ graph, { 2 } ] ],
    Length[ # ] >= 3 & ]

WhiteheadW2Q[ graph_Graph ] :=
  AllTrue[ Subsets[ VertexList[ graph ], { 2 } ],
    UniqueCollinearQ[ graph, # ] & ]

WhiteheadW3Q[ graph_Graph ] :=
  With[ { verts = VertexList[ graph ],
          linesThrough = { a, b } |-> Catenate[
            ( dag |-> With[ { paths = Catenate @ Catenate @ Table[ FindPath[ dag, src, snk, Infinity, All ],
                { src, Select[ VertexList @ dag, VertexInDegree[ dag, # ] == 0 & ] },
                { snk, Select[ VertexList @ dag, VertexOutDegree[ dag, # ] == 0 & ] } ] },
              If[ AllTrue[ VertexList @ dag, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ VertexList @ dag ] === Range @ VertexCount @ dag,
                Map[ Last, paths, { 2 } ], paths ] ] ) /@
              Replace[ FindInfraLine[ graph, a, b, All ], dag_Graph :> { dag } ] ] },
    AllTrue[ Tuples[ verts, 4 ],
      abcd |-> If[ Length @ DeleteDuplicates @ abcd < 4, True,
        With[ { A = abcd[[ 1 ]], B = abcd[[ 2 ]], C = abcd[[ 3 ]], D = abcd[[ 4 ]] },
          { abLines = linesThrough[ A, B ],
            cdLines = linesThrough[ C, D ] },
          If[ ! AnyTrue[ Tuples[ { abLines, cdLines } ], IntersectingQ @@ # & ],
            True,
            With[ { acLines = linesThrough[ A, C ],
                    bdLines = linesThrough[ B, D ] },
              AnyTrue[ Tuples[ { acLines, bdLines } ], IntersectingQ @@ # & ]
            ]
          ]
        ]
      ]
    ]
  ]


(* W1 + W2 + W3 plus a non-degeneracy witness: four vertices, no three collinear *)

ProjectivePlaneGraphQ[ graph_Graph ] :=
  Module[ { verts },
    verts = VertexList[ graph ];
    Length[ verts ] >= 4 &&
    WhiteheadW1Q[ graph ] &&
    WhiteheadW2Q[ graph ] &&
    WhiteheadW3Q[ graph ] &&
    AnyTrue[ Subsets[ verts, { 4 } ],
      quad |-> ! AnyTrue[ Subsets[ quad, { 3 } ], CollinearQ[ graph, # ] & ]
    ]
  ]
