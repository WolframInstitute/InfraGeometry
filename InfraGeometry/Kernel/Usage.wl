Package["WolframInstitute`InfraGeometry`"]

InfraPoint::usage = "InfraPoint is the scene-language token for the point search -- FindInfraPoint minus the graph. InfraPoint[] draws from the whole vertex list, InfraPoint[v] names one vertex, InfraPoint[\"Center\"] / InfraPoint[\"Periphery\"] a pool, InfraPoint[origin, d] the vertices at distance d, InfraPoint[n, \"Distance\" -> spec] an n-tuple. It is not a wrapper: a point IS a vertex of the substrate, carrying its label verbatim.";
FindInfraPoint::usage = "FindInfraPoint[graph] draws a vertex from the candidate pool; a trailing n | UpTo[n] | All sets the count and returns a List of vertices. Options \"From\", \"Distance\", \"MaxCliques\".";
FindInfraMidpoint::usage = "FindInfraMidpoint[graph, p1, p2] gives the density <|v -> m, ...|> of the middle vertices of every geodesic from p1 to p2 (one vertex at even distance, two at odd). Option Method.";
FindInfraGoldenSection::usage = "FindInfraGoldenSection[graph, p1, p2] gives the density <|v -> m, ...|> at the golden-ratio index along every geodesic from p1 to p2. Option Method.";
FindInfraReflection::usage = "FindInfraReflection[graph, x, a] gives the reflections x' of x through a: the vertices with B(x, a, x') and d(a, x) == d(a, x').";
FindInfraCommonPoint::usage = "FindInfraCommonPoint[graph, lines] gives the points lying on every listed line.";
FindClosestInfraPoint::usage = "FindClosestInfraPoint[graph, line, point] gives the vertices of line at minimum graph distance from point.";
SelectInfraPoint::usage = "SelectInfraPoint[graph, vertices] draws a vertex from a supplied bundle under graph distance; a trailing n | UpTo[n] | All sets the count. Options \"From\", \"Distance\", \"MaxCliques\".";
InfraReachableQ::usage = "InfraReachableQ[graph, p1, p2] tests whether p1 and p2 have realisations in the same connected component.";
RandomInfraPoint::usage = "RandomInfraPoint[graph] gives a uniformly random vertex. RandomInfraPoint[graph, p, d] gives a uniformly random vertex at distance d from p.";
InfraCenter::usage = "InfraCenter[graph] gives a vertex of least eccentricity.";

Undetermined::usage = "Undetermined is the value of the measurement \"Faithful\" on a head whose graph is faithful only under a hypothesis this paclet does not certify.";
InfraMeasurement::usage = "InfraMeasurement[graph, obj, property] measures a Euclidean head on graph: \"Graph\", \"Cardinality\", \"Length\", \"VertexDensity\", \"EdgeDensity\", \"Subgraph\", \"Faithful\", \"CountingMeasure\" (the vertex count), \"RiemannianMeasure\" (the count without boundary). A List of properties gives an Association, All gives them all, a List of heads measures each.";
FindInfraRepresentative::usage = "FindInfraRepresentative[graph, head] gives one member of the inert head as a vertex list; a trailing n | UpTo[n] | All gives a List of vertex lists. Modifiers \"RandomChoice\" (a random member) and, under All, \"Pruning\" -> q. A head with a graph is read off its chains, the circle and the scene tokens by their searches at the defaults.";
InfraMemberQ::usage = "InfraMemberQ[graph, obj, path] tests whether the vertex list path is a member of obj.";
InfraSubgraph::usage = "InfraSubgraph[graph, obj] gives the subgraph of graph induced on the support of obj; InfraSubgraph[graph, obj -> t] thickens the support by t steps.";

InfraSegment::usage = "InfraSegment[p1, ..., pk] is the inert polyline of the segments [p1, p2], ..., [p(k-1), pk], closed when pk == p1, its one witness then retracing no edge when some member does not; InfraSegment[p, q] is the segment itself, whose graph is the geodesic interval I(p, q). InfraMeasurement and FindInfraRepresentative evaluate it on a graph; FindInfraSegment is the search.";
FindInfraSegment::usage = "FindInfraSegment[graph, p, q] gives one geodesic from p to q as a vertex list; a trailing n | UpTo[n] | All gives a List of them.";
InfraWalkQ::usage = "InfraWalkQ[graph, walk] tests whether walk is a walk: consecutive vertices adjacent (revisits allowed).";
InfraSegmentQ::usage = "InfraSegmentQ[graph, walk] tests whether walk is a geodesic.";
UniqueInfraSegmentQ::usage = "UniqueInfraSegmentQ[graph, u, v] tests whether the u-v geodesic is unique; UniqueInfraSegmentQ[graph] tests the geodetic property.";

InfraWalk::usage = "InfraWalk[p1, ..., pk] inside InfraScene is the literal walk through p1, ..., pk, and InfraWalk[{p1, ..., pk}] in InfraSubstrateHighlight one oriented walk. A walk itself is a Graph: a directed path on the position pairs {i, v}, a closed walk a directed cycle on them; Last /@ VertexList gives the vertex sequence.";
FindInfraWalk::usage = "FindInfraWalk[graph, germ, kspec] gives the walk graphs grown from the germ, a vertex or a walk, in the class cut by Properties until a stopping condition or the budget kspec stops them. Options \"InfraScale\", Properties, \"StoppingCondition\", \"NextVertexFunction\", \"Direction\".";
InfraGeodesic::usage = "InfraGeodesic[germ, scale] is the inert geodesics at infra-scale scale through the germ, a vertex list, whose graph is the window graph of its forward extensions. FindInfraRepresentative gives the inextensible simple ones.";
FindInfraGeodesic::usage = "FindInfraGeodesic[graph, germ, scale, kspec] grows the germ into the geodesics at infra-scale scale -- FindInfraWalk at \"InfraScale\" -> scale with \"Minimizing\" among the rules. Options Properties, \"StoppingCondition\", \"NextVertexFunction\", \"Direction\".";
InfraGeodesicQ::usage = "InfraGeodesicQ[graph, walk, scale] tests whether every window of scale consecutive vertices of walk plus the next one is a shortest path; scale 1 gives InfraWalkQ and Infinity gives InfraSegmentQ.";
WalkSingularities::usage = "WalkSingularities[walk] gives the singularities of a walk (a vertex list or a walk graph; a cycle graph is read on its cyclic core) as parameter data: \"SelfIntersections\" (position groups sharing a vertex), \"SelfTangencies\" (oriented interval groups sharing an arc), \"Cusps\" (mirrored blocks).";
InfraImmersedQ::usage = "InfraImmersedQ[graph, walk] tests whether walk is an immersed walk: a walk with no cusp (no backtrack).";
InfraGenericQ::usage = "InfraGenericQ[graph, walk] tests whether walk is a generic immersed curve: no cusps, no self-tangencies, every self-intersection a double point off the endpoints.";
InfraWalkCrossingQ::usage = "InfraWalkCrossingQ[graph, walk, v, r] tests whether the double visit of walk at v is a transverse crossing at scale r: the two passes separate each other's exits on the shell {r, r+1}; {i, j} names two positions instead.";
ConcatenateInfraWalk::usage = "ConcatenateInfraWalk[path1, path2] joins every compatible walk pair, those with Last[walk1] === First[walk2].";

