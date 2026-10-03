BeginTestSection["MethodLadder"]

(* ===================== The class-invariance contract ===================== *)

(* the next-vertex function never changes the class: Identity and RandomSample enumerate the same realisation set under All.  canon normalises a realisation whose order carries no information (a vertex set); a walk keeps its sequence *)

classInvariantQ[ call_, canon_ : Identity ] :=
  SameQ @@ ( Sort[ canon /@ reps @ call[ # ] ] & /@ { Identity, RandomSample } )

(* the realisations of a returned class, read off its shape: a walk graph or a DAG
   spreads into vertex sequences, a List of walk graphs into all of theirs, and a
   List of sets or of leg-lists IS the list of realisations *)
infraSpread = WolframInstitute`InfraGeometry`PackageScope`infraSpread;

reps[ { } ]                := { }
reps[ x_Graph ]            := infraSpread @ x
reps[ x : { __Graph } ]    := infraSpread @ x
reps[ x_List ]             := x
reps[ x_ ]                 := { x }
sortReps[ x_ ] := Sort @ Replace[ reps @ x, l_List :> Sort @ l, { 1 } ]


(* ===================== Distance-matrix family ===================== *)

(* FindInfraSegment, FindInfraLine, FindInfraRay and the circle finder left the Method
   ladder on 2026-09-26 (EuclideanInertHeads): the count fixes the mode and the only
   modifiers are "RandomChoice" / "Pruning" on FindInfraRepresentative, so they carry no Method
   axis of their own to be invariant under any more. *)

VerificationTest[
  classInvariantQ[ m |-> ExtendInfraSegment[ TorusGraph[ { 4, 5 } ], { 1, 2 }, Infinity, All, "NextVertexFunction" -> m ] ],
  True,
  TestID -> "ExtendInfraSegment-class-invariant-under-NextVertexFunction"
]

(* the parallels through the centre of the 5 x 5 grid in the level set of its first row: one chain, the middle row *)
VerificationTest[
  classInvariantQ[ m |-> FindInfraParallel[ GridGraph[ { 5, 5 } ], Range[ 5 ], 13, All, "NextVertexFunction" -> m ] ],
  True,
  TestID -> "FindInfraParallel-class-invariant-under-NextVertexFunction"
]

(* two dead ends 11, 12 hang off 8 at distance 1 from the row 1..5: the chain 11-8-12 is inextensible in the level set but shorter than 6-7-8-11, so a longest-only sweep would drop it -- the class holds all six *)
VerificationTest[
  With[ { g = Graph[ Join[
        UndirectedEdge @@@ Partition[ Range[ 5 ], 2, 1 ],
        UndirectedEdge @@@ Partition[ Range[ 6, 10 ], 2, 1 ],
        UndirectedEdge @@@ Transpose[ { Range[ 5 ], Range[ 6, 10 ] } ],
        { 11 <-> 8, 11 <-> 3, 12 <-> 8, 12 <-> 3 } ] ] },
    classInvariantQ[ m |-> FindInfraParallel[ g, Range[ 5 ], 8, All, "NextVertexFunction" -> m ] ] ],
  True,
  TestID -> "FindInfraParallel-class-invariant-dead-ends"
]

(* the corner polygon is the product of its sides' geodesic classes: the diagonal side 9 -> 1 of the 3 x 3 grid has six geodesics, the other two one each *)
VerificationTest[
  With[ { call = m |-> FindInfraPolygon[ GridGraph[ { 3, 3 } ], { 1, 3, 9 }, All, "NextVertexFunction" -> m ] },
    { classInvariantQ[ call ], Length @ reps @ call[ Identity ] } ],
  { True, 6 },
  TestID -> "FindInfraPolygon-class-invariant-under-NextVertexFunction"
]

VerificationTest[
  classInvariantQ[ m |-> FindInfraTriangle[ GridGraph[ { 3, 3 } ], { 1, 3, 9 }, All, "NextVertexFunction" -> m ] ],
  True,
  TestID -> "FindInfraTriangle-class-invariant-under-NextVertexFunction"
]

(* a bounded count streams n geodesics per side and reads the first members of their product: prefixes of length n multiply to at least Min[n, |class|] polygons, so a strict count is exact under every next-vertex function and a soft count past the class returns the class *)
VerificationTest[
  Table[ Length @ FindInfraPolygon[ GridGraph[ { 3, 3 } ], { 1, 3, 9 }, n, "NextVertexFunction" -> m ],
    { m, { Identity, RandomSample } }, { n, { 1, 4, UpTo[ 10 ] } } ],
  ConstantArray[ { 1, 4, 6 }, 2 ],
  TestID -> "FindInfraPolygon-bounded-count-is-exact-under-NextVertexFunction"
]

(* four diagonal sides of the 4 x 4 grid with twenty geodesics each, 160 000 polygons: a strict count streams that many distinct members without forming the product *)
VerificationTest[
  Table[ With[ { polys = FindInfraPolygon[ GridGraph[ { 4, 4 } ], { 1, 16, 4, 13 }, 50, "NextVertexFunction" -> m ] },
      { Length @ polys, DuplicateFreeQ @ polys, AllTrue[ polys, InfraPolygonQ[ GridGraph[ { 4, 4 } ], # ] & ] } ],
    { m, { Identity, RandomSample } } ],
  ConstantArray[ { 50, True, True }, 2 ],
  TestID -> "FindInfraPolygon-strict-count-streams-off-the-product"
]


(* ===================== Walk family ===================== *)

VerificationTest[
  classInvariantQ[ f |-> FindInfraWalk[ GridGraph[ { 3, 3 } ], 1, UpTo[ 6 ], All,
    Properties -> { "Immersed" }, "StoppingCondition" -> 1, "NextVertexFunction" -> f ] ],
  True,
  TestID -> "FindInfraWalk-pointed-class-invariant-under-NextVertexFunction"
]

VerificationTest[
  classInvariantQ[ f |-> FindInfraWalk[ GridGraph[ { 3, 3 } ], 1, 9, UpTo[ 6 ], All, Properties -> { "Generic" }, "NextVertexFunction" -> f ] ],
  True,
  TestID -> "FindInfraWalk-two-point-class-invariant-under-NextVertexFunction"
]

VerificationTest[
  classInvariantQ[ f |-> ExtendInfraWalk[ GridGraph[ { 3, 3 } ], { 1, 2 }, UpTo[ 3 ], All, "NextVertexFunction" -> f ] ],
  True,
  TestID -> "ExtendInfraWalk-class-invariant-under-NextVertexFunction"
]

VerificationTest[
  classInvariantQ[ f |-> FindInfraGeodesic[ GridGraph[ { 4, 4 } ], 1, 2, UpTo[ 4 ], All, "NextVertexFunction" -> f ] ],
  True,
  TestID -> "FindInfraGeodesic-pointed-class-invariant-under-NextVertexFunction"
]

VerificationTest[
  classInvariantQ[ f |-> FindInfraGeodesic[ TorusGraph[ { 4, 5 } ], 1, 8, 2, UpTo[ 6 ], All, "NextVertexFunction" -> f ] ],
  True,
  TestID -> "FindInfraGeodesic-two-point-class-invariant-under-NextVertexFunction"
]

VerificationTest[
  classInvariantQ[ f |-> ExtendInfraGeodesic[ TorusGraph[ { 4, 5 } ], { 1, 2 }, 2, UpTo[ 3 ], All, "NextVertexFunction" -> f ] ],
  True,
  TestID -> "ExtendInfraGeodesic-class-invariant-under-NextVertexFunction"
]

(* on the walk family a count-less call is the first instance of the canonical descent: the same witness twice without a seed, the Identity one, and the First one where the first branch reaches the target; a two-sided extension re-checks the joined step, so its first joint move may fail where a later one passes, and First is pinned on the one-sided directions *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    AllTrue[
      { f |-> FindInfraWalk[ g, 1, UpTo[ 4 ], "NextVertexFunction" -> f ],
        f |-> FindInfraWalk[ g, 1, 2, UpTo[ 4 ], "NextVertexFunction" -> f ],
        f |-> ExtendInfraWalk[ g, { 1, 2 }, UpTo[ 2 ], "Direction" -> "Forward", "NextVertexFunction" -> f ],
        f |-> FindInfraGeodesic[ g, 1, 2, UpTo[ 4 ], "NextVertexFunction" -> f ],
        f |-> ExtendInfraGeodesic[ g, { 6, 7 }, Infinity, UpTo[ 2 ], "Direction" -> "Forward", "NextVertexFunction" -> f ] },
      call |-> call[ Identity ] === call[ Identity ] === call[ First ] ] ],
  True,
  TestID -> "WalkFamily-countless-is-the-canonical-witness"
]


(* ===================== Peel family ===================== *)

VerificationTest[
  classInvariantQ[ m |-> FindInfraSphere[ GridGraph[ { 4, 4 } ], 6, { 1, 2 }, All, Properties -> { "Separating" }, "NextVertexFunction" -> m ], Sort ],
  True,
  TestID -> "FindInfraSphere-class-invariant-under-NextVertexFunction"
]

(* the band is columns 2 and 3; a minimal separator takes exactly one vertex per row, 2^4 of them *)
VerificationTest[
  With[ { call = m |-> FindInfraBisectingHyperplane[ GridGraph[ { 4, 4 } ], 1, 4, { -1, 1 }, All,
      Properties -> { "Separating" }, "NextVertexFunction" -> m ] },
    { classInvariantQ[ call, Sort ], Length @ reps @ call[ Identity ] } ],
  { True, 16 },
  TestID -> "FindInfraBisectingHyperplane-class-invariant-under-NextVertexFunction"
]

VerificationTest[
  classInvariantQ[ m |-> FindInfraEllipticShell[ GridGraph[ { 4, 4 } ], { 6, 11 }, { 3, 4 }, All,
    Properties -> { "Separating" }, "NextVertexFunction" -> m ], Sort ],
  True,
  TestID -> "FindInfraEllipticShell-class-invariant-under-NextVertexFunction"
]

(* the peel from the centre of the 5 x 5 grid: sixteen minimal separators, and the lazy peel reaches each subset once -- without its visited set this ran minutes *)
VerificationTest[
  With[ { call = m |-> FindInfraSphere[ GridGraph[ { 5, 5 } ], 13, { 1, 2 }, All, Properties -> { "Separating" }, "NextVertexFunction" -> m ] },
    { classInvariantQ[ call, Sort ], Length @ reps @ call[ Identity ] } ],
  { True, 16 },
  TestID -> "FindInfraSphere-5x5-class-invariant-under-NextVertexFunction"
]


(* ===================== Ellipse family ===================== *)

(* the elliptic level band {4, 8} of the foci 25, 12 on the 7 x 7 grid: the sweep's shortest separating grade, the same class under every next-vertex function *)
VerificationTest[
  classInvariantQ[ m |-> FindInfraEllipse[ GridGraph[ { 7, 7 } ], { 25, 12 }, { 4, 8 }, All, "NextVertexFunction" -> m ] ],
  True,
  TestID -> "FindInfraEllipse-class-invariant-under-NextVertexFunction"
]

(* off the "Shortest" tie the sweep runs every grade: six cycles in the level set of 2, 15 at c = 4 *)
VerificationTest[
  With[ { call = m |-> FindInfraEllipse[ GridGraph[ { 4, 4 } ], { 2, 15 }, 4, All, Properties -> { }, "NextVertexFunction" -> m ] },
    { classInvariantQ[ call ], Length @ reps @ call[ Identity ] } ],
  { True, 6 },
  TestID -> "FindInfraEllipse-sweep-class-invariant-under-NextVertexFunction"
]


(* ===================== Regular polygon ===================== *)

(* the sixteen unit squares of the 5 x 5 grid: the candidate sweep is not lazy, so the next-vertex function only orders what the count takes *)
VerificationTest[
  With[ { call = m |-> FindInfraRegularPolygon[ GridGraph[ { 5, 5 } ], { 1 }, 4, All, "NextVertexFunction" -> m ] },
    { classInvariantQ[ call ], Length @ reps @ call[ Identity ] } ],
  { True, 16 },
  TestID -> "FindInfraRegularPolygon-class-invariant-under-NextVertexFunction"
]

(* ===================== Automatic is the deterministic descent ===================== *)

(* on every ladder symbol a count-less call is the first instance of the canonical descent: the same witness twice without a seed, and the explicit Identity one *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ], t = TorusGraph[ { 4, 5 } ] },
    AllTrue[
      { m |-> ExtendInfraSegment[ g, { 6, 7 }, 2, "NextVertexFunction" -> m ],
        m |-> FindInfraParallel[ g, Range[ 4 ], 10, "NextVertexFunction" -> m ],
        m |-> FindInfraSphere[ g, 6, { 1, 2 }, Properties -> { "Separating" }, "NextVertexFunction" -> m ],
        m |-> FindInfraBisectingHyperplane[ g, 1, 4, { -1, 1 }, Properties -> { "Separating" }, "NextVertexFunction" -> m ],
        m |-> FindInfraEllipticShell[ g, { 6, 11 }, { 3, 4 }, Properties -> { "Separating" }, "NextVertexFunction" -> m ],
        m |-> FindInfraPolygon[ GridGraph[ { 3, 3 } ], { 1, 3, 9 }, "NextVertexFunction" -> m ],
        m |-> FindInfraTriangle[ GridGraph[ { 3, 3 } ], { 1, 3, 9 }, "NextVertexFunction" -> m ],
        m |-> FindInfraEllipse[ GridGraph[ { 7, 7 } ], { 25, 12 }, { 4, 8 }, "NextVertexFunction" -> m ],
        m |-> FindInfraRegularPolygon[ GridGraph[ { 5, 5 } ], { 1 }, 4, "NextVertexFunction" -> m ] },
      call |-> call[ Identity ] === call[ Identity ] ] ],
  True,
  TestID -> "MethodLadder-countless-is-the-canonical-witness-on-every-symbol"
]


(* ===================== A random order is the whole class ===================== *)

(* RandomSample as the next-vertex function changes the order of the members, never the set All returns *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ], t = TorusGraph[ { 4, 5 } ] },
    AllTrue[
      { m |-> ExtendInfraSegment[ g, { 6, 7 }, 2, All, "NextVertexFunction" -> m ],
        m |-> FindInfraParallel[ g, Range[ 4 ], 10, All, "NextVertexFunction" -> m ],
        m |-> FindInfraSphere[ g, 6, { 1, 2 }, All, Properties -> { "Separating" }, "NextVertexFunction" -> m ],
        m |-> FindInfraBisectingHyperplane[ g, 1, 4, { -1, 1 }, All, Properties -> { "Separating" }, "NextVertexFunction" -> m ],
        m |-> FindInfraEllipticShell[ g, { 6, 11 }, { 3, 4 }, All, Properties -> { "Separating" }, "NextVertexFunction" -> m ],
        m |-> FindInfraPolygon[ GridGraph[ { 3, 3 } ], { 1, 3, 9 }, All, "NextVertexFunction" -> m ],
        m |-> FindInfraTriangle[ GridGraph[ { 3, 3 } ], { 1, 3, 9 }, All, "NextVertexFunction" -> m ],
        m |-> FindInfraEllipse[ GridGraph[ { 7, 7 } ], { 25, 12 }, { 4, 8 }, All, "NextVertexFunction" -> m ],
        m |-> FindInfraRegularPolygon[ GridGraph[ { 5, 5 } ], { 1 }, 4, All, "NextVertexFunction" -> m ] },
      call |-> sortReps @ call[ RandomSample ] === sortReps @ call[ Identity ] ] ],
  True,
  TestID -> "MethodLadder-RandomSample-is-the-whole-class"
]

EndTestSection[]
