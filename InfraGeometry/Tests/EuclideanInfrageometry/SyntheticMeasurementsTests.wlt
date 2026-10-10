VerificationTest[
  InfraMeasurement[CycleGraph[4],InfraMidpoint[1,3],"VertexDensity"],
  <|2->1,4->1|>,
  TestID -> "T5-InfraMidpointVertexDensity"
]

VerificationTest[
  InfraMeasurement[CycleGraph[4],InfraMidpoint[1,3],"Cardinality"],
  2,
  TestID -> "T5-InfraMidpointCardinality"
]

VerificationTest[
  InfraMeasurement[CycleGraph[4],InfraMidpoint[1,3],"CountingMeasure"],
  2,
  TestID -> "T5-InfraMidpointCountingMeasure"
]

VerificationTest[
  InfraMeasurement[CycleGraph[4],InfraMidpoint[1,3],"RiemannianMeasure"],
  0,
  TestID -> "T5-InfraMidpointRiemannianMeasure"
]

VerificationTest[
  VertexList[InfraMeasurement[CycleGraph[4],InfraMidpoint[1,3],"Subgraph"]],
  {2,4},
  TestID -> "T5-InfraMidpointsubgraph"
]

VerificationTest[
  InfraMemberQ[CycleGraph[4],InfraMidpoint[1,3],2],
  True,
  TestID -> "T5-InfraMidpointmember"
]

VerificationTest[
  InfraMemberQ[CycleGraph[4],InfraMidpoint[1,3],1],
  False,
  TestID -> "T5-InfraMidpointnonmember"
]

VerificationTest[
  Head[InfraMeasurement[CycleGraph[4],InfraMidpoint[1,3],"Graph"]],
  InfraMeasurement,
  TestID -> "T5-InfraMidpointunsupportedGraph"
]

VerificationTest[
  Head[InfraMeasurement[CycleGraph[4],InfraMidpoint[1,3],"EdgeDensity"]],
  InfraMeasurement,
  TestID -> "T5-InfraMidpointunsupportedEdgeDensity"
]

VerificationTest[
  Head[InfraMeasurement[CycleGraph[4],InfraMidpoint[1,3],"Length"]],
  InfraMeasurement,
  TestID -> "T5-InfraMidpointunsupportedLength"
]

VerificationTest[
  Head[InfraMeasurement[CycleGraph[4],InfraMidpoint[1,3],"Area"]],
  InfraMeasurement,
  TestID -> "T5-InfraMidpointunsupportedArea"
]

VerificationTest[
  Head[InfraMeasurement[CycleGraph[4],InfraMidpoint[1,3],"Volume"]],
  InfraMeasurement,
  TestID -> "T5-InfraMidpointunsupportedVolume"
]

VerificationTest[
  InfraDensity[CycleGraph[4],InfraMidpoint[1,3]],
  <|2->1,4->1|>,
  TestID -> "T5-InfraMidpointdensity"
]

VerificationTest[
  InfraDistance[CycleGraph[4],InfraMidpoint[1,3],1],
  1,
  TestID -> "T5-InfraMidpointdistance"
]

VerificationTest[
  With[{g=CycleGraph[4]},SeedRandom[831];With[{expected=RandomInteger[100000]},SeedRandom[831];InfraMeasurement[g,InfraMidpoint[1,3],All];InfraMemberQ[g,InfraMidpoint[1,3],2];InfraDistance[g,InfraMidpoint[1,3],1];RandomInteger[100000]===expected]],
  True,
  TestID -> "T5-InfraMidpointrng"
]

VerificationTest[
  InfraMeasurement[CycleGraph[4],InfraPerpendicularBisector[1,3],"VertexDensity"],
  <|2->1,4->1|>,
  TestID -> "T5-InfraPerpendicularBisectorVertexDensity"
]

VerificationTest[
  InfraMeasurement[CycleGraph[4],InfraPerpendicularBisector[1,3],"Cardinality"],
  2,
  TestID -> "T5-InfraPerpendicularBisectorCardinality"
]

VerificationTest[
  InfraMeasurement[CycleGraph[4],InfraPerpendicularBisector[1,3],"CountingMeasure"],
  2,
  TestID -> "T5-InfraPerpendicularBisectorCountingMeasure"
]

