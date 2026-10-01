Package["WolframInstitute`InfraGeometry`"]

SameDirectionQ[ graph_Graph, O_, v_, w_ ] :=
  v === w || AnyTrue[ FindInfraRay[ graph, O, v, All ], MemberQ[ #, w ] & ]

CollinearQ[ graph_Graph, verts_List ] :=
  Length[ DeleteDuplicates @ verts ] <= 1 ||
    FindInfraCommonLine[ graph, verts, UpTo[ 1 ] ] =!= { }

ConcurrentQ[ graph_Graph, lines_List ] :=
  Length[ lines ] <= 1 ||
    Length[ FindInfraCommonPoint[ graph, lines, UpTo[ 1 ] ] ] > 0

UniqueCollinearQ[ graph_Graph, verts_List ] :=
  Length @ FindInfraCommonLine[ graph, verts, UpTo[ 2 ] ] == 1

UniqueConcurrentQ[ graph_Graph, lines_List ] :=
  Length[ FindInfraCommonPoint[ graph, lines, All ] ] == 1

WhiteheadW1Q[ graph_Graph ] :=
  AllTrue[
    DeleteDuplicates @ Catenate[
      ( pair |-> ( l |-> First @ Sort @ { l, Reverse[ l ] } ) /@
          FindInfraLine[ graph, pair[[ 1 ]], pair[[ 2 ]], All ] ) /@
        Subsets[ VertexList @ graph, { 2 } ] ],
    Length[ # ] >= 3 & ]

WhiteheadW2Q[ graph_Graph ] :=
  AllTrue[ Subsets[ VertexList[ graph ], { 2 } ],
    UniqueCollinearQ[ graph, # ] & ]

WhiteheadW3Q[ graph_Graph ] :=
  With[ { verts = VertexList[ graph ],
          linesThrough = { a, b } |-> FindInfraLine[ graph, a, b, All ] },
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

ProjectivePlaneGraphQ[ graph_Graph ] :=
  VertexCount[ graph ] >= 4 &&
    WhiteheadW1Q[ graph ] &&
    WhiteheadW2Q[ graph ] &&
    WhiteheadW3Q[ graph ] &&
    AnyTrue[ Subsets[ VertexList[ graph ], { 4 } ], quad |-> ! AnyTrue[ Subsets[ quad, { 3 } ], CollinearQ[ graph, # ] & ] ]
