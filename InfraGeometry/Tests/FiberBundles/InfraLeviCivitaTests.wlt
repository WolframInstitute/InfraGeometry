BeginTestSection["InfraLeviCivita"]

(* Translated from InfraGaugeTheory Tests/LeviCivita.wlt and VectorTransport.wlt at e5dc83b: the per-edge transports become the
   InfraParallelTransport of the Levi-Civita InfraConnection on the displacement bundle, a vector p -> v being the pair {p, v} *)

(* ===== FindInfraLeviCivitaConnection ===== *)

VerificationTest[
  With[{fib = InfraDisplacementBundle[PathGraph[Range[6]], 1]},
    {conn = FindInfraLeviCivitaConnection[fib]},
    {InfraParallelTransport[fib, conn, {3, 4}], InfraParallelTransport[fib, conn, {4, 3}]}],
  {<|{3, 2} -> {4, 3}, {3, 4} -> {4, 5}|>, <|{4, 3} -> {3, 2}, {4, 5} -> {3, 4}|>},
  TestID -> "FindInfraLeviCivitaConnection-path-auto-parallel-and-invertible"
]

VerificationTest[
  With[{fib = InfraDisplacementBundle[PathGraph[Range[9]], 2]},
    InfraParallelTransport[fib, FindInfraLeviCivitaConnection[fib], {4, 5}]],
  <|{4, 2} -> {5, 3}, {4, 6} -> {5, 7}|>,
  TestID -> "FindInfraLeviCivitaConnection-path-scale-2"
]

VerificationTest[
  With[{fib = InfraDisplacementBundle[PathGraph[Range[6]], 1]},
    FindInfraLeviCivitaConnection[fib, Method -> "Alexandrov"] === FindInfraLeviCivitaConnection[fib]],
  True,
  TestID -> "FindInfraLeviCivitaConnection-path-Alexandrov-agrees"
]

(* The arc metric tells 120 from 180 degrees, so the bond germ goes to its straight continuation; of the two angle-isometries left,
   the translation moves the germs least *)