InfraLine::usage = "InfraLine[p, q] is the inert line through p and q, whose graph is the List of atoms I(a, p) + I(p, q) + I(q, b) over the maximal compatible end pairs (a, b). InfraLine[germ] is the line through a geodesic germ -- a vertex, a vertex list, a walk graph or a geodesic DAG -- whose atoms keep the germ's own edges in the middle. InfraMeasurement and FindInfraRepresentative evaluate it on a graph; FindInfraLine is the search.";
FindInfraLine::usage = "FindInfraLine[graph, p, q] gives one line through p and q as a vertex list -- an inextensible geodesic through both; a trailing n | UpTo[n] | All gives a List. FindInfraLine[graph, seq] prolongs a given geodesic.";
FindInfraParallel::usage = "FindInfraParallel[graph, line, p] gives one parallel to line through p: a geodesic through p inextensible within the level set { v : d(v, line) == d(p, line) }; a trailing n | UpTo[n] | All sets the count, All giving the pool. Option \"NextVertexFunction\".";
FindInfraPerpendicular::usage = "FindInfraPerpendicular[graph, line, point] gives the lines through point perpendicular to line. Options Method, \"Radius\".";
FindInfraCommonLine::usage = "FindInfraCommonLine[graph, vertices] gives the canonical lines containing every listed vertex.";
InfraLineQ::usage = "InfraLineQ[graph, walk] tests whether walk is a line: a geodesic that no neighbour of either endpoint prolongs.";
InfraParallelQ::usage = "InfraParallelQ[graph, l1, l2] tests whether two lines stay at constant distance; a trailing threshold allows that distance to vary.";
InfraPerpendicularQ::usage = "InfraPerpendicularQ[graph, l1, l2] tests whether two lines meet perpendicularly at every common vertex. Options Method, \"Radius\".";
LineCount::usage = "LineCount[graph] gives the number of distinct canonical maximal geodesics in graph.";
UniversalLineQ::usage = "UniversalLineQ[graph] tests whether some pair spans a line filling a whole connected component (Chen-Chvatal); UniversalLineQ[graph, {u, v}] tests one line.";

InfraShell::usage = "InfraShell[c, {r, s}] is the inert shell { v : r <= d(v, c) <= s }, c a vertex or a vertex set; InfraShell[c, r] is the band {r, r}. Read by InfraMeasurement and FindInfraRepresentative; FindInfraShell is the search.";
FindInfraShell::usage = "FindInfraShell[graph, c, r] gives the metric shell { v : d(v, c) == r } as a sorted vertex list; r may be a band {r, s}, c a vertex set.";
InfraSphere::usage = "InfraSphere[c, {r, s}] is the inert family of inclusion-minimal connected subsets of the shell InfraShell[c, {r, s}] separating the centre's side from the far side; InfraSphere[c, r] is the band {r, r}. Read by InfraMeasurement and FindInfraRepresentative.";
FindInfraSphere::usage = "FindInfraSphere[graph, c, r, n] gives n minimal separating subsets of the shell of c with radius r or band {r, s}; n may be UpTo[n] or All. Options Properties, \"NextVertexFunction\".";
FindInfraOsculatingShell::usage = "FindInfraOsculatingShell[graph, path, i, k] gives the shells whose level set contains the k-vertex window of path centred at position i, one per osculating centre.";
FindAdvancingInfraFront::usage = "FindAdvancingInfraFront[graph, origin, steps] gives the foliation by a bouncing wavefront as a List of sorted vertex lists: each front steps one geodesic step outward and reflects inward where it cannot.";
FindInfraShellCenter::usage = "FindInfraShellCenter[graph, shell] recovers {center, radii} from a shell. Option Method.";
InfraShellQ::usage = "InfraShellQ[graph, vertexSet] tests whether vertexSet is a metric shell { v : d(c, v) == r } for some centre c and radius r.";

InfraBall::usage = "InfraBall[c, r] is the inert closed ball { v : d(v, c) <= r }, c a vertex or a vertex set; InfraBall[c, {r, s}] is the shell. Read by InfraMeasurement and FindInfraRepresentative.";
InfraBallQ::usage = "InfraBallQ[graph, vertexSet] tests whether vertexSet is a closed metric ball.";

InfraBallHull::usage = "InfraBallHull[S, r] is the inert intersection of the closed balls of radius at most r containing S, the whole graph if none does; InfraBallHull[S, {r}] takes the balls of radius exactly r, InfraBallHull[S, {r, s}] those of radius between r and s, and InfraBallHull[S] every radius, the Mazur hull. Read by InfraMeasurement and FindInfraRepresentative.";
InfraConvexHull::usage = "InfraConvexHull[S, k] is the inert k-th round of the interval closure of S, a round adding all geodesics between its vertices; InfraConvexHull[S] is the convex hull. Read by InfraMeasurement and FindInfraRepresentative.";

InfraTube::usage = "InfraTube[core, profile] is the inert tube { v : d(a_i, v) <= r_i for some i } along the core a_1, ..., a_m, the profile a radius, a band {s, t}, a list of them or a function of i. Option Method (\"Balls\", \"Sliced\").";
InfraCylinder::usage = "InfraCylinder[axis, r] is the inert cylinder InfraTube[axis, r, Method -> \"Sliced\"], the tube of radius r with flat ends; r may be a band {r, s}.";
InfraCone::usage = "InfraCone[axis, slope] is the inert cone InfraTube[axis, i |-> slope (i - 1), Method -> \"Sliced\"], apex First[axis] and a flat base.";
InfraSolidOfRevolution::usage = "InfraSolidOfRevolution[axis, profile] is the inert solid InfraTube[axis, profile, Method -> \"Sliced\"], the profile read at the nearest axis vertex; a band profile {r, r} is the surface.";

InfraCircle::usage = "InfraCircle[c, r | {r, s}] is the inert family of circles around c in the band r <= d(c, v) <= s; its graph is the List of atoms of the unrolled band, the necklaces where that fails.";
InfraCircleQ::usage = "InfraCircleQ[graph, cycle] tests whether cycle is a cyclic edge chain whose vertex set is a metric shell.";

InfraArc::usage = "InfraArc[c, {p1, ..., pk}] is the inert arc around c through the points, the geodesics of the band of the circle through p1; InfraArc[c, {p, p}] is the closed arc, the circles through p. Option \"RadiusDelta\".";

InfraPolygon::usage = "InfraPolygon[As, n] is the inert family of regular n-gons whose k-th diagonals satisfy As[[k]]; FindInfraRegularPolygon is the search. The polygon through given corners is the closed polyline InfraSegment[p1, ..., pn, p1].";
FindInfraRegularPolygon::usage = "FindInfraRegularPolygon[graph, As, n] gives one closed n-vertex sequence whose k-th diagonal distances all match As[[k]] (each slot an Integer, {lo, hi}, or Automatic); a trailing n | UpTo[n] | All sets the count. Options \"NextVertexFunction\", \"From\".";
InfraRegularPolygonQ::usage = "InfraRegularPolygonQ[graph, cycle, As] tests whether cycle is regular with respect to the diagonal-distance tuple As.";

InfraQuadric::usage = "InfraQuadric[{p1, ..., pk}, c] is the inert solid { v : Sum_i d(p_i, v) <= c }, c a number or a band {lo, hi}; a trailing weight list gives the signed sum. One focus is the ball, two the ellipse, InfraQuadric[{p1, p2}, {c, c}] the elliptic shell, weights {1, -1} a hyperbola branch. Read by InfraMeasurement and FindInfraRepresentative.";

InfraEllipse::usage = "InfraEllipse names the metric-ellipse construction -- a cycle lying on an elliptic shell -- and carries no value of its own; FindInfraEllipse is the search and gives a directed cycle graph.";
FindInfraEllipse::usage = "FindInfraEllipse[graph, {p1, p2}, c] gives one shortest separating cycle in the level surface { v : d(p1, v) + d(p2, v) == c }; a trailing n | UpTo[n] | All sets the count. Options Properties, \"NextVertexFunction\".";
InfraEllipseQ::usage = "InfraEllipseQ[graph, cycle] tests whether cycle is a cyclic edge chain whose vertex set is an elliptic shell InfraQuadric[{p1, p2}, {c, c}] for some foci.";

