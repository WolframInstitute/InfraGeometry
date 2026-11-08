BeginTestSection[ "SpatialReconstruction" ]

Needs[ "WolframInstitute`InfraGeometry`" ]

$spatialDiamond = Graph[ { "a" -> "b", "a" -> "c", "b" -> "d", "c" -> "d" } ];
$spatialDiamondFoliation = { { "a" }, { "b", "c" }, { "d" } };

$spatialMultiple = Graph[ { "p" -> "x", "p" -> "y", "q" -> "x", "q" -> "y" } ];
$spatialMultipleFoliation = { { "p", "q" }, { "x", "y" } };

$spatialDepth = Graph[ { "r" -> "a", "r" -> "b", "a" -> "x", "b" -> "y" } ];
$spatialDepthFoliation = { { "r" }, { "a", "b" }, { "x", "y" } };
$spatialDepthShortcuts = EdgeAdd[ $spatialDepth, { "r" -> "x", "r" -> "y" } ];

$spatialOrphan = Graph[ { "a", "b", "c" }, { "a" -> "c" } ];
$spatialOrphanFoliation = { { "a", "b" }, { "c" } };

$spatialSkipped = Graph[ { "p" -> "x", "p" -> "y", "q" -> "z", "z" -> "w" } ];
$spatialSkippedFoliation = { { "p", "q" }, { "z" }, { "x", "y", "w" } };

$spatialTuple = Graph[ { { 0, 0 } -> { 1, 0 }, { 0, 0 } -> { 1, 1 } } ];
$spatialTupleFoliation = { { { 0, 0 } }, { { 1, 0 }, { 1, 1 } } };

$spatialComposition = Graph[
  { "a" -> "u", "a" -> "v", "b" -> "v", "u" -> "z", "v" -> "z" } ];
$spatialCompositionFoliation = { { "a", "b" }, { "u", "v" }, { "z" } };

$spatialNonhomomorphism = Graph[ { "r" -> "a", "r" -> "p", "s" -> "b", "s" -> "p",
  "a" -> "x", "b" -> "y", "p" -> "x", "p" -> "y", "p" -> "z" } ];
$spatialNonhomomorphismFoliation = { { "r", "s" }, { "a", "b", "p" }, { "x", "y", "z" } };

VerificationTest[
  CausalFoliationQ[ $spatialDiamond, $spatialDiamondFoliation ],
  True,
  TestID -> "CausalFoliationQ-Ordered-partition"
]

VerificationTest[
  Map[ foliation |-> CausalFoliationQ[ $spatialDiamond, foliation ],
    { { { "a" }, { }, { "b", "c" }, { "d" } }, { { "a" }, { "b", "c", "b" }, { "d" } },
      { { "a" }, { "b" }, { "d" } }, { { "a", "b" }, { "c" }, { "d" } },
      Reverse @ $spatialDiamondFoliation } ],
  ConstantArray[ False, 5 ],
  TestID -> "CausalFoliationQ-Rejects-empty-duplicate-incomplete-comparable-and-reversed-slices"
]

VerificationTest[
  { CausalFoliationQ[ Graph[ { 1 -> 2, 2 -> 1 } ], { { 1 }, { 2 } } ],
    CausalFoliationQ[ Graph[ { UndirectedEdge[ 1, 2 ] } ], { { 1 }, { 2 } } ],
    CausalFoliationQ[ Graph[ { } ], { } ], CausalSpatialGraphs[ Graph[ { } ] ] },
  { False, False, True, <| |> },
  TestID -> "CausalFoliationQ-DAG-domain-and-empty-graph"
]

VerificationTest[
  With[ { graphs = CausalSpatialGraphs[ $spatialDiamond ] },
    { Keys @ graphs, VertexList /@ graphs, EdgeList /@ graphs } ],
  { { 1, 2, 3 }, <| 1 -> { "a" }, 2 -> { "b", "c" }, 3 -> { "d" } |>,
    <| 1 -> { }, 2 -> { UndirectedEdge[ "b", "c" ] }, 3 -> { } |> },
  TestID -> "CausalSpatialGraphs-Diamond-common-parent"
]

