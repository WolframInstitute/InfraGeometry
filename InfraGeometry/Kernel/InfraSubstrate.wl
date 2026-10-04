Package[ "WolframInstitute`InfraGeometry`" ]

Options[ InfraSubstrate ] = { "KeepCoordinates" -> False, "Inflate" -> None }

InfraSubstrate[ ] :=
  <|
    "OpenManifold" -> {
      "SquareMeshGraph", "CubeMeshGraph",
      "TriangularTilingGraph", "SquareTilingGraph", "HexagonalTilingGraph", "HyperbolicTilingGraph",
      "SquareGridGraph", "CubicGridGraph" },
    "ClosedManifold" -> {
      "SphereMeshGraph",
      "SquareTorusGraph", "TriangularTorusGraph", "HexagonalTorusGraph",
      "UniformLengthSphereGraph", "UniformLengthProlateEllipsoidGraph", "UniformLengthTriaxialEllipsoidGraph", "BuckyballGraph" },
    "Fractal" -> { "SierpinskiTriangleGraph", "MengerCarpetGraph", "MengerSpongeGraph" },
    "Exotic" -> { "BinaryTreeGraph", "DilutedTreeGraph", "CompleteGraph" },
    "WolframModel" -> { "wm6655", "wm8619", "wm1811" }
  |>

InfraSubstrate[ All ] :=
  Catenate @ Values @ InfraSubstrate[ ]

InfraSubstrate[ name_String /; MemberQ[ InfraSubstrate[ All ], name ] || StringMatchQ[ name, "wm" ~~ DigitCharacter .. ] ] :=
  InfraSubstrate[ name, "Medium" ]

