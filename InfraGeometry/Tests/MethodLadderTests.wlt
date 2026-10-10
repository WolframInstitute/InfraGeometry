BeginTestSection["MethodLadder"]

(* the generic class: no cusp, no third visit, no self-tangency *)
genericRules = { { "Simple", 2 }, w |-> Count[ w, Last @ w ] <= 2 && WalkSingularities[ w ][ "SelfTangencies" ] === { } };

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

VerificationTest[
  classInvariantQ[ m |-> RandomInfraGeodesic[ TorusGraph[ { 4, 5 } ], { 1, 2 }, Infinity, Infinity, All, "NextVertexFunction" -> m,
      "Direction" -> "BothSides" ] ],
  True,
  TestID -> "RandomInfraGeodesic-walk-germ-lines-class-invariant-under-NextVertexFunction"
]

(* the parallels through the centre of the 5 x 5 grid in the level set of its first row: one chain, the middle row *)
VerificationTest[
  classInvariantQ[ m |-> RandomInfraParallel[ GridGraph[ { 5, 5 } ], Range[ 5 ], 13, All, "NextVertexFunction" -> m ] ],
  True,
  TestID -> "RandomInfraParallel-class-invariant-under-NextVertexFunction"
]

(* two dead ends 11, 12 hang off 8 at distance 1 from the row 1..5: the chain 11-8-12 is inextensible in the level set but shorter than 6-7-8-11, so a longest-only sweep would drop it -- the class holds all six *)
VerificationTest[
  With[ { g = Graph[ Join[
        UndirectedEdge @@@ Partition[ Range[ 5 ], 2, 1 ],
        UndirectedEdge @@@ Partition[ Range[ 6, 10 ], 2, 1 ],
        UndirectedEdge @@@ Transpose[ { Range[ 5 ], Range[ 6, 10 ] } ],
        { 11 <-> 8, 11 <-> 3, 12 <-> 8, 12 <-> 3 } ] ] },
    classInvariantQ[ m |-> RandomInfraParallel[ g, Range[ 5 ], 8, All, "NextVertexFunction" -> m ] ] ],
  True,
  TestID -> "RandomInfraParallel-class-invariant-dead-ends"
]

(* ===================== Walk family ===================== *)

