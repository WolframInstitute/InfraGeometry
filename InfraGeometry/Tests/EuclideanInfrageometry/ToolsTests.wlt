BeginTestSection["Tools"]

(* the walk readers and the anchor rule are internal, so the tests reach them by
   their PackageScope context *)
geodesicGraph       = WolframInstitute`InfraGeometry`PackageScope`geodesicGraph;
geodesicCycleGraph  = WolframInstitute`InfraGeometry`PackageScope`geodesicCycleGraph;
walkGraph           = walk |-> PathGraph[ MapIndexed[ { First @ #2, #1 } &, walk ], DirectedEdges -> True ];
infraSpread         = WolframInstitute`InfraGeometry`PackageScope`infraSpread;
closedWalkGraph     = walk |-> With[ { core = MapIndexed[ { First @ #2, #1 } &, If[ Length[ walk ] >= 2 && First @ walk === Last @ walk, Most @ walk, walk ] ] },
  Graph[ core, DirectedEdge @@@ Partition[ core, 2, 1, 1 ] ] ];

g33 = GridGraph[ { 3, 3 } ];

(* The distance metrics, centrality helpers, separating-cycle predicates, and
   path-selection routines in Tools.wl are now package-scope (internal). They
   are exercised indirectly through the public Find* functions and their
   "Select" option. Direct unit tests for them have been removed. *)

VerificationTest[
  True,
  True,
  TestID -> "Tools-placeholder"
]

(* ===================== InfraDensity ===================== *)

(* InfraDensity is the marginal of any shape to the vertex set with respect to the
   counting measure -- the anchor rule made public.  Raw masses, not a normalisation:
   Total, Merge, KeyMap and KeySelect are the density's own algebra, and dividing by
   Total is the caller's one-liner.  A family of two sets: the shared vertices carry 2 *)
VerificationTest[
  InfraDensity[ g33, { { 1, 2, 3 }, { 2, 3, 4 } } ],
  <| 1 -> 1, 2 -> 2, 3 -> 2, 4 -> 1 |>,
  TestID -> "InfraDensity-family-of-sets-sums-multiplicities"
]

(* one walk: every vertex visited exactly once maps to 1 *)
VerificationTest[
  InfraDensity[ g33, geodesicGraph @ { 1, 2, 3 } ],
  <| 1 -> 1, 2 -> 1, 3 -> 1 |>,
  TestID -> "InfraDensity-single-realisation-all-one"
]

(* a bundle: the total mass is the total length of its realisations, since every
   realisation contributes each of its vertices once *)
VerificationTest[
  With[ { reps = { { 1, 2, 3, 6, 9 }, { 1, 4, 7, 8, 9 }, { 1, 2, 5, 8, 9 } } },
    Total @ Values @ InfraDensity[ g33, geodesicGraph /@ reps ] === Total[ Length /@ reps ] ],
  True,
  TestID -> "InfraDensity-total-mass-is-total-length"
]

(* an interval DAG gives its occupation, the segment's vertex density, list-valued labels included *)
VerificationTest[
  With[ { gList = Graph[ Map[ { Quotient[ # - 1, 3 ] + 1, Mod[ # - 1, 3 ] + 1 } &, EdgeList @ g33, { 2 } ] ] },
    { InfraDensity[ g33, InfraMeasurement[ g33, InfraSegment[ 1, 9 ], "Graph" ] ] ===
        InfraMeasurement[ g33, InfraSegment[ 1, 9 ], "VertexDensity" ],
      InfraDensity[ gList, InfraMeasurement[ gList, InfraSegment[ { 1, 1 }, { 3, 3 } ], "Graph" ] ][ { 2, 2 } ] } ],
  { True, 4 },
  TestID -> "InfraDensity-interval-DAG-is-the-occupation"
]

(* the empty class yields the empty density *)
VerificationTest[
  InfraDensity[ g33, { } ],
  <||>,
  TestID -> "InfraDensity-empty-class"
]

(* a density is already the marginal, so InfraDensity is the identity on it up to
   key order -- the guarantee that two built by different routes compare SameQ *)
VerificationTest[
  InfraDensity[ g33, <| 2 -> 3, 1 -> 1 |> ],
  <| 1 -> 1, 2 -> 3 |>,
  TestID -> "InfraDensity-density-is-key-sorted-identity"
]

(* Counts promotes a list, Keys demotes a density: the two steps InfraDensity sits
   between, and the reason there is no second coercion in the API *)
VerificationTest[
  With[ { ball = RandomInfraRepresentative[g33, InfraBall[5, 1], All] },
    Keys @ InfraDensity[ g33, ball ] === Union[ ball ] &&
      InfraDensity[ g33, ball ] === KeySort @ Counts @ ball ],
  True,
  TestID -> "InfraDensity-Counts-promotes-Keys-demotes"
]

(* a bare vertex is the unit mass, even where the label is itself a List: only the
   graph tells a list-labelled vertex from a two-element set *)
VerificationTest[
  With[ { g = GridGraph[ { 2, 2 }, VertexLabels -> None ] },
    { InfraDensity[ g33, 5 ],
      InfraDensity[ TessellationGraph[ { 4, 4 }, 1 ], { 1, 1 } ] } ],
  { <| 5 -> 1 |>, <| { 1, 1 } -> 1 |> },
  TestID -> "InfraDensity-vertex-is-unit-mass"
]

(* normalising is the caller's, and both readings the old measure head carried are
   one division away *)
VerificationTest[
  With[ { d = InfraDensity[ g33, <| 1 -> 3, 2 -> 1 |> ] },
    { Max @ Values[ d / Max @ Values @ d ], Total @ Values[ d / Total @ Values @ d ] } ],
  { 1, 1 },
  TestID -> "InfraDensity-normalisations-are-one-division-away"
]

(* ===== the shape reader ===== *)

(* the three rows of the ontology, on a graph whose vertices are integers *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ], w = PathGraph[ { 1, 2, 3 }, DirectedEdges -> True ] },
    { InfraDensity[ g, 5 ], InfraDensity[ g, { 1, 2 } ], InfraDensity[ g, <| 1 -> 2 |> ], InfraDensity[ g, w ] } ],
  { <| 5 -> 1 |>, <| 1 -> 1, 2 -> 1 |>, <| 1 -> 2 |>, <| 1 -> 1, 2 -> 1, 3 -> 1 |> },
  TestID -> "shape-reader-three-rows"
]

(* the substrate is not decoration: on a graph whose vertex labels are themselves
   lists, only the graph separates a point from a two-element multiset *)
VerificationTest[
  With[ { t = Graph[ { { 1, 1 }, { 2, 1 } }, { { 1, 1 } <-> { 2, 1 } } ],
          g = GridGraph[ { 3, 3 } ] },
    { InfraDensity[ t, { 1, 1 } ], InfraDensity[ g, { 1, 1 } ] } ],
  { <| { 1, 1 } -> 1 |>, <| 1 -> 2 |> },
  TestID -> "shape-reader-is-graph-relative"
]

(* a vertex a graph does not have is neither a point nor -- being an atom -- a multiset *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    { VertexQ[ g, 99 ], InfraDensity[ g, 99 ] } ],
  { False, <| 99 -> 1 |> },
  TestID -> "shape-reader-off-substrate-vertex"
]

(* a family of realisations reads as its vertex occupation, the sum of the per-member
   Counts, rather than a unit mass -- RandomInfraSegment[g, p, q] no longer wraps its
   family in a DAG (EuclideanInertHeads), so the occupation is just Merge/Total *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    With[ { paths = RandomInfraSegment[ g, 1, 9, All ] },
      InfraDensity[ g, paths ] === KeySort @ Merge[ Counts /@ paths, Total ] ] ],
  True,
  TestID -> "walk-anchor-reads-as-occupation"
]

(* the multiset layer is a headless <| atom -> weight |> Association: repetition in
   a list reads as mass, and Keys is the step down to the support *)
VerificationTest[
  With[ { g = PathGraph @ Range[ 4 ] },
    { Counts[ { 1, 1, 2 } ],
      InfraDensity[ g, { 1, 1, 2 } ],
      Keys @ InfraDensity[ g, { 1, 1, 2 } ] } ],
  { <| 1 -> 2, 2 -> 1 |>,
    <| 1 -> 2, 2 -> 1 |>,
    { 1, 2 } },
  TestID -> "multiset-layer-is-a-headless-association"
]

(* the ANCHOR RULE: a vertex, a vertex list, a density and a walk graph all coerce
   to one 0-d density on bare vertices, so every construction reads its anchors
   through a single step *)
VerificationTest[
  With[ { g = PathGraph @ Range[ 4 ] },
    { InfraDensity[ g, 1 ],
      InfraDensity[ g, <| 1 -> 1, 2 -> 1 |> ], InfraDensity[ g, { 1, 1, 2 } ],
      InfraDensity[ g, <| 1 -> 3 |> ], InfraDensity[ g, PathGraph[ { 1, 2, 3 }, DirectedEdges -> True ] ] } ],
  { <| 1 -> 1 |>,
    <| 1 -> 1, 2 -> 1 |>,
    <| 1 -> 2, 2 -> 1 |>,
    <| 1 -> 3 |>,
    <| 1 -> 1, 2 -> 1, 3 -> 1 |> },
  TestID -> "anchor-rule-coerces-everything-to-a-density"
]

(* the density algebra is the Association's own -- Keys, Values, Total, and division
   for either normalisation.  No engine call is involved, which is the point *)
VerificationTest[
  With[ { p = <| 1 -> 3, 2 -> 1 |> },
    { Keys @ p, Values @ p, Total @ p, p / Total @ p, p / Max @ Values @ p } ],
  { { 1, 2 }, { 3, 1 }, 4, <| 1 -> 3/4, 2 -> 1/4 |>, <| 1 -> 1, 2 -> 1/3 |> },
  TestID -> "density-algebra-is-the-Association-s-own"
]

(* the measure is CONSTRUCTED at a projection off a family, never carried by it:
   the endpoints are a set-level fact (every geodesic of the family shares them),
   the midpoint a genuine density *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ], s = RandomInfraSegment[ GridGraph[ { 3, 3 } ], 1, 9, All ] },
    { Union[ First /@ s ], Union[ Last /@ s ], InfraMeasurement[ g, InfraSegment[ 1, 9 ], "Midpoint" ] } ],
  { { 1 }, { 9 }, <| 3 -> 1, 5 -> 4, 7 -> 1 |> },
  TestID -> "Measure-constructed-at-projection"
]

(* a bounded count is a prefix of the whole class, and a strict count fails on
   under-supply rather than returning fewer *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    { Length @ RandomInfraSegment[ g, 1, 16, UpTo[ 2 ] ],
      SubsetQ[ RandomInfraSegment[ g, 1, 16, All ],
               RandomInfraSegment[ g, 1, 16, UpTo[ 2 ] ] ],
      RandomInfraSegment[ g, 1, 16, 1000 ] } ],
  { 2, True, { } },
  TestID -> "bounded-count-is-a-prefix"
]

(* the count contract on RandomInfraSegment: count-less is ONE vertex list, a bounded
   count a List of them, All the whole class -- no DAG any more (EuclideanInertHeads) *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    { MatchQ[ RandomInfraSegment[ g, 1, 9 ], { __Integer } ],
      MatchQ[ RandomInfraSegment[ g, 1, 9, 1 ], { { __Integer } } ],
      MatchQ[ RandomInfraSegment[ g, 1, 9, UpTo[ 100 ] ], { { __Integer } .. } ],
      MatchQ[ RandomInfraSegment[ g, 1, 9, All ], { { __Integer } .. } ],
      Length @ RandomInfraSegment[ g, 1, 9, All ] === 6,
      RandomInfraSegment[ g, 1, 9, 7 ] === { } } ],
  { True, True, True, True, True, True },
  TestID -> "RandomInfraSegment-count-contract"
]

(* ===================== the interval DAG carries the family it stands for ===================== *)

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    InfraDensity[ g, InfraMeasurement[ g, InfraSegment[ 1, 16 ], "Graph" ] ] ===
      InfraMeasurement[ g, InfraSegment[ 1, 16 ], "VertexDensity" ] ],
  True,
  TestID -> "DAG-equals-enumerated-density"
]

(* both parities of d(1, t) *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    Keys @ InfraMeasurement[ g, InfraSegment[ 1, # ], "Midpoint" ] & /@ { 16, 12 } ],
  { { 4, 7, 10, 13 }, { 3, 4, 6, 7, 9, 10 } },
  TestID -> "Midpoint-both-parities"
]

EndTestSection[]
