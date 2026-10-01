Package[ "WolframInstitute`InfraGeometry`" ]

(* The contact graph of a relaxed hard-sphere packing has all edges at exactly 2r:
   two touching spheres of radius r have centers at distance 2r by geometry, not by
   force balance.  UniformLengthGraph packs a region as given -- filling a solid, meshing a
   surface -- and returns that contact graph; UniformLengthEmbedding is the inverse, realising
   an abstract graph in R^d with every edge a unit segment (the iterative sibling of
   the declarative ComplexEmbedding). *)

Options[ UniformLengthGraph ] = {
	Method -> "IterativeProjection",
	"Radius" -> Automatic,
	"MaxIterations" -> 200,
	"Tolerance" -> 10.^-6,
	"ProjectionStep" -> 1.,
	"Overpack" -> 1.,
	"ContactTolerance" -> 0.25,
	"KeepCoordinates" -> False
}

(* unit-length graph of region: contact graph of a relaxed hard-sphere packing of n spheres in
   region, every edge length 2r.  "KeepCoordinates" -> True stores the packing in VertexCoordinates;
   by default the coordinates are dropped.  The automatic radius
   spaces the spheres to tile the region's content C in its own dimension d (2r = C/n on a curve,
   Sqrt[2 C / (n Sqrt[3])] hexagonally on a surface, 1.12 (C/n)^(1/3) in a solid), so the packing
   jams into contacts; "Overpack" > 1 tightens the contact shell *)
