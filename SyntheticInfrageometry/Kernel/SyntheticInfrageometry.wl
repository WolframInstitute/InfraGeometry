Package["WolframInstitute`SyntheticInfrageometry`"]

(* ---- synthetic: objects and their properties --------------------------- *)
(* The observer constructs. Which Euclidean statement survives on a graph? *)

(* InfraPoint.wl -- InfraPoint is a scene-language token only, never a payload wrapper *)
PackageExport[InfraPoint]
PackageExport[FindInfraPoint]
PackageExport[FindInfraMidpoint]
PackageExport[FindInfraGoldenSection]
PackageExport[FindInfraReflection]
PackageExport[CompleteInfraEquilateralTriangle]
PackageExport[FindInfraCommonPoint]
PackageExport[FindClosestInfraPoint]
PackageExport[SelectInfraPoint]
PackageExport[InfraReachableQ]
PackageExport[RandomInfraPoint]
PackageExport[InfraCenter]

(* ---- EuclideanInfrageometry: Kernel/EuclideanInfrageometry/ ------------- *)
(* The Euclidean objects and the scene they are drawn in.  Each head -- InfraSegment[p1, ..., pk],
   InfraRay[p, q], InfraLine[p, q], InfraCircle[c, p], InfraArc[c, pts] -- is inert and computes
   nothing; a graph in front of it evaluates it, through InfraMeasurement and InfraVertexList *)

(* EuclideanInfrageometry/InfraMeasurement.wl *)
PackageExport[InfraMeasurement]
PackageExport[Undetermined]
PackageExport[InfraVertexList]
PackageExport[InfraMemberQ]
PackageExport[InfraSubgraph]

(* EuclideanInfrageometry/InfraSegment.wl *)
PackageExport[InfraSegment]
PackageExport[FindInfraSegment]
PackageExport[ExtendInfraSegment]
PackageExport[InfraWalkQ]
PackageExport[InfraSegmentQ]
PackageExport[UniqueInfraSegmentQ]

(* InfraWalk.wl *)
PackageExport[InfraWalk]
PackageExport[FindInfraWalk]
PackageExport[FindInfraGeodesic]
PackageExport[InfraGeodesicQ]
PackageExport[WalkSingularities]
PackageExport[InfraImmersedQ]
PackageExport[InfraGenericQ]
PackageExport[InfraWalkCrossingQ]
PackageExport[ExtendInfraWalk]
PackageExport[ExtendInfraGeodesic]
PackageExport[ConcatenateInfraWalk]

(* EuclideanInfrageometry/InfraLine.wl *)
PackageExport[InfraLine]
PackageExport[FindInfraLine]
PackageExport[FindInfraParallel]
PackageExport[FindInfraPerpendicular]
PackageExport[FindInfraCommonLine]
PackageExport[InfraLineQ]
PackageExport[InfraParallelQ]
PackageExport[InfraPerpendicularQ]
PackageExport[LineCount]
PackageExport[FindLineHull]
PackageExport[LineHullQ]
PackageExport[UniversalLineQ]

(* InfraLineStructure.wl *)
PackageExport[FindLineStructure]
PackageExport[InfraLineStructure]
PackageExport[ConsistentPathSystemQ]

(* InfraShell.wl *)
PackageExport[InfraShell]
PackageExport[FindInfraShell]
PackageExport[FindInfraOsculatingShell]
PackageExport[FindInfraShellCenter]
PackageExport[InfraShellQ]
PackageExport[SeparatesQ]

(* InfraEllipticShell.wl *)
PackageExport[InfraEllipticShell]
PackageExport[FindInfraEllipticShell]
PackageExport[InfraEllipticShellQ]

(* InfraQuadric.wl *)
PackageExport[FindInfraQuadric]

(* InfraBall.wl *)
PackageExport[InfraBall]
PackageExport[FindInfraBall]
PackageExport[InfraBallQ]
PackageExport[FindBallHull]
PackageExport[BallHullQ]