InfraPlane::usage = "InfraPlane[p1, p2] inside InfraScene is the bisecting hyperplane of p1 and p2; FindInfraBisectingHyperplane is the search. A plane itself is a sorted vertex list.";
FindInfraBisectingHyperplane::usage = "FindInfraBisectingHyperplane[graph, p1, p2] gives the perpendicular bisector { v : d(p1, v) == d(p2, v) }; a positional {lo, hi} widens it to a slab. Options Properties, \"NextVertexFunction\".";

InfraRay::usage = "InfraRay[p, q] is the inert ray from p through q, whose graph is the ray DAG R(p, q); InfraRay[p, p] is the pencil at p. InfraMeasurement and FindInfraRepresentative evaluate it on a graph; FindInfraRay is the search.";
FindInfraRay::usage = "FindInfraRay[graph, p, q] gives one ray from p through q as a vertex list -- a geodesic from p through q that no neighbour of its last vertex prolongs; a trailing n | UpTo[n] | All gives a List of them.";
InfraRayQ::usage = "InfraRayQ[graph, ray] tests whether ray is a pointed half-line: a geodesic from its own first vertex that cannot be prolonged past its last.";

FindInfraPolylineSubdivision::usage = "FindInfraPolylineSubdivision[graph, path] chunks a walk into the fewest geodesic legs whose knots are walk vertices. Option \"MaxLength\" caps each leg.";

InfraScalarProduct::usage = "InfraScalarProduct[graph, o, u, v] gives the base-point-relative product d(o, u) d(o, v) cos(theta), at curvature 0 the polar form (d(o,u)^2 + d(o,v)^2 - d(u,v)^2)/2. Option Method.";
FindInfraLinearCombination::usage = "FindInfraLinearCombination[graph, o, {{lambda1, u1}, ...}] gives the vertex realisations of Sum_i lambda_i u_i based at o. Options \"ScaleMethod\", \"SumMethod\".";
InfraAngle::usage = "InfraAngle[graph, {q1, p, q2}] gives the angle at p in radians. Option Method (\"Arclength\", \"Alexandrov\").";
InfraMetricTensor::usage = "InfraMetricTensor[graph, p] gives the matrix of d(p, u)/d(p, v) over v, w with u the vertex of I(p, w) closest to v; with r, over the shell FindInfraShell[graph, p, r]. Option \"SelectCoordinate\".";

SelectInfraWalk::usage = "SelectInfraWalk[graph, walks, n] draws n walks (default 1) from a bundle -- vertex lists or walk graphs, cycle graphs selecting as closed walks -- treated as a metric space; n may be UpTo[n] or All, and SelectInfraWalk[graph, n] is the operator form. Options \"From\", \"Distance\", \"Metric\", \"MaxCliques\", \"Cyclic\".";
EmbeddingClosest::usage = "EmbeddingClosest[graph, bundle, ref] keeps the bundle elements drawn closest to a Euclidean reference under GraphEmbedding; ref is {p1, p2}, {center, radius}, or a curve.";
FindEmbeddingClosestPath::usage = "FindEmbeddingClosestPath[graph, curve] snaps an embedded curve to a walk graph, mapping sampled points to nearest vertices and joining them by geodesics.";
SprayGraph::usage = "SprayGraph[graph, c] gives the BFS DAG rooted at c, whose directed source-to-sink paths are exactly the maximal geodesics from c; SprayGraph[graph, pairs] gives the union of geodesics between listed pairs.";
PathSubgraph::usage = "PathSubgraph[graph, u, v] gives the union of all shortest u-v paths; a trailing length cap or All widens it to longer simple paths.";
InfraDeformationSize::usage = "InfraDeformationSize[ref, walk] gives the number of ref edges that walk replaces -- Length[ref] - 1 less the shared prefix and suffix.";

FindInfraHomotopyRepresentative::usage = "FindInfraHomotopyRepresentative[graph, walk] gives the length-shortest walks in the homotopy class of walk -- an open walk with its endpoints fixed, a cycle graph a loop with its base point fixed, \"FreeHomotopy\" -> True freeing either. Options Method, \"FreeHomotopy\", \"NullHomotopicCycles\", \"MaxLength\", \"MaxMoves\".";
FindInfraHomotopyRepresentativeHomotopy::usage = "FindInfraHomotopyRepresentativeHomotopy[graph, obj] gives the chain of elementary moves reducing obj to a shortest representative. Options as FindInfraHomotopyRepresentative.";
FindInfraHomotopy::usage = "FindInfraHomotopy[graph, a, b] gives one chain of elementary moves from a to b as the List of walk graphs it passes through, { } when there is none; a bounded count or All gives a List of chains. Both walks must be open or both closed. Options as FindInfraHomotopyRepresentative.";
HomotopicQ::usage = "HomotopicQ[graph, a, b] tests whether a and b lie in the same homotopy class.";
NullHomotopicQ::usage = "NullHomotopicQ[graph, cycle] tests whether a closed walk -- a vertex list read cyclically, or a cycle graph -- is null-homotopic.";
HomotopyMoveType::usage = "HomotopyMoveType[walk1, walk2] classifies an elementary move as \"Contract\", \"Extend\", or \"Lateral\".";
HomotopyMoveTypes::usage = "HomotopyMoveTypes[chain] applies HomotopyMoveType to each consecutive pair of a homotopy chain.";

MetricInterval::usage = "MetricInterval[graph, u, v] gives { w : d(u, w) + d(w, v) == d(u, v) }, the union of all geodesics from u to v.";
ShortestPathMultiplicityMatrix::usage = "ShortestPathMultiplicityMatrix[graph] gives the matrix whose (i, j) entry is the number of shortest paths from the i-th to the j-th vertex, 0 when there is none.";
MedianVertices::usage = "MedianVertices[graph, vs] gives the vertices minimising the sum of distances to vs.";

InfraDensity::usage = "InfraDensity[graph, x] gives the marginal of any shape to the vertex set, <|v -> m|>, with respect to the counting measure: a vertex gives <|v -> 1|>, a vertex list its Counts, a density itself, a walk graph or a bundle its vertex occupation. It is the one coercion in the API -- Keys demotes it back to the set, Counts promotes a list to one.";

FindInfraEquidistantSet::usage = "FindInfraEquidistantSet[graph, {p1, ..., pn}] gives { v : d(p1, v) == ... == d(pn, v) } as a sorted vertex list; a trailing {lo, hi} thickens each bisector to a slab.";
InfraBoundary::usage = "InfraBoundary[graph, s] gives, as a sorted vertex list, the boundary of a vertex set, density or shape. Option Method (\"Combinatorial\", \"Alexandrov\").";
InfraInterior::usage = "InfraInterior[graph, s] gives, as a sorted vertex list, the interior of a vertex set, density or shape. Option Method (\"Combinatorial\", \"Alexandrov\").";

OrthogonalCoordinates::usage = "OrthogonalCoordinates[graph, c, axes, v] gives the integer displacement of v along each axis through the centre c; without v, the association over all vertices. Option \"SelectCoordinate\".";
FindInfraOrthogonalFrame::usage = "FindInfraOrthogonalFrame[graph, c, axisLength] gives frames of mutually perpendicular geodesic axes through the centre c. Options Method, \"AxisCount\", \"BranchSampleSize\", \"SelectCoordinate\".";
FindInfraSpanningAxes::usage = "FindInfraSpanningAxes[graph, n] gives n mutually well-separated longest geodesics across graph, with no fixed centre. Options \"AxisDistance\", \"MinLength\", \"MinSeparation\", \"AxisThickness\", \"RandomPick\".";