VerificationTest[
  { EdgeList @ CausalSpatialGraphs[ $spatialMultiple, $spatialMultipleFoliation ][ 2 ],
    CausalSliceRelation[ $spatialMultiple, $spatialMultipleFoliation, { 2, 1 } ],
    CausalSliceKernel[ $spatialMultiple, $spatialMultipleFoliation, { 2, 1 } ] },
  { { UndirectedEdge[ "x", "y" ] }, <| "x" -> { "p", "q" }, "y" -> { "p", "q" } |>,
    <| "x" -> <| "p" -> 1 / 2, "q" -> 1 / 2 |>, "y" -> <| "p" -> 1 / 2, "q" -> 1 / 2 |> |> },
  TestID -> "CausalSpatialGraphs-Multiple-lowest-common-ancestors-retained"
]

VerificationTest[
  Map[ depth |-> EdgeList @ CausalSpatialGraphs[ $spatialDepth, $spatialDepthFoliation, "AncestorDepth" -> depth ][ 3 ],
    { 0, 1, 2 } ],
  { { }, { }, { UndirectedEdge[ "x", "y" ] } },
  TestID -> "CausalSpatialGraphs-Depth-prevents-remote-common-ancestor-cliques"
]

VerificationTest[
  AllTrue[ { 0, 1, 2 }, depth |->
    ( EdgeList /@ CausalSpatialGraphs[ $spatialDepth, $spatialDepthFoliation, "AncestorDepth" -> depth ] ) ===
      ( EdgeList /@ CausalSpatialGraphs[ $spatialDepthShortcuts, $spatialDepthFoliation, "AncestorDepth" -> depth ] ) ],
  True,
  TestID -> "CausalSpatialGraphs-Invariant-under-transitive-shortcuts"
]

VerificationTest[
  { CausalFoliationQ[ $spatialSkipped, $spatialSkippedFoliation ],
    EdgeList @ CausalSpatialGraphs[ $spatialSkipped, $spatialSkippedFoliation ][ 3 ],
    EdgeList @ CausalSpatialGraphs[ $spatialSkipped, $spatialSkippedFoliation, "AncestorDepth" -> 2 ][ 3 ],
    CausalSliceRelation[ $spatialSkipped, $spatialSkippedFoliation, { 1, 3 } ],
    CausalSliceRelation[ $spatialSkipped, $spatialSkippedFoliation, { 1, 2 } ] },
  { True, { }, { UndirectedEdge[ "x", "y" ] }, <| "p" -> { "x", "y" }, "q" -> { "w" } |>,
    <| "p" -> { }, "q" -> { "z" } |> },
  TestID -> "SpatialReconstruction-Arbitrary-foliation-may-be-skipped-by-causal-paths"
]

VerificationTest[
  { CausalSliceRelation[ $spatialDiamond, $spatialDiamondFoliation, { 2, 1 } ],
    CausalSliceRelation[ $spatialDiamond, $spatialDiamondFoliation, { 2, 3 } ],
    CausalSliceRelation[ $spatialDiamond, $spatialDiamondFoliation, { 3, 1 } ],
    CausalSliceRelation[ $spatialDiamond, $spatialDiamondFoliation, { 2, 2 } ] },
  { <| "b" -> { "a" }, "c" -> { "a" } |>, <| "b" -> { "d" }, "c" -> { "d" } |>,
    <| "d" -> { "a" } |>, <| "b" -> { "b" }, "c" -> { "c" } |> },
  TestID -> "CausalSliceRelation-Both-directions-long-range-and-identity"
]

VerificationTest[
  { CausalSliceMap[ $spatialDiamond, $spatialDiamondFoliation, { 2, 1 } ],
    CausalSliceMap[ $spatialDiamond, $spatialDiamondFoliation, { 2, 3 } ],
    Head @ CausalSliceMap[ $spatialDiamond, $spatialDiamondFoliation, { 3, 2 } ],
    CausalSliceMap[ $spatialDiamond, $spatialDiamondFoliation, { 2, 2 } ] },
  { <| "b" -> "a", "c" -> "a" |>, <| "b" -> "d", "c" -> "d" |>,
    CausalSliceMap, <| "b" -> "b", "c" -> "c" |> },
  TestID -> "CausalSliceMap-Only-unique-images-by-default"
]

