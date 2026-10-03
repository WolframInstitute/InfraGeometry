BeginTestSection["InfraLeviCivita"]

(* Translated from InfraGaugeTheory Tests/LeviCivita.wlt and VectorTransport.wlt at e5dc83b, block by block with the same numbers.
   InfraGaugeTheory's per-edge transports InfraParallelTransport[g, p, q, r] and walk transports InfraParallelTransport[g, walk, r]
   become InfraParallelTransport[InfraDisplacementBundle[g, r], walk], a list with one transport per realisation, a vector p -> v
   being the pair {p, v}; InfraHolonomyAngle[g, loop, r] becomes InfraHolonomyAngle[InfraDisplacementBundle[g, r], loop].
   Not translatable: the zero vector (no displacement bundle at scale 0) and the count argument of InfraCovariantDerivative. *)

(* ===== InfraParallelTransport, the Levi-Civita transports ===== *)

VerificationTest[
  InfraParallelTransport[InfraDisplacementBundle[PathGraph[Range[6]], 1], {3, 4}],
  {<|{3, 2} -> {4, 3}, {3, 4} -> {4, 5}|>},
  TestID -> "InfraParallelTransport-Levi-Civita-radial-auto-parallel"
]

VerificationTest[
  InfraParallelTransport[InfraDisplacementBundle[PathGraph[Range[6]], 1], {4, 3}],
  {<|{4, 3} -> {3, 2}, {4, 5} -> {3, 4}|>},
  TestID -> "InfraParallelTransport-Levi-Civita-invertible"
]

VerificationTest[
  InfraParallelTransport[InfraDisplacementBundle[PathGraph[Range[9]], 2], {4, 5}],
  {<|{4, 2} -> {5, 3}, {4, 6} -> {5, 7}|>},
  TestID -> "InfraParallelTransport-Levi-Civita-radial-auto-parallel-scale-2"
]

VerificationTest[
  InfraParallelTransport[InfraDisplacementBundle[PathGraph[Range[6]], 1], {3, 4}, Method -> "Alexandrov"],
  {<|{3, 2} -> {4, 3}, {3, 4} -> {4, 5}|>},
  TestID -> "InfraParallelTransport-Levi-Civita-Alexandrov-angle"
]

(* The arc metric tells 120 from 180 degrees, so the bond germ goes to its unique straight continuation and two realisations are left *)
VerificationTest[
  With[{tri = Graph[Flatten[Table[{i, j}, {i, 0, 4}, {j, 0, 4}], 1],
      Flatten[Table[{UndirectedEdge[{i, j}, {Mod[i + 1, 5], j}], UndirectedEdge[{i, j}, {i, Mod[j + 1, 5]}],
        UndirectedEdge[{i, j}, {Mod[i + 1, 5], Mod[j + 1, 5]}]}, {i, 0, 4}, {j, 0, 4}]]]},
    {transports = InfraParallelTransport[InfraDisplacementBundle[tri, 1], {{0, 0}, {1, 0}}]},
    {Length @ transports, Lookup[First @ transports, Key[{{0, 0}, {1, 0}}]]}],
  {2, {{1, 0}, {2, 0}}},
  TestID -> "InfraParallelTransport-Levi-Civita-arc-resolves-triangular-pin"
]

