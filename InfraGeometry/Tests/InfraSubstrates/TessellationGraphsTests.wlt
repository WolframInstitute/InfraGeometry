BeginTestSection["TessellationGraphs"]

(* Moved from RiemannianTests.wlt on 2026-10-05, when the tests were split by kernel file (APISurfaceCleanup T9) *)

(* ===================== Tessellations, regular & uniform maps ===================== *)

(* --- Flat-torus regular tessellations --- *)

VerificationTest[
  { Union @ VertexDegree @ TessellationGraph[ { 3, 6 }, { 5, 5 } ],
    Union @ VertexDegree @ TessellationGraph[ { 4, 4 }, { 5, 5 } ],
    Union @ VertexDegree @ TessellationGraph[ { 6, 3 }, { 5, 5 } ] },
  { { 6 }, { 4 }, { 3 } },
  TestID -> "Torus-degrees-by-shape"
]

VerificationTest[
  VertexTransitiveGraphQ @ TessellationGraph[ { 3, 6 }, { 5, 5 } ],
  True,
  TestID -> "Torus-triangular-vertex-transitive"
]

(* --- Regular maps: spherical Platonic graphs --- *)

VerificationTest[ IsomorphicGraphQ[ TessellationGraph[ { 3, 3 } ], GraphData[ "TetrahedralGraph" ] ], True, TestID -> "Schlafli-33-is-tetrahedron" ]
VerificationTest[ IsomorphicGraphQ[ TessellationGraph[ { 4, 3 } ], GraphData[ "CubicalGraph" ] ], True, TestID -> "Schlafli-43-is-cube" ]
VerificationTest[ IsomorphicGraphQ[ TessellationGraph[ { 3, 4 } ], GraphData[ "OctahedralGraph" ] ], True, TestID -> "Schlafli-34-is-octahedron" ]
VerificationTest[ IsomorphicGraphQ[ TessellationGraph[ { 5, 3 } ], GraphData[ "DodecahedralGraph" ] ], True, TestID -> "Schlafli-53-is-dodecahedron" ]
VerificationTest[ IsomorphicGraphQ[ TessellationGraph[ { 3, 5 } ], GraphData[ "IcosahedralGraph" ] ], True, TestID -> "Schlafli-35-is-icosahedron" ]

VerificationTest[ Union @ VertexDegree @ TessellationGraph[ { 3, 5 } ], { 5 }, TestID -> "Schlafli-is-q-regular" ]

VerificationTest[
  { Length @ FindCycle[ TessellationGraph[ { 4, 3 } ], { 4 }, All ], Length @ FindCycle[ TessellationGraph[ { 5, 3 } ], { 5 }, All ] },
  { 6, 12 },
  TestID -> "Schlafli-p-cycle-count-equals-faces"
]