(* EuclideanInfrageometry/InfraCircle.wl *)
PackageExport[InfraCircle]
PackageExport[FindInfraCircle]
PackageExport[FindInfraCycle]
PackageExport[InfraCircleQ]

(* EuclideanInfrageometry/InfraArc.wl *)
PackageExport[InfraArc]
PackageExport[FindInfraArc]

(* InfraPolygon.wl *)
PackageExport[InfraPolygon]
PackageExport[FindInfraPolygon]
PackageExport[FindInfraRegularPolygon]
PackageExport[InfraPolygonQ]
PackageExport[InfraRegularPolygonQ]

(* InfraTriangle.wl *)
PackageExport[InfraTriangle]
PackageExport[FindInfraTriangle]
PackageExport[InfraTriangleQ]

(* InfraEllipse.wl *)
PackageExport[InfraEllipse]
PackageExport[FindInfraEllipse]
PackageExport[InfraEllipseQ]

(* InfraPlane.wl *)
PackageExport[InfraPlane]
PackageExport[FindInfraBisectingHyperplane]

(* EuclideanInfrageometry/InfraRay.wl *)
PackageExport[InfraRay]
PackageExport[FindInfraRay]
PackageExport[InfraRayQ]
PackageExport[PencilDirections]
PackageExport[PencilCardinality]

(* InfraPolyline.wl *)
PackageExport[InfraPolyline]
PackageExport[FindInfraPolylineSubdivision]
PackageExport[InfraPolylineQ]

(* InfraRevolution.wl *)
PackageExport[InfraRevolution]
PackageExport[FindInfraRevolution]
PackageExport[FindInfraCylinder]
PackageExport[FindInfraCone]
PackageExport[InfraRevolutionQ]

(* EuclideanSpace.wl *)
PackageExport[InfraScalarProduct]
PackageExport[FindInfraLinearCombination]
PackageExport[InfraAngle]

(* InfraCurveGeometry.wl *)
PackageExport[TurningAngles]
PackageExport[TotalCurvature]
PackageExport[TotalAbsoluteCurvature]
PackageExport[TurningNumber]

(* AlexandrovGeometry.wl *)
PackageExport[ComparisonTriangle]
PackageExport[InfraComparisonTriangle]
PackageExport[CATInequalityQ]
PackageExport[InfraCurvature]

(* WalkSpace.wl *)
PackageExport[SelectInfraWalk]
PackageExport[EmbeddingClosest]
PackageExport[FindEmbeddingClosestPath]
PackageExport[GeodesicSprayGraph]
PackageExport[GeodesicExtensionGraph]
PackageExport[PathSubgraph]
PackageExport[InfraDeformationSize]

(* Homotopy.wl *)
PackageExport[FindInfraHomotopy]
PackageExport[FindInfraHomotopyRepresentative]
PackageExport[FindInfraHomotopyRepresentativeHomotopy]
PackageExport[HomotopicQ]
PackageExport[NullHomotopicQ]
PackageExport[HomotopyMoveType]
PackageExport[HomotopyMoveTypes]

(* MetricAlgebra.wl *)
PackageExport[MetricInterval]
PackageExport[GeodesicMultiplicity]
PackageExport[GeodesicMultiplicityMatrix]
PackageExport[MedianVertices]
PackageExport[FindSegmentHull]
PackageExport[SegmentHullQ]

(* InfraSet.wl *)
(* AlexandrovTopology / GraphTopology are the complex-side layer and stay in the Infrageometry paclet; the ball topology came here with BallTopology.wl *)
PackageExport[FindInfraEquidistantSet]
PackageExport[FindAdvancingInfraFront]
PackageExport[InfraBoundary]
PackageExport[InfraInterior]
PackageExport[InfraVolume]