VerificationTest[
  { CausalSliceMap[ $spatialDiamond, $spatialDiamondFoliation, { 3, 2 }, "SelectImage" -> First ],
    CausalSliceMap[ $spatialDiamond, $spatialDiamondFoliation, { 3, 2 }, "SelectImage" -> Last ],
    Head @ CausalSliceMap[ $spatialDiamond, $spatialDiamondFoliation, { 3, 2 },
      "SelectImage" -> ( candidates |-> "outside" ) ],
    Head @ CausalSliceMap[ $spatialDiamond, $spatialDiamondFoliation, { 3, 2 },
      "SelectImage" -> ( candidates |-> Blank[ ] ) ] },
  { <| "d" -> "b" |>, <| "d" -> "c" |>, CausalSliceMap, CausalSliceMap },
  TestID -> "CausalSliceMap-Explicit-valid-selection-required"
]

VerificationTest[
  With[ { graph = Graph[ { DirectedEdge[ "a", "b", "left" ], DirectedEdge[ "a", "c", "right" ] } ],
      foliation = { { "a" }, { "b", "c" } } },
    { CausalFoliationQ[ graph, foliation ], EdgeList @ CausalSpatialGraphs[ graph, foliation ][ 2 ],
      CausalSliceMap[ graph, foliation, { 2, 1 } ] } ],
  { True, { UndirectedEdge[ "b", "c" ] }, <| "b" -> "a", "c" -> "a" |> },
  TestID -> "SpatialReconstruction-Tagged-directed-edges"
]

VerificationTest[
  With[ { graph = Graph[ { Blank[ ] -> "x", "a" -> "y" } ],
      foliation = { { Blank[ ], "a" }, { "x", "y" } } },
    CausalSliceRelation[ graph, foliation, { 2, 1 } ] ],
  <| "x" -> { Blank[ ] }, "y" -> { "a" } |>,
  TestID -> "CausalSliceRelation-Pattern-vertex-labels-are-literal"
]

VerificationTest[
  { CausalSliceKernel[ $spatialDiamond, $spatialDiamondFoliation, { 3, 2 } ],
    CausalSliceKernel[ $spatialDiamond, $spatialDiamondFoliation, { 1, 2 } ],
    CausalSliceKernel[ $spatialDiamond, $spatialDiamondFoliation, { 2, 2 } ] },
  { <| "d" -> <| "b" -> 1 / 2, "c" -> 1 / 2 |> |>,
    <| "a" -> <| "b" -> 1 / 2, "c" -> 1 / 2 |> |>,
    <| "b" -> <| "b" -> 1 |>, "c" -> <| "c" -> 1 |> |> },
  TestID -> "CausalSliceKernel-Symmetric-diamond-and-identity"
]

VerificationTest[
  { CausalSliceRelation[ $spatialOrphan, $spatialOrphanFoliation, { 1, 2 } ],
    Head @ CausalSliceMap[ $spatialOrphan, $spatialOrphanFoliation, { 1, 2 }, "SelectImage" -> First ],
    Head @ CausalSliceKernel[ $spatialOrphan, $spatialOrphanFoliation, { 1, 2 } ],
    CausalSliceMap[ $spatialOrphan, $spatialOrphanFoliation, { 2, 1 } ] },
  { <| "a" -> { "c" }, "b" -> { } |>, CausalSliceMap, CausalSliceKernel, <| "c" -> "a" |> },
  TestID -> "CausalSliceKernel-Orphan-row-kept-in-relation-and-rejected-for-transport"
]

VerificationTest[
  { CausalFoliationQ[ $spatialTuple, $spatialTupleFoliation ],
    VertexList @ CausalSpatialGraphs[ $spatialTuple, $spatialTupleFoliation ][ 2 ],
    EdgeList @ CausalSpatialGraphs[ $spatialTuple, $spatialTupleFoliation ][ 2 ],
    Lookup[ CausalSliceRelation[ $spatialTuple, $spatialTupleFoliation, { 2, 1 } ], Key[ { 1, 0 } ] ],
    Lookup[ CausalSliceMap[ $spatialTuple, $spatialTupleFoliation, { 2, 1 } ], Key[ { 1, 0 } ] ],
    Lookup[ Lookup[ CausalSliceKernel[ $spatialTuple, $spatialTupleFoliation, { 2, 1 } ],
      Key[ { 1, 0 } ] ], Key[ { 0, 0 } ] ] },
  { True, { { 1, 0 }, { 1, 1 } }, { UndirectedEdge[ { 1, 0 }, { 1, 1 } ] }, { { 0, 0 } }, { 0, 0 }, 1 },
  TestID -> "SpatialReconstruction-Preserves-tuple-vertex-labels"
]

