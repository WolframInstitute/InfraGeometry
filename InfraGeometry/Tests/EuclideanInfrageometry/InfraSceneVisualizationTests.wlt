geodesicGraph      = WolframInstitute`InfraGeometry`PackageScope`geodesicGraph;
geodesicCycleGraph = WolframInstitute`InfraGeometry`PackageScope`geodesicCycleGraph;
walkGraph          = walk |-> PathGraph[ MapIndexed[ { First @ #2, #1 } &, walk ], DirectedEdges -> True ];
infraInk           = WolframInstitute`InfraGeometry`PackageScope`infraInk;
strikeOutPalette   = WolframInstitute`InfraGeometry`PackageScope`$InfraStrikeOutPalette;
dotScales          = opts |-> Catenate @ Cases[ VertexShapeFunction /. opts,
  ( _ -> f_Function ) :> Cases[ f[ { 0, 0 }, None, { 1, 1 } ], Disk[ _, { r_, _ } ] :> r, Infinity ], Infinity ];
shapesAt           = opts |-> Association @ Cases[ VertexShapeFunction /. opts,
  ( v_ -> f_Function ) :> v -> Sort @ Cases[ f[ { 0, 0 }, None, { 1, 1 } ], ( h : Disk | Circle | Point )[ ___ ] :> h, Infinity ], { 1 } ];
ringScales         = opts |-> Catenate @ Cases[ VertexShapeFunction /. opts,
  ( _ -> f_Function ) :> Cases[ f[ { 0, 0 }, None, { 1, 1 } ], Circle[ _, { r_, _ } ] :> r, Infinity ], Infinity ];
headsOf            = drawing |-> Cases[ Epilog /. Options[ drawing, Epilog ],
  { { k_, AbsoluteThickness[ tk_ ], CapForm[ "Round" ], JoinForm[ "Round" ], b_BezierCurve },
    { c_, AbsoluteThickness[ t_ ], CapForm[ "Round" ], JoinForm[ "Round" ], b_BezierCurve } } :> { c, t, b, { k, tk } }, Infinity ];

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    Head @ InfraSubstrateHighlight[ g, { RandomInfraSegment[ g, 1, 16, All ] } ]
  ],
  Graph,
  TestID -> "InfraSubstrateHighlight-single-multiobject"
]

VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    Head @ InfraSubstrateHighlight[ g,
      { RandomInfraLine[ g, 1, 9, All ] -> RGBColor[ 0.8, 0.2, 0.2 ] } ]
  ],
  Graph,
  TestID -> "InfraSubstrateHighlight-explicit-color-rule"
]

VerificationTest[
  With[ { g = CycleGraph[ 8 ], vs = VertexList[ CycleGraph[ 8 ] ] },
    Head @ InfraSubstrateHighlight[ g, { { Append[ vs, First @ vs ] } } ]
  ],
  Graph,
  TestID -> "InfraSubstrateHighlight-self-closing-cycle"
]

VerificationTest[
  Head @ InfraSubstrateHighlight[ PathGraph[ Range[ 5 ] ], { } ],
  Graph,
  TestID -> "InfraSubstrateHighlight-empty-input-still-graph"
]

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    Head @ InfraSubstrateHighlight[ g, { RandomInfraPoint[ g, 5 ] } ]
  ],
  Graph,
  TestID -> "InfraSubstrateHighlight-vertex-singletons"
]

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    Head @ InfraSubstrateHighlight[ g,
      { RandomInfraSegment[ g, 1, 16, All ] -> Blue,
        { 1, 16 }                                   -> Red } ]
  ],
  Graph,
  TestID -> "InfraSubstrateHighlight-multiple-objects"
]

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    Head @ InfraSubstrateHighlight[ g,
      { RandomInfraSegment[ g, 1, 16, All ] -> Blue,
        RandomInfraCircle[ g, InfraCircle[ 1, 2 ], All ] -> Green } ]
  ],
  Graph,
  TestID -> "InfraSubstrateHighlight-mixed-segment-and-circle"
]

(* a multiset of vertices: each key treated as a single vertex (no edges).
   On a list-named-vertex graph, this is the case where the shape reader has to
   separate "single list-vertex" from "multiset of vertices". *)
VerificationTest[
  With[ { g = MeshConnectivityGraph @ DiscretizeRegion[
        Rectangle[], MaxCellMeasure -> 0.1 ] },
    With[ {
        pts  = Take[ VertexList @ g, 2 ],
        opts = Options @
          InfraSubstrateHighlight[ g, { InfraMeasurement[ g, Take[ VertexList @ g, 2 ], "VertexDensity" ] -> Red } ] },
      Length @ Flatten @ Cases[ opts,
        HoldPattern[ VertexShapeFunction -> rules_ ] :>
          Cases[ rules, ( v_ -> _ ) /; MemberQ[ pts, v ] ], Infinity ] > 0 &&
      Length @ Cases[ GraphHighlightStyle /. opts, _UndirectedEdge -> _, Infinity ] == 0
    ]
  ],
  True,
  TestID -> "InfraSubstrateHighlight-multiset-vertices-only"
]

(* a family of sets: edges are the induced subgraph's.
   On a 4x4 grid, the level set at radius {1, 2} from vertex 1 has four
   induced subgraph edges; verify they are highlighted. *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    With[ { styles = EdgeStyle /. Options @ InfraSubstrateHighlight[ g,
          { { Keys @ InfraMeasurement[ g, InfraShell[ 1, { 1, 2 } ], "VertexDensity" ] } -> Green } ] },
      Length @ Cases[ styles, _UndirectedEdge -> _, Infinity ] > 0
    ]
  ],
  True,
  TestID -> "InfraSubstrateHighlight-set-family-induced-edges"
]

(* a cycle graph: edges are its consecutive pairs, the wrap-around included.
   On the 4-cycle
   { 1, 2, 6, 5 } in GridGraph[{4, 4}], expect 4 highlighted edges:
   {1,2}, {2,6}, {6,5}, {5,1}. *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ], cyc = { 1, 2, 6, 5 } },
    With[ { styles = EdgeStyle /. Options @
          InfraSubstrateHighlight[ g, { geodesicCycleGraph @ cyc -> Blue } ] },
      Length @ Cases[ styles, _UndirectedEdge -> _, Infinity ] == 4
    ]
  ],
  True,
  TestID -> "InfraSubstrateHighlight-cycle-graph-closure"
]

(* geodesicCycleGraph is idempotent on pre-closed input: passing
   { 1, 2, 6, 5, 1 } produces the same edge set as { 1, 2, 6, 5 }. *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ], open = { 1, 2, 6, 5 }, closed = { 1, 2, 6, 5, 1 } },
    With[ {
        sOpen   = EdgeStyle /. Options @ InfraSubstrateHighlight[ g, { geodesicCycleGraph @ open   -> Blue } ],
        sClosed = EdgeStyle /. Options @ InfraSubstrateHighlight[ g, { geodesicCycleGraph @ closed -> Blue } ] },
      Sort @ Cases[ sOpen,   ( e_UndirectedEdge -> _ ) :> e, Infinity ] ===
      Sort @ Cases[ sClosed, ( e_UndirectedEdge -> _ ) :> e, Infinity ] &&
      Length @ Cases[ sOpen, _UndirectedEdge -> _, Infinity ] == 4
    ]
  ],
  True,
  TestID -> "InfraSubstrateHighlight-cycle-graph-idempotent-on-closed-input"
]

(* a path graph: sequential-edge semantics.  Verify
   that for a path of length 4 the highlighted edges are exactly the 3
   sequential pairs. *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ], path = { 1, 2, 3, 4 } },
    With[ { styles = EdgeStyle /. Options @
          InfraSubstrateHighlight[ g, { geodesicGraph @ path -> Blue } ] },
      Length @ Cases[ styles, _UndirectedEdge -> _, Infinity ] == 3
    ]
  ],
  True,
  TestID -> "InfraSubstrateHighlight-path-graph-sequential-edges"
]

(* Per-object style override via Rule -> Directive[...]: an explicit
   AbsolutePointSize is rerouted to a top-level VertexShapeFunction (it is a
   no-op inside a Style[] highlight spec), so it must reach the produced
   options. *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    ! FreeQ[
      Options @ InfraSubstrateHighlight[ g,
        { <| 1 -> 1, 6 -> 1, 11 -> 1 |> -> Directive[ Blue, AbsolutePointSize[ 25 ] ] } ],
      AbsolutePointSize[ 25 ] ]
  ],
  True,
  TestID -> "InfraSubstrateHighlight-rule-directive-pointsize-override"
]

(* Per-object style override via Style[obj, dirs__]: equivalent to the
   Rule -> Directive[...] form. *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    ! FreeQ[
      Options @ InfraSubstrateHighlight[ g,
        { Style[ <| 1 -> 1, 6 -> 1 |>, Green, AbsolutePointSize[ 30 ] ] } ],
      AbsolutePointSize[ 30 ] ]
  ],
  True,
  TestID -> "InfraSubstrateHighlight-style-wrapper-pointsize-override"
]

(* Edge-level override: AbsoluteThickness on InfraSegment must reach the
   produced EdgeStyle directive. *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    With[ { styles = EdgeStyle /. Options @ InfraSubstrateHighlight[ g,
          { geodesicGraph @ { 1, 2, 3, 4 } -> Directive[ Orange, AbsoluteThickness[ 8 ] ] } ] },
      ! FreeQ[ styles, AbsoluteThickness[ 8 ] ]
    ]
  ],
  True,
  TestID -> "InfraSubstrateHighlight-rule-directive-thickness-override"
]

(* An explicit Opacity directive overrides the on-by-default "OpacityRange"
   count-diffusion: only the user's opacity is emitted on each edge, so no
   gradient-induced opacity values appear alongside it. *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    With[ { styles = GraphHighlightStyle /. Options @ InfraSubstrateHighlight[ g,
          { geodesicGraph @ { 1, 2, 3, 4 } -> Directive[ Orange, Opacity[ 0.3 ] ] } ] },
      ! FreeQ[ styles, Opacity[ 0.3 ] ] &&
      Cases[ styles, Opacity[ x_ ] /; x =!= 0.3, Infinity ] === { }
    ]
  ],
  True,
  TestID -> "InfraSubstrateHighlight-explicit-opacity-overrides-opacityrange"
]

