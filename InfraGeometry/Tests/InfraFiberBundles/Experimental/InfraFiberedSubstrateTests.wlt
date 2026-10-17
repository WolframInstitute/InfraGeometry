BeginTestSection["InfraFiberedSubstrate"]

(* ===== the roster ===== *)

VerificationTest[
  {Keys @ InfraFiberedSubstrate[], Length /@ Values @ InfraFiberedSubstrate[], Length @ InfraFiberedSubstrate[All], DuplicateFreeQ @ InfraFiberedSubstrate[All]},
  {{"Trivial", "Covering", "Tangent", "Displacement", "NonBundle"}, {2, 3, 4, 4, 2}, 15, True},
  TestID -> "InfraFiberedSubstrate-roster"
]

VerificationTest[
  {InfraFiberedSubstrate["CycleDoubleCover"] === InfraFiberedSubstrate["CycleDoubleCover", "Medium"],
    InfraFiberedSubstrate["GridTangentBundle"] === InfraFiberedSubstrate["GridTangentBundle", "Medium"]},
  {True, True},
  TestID -> "InfraFiberedSubstrate-default-size-is-medium"
]

VerificationTest[
  Head /@ (InfraFiberedSubstrate[#, "Small"] & /@ InfraFiberedSubstrate[All]),
  Join[ConstantArray[InfraFibration, 5], ConstantArray[InfraTangentBundle, 4], ConstantArray[InfraDisplacementBundle, 4], ConstantArray[InfraFibration, 2]],
  TestID -> "InfraFiberedSubstrate-heads"
]

VerificationTest[
  VertexCount @ InfraTotalGraph @ InfraFiberedSubstrate[#, "Small"] & /@ InfraFiberedSubstrate[All],
  {16, 48, 16, 16, 72, 104, 648, 24, 660, 48, 216, 24, 240, 12, 24},
  TestID -> "InfraFiberedSubstrate-small-total-vertex-counts"
]

(* ===== the bases ===== *)

VerificationTest[
  {InfraFiberedSubstrate["GridTangentBundle", "Small"] === InfraTangentBundle[GridGraph[{4, 4}], 2],
    InfraFiberedSubstrate["OctahedronDisplacementBundle", "Large"] === InfraDisplacementBundle[EdgeDelete[CompleteGraph[6], {UndirectedEdge[1, 4], UndirectedEdge[2, 5], UndirectedEdge[3, 6]}], 1],
    VertexList @ First @ InfraFiberedSubstrate["TriangularTorusDisplacementBundle", "Small"] === VertexList @ TorusTessellation[{6, 6}, "Triangular"]},
  {True, True, True},
  TestID -> "InfraFiberedSubstrate-bundle-bases"
]

VerificationTest[
  IsomorphicGraphQ @@@ {
    {InfraBaseGraph @ InfraFiberedSubstrate["CycleProductBundle", "Small"], CycleGraph[8]},
    {InfraBaseGraph @ InfraFiberedSubstrate["GridProductBundle", "Small"], GridGraph[{4, 4}]},
    {InfraBaseGraph @ InfraFiberedSubstrate["TriangularTorusDoubleCover", "Small"], TorusTessellation[{6, 6}, "Triangular"]},
    {InfraBaseGraph @ InfraFiberedSubstrate["BranchedGridFibration", "Small"], GridGraph[{4, 4}]}},
  {True, True, True, True},
  TestID -> "InfraFiberedSubstrate-literal-bases"
]

VerificationTest[
  {IsomorphicGraphQ[InfraBaseGraph @ InfraFiberedSubstrate["MoebiusLadderCover", 5], CycleGraph[5]],
    InfraFiberedSubstrate["SphereMeshTangentBundle", 0.5] === InfraFiberedSubstrate["SphereMeshTangentBundle", "Small"]},
  {True, True},
  TestID -> "InfraFiberedSubstrate-raw-size"
]

(* ===== the total graphs: the twist is visible in the total graph ===== *)

VerificationTest[
  {IsomorphicGraphQ[InfraTotalGraph @ InfraFiberedSubstrate["CycleDoubleCover", "Small"], CycleGraph[16]],
    IsomorphicGraphQ[InfraTotalGraph @ InfraFiberedSubstrate["MoebiusLadderCover", "Small"], CirculantGraph[16, {1, 8}]],
    IsomorphicGraphQ[InfraTotalGraph @ InfraFiberedSubstrate["CycleProductBundle", "Small"], GraphProduct[CycleGraph[8], PathGraph[{1, 2}], "Cartesian"]],
    IsomorphicGraphQ[InfraTotalGraph @ InfraFiberedSubstrate["CycleProductBundle", "Small"], InfraTotalGraph @ InfraFiberedSubstrate["MoebiusLadderCover", "Small"]],
    IsomorphicGraphQ[InfraTotalGraph @ InfraFiberedSubstrate["TriangularTorusDoubleCover", "Small"], TorusTessellation[{12, 6}, "Triangular"]]},
  {True, True, True, False, True},
  TestID -> "InfraFiberedSubstrate-covers-and-products"
]

VerificationTest[
  Union[Length /@ Values @ GroupBy[Values @ InfraFibrationAssociation @ InfraFiberedSubstrate[#, "Small"], Identity]] & /@ {"BranchedCycleFibration", "BranchedGridFibration"},
  {{1, 2}, {1, 2}},
  TestID -> "InfraFiberedSubstrate-branched-fiber-sizes"
]

(* ===== the classification ===== *)

VerificationTest[
  Union @ Flatten @ Table[InfraFibrationQ @ InfraFiberedSubstrate[name, size], {name, InfraFiberedSubstrate[All]}, {size, {"Small", "Medium", "Large"}}],
  {True},
  TestID -> "InfraFiberedSubstrate-every-entry-is-a-fibration",
  TimeConstraint -> 300
]

VerificationTest[
  Union @ Flatten @ Table[InfraFiberBundleQ @ InfraFiberedSubstrate[name, size],
    {name, Join[InfraFiberedSubstrate[]["Trivial"], InfraFiberedSubstrate[]["Covering"]]}, {size, {"Small", "Medium", "Large"}}],
  {True},
  TestID -> "InfraFiberedSubstrate-trivial-and-covering-are-bundles"
]

VerificationTest[
  Union @ Flatten @ Table[InfraFiberBundleQ @ InfraFiberedSubstrate[name, size], {name, InfraFiberedSubstrate[]["NonBundle"]}, {size, {"Small", "Medium", "Large"}}],
  {False},
  TestID -> "InfraFiberedSubstrate-non-bundles"
]

(* Measured: no tangent or displacement entry passes InfraFiberBundleQ. Over the grid and the sphere mesh the fibers differ; over the
   torus and the octahedron they agree, but a ray has several lifts over a base edge, where InfraFiberBundleQ asks for exactly one *)

VerificationTest[
  Table[InfraFiberBundleQ @ InfraFiberedSubstrate[name, "Small"], {name, Join[InfraFiberedSubstrate[]["Tangent"], InfraFiberedSubstrate[]["Displacement"]]}],
  ConstantArray[False, 8],
  TestID -> "InfraFiberedSubstrate-tangent-and-displacement-are-not-bundles"
]

(* ===== structure and presentation ===== *)

VerificationTest[
  Union[Options[InfraTotalGraph @ InfraFiberedSubstrate[#, "Small"], VertexCoordinates] & /@ InfraFiberedSubstrate[All]],
  {{VertexCoordinates -> Automatic}},
  TestID -> "InfraFiberedSubstrate-totals-do-not-store-layout"
]

VerificationTest[
  With[{fib = InfraFiberedSubstrate["CycleDoubleCover", "Small"]},
    {Sort[VertexList[InfraFiber[fib, 1]]], EdgeCount[InfraFiber[fib, 1]],
      Lookup[InfraFibrationAssociation[fib], Key[{1, 2}]],
      EdgeQ[InfraTotalGraph[fib], UndirectedEdge[{8, 1}, {1, 2}]],
      EdgeQ[InfraTotalGraph[fib], UndirectedEdge[{8, 1}, {1, 1}]]}],
  {{{1, 1}, {1, 2}}, 0, 1, True, False},
  TestID -> "InfraFiberedSubstrate-cover-fibers-and-twist"
]

EndTestSection[]