InfraScene::usage = "InfraScene[objects, hypotheses] builds a scene descriptor from symbolic objects and construction or assertion hypotheses. Properties \"Steps\", \"Constructions\", \"Assertions\", \"DependencyGraph\".";
FindInfraScene::usage = "FindInfraScene[scene, graph] solves a scene on a graph and gives the resulting InfraSceneInstance bindings. Option \"PruneProbability\".";
InfraSceneInstance::usage = "InfraSceneInstance[bindings] wraps a solved binding association; InfraSceneInstance[bindings, sym] reads one object out of it.";
InfraStep::usage = "InfraStep[{hyp1, ...}] groups hypotheses into one construction step of a scene; a second argument labels it.";
InfraIntersection::usage = "InfraIntersection[graph, obj1, obj2, ...] gives the vertex-set intersection of shapes on graph -- vertex lists, densities, walk graphs, bundles -- as a sorted List. On Euclidean heads it is inert and InfraMeasurement gives it the common support and the product density. Inside InfraScene it is the token InfraIntersection[c1, c2], one branch per common vertex, the engine supplying the graph.";
InfraUnion::usage = "InfraUnion[graph, obj1, obj2, ...] gives the vertex-set union of shapes on graph as a sorted List. On Euclidean heads it is inert and InfraMeasurement gives it the joint support and the sum density. Inside InfraScene it is the token InfraUnion[c1, c2], one branch per vertex of either, the engine supplying the graph.";
InfraDistance::usage = "InfraDistance[graph, p, q] gives the graph distance between two Infra* objects, aggregated over their vertex sets. Option \"Aggregation\".";
InfraPlaneQ::usage = "InfraPlaneQ[graph, h, p1, p2] tests whether h lies in the bisector slab of p1, p2 and separates them; a trailing window widens the slab. The graph-free InfraPlaneQ[h, p1, p2] is the inert InfraScene assertion.";
InfraIntersectQ::usage = "InfraIntersectQ[s1, s2] asserts inside an InfraScene that two sets intersect; it stays inert until bindings resolve, which is why it exists rather than the built-in IntersectingQ.";

InfraSubstrateHighlight::usage = "InfraSubstrateHighlight[graph, {obj1, obj2, ...}] draws the sum of the objects' densities on graph, the i-th object in the i-th palette color; a Directive styles the objects after it. Options \"OpacityRange\", \"ThicknessRange\", \"PointSizeRange\", \"Arrowheads\", \"Palette\".";
InfraSceneViewer::usage = "InfraSceneViewer[scene, graph] is an interactive step-by-step visualisation of an InfraScene on a graph.";
PointViewer::usage = "PointViewer[graph] is an interactive viewer for selecting points; PointViewer[graph, sym] stores the selection in sym.";
SegmentViewer::usage = "SegmentViewer[graph] is an interactive viewer for exploring geodesic segments.";
ShellViewer::usage = "ShellViewer[graph] is an interactive viewer for exploring metric shells.";
CircleViewer::usage = "CircleViewer[graph] is an interactive viewer for exploring separating cycles.";

InfraEqualQ::usage = "InfraEqualQ[graph, a, b] tests equality of two Infra* objects through their diffusion diagrams. Option Method (\"Diffuse\", \"Overlap\", \"Set\", \"Multiset\").";

LogDifferenceQuotients::usage = "LogDifferenceQuotients[w] gives the log-difference quotients q(r) = (Log w(r) - Log w(r-1)) / (Log(r+1) - Log r) of a sequence w = {w(0), w(1), ...}, the discrete d Log w / d Log r; equals ResourceFunction[\"LogDifferences\"][w]. Accepts any numeric or Around sequence, such as the measures of InfraBall[v, r] over r, or their MeanAround over a vertex subset.";

VolumeGrowthObservables::usage = "VolumeGrowthObservables[g, v, window] fits dimension and scalar curvature to the ball and sphere growth at v by DimensionCurvatureFit and returns profiles, quotients, fits and windows as one Association; window {rmin, rmax}, All or Automatic. Options \"Measure\" (\"RiemannianMeasure\", \"CountingMeasure\"), \"Dimension\".";

DimensionCurvatureFit::usage = "DimensionCurvatureFit[{{r, q(r)}, ...}] fits <|\"Dimension\", \"ScalarCurvature\"|> to log-difference quotients by Bishop-Gromov regression on r (r + 1); a bare list {q(0), q(1), ...} sits at radii 0, 1, .... Options \"Probe\" (\"Ball\", \"Sphere\", \"Tube\", \"TubeMantle\"), \"Dimension\".";

TorusTessellation::usage ="TorusTessellation[{m, n}, shape] is the vertex-transitive flat-torus graph carrying the regular tessellation indicated by shape, one of \"Square\" ({4,4}), \"Triangular\" ({3,6}, the default) or \"Hexagonal\" ({6,3}).";

TessellationGraph::usage = "TessellationGraph[{p, q}] is the smallest regular map of type {p, q} as a graph -- the Platonic solid when (p-2)(q-2) < 4, the smallest hyperbolic quotient when > 4. TessellationGraph[config] is the uniform (Archimedean) map of vertex configuration config (the cyclic face sizes around a vertex, e.g. {3, 6, 3, 6}). TessellationGraph[spec, n] sizes the result (n x n flat torus in the Euclidean case, n-th PSL(2,ell) quotient in the hyperbolic case); TessellationGraph[{p, q}, {m, n}] gives the m x n flat torus; TessellationGraph[{p, q}, G] / [{p, q}, {r, s}] carries the coset graph of a finite group G or an explicit (2,p,q)-generation. Option Method (Automatic (default; fast realiser per curvature), \"Platonic\", \"Torus\", \"PSL2\", or \"CosetEnumeration\" / {\"CosetEnumeration\", \"MaxIndex\" -> n} for the general low-index method).";

TessellationCurvature::usage = "TessellationCurvature[{p, q}] (or TessellationCurvature[config]) is the combinatorial Gaussian curvature Sum 1/f_i - (k-2)/2 at a vertex of the {p, q} regular map or the uniform map of vertex configuration config; its sign is spherical (> 0), flat (== 0), or hyperbolic (< 0) and the geometric angle defect is 2 Pi times it. TessellationCurvature[graph] detects a regular configuration (uniform degree, girth face size) from the graph.";

TessellationEulerCharacteristic::usage = "TessellationEulerCharacteristic[graph, spec] is the Euler characteristic V - E + F of the realised tessellation graph, where spec is its {p, q} symbol or vertex configuration. TessellationEulerCharacteristic[graph] assumes a regular map and detects spec from the graph (pass spec explicitly for Archimedean / mixed-face maps).";

TessellationGenus::usage = "TessellationGenus[graph, spec] is the orientable genus (2 - chi)/2 of the realised tessellation graph, where spec is its {p, q} symbol or vertex configuration. TessellationGenus[graph] assumes a regular map and detects spec from the graph (pass spec explicitly for Archimedean / mixed-face maps).";

TessellationNeighborhoodGraph::usage = "TessellationNeighborhoodGraph[{p, q}, r] is the radius-r graph-distance ball cut from the infinite regular {p, q} tessellation of its covering surface (Euclidean plane, hyperbolic plane, or closing-up sphere by the curvature (p-2)(q-2)) -- the non-compact companion to TessellationGraph, with VertexCoordinates carrying the embedding. TessellationNeighborhoodGraph[config, r] cuts the same ball from the uniform / Archimedean tiling of a longer vertex configuration (the chiral snub / elongated families are deferred). TessellationNeighborhoodGraph[{p, q}, {m, n}] is the m x n rectangular Euclidean patch.";

DisplacementCompose::usage = "DisplacementCompose[d1, d2, ...] composes displacements as flows, the leftmost acting first; targets are collected over every intermediate point.";

