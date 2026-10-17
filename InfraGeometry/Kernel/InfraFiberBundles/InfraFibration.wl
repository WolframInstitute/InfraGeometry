Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: InfraFiberBundles :: InfraFibration *)

InfraTotalGraph[ InfraFibration[ total_Graph, _ ] ] /;
    SimpleGraphQ[ total ] && UndirectedGraphQ[ total ] && ! WeightedGraphQ[ total ] :=
  total

InfraFibrationAssociation[ fib : InfraFibration[ total_Graph, projection_ ] ] /;
    GraphQ[ InfraTotalGraph[ fib ] ] && ( ! AssociationQ[ projection ] ||
      Length[ projection ] == VertexCount[ total ] && AllTrue[ VertexList[ total ], KeyExistsQ[ projection, # ] & ] ) :=
  AssociationMap[
    vertex |-> If[ AssociationQ[ projection ], Lookup[ projection, Key[ vertex ] ], projection[ vertex ] ],
    VertexList[ total ] ]

InfraBaseGraph[ fib : _[ _Graph, __ ] ] /;
    AssociationQ[ InfraFibrationAssociation[ fib ] ] && GraphQ[ InfraTotalGraph[ fib ] ] :=
  With[ { projection = InfraFibrationAssociation[ fib ], total = InfraTotalGraph[ fib ] },
    Graph[ DeleteDuplicates[ Values[ projection ] ],
      DeleteDuplicates @ Select[
        UndirectedEdge @@ Sort[ Lookup[ projection, Key /@ List @@ # ] ] & /@ EdgeList[ total ],
        First[ # ] =!= Last[ # ] & ] ] ]

InfraFiber[ fib : _[ _Graph, __ ], point_ ] /;
    AssociationQ[ InfraFibrationAssociation[ fib ] ] && GraphQ[ InfraTotalGraph[ fib ] ] :=
  Subgraph[ InfraTotalGraph[ fib ], Keys @ Select[ InfraFibrationAssociation[ fib ], # === point & ] ]

InfraFibers[ fib : _[ _Graph, __ ] ] /;
    AssociationQ[ InfraFibrationAssociation[ fib ] ] && GraphQ[ InfraTotalGraph[ fib ] ] :=
  With[ { projection = InfraFibrationAssociation[ fib ], total = InfraTotalGraph[ fib ] },
    Subgraph[ total, # ] & /@ GroupBy[ VertexList[ total ], Lookup[ projection, Key[ # ] ] & ] ]

InfraFibrationQ[ fibs : { __ } ] :=
  And @@ ( InfraFibrationQ /@ fibs )

InfraFibrationQ[ { } ] :=
  False

InfraFibrationQ[ fib : _[ _Graph, __ ] ] /;
    AssociationQ[ InfraFibrationAssociation[ fib ] ] && GraphQ[ InfraBaseGraph[ fib ] ] :=
  With[ { projection = InfraFibrationAssociation[ fib ], total = InfraTotalGraph[ fib ], base = InfraBaseGraph[ fib ] },
    AllTrue[ VertexList[ total ], vertex |->
      SubsetQ[ Lookup[ projection, Key /@ AdjacencyList[ total, vertex ] ],
        AdjacencyList[ base, Lookup[ projection, Key[ vertex ] ] ] ] ] ]

InfraFiberBundleQ[ fibs : { __ } ] :=
  And @@ ( InfraFiberBundleQ /@ fibs )

InfraFiberBundleQ[ { } ] :=
  False

InfraFiberBundleQ[ fib : _[ _Graph, __ ] ] /;
    AssociationQ[ InfraFibrationAssociation[ fib ] ] && GraphQ[ InfraBaseGraph[ fib ] ] :=
  With[ { projection = InfraFibrationAssociation[ fib ], total = InfraTotalGraph[ fib ],
      base = InfraBaseGraph[ fib ], fibers = InfraFibers[ fib ] },
    ( Length[ fibers ] < 2 || AllTrue[ Rest @ Values[ fibers ], IsomorphicGraphQ[ First @ Values[ fibers ], # ] & ] ) &&
      AllTrue[ VertexList[ total ], vertex |->
        Sort @ Select[ Lookup[ projection, Key /@ AdjacencyList[ total, vertex ] ], # =!= Lookup[ projection, Key[ vertex ] ] & ] ===
          Sort @ AdjacencyList[ base, Lookup[ projection, Key[ vertex ] ] ] ] &&
      AllTrue[ EdgeList[ base ], edge |->
        With[ { source = Lookup[ fibers, Key[ First[ edge ] ] ], target = Lookup[ fibers, Key[ Last[ edge ] ] ] },
          { transport = AssociationMap[
              vertex |-> First @ Select[ AdjacencyList[ total, vertex ],
                Lookup[ projection, Key[ # ] ] === Last[ edge ] & ], VertexList[ source ] ] },
          Sort[ UndirectedEdge @@ Sort[ Lookup[ transport, Key /@ List @@ # ] ] & /@ EdgeList[ source ] ] ===
            Sort[ UndirectedEdge @@ Sort[ List @@ # ] & /@ EdgeList[ target ] ] ] ] ]

Options[ RandomInfraFibration ] = {
  "VerticalVertices" -> 1,
  "VerticalEdges" -> 0,
  "HorizontalEdgesRadius" -> 1,
  "HorizontalEdgesDensity" -> 1,
  "IsomorphicFibers" -> False
}

RandomInfraFibration[ base_Graph, opts : OptionsPattern[] ] /;
    SubsetQ[ First /@ Options[ RandomInfraFibration ], First /@ Flatten @ { opts } ] &&
    With[ { vertices = OptionValue[ RandomInfraFibration, { opts }, "VerticalVertices" ],
        edges = OptionValue[ RandomInfraFibration, { opts }, "VerticalEdges" ],
        density = OptionValue[ RandomInfraFibration, { opts }, "HorizontalEdgesDensity" ] },
      SimpleGraphQ[ base ] && UndirectedGraphQ[ base ] && ! WeightedGraphQ[ base ] &&
        OptionValue[ RandomInfraFibration, { opts }, "HorizontalEdgesRadius" ] === 1 &&
        MemberQ[ { True, False }, OptionValue[ RandomInfraFibration, { opts }, "IsomorphicFibers" ] ] &&
        ( MatchQ[ vertices, _Integer?Positive ] || MatchQ[ vertices, { lo_Integer?Positive, hi_Integer?Positive } /; lo <= hi ] ) &&
        ( MatchQ[ edges, _Integer?NonNegative ] || MatchQ[ edges, { lo_Integer?NonNegative, hi_Integer?NonNegative } /; lo <= hi ] ) &&
        ( density === All || NumericQ[ density ] && TrueQ[ density > 0 ] ||
          MatchQ[ density, { lo_?NumericQ, hi_?NumericQ } /; 0 < lo <= hi ] ) ] :=
  With[ { drawCount = spec |-> If[ IntegerQ[ spec ], spec, RandomInteger[ spec ] ],
      isomorphic = OptionValue[ RandomInfraFibration, { opts }, "IsomorphicFibers" ] },
    { sizes = If[ isomorphic && VertexCount[ base ] > 0,
        ConstantArray[ drawCount @ OptionValue[ RandomInfraFibration, { opts }, "VerticalVertices" ], VertexCount[ base ] ],
        Table[ drawCount @ OptionValue[ RandomInfraFibration, { opts }, "VerticalVertices" ], VertexCount[ base ] ] ] },
    { fibers = AssociationThread[ VertexList[ base ], MapThread[
        { point, count } |-> Table[ { point, index }, { index, count } ], { VertexList[ base ], sizes } ] ] },
    { template = count |-> With[
        { edgeCount = Min[ drawCount @ OptionValue[ RandomInfraFibration, { opts }, "VerticalEdges" ], count ( count - 1 ) / 2 ] },
        If[ edgeCount == 0, { }, EdgeList @ RandomGraph[ { count, edgeCount } ] ] ] },
    { shared = If[ isomorphic && sizes =!= { }, template[ First[ sizes ] ], { } ] },
    { vertical = Catenate @ Map[
        fiber |-> ( UndirectedEdge @@ fiber[[ List @@ # ]] & /@
          If[ isomorphic, shared, template[ Length[ fiber ] ] ] ), Values[ fibers ] ] },
    { horizontal = Catenate @ Map[
        edge |-> With[ { source = Lookup[ fibers, Key[ First[ edge ] ] ], target = Lookup[ fibers, Key[ Last[ edge ] ] ],
            density = Replace[ OptionValue[ RandomInfraFibration, { opts }, "HorizontalEdgesDensity" ], range_List :> RandomReal[ range ] ] },
          { pairs = Tuples[ { Range[ Length[ source ] ], Range[ Length[ target ] ] } ] },
          UndirectedEdge[ source[[ First[ # ] ]], target[[ Last[ # ] ]] ] & /@
            If[ density === All, pairs, Select[ pairs,
              With[ { residue = Mod[ First[ # ] Length[ target ] - Last[ # ] Length[ source ],
                  Length[ source ] Length[ target ] ] },
                residue < density Max[ Length[ source ], Length[ target ] ] ] & ] ] ], EdgeList[ base ] ] },
    { vertices = Catenate[ Values[ fibers ] ] },
    InfraFibration[ Graph[ vertices, Join[ vertical, horizontal ] ], AssociationMap[ First, vertices ] ] ]

InfraBundleMorphismQ[ fib1 : _[ _Graph, __ ], fib2 : _[ _Graph, __ ], map_, baseMap_ : Identity ] /;
    AssociationQ[ InfraFibrationAssociation[ fib1 ] ] && AssociationQ[ InfraFibrationAssociation[ fib2 ] ] :=
  With[ { total1 = InfraTotalGraph[ fib1 ], total2 = InfraTotalGraph[ fib2 ],
      projection1 = InfraFibrationAssociation[ fib1 ], projection2 = InfraFibrationAssociation[ fib2 ],
      apply = { function, vertex } |-> If[ AssociationQ[ function ], Lookup[ function, Key[ vertex ] ], function[ vertex ] ] },
    ( ! AssociationQ[ map ] || AllTrue[ VertexList[ total1 ], KeyExistsQ[ map, # ] & ] ) &&
      ( ! AssociationQ[ baseMap ] || AllTrue[ Values[ projection1 ], KeyExistsQ[ baseMap, # ] & ] ) &&
      AllTrue[ VertexList[ total1 ], vertex |->
        With[ { image = apply[ map, vertex ] },
          VertexQ[ total2, image ] && Lookup[ projection2, Key[ image ] ] === apply[ baseMap, Lookup[ projection1, Key[ vertex ] ] ] ] ] &&
      AllTrue[ EdgeList[ total1 ], edge |->
        With[ { images = apply[ map, # ] & /@ List @@ edge },
          First[ images ] === Last[ images ] || EdgeQ[ total2, UndirectedEdge @@ images ] ] ] ]