VerificationTest[
  With[{g = TorusTessellation[{6, 6}, "Triangular"]},
    {fib = InfraDisplacementBundle[g, 1]},
    {transport = InfraParallelTransport[fib, FindInfraLeviCivitaConnection[fib], {{0, 0}, {1, 0}}]},
    {transport[{{0, 0}, {1, 0}}], Length @ transport, Union[GraphDistance[g, Last @ First @ #, Last @ Last @ #] & /@ Normal @ transport]}],
  {{{1, 0}, {2, 0}}, 6, {1}},
  TestID -> "FindInfraLeviCivitaConnection-triangular-straight-continuation"
]

VerificationTest[
  With[{oct = EdgeDelete[CompleteGraph[6], {1 \[UndirectedEdge] 4, 2 \[UndirectedEdge] 5, 3 \[UndirectedEdge] 6}]},
    {fib = InfraDisplacementBundle[oct, 1]},
    {conn = FindInfraLeviCivitaConnection[fib]},
    {Head @ conn, InfraConnectionQ[fib, conn], InfraFlatConnectionQ[fib, conn]}],
  {InfraConnection, True, False},
  TestID -> "FindInfraLeviCivitaConnection-octahedron-is-a-curved-connection"
]

VerificationTest[
  Through[{InfraConnectionQ, InfraFlatConnectionQ}[#, FindInfraLeviCivitaConnection[#]]] & /@
    {InfraDisplacementBundle[TorusTessellation[{6, 6}, "Square"], 1], InfraDisplacementBundle[TorusTessellation[{6, 6}, "Triangular"], 1]},
  {{True, True}, {True, True}},
  TestID -> "FindInfraLeviCivitaConnection-flat-tori-are-flat"
]

VerificationTest[
  FindInfraLeviCivitaConnection[InfraDisplacementBundle[CycleGraph[4], 1], Method -> "Ribbon"],
  FindInfraLeviCivitaConnection[InfraDisplacementBundle[CycleGraph[4], 1], Method -> "Ribbon"],
  TestID -> "FindInfraLeviCivitaConnection-unknown-method-stays-unevaluated"
]

(* ===== InfraHolonomyAngle ===== *)

(* An octahedron triangle turns the 4-cycle of directions by one step, a quarter turn; Gauss-Bonnet: 8 quarter turns = 4 Pi *)
VerificationTest[
  With[{oct = EdgeDelete[CompleteGraph[6], {1 \[UndirectedEdge] 4, 2 \[UndirectedEdge] 5, 3 \[UndirectedEdge] 6}]},
    {fib = InfraDisplacementBundle[oct, 1]},
    {conn = FindInfraLeviCivitaConnection[fib]},
    {angles = InfraHolonomyAngle[fib, conn, Append[#[[All, 1]], #[[1, 1]]]] & /@ FindCycle[oct, {3}, All]},
    {Length @ angles, Union @ angles, Total @ angles, InfraHolonomy[fib, conn, {1, 2, 3, 1}]}],
  {8, {Pi / 2}, 4 Pi, Cycles[{{1, 2, 3, 4}}]},
  TestID -> "InfraHolonomyAngle-octahedron-Gauss-Bonnet"
]

(* Measured as a fraction of the full turn, the angle does not depend on the angle structure *)
VerificationTest[
  With[{oct = EdgeDelete[CompleteGraph[6], {1 \[UndirectedEdge] 4, 2 \[UndirectedEdge] 5, 3 \[UndirectedEdge] 6}]},
    {fib = InfraDisplacementBundle[oct, 1]},
    {conn = FindInfraLeviCivitaConnection[fib, Method -> "Alexandrov"]},
    {InfraHolonomyAngle[fib, conn, {1, 2, 3, 1}], InfraHolonomyAngle[fib, conn, {1, 2, 3, 1}, Method -> "Alexandrov"]}],
  {Pi / 2, Pi / 2},
  TestID -> "InfraHolonomyAngle-octahedron-Alexandrov"
]

VerificationTest[
  With[{g = TorusTessellation[{6, 6}, "Triangular"]},
    {fib = InfraDisplacementBundle[g, 1]},
    {conn = FindInfraLeviCivitaConnection[fib]},
    Union[InfraHolonomyAngle[fib, conn, Append[#[[All, 1]], #[[1, 1]]]] & /@ FindCycle[g, {6}, All]]],
  {0},
  TestID -> "InfraHolonomyAngle-triangular-torus-hexagons-are-flat"
]

VerificationTest[
  With[{fib = InfraDisplacementBundle[TorusTessellation[{6, 6}, "Square"], 1]},
    InfraHolonomyAngle[fib, FindInfraLeviCivitaConnection[fib], {{1, 1}, {1, 2}, {2, 2}, {2, 1}, {1, 1}}]],
  0,
  TestID -> "InfraHolonomyAngle-square-torus-plaquette-is-flat"
]

(* ===== transport of vectors ===== *)

VerificationTest[
  With[{fib = InfraDisplacementBundle[GridGraph[{7, 7}], 2]},
    {conn = FindInfraLeviCivitaConnection[fib]},
    {InfraParallelTransport[fib, conn, {18, 25, 32}][{18, 20}], InfraParallelTransport[fib, conn, {25, 26, 33, 32, 25}][{25, 27}]}],
  {{32, 34}, {25, 27}},
  TestID -> "FindInfraLeviCivitaConnection-grid-scale-2-rigid-and-flat"
]

(* Around a buckyball pentagon a scale-2 direction comes back turned by Pi / 3, the angle defect of the five vertices *)
VerificationTest[
  With[{g = PolyhedronData["TruncatedIcosahedron", "Skeleton"]},
    {fib = InfraDisplacementBundle[g, 2], loop = Append[#, First @ #] & @ First[FindCycle[g, {5}, 1]][[All, 1]]},
    {conn = FindInfraLeviCivitaConnection[fib]},
    {transport = InfraParallelTransport[fib, conn, loop]},
    {Length @ transport, Count[Normal @ transport, x_ -> x_], InfraHolonomyAngle[fib, conn, loop]}],
  {6, 0, Pi / 3},
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
    InfraCovariantDerivative[fib, FindInfraLeviCivitaConnection[fib], InfraSection[<|18 -> {18, 19}, 25 -> {25, 26}, 32 -> {32, 33}|>], {18, 25, 32}]],
  <|18 -> 18, 25 -> 25|>,
  TestID -> "InfraCovariantDerivative-grid-parallel-field"
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
    InfraCovariantDerivative[fib, FindInfraLeviCivitaConnection[fib], InfraSection[<|18 -> {18, 19}, 25 -> {25, 32}, 32 -> {32, 33}|>], {18, 25, 32}]],
  <|18 -> 24, 25 -> 19|>,
  TestID -> "InfraCovariantDerivative-grid-turning-field"
]

VerificationTest[
  With[{fib = InfraDisplacementBundle[PathGraph[Range[9]], 1]},
    MissingQ @ InfraCovariantDerivative[fib, FindInfraLeviCivitaConnection[fib], InfraSection[<|3 -> {3, 4}|>], {3, 4}][3]],
  True,
  TestID -> "InfraCovariantDerivative-dead-transport-is-missing"
]

(* ===== InfraCanonicalOneForm ===== *)

VerificationTest[
  {InfraCanonicalOneForm[PathGraph[Range[9]], {4, 6}, {4, 7}], InfraCanonicalOneForm[PathGraph[Range[9]], {4, 6}, {5, 7}],
    InfraCanonicalOneForm[PathGraph[Range[9]], {4, 6}, {3, 5}]},
  {0, 2, -2},
  TestID -> "InfraCanonicalOneForm-vertical-spray-antispray"
]

(* On the geodesic spray, a ray stepping to its own tail, the form is r d(x, y) = r *)
VerificationTest[
  With[{g = GridGraph[{5, 5}]},
    Table[Union[InfraCanonicalOneForm[g, #, Rest @ #] & /@ InfraRays[g, 13, r]], {r, 1, 2}]],
  {{1}, {2}},
  TestID -> "InfraCanonicalOneForm-grid-geodesic-spray"
]

EndTestSection[]
