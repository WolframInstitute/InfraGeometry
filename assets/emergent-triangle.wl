Needs["WolframInstitute`InfraGeometry`"]

emergentTriangleHero[] :=
  GraphicsRow[
    Table[
      With[
        {g = (SeedRandom[2]; InfraSubstrate["SquareTilingGraph", size, "KeepCoordinates" -> False])},
        {abc = triangleCorners[g]},
        {ab = InfraSegment[abc[[1]], abc[[2]]]},
        {bc = InfraSegment[abc[[2]], abc[[3]]]},
        {ca = InfraSegment[abc[[3]], abc[[1]]]},
        InfraSubstrateHighlight[g, {ab, bc, ca, abc}, ImageSize -> 420]],
      {size, {"Small", "Medium", "Large"}}],
    ImageSize -> Full, Spacings -> 20]

triangleCorners[g_] :=
  With[
    {c = First @ GraphCenter @ g, d = GraphDistanceMatrix @ g},
    {radius = Floor[GraphRadius[g]/2]},
    {shell = FindInfraShell[g, c, radius]},
    {row = end |-> d[[VertexIndex[g, end], VertexIndex[g, #] & /@ shell]]},
    {a = First @ shell},
    {b = SelectFirst[Reverse @ SortBy[shell, v |-> d[[VertexIndex[g, a], VertexIndex[g, v]]]],
      v |-> InfraMeasurement[g, InfraSegment[a, v], "Cardinality"] > 1]},
    {thirdCandidates = shell[[Reverse @ Ordering[MapThread[Min, {row @ a, row @ b}]]]]},
    {a, b, SelectFirst[thirdCandidates,
      v |-> InfraMeasurement[g, InfraSegment[a, v], "Cardinality"] > 1 &&
        InfraMeasurement[g, InfraSegment[b, v], "Cardinality"] > 1]}]