DisplacementScale::usage = "DisplacementScale[g, d, t] scales displacement d by t: endpoints of the geodesics v -> d(v) rescaled to t times their length (t < 0 reflects through the base point).";

DisplacementNegative::usage = "DisplacementNegative[g, d] is the metric negative of d: each step is reflected through its base point, the scale -1 case of DisplacementScale.";

DisplacementInverse::usage = "DisplacementInverse[d] reverses the relation d: its value at v is the set of vertices whose d-value contains v. It is the ordinary inverse when d is bijective and may have empty fibers otherwise.";

DisplacementSum::usage = "DisplacementSum[g, d1, d2] is the bisector of the two composition orders of d1 and d2 -- by Baker-Campbell-Hausdorff the sum of the generators, with the commutator term cancelled.";

DisplacementCommutator::usage = "DisplacementCommutator[g, d1, d2] applies the commutator loop selected by Method. Method -> \"Inverse\" (default) is the exact group commutator of bijective displacements; Method -> \"Negative\" composes d1, d2 and their metric negatives. DisplacementCommutator[g, d1, d2, v] evaluates it at v.";

DisplacementBracket::usage = "DisplacementBracket[g, d1, d2] is DisplacementCommutator[g, d1, d2, Method -> \"Negative\"], the scale-dependent metric bracket candidate. DisplacementBracket[g, d1, d2, v] evaluates it at v.";

DisplacementMagnitude::usage = "DisplacementMagnitude[g, d] is the maximal step length of displacement d -- its scale.";

DisplacementReduce::usage = "DisplacementReduce[g, d] contracts each value set of d to its metric centre (minimal eccentricity within the set), iterated to a fixed point; genuine ties survive.";

DisplacementSingleValuedQ::usage = "DisplacementSingleValuedQ[d] tests whether every value of displacement d is a single vertex.";

DisplacementBijectionQ::usage = "DisplacementBijectionQ[d] tests whether displacement d is a single-valued permutation of the vertex set.";

DisplacementIsomorphismQ::usage = "DisplacementIsomorphismQ[g, d] tests whether displacement d is a graph automorphism of g -- a discrete Killing displacement.";

ContinuousDisplacementQ::usage = "ContinuousDisplacementQ[g, d, k] tests k-continuity of displacement d (default k = 1). Method -> \"Weak\" requires one close target pair across each edge; \"Hausdorff\" requires every target to have a close partner; \"Strong\" requires every cross-pair to be close.";

RandomDisplacement::usage = "RandomDisplacement[g, r] generates a random continuous displacement of magnitude at most r (default 1): a random continuous section of the scale-r tangent bundle.";

FindKillingDisplacement::usage = "FindKillingDisplacement[g] finds the nontrivial graph automorphism of least displacement magnitude, as a displacement. FindKillingDisplacement[g, All] returns all minimal ones.";

KillingDisplacementMagnitude::usage = "KillingDisplacementMagnitude[g] is the least magnitude of a nonidentity graph automorphism, or Infinity when g is asymmetric.";

PolarDisplacements::usage = "PolarDisplacements[g, c] gives the polar pair {radial, angular} at centre c: radial steps along geodesics from c (outward, or inward with \"Direction\" -> \"Inward\"), angular steps along edges of equal distance.";

GradientDisplacement::usage = "GradientDisplacement[g, f] is the steepest-ascent displacement of the vertex function f (an association): each vertex moves to the neighbours maximising the increase of f; local maxima stay put.";

TranslationDisplacement::usage = "TranslationDisplacement[g, v] translates along the graph embedding: each vertex moves to the vertices whose coordinates are nearest to its own position plus the vector v.";

DisplacementPlot::usage = "DisplacementPlot[g, d] draws displacement d as bent arcs over the graph's own embedding. DisplacementPlot[g, {d1, d2, ...}] draws a sequence, the k-th in the k-th Standard colour.";

GraphBoundary::usage = "GraphBoundary[g, S] gives the inner vertex boundary of S in g (vertices where a g-edge escapes S). If S is a vertex list it is treated as the induced subgraph, so the boundary is the vertices of S adjacent to some vertex outside S; if S is a subgraph h, the boundary is the vertices of h having a g-neighbor they are not joined to in h (so a path/curve, lacking its induced chords, is all boundary).";

GraphInterior::usage = "GraphInterior[g, S] gives the interior of S in g (= S minus GraphBoundary[g, S]): the vertices all of whose g-edges stay inside the object. S may be a vertex list (induced-subgraph notion) or a subgraph h (its own edges, so a 1-D curve has empty interior).";

GraphExteriorBoundary::usage = "GraphExteriorBoundary[g] gives the exterior-boundary (rim) vertices of the whole graph, detected from vertex degrees; GraphExteriorBoundary[mr] gives the exact surface vertices of the MeshRegion (the vertices on a facet belonging to exactly one top cell). Option Method (\"AverageDegree\" (default, for meshes: the vertices of below-average degree) | \"MaxDegree\" (for lattices: the vertices of less than full degree)); a MeshRegion needs no method. Complements GraphBoundary, the inner boundary of a subset.";

BoundarylessGraph::usage = "BoundarylessGraph[g] deletes every edge joining two exterior-boundary vertices (GraphExteriorBoundary[g]) and then the vertices this isolates, preserving the original vertex coordinates and their dimension: the rim contour disappears while boundary vertices with an inward edge survive as whiskers, so the result models an open window onto the geometry. BoundarylessGraph[mr] does the same on the 1-skeleton of the MeshRegion, with the exact surface as the boundary. Options: Method (passed to GraphExteriorBoundary; Graph form only), \"KeepCoordinates\" (True (default) carries the coordinates over, False drops them).";

GraphEccentricities::usage = "GraphEccentricities[g] gives the eccentricity max_w d(v, w) of every vertex, in VertexList order -- the list form of VertexEccentricity. Also takes a distance matrix. Values run from GraphRadius[g] to GraphDiameter[g].";

CenterGraph::usage = "CenterGraph[g, q] gives the induced subgraph on { v : d(v, GraphCenter[g]) <= Floor[q GraphRadius[g]] }, the substrate cut to a fraction q of the way out from its centre; q = 0 is the centre, q = 1 (the default) the whole graph, and q is clipped to [0, 1]. Vertex labels and coordinates are g's, so a construction made on the ball draws on g. For a cut in hops use NeighborhoodGraph[g, GraphCenter[g], k]. Returns g unchanged when the graph is vertex-transitive or disconnected.";

RelativeEccentricity::usage = "RelativeEccentricity[g] gives (e(v) - radius)/(diameter - radius) for each vertex in VertexList order -- 0 on GraphCenter, 1 on GraphPeriphery. Also takes a distance matrix. Identically 0 when diameter == radius or the graph is disconnected.";

BallTopology::usage = "BallTopology[g, r] returns the Hasse diagram of the r-ball specialization preorder on V(g): directed edge q -> p iff the closed r-ball at p is contained in the one at q, transitive edges removed. This digraph is the topology object consumed by the Topological* operators. Option \"Dual\" (False default; True gives the ReverseGraph).";

TopologicalClosure::usage = "TopologicalClosure[topo, verts] gives the closure of vertex list verts in the specialization-preorder digraph topo: the union of the in-components (down-sets) of the vertices.";

TopologicalInterior::usage = "TopologicalInterior[topo, verts] gives the interior int(S) = V \\ cl(V\\S) of vertex list verts in the digraph topo, with carrier V = VertexList[topo].";

TopologicalBoundary::usage = "TopologicalBoundary[topo, verts] gives the (two-sided) boundary cl(S) \\ int(S) of vertex list verts in the digraph topo.";