UniformLengthGraph[ region_ ? RegionQ, n_Integer, opts : OptionsPattern[] ] :=
  With[
    { radiusOption = OptionValue[ "Radius" ], dim = RegionDimension[ region ] },
    {
      radius = If[ radiusOption === Automatic,
        With[
          {
            measure = Replace[ region, {
              Sphere[ _ : { 0, 0, 0 }, r_ : 1 ] :> 4. Pi r ^ 2,
              Ball[ _ : { 0, 0, 0 }, r_ : 1 ] :> 4. Pi r ^ 3 / 3,
              Ellipsoid[ _, { a_, b_, c_ } ] :> 4. Pi a b c / 3,
              RegionBoundary[ Ellipsoid[ _, { a_, b_, c_ } ] ] :>
                4. Pi ( ( a ^ 1.6075 b ^ 1.6075 + a ^ 1.6075 c ^ 1.6075 + b ^ 1.6075 c ^ 1.6075 ) / 3 ) ^ ( 1 / 1.6075 ),
              _ :> RegionMeasure[ region ]
            } ]
          },
          0.5 OptionValue[ "Overpack" ] Switch[ dim,
            1, measure / n,
            2, Sqrt[ 2 measure / ( n Sqrt[ 3. ] ) ],
            _, 1.12 ( measure / n ) ^ ( 1 / 3 )
          ]
        ],
        N[ radiusOption ]
      ],
      fibonacci = Table[
        With[
          { phi = N[ Pi ( 3 - Sqrt[ 5 ] ) ] i, z = 1. - 2. ( i + 0.5 ) / n },
          { rho = Sqrt[ 1. - z ^ 2 ] },
          { rho Cos[ phi ], rho Sin[ phi ], z }
        ],
        { i, 0, n - 1 }
      ]
    },
    {
      seed = Replace[ region, {
        Sphere[ c : { _, _, _ } : { 0, 0, 0 }, r_ : 1 ] :> ( c + r # & ) /@ fibonacci,
        RegionBoundary[ Ellipsoid[ c : { _, _, _ }, s : { _, _, _ } ] ] :> ( c + s # & ) /@ fibonacci,
        _ :> RandomPoint[ region, n ]
      } ]
    },
    {
      points = Switch[ OptionValue[ Method ],
        "ConstrainedPacking",
        With[
          { regionDistance = Unique[ "ulRegionDistance" ], vars = Table[ Unique[ "ulx" ], Length[ seed ], Length[ First[ seed ] ] ] },
          regionDistance[ p : { __ ? NumericQ } ] := RegionDistance[ region, p ];
          Partition[
            Flatten[ vars ] /. Last @ NMinimize[
              {
                Total[ regionDistance[ # ] ^ 2 & /@ vars ],
                And @@ Flatten @ Table[
                  ( vars[[ i ]] - vars[[ j ]] ) . ( vars[[ i ]] - vars[[ j ]] ) >= ( 2 radius ) ^ 2,
                  { i, Length[ vars ] },
                  { j, i + 1, Length[ vars ] }
                ]
              },
              Flatten[ vars ]
            ],
            Length[ First[ seed ] ]
          ]
        ],
        _,
        With[
          {
            retract = Replace[ region, {
              Sphere[ c : { _, _, _ } : { 0, 0, 0 }, r_ : 1 ] :> ( pts |-> ( c + r Normalize[ # - c ] & ) /@ pts ),
              Ball[ c : { _, _, _ } : { 0, 0, 0 }, r_ : 1 ] :>
                ( pts |-> ( If[ EuclideanDistance[ c, # ] <= r, #, c + r Normalize[ # - c ] ] & ) /@ pts ),
              Ellipsoid[ c : { _, _, _ }, s : { _, _, _ } ] :>
                ( pts |-> ( With[ { q = ( # - c ) / s }, If[ q . q <= 1, #, c + ( # - c ) / Sqrt[ q . q ] ] ] & ) /@ pts ),
              RegionBoundary[ Ellipsoid[ c : { _, _, _ }, s : { _, _, _ } ] ] :>
                ( pts |-> ( c + ( # - c ) / Sqrt[ Total[ ( ( # - c ) / s ) ^ 2 ] ] & ) /@ pts ),
              _ :> ( pts |-> RegionNearest[ region, pts ] )
            } ]
          },
          NestWhile[
            pts |-> With[
              { neighbors = Nearest[ pts -> "Index" ][ pts, { Infinity, 2. radius } ] },
              {
                groups = GroupBy[
                  Catenate @ Catenate @ Table[
                    With[ { v = pts[[ i ]] - pts[[ j ]], dist = EuclideanDistance[ pts[[ i ]], pts[[ j ]] ] },
                      If[ 10. ^ -12 < dist < 2 radius,
                        With[ { delta = 0.5 ( 2 radius - dist ) v / dist }, { i -> delta, j -> -delta } ],
                        { }
                      ]
                    ],
                    { i, Length[ pts ] },
                    { j, Select[ neighbors[[ i ]], # > i & ] }
                  ],
                  First -> Last
                ]
              },
              { moved = pts + Table[ Fold[ Plus, 0. pts[[ i ]], Lookup[ groups, i, { } ] ], { i, Length[ pts ] } ] },
              moved + OptionValue[ "ProjectionStep" ] ( retract[ moved ] - moved )
            ],
            N[ seed ],
            Max[ Norm /@ ( #2 - #1 ) ] >= OptionValue[ "Tolerance" ] &,
            2,
            OptionValue[ "MaxIterations" ]
          ]
        ]
      ]
    },
    With[ { nf = Nearest[ points -> "Index" ], band = 2 radius OptionValue[ "ContactTolerance" ] },
      {
        cg = Graph[
          Range[ Length[ points ] ],
          Flatten @ Table[
            UndirectedEdge[ i, # ] & /@ Select[
              nf[ points[[ i ]], { Infinity, 2 radius + band } ],
              # > i && Abs[ EuclideanDistance[ points[[ i ]], points[[ # ]] ] - 2 radius ] <= band &
            ],
            { i, Length[ points ] }
          ],
          VertexCoordinates -> points
        ]
      },
      If[ OptionValue[ "KeepCoordinates" ], cg, Graph[ cg, VertexCoordinates -> Automatic ] ]
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