(* TarskiGeometry.wl *)
PackageExport[BetweennessQ]
PackageExport[EquidistanceQ]
PackageExport[TarskiStructure]
PackageExport[TarskiBetweennessTensor]
PackageExport[TarskiEquidistanceClasses]
PackageExport[TarskiCongruenceReflexivityQ]
PackageExport[TarskiCongruenceTransitivityQ]
PackageExport[TarskiCongruenceIdentityQ]
PackageExport[TarskiSegmentConstructionQ]
PackageExport[TarskiFiveSegmentsQ]
PackageExport[TarskiBetweennessIdentityQ]
PackageExport[TarskiInnerPaschQ]
PackageExport[TarskiLowerDimensionQ]
PackageExport[TarskiUpperDimensionQ]
PackageExport[TarskiEuclidAxiomQ]
PackageExport[TarskiContinuityQ]
PackageExport[TarskiAxiomQ]
PackageExport[FindTarskiCounterexample]

(* ProjectiveGeometry.wl *)
PackageExport[SameDirectionQ]
PackageExport[CollinearQ]
PackageExport[ConcurrentQ]
PackageExport[UniqueCollinearQ]
PackageExport[UniqueConcurrentQ]
PackageExport[WhiteheadW1Q]
PackageExport[WhiteheadW2Q]
PackageExport[WhiteheadW3Q]
PackageExport[ProjectivePlaneGraphQ]

(* InfraEquality.wl *)
PackageExport[InfraEqualQ]

(* EuclideanInfrageometry/InfraScene.wl *)
PackageExport[InfraScene]
PackageExport[FindInfraScene]
PackageExport[InfraSceneInstance]
PackageExport[InfraGeometricStep]
PackageExport[InfraIntersection]
PackageExport[InfraUnion]
PackageExport[InfraDistance]
PackageExport[InfraPlaneQ]
PackageExport[InfraIntersectQ]

(* EuclideanInfrageometry/InfraSceneVisualization.wl *)
PackageExport[InfraSceneHighlight]
PackageExport[$InfraPointColor]
PackageExport[$InfraSegmentColor]
PackageExport[$InfraShellColor]
PackageExport[$InfraPlaneColor]
PackageExport[$InfraCircleColor]
PackageExport[$InfraRayColor]
PackageExport[$InfraWalkColor]
PackageExport[$InfraLineColor]

(* EuclideanInfrageometry/InfraSceneInteractive.wl *)
PackageExport[PointViewer]
PackageExport[SegmentViewer]
PackageExport[ShellViewer]
PackageExport[CircleViewer]
PackageExport[InfraSceneViewer]

(* ---- Riemannian: measurements of the substrate ------------------------- *)
(* The observer measures. Which tensor do the numbers see? *)

(* VolumeGrowth.wl *)
PackageExport[BallHull]
PackageExport[BallVolumes]
PackageExport[ShellAreas]
PackageExport[CylinderVolumes]
PackageExport[TubeVolumes]
PackageExport[IntervalVolumes]
PackageExport[GeodesicIntervalGraph]
PackageExport[GeodesicOccupation]
PackageExport[GeodesicEdgeOccupation]
PackageExport[LogDifferenceQuotients]
PackageExport[VolumeGrowthObservables]
PackageExport[DimensionCurvatureFit]

(* TessellationGraphs.wl *)
PackageExport[TessellationGraph]
PackageExport[TorusTessellation]
PackageExport[TessellationCurvature]
PackageExport[TessellationEulerCharacteristic]
PackageExport[TessellationGenus]
PackageExport[TessellationNeighborhoodGraph]
PackageExport[CosetEnumeration]
PackageExport[LowIndexMaps]
PackageExport[RotationMapGraph]

(* Displacements.wl *)
PackageExport[DisplacementCompose]
PackageExport[DisplacementScale]
PackageExport[DisplacementNegative]
PackageExport[DisplacementInverse]
PackageExport[DisplacementSum]
PackageExport[DisplacementCommutator]
PackageExport[DisplacementBracket]
PackageExport[DisplacementMagnitude]
PackageExport[DisplacementReduce]
PackageExport[DisplacementSingleValuedQ]
PackageExport[DisplacementBijectionQ]
PackageExport[DisplacementIsomorphismQ]
PackageExport[ContinuousDisplacementQ]
PackageExport[RandomDisplacement]
PackageExport[FindKillingDisplacement]
PackageExport[KillingDisplacementMagnitude]
PackageExport[PolarDisplacements]
PackageExport[GradientDisplacement]
PackageExport[TranslationDisplacement]
PackageExport[DisplacementPlot]