(* Regression test for the Flatten level bug: edges must actually be
   highlighted on a graph whose vertices are 2-lists.  Pre-fix, the bare
   Flatten call inside InfraSubstrateHighlight collapsed list-named vertices
   to scalars and HighlightGraph silently received malformed edges, so
   GraphHighlightStyle ended up empty of EdgeStyle entries. *)
VerificationTest[
  With[ {
      g = MeshConnectivityGraph @ DiscretizeRegion[
        Rectangle[], MaxCellMeasure -> 0.1 ] },
    With[ {
        vs  = VertexList @ g,
        seg = RandomInfraSegment[ g,
          First @ VertexList @ g, Last @ VertexList @ g, All ] },
      MatchQ[ First @ vs, { _, _ } ] &&
      Length @ Cases[
        EdgeStyle /. Options @ InfraSubstrateHighlight[ g, { seg -> Red } ],
        ( UndirectedEdge[ { _, _ }, { _, _ } ] -> _ ), Infinity ] > 0
    ]
  ],
  True,
  TestID -> "InfraSubstrateHighlight-list-vertex-edges-actually-highlighted"
]

(* Structured per-object spec: a flat option list is auto-sorted into the
   vertex / edge / diffusion channels.  EdgeStyle and VertexSize must reach
   the produced top-level Graph options (not just the Style[] highlight
   specs), and "ThicknessRange" must scale the per-edge thickness there. *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ {
        opts = Options @ InfraSubstrateHighlight[ g, {
          geodesicGraph @ { 1, 2, 3, 4, 5 } -> {
            VertexStyle      -> Red,
            VertexSize       -> Large,
            EdgeStyle        -> Directive[ Blue, AbsoluteThickness[ 7 ] ],
            "ThicknessRange" -> { 1, 9 } } } ] },
      ! FreeQ[ Cases[ opts, HoldPattern[ EdgeStyle -> e_ ] :> e, Infinity ], AbsoluteThickness[ 7 ] ] &&
      Cases[ opts, HoldPattern[ VertexSize -> _ ], Infinity ] =!= { }
    ]
  ],
  True,
  TestID -> "InfraSubstrateHighlight-structured-spec-toplevel-routing"
]

(* "PointSizeRange" opt-in reroutes vertex sizing to top-level
   VertexShapeFunction rules (HighlightGraph ignores AbsolutePointSize in
   Style[] highlight specs). *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    Cases[
      Options @ InfraSubstrateHighlight[ g,
        { geodesicGraph @ { 1, 2, 3, 4, 5 } -> { "PointSizeRange" -> { 8, 20 } } } ],
      HoldPattern[ VertexShapeFunction -> _ ], Infinity ] =!= { }
  ],
  True,
  TestID -> "InfraSubstrateHighlight-pointsizerange-reroutes-to-vsf"
]

(* VertexSize is a plain graph-coordinate passthrough for every value: a
   numeric per-entry VertexSize stays on the top-level VertexSize channel (no
   AbsolutePointSize reroute), exactly like a symbolic one. *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ { opts = Options @ InfraSubstrateHighlight[ g,
          { 13 -> { VertexStyle -> Blue, VertexSize -> 12 } } ] },
      Cases[ opts, HoldPattern[ VertexSize -> _ ], Infinity ] =!= { } &&
      FreeQ[ opts, AbsolutePointSize ]
    ]
  ],
  True,
  TestID -> "InfraSubstrateHighlight-numeric-vertexsize-stays-graphcoord"
]

(* AbsolutePointSize[n] is the explicit constant-on-screen-size path: it
   reroutes to a top-level VertexShapeFunction (HighlightGraph drops point
   sizing inside Style[] specs) and suppresses the "PointSizeRange" diffusion. *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ { opts = Options @ InfraSubstrateHighlight[ g,
          { 13 -> { Blue, AbsolutePointSize[ 12 ],
            "PointSizeRange" -> { 4, 30 } } } ] },
      Cases[ opts, HoldPattern[ VertexShapeFunction -> _ ], Infinity ] =!= { } &&
      ! FreeQ[ opts, AbsolutePointSize[ 12 ] ] &&
      FreeQ[ opts, AbsolutePointSize[ 4 ] | AbsolutePointSize[ 30 ] ]
    ]
  ],
  True,
  TestID -> "InfraSubstrateHighlight-abspointsize-overrides-pointsizerange"
]

(* Scalar "ThicknessRange" is the base, the thickness at the lightest mass.  On CycleGraph[4] the two geodesics
   1-2-3 and 1-4-3 use every edge once, so every edge is at the base. *)
VerificationTest[
  With[ { g = CycleGraph[ 4 ] },
    Union @ Cases[ EdgeStyle /. Options @ InfraSubstrateHighlight[ g,
      { RandomInfraSegment[ g, 1, 3, All ] }, "ThicknessRange" -> 8 ], AbsoluteThickness[ t_ ] :> t, Infinity ] ],
  { 8 },
  TestID -> "InfraSubstrateHighlight-scalar-thickness-is-the-base"
]

(* A crisp single-realisation object carries the full base measure. *)
VerificationTest[
  With[ { g = PathGraph[ Range[ 4 ] ] },
    ! FreeQ[
      Options @ InfraSubstrateHighlight[ g,
        { geodesicGraph @ { 1, 2, 3, 4 } }, "ThicknessRange" -> 8 ],
      AbsoluteThickness[ 8 ] ]
  ],
  True,
  TestID -> "InfraSubstrateHighlight-scalar-thickness-crisp-full-measure"
]

(* Default point sizing: a fuzzy InfraPoint distributes the base point measure
   over its candidate vertices (two candidates -> half each), a crisp one gets
   the whole measure.  Stated as the ratio, so the palette may retune the base. *)
VerificationTest[
  With[ { g = GridGraph[ { 7, 7 } ] },
    { (* a UNIFORM effective point (here a ball) is uniformly bright: its diffuseness
         is its extent, not a per-vertex fade *)
      Union @ dotScales @ Options @ InfraSubstrateHighlight[ g, { InfraMeasurement[ g, Keys @ InfraMeasurement[ g, InfraBall[25, 2], "VertexDensity" ], "VertexDensity" ] } ],
      (* a NON-uniform effective point draws its lightest vertex at the substrate's size and its heaviest at the top *)
      MinMax @ dotScales @ Options @ InfraSubstrateHighlight[ g, { InfraMeasurement[ g, InfraSegment[ 1, 49 ], "Midpoint" ] } ] } ],
  { { 1 }, { 1, 3 } },
  TestID -> "InfraSubstrateHighlight-density-relative-mass"
]

(* A highlighted walk is drawn as ONE joined stroke through its vertices, not as a
   chain of separately butt-capped edges: a bend must not bite a wedge of background
   out of the ribbon. *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    Cases[ Options @ InfraSubstrateHighlight[ g, { walkGraph /@ { { 1, 2, 6, 10, 11 } } } ],
      Line[ q_ ] :> q, Infinity ] === { GraphEmbedding[ g ][[ { 1, 2, 6, 10, 11 } ]] }
  ],
  True,
  TestID -> "InfraSubstrateHighlight-walk-is-one-stroke"
]

(* A walk that repeats an edge still paints every step: an edge whose shape function
   draws nothing has to lie on one of the joined strokes. *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    { opts = Options @ InfraSubstrateHighlight[ g, { walkGraph /@ { { 1, 2, 6, 2, 3, 7 } } } ],
      xy   = AssociationThread[ VertexList[ g ] -> GraphEmbedding[ g ] ] },
    { stroked = Union @ Catenate[ Sort /@ Partition[ #, 2, 1 ] & /@ Cases[ opts, Line[ q_ ] :> q, Infinity ] ],
      blank   = Cases[ opts, ( e_UndirectedEdge -> f_Function ) /; FreeQ[ f, _Line ] :> Sort[ xy /@ List @@ e ], Infinity ] },
    blank =!= { } && SubsetQ[ stroked, blank ]
  ],
  True,
  TestID -> "InfraSubstrateHighlight-repeated-edge-walk-keeps-every-step"
]

(* The Automatic point-size default is on for everything that is not a line: a set
   highlight emits a VertexShapeFunction, one dot per vertex. *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    Cases[
      Options @ InfraSubstrateHighlight[ g,
        { { Keys @ InfraMeasurement[ g, InfraShell[ 1, { 1, 2 } ], "VertexDensity" ] } } ],
      HoldPattern[ VertexShapeFunction -> _ ], Infinity ] =!= { }
  ],
  True,
  TestID -> "InfraSubstrateHighlight-automatic-pointsize-on-for-sets"
]

(* A symbolic per-entry VertexSize (Large / Tiny / Scaled[..]) stays on the
   graph-coordinate HighlightGraph VertexSize channel. *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    Cases[
      Options @ InfraSubstrateHighlight[ g,
        { 13 -> { VertexSize -> Large } } ],
      HoldPattern[ VertexSize -> _ ], Infinity ] =!= { }
  ],
  True,
  TestID -> "InfraSubstrateHighlight-symbolic-vertexsize-stays-graphcoord"
]


(* ===== point-layer highlight objects ===== *)

(* a vertex List that is no induced path is a set: dots at the substrate's own size, and its induced edges faint, at
   the bottom of the opacity range and at the base thickness.  On the 4x4 grid the ball of radius 1 about 6 is
   { 2, 5, 6, 7, 10 }, whose induced subgraph is the four spokes. *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    With[ { opts = Options @ InfraSubstrateHighlight[ g, { { Keys @ InfraMeasurement[ g, InfraBall[6, 1], "VertexDensity" ] } -> Red } ] },
      { Length @ Cases[ EdgeStyle /. opts, _UndirectedEdge -> _, Infinity ],
        Union @ Cases[ EdgeStyle /. opts, ( _UndirectedEdge -> d_ ) :> Cases[ d, _AbsoluteThickness | _Opacity ], Infinity ],
        dotScales @ opts } ] ],
  { 4, { { Opacity[ 0.4 ], AbsoluteThickness[ 1. ] } }, { 1, 1, 1, 1, 1 } },
  TestID -> "InfraSubstrateHighlight-vertex-list-is-dots-with-faint-edges"
]