VerificationTest[
  InfraMeasurement[CycleGraph[4],InfraPerpendicularBisector[1,3],"RiemannianMeasure"],
  0,
  TestID -> "T5-InfraPerpendicularBisectorRiemannianMeasure"
]

VerificationTest[
  VertexList[InfraMeasurement[CycleGraph[4],InfraPerpendicularBisector[1,3],"Subgraph"]],
  {2,4},
  TestID -> "T5-InfraPerpendicularBisectorsubgraph"
]

VerificationTest[
  InfraMemberQ[CycleGraph[4],InfraPerpendicularBisector[1,3],2],
  True,
  TestID -> "T5-InfraPerpendicularBisectormember"
]

VerificationTest[
  InfraMemberQ[CycleGraph[4],InfraPerpendicularBisector[1,3],1],
  False,
  TestID -> "T5-InfraPerpendicularBisectornonmember"
]

VerificationTest[
  Head[InfraMeasurement[CycleGraph[4],InfraPerpendicularBisector[1,3],"Graph"]],
  InfraMeasurement,
  TestID -> "T5-InfraPerpendicularBisectorunsupportedGraph"
]

VerificationTest[
  Head[InfraMeasurement[CycleGraph[4],InfraPerpendicularBisector[1,3],"EdgeDensity"]],
  InfraMeasurement,
  TestID -> "T5-InfraPerpendicularBisectorunsupportedEdgeDensity"
]

VerificationTest[
  Head[InfraMeasurement[CycleGraph[4],InfraPerpendicularBisector[1,3],"Length"]],
  InfraMeasurement,
  TestID -> "T5-InfraPerpendicularBisectorunsupportedLength"
]

VerificationTest[
  Head[InfraMeasurement[CycleGraph[4],InfraPerpendicularBisector[1,3],"Area"]],
  InfraMeasurement,
  TestID -> "T5-InfraPerpendicularBisectorunsupportedArea"
]

VerificationTest[
  Head[InfraMeasurement[CycleGraph[4],InfraPerpendicularBisector[1,3],"Volume"]],
  InfraMeasurement,
  TestID -> "T5-InfraPerpendicularBisectorunsupportedVolume"
]

VerificationTest[
  InfraDensity[CycleGraph[4],InfraPerpendicularBisector[1,3]],
  <|2->1,4->1|>,
  TestID -> "T5-InfraPerpendicularBisectordensity"
]

VerificationTest[
  InfraDistance[CycleGraph[4],InfraPerpendicularBisector[1,3],1],
  1,
  TestID -> "T5-InfraPerpendicularBisectordistance"
]

VerificationTest[
  With[{g=CycleGraph[4]},SeedRandom[831];With[{expected=RandomInteger[100000]},SeedRandom[831];InfraMeasurement[g,InfraPerpendicularBisector[1,3],All];InfraMemberQ[g,InfraPerpendicularBisector[1,3],2];InfraDistance[g,InfraPerpendicularBisector[1,3],1];RandomInteger[100000]===expected]],
  True,
  TestID -> "T5-InfraPerpendicularBisectorrng"
]

VerificationTest[
  InfraMeasurement[CycleGraph[4],InfraRegionNearest[{2,4},1],"VertexDensity"],
  <|2->1,4->1|>,
  TestID -> "T5-InfraRegionNearestVertexDensity"
]

VerificationTest[
  InfraMeasurement[CycleGraph[4],InfraRegionNearest[{2,4},1],"Cardinality"],
  2,
  TestID -> "T5-InfraRegionNearestCardinality"
]

VerificationTest[
  InfraMeasurement[CycleGraph[4],InfraRegionNearest[{2,4},1],"CountingMeasure"],
  2,
  TestID -> "T5-InfraRegionNearestCountingMeasure"
]

VerificationTest[
  InfraMeasurement[CycleGraph[4],InfraRegionNearest[{2,4},1],"RiemannianMeasure"],
  0,
  TestID -> "T5-InfraRegionNearestRiemannianMeasure"
]

