VerificationTest[
  BlockRandom[
    SeedRandom[ 419 ];
    With[
      { base = Graph[ { "a", { "b", 1 }, "c", point[ 0 ] },
          { UndirectedEdge[ "a", { "b", 1 } ], UndirectedEdge[ { "b", 1 }, "c" ] } ],
        predicates = <| "EqualFiberSizes" -> InfraEqualFiberSizesQ, "IsomorphicFibers" -> InfraIsomorphicFibersQ,
          "Fibration" -> InfraFibrationQ, "AtMostOneEdgeLift" -> InfraAtMostOneEdgeLiftQ,
          "UniqueEdgeLifting" -> InfraUniqueEdgeLiftingQ, "FiberBundle" -> InfraFiberBundleQ, "Covering" -> InfraCoveringQ |> },
      Select[ Subsets[ Keys[ predicates ] ], properties |-> With[
        { fibered = RandomInfraFiberedGraph[ base, Properties -> properties, "VerticalVertexCount" -> { 2, 3 } ] },
        ! TrueQ[ InfraFiberedGraphQ[ fibered ] &&
          Sort[ VertexList @ InfraBaseSpace[ fibered ] ] === Sort[ VertexList[ base ] ] &&
          Sort[ Sort /@ ( List @@@ EdgeList @ InfraBaseSpace[ fibered ] ) ] ===
            Sort[ Sort /@ ( List @@@ EdgeList[ base ] ) ] &&
          AllTrue[ properties, Lookup[ predicates, # ][ fibered ] & ] ] ] ] ] ],
  { },
  TestID -> "all-property-combinations-preserve-literal-base-and-requested-laws"
]