(* and its DENSITY is the point family: dots, no edges.  InfraMeasurement is the one
   coercion, so promoting a set to points needs no new option. *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    With[ { opts = Options @ InfraSubstrateHighlight[ g, { InfraMeasurement[ g, { 3, 9 }, "VertexDensity" ] -> Red } ] },
      { Length @ Cases[ EdgeStyle /. opts, _UndirectedEdge -> _, Infinity ],
        dotScales @ opts } ] ],
  { 0, { 1, 1 } },
  TestID -> "InfraSubstrateHighlight-density-is-a-point-family"
]

(* A CHAIN of open walks is a polyline, read off the shape: consecutive legs share
   their endpoint.  It draws as ONE joined stroke through the concatenated sequence,
   with the knots as points on top so the subdivision is visible.  Four legs over
   Range[11] give five knots. *)
VerificationTest[
  With[ { g = PathGraph @ Range[ 11 ] },
    With[ { legs = FindInfraPolylineSubdivision[ g, Range[ 11 ], "MaxLength" -> 3 ] },
      { Length @ legs,
        Cases[ Options @ InfraSubstrateHighlight[ g, { legs } ], Line[ q_ ] :> q, Infinity ] ===
          { GraphEmbedding[ g ] },
        dotScales @ Options @ InfraSubstrateHighlight[ g, { legs } ] } ] ],
  { 4, True, { 1, 1, 1, 1, 1 } },
  TestID -> "InfraSubstrateHighlight-polyline-is-one-stroke-with-knots"
]

(* a CLOSED chain is a polygon: its corner set drops the repeated closing knot,
   so a triangle draws three corner dots, not four *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    With[ { sides = geodesicGraph /@ { RandomInfraSegment[ g, 1, 4 ], RandomInfraSegment[ g, 4, 13 ], RandomInfraSegment[ g, 13, 1 ] } },
      Length @ dotScales @ Options @ InfraSubstrateHighlight[ g, { sides } ] ] ],
  3,
  TestID -> "InfraSubstrateHighlight-polygon-corners-drop-the-closure"
]

(* the knots are painted right after their own chain, in the chain's colour: one chain, knot 4 *)
VerificationTest[
  With[ { g = PathGraph @ Range[ 11 ] },
    With[ { opts = Options @ InfraSubstrateHighlight[ g, { FindInfraPolylineSubdivision[ g, Range[ 11 ], "MaxLength" -> 3 ] } ] },
      First @ Cases[ VertexShapeFunction /. opts, ( 4 -> f_ ) :> First @ Cases[ f, _RGBColor, Infinity ] ] ] ],
  First @ strikeOutPalette,
  TestID -> "InfraSubstrateHighlight-knots-take-their-object-colour"
]

(* a bundle of geodesics between the same two points does NOT chain -- every leg
   runs p -> q -- so it inks as a walk bundle and gets no knots *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    Cases[ Options @ InfraSubstrateHighlight[ g, { RandomInfraSegment[ g, 1, 16, UpTo[ 3 ] ] } ],
      AbsolutePointSize[ s_ ] :> s, Infinity ] ],
  { },
  TestID -> "InfraSubstrateHighlight-same-endpoint-bundle-is-not-a-polyline"
]

(* no weight exceeds 1, whatever the shape: a fraction above 1 would lerp the
   opacity past opaque.  The degenerate triangle 1 -> 5 -> 25 on the 5x5 grid
   retraces its third side, so its vertices carry mass 2. *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ { objects = { geodesicGraph /@ { RandomInfraSegment[ g, 1, 5 ], RandomInfraSegment[ g, 5, 25 ],
                Reverse @ Join[ RandomInfraSegment[ g, 1, 5 ], Rest @ RandomInfraSegment[ g, 5, 25 ] ] },
              InfraSegment[ 1, 5, 25, 1 ],
              RandomInfraSegment[ g, 1, 25, All ],
              { Keys @ InfraMeasurement[ g, InfraShell[ 13, 2 ], "VertexDensity" ] },
              Keys @ InfraMeasurement[ g, InfraBall[13, 2], "VertexDensity" ] } },
      Union @ Cases[ Options @ InfraSubstrateHighlight[ g, objects ],
        Opacity[ x_ ] :> x <= 1, Infinity ] ] ],
  { True },
  TestID -> "InfraSubstrateHighlight-no-weight-exceeds-one"
]

(* a bare vertex is a legal highlight object *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    dotScales @ Options @ InfraSubstrateHighlight[ g, { 7 -> Red } ] ],
  { 1 },
  TestID -> "InfraSubstrateHighlight-bare-vertex"
]

(* a dot at density 1 is the substrate's own vertex, coloured, on every graph *)
VerificationTest[
  DeleteDuplicates[ ( graph |-> dotScales @ Options @ InfraSubstrateHighlight[ graph, { First @ VertexList @ graph } ] ) /@
    { PathGraph @ Range @ 5, GridGraph[ { 6, 6 } ], PetersenGraph[ ] } ],
  { { 1 } },
  TestID -> "InfraSubstrateHighlight-dot-at-density-one-is-the-substrate-vertex"
]

VerificationTest[
  { WolframInstitute`InfraGeometry`PackageScope`$InfraPointSizes, WolframInstitute`InfraGeometry`PackageScope`$InfraAccentPointSize },
  { <| Small -> 4, Medium -> 7, Large -> 10 |>, 12 },
  TestID -> "InfraPointSizes-closed-table"
]

(* the default head is an Epilog, drawn over the dots: none without the option, one open head per walk with it, no polygon anywhere *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] }, With[ { seg = geodesicGraph @ RandomInfraSegment[ g, 1, 25 ] },
    { FreeQ[ Options @ InfraSubstrateHighlight[ g, { seg } ], Epilog | _Polygon ],
      Length @ headsOf @ InfraSubstrateHighlight[ g, { seg }, "Arrowheads" -> True ],
      FreeQ[ Options @ InfraSubstrateHighlight[ g, { seg }, "Arrowheads" -> True ], _Polygon ] } ] ],
  { True, 1, True },
  TestID -> "InfraSubstrateHighlight-Arrowheads-off-by-default-drawn-when-on"
]

(* the head's colour is half the stroke's thickness t and its barbs are 14 + 2 t printer points long, behind the tip *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    ( t |-> With[ { head = First @ headsOf @ InfraSubstrateHighlight[ g, { InfraWalk[ { 1, 2, 3 } ] }, "Arrowheads" -> True, "ThicknessRange" -> t ] },
      { head[[ 2 ]], - Min @ Cases[ head[[ 3 ]], Offset[ d_, _ ] :> Last @ d, Infinity ] } ] ) /@ { Automatic, 2, 9 } ],
  { { 0.5, 16 }, { 1, 18 }, { 4.5, 32 } },
  SameTest -> Equal,
  TestID -> "InfraSubstrateHighlight-Arrowheads-scaled-to-the-stroke"
]

(* the head is in the walk's own colour *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    ( c |-> First @ First @ headsOf @ InfraSubstrateHighlight[ g, { InfraWalk[ { 1, 2, 3 } ] -> c }, "Arrowheads" -> True ] ) /@
      { StandardYellow, strikeOutPalette[[ 2 ]] } ],
  { StandardYellow, strikeOutPalette[[ 2 ]] },
  TestID -> "InfraSubstrateHighlight-Arrowheads-in-the-walks-colour"
]

(* each head is two strokes of the same barbs: a black contour underneath, the walk's colour on top, so the head reads
   where it lies on its own walk; the whole head, contour included, is as broad as the walk's edge: black at the edge's
   thickness t, the colour at t / 2 *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    ( t |-> With[ { drawing = InfraSubstrateHighlight[ g, { InfraWalk[ { 1, 2, 3 } ] -> StandardBlue }, "Arrowheads" -> True, "ThicknessRange" -> t ] },
      { Count[ Epilog /. Options[ drawing, Epilog ], _BezierCurve, Infinity ],
        Last @ First @ headsOf @ drawing,
        First @ First @ headsOf @ drawing,
        First[ headsOf @ drawing ][[ 2 ]],
        Union @ Cases[ EdgeStyle /. Options[ drawing, EdgeStyle ], ( UndirectedEdge[ 2, 3 ] -> d_ ) :> First @ Cases[ d, AbsoluteThickness[ w_ ] :> w, Infinity ], Infinity ] } ] ) /@ { Automatic, 3 } ],
  { { 2, { Black, 1 }, StandardBlue, 0.5, { 1 } }, { 2, { Black, 3 }, StandardBlue, 1.5, { 3 } } },
  SameTest -> Equal,
  TestID -> "InfraSubstrateHighlight-Arrowheads-black-contour-under-the-colour"
]

(* the tip is the last vertex and the head points along the last two edges (one edge of a mesh zigzags):
   the barbs are symmetric about the direction from the third-last vertex to the tip *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ { head = First @ headsOf @ InfraSubstrateHighlight[ g, { InfraWalk[ { 1, 2, 3, 8 } ] }, "Arrowheads" -> True ],
            c    = AssociationThread[ VertexList @ g -> GraphEmbedding @ g ] },
      { head[[ 3, 1, 3 ]] == c[ 8 ],
        Norm[ Normalize @ Total @ Cases[ head[[ 3 ]], Offset[ d_, _ ] :> d, Infinity ][[ { 1, -1 } ]] + Normalize[ c[ 8 ] - c[ 2 ] ] ] < 10^-9 } ] ],
  { True, True },
  TestID -> "InfraSubstrateHighlight-Arrowheads-along-the-walk"
]

(* a one-step walk is drawn with its head, so a 1-cochain edge shows its orientation: one head, its tip at v *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ { heads = headsOf @ InfraSubstrateHighlight[ g, { InfraWalk[ { 1, 2 } ] }, "Arrowheads" -> True ] },
      { Length @ heads, heads[[ 1, 3, 1, 3 ]] } ] ],
  { 1, { 1., 2. } },
  TestID -> "InfraSubstrateHighlight-Arrowheads-one-step-walk"
]

