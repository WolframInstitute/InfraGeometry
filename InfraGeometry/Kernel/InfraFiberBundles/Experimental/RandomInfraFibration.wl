Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: InfraFiberBundles/Experimental :: RandomInfraFibration *)

Options[ RandomInfraFibration ] = {
  "VerticalVertices" -> 1,
  "VerticalEdges" -> 0,
  "HorizontalEdgesRadius" -> 1,
  "HorizontalEdgesDensity" -> 1,
  "IsomorphicFibers" -> False,
  RandomSeeding            -> Automatic
}

RandomInfraFibration[ args___ ] /; FreeQ[ { args }, RandomSeeding -> None, { 1 } ] :=
  With[ { result = BlockRandom[
      RandomInfraFibration[ Sequence @@ DeleteCases[ { args }, RandomSeeding -> _ ], RandomSeeding -> None ],
      RandomSeeding -> FirstCase[ { args }, ( RandomSeeding -> seed_ ) :> seed, Automatic ] ] },
    result /; ! MatchQ[ result, HoldPattern[ RandomInfraFibration[ ___, RandomSeeding -> None ] ] ] ]

RandomInfraFibration[ base_Graph, opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( SubsetQ[ First /@ Options[ RandomInfraFibration ], First /@ Flatten @ { opts } ] &&
    With[ { vertices = OptionValue[ RandomInfraFibration, { opts }, "VerticalVertices" ],
        edges = OptionValue[ RandomInfraFibration, { opts }, "VerticalEdges" ],
        density = OptionValue[ RandomInfraFibration, { opts }, "HorizontalEdgesDensity" ] },
      SimpleGraphQ[ base ] && UndirectedGraphQ[ base ] && ! WeightedGraphQ[ base ] &&
        OptionValue[ RandomInfraFibration, { opts }, "HorizontalEdgesRadius" ] === 1 &&
        MemberQ[ { True, False }, OptionValue[ RandomInfraFibration, { opts }, "IsomorphicFibers" ] ] &&
        ( MatchQ[ vertices, _Integer?Positive ] || MatchQ[ vertices, { lo_Integer?Positive, hi_Integer?Positive } /; lo <= hi ] ) &&
        ( MatchQ[ edges, _Integer?NonNegative ] || MatchQ[ edges, { lo_Integer?NonNegative, hi_Integer?NonNegative } /; lo <= hi ] ) &&
        ( density === All || NumericQ[ density ] && TrueQ[ density > 0 ] ||
          MatchQ[ density, { lo_?NumericQ, hi_?NumericQ } /; 0 < lo <= hi ] ) ] ) :=
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