TopologicalNeighborhood::usage = "TopologicalNeighborhood[topo, verts] gives the unique minimal open neighborhood of vertex list verts in the digraph topo: the union of the out-components (up-sets) of the vertices.";

ContinuousMapQ::usage = "ContinuousMapQ[f, topo1, topo2] tests whether the vertex map f is continuous from preorder digraph topo1 to topo2, i.e. every Hasse edge q -> p of topo1 maps to a pair reachable in the transitive closure of topo2. f: Association, list of Rule, or callable.";

TopologyGraph::usage = "TopologyGraph[g, topo] draws the graph g overlaid with the Hasse arrows of the specialization-preorder digraph topo.";

SierpinskiGraph::usage = "SierpinskiGraph[n] is the trivalent Sierpinski graph: the 3-simplex K_4 with corner-cutting (truncation) iterated n-1 times. 3-regular at every generation, 4*3^(n-1) vertices; n=2 is the truncated tetrahedron. Graph options are forwarded.";

BetheGraph::usage = "BetheGraph[n, z] is the finite Bethe lattice / Cayley tree of n shells and coordination number z (argument order matching CompleteKaryTree[n, k]): the root branches z ways and every other internal node z-1, so all interior vertices are z-valent. Distinct from the rooted, irregular CompleteKaryTree. Undirected by default; DirectedEdges -> True orients edges away from the root.";

BranchingSequenceTree::usage = "BranchingSequenceTree[b] is the spherically symmetric rooted tree whose offspring count depends only on depth: a vertex at depth l has b[[l+1]] children. Length[b]+1 levels, FoldList[Times, 1, b] vertices per shell. Constant b gives CompleteKaryTree. Graph options are forwarded.";

InflateGraph::usage = "InflateGraph[g] grows a fiber of extra vertices over every vertex of g, joins each to its base vertex, and adds random edges between fibers whose base vertices lie within \"Radius\" in g. The base is recoverable as the induced subgraph on VertexList[g]. Options \"ExtraVertices\", \"ExtraEdges\", \"Radius\" and \"Density\", each a constant or a {min, max} range sampled per base vertex.";

InflatedVertex::usage = "InflatedVertex[v, i] is the i-th fiber vertex over base vertex v in a graph produced by InflateGraph.";

InfraSubstrateStyle::usage = "InfraSubstrateStyle[size] is the Graph option list a substrate backdrop is drawn with at size \"Small\" | \"Medium\" | \"Large\" -- StandardGray edges on an opacity ladder and faintly filled outlined vertex disks at a scaled 0.013 | 0.009 | 0.006 of the coordinate diagonal, fading as the substrate grows, so one style draws one dot on every graph -- and \"Default\" is none. InfraSubstrateStyle[name, size] is the style of the named substrate at that size: every substrate falls back to the size default today, and a custom look for one substrate is one more definition. Splice a style into any graph construction: Graph[g, Sequence @@ InfraSubstrateStyle[\"Medium\"]] -- the way to draw a hand-built object (a Wolfram-model graph in particular) exactly like the roster substrates. InfraSubstrateStyle[] lists the available styles in an Association with \"Default\" and \"Custom\" keys; InfraSubstrateStyle[All] gives the flat list of all default and custom styles.";

InfraSubstrate::usage = "InfraSubstrate[name, size] is the named example substrate at size \"Small\", \"Medium\" or \"Large\", or at a raw spec (a cell measure, a radius, grid dimensions, a generation count); a substrate drawn from a random construction is seeded from outside, with SeedRandom, so the same seed recovers the same graph; a call consumes the random stream like any other draw. Each substrate is one explicit definition in Kernel/InfraSubstrates/InfraSubstrate.wl, with its size table and its exceptions (an interior strip, a kept embedding) written into the definition. A Wolfram-model universe is named by its Registry of Notable Universes number, as in InfraSubstrate[\"wm6655\", 11], and any of the 947 registry entries resolves through ResourceFunction[\"WolframModelData\"]. InfraSubstrate[name, size, style] overrides the ambient style, which defaults to the InfraSubstrateStyle of that size since a substrate is a backdrop; pass \"Default\" for none. A substrate is bare combinatorics by default -- a stored embedding is discarded and a spring layout of its own dimension places the vertices; option \"KeepCoordinates\" -> True draws the substrate where it lives instead. Any substrate inflates: option \"Inflate\" -> amount grows a fiber of that many extra vertices over every vertex through InflateGraph (a constant or a {min, max} range), and \"Inflate\" -> {opts} passes InflateGraph its full option list. InfraSubstrate[] lists the roster classified by what a substrate models (\"OpenManifold\" -- boundaryless patches, open subsets delivered with the rim contour removed; \"ClosedManifold\" -- compact tessellated surfaces; \"Fractal\" -- self-similar, Hausdorff dimension between the integers; \"Exotic\" -- graphs with no manifold model and no scaling law; \"WolframModel\"); InfraSubstrate[All] is the flat name list; InfraSubstrate[name] is the \"Medium\" size. Graph options are forwarded.";

InfraSubstrateCode::usage = "InfraSubstrateCode[name, size] is the code behind InfraSubstrate[name, size]: the held construction, without the backdrop style, wrapped in a Graph call only when a layout clause or a forwarded option has to attach to it, whose ReleaseHold evaluates to the graph InfraSubstrate draws at the same seed with the \"Default\" style (building the code realizes the graph once, so set the seed after the build). It is HoldForm, so an output cell shows it as typeset code. The roster definition is itself held code -- InfraSubstrate evaluates it, InfraSubstrateCode prints it -- so the printed code cannot drift from the code that runs, and it names no symbol the reader cannot see. Baked in: the size table collapsed to the value the size selects, the rule and initial condition of a Wolfram-model universe, the layout dimension and the inflation call; the style is presentation and is spliced back with Sequence @@ InfraSubstrateStyle[size]. Takes the options of InfraSubstrate, and Graph options are forwarded.";

UniformLengthGraph::usage = "UniformLengthGraph[region, n] returns the contact graph of an n-sphere hard-sphere packing relaxed in region (filling a solid, meshing a surface); every edge has length 2r. Option Method (\"IterativeProjection\" (default), \"ConstrainedPacking\"); \"Radius\" (Automatic spaces the spheres to tile the region's content); \"KeepCoordinates\" (False (default) drops the packing coordinates, True stores them as VertexCoordinates).";

UniformLengthEmbedding::usage = "UniformLengthEmbedding[graph] embeds graph in R^d (option \"Dimension\") so every edge is a unit segment, returning coordinates in VertexList order (cf. GraphEmbedding); the iterative counterpart of ComplexEmbedding.";

RadarCoordinates::usage = "RadarCoordinates[g, basis, v] gives the distance vector (d(v, b))_{b in basis} of vertex v; RadarCoordinates[g, basis] gives the association of all vertices' radar coordinates.";

ResolvingSetQ::usage = "ResolvingSetQ[g, basis] tests whether basis is a resolving set: the radar map v |-> (d(v, b))_{b in basis} is injective over the vertices.";

FindResolvingSet::usage = "FindResolvingSet[g, n, m] returns up to n resolving sets (metric bases) of g by ascending size; m restricts the sizes (All, an integer max, {min, max}, or {exact}).";

MetricDimension::usage = "MetricDimension[g] gives the metric dimension of g: the size of a smallest resolving set.";

ResistanceCoordinates::usage = "ResistanceCoordinates[g] gives the association vertex -> spectral embedding Phi with ||Phi(u)-Phi(v)||^2 == EffectiveResistance[g,u,v]; options \"Rescaling\" (\"ResistanceMatching\" | \"None\" | \"Diffusion\"->t), \"Dimension\", \"Origin\". ResistanceCoordinates[g, v] gives the coordinates of v.";

