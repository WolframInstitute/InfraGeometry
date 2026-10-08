Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: InfraTopology :: BallCover *)

Options[ FindBallCover ] = { Method -> "Exhaustive" }
FindBallCover[ g_Graph, r_ : 1, targets : ( _List | All ) : All, count : ( _Integer | All | UpTo[ _Integer ] ) : 1, opts : OptionsPattern[] ] :=
  With[
    { vs = VertexList[ g ] },
    {
      candmat = If[ targets === All,
        { vs, Map[ Boole[ # <= r ] &, GraphDistanceMatrix[ g ], { 2 } ] },
        With[
          { balls = VertexList[ NeighborhoodGraph[ g, #, r ] ] & /@ targets },
          { cc = Union @@ balls },
          { ix = AssociationThread[ cc, Range @ Length[ cc ] ] },
          {
            cc,
            SparseArray[
              Join @@ MapIndexed[ { ball, i } |-> ( { First[ i ], ix[ # ] } -> 1 & /@ ball ), balls ],
              { Length[ targets ], Length[ cc ] }
            ]
          }
        ]
      ]
    },
    { cand = candmat[[ 1 ]], mat = candmat[[ 2 ]], method = OptionValue[ Method ] },
    {
      one = Switch[ method,
        "Greedy",
        cand[[
          Last @ NestWhile[
            Apply[ { uncov, chosen } |-> With[
              { j = First @ Ordering[ uncov . mat, -1 ] },
              { uncov ( 1 - Normal[ mat[[ All, j ]] ] ), Append[ chosen, j ] }
            ] ],
            { ConstantArray[ 1, Length[ mat ] ], { } },
            Apply[ { uncov, chosen } |-> Total[ uncov ] > 0 ]
          ]
        ]],
        "Symmetric",
        With[
          {
            els = DeleteCases[ GroupElements[ GraphAutomorphismGroup[ g ] ], Cycles[ { } ] ],
            dmat = GraphDistanceMatrix[ g ],
            n = Length[ vs ],
            tIdx = If[ targets === All, Range @ Length[ vs ], Flatten[ FirstPosition[ vs, # ] & /@ targets ] ]
          },
          {
            moved = Select[
              DeleteDuplicates[ Sort /@ Flatten[ GroupOrbits[ PermutationGroup[ { # } ], Range[ n ] ] & /@ els, 1 ] ],
              Length[ # ] >= 2 &
            ]
          },
          (* a vertex fixed by every automorphism lies in no moved orbit; it is its own Aut(g) orbit *)
          { orbits = Join[ moved, List /@ Complement[ Range[ n ], Flatten[ moved ] ] ] },
          { m = Length[ orbits ], contain = Table[ Select[ Range @ Length[ orbits ], MemberQ[ orbits[[ # ]], v ] & ], { v, n } ] },
          { y = Array[ \[FormalY], m ], z = Array[ \[FormalZ], n ] },
          {
            sol = LinearOptimization[
              Total[ z ],
              Join[
                Flatten @ Table[ z[[ v ]] >= y[[ k ]], { k, m }, { v, orbits[[ k ]] } ],
                Table[ z[[ v ]] <= Total[ y[[ contain[[ v ]] ]] ], { v, n } ],
                Table[ Total[ z[[ Flatten @ Position[ dmat[[ t ]], d_ /; d <= r ] ]] ] >= 1, { t, tIdx } ],
                Thread[ 0 <= Join[ y, z ] <= 1 ]
              ],
              Join[ y, z ] \[Element] Vectors[ m + n, Integers ]
            ]
          },
          vs[[ Flatten @ Position[ Round[ z /. sol ], 1 ] ]]
        ],
        _,
        With[
          { x = Array[ \[FormalX], Length[ cand ] ] },
          cand[[
            Flatten @ Position[
              Round[
                x /. LinearOptimization[
                  Total[ x ],
                  Join[ Thread[ mat . x >= 1 ], Thread[ 0 <= x <= 1 ] ],
                  x \[Element] Vectors[ Length[ cand ], Integers ]
                ]
              ],
              1
            ]
          ]]
        ]
      ]
    },
    If[ count === 1,
      one,
      With[
        {
          covers = If[ MemberQ[ { "Greedy", "Symmetric" }, method ],
            { one },
            Select[ Subsets[ cand, { Length[ one ] } ], BallCoverQ[ g, r, #, targets ] & ]
          ]
        },
        Replace[ count, { All -> covers, ( n_Integer | UpTo[ n_ ] ) :> Take[ covers, UpTo[ n ] ] } ]
      ]
    ]
  ]

BallCoverQ[ g_Graph, r_, s_List, targets : (_List | All) : All ] :=
    With[
        { vs = VertexList[ g ], dm = GraphDistanceMatrix[ g ] },
        { pos = Flatten[ FirstPosition[ vs, # ] & /@ s ], rows = If[ targets === All, dm, dm[[ Flatten[ FirstPosition[ vs, # ] & /@ targets ] ]] ] },
        AllTrue[ rows, row |-> AnyTrue[ pos, j |-> row[[ j ]] <= r ] ]
    ]

Options[ BallCoverNumber ] = { Method -> "Exhaustive" }
BallCoverNumber[ g_Graph, r_ : 1, targets : ( _List | All ) : All, opts : OptionsPattern[] ] :=
  Length @ FindBallCover[ g, r, targets, Method -> OptionValue[ Method ] ]