VerificationTest[
  VertexList[InfraMeasurement[CycleGraph[4],InfraRegionNearest[{2,4},1],"Subgraph"]],
  {2,4},
  TestID -> "T5-InfraRegionNearestsubgraph"
]

VerificationTest[
  InfraMemberQ[CycleGraph[4],InfraRegionNearest[{2,4},1],2],
  True,
  TestID -> "T5-InfraRegionNearestmember"
]

VerificationTest[
  InfraMemberQ[CycleGraph[4],InfraRegionNearest[{2,4},1],1],
  False,
  TestID -> "T5-InfraRegionNearestnonmember"
]

VerificationTest[
  Head[InfraMeasurement[CycleGraph[4],InfraRegionNearest[{2,4},1],"Graph"]],
  InfraMeasurement,
  TestID -> "T5-InfraRegionNearestunsupportedGraph"
]

VerificationTest[
  Head[InfraMeasurement[CycleGraph[4],InfraRegionNearest[{2,4},1],"EdgeDensity"]],
  InfraMeasurement,
  TestID -> "T5-InfraRegionNearestunsupportedEdgeDensity"
]

VerificationTest[
  Head[InfraMeasurement[CycleGraph[4],InfraRegionNearest[{2,4},1],"Length"]],
  InfraMeasurement,
  TestID -> "T5-InfraRegionNearestunsupportedLength"
]

VerificationTest[
  Head[InfraMeasurement[CycleGraph[4],InfraRegionNearest[{2,4},1],"Area"]],
  InfraMeasurement,
  TestID -> "T5-InfraRegionNearestunsupportedArea"
]

VerificationTest[
  Head[InfraMeasurement[CycleGraph[4],InfraRegionNearest[{2,4},1],"Volume"]],
  InfraMeasurement,
  TestID -> "T5-InfraRegionNearestunsupportedVolume"
]

VerificationTest[
  InfraDensity[CycleGraph[4],InfraRegionNearest[{2,4},1]],
  <|2->1,4->1|>,
  TestID -> "T5-InfraRegionNearestdensity"
]

VerificationTest[
  InfraDistance[CycleGraph[4],InfraRegionNearest[{2,4},1],1],
  1,
  TestID -> "T5-InfraRegionNearestdistance"
]

VerificationTest[
  With[{g=CycleGraph[4]},SeedRandom[831];With[{expected=RandomInteger[100000]},SeedRandom[831];InfraMeasurement[g,InfraRegionNearest[{2,4},1],All];InfraMemberQ[g,InfraRegionNearest[{2,4},1],2];InfraDistance[g,InfraRegionNearest[{2,4},1],1];RandomInteger[100000]===expected]],
  True,
  TestID -> "T5-InfraRegionNearestrng"
]

VerificationTest[
  InfraMeasurement[PathGraph[{1,2}],InfraMidpoint[1,2],"VertexDensity"],
  <||>,
  TestID -> "T5-emptyVertexDensity"
]

VerificationTest[
  InfraMeasurement[PathGraph[{1,2}],InfraMidpoint[1,2],"Cardinality"],
  0,
  TestID -> "T5-emptyCardinality"
]

VerificationTest[
  InfraMeasurement[PathGraph[{1,2}],InfraMidpoint[1,2],"CountingMeasure"],
  0,
  TestID -> "T5-emptyCountingMeasure"
]

VerificationTest[
  InfraMeasurement[PathGraph[{1,2}],InfraMidpoint[1,2],"RiemannianMeasure"],
  0,
  TestID -> "T5-emptyRiemannianMeasure"
]

VerificationTest[
  VertexCount[InfraMeasurement[PathGraph[{1,2}],InfraMidpoint[1,2],"Subgraph"]],
  0,
  TestID -> "T5-empty-subgraph"
]

VerificationTest[
  InfraMemberQ[PathGraph[{1,2}],InfraMidpoint[1,2],1],
  False,
  TestID -> "T5-empty-member"
]

VerificationTest[
  InfraDistance[PathGraph[{1,2}],InfraMidpoint[1,2],1],
  Infinity,
  TestID -> "T5-empty-distance"
]

VerificationTest[
  InfraDistance[Graph[{1,2},{}],{1},{2}],
  Infinity,
  TestID -> "T5-disconnected-distance"
]