VerificationTest[
  With[ { g = TessellationGraph[ { 3, 5 } ] },
    Length @ DeleteDuplicates[ CanonicalGraph[ NeighborhoodGraph[ g, #, 1 ] ] & /@ VertexList[ g ], IsomorphicGraphQ ] ],
  1,
  TestID -> "Schlafli-locally-isomorphic"
]

VerificationTest[ IsomorphicGraphQ[ TessellationGraph[ { 4, 4 }, 5 ], TessellationGraph[ { 4, 4 }, { 5, 5 } ] ], True, TestID -> "Schlafli-44-is-torus" ]
VerificationTest[ IsomorphicGraphQ[ TessellationGraph[ { 6, 3 }, 4 ], TessellationGraph[ { 6, 3 }, { 4, 4 } ] ], True, TestID -> "Schlafli-63-is-hexagonal-torus" ]

VerificationTest[
  With[ { g = TessellationGraph[ { 3, 7 } ] }, { VertexCount @ g, EdgeCount @ g, Union @ VertexDegree @ g, VertexTransitiveGraphQ @ g } ],
  { 24, 84, { 7 }, True },
  TestID -> "Schlafli-37-Klein-quartic-skeleton"
]

(* genus via Euler on the embedded map: Klein quartic {3,7} has genus 3 *)
VerificationTest[
  With[ { g = TessellationGraph[ { 3, 7 } ] }, With[ { v = VertexCount @ g, e = EdgeCount @ g, f = Length @ FindCycle[ g, { 3 }, All ] }, 1 - ( v - e + f )/2 ] ],
  3,
  TestID -> "Schlafli-37-genus-3"
]

VerificationTest[ IsomorphicGraphQ[ TessellationGraph[ { 4, 3 }, SymmetricGroup[ 4 ] ], GraphData[ "CubicalGraph" ] ], True, TestID -> "RegularMap-explicit-group-cube" ]

(* a group without a (2, p, q)-generation: no message, no loop *)
VerificationTest[
  TimeConstrained[ TessellationGraph[ { 3, 8 }, SymmetricGroup[ 4 ] ], 1 ],
  HoldPattern @ TessellationGraph[ { 3, 8 }, SymmetricGroup[ 4 ] ],
  SameTest -> MatchQ,
  TestID -> "RegularMap-group-without-generation-stays-unevaluated"
]

(* --- Regular maps in increasing order of size: the normal subgroups of the triangle group <x, y | x^p, y^q, (x y)^2> --- *)

(* the Hurwitz groups of order 168, 504, 1092: V = |G| / 7 *)
VerificationTest[
  VertexCount /@ Table[ TessellationGraph[ { 3, 7 }, k ], { k, 3 } ],
  { 24, 72, 156 },
  TestID -> "Schlafli-37-maps-in-increasing-order"
]

VerificationTest[
  VertexCount /@ { TessellationGraph[ { 4, 5 } ], TessellationGraph[ { 3, 8 } ], TessellationGraph[ { 5, 5 } ] },
  { 24, 12, 12 },
  TestID -> "Schlafli-first-maps-of-45-38-55"
]

(* the {3, 8} map of order 48, the Bolza surface, has 6 vertices and 24 edges: a multigraph, skipped *)
VerificationTest[
  With[ { g = TessellationGraph[ { 3, 8 } ] }, { VertexCount @ g, EdgeCount @ g, Union @ VertexDegree @ g } ],
  { 12, 48, { 8 } },
  TestID -> "Schlafli-38-multigraph-map-skipped"
]

(* k counts normal subgroups: the three of index 1092 are k = 3, 4, 5; the sixth map is past the order 1100 *)
VerificationTest[
  { VertexCount @ TessellationGraph[ { 3, 7 }, 5 ], TessellationGraph[ { 3, 7 }, 6 ] },
  { 156, HoldPattern @ TessellationGraph[ { 3, 7 }, 6 ] },
  SameTest -> MatchQ,
  TestID -> "Schlafli-past-the-maximal-order-stays-unevaluated"
]

VerificationTest[
  TessellationGraph[ { 3, 5 }, 2 ],
  HoldPattern @ TessellationGraph[ { 3, 5 }, 2 ],
  SameTest -> MatchQ,
  TestID -> "Schlafli-sphere-has-one-map"
]

(* Method -> "PSL2": the quotient PSL(2, ell) of the k-th prime ell that admits a generation *)
VerificationTest[
  With[ { g = TessellationGraph[ { 3, 7 }, 1, Method -> "PSL2" ] }, { VertexCount @ g, EdgeCount @ g, IsomorphicGraphQ[ g, TessellationGraph[ { 3, 7 } ] ] } ],
  { 24, 84, True },
  TestID -> "Method-PSL2-Klein-map"
]

VerificationTest[
  VertexCount @ TessellationGraph[ { 3, 7 }, 2, Method -> "PSL2" ],
  156,
  TestID -> "Method-PSL2-is-the-prime-family"
]

VerificationTest[
  MatchQ[ #, _TessellationGraph ] & /@ { TessellationGraph[ { 3, 3 }, Method -> "Nonsense" ], TessellationGraph[ { 4, 3 }, Method -> "CosetEnumeration" ] },
  { True, True },
  TestID -> "Method-unknown-stays-unevaluated"
]

(* --- Uniform / Archimedean maps --- *)

VerificationTest[ IsomorphicGraphQ[ TessellationGraph[ { 3, 4, 3, 4 } ], PolyhedronData[ "Cuboctahedron", "SkeletonGraph" ] ], True, TestID -> "Archimedean-3434-is-cuboctahedron" ]
VerificationTest[ IsomorphicGraphQ[ TessellationGraph[ { 4, 6, 8 } ], PolyhedronData[ "GreatRhombicuboctahedron", "SkeletonGraph" ] ], True, TestID -> "Archimedean-468-is-great-rhombicuboctahedron" ]

VerificationTest[
  { VertexCount @ #, Union @ VertexDegree @ #, VertexTransitiveGraphQ @ # } &@ TessellationGraph[ { 4, 4, 5 } ],
  { 10, { 3 }, True },
  TestID -> "Archimedean-pentagonal-prism"
]

VerificationTest[ IsomorphicGraphQ[ TessellationGraph[ { 3, 3, 3, 5 } ], PolyhedronData[ { "Antiprism", 5 }, "SkeletonGraph" ] ], True, TestID -> "Archimedean-pentagonal-antiprism" ]
VerificationTest[ IsomorphicGraphQ[ TessellationGraph[ { 4, 4, 4 } ], GraphData[ "CubicalGraph" ] ], True, TestID -> "Archimedean-444-forwards-to-cube" ]

(* the 11 Archimedean solids that rectify and truncate reach, computed on the Platonic maps *)
VerificationTest[
  ( { config, name } |-> IsomorphicGraphQ[ TessellationGraph[ config ], PolyhedronData[ name, "SkeletonGraph" ] ] ) @@@ {
    { { 3, 4, 3, 4 }, "Cuboctahedron" }, { { 3, 5, 3, 5 }, "Icosidodecahedron" }, { { 3, 6, 6 }, "TruncatedTetrahedron" },
    { { 3, 8, 8 }, "TruncatedCube" }, { { 4, 6, 6 }, "TruncatedOctahedron" }, { { 3, 10, 10 }, "TruncatedDodecahedron" },
    { { 5, 6, 6 }, "TruncatedIcosahedron" }, { { 3, 4, 4, 4 }, "SmallRhombicuboctahedron" }, { { 4, 6, 8 }, "GreatRhombicuboctahedron" },
    { { 3, 4, 5, 4 }, "SmallRhombicosidodecahedron" }, { { 4, 6, 10 }, "GreatRhombicosidodecahedron" } },
  ConstantArray[ True, 11 ],
  TestID -> "Archimedean-eleven-solids-computed"
]

VerificationTest[
  MatchQ[ #, _TessellationGraph ] & /@ { TessellationGraph[ { 3, 3, 3, 3, 4 } ], TessellationGraph[ { 3, 3, 3, 3, 5 } ], TessellationGraph[ { 3, 4, 3, 4 }, 2 ] },
  { True, True, True },
  TestID -> "Archimedean-snubs-and-second-solid-stay-unevaluated"
]

(* the truncation of the {5, 5} map of genus 4 on its own faces, not the truncated icosahedron *)
VerificationTest[
  With[ { g = TessellationGraph[ { 5, 10, 10 } ] },
    { VertexCount @ g, FindCycle[ g, { 10 }, 1 ] =!= { }, FindCycle[ g, { 6 }, 1 ], TessellationGenus[ g, { 5, 10, 10 } ] } ],
  { 60, True, { }, 4 },
  TestID -> "Uniform-5-10-10-truncates-the-55-map"
]

VerificationTest[
  Table[ With[ { g = TessellationGraph[ { 3, 7, 3, 7 }, k ] }, { VertexCount @ g, Union @ VertexDegree @ g } ], { k, 2 } ],
  { { 84, { 4 } }, { 252, { 4 } } },
  TestID -> "Uniform-hyperbolic-on-the-kth-parent"
]

(* every uniform map is regular of the length of its configuration and carries a cycle of every face size *)
VerificationTest[
  ( config |-> With[ { g = TessellationGraph[ config ] },
      Union @ VertexDegree @ g == { Length @ config } && AllTrue[ Union @ config, f |-> FindCycle[ g, { f }, 1 ] =!= { } ] ] ) /@
    { { 3, 7, 3, 7 }, { 3, 4, 7, 4 }, { 4, 6, 14 }, { 3, 14, 14 }, { 7, 6, 6 }, { 4, 8, 10 }, { 4, 10, 10 }, { 3, 10, 10 }, { 4, 6, 10 } },
  ConstantArray[ True, 9 ],
  TestID -> "Uniform-maps-have-their-configuration"
]

(* the Euclidean uniform maps on the k x k torus from its lattice faces, small k included; a torus whose graph is not simple has none *)
VerificationTest[
  ( g |-> { VertexCount @ g, VertexTransitiveGraphQ @ g } ) /@
    { TessellationGraph[ { 4, 8, 8 }, 3 ], TessellationGraph[ { 3, 6, 3, 6 }, 3 ], TessellationGraph[ { 3, 12, 12 }, 2 ] },
  { { 36, True }, { 27, True }, { 24, True } },
  TestID -> "Uniform-euclidean-small-tori"
]

VerificationTest[
  MatchQ[ #, _TessellationGraph ] & /@ { TessellationGraph[ { 4, 8, 8 }, 2 ], TessellationGraph[ { 3, 6, 3, 6 }, 2 ], TessellationGraph[ { 3, 12, 12 }, 1 ] },
  { True, True, True },
  TestID -> "Uniform-degenerate-torus-stays-unevaluated"
]

VerificationTest[
  With[ { g = TessellationGraph[ { 3, 6, 3, 6 }, 4 ] }, { Union @ VertexDegree @ g, VertexTransitiveGraphQ @ g } ],
  { { 4 }, True },
  TestID -> "Archimedean-trihexagonal-torus"
]

VerificationTest[
  With[ { g = TessellationGraph[ { 4, 8, 8 }, 4 ] }, { Union @ VertexDegree @ g, VertexTransitiveGraphQ @ g } ],
  { { 3 }, True },
  TestID -> "Archimedean-truncated-square-torus"
]

VerificationTest[
  With[ { g = TessellationGraph[ { 3, 12, 12 }, 4 ] }, { Union @ VertexDegree @ g, VertexTransitiveGraphQ @ g } ],
  { { 3 }, True },
  TestID -> "Archimedean-truncated-hexagonal-torus"
]

VerificationTest[
  With[ { g = TessellationGraph[ { 3, 4, 6, 4 }, 4 ] }, { Union @ VertexDegree @ g, VertexTransitiveGraphQ @ g } ],
  { { 4 }, True },
  TestID -> "Archimedean-rhombitrihexagonal-torus"
]

VerificationTest[
  With[ { g = TessellationGraph[ { 4, 6, 12 }, 4 ] }, { Union @ VertexDegree @ g, VertexTransitiveGraphQ @ g } ],
  { { 3 }, True },
  TestID -> "Archimedean-truncated-trihexagonal-torus"
]

(* genus via Euler with the mixed face vector: a Euclidean uniform tiling has genus 1 *)
VerificationTest[
  With[ { g = TessellationGraph[ { 3, 6, 3, 6 }, 5 ], cfg = { 3, 6, 3, 6 } },
    With[ { v = VertexCount @ g }, 1 - v ( 1 - Length[ cfg ]/2 + Total[ 1/cfg ] )/2 ] ],
  1,
  TestID -> "Archimedean-torus-genus-1"
]

(* ===================== Map invariants: curvature, Euler characteristic, genus ===================== *)

(* combinatorial Gaussian curvature classifies the geometry by sign: flat / hyperbolic / spherical *)
VerificationTest[
  Sign @ { TessellationCurvature[ { 3, 6 } ], TessellationCurvature[ { 3, 7 } ], TessellationCurvature[ { 3, 5 } ] },
  { 0, -1, 1 },
  TestID -> "TessellationCurvature-flat-hyperbolic-spherical"
]

(* every Euclidean uniform (Archimedean) tiling is flat *)
VerificationTest[
  { TessellationCurvature[ { 4, 8, 8 } ], TessellationCurvature[ { 3, 4, 6, 4 } ], TessellationCurvature[ { 3, 6, 3, 6 } ] },
  { 0, 0, 0 },
  TestID -> "TessellationCurvature-archimedean-flat"
]

(* icosahedron {3,5} is a sphere: chi = 2, genus 0 *)
VerificationTest[
  With[ { g = TessellationGraph[ { 3, 5 } ] }, { TessellationEulerCharacteristic[ g, { 3, 5 } ], TessellationGenus[ g, { 3, 5 } ] } ],
  { 2, 0 },
  TestID -> "TessellationGenus-icosahedron-sphere"
]

(* Euclidean tilings (regular and Archimedean) on the torus have genus 1 *)
VerificationTest[
  { TessellationGenus[ TessellationGraph[ { 4, 4 }, { 12, 12 } ], { 4, 4 } ],
    TessellationGenus[ TessellationGraph[ { 4, 8, 8 }, 5 ], { 4, 8, 8 } ] },
  { 1, 1 },
  TestID -> "TessellationGenus-torus-genus-1"
]

(* hyperbolic quotient: chi agrees with the discrete Gauss-Bonnet sum V*kappa, genus > 1 *)
VerificationTest[
  With[ { g = TessellationGraph[ { 3, 7 }, 2 ] },
    TessellationEulerCharacteristic[ g, { 3, 7 } ] == VertexCount[ g ] TessellationCurvature[ { 3, 7 } ] && TessellationGenus[ g, { 3, 7 } ] > 1 ],
  True,
  TestID -> "TessellationGenus-hyperbolic-gauss-bonnet"
]

(* spec-free forms detect a regular configuration (uniform degree, girth face) from the graph *)
VerificationTest[
  { TessellationGenus[ TessellationGraph[ { 3, 5 } ] ],
    TessellationGenus[ TessellationGraph[ { 4, 4 }, { 12, 12 } ] ],
    TessellationGenus[ TessellationGraph[ { 3, 7 }, 2 ] ] },
  { 0, 1, 7 },
  TestID -> "TessellationGenus-spec-free-regular-detection"
]

(* ===== TessellationNeighborhoodGraph: unwrapped {p,q} patches ===== *)

(* Euclidean patches: interior degree q, exact ball counts, p-gon faces *)
VerificationTest[
  Max @ VertexDegree @ TessellationNeighborhoodGraph[ { 4, 4 }, 3 ],
  4,
  TestID -> "TessellatedDisk-44-interior-degree-4"
]

VerificationTest[
  Max @ VertexDegree @ TessellationNeighborhoodGraph[ { 3, 6 }, 3 ],
  6,
  TestID -> "TessellatedDisk-36-interior-degree-6"
]

VerificationTest[
  Max @ VertexDegree @ TessellationNeighborhoodGraph[ { 6, 3 }, 3 ],
  3,
  TestID -> "TessellatedDisk-63-interior-degree-3"
]

(* triangular B_r ball: 1 + 3 r (r + 1) vertices *)
VerificationTest[
  VertexCount /@ ( TessellationNeighborhoodGraph[ { 3, 6 }, # ] & /@ { 2, 3, 4 } ),
  { 19, 37, 61 },
  TestID -> "TessellatedDisk-36-ball-counts"
]

(* the patch has a boundary -- unlike the torus, it is not vertex-transitive *)
VerificationTest[
  VertexTransitiveGraphQ @ TessellationNeighborhoodGraph[ { 3, 6 }, 3 ],
  False,
  TestID -> "TessellatedDisk-36-not-vertex-transitive"
]

VerificationTest[
  FindCycle[ TessellationNeighborhoodGraph[ { 4, 4 }, 3 ], { 4 }, 1 ] =!= {} &&
   FindCycle[ TessellationNeighborhoodGraph[ { 6, 3 }, 3 ], { 6 }, 1 ] =!= {},
  True,
  TestID -> "TessellatedDisk-euclidean-faces"
]

(* Hyperbolic patches: connected, planar, max degree == q (dedup regression guard) *)
VerificationTest[
  With[ { g = TessellationNeighborhoodGraph[ { 7, 3 }, 4 ] },
    { ConnectedGraphQ @ g, PlanarGraphQ @ g, Max @ VertexDegree @ g } ],
  { True, True, 3 },
  TestID -> "TessellatedDisk-73-connected-planar-degree3"
]

VerificationTest[
  With[ { g = TessellationNeighborhoodGraph[ { 3, 7 }, 3 ] },
    { ConnectedGraphQ @ g, PlanarGraphQ @ g, Max @ VertexDegree @ g } ],
  { True, True, 7 },
  TestID -> "TessellatedDisk-37-connected-planar-degree7"
]

VerificationTest[
  FindCycle[ TessellationNeighborhoodGraph[ { 7, 3 }, 4 ], { 7 }, 1 ] =!= {},
  True,
  TestID -> "TessellatedDisk-73-heptagon-faces"
]

(* vertex count strictly increases with r *)
VerificationTest[
  With[ { c = VertexCount /@ ( TessellationNeighborhoodGraph[ { 7, 3 }, # ] & /@ { 2, 3, 4 } ) },
    OrderedQ @ c && DuplicateFreeQ @ c ],
  True,
  TestID -> "TessellatedDisk-73-monotone"
]

(* Spherical patches: the combinatorics closes the tiling up into the finite Platonic graph *)
VerificationTest[
  VertexCount /@ ( TessellationNeighborhoodGraph[ #, 9 ] & /@ { { 3, 3 }, { 4, 3 }, { 3, 4 }, { 5, 3 }, { 3, 5 } } ),
  { 4, 8, 6, 20, 12 },
  TestID -> "TessellatedDisk-spherical-closure-counts"
]

VerificationTest[
  Max @ VertexDegree @ TessellationNeighborhoodGraph[ { 3, 5 }, 9 ],
  5,
  TestID -> "TessellatedDisk-icosahedron-degree-5"
]

VerificationTest[
  With[ { cap = TessellationNeighborhoodGraph[ { 3, 5 }, 1 ] },
    ConnectedGraphQ @ cap && VertexCount @ cap < 12 ],
  True,
  TestID -> "TessellatedDisk-icosahedron-cap-open"
]

(* ===== TessellationNeighborhoodGraph: unwrapped uniform / Archimedean patches ===== *)

(* the unwrapped ball of a uniform tiling equals the same-radius ball cut from its compact
   torus quotient -- the construction-independent characterisation of B_r *)
VerificationTest[
  IsomorphicGraphQ[
    TessellationNeighborhoodGraph[ { 4, 8, 8 }, 2 ],
    With[ { g = TessellationGraph[ { 4, 8, 8 }, 5 ] }, NeighborhoodGraph[ g, First @ GraphCenter @ g, 2 ] ] ],
  True,
  TestID -> "TessellatedDisk-488-matches-torus-ball"
]

(* interior valence is the configuration length: degree 3 for the 3-valent uniform tilings *)
VerificationTest[
  Max @ VertexDegree @ TessellationNeighborhoodGraph[ { 4, 8, 8 }, 4 ],
  3,
  TestID -> "TessellatedDisk-488-degree-3"
]

(* and degree 4 for the 4-valent ones *)
VerificationTest[
  Max @ VertexDegree @ TessellationNeighborhoodGraph[ { 3, 6, 3, 6 }, 4 ],
  4,
  TestID -> "TessellatedDisk-3636-degree-4"
]

(* every face size in the configuration occurs as a girth-class cycle of the patch *)
VerificationTest[
  AllTrue[ { 3, 4, 6 }, FindCycle[ TessellationNeighborhoodGraph[ { 3, 4, 6, 4 }, 4 ], { # }, 1 ] =!= {} & ],
  True,
  TestID -> "TessellatedDisk-3464-face-types"
]

(* an all-equal configuration is a regular {p, q} symbol and forwards to the {p, q} engine *)
VerificationTest[
  IsomorphicGraphQ[
    TessellationNeighborhoodGraph[ { 6, 6, 6 }, 3 ],
    TessellationNeighborhoodGraph[ { 6, 3 }, 3 ] ],
  True,
  TestID -> "TessellatedDisk-regular-config-forwards"
]

(* a spherical configuration (defect > 0) is the finite Archimedean solid: cuboctahedron *)
VerificationTest[
  With[ { g = TessellationNeighborhoodGraph[ { 3, 4, 3, 4 }, 9 ] },
    VertexCount @ g == 12 && Max @ VertexDegree @ g == 4 ],
  True,
  TestID -> "TessellatedDisk-cuboctahedron"
]

(* a hyperbolic uniform tiling (defect < 0) grows in the Poincare disk: interior valence is the
   configuration length, both face sizes occur, and the patch is genuinely hyperbolic (K = -1) *)
VerificationTest[
  With[ { g = TessellationNeighborhoodGraph[ { 3, 7, 3, 7 }, 3 ] },
    Max @ VertexDegree @ g == 4 && FindCycle[ g, { 3 }, 1 ] =!= {} && FindCycle[ g, { 7 }, 1 ] =!= {} ],
  True,
  TestID -> "TessellatedDisk-hyperbolic-3737"
]

(* a hyperbolic uniform tiling with three distinct face sizes, including a large polygon *)
VerificationTest[
  Max @ VertexDegree @ TessellationNeighborhoodGraph[ { 4, 6, 14 }, 3 ],
  3,
  TestID -> "TessellatedDisk-hyperbolic-4-6-14"
]

(* the curvature parameter solved from the angle defect has the sign of the defect *)
VerificationTest[
  Sign /@ { TessellationCurvature[ { 4, 8, 8 } ], TessellationCurvature[ { 3, 7, 3, 7 } ], TessellationCurvature[ { 3, 5 } ] },
  { 0, -1, 1 },
  TestID -> "TessellatedDisk-defect-signs"
]

EndTestSection[]
