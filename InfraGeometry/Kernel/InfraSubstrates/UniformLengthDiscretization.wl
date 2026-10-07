Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: InfraSubstrates :: UniformLengthDiscretization *)

Options[ UniformLengthGraph ] = {
	"ContactTolerance" -> 0.25,
	"InitialPoints" -> Automatic,
	"KeepCoordinates" -> False,
	MaxIterations -> 200,
	Tolerance -> 10.^-6
}

UniformLengthGraph[ region_ ? RegionQ, h_ ? Positive, opts : OptionsPattern[] ] :=
  With[
    {
      points = If[ RegionDimension[ region ] === 1,
        With[
          { mesh = DiscretizeRegion[ region, MaxCellMeasure -> { 1 -> h / 20 }, AccuracyGoal -> Log10[ 1000 / h ] ] },
          { cells = MeshCells[ mesh, 1 ][[ All, 1 ]] },
          { chainGraph = Graph[ UndirectedEdge @@@ cells ] },
          { ends = Pick[ VertexList[ chainGraph ], VertexDegree[ chainGraph ], 1 ] },
          {
            chain = MeshCoordinates[ mesh ][[ If[ ends === { },
              Append[ #, First[ # ] ] & @ FindShortestPath[ EdgeDelete[ chainGraph, UndirectedEdge @@ First[ cells ] ], Sequence @@ First[ cells ] ],
              FindShortestPath[ chainGraph, First[ ends ], Last[ ends ] ]
            ] ]]
          },
          { arclength = Prepend[ Accumulate[ EuclideanDistance @@@ Partition[ chain, 2, 1 ] ], 0. ] },
          { count = Max[ 1, Round[ Last[ arclength ] / h ] ] },
          Interpolation[ Transpose[ { arclength, chain } ], InterpolationOrder -> 1 ] /@
            ( Last[ arclength ] If[ ends === { }, Range[ 0, count - 1 ], Range[ 0, count ] ] / count )
        ],
        NestWhile[
          pts |-> With[
            { neighbors = Nearest[ pts -> "Index" ][ pts, { Infinity, h } ] },
            {
              groups = GroupBy[
                Catenate @ Catenate @ Table[
                  With[ { v = pts[[ i ]] - pts[[ j ]], dist = EuclideanDistance[ pts[[ i ]], pts[[ j ]] ] },
                    If[ 10. ^ -12 < dist < h,
                      With[ { delta = 0.5 ( h - dist ) v / dist }, { i -> delta, j -> -delta } ],
                      { }
                    ]
                  ],
                  { i, Length[ pts ] },
                  { j, Select[ neighbors[[ i ]], # > i & ] }
                ],
                First -> Last
              ]
            },
            RegionNearest[ region, pts + Table[ Fold[ Plus, 0. pts[[ i ]], Lookup[ groups, i, { } ] ], { i, Length[ pts ] } ] ]
          ],
          N @ Replace[
            OptionValue[ "InitialPoints" ],
            (* the hexagonal packing gives a sphere of diameter h the area Sqrt[3] h^2 / 2 on a surface; in a solid it takes (h / 1.12)^3 *)
            Automatic :> RandomPoint[ region, Max[ 1, Round[ If[ RegionDimension[ region ] === 2,
              2 RegionMeasure[ region ] / ( Sqrt[ 3. ] h ^ 2 ),
              RegionMeasure[ region ] ( 1.12 / h ) ^ 3
            ] ] ] ]
          ],
          Max[ Norm /@ ( #2 - #1 ) ] >= OptionValue[ Tolerance ] &,
          2,
          OptionValue[ MaxIterations ]
        ]
      ]
    },
    With[ { nf = Nearest[ points -> "Index" ], band = h OptionValue[ "ContactTolerance" ] },
      {
        graph = Graph[
          Range[ Length[ points ] ],
          Catenate @ Table[
            UndirectedEdge[ i, # ] & /@ Select[
              nf[ points[[ i ]], { Infinity, h + band } ],
              # > i && Abs[ EuclideanDistance[ points[[ i ]], points[[ # ]] ] - h ] <= band &
            ],
            { i, Length[ points ] }
          ],
          VertexCoordinates -> points
        ]
      },
      If[ OptionValue[ "KeepCoordinates" ], graph, Graph[ graph, VertexCoordinates -> Automatic ] ]
    ]
  ]

Options[ UniformLengthEmbedding ] = {
	"Dimension" -> 3,
	"MaxIterations" -> 500,
	"Tolerance" -> 10.^-7,
	"NonEdgeRepulsion" -> 0.,
	"MaxStepPerVertex" -> 0.15,
	"InitialEmbedding" -> Automatic
}

(* embedding f : V -> R^d realising every edge as a unit segment, by edge-spring relaxation
   from a spring-electrical start; returns coordinates in VertexList order (cf. GraphEmbedding).
   The declarative counterpart is ComplexEmbedding *)
UniformLengthEmbedding[ graph_ ? GraphQ, opts : OptionsPattern[] ] :=
  With[
    {
      dim = OptionValue[ "Dimension" ],
      tol = OptionValue[ "Tolerance" ],
      repulse = OptionValue[ "NonEdgeRepulsion" ],
      maxStep = OptionValue[ "MaxStepPerVertex" ],
      init = OptionValue[ "InitialEmbedding" ],
      vlist = VertexList[ graph ],
      accumulate = { zero, contributions } |-> With[
        { groups = GroupBy[ contributions, First -> Last ] },
        Table[ Fold[ Plus, zero[[ i ]], Lookup[ groups, i, { } ] ], { i, Length[ zero ] } ]
      ]
    },
    { vIdx = AssociationThread[ vlist -> Range[ Length[ vlist ] ] ] },
    { edges = { vIdx[ #[[ 1 ]] ], vIdx[ #[[ 2 ]] ] } & /@ EdgeList[ graph ] },
    { start = N @ If[ init === Automatic, GraphEmbedding[ graph, "SpringElectricalEmbedding", dim ], init ] },
    { jittered = If[ dim == 3 && Max[ Abs[ start[[ All, 3 ]] ] ] < 10. ^ -6, start + RandomReal[ { -0.01, 0.01 }, Dimensions[ start ] ], start ] },
    {
      scaled = With[ { m = Mean[ EuclideanDistance[ jittered[[ #[[ 1 ]] ]], jittered[[ #[[ 2 ]] ]] ] & /@ edges ] },
        If[ m > 10. ^ -12, Divide[ jittered, m ], jittered ]
      ]
    },
    NestWhile[
      points |-> With[
        {
          spring = accumulate[
            0. points,
            Catenate @ Table[
              With[ { e1 = edges[[ k, 1 ]], e2 = edges[[ k, 2 ]], v = points[[ edges[[ k, 1 ]] ]] - points[[ edges[[ k, 2 ]] ]] },
                With[ { dist = Norm[ v ] },
                  If[ dist > 10. ^ -12,
                    With[ { delta = 0.5 ( 1. - dist ) v / dist }, { e1 -> delta, e2 -> -delta } ],
                    { }
                  ]
                ]
              ],
              { k, Length[ edges ] }
            ]
          ]
        },
        {
          d = If[ repulse > 0.,
            spring + With[
              { es = AssociationThread[ Sort /@ edges -> True ], neighbors = Nearest[ points -> "Index" ][ points, { Infinity, 0.9 } ] },
              accumulate[
                0. points,
                Catenate @ Catenate @ Table[
                  If[ j > i && ! KeyExistsQ[ es, Sort[ { i, j } ] ],
                    With[ { v = points[[ i ]] - points[[ j ]], dist = EuclideanDistance[ points[[ i ]], points[[ j ]] ] },
                      If[ 10. ^ -12 < dist < 0.9,
                        With[ { delta = repulse 0.5 ( 0.9 - dist ) v / dist }, { i -> delta, j -> -delta } ],
                        { }
                      ]
                    ],
                    { }
                  ],
                  { i, Length[ points ] },
                  { j, neighbors[[ i ]] }
                ]
              ]
            ],
            spring
          ]
        },
        points + MapThread[ If[ #2 > maxStep, #1 ( maxStep / #2 ), #1 ] &, { d, Norm /@ d } ]
      ],
      scaled,
      Max[ Norm /@ ( #2 - #1 ) ] >= tol &,
      2,
      OptionValue[ "MaxIterations" ]
    ]
  ]
