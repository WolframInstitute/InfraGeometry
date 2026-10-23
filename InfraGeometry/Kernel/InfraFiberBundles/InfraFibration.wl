Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: InfraFiberBundles :: InfraFibration *)

InfraTotalSpace[ head_[ total_Graph, _ ] ] /;
    MemberQ[ { InfraFiberedGraph, InfraFibration }, head ] &&
      SimpleGraphQ[ total ] && UndirectedGraphQ[ total ] && ! WeightedGraphQ[ total ] && ! EdgeTaggedGraphQ[ total ] :=
  total

InfraProjection[ fib : head_[ total_Graph, projection_ ] ] /;
    MemberQ[ { InfraFiberedGraph, InfraFibration }, head ] && GraphQ[ InfraTotalSpace[ fib ] ] &&
      ( ! AssociationQ[ projection ] || Length[ projection ] == VertexCount[ total ] &&
        AllTrue[ VertexList[ total ], KeyExistsQ[ projection, # ] & ] ) :=
  AssociationMap[
    vertex |-> If[ AssociationQ[ projection ], Lookup[ projection, Key[ vertex ] ], projection[ vertex ] ],
    VertexList[ total ] ]

InfraBaseSpace[ fib : _[ _Graph, __ ] ] /;
    AssociationQ[ InfraProjection[ fib ] ] && GraphQ[ InfraTotalSpace[ fib ] ] :=
  With[ { projection = InfraProjection[ fib ], total = InfraTotalSpace[ fib ] },
    Graph[ DeleteDuplicates[ Values[ projection ] ],
      DeleteDuplicates @ Select[
        UndirectedEdge @@ Sort[ Lookup[ projection, Key /@ List @@ # ] ] & /@ EdgeList[ total ],
        First[ # ] =!= Last[ # ] & ] ] ]

InfraTotalGraph[ fib : _[ _Graph, __ ] ] /; GraphQ[ InfraTotalSpace[ fib ] ] :=
  InfraTotalSpace[ fib ]

InfraFibrationAssociation[ fib : _[ _Graph, __ ] ] /; AssociationQ[ InfraProjection[ fib ] ] :=
  InfraProjection[ fib ]

InfraBaseGraph[ fib : _[ _Graph, __ ] ] /; GraphQ[ InfraBaseSpace[ fib ] ] :=
  InfraBaseSpace[ fib ]

InfraFiber[ fib : _[ _Graph, __ ], point_ ] /;
    AssociationQ[ InfraProjection[ fib ] ] && GraphQ[ InfraTotalSpace[ fib ] ] :=
  Subgraph[ InfraTotalSpace[ fib ], Keys @ Select[ InfraProjection[ fib ], # === point & ] ]

InfraFibers[ fib : _[ _Graph, __ ] ] /;
    AssociationQ[ InfraProjection[ fib ] ] && GraphQ[ InfraTotalSpace[ fib ] ] :=
  With[ { projection = InfraProjection[ fib ], total = InfraTotalSpace[ fib ] },
    Subgraph[ total, # ] & /@ GroupBy[ VertexList[ total ], Lookup[ projection, Key[ # ] ] & ] ]

InfraEdgeLiftMultiplicity[ fib : _[ _Graph, __ ] ] /;
    AssociationQ[ InfraProjection[ fib ] ] && GraphQ[ InfraBaseSpace[ fib ] ] :=
  With[ { total = InfraTotalSpace[ fib ], base = InfraBaseSpace[ fib ], projection = InfraProjection[ fib ] },
    { vertices = VertexList[ total ], points = VertexList[ base ], indexedTotal = IndexGraph[ total ], indexedBase = IndexGraph[ base ] },
    { positions = AssociationThread[ vertices, Range @ Length[ vertices ] ],
      basePositions = AssociationThread[ points, Range @ Length[ points ] ] },
    AssociationMap[ vertex |-> With[
      { counts = Counts @ Lookup[ projection, Key /@ vertices[[ AdjacencyList[ indexedTotal, Lookup[ positions, Key[ vertex ] ] ] ]] ],
        neighbors = points[[ AdjacencyList[ indexedBase, Lookup[ basePositions, Key @ Lookup[ projection, Key[ vertex ] ] ] ] ]] },
      AssociationMap[ Lookup[ counts, Key[ # ], 0 ] &, neighbors ] ], vertices ] ]

InfraFiberedGraphQ[ fibs : { __ } ] :=
  And @@ ( InfraFiberedGraphQ /@ fibs )

InfraFiberedGraphQ[ { } ] :=
  False

InfraFiberedGraphQ[ fib : _[ _Graph, __ ] ] /;
    AssociationQ[ InfraProjection[ fib ] ] && GraphQ[ InfraBaseSpace[ fib ] ] :=
  True

InfraEqualFiberSizesQ[ fibs : { __ } ] :=
  And @@ ( InfraEqualFiberSizesQ /@ fibs )

InfraEqualFiberSizesQ[ { } ] :=
  False

InfraEqualFiberSizesQ[ fib : _[ _Graph, __ ] ] /;
    AssociationQ[ InfraProjection[ fib ] ] && GraphQ[ InfraBaseSpace[ fib ] ] :=
  Length[ DeleteDuplicates[ Values @ Counts @ Values @ InfraProjection[ fib ] ] ] <= 1

InfraIsomorphicFibersQ[ fibs : { __ } ] :=
  And @@ ( InfraIsomorphicFibersQ /@ fibs )

InfraIsomorphicFibersQ[ { } ] :=
  False

InfraIsomorphicFibersQ[ fib : _[ _Graph, __ ] ] /;
    AssociationQ[ InfraProjection[ fib ] ] && GraphQ[ InfraBaseSpace[ fib ] ] :=
  With[ { fibers = Values @ InfraFibers[ fib ] },
    Length[ fibers ] < 2 || AllTrue[ Rest[ fibers ], IsomorphicGraphQ[ First[ fibers ], # ] & ] ]

InfraFibrationQ[ fibs : { __ } ] :=
  And @@ ( InfraFibrationQ /@ fibs )

InfraFibrationQ[ { } ] :=
  False

InfraFibrationQ[ fib : _[ _Graph, __ ] ] /;
    AssociationQ[ InfraProjection[ fib ] ] && GraphQ[ InfraBaseSpace[ fib ] ] :=
  AllTrue[ Catenate[ Values /@ Values @ InfraEdgeLiftMultiplicity[ fib ] ], Positive ]

InfraAtMostOneEdgeLiftQ[ fibs : { __ } ] :=
  And @@ ( InfraAtMostOneEdgeLiftQ /@ fibs )

InfraAtMostOneEdgeLiftQ[ { } ] :=
  False

InfraAtMostOneEdgeLiftQ[ fib : _[ _Graph, __ ] ] /;
    AssociationQ[ InfraProjection[ fib ] ] && GraphQ[ InfraBaseSpace[ fib ] ] :=
  AllTrue[ Catenate[ Values /@ Values @ InfraEdgeLiftMultiplicity[ fib ] ], # <= 1 & ]

InfraUniqueEdgeLiftingQ[ fibs : { __ } ] :=
  And @@ ( InfraUniqueEdgeLiftingQ /@ fibs )

InfraUniqueEdgeLiftingQ[ { } ] :=
  False

InfraUniqueEdgeLiftingQ[ fib : _[ _Graph, __ ] ] /;
    AssociationQ[ InfraProjection[ fib ] ] && GraphQ[ InfraBaseSpace[ fib ] ] :=
  AllTrue[ Catenate[ Values /@ Values @ InfraEdgeLiftMultiplicity[ fib ] ], # == 1 & ]

InfraCoveringQ[ fibs : { __ } ] :=
  And @@ ( InfraCoveringQ /@ fibs )

InfraCoveringQ[ { } ] :=
  False

InfraCoveringQ[ fib : _[ _Graph, __ ] ] /;
    AssociationQ[ InfraProjection[ fib ] ] && GraphQ[ InfraBaseSpace[ fib ] ] :=
  InfraUniqueEdgeLiftingQ[ fib ] && AllTrue[ Values @ InfraFibers[ fib ], EdgeCount[ # ] == 0 & ]

InfraFiberBundleQ[ fibs : { __ } ] :=
  And @@ ( InfraFiberBundleQ /@ fibs )

InfraFiberBundleQ[ { } ] :=
  False

InfraFiberBundleQ[ fib : _[ _Graph, __ ] ] /;
    AssociationQ[ InfraProjection[ fib ] ] && GraphQ[ InfraBaseSpace[ fib ] ] :=
  With[ { projection = InfraProjection[ fib ], total = InfraTotalSpace[ fib ],
      base = InfraBaseSpace[ fib ], fibers = InfraFibers[ fib ] },
    { vertices = VertexList[ total ], indexed = IndexGraph[ total ] },
    { positions = AssociationThread[ vertices, Range @ Length[ vertices ] ] },
    InfraIsomorphicFibersQ[ fib ] && InfraUniqueEdgeLiftingQ[ fib ] &&
      AllTrue[ EdgeList[ base ], edge |-> With[
        { source = Lookup[ fibers, Key[ First[ edge ] ] ], target = Lookup[ fibers, Key[ Last[ edge ] ] ] },
        { transport = AssociationMap[
            vertex |-> First @ Select[ vertices[[ AdjacencyList[ indexed, Lookup[ positions, Key[ vertex ] ] ] ]],
              Lookup[ projection, Key[ # ] ] === Last[ edge ] & ], VertexList[ source ] ] },
        Sort[ UndirectedEdge @@ Sort[ Lookup[ transport, Key /@ List @@ # ] ] & /@ EdgeList[ source ] ] ===
          Sort[ UndirectedEdge @@ Sort[ List @@ # ] & /@ EdgeList[ target ] ] ] ] ]

Options[ RandomInfraFiberedGraph ] = {
  Properties -> { },
  "VerticalVertexCount" -> { 1 },
  "VerticalEdgeCount" -> { 0 },
  "HorizontalEdgeCount" -> Automatic,
  RandomSeeding         -> Automatic
}

RandomInfraFiberedGraph[ args___ ] /; FreeQ[ { args }, RandomSeeding -> None, { 1 } ] :=
  With[ { result = BlockRandom[
      RandomInfraFiberedGraph[ Sequence @@ DeleteCases[ { args }, RandomSeeding -> _ ], RandomSeeding -> None ],
      RandomSeeding -> FirstCase[ { args }, ( RandomSeeding -> seed_ ) :> seed, Automatic ] ] },
    result /; ! MatchQ[ result, HoldPattern[ RandomInfraFiberedGraph[ ___, RandomSeeding -> None ] ] ] ]

RandomInfraFiberedGraph[ base_Graph, opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( SubsetQ[ First /@ Options[ RandomInfraFiberedGraph ], First /@ Flatten @ { opts } ] &&
    With[ { properties = OptionValue[ RandomInfraFiberedGraph, { opts }, Properties ],
        vertices = OptionValue[ RandomInfraFiberedGraph, { opts }, "VerticalVertexCount" ],
        vertical = OptionValue[ RandomInfraFiberedGraph, { opts }, "VerticalEdgeCount" ],
        horizontal = OptionValue[ RandomInfraFiberedGraph, { opts }, "HorizontalEdgeCount" ] },
      SimpleGraphQ[ base ] && UndirectedGraphQ[ base ] && ! WeightedGraphQ[ base ] && ! EdgeTaggedGraphQ[ base ] &&
      ListQ[ properties ] && SubsetQ[ { "EqualFiberSizes", "IsomorphicFibers", "Fibration", "AtMostOneEdgeLift",
        "UniqueEdgeLifting", "FiberBundle", "Covering" }, properties ] &&
      ( MatchQ[ vertices, _Integer?Positive | { _Integer?Positive } ] ||
        MatchQ[ vertices, { lo_Integer?Positive, hi_Integer?Positive } /; lo <= hi ] ) &&
      ( MatchQ[ vertical, _Integer?NonNegative | { _Integer?NonNegative } ] ||
        MatchQ[ vertical, { lo_Integer?NonNegative, hi_Integer?NonNegative } /; lo <= hi ] ) &&
      ( MemberQ[ { Automatic, All }, horizontal ] || MatchQ[ horizontal, _Integer?NonNegative | { _Integer?NonNegative } ] ||
        MatchQ[ horizontal, { lo_Integer?NonNegative, hi_Integer?NonNegative } /; lo <= hi ] ) &&
      With[ { range = Which[ IntegerQ[ vertices ], { 1, vertices }, Length[ vertices ] == 1, { First[ vertices ], First[ vertices ] },
            True, vertices ],
          unique = ! DisjointQ[ properties, { "UniqueEdgeLifting", "FiberBundle", "Covering" } ] ||
            ContainsAll[ properties, { "Fibration", "AtMostOneEdgeLift" } ],
          covering = MemberQ[ properties, "Covering" ] },
        { atMost = unique || MemberQ[ properties, "AtMostOneEdgeLift" ],
          lifting = unique || MemberQ[ properties, "Fibration" ] },
        { lower = If[ lifting, Last[ range ], 1 ],
          upper = If[ atMost, First[ range ], First[ range ]^2 ],
          verticalCapacity = If[ covering, 0, Binomial[ First[ range ], 2 ] ] },
        VertexCount[ base ] == 0 ||
          ( IntegerQ[ vertical ] || Last[ vertical ] <= verticalCapacity ) &&
          ( EdgeCount[ base ] == 0 || Which[
            horizontal === Automatic, True,
            horizontal === All, ! atMost || Last[ range ] == 1,
            IntegerQ[ horizontal ], horizontal >= lower,
            True, First[ horizontal ] >= lower && Last[ horizontal ] <= upper ] ) ] ] ) :=
  With[ { properties = DeleteDuplicates @ OptionValue[ RandomInfraFiberedGraph, { opts }, Properties ],
      vertexSpecification = OptionValue[ RandomInfraFiberedGraph, { opts }, "VerticalVertexCount" ],
      verticalSpecification = OptionValue[ RandomInfraFiberedGraph, { opts }, "VerticalEdgeCount" ],
      horizontalSpecification = OptionValue[ RandomInfraFiberedGraph, { opts }, "HorizontalEdgeCount" ],
      points = VertexList[ base ] },
    { range = Which[ IntegerQ[ vertexSpecification ], { 1, vertexSpecification },
        Length[ vertexSpecification ] == 1, { First[ vertexSpecification ], First[ vertexSpecification ] }, True, vertexSpecification ],
      unique = ! DisjointQ[ properties, { "UniqueEdgeLifting", "FiberBundle", "Covering" } ] ||
        ContainsAll[ properties, { "Fibration", "AtMostOneEdgeLift" } ],
      commonSize = ! DisjointQ[ properties, { "EqualFiberSizes", "IsomorphicFibers", "FiberBundle" } ],
      isomorphic = ! DisjointQ[ properties, { "IsomorphicFibers", "FiberBundle" } ],
      covering = MemberQ[ properties, "Covering" ], bundle = MemberQ[ properties, "FiberBundle" ],
      drawCount = { specification, lower, upper } |-> Which[
        specification === Automatic, RandomInteger[ { lower, upper } ],
        specification === All, upper,
        IntegerQ[ specification ], RandomInteger[ { lower, Min[ specification, upper ] } ],
        Length[ specification ] == 1, First[ specification ],
        True, RandomInteger[ specification ] ] },
    { atMost = unique || MemberQ[ properties, "AtMostOneEdgeLift" ],
      lifting = unique || MemberQ[ properties, "Fibration" ],
      groups = If[ points === { }, { }, If[ commonSize, { Range @ Length[ points ] },
        If[ unique, ConnectedComponents @ IndexGraph[ base ], List /@ Range @ Length[ points ] ] ] ],
      template = count |-> With[
        { edgeCount = drawCount[ verticalSpecification, 0, If[ covering, 0, Binomial[ count, 2 ] ] ] },
        If[ edgeCount == 0, Graph[ Range[ count ], { } ], RandomGraph[ { count, edgeCount } ] ] ] },
    { sizes = Lookup[ Association @ Catenate @ Map[ group |-> With[ { count = RandomInteger[ range ] },
        Thread[ group -> ConstantArray[ count, Length[ group ] ] ] ], groups ], Range @ Length[ points ] ] },
    { fibers = AssociationThread[ points, MapThread[
        { point, count } |-> Table[ { point, index }, { index, count } ], { points, sizes } ] ],
      templates = If[ isomorphic && sizes =!= { },
        ConstantArray[ template[ First[ sizes ] ], Length[ sizes ] ], template /@ sizes ] },
    { vertical = Catenate @ MapThread[
        { fiber, graph } |-> ( UndirectedEdge @@ fiber[[ List @@ # ]] & /@ EdgeList[ graph ] ),
        { Values[ fibers ], templates } ],
      automorphisms = If[ bundle && templates =!= { }, GraphAutomorphismGroup[ First[ templates ] ], None ] },
    { horizontal = Catenate @ Map[ edge |-> With[
        { source = Lookup[ fibers, Key[ First[ edge ] ] ], target = Lookup[ fibers, Key[ Last[ edge ] ] ] },
        { sourceCount = Length[ source ], targetCount = Length[ target ] },
        { count = drawCount[ horizontalSpecification, If[ lifting, Max[ sourceCount, targetCount ], 1 ],
            If[ atMost, Min[ sourceCount, targetCount ], sourceCount targetCount ] ],
          pairs = Tuples[ { Range[ sourceCount ], Range[ targetCount ] } ] },
        { selected = Which[
            horizontalSpecification === All, pairs,
            bundle, Transpose[ { Range[ sourceCount ], PermutationList[ RandomPermutation[ automorphisms ], sourceCount ] } ],
            unique, Transpose[ { Range[ sourceCount ], RandomSample @ Range[ targetCount ] } ],
            atMost, Transpose[ { RandomSample[ Range[ sourceCount ], count ], RandomSample[ Range[ targetCount ], count ] } ],
            lifting,
              (* The remaining budget must cover every isolated endpoint; this does not force a perfect matching. *)
              Nest[ chosen |-> Append[ chosen, RandomChoice @ Select[ Complement[ pairs, chosen ], pair |-> With[
                { extended = Append[ chosen, pair ] },
                Max[ sourceCount - Length @ DeleteDuplicates[ First /@ extended ],
                  targetCount - Length @ DeleteDuplicates[ Last /@ extended ] ] <= count - Length[ extended ] ] ] ], { }, count ],
            True, RandomSample[ pairs, count ] ] },
        UndirectedEdge[ source[[ First[ # ] ]], target[[ Last[ # ] ]] ] & /@ selected ], EdgeList[ base ] ] },
    { vertices = Catenate[ Values[ fibers ] ] },
    InfraFiberedGraph[ Graph[ vertices, Join[ vertical, horizontal ] ], AssociationMap[ First, vertices ] ] ]

InfraBundleMorphismQ[ fib1 : _[ _Graph, __ ], fib2 : _[ _Graph, __ ], map_, baseMap_ : Identity ] /;
    AssociationQ[ InfraProjection[ fib1 ] ] && AssociationQ[ InfraProjection[ fib2 ] ] :=
  With[ { total1 = InfraTotalSpace[ fib1 ], total2 = InfraTotalSpace[ fib2 ],
      projection1 = InfraProjection[ fib1 ], projection2 = InfraProjection[ fib2 ],
      apply = { function, vertex } |-> If[ AssociationQ[ function ], Lookup[ function, Key[ vertex ] ], function[ vertex ] ] },
    { positions = AssociationThread[ VertexList[ total2 ], Range @ VertexCount[ total2 ] ], indexed = IndexGraph[ total2 ] },
    ( ! AssociationQ[ map ] || AllTrue[ VertexList[ total1 ], KeyExistsQ[ map, # ] & ] ) &&
      ( ! AssociationQ[ baseMap ] || AllTrue[ Values[ projection1 ], KeyExistsQ[ baseMap, # ] & ] ) &&
      AllTrue[ VertexList[ total1 ], vertex |-> With[ { image = apply[ map, vertex ] },
        KeyExistsQ[ positions, image ] && Lookup[ projection2, Key[ image ] ] === apply[ baseMap, Lookup[ projection1, Key[ vertex ] ] ] ] ] &&
      AllTrue[ EdgeList[ total1 ], edge |-> With[ { images = apply[ map, # ] & /@ List @@ edge },
        First[ images ] === Last[ images ] || EdgeQ[ indexed, UndirectedEdge @@ Lookup[ positions, Key /@ images ] ] ] ] ]