FindBallCover::usage = "FindBallCover[g, r] returns a minimum r-ball cover of g: a smallest set of centres whose radius-r balls cover every vertex (a minimum r-dominating set). FindBallCover[g, r, targets] covers only the given vertex subset (centres still chosen from all of g). FindBallCover[g, r, targets, count] returns up to count distinct minimum covers for an integer count or UpTo[count], or every one for All; count defaults to 1 (a single cover). Option Method (\"Exhaustive\" (default) exact integer program, \"Greedy\" repeatedly takes the centre covering the most uncovered targets -- fast but not minimum in general, even on vertex-transitive graphs, \"Symmetric\" smallest union of Aut(g) orbits that covers -- exact when a minimum cover is orbit-shaped, an upper bound otherwise).";

BallCoverQ::usage = "BallCoverQ[g, r, S] tests whether the radius-r balls around the centres S cover every vertex of g. BallCoverQ[g, r, S, targets] tests coverage of the given vertex subset.";

DominationNumber::usage = "DominationNumber[g, r] gives the r-domination number of g: the size of a minimum r-ball cover. DominationNumber[g, r, targets] gives the size of a minimum r-ball cover of the given vertex subset.";

OllivierRicciCurvature::usage = "OllivierRicciCurvature[g] returns Association[edge -> kappa] with the Ollivier-Ricci curvature kappa(u, v) = 1 - W_1(mu_u, mu_v) / d(u, v), where mu_x is uniform on N(x) and W_1 is the Wasserstein-1 distance under graph distance (alpha = 0).";

EffectiveResistance::usage = "EffectiveResistance[g, u, v] returns the Klein-Randic resistance distance R(u, v) = (e_u - e_v)^T L^+ (e_u - e_v) for the graph Laplacian pseudoinverse L^+. EffectiveResistance[g] returns the full V x V matrix; EffectiveResistance[g, vs] the submatrix on a vertex list.";

ResistanceQ::usage = "ResistanceQ[r] tests whether a real symmetric n x n matrix r with zero diagonal is realisable as a resistance distance matrix (Klein-Randic / Schoenberg negative-type criterion: the centred Gram matrix is positive semidefinite).";

MiniballRadius::usage = "MiniballRadius[pts] returns the radius of the smallest enclosing ball of the points (BoundingRegion[pts, 'MinBall']).";

BallIntersectionComplex::usage = "BallIntersectionComplex[data, r, k] returns the order-k ball-intersection complex of closed radius-r balls: a simplex is admitted iff every k-subset of its balls has a common point. k = 2 is Vietoris-Rips (equal to VietorisRipsComplex[data, 2 r]), k = Infinity is Cech (the nerve), 2 < k < Infinity interpolates. Options: 'Metric'->EuclideanDistance|matrix|Graph|fn (Euclidean uses the exact miniball test, other metrics an intrinsic intersection oracle over the sample points), 'IntersectionTest'->fn applied to the common region (default = non-empty), 'MaxDimension'->k.";

CechComplex::usage = "CechComplex[data, r] returns the Cech complex (nerve) of closed radius-r balls = BallIntersectionComplex[data, r, Infinity].";

BallIntersectionFiltrationValue::usage = "BallIntersectionFiltrationValue[data, sigma, k] returns f_k(sigma), the birth radius of sigma in the order-k complex: the max miniball radius over its k-subsets (its own miniball when |sigma| <= k). Monotone under faces.";

BallIntersectionFiltration::usage = "BallIntersectionFiltration[data, radii, k] returns association r -> BallIntersectionComplex[data, r, k] over the sorted radii, ready for PersistenceIntervals.";

CechFiltration::usage = "CechFiltration[data, radii] = BallIntersectionFiltration[data, radii, Infinity].";

BallIntersectionBifiltration::usage = "BallIntersectionBifiltration[data, radii, orders] returns the (r, k) object as association k -> (association r -> complex); for fixed r the nesting C^(k) contains C^(k+1) as k grows, saturating to Cech at k = d + 1 for convex balls (Helly).";

FormValue::usage = "FormValue[w, v, tuple] gives the value of the germ of form w at vertex v on a tuple of neighbours of v, alternating in the tuple.";

CochainValue::usage = "CochainValue[a, tuple] gives the value of the ALTERNATING cochain a on an arbitrary vertex tuple, by the sign of the permutation taking it to increasing order; 0 off the complex. Do not apply it to the output of OrderedCochainCup or CochainCupOne, which are ordered cochains.";

OrderedCochainValue::usage = "OrderedCochainValue[a, tuple] gives the value of the ORDERED cochain a on an increasing vertex tuple, 0 off the complex, and Missing[\"NonIncreasingTuple\", tuple] otherwise. This is the correct accessor for the output of OrderedCochainCup and CochainCupOne.";

FormDegree::usage = "FormDegree[w] gives the degree of form w, read off a stored germ.";

CochainDegree::usage = "CochainDegree[a] gives the degree of cochain a: one less than the number of vertices of a stored cell.";

ZeroForm::usage = "ZeroForm[g, f] is the vertex function f (an association or a function) as a 0-form on g.";

RestrictionMap::usage = "RestrictionMap[g, a] is the form R a obtained from the alternating cochain a by reading it with the base vertex prepended; it vanishes off cliques.";

IntegrationMap::usage = "IntegrationMap[g, w] is the alternating cochain I w obtained by averaging the germs of w over the vertices of each clique with the orientation sign. I is a left inverse of RestrictionMap and a chain map.";

Coboundary::usage = "Coboundary[g, a] is the coboundary of cochain a: the alternating sum over the faces of every clique one dimension up. It agrees on the alternating and the ordered convention.";

FormDifferential::usage = "FormDifferential[g, w] is the differential of form w: the graph gradient on 0-forms, and on 1-forms the difference of germ values corrected by the transport term from the neighbouring germs.";

NaiveDifferential::usage = "NaiveDifferential[g, w] is the differential of the 1-form w with the transport term dropped; integrating it loses the factor (k+1)/(k+2).";

FormWedge::usage = "FormWedge[w, e] is the wedge product of forms, the exterior product on each tangent fiber. It is strictly associative and graded-commutative, but its differential fails Leibniz.";

CochainCup::usage = "CochainCup[g, a, b] is the cup product of ALTERNATING cochains: the full antisymmetrisation of the Alexander-Whitney formula over the (p+q+1)! orderings of each clique. It needs no vertex order, is unital, graded-commutative and a derivation for the coboundary, and is NOT associative; its 1/(p+q+1)! normalisation is the one agreeing with the cup product on cohomology. For the associative Alexander-Whitney formula use OrderedCochainCup.";

OrderedCochainCup::usage = "OrderedCochainCup[g, a, b] is the bare Alexander-Whitney cup product of ORDERED cochains, a(v0..vp) b(vp..v_{p+q}) on each increasing clique. Associative and unital but not graded-commutative, and well defined only in the ordered convention: the Alexander-Whitney cup of two alternating cochains is not alternating, so read the result with OrderedCochainValue. It is what the Steenrod tower and the A-infinity comparison need.";

CochainCupOne::usage = "CochainCupOne[g, a, b] is the Steenrod cup-1 product of ORDERED cochains. For closed a and b it is a primitive for the graded commutator: Coboundary[g, CochainCupOne[g, a, b]] equals OrderedCochainCup[g, a, b] - (-1)^(p q) OrderedCochainCup[g, b, a]. It vanishes when a has degree 0.";

AntisymmetrizedCup::usage = "AntisymmetrizedCup[g, a, b] is an alias of CochainCup, the name the antisymmetrised product carried before it became the cup product.";