(* an object carries its own head: obj -> True arms that object alone, obj -> False disarms it
   against an armed option.  One open head per armed path object, for True and for an Arrowheads spec alike. *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ { a = geodesicGraph @ RandomInfraSegment[ g, 1, 5 ], b = geodesicGraph @ RandomInfraSegment[ g, 21, 25 ] },
      { Length @ headsOf @ InfraSubstrateHighlight[ g, { a -> True, b } ],
        Length @ headsOf @ InfraSubstrateHighlight[ g, { Style[ a, Arrowheads[ 0.09 ] ], b } ],
        Length @ headsOf @ InfraSubstrateHighlight[ g, { a, b -> False }, "Arrowheads" -> True ] } ] ],
  { 1, 1, 1 },
  TestID -> "InfraSubstrateHighlight-Arrowheads-per-object"
]

(* the option's name works inside an object's style list too, obj -> {..., "Arrowheads" -> True}, as "ThicknessRange" does:
   it arms or disarms that object and never reaches the stroke or dot directives *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ { a = InfraWalk[ { 1, 2, 3 } ], b = InfraWalk[ { 21, 22, 23 } ] },
      { Length @ headsOf @ InfraSubstrateHighlight[ g, { a -> { StandardBlue, "Arrowheads" -> True }, b } ],
        Length @ headsOf @ InfraSubstrateHighlight[ g, { a, b -> { "Arrowheads" -> False } }, "Arrowheads" -> True ],
        FreeQ[ Options[ InfraSubstrateHighlight[ g, { a -> { StandardBlue, "Arrowheads" -> True } } ], { EdgeStyle, VertexShapeFunction } ],
          "Arrowheads" ] } ] ],
  { 1, 1, True },
  TestID -> "InfraSubstrateHighlight-Arrowheads-option-name-in-a-style-list"
]

(* the head joins an Epilog the caller passes instead of replacing it *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ { drawing = InfraSubstrateHighlight[ g, { InfraWalk[ { 1, 2, 3 } ] }, "Arrowheads" -> True, Epilog -> { Red, Disk[ ] } ] },
      { Length @ headsOf @ drawing, Count[ Epilog /. Options[ drawing, Epilog ], _Disk, Infinity ] } ] ],
  { 1, 1 },
  TestID -> "InfraSubstrateHighlight-Arrowheads-keep-the-callers-Epilog"
]

(* an object's own spec overrides the option for that object: its head is sized by the spec, with no
   head at the option's absolute size *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ { seg = geodesicGraph @ RandomInfraSegment[ g, 1, 5 ] },
      With[ { epilog = Epilog /. Options[ InfraSubstrateHighlight[ g, { seg -> Arrowheads[ 0.09 ] }, "Arrowheads" -> True ], Epilog ] },
        { Cases[ epilog, Arrowheads[ l_List ] :> l[[ All, 1 ]], Infinity ], Count[ epilog, _Offset, Infinity ] } ] ] ],
  { { { 0.09 } }, 0 },
  TestID -> "InfraSubstrateHighlight-Arrowheads-object-overrides-option"
]

(* the head is opaque on a substrate whose vertices are drawn translucent: an Epilog is outside the vertex style *)
VerificationTest[
  With[ { g = Graph[ GridGraph[ { 5, 5 } ], VertexStyle -> Directive[ GrayLevel[ 0.62 ], Opacity[ 0.45 ] ] ] },
    { Length @ headsOf @ InfraSubstrateHighlight[ g, { InfraWalk[ { 1, 2, 3 } ] }, "Arrowheads" -> True ],
      FreeQ[ Epilog /. Options[ InfraSubstrateHighlight[ g, { InfraWalk[ { 1, 2, 3 } ] }, "Arrowheads" -> True ], Epilog ], _Opacity ] } ],
  { 1, True },
  TestID -> "InfraSubstrateHighlight-Arrowheads-opaque-on-a-styled-substrate"
]

(* an Arrowheads spec, as a style token, as the option, or as the option's bare size, draws the same open head through
   Wolfram's Arrow, its size handed to Arrowheads untouched: one head per walk, no filled polygon, no head on the stroke *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ], w = InfraWalk[ { 1, 2, 3 } ] },
    ( drawing |-> With[ { opts = Options @ drawing },
        { Cases[ Epilog /. opts, Arrowheads[ l_List ] :> l[[ All, 1 ]], Infinity ], Length @ headsOf @ drawing,
          FreeQ[ opts, _Polygon ], FreeQ[ EdgeShapeFunction /. opts, _Arrowheads ] } ] ) /@ {
      InfraSubstrateHighlight[ g, { w -> { StandardBlue, Arrowheads[ 0.05 ] } } ],
      InfraSubstrateHighlight[ g, { w -> Arrowheads[ Small ] } ],
      InfraSubstrateHighlight[ g, { w }, "Arrowheads" -> Arrowheads[ Large ] ],
      InfraSubstrateHighlight[ g, { w }, "Arrowheads" -> Medium ] } ],
  { { { { 0.05 } }, 1, True, True }, { { { Small } }, 1, True, True }, { { { Large } }, 1, True, True }, { { { Medium } }, 1, True, True } },
  TestID -> "InfraSubstrateHighlight-Arrowheads-spec-sizes-the-open-head"
]

(* the head rides on an Arrow whose shaft is invisible, Opacity[0]; the head graphic restores full opacity and carries
   the walk's colour at half its stroke over the black contour at its stroke *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ { drawing = InfraSubstrateHighlight[ g, { InfraWalk[ { 1, 2, 3 } ] -> StandardRed }, "Arrowheads" -> Arrowheads[ Large ] ] },
      { Length @ Cases[ Epilog /. Options[ drawing, Epilog ],
          { Opacity[ 0 ], Arrowheads[ { { _, _, Graphics[ { Opacity[ 1 ], __ } ] } } ], _Arrow }, Infinity ],
        First[ headsOf @ drawing ][[ { 1, 2, 4 } ]] } ] ],
  { 1, { StandardRed, 0.5, { Black, 1 } } },
  SameTest -> Equal,
  TestID -> "InfraSubstrateHighlight-Arrowheads-spec-invisible-shaft"
]

(* the Arrow runs along the walk with the vertex before the tip left out, so its head points from the third-last
   vertex to the tip, as the absolute head does *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ { c = AssociationThread[ VertexList @ g -> GraphEmbedding @ g ] },
      Cases[ Epilog /. Options[ InfraSubstrateHighlight[ g, { InfraWalk[ { 1, 2, 3, 8 } ] }, "Arrowheads" -> Arrowheads[ Small ] ], Epilog ],
        Arrow[ points_ ] :> points == Lookup[ c, { 1, 2, 8 } ], Infinity ] ] ],
  { True },
  TestID -> "InfraSubstrateHighlight-Arrowheads-spec-along-the-walk"
]

(* a list of specs places one head per spec as Arrow does: plain sizes evenly from tail to tip, a negative one reversed,
   {s, pos} at pos *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ], w = InfraWalk[ { 1, 2, 3 } ] },
    ( spec |-> With[ { drawing = InfraSubstrateHighlight[ g, { w }, "Arrowheads" -> spec ] },
        { Length @ headsOf @ drawing, Cases[ Epilog /. Options[ drawing, Epilog ], Arrowheads[ l_List ] :> l[[ All, { 1, 2 } ]], Infinity ] } ] ) /@
      { Arrowheads[ { -0.05, 0.05 } ], Arrowheads[ { { 0.05, 0.5 } } ], Arrowheads[ { 0.05, { Small, 0.3 }, 0.05 } ] } ],
  { { 2, { { { -0.05, Automatic }, { 0.05, Automatic } } } },
    { 1, { { { 0.05, 0.5 } } } },
    { 3, { { { 0.05, Automatic }, { Small, 0.3 }, { 0.05, Automatic } } } } },
  TestID -> "InfraSubstrateHighlight-Arrowheads-list-of-specs"
]

(* a spec carrying its own head graphic is Wolfram's, drawn as given: Arrow on the walk's last stroke, no open head *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ], spec = Arrowheads[ { { 0.1, 1, Graphics[ Disk[ ] ] } } ] },
    With[ { opts = Options @ InfraSubstrateHighlight[ g, { InfraWalk[ { 1, 2, 3 } ] -> spec } ] },
      { DeleteDuplicates @ Cases[ EdgeShapeFunction /. opts, _Arrowheads, Infinity ] === { spec }, FreeQ[ opts, Epilog ] } ] ],
  { True, True },
  TestID -> "InfraSubstrateHighlight-Arrowheads-own-graphic-drawn-as-given"
]

(* drawn, the head's size means what it means to Arrow: Small is smaller than Large, both absolute, while a number is a
   fraction of the width, so its head doubles with the ImageSize; read off the pixels the head changes against the same
   drawing without it *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    { pixels = { spec, size } |-> ImageData[ Rasterize[
        InfraSubstrateHighlight[ g, { InfraWalk[ { 7, 8, 9 } ] -> StandardBlue }, "Arrowheads" -> spec, ImageSize -> size ],
        "Image", Background -> White, ImageResolution -> 72 ], "Byte" ] },
    { ink = { spec, size } |-> Count[ Map[ Max, Abs[ pixels[ spec, size ] - pixels[ None, size ] ], { 2 } ], d_ /; d > 40, { 2 } ] },
    { 0 < ink[ Arrowheads[ Small ], 300 ] < ink[ Arrowheads[ Large ], 300 ],
      ink[ Arrowheads[ Large ], 600 ] < 1.25 ink[ Arrowheads[ Large ], 300 ],
      ink[ Arrowheads[ 0.1 ], 600 ] > 1.6 ink[ Arrowheads[ 0.1 ], 300 ] } ],
  { True, True, True },
  TestID -> "InfraSubstrateHighlight-Arrowheads-spec-drawn-at-Arrows-size"
]