VerificationTest[
  classInvariantQ[ f |-> RandomInfraWalk[ GridGraph[ { 3, 3 } ], 1, UpTo[ 6 ], All,
    Properties -> { { "Simple", 2 } }, "StoppingCondition" -> ( Length[ # ] - Length[ DeleteDuplicates @ # ] >= 1 & ), "NextVertexFunction" -> f ] ],
  True,
  TestID -> "RandomInfraWalk-pointed-class-invariant-under-NextVertexFunction"
]

VerificationTest[
  classInvariantQ[ f |-> Select[
    RandomInfraWalk[ GridGraph[ { 3, 3 } ], 1, UpTo[ 6 ], All, Properties -> genericRules,
      "StoppingCondition" -> ( Last[ # ] === 9 & ), "NextVertexFunction" -> f ],
    Last @ Last @ VertexList @ # === 9 & ] ],
  True,
  TestID -> "RandomInfraWalk-endpoint-stopping-condition-class-invariant-under-NextVertexFunction"
]

VerificationTest[
  classInvariantQ[ f |-> RandomInfraWalk[ GridGraph[ { 3, 3 } ], { 1, 2 }, UpTo[ 3 ], All, Properties -> { "Simple" }, "NextVertexFunction" -> f,
      "Direction" -> "BothSides" ] ],
  True,
  TestID -> "RandomInfraWalk-germ-class-invariant-under-NextVertexFunction"
]

VerificationTest[
  classInvariantQ[ f |-> RandomInfraGeodesic[ GridGraph[ { 4, 4 } ], 1, 2, UpTo[ 4 ], All, "NextVertexFunction" -> f ] ],
  True,
  TestID -> "RandomInfraGeodesic-pointed-class-invariant-under-NextVertexFunction"
]

VerificationTest[
  classInvariantQ[ f |-> Select[
    RandomInfraGeodesic[ TorusGraph[ { 4, 5 } ], 1, 2, UpTo[ 6 ], All,
      "StoppingCondition" -> ( Last[ # ] === 8 & ), "NextVertexFunction" -> f ],
    Last @ Last @ VertexList @ # === 8 & ] ],
  True,
  TestID -> "RandomInfraGeodesic-endpoint-stopping-condition-class-invariant-under-NextVertexFunction"
]

VerificationTest[
  classInvariantQ[ f |-> RandomInfraGeodesic[ TorusGraph[ { 4, 5 } ], { 1, 2 }, 2, UpTo[ 3 ], All, "NextVertexFunction" -> f,
      "Direction" -> "BothSides" ] ],
  True,
  TestID -> "RandomInfraGeodesic-germ-class-invariant-under-NextVertexFunction"
]

(* a soft rule weighs the candidates and never filters them: the class is the
   same under Identity, RandomSample and Automatic, which draws by the weights *)
VerificationTest[
  With[ { call = f |-> RandomInfraWalk[ GridGraph[ { 4, 4 } ], 6, { 4 }, All, Properties -> { "Simple", { "Shortest", 3, 0.3 } },
      "NextVertexFunction" -> f ] },
    { classInvariantQ[ call ], classInvariantQ[ f |-> call[ f /. RandomSample -> Automatic ] ] } ],
  { True, True },
  TestID -> "RandomInfraWalk-soft-rule-class-invariant-under-NextVertexFunction"
]

(* on the walk family a count-less call is the first instance of the canonical descent: the same witness twice without a seed, the Identity one, and the First one where the first branch ends the walk, here the stopping condition firing at its first arrival at 2 or the budget spent; a two-sided extension re-checks the joined step, so its first joint move may fail where a later one passes, and First is pinned on the one-sided directions *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    AllTrue[
      { f |-> RandomInfraWalk[ g, 1, UpTo[ 4 ], Properties -> { "Simple" }, "NextVertexFunction" -> f ],
        f |-> RandomInfraWalk[ g, 1, UpTo[ 4 ], Properties -> { "Simple" }, "StoppingCondition" -> ( Last[ # ] === 2 & ), "NextVertexFunction" -> f ],
        f |-> RandomInfraWalk[ g, { 1, 2 }, UpTo[ 2 ], Properties -> { "Simple" }, "NextVertexFunction" -> f, "Direction" -> "Forward" ],
        f |-> RandomInfraGeodesic[ g, 1, 2, UpTo[ 4 ], "NextVertexFunction" -> f ],
        f |-> RandomInfraGeodesic[ g, { 6, 7 }, Infinity, UpTo[ 2 ], "NextVertexFunction" -> f, "Direction" -> "Forward" ] },
      call |-> call[ Identity ] === call[ Identity ] === call[ First ] ] ],
  True,
  TestID -> "WalkFamily-countless-is-the-canonical-witness"
]


(* ===================== Peel family ===================== *)

VerificationTest[
  classInvariantQ[ m |-> RandomInfraSphere[ GridGraph[ { 4, 4 } ], 6, { 1, 2 }, All, Properties -> { "Separating" }, "NextVertexFunction" -> m ], Sort ],
  True,
  TestID -> "RandomInfraSphere-class-invariant-under-NextVertexFunction"
]

(* the band is columns 2 and 3; a minimal separator takes exactly one vertex per row, 2^4 of them *)
VerificationTest[
  With[ { call = m |-> FindInfraBisectingHyperplane[ GridGraph[ { 4, 4 } ], 1, 4, { -1, 1 }, All,
      Properties -> { "Separating" }, "NextVertexFunction" -> m ] },
    { classInvariantQ[ call, Sort ], Length @ reps @ call[ Identity ] } ],
  { True, 16 },
  TestID -> "FindInfraBisectingHyperplane-class-invariant-under-NextVertexFunction"
]

(* the peel from the centre of the 5 x 5 grid: sixteen minimal separators, and the lazy peel reaches each subset once -- without its visited set this ran minutes *)
VerificationTest[
  With[ { call = m |-> RandomInfraSphere[ GridGraph[ { 5, 5 } ], 13, { 1, 2 }, All, Properties -> { "Separating" }, "NextVertexFunction" -> m ] },
    { classInvariantQ[ call, Sort ], Length @ reps @ call[ Identity ] } ],
  { True, 16 },
  TestID -> "RandomInfraSphere-5x5-class-invariant-under-NextVertexFunction"
]


(* ===================== Ellipse family ===================== *)

(* the elliptic level band {4, 8} of the foci 25, 12 on the 7 x 7 grid: the sweep's shortest separating grade, the same class under every next-vertex function *)
VerificationTest[
  classInvariantQ[ m |-> RandomInfraEllipse[ GridGraph[ { 7, 7 } ], { 25, 12 }, { 4, 8 }, All, "NextVertexFunction" -> m ] ],
  True,
  TestID -> "RandomInfraEllipse-class-invariant-under-NextVertexFunction"
]

(* off the "Shortest" tie the sweep runs every grade: six cycles in the level set of 2, 15 at c = 4 *)
VerificationTest[
  With[ { call = m |-> RandomInfraEllipse[ GridGraph[ { 4, 4 } ], { 2, 15 }, 4, All, Properties -> { }, "NextVertexFunction" -> m ] },
    { classInvariantQ[ call ], Length @ reps @ call[ Identity ] } ],
  { True, 6 },
  TestID -> "RandomInfraEllipse-sweep-class-invariant-under-NextVertexFunction"
]


(* ===================== Regular polygon ===================== *)

(* the sixteen unit squares of the 5 x 5 grid: the candidate sweep is not lazy, so the next-vertex function only orders what the count takes *)
VerificationTest[
  With[ { call = m |-> RandomInfraRegularPolygon[ GridGraph[ { 5, 5 } ], { 1 }, 4, All, "NextVertexFunction" -> m ] },
    { classInvariantQ[ call ], Length @ reps @ call[ Identity ] } ],
  { True, 16 },
  TestID -> "RandomInfraRegularPolygon-class-invariant-under-NextVertexFunction"
]

(* ===================== Automatic is the deterministic descent ===================== *)

(* on every ladder symbol a count-less call is the first instance of the canonical descent: the same witness twice without a seed, and the explicit Identity one *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ], t = TorusGraph[ { 4, 5 } ] },
    AllTrue[
      { m |-> RandomInfraGeodesic[ g, { 6, 7 }, Infinity, UpTo[ 2 ], "NextVertexFunction" -> m, "Direction" -> "BothSides" ],
        m |-> RandomInfraParallel[ g, Range[ 4 ], 10, "NextVertexFunction" -> m ],
        m |-> RandomInfraSphere[ g, 6, { 1, 2 }, Properties -> { "Separating" }, "NextVertexFunction" -> m ],
        m |-> FindInfraBisectingHyperplane[ g, 1, 4, { -1, 1 }, Properties -> { "Separating" }, "NextVertexFunction" -> m ],
        m |-> RandomInfraEllipse[ GridGraph[ { 7, 7 } ], { 25, 12 }, { 4, 8 }, "NextVertexFunction" -> m ],
        m |-> RandomInfraRegularPolygon[ GridGraph[ { 5, 5 } ], { 1 }, 4, "NextVertexFunction" -> m ] },
      call |-> call[ Identity ] === call[ Identity ] ] ],
  True,
  TestID -> "MethodLadder-countless-is-the-canonical-witness-on-every-symbol"
]


(* ===================== A random order is the whole class ===================== *)

(* RandomSample as the next-vertex function changes the order of the members, never the set All returns *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ], t = TorusGraph[ { 4, 5 } ] },
    AllTrue[
      { m |-> RandomInfraGeodesic[ g, { 6, 7 }, Infinity, UpTo[ 2 ], All, "NextVertexFunction" -> m, "Direction" -> "BothSides" ],
        m |-> RandomInfraParallel[ g, Range[ 4 ], 10, All, "NextVertexFunction" -> m ],
        m |-> RandomInfraSphere[ g, 6, { 1, 2 }, All, Properties -> { "Separating" }, "NextVertexFunction" -> m ],
        m |-> FindInfraBisectingHyperplane[ g, 1, 4, { -1, 1 }, All, Properties -> { "Separating" }, "NextVertexFunction" -> m ],
        m |-> RandomInfraEllipse[ GridGraph[ { 7, 7 } ], { 25, 12 }, { 4, 8 }, All, "NextVertexFunction" -> m ],
        m |-> RandomInfraRegularPolygon[ GridGraph[ { 5, 5 } ], { 1 }, 4, All, "NextVertexFunction" -> m ] },
      call |-> sortReps @ call[ RandomSample ] === sortReps @ call[ Identity ] ] ],
  True,
  TestID -> "MethodLadder-RandomSample-is-the-whole-class"
]


(* the orthogonal axes and rays: All is a list of sets, a set of walks whose order carries no information *)
VerificationTest[
  With[ { g = GridGraph[ { 7, 7 } ] },
    { classInvariantQ[ m |-> FindInfraOrthogonalAxes[ g, 25, 2, All, "NextVertexFunction" -> m ], Sort ],
      classInvariantQ[ m |-> FindInfraOrthogonalRays[ g, 25, 2, All, "NextVertexFunction" -> m ], Sort ] } ],
  { True, True },
  TestID -> "FindInfraOrthogonalAxes-Rays-class-invariant-under-NextVertexFunction"
]

EndTestSection[]
