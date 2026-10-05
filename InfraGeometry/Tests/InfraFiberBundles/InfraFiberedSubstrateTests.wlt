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
    InfraFiberedSubstrate["OctahedronDisplacementBundle", "Large"] === InfraDisplacementBundle[EdgeDelete[CompleteGraph[6], {1 <-> 4, 2 <-> 5, 3 <-> 6}], 1],
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

(* ===== the drawing ===== *)

VerificationTest[
  With[{entries = InfraFiberedSubstrate[#, "Small"] & /@ {"CycleProductBundle", "MoebiusLadderCover", "CycleDoubleCover",
      "GridProductBundle", "TriangularTorusDoubleCover", "BranchedGridFibration", "GridTangentBundle", "GridDisplacementBundle", "OctahedronDisplacementBundle"}},
    {Head @ GraphicsGrid @ Partition[InfraTotalGraph /@ entries, 3], Union[Options[InfraTotalGraph @ #, VertexCoordinates] =!= {VertexCoordinates -> Automatic} & /@ entries]}],
  {Graphics, {True}},
  TestID -> "InfraFiberedSubstrate-grid-of-nine-drawn"
]

VerificationTest[
  With[{fib = InfraFiberedSubstrate["CycleDoubleCover", "Small"]},
    {coordinates = AssociationThread[VertexList @ InfraTotalGraph @ fib, GraphEmbedding @ InfraTotalGraph @ fib]},
    Union @ Round[Norm[coordinates[{#, 1}] - coordinates[{#, 2}]] & /@ Range[8], 10.^-6]],
  {Round[2 / 3 EuclideanDistance @@ Take[GraphEmbedding @ CycleGraph[8], 2], 10.^-6]},
  TestID -> "InfraFiberedSubstrate-fibers-on-small-circles"
]

EndTestSection[]