(* in 3D an Arrowheads spec, and True as Arrowheads[.035], stay Wolfram's own head on the last stroke *)
VerificationTest[
  With[ { g = Graph[ GridGraph[ { 3, 3, 3 } ], VertexCoordinates -> Tuples[ Range[ 3 ], 3 ] ] },
    ( spec |-> With[ { opts = Options @ InfraSubstrateHighlight[ g, { InfraWalk[ { 1, 2, 3 } ] }, "Arrowheads" -> spec ] },
        { DeleteDuplicates @ Cases[ EdgeShapeFunction /. opts, _Arrowheads, Infinity ], FreeQ[ opts, Epilog ] } ] ) /@
      { True, Arrowheads[ Small ] } ],
  { { { Arrowheads[ 0.035 ] }, True }, { { Arrowheads[ Small ] }, True } },
  TestID -> "InfraSubstrateHighlight-Arrowheads-3D-unchanged"
]

(* the stroke rules are keyed as the graph stores its edges, so a run whose first edge is stored reversed keeps its stroke *)
VerificationTest[
  With[ { g = Graph[ { UndirectedEdge[ 2, 1 ], UndirectedEdge[ 3, 2 ], UndirectedEdge[ 3, 4 ], UndirectedEdge[ 1, 4 ] } ] },
    { opts = Options @ InfraSubstrateHighlight[ g, { InfraWalk[ { 1, 2, 3, 4 } ] } ] },
    { SubsetQ[ EdgeList @ g, Keys[ EdgeShapeFunction /. opts ] ],
      SubsetQ[ EdgeList @ g, Cases[ EdgeStyle /. opts, ( e_ -> _ ) :> e ] ],
      FreeQ[ UndirectedEdge[ 2, 1 ] /. ( EdgeShapeFunction /. opts ), Line ] } ],
  { True, True, False },
  TestID -> "InfraSubstrateHighlight-stroke-rules-keyed-as-the-graph-stores-its-edges"
]

(* StrikeOutPalette: colour follows ADDITION ORDER, not object type. *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ { a = RandomInfraSegment[ g, 1, 25 ], b = Keys @ InfraMeasurement[ g, InfraBall[13, 1], "VertexDensity" ] },
      Module[ { c1, c2 },
        c1 = Cases[ ToBoxes @ InfraSubstrateHighlight[ g, { a, b } ], _RGBColor, Infinity ];
        c2 = Cases[ ToBoxes @ InfraSubstrateHighlight[ g, { b, a } ], _RGBColor, Infinity ];
        { MemberQ[ c1, First @ strikeOutPalette ], c1 =!= c2 } ] ] ],
  { True, True },
  TestID -> "InfraSubstrateHighlight-Palette-follows-addition-order"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ { seg = RandomInfraSegment[ g, 1, 25 ] },
      MemberQ[ Cases[ ToBoxes @ InfraSubstrateHighlight[ g, { seg -> RGBColor[ 0, 1, 0 ] } ], _RGBColor, Infinity ],
        RGBColor[ 0, 1, 0 ] ] ] ],
  True,
  TestID -> "InfraSubstrateHighlight-Palette-explicit-colour-still-wins"
]

VerificationTest[
  { Length @ strikeOutPalette, First @ strikeOutPalette === First @ ColorData[ 112, "ColorList" ] },
  { 15, True },
  TestID -> "InfraStrikeOutPalette-is-ColorData-112"
]


(* ===== the ink: every object a vertex and an edge density ===== *)

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    ( x |-> Values @ KeyTake[ infraInk[ g, x ], { "EdgeDensity", "Walk" } ] ) /@ {
      7,
      <| 1 -> 2, 7 -> 1 |>,
      InfraWalk[ { 1, 2, 7 } ],
      { 7, 8 },
      { 7, 9 },
      walkGraph @ { 1, 2, 7 } } ],
  { { <| |>, None },
    { <| |>, None },
    { <| UndirectedEdge[ 1, 2 ] -> 1, UndirectedEdge[ 2, 7 ] -> 1 |>, { 1, 2, 7 } },
    { <| UndirectedEdge[ 7, 8 ] -> 1 |>, { 7, 8 } },
    { <| |>, None },
    { <| UndirectedEdge[ 1, 2 ] -> 1, UndirectedEdge[ 2, 7 ] -> 1 |>, { 1, 2, 7 } } },
  TestID -> "infraInk-one-row-per-object"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    AllTrue[
      { 7, <| 1 -> 2, 7 -> 1 |>, Keys @ InfraMeasurement[ g, InfraBall[13, 1], "VertexDensity" ], { Keys @ InfraMeasurement[ g, InfraShell[ 13, 2 ], "VertexDensity" ] },
        walkGraph @ { 1, 2, 7 }, geodesicCycleGraph @ { 1, 2, 7, 6 }, walkGraph /@ { { 1, 2, 7 }, { 1, 6, 7 } } },
      x |-> infraInk[ g, x ][ "VertexDensity" ] === InfraMeasurement[ g, x, "VertexDensity" ] ] ],
  True,
  TestID -> "infraInk-vertex-column-is-InfraMeasurement"
]