VerificationTest[
  InfraDistance[PathGraph[Range[4]],<|1->0,4->2|>,1],
  3,
  TestID -> "T5-distance-nonzero"
]

VerificationTest[
  InfraDistance[PathGraph[Range[4]],{1,2},{3,4}],
  1,
  TestID -> "T5-region-distance"
]

VerificationTest[
  InfraDistance[PathGraph[Range[4]],{1,2},{3,4},"Aggregation"->Max],
  3,
  TestID -> "T5-distance-max"
]

VerificationTest[
  InfraDistance[PathGraph[Range[4]],InfraBall[1,1],4],
  2,
  TestID -> "T5-old-region-distance"
]

VerificationTest[
  Head[InfraDistance[PathGraph[{1,2}],99,1]],
  InfraDistance,
  TestID -> "T5-invalid-distance"
]

VerificationTest[
  Head[InfraMemberQ[CycleGraph[4],InfraMidpoint[1,3],99]],
  InfraMemberQ,
  TestID -> "T5-invalid-member"
]

VerificationTest[
  Head[InfraMeasurement[PathGraph[{1,2}],InfraMidpoint[1,99],"CountingMeasure"]],
  InfraMeasurement,
  TestID -> "T5-nonmatch59"
]

VerificationTest[
  Head[InfraDensity[PathGraph[{1,2}],InfraMidpoint[1,99]]],
  InfraDensity,
  TestID -> "T5-nonmatch60"
]

VerificationTest[
  Head[InfraMeasurement[PathGraph[{1,2},DirectedEdges->True],InfraMidpoint[1,2],"VertexDensity"]],
  InfraMeasurement,
  TestID -> "T5-nonmatch61"
]

VerificationTest[
  With[{g=Graph[{{},{1},{2}},{UndirectedEdge[{},{1}],UndirectedEdge[{1},{2}]}]}, {InfraDensity[g,InfraMidpoint[{},{2}]],InfraMemberQ[g,InfraMidpoint[{},{2}],{1}],InfraDistance[g,{}, {2}]}],
  {<|{1}->1|>,True,2},
  TestID -> "T5-list-labels"
]

VerificationTest[
  With[{g=Graph[{InfraMidpoint[1,2],x},{UndirectedEdge[InfraMidpoint[1,2],x]}]}, {InfraDensity[g,InfraMidpoint[1,2]],InfraDistance[g,InfraMidpoint[1,2],x]}],
  {<|InfraMidpoint[1,2]->1|>,1},
  TestID -> "T5-inert-label"
]

VerificationTest[
  InfraMeasurement[PathGraph[Range[4]],InfraPerpendicularBisector[1,1],"RiemannianMeasure"],
  4,
  TestID -> "T5-full-component-interior"
]

VerificationTest[
  InfraMeasurement[PathGraph[{1,2}],InfraSegment[1,2],"Midpoint"],
  <|1->1,2->1|>,
  TestID -> "T5-old-midpoint"
]

VerificationTest[
  InfraDensity[CycleGraph[4],InfraRegionNearest[InfraMidpoint[1,3],1]],
  <|2->1,4->1|>,
  TestID -> "T5-nested-nearest"
]

VerificationTest[
  InfraDistance[PathGraph[Range[4]],PathGraph[{1,2}],4],
  2,
  TestID -> "T5-raw-graph-distance"
]

VerificationTest[
  InfraMeasurement[PathGraph[Range[3]],InfraSegment[1,3,1],"Length"],
  4,
  TestID -> "T5-repeated-traversal-length"
]

VerificationTest[
  With[{g=Graph[{{},{1},{2}},{UndirectedEdge[{},{1}],UndirectedEdge[{1},{2}]}]}, {InfraMemberQ[g,InfraMidpoint[{},{}],{}],InfraMeasurement[g,InfraPerpendicularBisector[{1},{1}],"RiemannianMeasure"]}],
  {True,3},
  TestID -> "T5-empty-list-member-interior"
]

VerificationTest[
  InfraDistance[Graph[{},{}],{},{}],
  Infinity,
  TestID -> "T5-empty-graph-distance"
]