(* Boundary.wl *)
PackageExport[GraphBoundary]
PackageExport[GraphInterior]
PackageExport[GraphExteriorBoundary]
PackageExport[BoundarylessGraph]
PackageExport[GraphEccentricities]
PackageExport[CenterGraph]
PackageExport[RelativeEccentricity]

(* BallTopology.wl *)
PackageExport[BallTopology]
PackageExport[TopologicalClosure]
PackageExport[TopologicalInterior]
PackageExport[TopologicalBoundary]
PackageExport[TopologicalNeighborhood]
PackageExport[ContinuousMapQ]
PackageExport[TopologyGraph]

(* ExampleGraphs.wl *)
PackageExport[SierpinskiGraph]
PackageExport[BetheGraph]
PackageExport[BranchingSequenceTree]
PackageExport[InflateGraph]
PackageExport[InflatedVertex]

(* InfraSubstrate.wl *)
PackageExport[InfraSubstrate]
PackageExport[InfraSubstrateStyle]
PackageExport[InfraSubstrateCode]

(* UniformLengthDiscretization.wl *)
PackageExport[UniformLengthGraph]
PackageExport[UniformLengthEmbedding]

(* Coordinatization.wl *)
PackageExport[RadarCoordinates]
PackageExport[ResolvingSetQ]
PackageExport[FindResolvingSet]
PackageExport[MetricDimension]
PackageExport[ResistanceCoordinates]
PackageExport[FindBallCover]
PackageExport[BallCoverQ]
PackageExport[DominationNumber]
PackageExport[OrthogonalCoordinates]
PackageExport[FindInfraOrthogonalFrame]
PackageExport[FindInfraSpanningAxes]

(* OllivierCurvature.wl *)
PackageExport[OllivierRicciCurvature]
PackageExport[EffectiveResistance]
PackageExport[ResistanceQ]

(* BallIntersectionComplex.wl -- arrived from the Infrageometry paclet 2026-09-22;
   the complex of a family of metric balls, so it reads the metric *)
PackageExport[MiniballRadius]
PackageExport[BallIntersectionComplex]
PackageExport[CechComplex]
PackageExport[BallIntersectionFiltrationValue]
PackageExport[BallIntersectionFiltration]
PackageExport[CechFiltration]
PackageExport[BallIntersectionBifiltration]

(* DifferentialForms.wl -- arrived from the Infrageometry paclet 2026-09-22;
   the cochain calculus the measurements are written in *)
PackageExport[FormValue]
PackageExport[CochainValue]
PackageExport[OrderedCochainValue]
PackageExport[FormDegree]
PackageExport[CochainDegree]
PackageExport[ZeroForm]
PackageExport[RestrictionMap]
PackageExport[IntegrationMap]
PackageExport[Coboundary]
PackageExport[FormDifferential]
PackageExport[NaiveDifferential]
PackageExport[FormWedge]
PackageExport[CochainCup]
PackageExport[OrderedCochainCup]
PackageExport[CochainCupOne]
PackageExport[AntisymmetrizedCup]

(* ---- symplectic: dynamics of an action on paths ------------------------ *)
(* The observer moves. What is conserved? Declared, no kernel code yet. *)

(* ---- infrastructure: not a branch -------------------------------------- *)
(* Usage.wl declares no exports -- the ::usage registry lives there. *)

(* Tools.wl *)
PackageExport[InfraDensity]

(* GraphEnumeration.wl *)
PackageExport[EnumerateGraphs]

ClearAll["WolframInstitute`SyntheticInfrageometry`**`*", "WolframInstitute`SyntheticInfrageometry`*"]