VerificationTest[
  ( { g, h } |-> With[ { ink = infraInk[ g, h ] },
      { ink[ "VertexDensity" ] === InfraMeasurement[ g, h, "VertexDensity" ],
        Total @ ink[ "EdgeDensity" ] === Total @ InfraMeasurement[ g, h, "EdgeDensity" ],
        Sort @ Keys @ ink[ "EdgeDensity" ] ===
          Union[ UndirectedEdge @@ Sort @ # & /@ Catenate[ Partition[ #, 2, 1 ] & /@ Replace[ h, { token_InfraPoint :> RandomInfraPoint[ g, token, All ], token_InfraSegment :> RandomInfraSegment[ g, token, All ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, All ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraCircle :> RandomInfraCircle[ g, token, All ], token_InfraArc :> RandomInfraArc[ g, token, All ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, All ], token_InfraPlane :> RandomInfraPlane[ g, token, All ], token_InfraBall :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraShell :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraSphere :> RandomInfraSphere[ g, token, All ], token_InfraTube :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraCylinder :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraCone :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraSolidOfRevolution :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraBallHull :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraConvexHull :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraQuadric :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraWalk :> RandomInfraWalk[ g, token, All ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, All ], token_InfraEllipse :> RandomInfraEllipse[ g, token, All ], token_InfraIntersection :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraUnion :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraRay :> RandomInfraHalfLine[ g, token, All ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, All ] } ] ] ] } ] ) @@@
    { { CycleGraph[ 6 ], InfraSegment[ 1, 4 ] }, { GridGraph[ { 5, 5 } ], InfraSegment[ 1, 13 ] } },
  { { True, True, True }, { True, True, True } },
  TestID -> "InfraSubstrateHighlight-head-ink-is-its-measurement"
]

(* the segment draws no chord; the list 1, 2, 3, 4 has the chords 1-3 and 2-4, so it is no line and draws no
   counted edge either, only its dots and its faint induced edges *)
VerificationTest[
  With[ { g = Graph[ { 1 <-> 2, 1 <-> 3, 2 <-> 3, 2 <-> 4, 3 <-> 4 } ] },
    KeyExistsQ[ infraInk[ g, # ][ "EdgeDensity" ], UndirectedEdge[ 2, 3 ] ] & /@ { InfraSegment[ 1, 4 ], { 1, 2, 3, 4 } } ],
  { False, False },
  TestID -> "InfraSubstrateHighlight-head-draws-no-chords"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    { infraInk[ g, InfraSegment[ 1, 5 ] ][ "Walk" ],
      infraInk[ g, InfraArc[ 13, { 12, 12 }, "RadiusDelta" -> 1 ] ][ "Walk" ],
      infraInk[ g, InfraSegment[ 1, 7 ] ][ "Walk" ],
      infraInk[ g, InfraMeasurement[ g, InfraSegment[ 1, 25 ], "Graph" ] ][ "Walk" ],
      infraInk[ g, walkGraph @ { 1, 2, 7, 2, 3 } ][ "Walk" ] } ],
  { { 1, 2, 3, 4, 5 }, { 8, 7, 12, 17, 18, 19, 14, 9, 8 }, None, None, { 1, 2, 7, 2, 3 } },
  TestID -> "infraInk-one-member-keeps-its-order"
]

VerificationTest[
  With[ { g = CycleGraph[ 6 ] },
    { Sort @ Keys @ infraInk[ g, geodesicCycleGraph @ Range[ 6 ] ][ "EdgeDensity" ],
      infraInk[ g, InfraWalk[ { 1, 2, 3, 4, 5, 6, 1 } ] ][ "VertexDensity" ],
      Cases[ Options @ InfraSubstrateHighlight[ g, { InfraWalk[ { 1, 2, 3, 4, 5, 6, 1 } ] } ], Line[ q_ ] :> q, Infinity ] } ],
  { Sort[ UndirectedEdge @@@ { { 1, 2 }, { 2, 3 }, { 3, 4 }, { 4, 5 }, { 5, 6 }, { 1, 6 } } ],
    AssociationThread[ Range[ 6 ] -> 1 ],
    { GraphEmbedding[ CycleGraph[ 6 ] ][[ { 1, 2, 3, 4, 5, 6, 1 } ]] } },
  TestID -> "InfraSubstrateHighlight-closed-InfraWalk-closes-the-stroke"
]

(* a closed polyline InfraSegment[p, ..., p] is a polygon: its members return to p, which
   the measurement counts twice and the ink once, so the hexagon draws at full strength *)
VerificationTest[
  With[ { g = CycleGraph[ 6 ], hexagon = InfraSegment[ 1, 3, 5, 1 ] },
    { InfraMeasurement[ g, hexagon, "VertexDensity" ][ 1 ],
      infraInk[ g, hexagon ][ "VertexDensity" ],
      infraInk[ g, hexagon ][ "Walk" ],
      Union @ Cases[ EdgeStyle /. Options @ InfraSubstrateHighlight[ g, { hexagon } ], AbsoluteThickness[ t_ ] :> t, Infinity ] } ],
  { 2, AssociationThread[ Range[ 6 ] -> 1 ], { 1, 2, 3, 4, 5, 6, 1 }, { 1. } },
  TestID -> "InfraSubstrateHighlight-closed-polyline-counts-its-return-once"
]

VerificationTest[
  With[ { listLabelled = MeshConnectivityGraph @ DiscretizeRegion[ Rectangle[], MaxCellMeasure -> 0.1 ] },
    { infraInk[ listLabelled, First @ VertexList @ listLabelled ][ "EdgeDensity" ],
      infraInk[ GridGraph[ { 5, 5 } ], { 1, 2 } ][ "EdgeDensity" ] } ],
  { <| |>, <| UndirectedEdge[ 1, 2 ] -> 1 |> },
  TestID -> "infraInk-substrate-separates-point-from-region"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    infraInk[ g, # ][ "Knots" ] & /@ {
      geodesicGraph /@ { RandomInfraSegment[ g, 1, 4 ], RandomInfraSegment[ g, 4, 21 ], RandomInfraSegment[ g, 21, 1 ] },
      RandomInfraSegment[ g, 1, 25, UpTo[ 4 ] ],
      { RandomInfraSegment[ g, 1, 25 ] },
      RandomInfraCircle[ g, InfraCircle[ 13, 2 ], UpTo[ 2 ] ] } ],
  { { 1, 4, 21 }, { }, { }, { } },
  TestID -> "infraInk-chain-has-knots-bundle-has-none"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ { styles = EdgeStyle /. Options @ InfraSubstrateHighlight[ g,
          { InfraWalk[ { 1, 2, 3 } ], Directive[ Red ], InfraWalk[ { 21, 22, 23 } ], InfraWalk[ { 11, 12, 13 } ] } ] },
      First @ Cases[ Lookup[ styles, # ], _RGBColor ] & /@ { UndirectedEdge[ 1, 2 ], UndirectedEdge[ 21, 22 ], UndirectedEdge[ 11, 12 ] } ] ],
  { First @ strikeOutPalette, Red, Red },
  TestID -> "InfraSubstrateHighlight-Directive-styles-the-objects-after-it"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ {
        once  = Lookup[ EdgeStyle /. Options @ InfraSubstrateHighlight[ g, { InfraSegment[ 1, 7 ] }, "ThicknessRange" -> 8 ], UndirectedEdge[ 1, 2 ] ],
        twice = Lookup[ EdgeStyle /. Options @ InfraSubstrateHighlight[ g, { InfraSegment[ 1, 7 ], InfraSegment[ 1, 7 ] }, "ThicknessRange" -> 8 ], UndirectedEdge[ 1, 2 ] ] },
      { Cases[ once, _AbsoluteThickness ], Cases[ twice, _AbsoluteThickness ], First @ Cases[ twice, _RGBColor ] === strikeOutPalette[[ 2 ]] } ] ],
  { { AbsoluteThickness[ 8 ] }, { AbsoluteThickness[ 8 ] }, True },
  TestID -> "InfraSubstrateHighlight-overlap-last-object-wins-colour"
]

(* objects are painted in list order: where they overlap, the colour drawn is the last object's, never a blend *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    ( items |-> With[ { opts = Options @ InfraSubstrateHighlight[ g, items ] },
        { First @ Cases[ Lookup[ EdgeStyle /. opts, # ], _?ColorQ ] & /@ { UndirectedEdge[ 1, 2 ], UndirectedEdge[ 2, 3 ], UndirectedEdge[ 3, 4 ] },
          First @ Cases[ # /. ( GraphHighlightStyle /. opts ), _?ColorQ, Infinity ] & /@ { 1, 2, 3, 4 } } ] ) /@
      { { InfraWalk[ { 1, 2, 3 } ] -> Red, InfraWalk[ { 2, 3, 4 } ] -> Blue },
        { InfraWalk[ { 2, 3, 4 } ] -> Blue, InfraWalk[ { 1, 2, 3 } ] -> Red } } ],
  { { { Red, Blue, Blue }, { Red, Blue, Blue, Blue } },
    { { Red, Red, Blue }, { Red, Red, Red, Blue } } },
  TestID -> "InfraSubstrateHighlight-last-object-wins-explicit-colours"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ { opts = Options @ InfraSubstrateHighlight[ g, { InfraWalk[ { 1, 2, 3 } ], InfraWalk[ { 2, 3, 4 } ] } ] },
      { First @ Cases[ Lookup[ EdgeStyle /. opts, # ], _?ColorQ ] & /@ { UndirectedEdge[ 1, 2 ], UndirectedEdge[ 2, 3 ] },
        First @ Cases[ # /. ( GraphHighlightStyle /. opts ), _?ColorQ, Infinity ] & /@ { 1, 2 } } ] ],
  { strikeOutPalette[[ { 1, 2 } ]], strikeOutPalette[[ { 1, 2 } ]] },
  TestID -> "InfraSubstrateHighlight-last-object-wins-palette-colours"
]

(* a later dot covers an earlier one completely: its colour, its own size, nothing of the earlier dot left *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ { f = 13 /. ( VertexShapeFunction /. Options @ InfraSubstrateHighlight[ g, { <| 12 -> 1, 13 -> 3 |> -> Red, <| 13 -> 1 |> -> Blue } ] ) },
      { Cases[ f[ { 0, 0 }, 13, { 1, 1 } ], _?ColorQ, Infinity ], Cases[ f[ { 0, 0 }, 13, { 1, 1 } ], Disk[ _, { r_, _ } ] :> r, Infinity ] } ] ],
  { { Blue }, { 1 } },
  TestID -> "InfraSubstrateHighlight-last-object-wins-on-a-dot"
]

(* a chain's knots wear the chain's colour, not a palette one, at the base size however many chains share them;
   a later object paints over them like over any vertex *)
VerificationTest[
  With[ { g = PathGraph @ Range[ 11 ] },
    With[ { legs = FindInfraPolylineSubdivision[ g, Range[ 11 ], "MaxLength" -> 3 ] },
      { styled = Options @ InfraSubstrateHighlight[ g, { Directive[ StandardGreen ], legs } ],
        twice  = Options @ InfraSubstrateHighlight[ g, { legs, legs } ],
        under  = Options @ InfraSubstrateHighlight[ g, { legs -> Red, InfraWalk[ Range[ 11 ] ] -> Blue } ] },
      { Union @ Cases[ VertexShapeFunction /. styled, ( _ -> f_Function ) :> Splice @ Cases[ f, _?ColorQ, Infinity ] ],
        Union @ Cases[ VertexShapeFunction /. twice, ( _ -> f_Function ) :> Splice @ Cases[ f, _?ColorQ, Infinity ] ],
        Union @ dotScales @ twice,
        FreeQ[ under, Red ] } ] ],
  { { StandardGreen }, { strikeOutPalette[[ 2 ]] }, { 1 }, True },
  TestID -> "InfraSubstrateHighlight-knots-in-their-object-colour-and-place"
]

(* a family of geodesics under a family of midpoints: the midpoints in exactly their own colour, the endpoints in the geodesics' *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ { mids = RandomInfraMidpoint[ g, 1, 13, All ] },
      { opts = Options @ InfraSubstrateHighlight[ g, { Directive[ StandardBlue ], Splice @ RandomInfraSegment[ g, 1, 13, All ],
          Directive[ StandardRed, AbsolutePointSize[ 9 ] ], mids } ] },
      { Union @ Cases[ Lookup[ VertexShapeFunction /. opts, mids ], _?ColorQ, Infinity ],
        Union @ Cases[ { 1, 13 } /. ( GraphHighlightStyle /. opts ), _?ColorQ, Infinity ],
        Union @ Cases[ EdgeStyle /. opts, _?ColorQ, Infinity ] } ] ],
  { { StandardRed }, { StandardBlue }, { StandardBlue } },
  TestID -> "InfraSubstrateHighlight-midpoints-over-geodesics-keep-their-colour"
]

(* a list of heads, or of walks, as one entry is a family: its ink is the sum of its members' inks *)
VerificationTest[
  With[{g = GridGraph[{5, 5}], a = InfraSegment[1, 13], b = InfraSegment[7, 19]},
    {one = infraInk[g, {a, b}], ia = infraInk[g, a], ib = infraInk[g, b]},
    one["VertexDensity"] === KeySort[Merge[{ia["VertexDensity"], ib["VertexDensity"]}, Total]] &&
      one["EdgeDensity"] === KeySort[Merge[{ia["EdgeDensity"], ib["EdgeDensity"]}, Total]]],
  True,
  TestID -> "infraInk-list-of-heads-is-the-sum"
]

VerificationTest[
  With[{g = GridGraph[{5, 5}]},
    {Head @ InfraSubstrateHighlight[g, {{InfraSegment[1, 13], InfraSegment[7, 19]}}],
     Head @ InfraSubstrateHighlight[g, {{InfraWalk[{1, 2, 3}], InfraWalk[{3, 8, 13}]}}]}],
  {Graph, Graph},
  TestID -> "InfraSubstrateHighlight-list-of-heads-or-walks-is-one-object"
]


(* ===== ink by kind: lines by edge counts, everything else as dots with faint edges ===== *)

(* a vertex list is a line iff it is an induced path, or an induced cycle, in its own order: a geodesic, a row,
   the square 1, 2, 7, 6 given open and closed; the walk 1, 2, 7, 6, 11 has the chord 1-6 and the sorted ball is no
   walk, so both are sets *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    infraInk[ g, # ][ "Walk" ] & /@ {
      { 1, 2, 3, 8, 13 }, { 1, 2, 3, 4, 5 }, { 1, 2, 7, 6 }, { 1, 2, 7, 6, 1 }, { 1, 2, 7, 6, 11 },
      Keys @ InfraMeasurement[ g, InfraBall[ 13, 1 ], "VertexDensity" ] } ],
  { { 1, 2, 3, 8, 13 }, { 1, 2, 3, 4, 5 }, { 1, 2, 7, 6, 1 }, { 1, 2, 7, 6, 1 }, None, None },
  TestID -> "infraInk-line-test-induced-path-or-cycle"
]

(* the regions, an intersection and a union with a set among its parts carry no counted edges: they are dots *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    infraInk[ g, # ][ "EdgeDensity" ] & /@ {
      InfraBall[ 13, 1 ], InfraShell[ 13, 1 ], InfraTube[ InfraSegment[ 11, 15 ], 1 ],
      InfraIntersection[ InfraSegment[ 1, 25 ], InfraSegment[ 5, 21 ] ],
      InfraUnion[ InfraBall[ 13, 1 ], InfraSegment[ 1, 5 ] ] } ],
  { <| |>, <| |>, <| |>, <| |>, <| |> },
  TestID -> "infraInk-regions-intersections-mixed-unions-are-dots"
]

(* a union of lines is a line, the sum of its parts, and its counted edges are its measured edge density *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ], a = InfraSegment[ 1, 25 ], b = InfraSegment[ 5, 21 ] },
    { infraInk[ g, InfraUnion[ a, b ] ] === infraInk[ g, { a, b } ],
      Total @ infraInk[ g, InfraUnion[ a, b ] ][ "EdgeDensity" ] === Total @ InfraMeasurement[ g, InfraUnion[ a, b ], "EdgeDensity" ],
      ! FreeQ[ Options @ InfraSubstrateHighlight[ g, { InfraUnion[ a, b ] } ], AbsoluteThickness ] } ],
  { True, True, True },
  TestID -> "InfraSubstrateHighlight-union-of-lines-is-a-line"
]

(* a density draws dots sized by its masses and the edge between them faint *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ { opts = Options @ InfraSubstrateHighlight[ g, { <| 12 -> 2, 13 -> 1 |> } ] },
      { Cases[ EdgeStyle /. opts, ( e_UndirectedEdge -> _ ) :> e, Infinity ],
        Sort @ dotScales @ opts } ] ],
  { { UndirectedEdge[ 12, 13 ] }, { 1, 3 } },
  TestID -> "InfraSubstrateHighlight-density-dots-and-faint-edges"
]

(* where a line and a set share an edge the line's stroke wins; the set's other edges stay faint *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ { styles = EdgeStyle /. Options @ InfraSubstrateHighlight[ g, { InfraSegment[ 11, 15 ], InfraBall[ 13, 1 ] } ] },
      Cases[ Lookup[ styles, # ], _Opacity ] & /@ { UndirectedEdge[ 12, 13 ], UndirectedEdge[ 8, 13 ] } ] ],
  { { Opacity[ 1 ] }, { Opacity[ 0.4 ] } },
  TestID -> "InfraSubstrateHighlight-line-stroke-beats-faint-edge"
]

(* an explicit style still wins on the faint edges of a set *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    Union @ Cases[
      EdgeStyle /. Options @ InfraSubstrateHighlight[ g, { InfraBall[ 13, 1 ] -> Directive[ Red, AbsoluteThickness[ 3 ], Opacity[ 0.7 ] ] } ],
      ( _UndirectedEdge -> d_ ) :> Cases[ d, _AbsoluteThickness | _Opacity ], Infinity ] ],
  { { AbsoluteThickness[ 3 ], Opacity[ 0.7 ] } },
  TestID -> "InfraSubstrateHighlight-explicit-style-wins-on-faint-edges"
]


(* ===== sizes: the base, the range, the precedence ===== *)

(* density 1 draws at the substrate's own thickness; the lightest count of a bundle at the base, the heaviest at the top *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    { Union @ Cases[ EdgeStyle /. Options @ InfraSubstrateHighlight[ g, { InfraWalk[ { 1, 2, 3, 8 } ] } ], AbsoluteThickness[ t_ ] :> t, Infinity ],
      MinMax @ Cases[ EdgeStyle /. Options @ InfraSubstrateHighlight[ g, { InfraSegment[ 1, 13 ] } ], AbsoluteThickness[ t_ ] :> t, Infinity ] } ],
  { { 1. }, { 1., 4. } },
  TestID -> "InfraSubstrateHighlight-base-and-range"
]

(* a directive on one object beats the option, which beats the default *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ { styles = EdgeStyle /. Options @ InfraSubstrateHighlight[ g,
          { InfraWalk[ { 1, 2, 3 } ] -> AbsoluteThickness[ 2 ], InfraWalk[ { 11, 12, 13 } ] }, "ThicknessRange" -> 5 ] },
      Cases[ Lookup[ styles, # ], _AbsoluteThickness ] & /@ { UndirectedEdge[ 1, 2 ], UndirectedEdge[ 11, 12 ] } ] ],
  { { AbsoluteThickness[ 2 ] }, { AbsoluteThickness[ 5 ] } },
  TestID -> "InfraSubstrateHighlight-object-beats-option-beats-default"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    Internal`InheritedBlock[ { InfraSubstrateHighlight },
      SetOptions[ InfraSubstrateHighlight, "ThicknessRange" -> 3 ];
      Union @ Cases[ EdgeStyle /. Options @ InfraSubstrateHighlight[ g, { InfraWalk[ { 1, 2, 3 } ] } ], AbsoluteThickness[ t_ ] :> t, Infinity ] ] ],
  { 3 },
  TestID -> "InfraSubstrateHighlight-SetOptions-sets-the-global-base"
]

(* a walk that reuses an edge is one opaque path: its doubled edge is thicker, never fainter *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ { styles = EdgeStyle /. Options @ InfraSubstrateHighlight[ g, { InfraWalk[ { 1, 2, 7, 2, 3 } ] } ] },
      { Union @ Cases[ styles, _Opacity, Infinity ],
        Cases[ Lookup[ styles, # ], _AbsoluteThickness ] & /@ { UndirectedEdge[ 1, 2 ], UndirectedEdge[ 2, 7 ] } } ] ],
  { { Opacity[ 1 ] }, { { AbsoluteThickness[ 1. ] }, { AbsoluteThickness[ 4. ] } } },
  TestID -> "InfraSubstrateHighlight-walk-reusing-edges-is-one-opaque-path"
]

(* the option sizes the dots of the objects without edges; a line gets dots only from its own style *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    { Cases[ Options @ InfraSubstrateHighlight[ g, { InfraWalk[ { 1, 2, 3 } ], 13 }, "PointSizeRange" -> 10 ], AbsolutePointSize[ s_ ] :> s, Infinity ],
      Cases[ Options @ InfraSubstrateHighlight[ g, { InfraWalk[ { 1, 2, 3 } ] -> { "PointSizeRange" -> 10 } } ], AbsolutePointSize[ s_ ] :> s, Infinity ] } ],
  { { 10 }, { 10, 10, 10 } },
  TestID -> "InfraSubstrateHighlight-option-sizes-dots-not-lines"
]

(* a line's vertex masses size no dot: a set on the ends of a bundle stays at its base *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    Union @ Cases[ Options @ InfraSubstrateHighlight[ g, { InfraSegment[ 1, 13 ], { 1, 13 } }, "PointSizeRange" -> 10 ],
      AbsolutePointSize[ s_ ] :> s, Infinity ] ],
  { 10 },
  TestID -> "InfraSubstrateHighlight-line-masses-size-no-dot"
]


(* ===== signed densities: a filled dot for a positive mass, an empty ring for a negative one ===== *)

(* on a signed density every opacity lies in [0, 1] and every size is positive, in both dot branches *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ], d = <| 7 -> 3, 8 -> -1, 12 -> -3, 13 -> 2, 19 -> -2 |> },
    ( opts |-> With[ { sizes = Catenate @ Cases[ VertexShapeFunction /. opts,
          ( _ -> f_Function ) :> Cases[ f[ { 0, 0 }, None, { 1, 1 } ],
            ( Disk | Circle )[ _, { r_, _ } | Offset[ { r_, _ } ] ] | AbsolutePointSize[ r_ ] :> r, Infinity ], { 1 } ] },
        { AllTrue[ Cases[ opts, Opacity[ x_ ] :> x, Infinity ], 0 <= # <= 1 & ], Length @ sizes, AllTrue[ sizes, # > 0 & ] } ] ) /@
      { Options @ InfraSubstrateHighlight[ g, { d } ], Options @ InfraSubstrateHighlight[ g, { d }, "PointSizeRange" -> 10 ] } ],
  { { True, 5, True }, { True, 5, True } },
  TestID -> "InfraSubstrateHighlight-signed-opacities-and-sizes-in-range"
]

(* the rings sit exactly at the negative masses: in the default dot branch, at a point size, and at a VertexSize *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ], d = <| 7 -> 3, 8 -> -1, 12 -> -3, 13 -> 2, 19 -> -2 |> },
    KeySort @ shapesAt @ Options @ InfraSubstrateHighlight[ g, { d -> # } ] & /@ { { }, { "PointSizeRange" -> 10 }, { VertexSize -> 0.4 } } ],
  { <| 7 -> { Disk }, 8 -> { Circle }, 12 -> { Circle }, 13 -> { Disk }, 19 -> { Circle } |>,
    <| 7 -> { Point }, 8 -> { Circle }, 12 -> { Circle }, 13 -> { Point }, 19 -> { Circle } |>,
    <| 8 -> { Circle }, 12 -> { Circle }, 19 -> { Circle } |> },
  TestID -> "InfraSubstrateHighlight-rings-exactly-at-the-negative-masses"
]

(* size and opacity read the absolute mass: the rings of -d are the dots of d, and a unit boundary draws both at the base, opaque *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ], d = <| 7 -> 3, 8 -> 1, 12 -> 2 |> },
    { pos = Options @ InfraSubstrateHighlight[ g, { d } ],
      neg = Options @ InfraSubstrateHighlight[ g, { - d } ],
      unit = Options @ InfraSubstrateHighlight[ g, { <| 12 -> 1, 14 -> -1 |> } ],
      peak = Options @ InfraSubstrateHighlight[ g, { <| 12 -> 1, 14 -> -3 |> } ] },
    { ringScales @ neg === dotScales @ pos,
      Cases[ neg, _Opacity, Infinity ] === Cases[ pos, _Opacity, Infinity ],
      { dotScales @ unit, ringScales @ unit, Union @ Cases[ VertexShapeFunction /. unit, Opacity[ x_ ] :> x, Infinity ] },
      { dotScales @ peak, ringScales @ peak } } ],
  { True, True, { { 1 }, { 1 }, { 1. } }, { { 1 }, { 3 } } },
  TestID -> "InfraSubstrateHighlight-ring-sized-by-the-absolute-mass"
]

(* two objects on one vertex: the positive one draws its dot, the negative one its ring, each in its own colour *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ { opts = Options @ InfraSubstrateHighlight[ g, { <| 12 -> 2, 13 -> 1 |>, <| 13 -> -1, 14 -> -3 |> } ] },
      { KeySort @ shapesAt @ opts,
        Cases[ ( 13 /. ( VertexShapeFunction /. opts ) )[ { 0, 0 }, 13, { 1, 1 } ],
          { c_?ColorQ, ___, ( h : Disk | Circle )[ ___ ] } :> h -> c, Infinity ] } ] ],
  { <| 12 -> { Disk }, 13 -> { Circle, Disk }, 14 -> { Circle } |>, { Disk -> strikeOutPalette[[ 1 ]], Circle -> strikeOutPalette[[ 2 ]] } },
  TestID -> "InfraSubstrateHighlight-dot-and-ring-on-one-vertex"
]

(* a zero mass is not drawn, and neither are the faint edges at it: an explicit zero, a cancelled mass, a density of zeros *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    { opts = Options @ InfraSubstrateHighlight[ g, { <| 12 -> 0, 13 -> 1, 14 -> 2 |> } ],
      cancel = Options @ InfraSubstrateHighlight[ g, { InfraUnion[ <| 12 -> 1, 13 -> 1 |>, <| 13 -> -1 |> ] } ] },
    { Keys @ KeySort @ shapesAt @ opts,
      FreeQ[ { VertexStyle, VertexSize } /. opts, 12 ],
      Cases[ EdgeStyle /. opts, ( e_UndirectedEdge -> _ ) :> e, { 1 } ],
      Sort @ dotScales @ opts,
      Keys @ shapesAt @ cancel,
      Options @ InfraSubstrateHighlight[ g, { <| 12 -> 0, 13 -> 0 |> } ] === Options @ HighlightGraph[ g, { } ] } ],
  { { 13, 14 }, True, { UndirectedEdge[ 13, 14 ] }, { 1, 3 }, { 12 }, True },
  TestID -> "InfraSubstrateHighlight-zero-mass-not-drawn"
]

(* edges stay unsigned: a signed density draws the edges of its absolute value *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ], d = <| 7 -> 2, 8 -> -1, 12 -> -3, 13 -> 1 |> },
    { styles = EdgeStyle /. Options @ InfraSubstrateHighlight[ g, { d } ] },
    { styles === ( EdgeStyle /. Options @ InfraSubstrateHighlight[ g, { Abs /@ d } ] ), Length @ styles } ],
  { True, 4 },
  TestID -> "InfraSubstrateHighlight-signed-density-edges-are-unsigned"
]

(* the union of signed densities draws their sum and the intersection their product *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ], d1 = <| 7 -> 1, 12 -> 1, 13 -> 2 |>, d2 = <| 7 -> -1, 13 -> -3, 14 -> -1 |> },
    { Options @ InfraSubstrateHighlight[ g, { InfraUnion[ d1, d2 ] } ] ===
        Options @ InfraSubstrateHighlight[ g, { <| 12 -> 1, 13 -> -1, 14 -> -1 |> } ],
      Options @ InfraSubstrateHighlight[ g, { InfraIntersection[ d1, d2 ] } ] ===
        Options @ InfraSubstrateHighlight[ g, { <| 7 -> -1, 13 -> -6 |> } ] } ],
  { True, True },
  TestID -> "InfraSubstrateHighlight-signed-union-sum-intersection-product"
]

(* an explicit VertexShapeFunction wins on a negative mass too *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    Sort[ VertexShapeFunction /. Options @ InfraSubstrateHighlight[ g, { <| 12 -> -1, 13 -> 2 |> -> { VertexShapeFunction -> "Square" } } ] ] ],
  { 12 -> "Square", 13 -> "Square" },
  TestID -> "InfraSubstrateHighlight-explicit-shape-wins-on-a-negative-mass"
]


(* ===== only a path or a cycle is a walk: a DAG, a list of DAGs, a digraph with cycles draw as densities ===== *)

(* two branching DAGs end to start: each counts its source-to-sink paths, and the list is their sum, not a polyline *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ], dags = { Graph[ { 1 -> 2, 1 -> 4, 2 -> 5, 4 -> 5 } ], Graph[ { 5 -> 6, 5 -> 8, 6 -> 9, 8 -> 9 } ] } },
    { ink = infraInk[ g, dags ] },
    { ink[ "VertexDensity" ], Values @ ink[ "EdgeDensity" ], ink[ "Walk" ], ink[ "Knots" ] } ],
  { <| 1 -> 2, 2 -> 1, 4 -> 1, 5 -> 4, 6 -> 1, 8 -> 1, 9 -> 2 |>, ConstantArray[ 1, 8 ], None, { } },
  TestID -> "infraInk-list-of-DAGs-is-the-sum-of-path-densities"
]

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    { dags = BeamGraph[ g, 6, 7 ] },
    { Head @ InfraSubstrateHighlight[ g, { dags } ],
      Total @ infraInk[ g, dags ][ "EdgeDensity" ] === Total @ InfraMeasurement[ g, InfraInfiniteLine[ 6, 7 ], "EdgeDensity" ] } ],
  { Graph, True },
  TestID -> "InfraSubstrateHighlight-list-of-DAGs-draws-the-line"
]

(* a digraph with a cycle that is not itself a cycle has no path density: it draws as its support, every edge once *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ], h = Graph[ { 1 -> 2, 2 -> 3, 1 -> 4, 4 -> 5, 5 -> 2, 2 -> 5, 5 -> 6, 6 -> 3 } ] },
    { ink = infraInk[ g, h ] },
    { Head @ InfraSubstrateHighlight[ g, { h } ], ink[ "VertexDensity" ], ink[ "EdgeDensity" ], ink[ "Walk" ] } ],
  { Graph, AssociationThread[ Range[ 6 ] -> 1 ],
    AssociationThread[ UndirectedEdge @@@ { { 1, 2 }, { 1, 4 }, { 2, 3 }, { 2, 5 }, { 3, 6 }, { 4, 5 }, { 5, 6 } } -> 1 ], None },
  TestID -> "infraInk-cyclic-digraph-is-its-support"
]

VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    { Head @ InfraSubstrateHighlight[ g, { PathSubgraph[ g, 1, 3, 4 ] } ], infraInk[ g, Graph[ { 1 -> 2, 2 -> 5, 5 -> 4, 4 -> 1 } ] ][ "Walk" ] } ],
  { Graph, { 1, 2, 5, 4, 1 } },
  TestID -> "InfraSubstrateHighlight-PathSubgraph-with-detours-and-directed-cycle"
]


(* ===== the geodesic and the ellipse are family heads: their ink is their "VertexDensity" and "EdgeDensity", one member a walk ===== *)

(* on the 3 x 3 grid the maximal shortest paths through 5, 6 are 1, 4, 5, 6, 9 and 1, 2, 5, 6, 9 and their mirrors 7, 4, 5, 6, 3
   and 7, 8, 5, 6, 3: four members through the edge 5 - 6; the readings are InfraMeasurement's on InfraGeodesic *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    { ink = infraInk[ g, InfraGeodesic[ { 5, 6 }, Infinity ] ] },
    { Head @ InfraSubstrateHighlight[ g, { InfraGeodesic[ { 5, 6 }, Infinity ] } ], ink[ "VertexDensity" ],
      ink[ "EdgeDensity" ][ UndirectedEdge[ 5, 6 ] ], ink[ "Walk" ] } ],
  { Graph, <| 1 -> 2, 2 -> 1, 3 -> 2, 4 -> 2, 5 -> 4, 6 -> 4, 7 -> 2, 8 -> 1, 9 -> 2 |>, 4, None },
  TestID -> "InfraSubstrateHighlight-InfraGeodesic-draws-its-family"
]

VerificationTest[
  infraInk[ PathGraph @ Range[ 5 ], InfraGeodesic[ { 2, 3 }, 2 ] ][ "Walk" ],
  { 1, 2, 3, 4, 5 },
  TestID -> "infraInk-InfraGeodesic-one-member-is-a-walk"
]

(* with the 2-side of K_{2,3} as foci every vertex has distance sum 2, so the three 4-cycles are the members: 3 through a focus, 2 through
   every other vertex and every edge; on the 6-cycle the one member is drawn closed, and an empty family draws nothing *)
VerificationTest[
  With[ { k = CompleteGraph[ { 2, 3 } ], g = CycleGraph[ 6 ] },
    { ink = infraInk[ k, InfraEllipse[ { 1, 2 }, 2, Properties -> { } ] ], one = infraInk[ g, InfraEllipse[ { 1, 4 }, 3, Properties -> { } ] ],
      empty = infraInk[ g, InfraEllipse[ { 1, 4 }, 1 ] ] },
    { Head @ InfraSubstrateHighlight[ k, { InfraEllipse[ { 1, 2 }, 2, Properties -> { } ] } ], ink[ "VertexDensity" ], Values @ ink[ "EdgeDensity" ],
      ink[ "Walk" ], one[ "Walk" ], empty[ "VertexDensity" ], empty[ "EdgeDensity" ] } ],
  { Graph, <| 1 -> 3, 2 -> 3, 3 -> 2, 4 -> 2, 5 -> 2 |>, { 2, 2, 2, 2, 2, 2 }, None, { 1, 2, 3, 4, 5, 6, 1 }, <| |>, <| |> },
  TestID -> "InfraSubstrateHighlight-InfraEllipse-draws-its-family"
]

VerificationTest[ GraphQ[ InfraSubstrateHighlight[ PathGraph[ Range[ 3 ] ], { InfraMidpoint[ 1, 3 ] } ] ],
  True, TestID -> "InfraSubstrateHighlight-midpoint-family" ]
VerificationTest[ GraphQ[ InfraSubstrateHighlight[ CycleGraph[ 4 ], { InfraPerpendicularBisector[ 1, 3 ] } ] ],
  True, TestID -> "InfraSubstrateHighlight-bisector-family" ]
VerificationTest[ GraphQ[ InfraSubstrateHighlight[ PathGraph[ Range[ 3 ] ], { InfraRegionNearest[ { 1, 3 }, 2 ] } ] ],
  True, TestID -> "InfraSubstrateHighlight-nearest-family" ]