InfraFibration::usage = "InfraFibration[total, proj] is a fibration of graphs: the total graph with its projection to the base, an association or a function on the vertices of total.\nInfraFibration[fib] gives the construction fib, such as InfraTangentBundle[g, r], as a literal InfraFibration, computing its total graph once.";
InfraTotalGraph::usage = "InfraTotalGraph[fib] gives the total graph of the fibration fib.";
InfraFibrationAssociation::usage = "InfraFibrationAssociation[fib] gives the projection of fib as an association <|x -> p, ...|> from total vertices to base vertices.";
InfraBaseGraph::usage = "InfraBaseGraph[fib] gives the base graph of fib: the projected vertices, p and q adjacent iff some total edge projects onto {p, q}.";
InfraFiber::usage = "InfraFiber[fib, p] gives the fiber over the base vertex p, the subgraph of the total graph on the vertices projecting to p.";
InfraFibers::usage = "InfraFibers[fib] gives the association <|p -> fiber, ...|> of the fibers of fib over every base vertex.";
InfraFibrationQ::usage = "InfraFibrationQ[fib] tests the edge lifting property: every total vertex over p has a neighbour over every base neighbour of p.";
InfraFiberBundleQ::usage = "InfraFiberBundleQ[fib] tests whether fib is a fiber bundle: isomorphic fibers, exactly one lift of each base edge at each vertex, trivial over every ball of radius 1.";
RandomInfraFibration::usage = "RandomInfraFibration[base] gives a random InfraFibration over base, each fiber drawn around its base vertex. Options \"VerticalVertices\", \"VerticalEdges\", \"HorizontalEdgesRadius\", \"HorizontalEdgesDensity\", \"IsomorphicFibers\".";
InfraBundleMorphismQ::usage = "InfraBundleMorphismQ[fib1, fib2, F, f] tests whether F maps total vertices of fib1 to total vertices of fib2 over f, and edges to edges or vertices; f defaults to Identity.";
InfraSection::usage = "InfraSection[s] is a section of a fibration, the association s from base vertices to total vertices over them; it carries no graph.";
InfraSectionQ::usage = "InfraSectionQ[fib, InfraSection[s]] tests whether s[p] lies over p for every key p of s.";
InfraContinuousSectionQ::usage = "InfraContinuousSectionQ[fib, InfraSection[s]] tests whether s is a section of fib mapping every base edge between its keys to a total edge.";
RandomInfraSection::usage = "RandomInfraSection[fib] gives an InfraSection choosing a random total vertex in every fiber of fib.";
FindInfraSection::usage = "FindInfraSection[fib, n] gives n continuous sections of fib over the whole base, as InfraSection objects.";
InfraConnection::usage = "InfraConnection[edges] is a connection: horizontal edges of the total graph chosen as lifts, at most one per fiber vertex and base neighbour, every existing lift chosen.";
InfraConnectionQ::usage = "InfraConnectionQ[fib, InfraConnection[edges]] tests whether edges are horizontal total edges giving exactly one lift wherever the total graph has one.";
InfraFlatConnectionQ::usage = "InfraFlatConnectionQ[fib, conn] tests whether conn is a connection whose horizontal leaves, the components of its edges, each project injectively to the base.";
RandomInfraConnection::usage = "RandomInfraConnection[fib] gives an InfraConnection from a random maximum matching of the total edges over every base edge.";
FindInfraHorizontalLift::usage = "FindInfraHorizontalLift[fib, conn, x, walk, n] gives n lifts of the base walk along the edges of conn, each starting at the total vertex x.";
InfraParallelTransport::usage = "InfraParallelTransport[fib, conn, walk] gives the transport <|x -> y, ...|> along walk of the fiber over its first vertex; blocked vertices are dropped.\nInfraParallelTransport[InfraDisplacementBundle[g, r], walk] gives the Levi-Civita transports along walk, a list with one transport for each choice among the best angle-isometries over its edges. Option Method (\"Arclength\", \"Alexandrov\").";
InfraHolonomy::usage = "InfraHolonomy[fib, conn, loop] gives the transport around a closed walk as Cycles on the positions of the fiber over its first vertex.";
InfraRays::usage = "InfraRays[g, p, r] gives the rays of length r from p: the walks {p, u1, ..., ur} with d(p, ui) = i.";
InfraTangentBundle::usage = "InfraTangentBundle[g, r] is the tangent bundle of g at scale r: the total vertices are the rays of length r, projected to their first vertex, two rays adjacent iff at every position their vertices are equal or adjacent.";
InfraCotangentBundle::usage = "InfraCotangentBundle[g, r] is the cotangent bundle of g at scale r: the total vertices are the reversed rays of length r, projected to their last vertex, with the adjacency of InfraTangentBundle.";
InfraDisplacementBundle::usage = "InfraDisplacementBundle[g, r] is the displacement bundle of g at scale r: the total vertices are the pairs {p, v} with d(p, v) = r, projected to p, two pairs adjacent iff their base points and their endpoints are equal or adjacent.";
InfraBundleMorphism::usage = "InfraBundleMorphism[fib1, fib2] gives the natural bundle morphism from fib1 to fib2 over the identity: the endpoint map from InfraTangentBundle to InfraDisplacementBundle, the truncation from scale r to s < r, the reversal between InfraTangentBundle and InfraCotangentBundle.";
FindInfraLeviCivitaConnection::usage = "FindInfraLeviCivitaConnection[InfraDisplacementBundle[g, r]] gives the Levi-Civita InfraConnection: over each edge p -> q of g the first of the best angle-isometries from the directions at p to those at q fixing the geodesics through q, its lifts that are not total edges dropped. Option Method (\"Arclength\", \"Alexandrov\").";
InfraHolonomyAngle::usage = "InfraHolonomyAngle[InfraDisplacementBundle[g, r], conn, loop] gives the unsigned rotation angle of the directions around loop under conn: the mean angle between each moved direction and its image, in arc radians.\nInfraHolonomyAngle[InfraDisplacementBundle[g, r], loop] gives the least such angle over the Levi-Civita transports of InfraParallelTransport. Option Method (\"Arclength\", \"Alexandrov\").";
InfraCovariantDerivative::usage = "InfraCovariantDerivative[InfraDisplacementBundle[g, r], conn, InfraSection[s], walk] gives <|p -> x, ...|>: for each step p -> q of walk, conn carries s[q] back to p, the arrow from s[p] to that image is carried to p by the Levi-Civita transports at its own length, and x is the endpoint nearest to p, x == p for zero. The arrow is carried by the Levi-Civita transports whatever conn is. Option Method.";
InfraCanonicalOneForm::usage = "InfraCanonicalOneForm[g, {x, ..., v}, {y, ...}] gives the canonical 1-form at the vector x -> v on the step to y: the pairing (d(x,v)^2 + d(x,y)^2 - d(v,y)^2)/2.";
InfraFiberedSubstrate::usage = "InfraFiberedSubstrate[name, size] is the named example fibration at size \"Small\", \"Medium\" or \"Large\", or at a raw spec of its base (a cycle length, grid or torus dimensions, a mesh size): a construction head InfraTangentBundle[g, 2] or InfraDisplacementBundle[g, 1] over a base taken from InfraSubstrate where one exists, or a literal InfraFibration whose total vertices {p, k} sit on a small circle around their base vertex p. InfraFiberedSubstrate[] lists the roster by group (\"Trivial\" -- products; \"Covering\" -- twisted double covers and the Moebius ladder; \"Tangent\" and \"Displacement\" -- the two bundles over a grid, a triangular torus, the octahedron and a sphere mesh; \"NonBundle\" -- fibrations with non-isomorphic fibers); InfraFiberedSubstrate[All] is the flat name list; InfraFiberedSubstrate[name] is the \"Medium\" size. The octahedron has one size.";
