geodesicGraph      = WolframInstitute`InfraGeometry`PackageScope`geodesicGraph;
geodesicCycleGraph = WolframInstitute`InfraGeometry`PackageScope`geodesicCycleGraph;
walkGraph          = walk |-> PathGraph[ MapIndexed[ { First @ #2, #1 } &, walk ], DirectedEdges -> True ];
infraInk           = WolframInstitute`InfraGeometry`PackageScope`infraInk;

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    Head @ InfraSubstrateHighlight[ g, { FindInfraSegment[ g, 1, 16, All ] } ]
  ],
  Graph,
  TestID -> "InfraSubstrateHighlight-single-multiobject"
]

VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    Head @ InfraSubstrateHighlight[ g,
      { FindInfraLine[ g, 1, 9, All ] -> RGBColor[ 0.8, 0.2, 0.2 ] } ]
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
    Head @ InfraSubstrateHighlight[ g, { FindInfraPoint[ g, 5 ] } ]
  ],
  Graph,
  TestID -> "InfraSubstrateHighlight-vertex-singletons"
]

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    Head @ InfraSubstrateHighlight[ g,
      { FindInfraSegment[ g, 1, 16, All ] -> Blue,
        { 1, 16 }                                   -> Red } ]
  ],
  Graph,
  TestID -> "InfraSubstrateHighlight-multiple-objects-blend"
]

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    Head @ InfraSubstrateHighlight[ g,
      { FindInfraSegment[ g, 1, 16, All ] -> Blue,
        FindInfraCircle[ g, 1, "Radius" -> 2, All ] -> Green } ]
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
          InfraSubstrateHighlight[ g, { InfraDensity[ g, Take[ VertexList @ g, 2 ] ] -> Red } ] },
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
          { FindInfraShell[ g, 1, { 1, 2 }, All ] -> Green } ] },
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
        seg = FindInfraSegment[ g,
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

(* Scalar "ThicknessRange": the base measure is distributed across
   realisations.  On CycleGraph[4] the two geodesics 1-2-3 and 1-4-3 split
   the measure, so every edge renders at exactly half the base thickness. *)
VerificationTest[
  With[ { g = CycleGraph[ 4 ] },
    With[ { opts = Options @ InfraSubstrateHighlight[ g,
          { FindInfraSegment[ g, 1, 3, All ] }, "ThicknessRange" -> 8 ] },
      ! FreeQ[ opts, AbsoluteThickness[ 4 ] ] && FreeQ[ opts, AbsoluteThickness[ 8 ] ]
    ]
  ],
  True,
  TestID -> "InfraSubstrateHighlight-scalar-thickness-distributes-measure"
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
      Union @ Cases[ Options @ InfraSubstrateHighlight[ g, { InfraDensity[ g, FindInfraBall[ g, 25, 2 ] ] } ],
        AbsolutePointSize[ s_ ] :> s, Infinity ],
      (* a NON-uniform effective point draws its heaviest vertex full and the rest smaller *)
      With[ { sizes = Cases[ Options @ InfraSubstrateHighlight[ g, { FindInfraMidpoint[ g, 1, 49 ] } ],
                AbsolutePointSize[ s_ ] :> s, Infinity ] },
        { Max @ sizes, Max @ sizes > Min @ sizes } ] } ],
  { { 6 }, { 6, True } },
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

(* The Automatic point-size default stays off for non-point objects: a set
   highlight emits no VertexShapeFunction, its vertices inherit the graph's
   point size. *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    Cases[
      Options @ InfraSubstrateHighlight[ g,
        { FindInfraShell[ g, 1, { 1, 2 }, All ] } ],
      HoldPattern[ VertexShapeFunction -> _ ], Infinity ] === { }
  ],
  True,
  TestID -> "InfraSubstrateHighlight-automatic-pointsize-off-for-sets"
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

(* a vertex List is a region: its induced edges, no dots.  On the 4x4 grid the ball of radius 1 about 6 is
   { 2, 5, 6, 7, 10 }, whose induced subgraph is the four spokes. *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    With[ { opts = Options @ InfraSubstrateHighlight[ g, { FindInfraBall[ g, 6, 1 ] -> Red } ] },
      { Length @ Cases[ EdgeStyle /. opts, _UndirectedEdge -> _, Infinity ],
        Cases[ opts, AbsolutePointSize[ s_ ] :> s, Infinity ] } ] ],
  { 4, { } },
  TestID -> "InfraSubstrateHighlight-vertex-list-is-a-region"
]

(* and its DENSITY is the point family: dots, no edges.  InfraDensity is the one
   coercion, so promoting a set to points needs no new option. *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    With[ { opts = Options @ InfraSubstrateHighlight[ g, { InfraDensity[ g, { 3, 9 } ] -> Red } ] },
      { Length @ Cases[ EdgeStyle /. opts, _UndirectedEdge -> _, Infinity ],
        Cases[ opts, AbsolutePointSize[ s_ ] :> s, Infinity ] } ] ],
  { 0, { 6, 6 } },
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
        Cases[ Options @ InfraSubstrateHighlight[ g, { legs } ], AbsolutePointSize[ s_ ] :> s, Infinity ] } ] ],
  { 4, True, { 6, 6, 6, 6, 6 } },
  TestID -> "InfraSubstrateHighlight-polyline-is-one-stroke-with-knots"
]

(* a CLOSED chain is a polygon: its corner set drops the repeated closing knot,
   so a triangle draws three corner dots, not four *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    With[ { sides = FindInfraTriangle[ g, { 1, 4, 13 } ] },
      Length @ Cases[ Options @ InfraSubstrateHighlight[ g, { sides } ],
        AbsolutePointSize[ s_ ] :> s, Infinity ] ] ],
  3,
  TestID -> "InfraSubstrateHighlight-polygon-corners-drop-the-closure"
]

(* a bundle of geodesics between the same two points does NOT chain -- every leg
   runs p -> q -- so it inks as a walk bundle and gets no knots *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    Cases[ Options @ InfraSubstrateHighlight[ g, { FindInfraSegment[ g, 1, 16, UpTo[ 3 ] ] } ],
      AbsolutePointSize[ s_ ] :> s, Infinity ] ],
  { },
  TestID -> "InfraSubstrateHighlight-same-endpoint-bundle-is-not-a-polyline"
]

(* no weight exceeds 1, whatever the shape: a fraction above 1 would lerp the
   opacity past opaque.  The degenerate triangle 1 -> 5 -> 25 on the 5x5 grid
   retraces its third side, so its vertices carry mass 2. *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ { objects = { FindInfraTriangle[ g, { 1, 5, 25 } ],
              FindInfraTriangle[ g, { 1, 5, 25 }, UpTo[ 4 ] ],
              FindInfraSegment[ g, 1, 25, All ],
              FindInfraShell[ g, 13, 2, All ],
              FindInfraBall[ g, 13, 2 ] } },
      Union @ Cases[ Options @ InfraSubstrateHighlight[ g, objects ],
        Opacity[ x_ ] :> x <= 1, Infinity ] ] ],
  { True },
  TestID -> "InfraSubstrateHighlight-no-weight-exceeds-one"
]

(* a bare vertex is a legal highlight object *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    Cases[ Options @ InfraSubstrateHighlight[ g, { 7 -> Red } ], AbsolutePointSize[ s_ ] :> s, Infinity ] ],
  { 6 },
  TestID -> "InfraSubstrateHighlight-bare-vertex"
]

(* AbsoluteVertexSizes: a size class is one absolute value and never consults the graph.
   The three graphs are the ones the work item named as its acceptance test. *)
VerificationTest[
  DeleteDuplicates[ ( graph |-> Cases[ Options @ InfraSubstrateHighlight[ graph, { First @ VertexList @ graph } ],
    _AbsolutePointSize, Infinity ] ) /@ { PathGraph @ Range @ 5, GridGraph[ { 6, 6 } ], PetersenGraph[] } ],
  { { AbsolutePointSize[ 6 ] } },
  TestID -> "InfraSubstrateHighlight-vertex-size-is-graph-independent"
]

VerificationTest[
  { $InfraPointSizes, $InfraAccentPointSize },
  { <| Small -> 4, Medium -> 7, Large -> 10 |>, 12 },
  TestID -> "InfraPointSizes-closed-table"
]

(* DirectedPathDisplay: one arrowhead per path object, at its end, sized from the plot and
   NOT from the terminal edge's weight -- a heavy edge must not get a giant head.  The head
   is counted in the BOXES: arrowSpec is a Module local inside the EdgeShapeFunction body, so
   it only resolves when that function is called to draw. *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] }, With[ { seg = geodesicGraph @ FindInfraSegment[ g, 1, 25 ] },
    { Count[ ToBoxes @ InfraSubstrateHighlight[ g, { seg } ], ArrowBox, Infinity, Heads -> True ] > 0,
      Count[ ToBoxes @ InfraSubstrateHighlight[ g, { seg }, "Arrowheads" -> True ], ArrowBox, Infinity, Heads -> True ] > 0 } ] ],
  { False, True },
  TestID -> "InfraSubstrateHighlight-Arrowheads-off-by-default-drawn-when-on"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] }, With[ { seg = InfraWalk @ FindInfraSegment[ g, 1, 25 ] },
    SameQ @@ ( ( t |-> Cases[ ToBoxes @ InfraSubstrateHighlight[ g, { seg }, "Arrowheads" -> True,
        "ThicknessRange" -> t ], ArrowheadsBox[ a___ ] :> { a }, Infinity ] ) /@ { 2, 9 } ) ] ],
  True,
  TestID -> "InfraSubstrateHighlight-Arrowheads-independent-of-stroke-weight"
]

(* an object carries its own head: obj -> True arms that object alone, obj -> False disarms it
   against an armed option.  One ArrowBox per armed path object. *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ { a = geodesicGraph @ FindInfraSegment[ g, 1, 5 ], b = geodesicGraph @ FindInfraSegment[ g, 21, 25 ] },
      ( heads = ( e |-> Count[ ToBoxes @ e, ArrowBox, Infinity, Heads -> True ] ) );
      { heads @ InfraSubstrateHighlight[ g, { a -> True, b } ],
        heads @ InfraSubstrateHighlight[ g, { Style[ a, Arrowheads[ 0.09 ] ], b } ],
        heads @ InfraSubstrateHighlight[ g, { a, b -> False }, "Arrowheads" -> True ] } ] ],
  { 1, 1, 1 },
  TestID -> "InfraSubstrateHighlight-Arrowheads-per-object"
]

(* an object's own spec overrides the option's size for that object.  The head spec is read off
   the EdgeShapeFunction rules, not the boxes: it sits inside the drawing function's body and
   never surfaces as an ArrowheadsBox. *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ { seg = geodesicGraph @ FindInfraSegment[ g, 1, 5 ] },
      DeleteDuplicates @ Cases[
        Options[ InfraSubstrateHighlight[ g, { seg -> Arrowheads[ 0.09 ] }, "Arrowheads" -> True ],
          EdgeShapeFunction ], _Arrowheads, Infinity ] ] ],
  { Arrowheads[ 0.09 ] },
  TestID -> "InfraSubstrateHighlight-Arrowheads-object-overrides-option"
]

(* StrikeOutPalette: colour follows ADDITION ORDER, not object type. *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ { a = FindInfraSegment[ g, 1, 25 ], b = FindInfraBall[ g, 13, 1 ] },
      Module[ { c1, c2 },
        c1 = Cases[ ToBoxes @ InfraSubstrateHighlight[ g, { a, b } ], _RGBColor, Infinity ];
        c2 = Cases[ ToBoxes @ InfraSubstrateHighlight[ g, { b, a } ], _RGBColor, Infinity ];
        { MemberQ[ c1, First @ $InfraStrikeOutPalette ], c1 =!= c2 } ] ] ],
  { True, True },
  TestID -> "InfraSubstrateHighlight-Palette-follows-addition-order"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ { seg = FindInfraSegment[ g, 1, 25 ] },
      MemberQ[ Cases[ ToBoxes @ InfraSubstrateHighlight[ g, { seg -> RGBColor[ 0, 1, 0 ] } ], _RGBColor, Infinity ],
        RGBColor[ 0, 1, 0 ] ] ] ],
  True,
  TestID -> "InfraSubstrateHighlight-Palette-explicit-colour-still-wins"
]

VerificationTest[
  { Length @ $InfraStrikeOutPalette, First @ $InfraStrikeOutPalette === First @ ColorData[ 112, "ColorList" ] },
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
      walkGraph @ { 1, 2, 7 } } ],
  { { <| |>, None },
    { <| |>, None },
    { <| UndirectedEdge[ 1, 2 ] -> 1, UndirectedEdge[ 2, 7 ] -> 1 |>, { 1, 2, 7 } },
    { <| UndirectedEdge[ 7, 8 ] -> 1 |>, None },
    { <| UndirectedEdge[ 1, 2 ] -> 1, UndirectedEdge[ 2, 7 ] -> 1 |>, { 1, 2, 7 } } },
  TestID -> "infraInk-one-row-per-object"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    AllTrue[
      { 7, <| 1 -> 2, 7 -> 1 |>, FindInfraBall[ g, 13, 1 ], FindInfraShell[ g, 13, 2, All ],
        walkGraph @ { 1, 2, 7 }, geodesicCycleGraph @ { 1, 2, 7, 6 }, walkGraph /@ { { 1, 2, 7 }, { 1, 6, 7 } } },
      x |-> infraInk[ g, x ][ "VertexDensity" ] === InfraDensity[ g, x ] ] ],
  True,
  TestID -> "infraInk-vertex-column-is-InfraDensity"
]

VerificationTest[
  ( { g, h } |-> With[ { ink = infraInk[ g, h ] },
      { ink[ "VertexDensity" ] === InfraMeasurement[ g, h, "VertexDensity" ],
        Total @ ink[ "EdgeDensity" ] === Total @ InfraMeasurement[ g, h, "EdgeDensity" ],
        Sort @ Keys @ ink[ "EdgeDensity" ] ===
          Union[ UndirectedEdge @@ Sort @ # & /@ Catenate[ Partition[ #, 2, 1 ] & /@ InfraVertexList[ g, h, All ] ] ] } ] ) @@@
    { { CycleGraph[ 6 ], InfraSegment[ 1, 4 ] }, { GridGraph[ { 5, 5 } ], InfraSegment[ 1, 13 ] } },
  { { True, True, True }, { True, True, True } },
  TestID -> "InfraSubstrateHighlight-head-ink-is-its-measurement"
]

VerificationTest[
  With[ { g = Graph[ { 1 <-> 2, 1 <-> 3, 2 <-> 3, 2 <-> 4, 3 <-> 4 } ] },
    KeyExistsQ[ infraInk[ g, # ][ "EdgeDensity" ], UndirectedEdge[ 2, 3 ] ] & /@ { InfraSegment[ 1, 4 ], { 1, 2, 3, 4 } } ],
  { False, True },
  TestID -> "InfraSubstrateHighlight-head-draws-no-chords"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    { infraInk[ g, InfraSegment[ 1, 5 ] ][ "Walk" ],
      infraInk[ g, InfraCircle[ 13, 12, "RadiusDelta" -> 1 ] ][ "Walk" ],
      infraInk[ g, InfraSegment[ 1, 7 ] ][ "Walk" ],
      infraInk[ g, InfraMeasurement[ g, InfraSegment[ 1, 25 ], "Graph" ] ][ "Walk" ],
      infraInk[ g, walkGraph @ { 1, 2, 7, 2, 3 } ][ "Walk" ] } ],
  { { 1, 2, 3, 4, 5 }, { 12, 7, 8, 9, 14, 19, 18, 17, 12 }, None, None, { 1, 2, 7, 2, 3 } },
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
      FindInfraTriangle[ g, { 1, 4, 21 } ],
      FindInfraSegment[ g, 1, 25, UpTo[ 4 ] ],
      { FindInfraSegment[ g, 1, 25 ] },
      FindInfraCircle[ g, 13, "Radius" -> 2, UpTo[ 2 ] ] } ],
  { { 1, 4, 21 }, { }, { }, { } },
  TestID -> "infraInk-chain-has-knots-bundle-has-none"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ { styles = EdgeStyle /. Options @ InfraSubstrateHighlight[ g,
          { InfraWalk[ { 1, 2, 3 } ], Directive[ Red ], InfraWalk[ { 21, 22, 23 } ], InfraWalk[ { 11, 12, 13 } ] } ] },
      First @ Cases[ Lookup[ styles, # ], _RGBColor ] & /@ { UndirectedEdge[ 1, 2 ], UndirectedEdge[ 21, 22 ], UndirectedEdge[ 11, 12 ] } ] ],
  { First @ $InfraStrikeOutPalette, Red, Red },
  TestID -> "InfraSubstrateHighlight-Directive-styles-the-objects-after-it"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    With[ {
        once  = Lookup[ EdgeStyle /. Options @ InfraSubstrateHighlight[ g, { InfraSegment[ 1, 7 ] }, "ThicknessRange" -> 8 ], UndirectedEdge[ 1, 2 ] ],
        twice = Lookup[ EdgeStyle /. Options @ InfraSubstrateHighlight[ g, { InfraSegment[ 1, 7 ], InfraSegment[ 1, 7 ] }, "ThicknessRange" -> 8 ], UndirectedEdge[ 1, 2 ] ] },
      { Cases[ once, _AbsoluteThickness ], Cases[ twice, _AbsoluteThickness ],
        ColorDistance[ First @ Cases[ twice, _RGBColor ], Blend[ Take[ $InfraStrikeOutPalette, 2 ], { 1, 1 } ] ] < 10^-6 } ] ],
  { { AbsoluteThickness[ 4 ] }, { AbsoluteThickness[ 8 ] }, True },
  TestID -> "InfraSubstrateHighlight-overlap-sums-strength-and-blends-colour"
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