(* InfraGaugeTheory's zero defect on the octahedron: the transport over an edge preserves every angle, under both angle structures *)
VerificationTest[
  With[{oct = EdgeDelete[CompleteGraph[6], {1 \[UndirectedEdge] 4, 2 \[UndirectedEdge] 5, 3 \[UndirectedEdge] 6}]},
    Table[
      With[{transport = First @ InfraParallelTransport[InfraDisplacementBundle[oct, 1], {1, 2}, Method -> method]},
        AllTrue[Tuples[Keys @ transport, 2],
          InfraAngle[oct, {Last @ #[[1]], 1, Last @ #[[2]]}, Method -> method] ==
            InfraAngle[oct, {Last @ transport @ #[[1]], 2, Last @ transport @ #[[2]]}, Method -> method] &]],
      {method, {"Arclength", "Alexandrov"}}]],
  {True, True},
  TestID -> "InfraParallelTransport-Levi-Civita-octahedron-is-exact"
]

VerificationTest[
  Lookup[InfraParallelTransport[InfraDisplacementBundle[PathGraph[Range[6]], 1], {2, 3, 4}], Key[{2, 3}]],
  {{4, 5}},
  TestID -> "InfraParallelTransport-Levi-Civita-auto-parallel-frame"
]

(* ===== InfraHolonomyAngle ===== *)

VerificationTest[
  InfraHolonomyAngle[InfraDisplacementBundle[GraphProduct[CycleGraph[4], CycleGraph[4], "Cartesian"], 1], {{1, 1}, {1, 2}, {2, 2}, {2, 1}, {1, 1}}],
  0,
  TestID -> "InfraHolonomyAngle-flat-is-trivial"
]

VerificationTest[
  With[{tri = Graph[Flatten[Table[{i, j}, {i, 0, 4}, {j, 0, 4}], 1],
      Flatten[Table[{UndirectedEdge[{i, j}, {Mod[i + 1, 5], j}], UndirectedEdge[{i, j}, {i, Mod[j + 1, 5]}],
        UndirectedEdge[{i, j}, {Mod[i + 1, 5], Mod[j + 1, 5]}]}, {i, 0, 4}, {j, 0, 4}]]]},
    InfraHolonomyAngle[InfraDisplacementBundle[tri, 1], {{0, 0}, {1, 0}, {1, 1}, {0, 0}}]],
  0,
  TestID -> "InfraHolonomyAngle-flat-triangular-face-is-trivial"
]

(* An octahedron triangle turns the 4-cycle of directions by one step: 1 arc radian, Pi / 3 under the Alexandrov angle *)
VerificationTest[
  With[{oct = EdgeDelete[CompleteGraph[6], {1 \[UndirectedEdge] 4, 2 \[UndirectedEdge] 5, 3 \[UndirectedEdge] 6}]},
    {InfraHolonomyAngle[InfraDisplacementBundle[oct, 1], {1, 2, 3, 1}],
     InfraHolonomyAngle[InfraDisplacementBundle[oct, 1], {1, 2, 3, 1}, Method -> "Alexandrov"]}],
  {1, Pi / 3},
  TestID -> "InfraHolonomyAngle-octahedron-face"
]

(* InfraConnectionCurvature: the holonomy angle around the closed boundary of a face *)
VerificationTest[
  With[{oct = EdgeDelete[CompleteGraph[6], {1 \[UndirectedEdge] 4, 2 \[UndirectedEdge] 5, 3 \[UndirectedEdge] 6}]},
    InfraHolonomyAngle[InfraDisplacementBundle[oct, 1], Append[#, First @ #] & @ {1, 2, 3}]],
  1,
  TestID -> "InfraHolonomyAngle-face-curvature"
]

VerificationTest[
  With[{oct = EdgeDelete[CompleteGraph[6], {1 \[UndirectedEdge] 4, 2 \[UndirectedEdge] 5, 3 \[UndirectedEdge] 6}]},
    AllTrue[InfraParallelTransport[InfraDisplacementBundle[oct, 1], {1, 2, 3, 1}], AssociationQ]],
  True,
  TestID -> "InfraHolonomyAngle-holonomies-are-self-maps"
]

(* The same face under the connection, which keeps the first realisation over each edge *)
VerificationTest[
  With[{oct = EdgeDelete[CompleteGraph[6], {1 \[UndirectedEdge] 4, 2 \[UndirectedEdge] 5, 3 \[UndirectedEdge] 6}]},
    {fib = InfraDisplacementBundle[oct, 1]},
    {conn = FindInfraLeviCivitaConnection[fib]},
    {InfraHolonomyAngle[fib, conn, #] & /@ (Append[#[[All, 1]], #[[1, 1]]] & /@ FindCycle[oct, {3}, All]), InfraHolonomy[fib, conn, {1, 2, 3, 1}]}],
  {{1, 1, 1, 1, 1, 1, 1, 1}, Cycles[{{1, 2, 3, 4}}]},
  TestID -> "InfraHolonomyAngle-octahedron-faces-under-the-connection"
]

VerificationTest[
  With[{g = TorusTessellation[{6, 6}, "Triangular"]},
    {fib = InfraDisplacementBundle[g, 1], hexagons = Append[#[[All, 1]], #[[1, 1]]] & /@ FindCycle[g, {6}, All]},
    {Length @ hexagons, Union[InfraHolonomyAngle[fib, #] & /@ hexagons]}],
  {558, {0}},
  TestID -> "InfraHolonomyAngle-triangular-torus-hexagons-are-flat"
]

(* The first transport over an edge need not map adjacent directions to adjacent ones: on the triangular torus 12 of the 108 edges
   keep 2 of their 6 lifts, so the connection is not complete there; the square torus keeps every lift and is flat *)
VerificationTest[
  {With[{g = TorusTessellation[{6, 6}, "Triangular"]},
     {fib = InfraDisplacementBundle[g, 1]},
     {conn = FindInfraLeviCivitaConnection[fib]},
     {InfraConnectionQ[fib, conn], Counts[Length[InfraParallelTransport[fib, conn, List @@ #]] & /@ EdgeList[g]]}],
   With[{fib = InfraDisplacementBundle[TorusTessellation[{6, 6}, "Square"], 1]},
     {conn = FindInfraLeviCivitaConnection[fib]},
     {InfraConnectionQ[fib, conn], InfraFlatConnectionQ[fib, conn]}]},
  {{False, <|6 -> 96, 2 -> 12|>}, {True, True}},
  TestID -> "FindInfraLeviCivitaConnection-tori"
]

VerificationTest[
  With[{fib = InfraDisplacementBundle[TorusTessellation[{6, 6}, "Square"], 1]},
    InfraHolonomyAngle[fib, FindInfraLeviCivitaConnection[fib], {{1, 1}, {1, 2}, {2, 2}, {2, 1}, {1, 1}}]],
  0,
  TestID -> "InfraHolonomyAngle-square-torus-plaquette-is-flat"
]

(* ===== FindInfraLeviCivitaConnection ===== *)

VerificationTest[
  With[{fib = InfraDisplacementBundle[PathGraph[Range[6]], 1]},
    {conn = FindInfraLeviCivitaConnection[fib]},
    {InfraParallelTransport[fib, conn, {3, 4}], InfraParallelTransport[fib, conn, {4, 3}]}],
  {<|{3, 2} -> {4, 3}, {3, 4} -> {4, 5}|>, <|{4, 3} -> {3, 2}, {4, 5} -> {3, 4}|>},
  TestID -> "FindInfraLeviCivitaConnection-path-auto-parallel-and-invertible"
]

VerificationTest[
  With[{fib = InfraDisplacementBundle[PathGraph[Range[6]], 1]},
    FindInfraLeviCivitaConnection[fib, Method -> "Alexandrov"] === FindInfraLeviCivitaConnection[fib]],
  True,
  TestID -> "FindInfraLeviCivitaConnection-path-Alexandrov-agrees"
]

(* InfraGaugeTheory's fibration triple feeding HolonomyMatrix: a connection whose holonomy permutes the four directions *)
VerificationTest[
  With[{oct = EdgeDelete[CompleteGraph[6], {1 \[UndirectedEdge] 4, 2 \[UndirectedEdge] 5, 3 \[UndirectedEdge] 6}]},
    {fib = InfraDisplacementBundle[oct, 1]},
    {conn = FindInfraLeviCivitaConnection[fib]},
    {Head @ conn, InfraConnectionQ[fib, conn], InfraFlatConnectionQ[fib, conn], Length @ InfraParallelTransport[fib, conn, {1, 2, 3, 1}]}],
  {InfraConnection, True, False, 4},
  TestID -> "FindInfraLeviCivitaConnection-octahedron-is-a-curved-connection"
]

VerificationTest[
  FindInfraLeviCivitaConnection[InfraDisplacementBundle[CycleGraph[4], 1], Method -> "Ribbon"],
  FindInfraLeviCivitaConnection[InfraDisplacementBundle[CycleGraph[4], 1], Method -> "Ribbon"],
  TestID -> "FindInfraLeviCivitaConnection-unknown-method-stays-unevaluated"
]

(* ===== transport of vectors, InfraGaugeTheory's InfraVectorTransport ===== *)

VerificationTest[
  Lookup[InfraParallelTransport[InfraDisplacementBundle[PathGraph[Range[9]], 2], {4, 5}], Key[{4, 6}]],
  {{5, 7}},
  TestID -> "InfraParallelTransport-vector-auto-parallel"
]

VerificationTest[
  Lookup[InfraParallelTransport[InfraDisplacementBundle[PathGraph[Range[9]], 1], {4, 5}], Key[{4, 6}], Nothing],
  {},
  TestID -> "InfraParallelTransport-vector-scale-restriction"
]

VerificationTest[
  With[{field = InfraSection[<|4 -> {4, 6}|>]},
    Lookup[InfraParallelTransport[InfraDisplacementBundle[PathGraph[Range[9]], 2], {4, 5}], Key[First[field][4]]]],
  {{5, 7}},
  TestID -> "InfraParallelTransport-vector-field-value"
]

VerificationTest[
  Lookup[InfraParallelTransport[InfraDisplacementBundle[GridGraph[{7, 7}], 2], {18, 25, 32}], Key[{18, 20}]],
  {{32, 34}},
  TestID -> "InfraParallelTransport-vector-grid-rigid-scale-2"
]

VerificationTest[
  Lookup[InfraParallelTransport[InfraDisplacementBundle[GridGraph[{7, 7}], 2], {25, 26, 33, 32, 25}], Key[{25, 27}]],
  {{25, 27}},
  TestID -> "InfraParallelTransport-vector-flat-loop-returns"
]

VerificationTest[
  With[{fib = InfraDisplacementBundle[GridGraph[{7, 7}], 2]},
    {conn = FindInfraLeviCivitaConnection[fib]},
    {InfraParallelTransport[fib, conn, {18, 25, 32}][{18, 20}], InfraParallelTransport[fib, conn, {25, 26, 33, 32, 25}][{25, 27}]}],
  {{32, 34}, {25, 27}},
  TestID -> "FindInfraLeviCivitaConnection-grid-scale-2-rigid-and-flat"
]

(* Around a buckyball pentagon a scale-2 vector comes back rotated, in a single realisation *)
VerificationTest[
  With[{bucky = BuckyballGraph[]},
    {pentagon = First[FindCycle[bucky, {5}, 1]][[All, 1]]},
    {fib = InfraDisplacementBundle[bucky, 2], loop = Append[pentagon, First @ pentagon],
     vector = {First @ pentagon, First @ Pick[VertexList @ bucky, GraphDistance[bucky, First @ pentagon], 2]}},
    {out = Lookup[InfraParallelTransport[fib, loop], Key @ vector]},
    {Length @ out, out =!= {vector}, InfraHolonomyAngle[fib, loop] > 0}],
  {1, True, True},
  TestID -> "InfraParallelTransport-vector-curved-loop-rotates"
]

VerificationTest[
  With[{g = PolyhedronData["TruncatedIcosahedron", "Skeleton"]},
    {fib = InfraDisplacementBundle[g, 2], loop = Append[#, First @ #] & @ First[FindCycle[g, {5}, 1]][[All, 1]]},
    {transports = InfraParallelTransport[fib, loop]},
    {Length @ transports, Length @ First @ transports, Count[Normal @ First @ transports, x_ -> x_], InfraHolonomyAngle[fib, loop]}],
  {1, 6, 0, 4 / 3},
  TestID -> "InfraHolonomyAngle-buckyball-pentagon-scale-2"
]

(* ===== InfraCovariantDerivative ===== *)

VerificationTest[
  With[{fib = InfraDisplacementBundle[PathGraph[Range[9]], 1]},
    InfraCovariantDerivative[fib, FindInfraLeviCivitaConnection[fib], InfraSection[AssociationMap[i |-> {i, i + 1}, Range[8]]], {3, 4, 5}]],
  <|3 -> 3, 4 -> 4|>,
  TestID -> "InfraCovariantDerivative-parallel-field-is-zero"
]

VerificationTest[
  With[{fib = InfraDisplacementBundle[GridGraph[{7, 7}], 1]},
    InfraCovariantDerivative[fib, FindInfraLeviCivitaConnection[fib], InfraSection[<|18 -> {18, 19}, 25 -> {25, 26}, 32 -> {32, 33}|>],
      {18, 25, 32}]],
  <|18 -> 18, 25 -> 25|>,
  TestID -> "InfraCovariantDerivative-grid-parallel-field"
]

VerificationTest[
  With[{fib = InfraDisplacementBundle[PathGraph[Range[9]], 1]},
    MissingQ @ InfraCovariantDerivative[fib, FindInfraLeviCivitaConnection[fib], InfraSection[<|3 -> {3, 4}|>], {3, 4}][3]],
  True,
  TestID -> "InfraCovariantDerivative-dead-transport-is-missing"
]

(* The field flips from +1 to -1 and back: the derivatives are -2 and +2 *)
VerificationTest[
  With[{fib = InfraDisplacementBundle[PathGraph[Range[9]], 1]},
    InfraCovariantDerivative[fib, FindInfraLeviCivitaConnection[fib], InfraSection[<|3 -> {3, 4}, 4 -> {4, 3}, 5 -> {5, 6}|>], {3, 4, 5}]],
  <|3 -> 1, 4 -> 6|>,
  TestID -> "InfraCovariantDerivative-path-flip"
]

(* east then south then east on the grid: the differences south - east and east - south, carried to the base point *)
VerificationTest[
  With[{fib = InfraDisplacementBundle[GridGraph[{7, 7}], 1]},
    InfraCovariantDerivative[fib, FindInfraLeviCivitaConnection[fib], InfraSection[<|18 -> {18, 19}, 25 -> {25, 32}, 32 -> {32, 33}|>],
      {18, 25, 32}]],
  <|18 -> 24, 25 -> 19|>,
  TestID -> "InfraCovariantDerivative-grid-turning-field"
]

(* ===== InfraCanonicalOneForm ===== *)

VerificationTest[
  {InfraCanonicalOneForm[PathGraph[Range[9]], {4, 6}, {4, 7}], InfraCanonicalOneForm[PathGraph[Range[9]], {4, 6}, {5, 7}],
    InfraCanonicalOneForm[PathGraph[Range[9]], {4, 6}, {3, 5}]},
  {0, 2, -2},
  TestID -> "InfraCanonicalOneForm-vertical-spray-antispray"
]

(* On the geodesic spray, a ray of length r stepping to the same geodesic shifted by one, the form is r d(x, y) = r *)
VerificationTest[
  With[{g = GridGraph[{5, 5}]},
    Table[Union[InfraCanonicalOneForm[g, Most @ #, Rest @ #] & /@ InfraRays[g, 13, r + 1]], {r, 1, 2}]],
  {{1}, {2}},
  TestID -> "InfraCanonicalOneForm-grid-geodesic-spray"
]

EndTestSection[]