InfraSubstrate[ name_String /; MemberQ[ InfraSubstrate[ All ], name ] || StringMatchQ[ name, "wm" ~~ DigitCharacter .. ], size_, style : ( _String | Automatic ) : Automatic,
    opts : OptionsPattern[ { InfraSubstrate, Graph } ] ] :=
  With[
    { own = FilterRules[ { opts }, Options @ InfraSubstrate ] },
    { raw = Switch[ name,
        "SquareMeshGraph", With[
          { mesh = BoundarylessGraph @ DiscretizeRegion[ Rectangle[ ],
              MaxCellMeasure -> ( size /. { "Small" -> 0.0085, "Medium" -> 0.0028, "Large" -> 0.00082 } ), PrecisionGoal -> Infinity ] },
          VertexDelete[ mesh, Pick[ VertexList @ mesh, VertexDegree @ mesh, 1 ] ] ],
        "CubeMeshGraph", With[
          { mesh = BoundarylessGraph @ DiscretizeRegion[ Cuboid[ ],
              MaxCellMeasure -> ( size /. { "Small" -> 0.004, "Medium" -> 0.00133, "Large" -> 0.0004 } ), PrecisionGoal -> Infinity ] },
          VertexDelete[ mesh, Pick[ VertexList @ mesh, VertexDegree @ mesh, 1 ] ] ],
        "SphereMeshGraph", With[
          { mesh = DiscretizeRegion[ Sphere[ ],
              MaxCellMeasure -> { "Area" -> ( size /. { "Small" -> 0.5, "Medium" -> 0.1, "Large" -> 0.02 } ) }, PrecisionGoal -> 1 ] },
          Graph[ IndexGraph @ MeshConnectivityGraph @ mesh,
            VertexCoordinates -> Normalize /@ MeshCoordinates @ mesh ] ],
        "TriangularTilingGraph", BoundarylessGraph[
          TessellationNeighborhoodGraph[ { 3, 6 }, size /. { "Small" -> 5, "Medium" -> 9, "Large" -> 16 } ], Method -> "MaxDegree" ],
        "SquareTilingGraph", BoundarylessGraph[
          TessellationNeighborhoodGraph[ { 4, 4 }, size /. { "Small" -> 7, "Medium" -> 12, "Large" -> 22 } ], Method -> "MaxDegree" ],
        "HexagonalTilingGraph", BoundarylessGraph[
          TessellationNeighborhoodGraph[ { 6, 3 }, size /. { "Small" -> 8, "Medium" -> 14, "Large" -> 25 } ], Method -> "MaxDegree" ],
        "HyperbolicTilingGraph", BoundarylessGraph[
          TessellationNeighborhoodGraph[ { 3, 7 }, size /. { "Small" -> 3, "Medium" -> 4, "Large" -> 5 } ], Method -> "MaxDegree" ],
        "SquareGridGraph", BoundarylessGraph[
          GridGraph[ size /. { "Small" -> { 10, 10 }, "Medium" -> { 17, 17 }, "Large" -> { 32, 32 } } ], Method -> "MaxDegree" ],
        "CubicGridGraph", With[
          { dims = size /. { "Small" -> { 5, 5, 5 }, "Medium" -> { 7, 7, 7 }, "Large" -> { 10, 10, 10 } } },
          BoundarylessGraph[
            Graph[ GridGraph @ dims, VertexCoordinates -> Reverse /@ Tuples[ Range /@ Reverse @ dims ] ],
            Method -> "MaxDegree" ] ],
        "SquareTorusGraph" | "TriangularTorusGraph" | "HexagonalTorusGraph", With[
          { dims = size /. If[ name === "HexagonalTorusGraph",
              { "Small" -> { 7, 7 }, "Medium" -> { 15, 10 }, "Large" -> { 25, 20 } },
              { "Small" -> { 10, 10 }, "Medium" -> { 20, 15 }, "Large" -> { 40, 25 } } ] },
          { m = First @ dims, n = Last @ dims, torus = TorusTessellation[ dims, StringDelete[ name, "TorusGraph" ] ] },
          Graph[ torus, VertexCoordinates -> Map[
            v |-> With[ { s = If[ Length @ v >= 3, v[[ 3 ]], 0 ] },
              { u = 2 Pi ( v[[ 1 ]] + s / 2 ) / m, w = 2 Pi ( v[[ 2 ]] + s / 2 ) / n },
              { ( 1 + 0.4 Cos[ w ] ) Cos[ u ], ( 1 + 0.4 Cos[ w ] ) Sin[ u ], 0.4 Sin[ w ] } ],
            VertexList @ torus ] ] ],
        "UniformLengthSphereGraph", UniformLengthGraph[ BoundaryDiscretizeRegion @ Ellipsoid[ { 0, 0, 0 }, { 1, 1, 1 } ],
          size /. { "Small" -> 100, "Medium" -> 300, "Large" -> 1000 }, "KeepCoordinates" -> True ],
        "UniformLengthProlateEllipsoidGraph", UniformLengthGraph[ BoundaryDiscretizeRegion @ Ellipsoid[ { 0, 0, 0 }, { 5, 1, 1 } ],
          size /. { "Small" -> 100, "Medium" -> 300, "Large" -> 1000 }, "KeepCoordinates" -> True ],
        "UniformLengthTriaxialEllipsoidGraph", UniformLengthGraph[ BoundaryDiscretizeRegion @ Ellipsoid[ { 0, 0, 0 }, { 4, 2, 1 } ],
          size /. { "Small" -> 100, "Medium" -> 300, "Large" -> 1000 }, "KeepCoordinates" -> True ],
        "BuckyballGraph", With[
          { ball = ResourceFunction[ "BuckyballGraph" ][ size /. { "Small" -> 1, "Medium" -> 2, "Large" -> 4 } ] },
          Graph[ ball, VertexCoordinates -> GraphEmbedding @ ball ] ],
        "SierpinskiTriangleGraph", IndexGraph @ MeshConnectivityGraph @ SierpinskiMesh[ size /. { "Small" -> 4, "Medium" -> 5, "Large" -> 6 } ],
        "MengerCarpetGraph", IndexGraph @ MeshConnectivityGraph @ MengerMesh[ size /. { "Small" -> 2, "Medium" -> 3, "Large" -> 4 } ],
        "MengerSpongeGraph", IndexGraph @ MeshConnectivityGraph @ MengerMesh[ size /. { "Small" -> 1, "Medium" -> 2, "Large" -> 3 }, 3 ],
        "BinaryTreeGraph", KaryTree[ size /. { "Small" -> 63, "Medium" -> 255, "Large" -> 1023 } ],
        "CompleteGraph", CompleteGraph[ size /. { "Small" -> 10, "Medium" -> 30, "Large" -> 90 } ],
        (* the branching sequence doubles on the levels whose index is a perfect power 1/exponent, so
           the tree grows subexponentially: its ball of radius r carries about r^(1/exponent) branchings *)
        "DilutedTreeGraph", With[
          { spec = size /. { "Small" -> { 1/2, 16 }, "Medium" -> { 1/2, 26 }, "Large" -> { 1/2, 42 } } },
          { exponent = First @ spec, depth = Last @ spec },
          BranchingSequenceTree @ Table[
            If[ MemberQ[ Ceiling[ Range[ depth ]^( 1 / exponent ) ], level ], 2, 1 ], { level, depth } ] ],
        _?( StringMatchQ[ #, "wm" ~~ DigitCharacter .. ] & ), With[
          { model = Replace[ <|
              "wm6655" -> {
                { { 1, 2 }, { 1, 3 } } -> { { 1, 2 }, { 1, 4 }, { 2, 4 }, { 3, 4 } }, { { 1, 1 }, { 1, 1 } },
                { "Small" -> 7, "Medium" -> 9, "Large" -> 11 } },
              "wm8619" -> {
                { { 1, 2, 2 }, { 1, 3, 4 } } -> { { 4, 5, 5 }, { 5, 3, 2 }, { 1, 2, 5 } }, { { 1, 1, 1 }, { 1, 1, 1 } },
                { "Small" -> 100, "Medium" -> 300, "Large" -> 1000 } },
              "wm1811" -> {
                { { 1, 1, 2 }, { 1, 3, 4 } } -> { { 4, 4, 3 }, { 2, 5, 3 }, { 2, 5, 3 } }, { { 1, 1, 1 }, { 1, 1, 1 } },
                { "Small" -> 100, "Medium" -> 300, "Large" -> 1000 } } |>[ name ], _Missing :>
              { First @ Flatten[ { ResourceFunction[ "WolframModelData" ][ name, "Rule" ] }, 2 ],
                ResourceFunction[ "WolframModelData" ][ name, "InitialCondition" ],
                { "Small" -> 6, "Medium" -> 8, "Large" -> 10 } } ] },
          { state = ResourceFunction[ "WolframModel" ][ model[[ 1 ]], model[[ 2 ]], size /. model[[ 3 ]], "FinalState" ] },
          If[ AllTrue[ state, Length @ # === 2 & ],
            Graph @ DeleteDuplicates[ UndirectedEdge @@@ Sort /@ Select[ state, Apply @ UnsameQ ] ],
            UndirectedGraph @ ResourceFunction[ "HypergraphToGraph" ][ state ] ] ] ] },
    { g = Replace[ OptionValue[ InfraSubstrate, own, "Inflate" ], {
        None -> raw,
        inflate_ :> InflateGraph[ raw, Sequence @@ Replace[ inflate, amount : Except[ { ___Rule } ] :> { "ExtraVertices" -> amount } ] ] } ],
      keep = TrueQ @ OptionValue[ InfraSubstrate, own, "KeepCoordinates" ] },
    Graph[ g, FilterRules[ { opts }, Options @ Graph ],
      Sequence @@ Which[
        Options[ g, VertexCoordinates ] === { VertexCoordinates -> Automatic }, { },
        keep, { VertexCoordinates -> GraphEmbedding @ g },
        True, { VertexCoordinates -> Automatic,
          GraphLayout -> { "VertexLayout" -> "SpringElectricalEmbedding",
            "Dimension" -> Last @ Dimensions @ GraphEmbedding @ g } } ],
      Sequence @@ InfraSubstrateStyle[ name, Replace[ style, Automatic :> Replace[ size, Except[ "Small" | "Medium" | "Large" ] :>
        Which[ VertexCount @ g <= 250, "Small", VertexCount @ g <= 800, "Medium", True, "Large" ] ] ] ] ] ]

Options[ InfraSubstrateCode ] = Options[ InfraSubstrate ]

InfraSubstrateCode[ name_String /; MemberQ[ InfraSubstrate[ All ], name ] || StringMatchQ[ name, "wm" ~~ DigitCharacter .. ] ] :=
  InfraSubstrateCode[ name, "Medium" ]

InfraSubstrateCode[ name_String /; MemberQ[ InfraSubstrate[ All ], name ] || StringMatchQ[ name, "wm" ~~ DigitCharacter .. ], size_, opts : OptionsPattern[ { InfraSubstrate, Graph } ] ] :=
  With[
    { own = FilterRules[ { opts }, Options @ InfraSubstrate ] },
    { raw = Switch[ name,
        "SquareMeshGraph", With[ { measure = size /. { "Small" -> 0.0085, "Medium" -> 0.0028, "Large" -> 0.00082 } },
          HoldComplete @ With[
            { mesh = BoundarylessGraph @ DiscretizeRegion[ Rectangle[ ], MaxCellMeasure -> measure, PrecisionGoal -> Infinity ] },
            VertexDelete[ mesh, Pick[ VertexList @ mesh, VertexDegree @ mesh, 1 ] ] ] ],
        "CubeMeshGraph", With[ { measure = size /. { "Small" -> 0.004, "Medium" -> 0.00133, "Large" -> 0.0004 } },
          HoldComplete @ With[
            { mesh = BoundarylessGraph @ DiscretizeRegion[ Cuboid[ ], MaxCellMeasure -> measure, PrecisionGoal -> Infinity ] },
            VertexDelete[ mesh, Pick[ VertexList @ mesh, VertexDegree @ mesh, 1 ] ] ] ],
        "SphereMeshGraph", With[ { area = size /. { "Small" -> 0.5, "Medium" -> 0.1, "Large" -> 0.02 } },
          HoldComplete @ With[
            { mesh = DiscretizeRegion[ Sphere[ ], MaxCellMeasure -> { "Area" -> area }, PrecisionGoal -> 1 ] },
            Graph[ IndexGraph @ MeshConnectivityGraph @ mesh,
              VertexCoordinates -> Normalize /@ MeshCoordinates @ mesh ] ] ],
        "TriangularTilingGraph", With[ { radius = size /. { "Small" -> 5, "Medium" -> 9, "Large" -> 16 } },
          HoldComplete @ BoundarylessGraph[ TessellationNeighborhoodGraph[ { 3, 6 }, radius ], Method -> "MaxDegree" ] ],
        "SquareTilingGraph", With[ { radius = size /. { "Small" -> 7, "Medium" -> 12, "Large" -> 22 } },
          HoldComplete @ BoundarylessGraph[ TessellationNeighborhoodGraph[ { 4, 4 }, radius ], Method -> "MaxDegree" ] ],
        "HexagonalTilingGraph", With[ { radius = size /. { "Small" -> 8, "Medium" -> 14, "Large" -> 25 } },
          HoldComplete @ BoundarylessGraph[ TessellationNeighborhoodGraph[ { 6, 3 }, radius ], Method -> "MaxDegree" ] ],
        "HyperbolicTilingGraph", With[ { radius = size /. { "Small" -> 3, "Medium" -> 4, "Large" -> 5 } },
          HoldComplete @ BoundarylessGraph[ TessellationNeighborhoodGraph[ { 3, 7 }, radius ], Method -> "MaxDegree" ] ],
        "SquareGridGraph", With[ { dims = size /. { "Small" -> { 10, 10 }, "Medium" -> { 17, 17 }, "Large" -> { 32, 32 } } },
          HoldComplete @ BoundarylessGraph[ GridGraph @ dims, Method -> "MaxDegree" ] ],
        "CubicGridGraph", With[ { dims = size /. { "Small" -> { 5, 5, 5 }, "Medium" -> { 7, 7, 7 }, "Large" -> { 10, 10, 10 } } },
          HoldComplete @ BoundarylessGraph[
            Graph[ GridGraph @ dims, VertexCoordinates -> Reverse /@ Tuples[ Range /@ Reverse @ dims ] ],
            Method -> "MaxDegree" ] ],
        "SquareTorusGraph" | "TriangularTorusGraph" | "HexagonalTorusGraph", With[
          { shape = StringDelete[ name, "TorusGraph" ],
            dims = size /. If[ name === "HexagonalTorusGraph",
              { "Small" -> { 7, 7 }, "Medium" -> { 15, 10 }, "Large" -> { 25, 20 } },
              { "Small" -> { 10, 10 }, "Medium" -> { 20, 15 }, "Large" -> { 40, 25 } } ] },
          { m = First @ dims, n = Last @ dims },
          HoldComplete @ With[
            { torus = TorusTessellation[ dims, shape ] },
            Graph[ torus, VertexCoordinates -> Map[
              v |-> With[ { s = If[ Length @ v >= 3, v[[ 3 ]], 0 ] },
                { u = 2 Pi ( v[[ 1 ]] + s / 2 ) / m, w = 2 Pi ( v[[ 2 ]] + s / 2 ) / n },
                { ( 1 + 0.4 Cos[ w ] ) Cos[ u ], ( 1 + 0.4 Cos[ w ] ) Sin[ u ], 0.4 Sin[ w ] } ],
              VertexList @ torus ] ] ] ],
        "UniformLengthSphereGraph", With[ { count = size /. { "Small" -> 100, "Medium" -> 300, "Large" -> 1000 } },
          HoldComplete @ UniformLengthGraph[ BoundaryDiscretizeRegion @ Ellipsoid[ { 0, 0, 0 }, { 1, 1, 1 } ],
            count, "KeepCoordinates" -> True ] ],
        "UniformLengthProlateEllipsoidGraph", With[ { count = size /. { "Small" -> 100, "Medium" -> 300, "Large" -> 1000 } },
          HoldComplete @ UniformLengthGraph[ BoundaryDiscretizeRegion @ Ellipsoid[ { 0, 0, 0 }, { 5, 1, 1 } ],
            count, "KeepCoordinates" -> True ] ],
        "UniformLengthTriaxialEllipsoidGraph", With[ { count = size /. { "Small" -> 100, "Medium" -> 300, "Large" -> 1000 } },
          HoldComplete @ UniformLengthGraph[ BoundaryDiscretizeRegion @ Ellipsoid[ { 0, 0, 0 }, { 4, 2, 1 } ],
            count, "KeepCoordinates" -> True ] ],
        "BuckyballGraph", With[ { steps = size /. { "Small" -> 1, "Medium" -> 2, "Large" -> 4 } },
          HoldComplete @ With[
            { ball = ResourceFunction[ "BuckyballGraph" ][ steps ] },
            Graph[ ball, VertexCoordinates -> GraphEmbedding @ ball ] ] ],
        "SierpinskiTriangleGraph", With[ { steps = size /. { "Small" -> 4, "Medium" -> 5, "Large" -> 6 } },
          HoldComplete @ IndexGraph @ MeshConnectivityGraph @ SierpinskiMesh @ steps ],
        "MengerCarpetGraph", With[ { steps = size /. { "Small" -> 2, "Medium" -> 3, "Large" -> 4 } },
          HoldComplete @ IndexGraph @ MeshConnectivityGraph @ MengerMesh @ steps ],
        "MengerSpongeGraph", With[ { steps = size /. { "Small" -> 1, "Medium" -> 2, "Large" -> 3 } },
          HoldComplete @ IndexGraph @ MeshConnectivityGraph @ MengerMesh[ steps, 3 ] ],
        "BinaryTreeGraph", With[ { count = size /. { "Small" -> 63, "Medium" -> 255, "Large" -> 1023 } },
          HoldComplete @ KaryTree @ count ],
        "CompleteGraph", With[ { count = size /. { "Small" -> 10, "Medium" -> 30, "Large" -> 90 } },
          HoldComplete @ CompleteGraph @ count ],
        "DilutedTreeGraph", With[ { spec = size /. { "Small" -> { 1/2, 16 }, "Medium" -> { 1/2, 26 }, "Large" -> { 1/2, 42 } } },
          { exponent = First @ spec, depth = Last @ spec },
          HoldComplete @ BranchingSequenceTree @ Table[
            If[ MemberQ[ Ceiling[ Range[ depth ]^( 1 / exponent ) ], level ], 2, 1 ], { level, depth } ] ],
        _?( StringMatchQ[ #, "wm" ~~ DigitCharacter .. ] & ), With[
          { model = Replace[ <|
              "wm6655" -> {
                { { 1, 2 }, { 1, 3 } } -> { { 1, 2 }, { 1, 4 }, { 2, 4 }, { 3, 4 } }, { { 1, 1 }, { 1, 1 } },
                { "Small" -> 7, "Medium" -> 9, "Large" -> 11 } },
              "wm8619" -> {
                { { 1, 2, 2 }, { 1, 3, 4 } } -> { { 4, 5, 5 }, { 5, 3, 2 }, { 1, 2, 5 } }, { { 1, 1, 1 }, { 1, 1, 1 } },
                { "Small" -> 100, "Medium" -> 300, "Large" -> 1000 } },
              "wm1811" -> {
                { { 1, 1, 2 }, { 1, 3, 4 } } -> { { 4, 4, 3 }, { 2, 5, 3 }, { 2, 5, 3 } }, { { 1, 1, 1 }, { 1, 1, 1 } },
                { "Small" -> 100, "Medium" -> 300, "Large" -> 1000 } } |>[ name ], _Missing :>
              { First @ Flatten[ { ResourceFunction[ "WolframModelData" ][ name, "Rule" ] }, 2 ],
                ResourceFunction[ "WolframModelData" ][ name, "InitialCondition" ],
                { "Small" -> 6, "Medium" -> 8, "Large" -> 10 } } ] },
          { rule = model[[ 1 ]], init = model[[ 2 ]], steps = size /. model[[ 3 ]] },
          HoldComplete @ With[
            { state = ResourceFunction[ "WolframModel" ][ rule, init, steps, "FinalState" ] },
            If[ AllTrue[ state, Length @ # === 2 & ],
              Graph @ DeleteDuplicates[ UndirectedEdge @@@ Sort /@ Select[ state, Apply @ UnsameQ ] ],
              UndirectedGraph @ ResourceFunction[ "HypergraphToGraph" ][ state ] ] ] ] ] },
    { code = Replace[ OptionValue[ InfraSubstrate, own, "Inflate" ], {
        None -> raw,
        inflate_ :> ( Join[ HoldComplete @ InflateGraph, raw,
          HoldComplete @@ Replace[ inflate, amount : Except[ { ___Rule } ] :> { "ExtraVertices" -> amount } ] ] /.
          HoldComplete[ head_, rest__ ] :> HoldComplete @ head[ rest ] ) } ] },
    { g = ReleaseHold @ code },
    { arguments = DeleteCases[
        Join[ FilterRules[ { opts }, Options @ Graph ],
          Which[
            Options[ g, VertexCoordinates ] === { VertexCoordinates -> Automatic }, { },
            TrueQ @ OptionValue[ InfraSubstrate, own, "KeepCoordinates" ], { VertexCoordinates -> GraphEmbedding @ g },
            True, { VertexCoordinates -> Automatic,
              GraphLayout -> { "VertexLayout" -> "SpringElectricalEmbedding",
                "Dimension" -> Last @ Dimensions @ GraphEmbedding @ g } } ] ],
        VertexCoordinates -> _List ] },
    { public = code /. Map[
        s |-> s -> ToExpression[ StringDelete[ SymbolName @ Unevaluated @ s, "$" ~~ EndOfString ], InputForm, Hold ],
        Cases[ code, s_Symbol /; StringEndsQ[ Context @ Unevaluated @ s, "`PackagePrivate`" ], Infinity, Heads -> True ] ] /.
        Hold[ x_ ] :> x },
    Replace[ Join[ public, HoldComplete @@ arguments ], {
      HoldComplete[ body_ ] :> HoldForm @ body,
      HoldComplete[ body_, args__ ] :> HoldForm @ Graph[ body, args ] } ] ]

InfraSubstrateStyle[ ] :=
  <|
    "Default" -> { "Default", "Small", "Medium", "Large" },
    "Custom" -> Join[
      Cases[ DownValues[ InfraSubstrateStyle ],
        HoldPattern[ Verbatim[ HoldPattern ][ InfraSubstrateStyle[ style_String ] ] :> _ ] /;
          ! MemberQ[ { "Default", "Small", "Medium", "Large" }, style ] :> style ],
      Cases[ DownValues[ InfraSubstrateStyle ],
        HoldPattern[ Verbatim[ HoldPattern ][ InfraSubstrateStyle[ name_String, size_String ] ] :> _ ] :> { name, size } ] ]
  |>

InfraSubstrateStyle[ All ] :=
  Catenate @ Values @ InfraSubstrateStyle[ ]

InfraSubstrateStyle[ "Default" ] = { }

InfraSubstrateStyle[ "Small" ] = {
  EdgeStyle -> Directive[ StandardGray, Opacity[ 0.35 ] ],
  VertexStyle -> Directive[ StandardGray, Opacity[ 0.5 ], EdgeForm[ { GrayLevel[ 0 ], Opacity[ 0.65 ] } ] ],
  VertexSize -> { "Scaled", 0.013 } }

InfraSubstrateStyle[ "Medium" ] = {
  EdgeStyle -> Directive[ StandardGray, Opacity[ 0.3 ] ],
  VertexStyle -> Directive[ StandardGray, Opacity[ 0.45 ], EdgeForm[ { GrayLevel[ 0 ], Opacity[ 0.6 ] } ] ],
  VertexSize -> { "Scaled", 0.009 } }

InfraSubstrateStyle[ "Large" ] = {
  EdgeStyle -> Directive[ StandardGray, Opacity[ 0.22 ] ],
  VertexStyle -> Directive[ StandardGray, Opacity[ 0.33 ], EdgeForm[ { GrayLevel[ 0 ], Opacity[ 0.45 ] } ] ],
  VertexSize -> { "Scaled", 0.006 } }

InfraSubstrateStyle[ name_String, size_String ] :=
  InfraSubstrateStyle @ size