VerificationTest[
  With[ { kernel = CausalSliceKernel[ $spatialComposition, $spatialCompositionFoliation, { 2, 1 } ],
      mass = <| "u" -> 2, "v" -> 6 |>, observable = <| "a" -> 3, "b" -> -2 |> },
    With[ { transported = AssociationMap[
        target |-> Total @ KeyValueMap[ { source, row } |-> mass[ source ] Lookup[ row, Key[ target ], 0 ], kernel ],
        { "a", "b" } ] },
      { Total /@ kernel, transported, Total @ transported === Total @ mass,
        Total @ KeyValueMap[ { target, weight } |-> observable[ target ] weight, transported ] ===
          Total @ KeyValueMap[ { source, row } |-> mass[ source ]
            Total @ KeyValueMap[ { target, weight } |-> observable[ target ] weight, row ], kernel ] } ] ],
  { <| "u" -> 1, "v" -> 1 |>, <| "a" -> 5, "b" -> 3 |>, True, True },
  TestID -> "CausalSliceKernel-Preserves-mass-and-observable-duality"
]

VerificationTest[
  With[ { first = CausalSliceKernel[ $spatialComposition, $spatialCompositionFoliation, { 3, 2 } ],
      second = CausalSliceKernel[ $spatialComposition, $spatialCompositionFoliation, { 2, 1 } ],
      direct = CausalSliceKernel[ $spatialComposition, $spatialCompositionFoliation, { 3, 1 } ] },
    { Total @ KeyValueMap[ { middle, weight } |-> weight Lookup[ second[ middle ], "a", 0 ], first[ "z" ] ],
      direct[ "z" ][ "a" ] } ],
  { 3 / 4, 1 / 2 },
  TestID -> "CausalSliceKernel-Direct-uniform-kernel-need-not-compose"
]

VerificationTest[
  With[ { graphs = CausalSpatialGraphs[ $spatialNonhomomorphism, $spatialNonhomomorphismFoliation ],
      map = CausalSliceMap[ $spatialNonhomomorphism, $spatialNonhomomorphismFoliation, { 3, 2 },
        "SelectImage" -> First ] },
    { Sort @ Values @ map === Sort @ VertexList @ graphs[ 2 ], EdgeQ[ graphs[ 3 ], UndirectedEdge[ "x", "y" ] ],
      EdgeQ[ graphs[ 2 ], UndirectedEdge[ map[ "x" ], map[ "y" ] ] ] } ],
  { True, True, False },
  TestID -> "CausalSliceMap-Surjective-causal-selection-need-not-preserve-spatial-adjacency"
]

VerificationTest[
  With[ { graph = Graph[ { "a" -> "x", "a" -> "y", "b" -> "x" } ],
      foliation = { { "a", "b" }, { "x", "y" } } },
    CausalSliceMap[ graph, foliation, { 1, 2 }, "SelectImage" -> First ] ],
  <| "a" -> "x", "b" -> "x" |>,
  TestID -> "CausalSliceMap-Selection-need-not-be-surjective"
]

VerificationTest[
  { CausalSliceRelation[ $spatialDiamond, Automatic, { 3, 2 } ],
    CausalSliceMap[ $spatialDiamond, Automatic, { 2, 1 } ],
    CausalSliceKernel[ $spatialDiamond, Automatic, { 3, 2 } ] },
  { <| "d" -> { "b", "c" } |>, <| "b" -> "a", "c" -> "a" |>,
    <| "d" -> <| "b" -> 1 / 2, "c" -> 1 / 2 |> |> },
  TestID -> "SpatialReconstruction-Automatic-causal-height-foliation"
]

VerificationTest[
  { Head @ CausalSpatialGraphs[ $spatialDiamond, Reverse @ $spatialDiamondFoliation ],
    Head @ CausalSpatialGraphs[ $spatialDiamond, $spatialDiamondFoliation, "AncestorDepth" -> -1 ],
    Head @ CausalSliceRelation[ $spatialDiamond, $spatialDiamondFoliation, { 0, 1 } ],
    Head @ CausalSliceMap[ $spatialDiamond, $spatialDiamondFoliation, { 1, 4 } ],
    Head @ CausalSliceKernel[ $spatialDiamond, Reverse @ $spatialDiamondFoliation, { 1, 2 } ] },
  { CausalSpatialGraphs, CausalSpatialGraphs, CausalSliceRelation, CausalSliceMap, CausalSliceKernel },
  TestID -> "SpatialReconstruction-Invalid-input-remains-unevaluated"
]

EndTestSection[ ]
