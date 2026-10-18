---
Template: Symbol
Name: InfraScenePlot
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraScenePlot
Keywords: [scene, static, plot, representative, segment, family]
SeeAlso: [InfraScene, InfraSceneInstance, RandomInfraInstance, InfraSubstrateHighlight, InfraSceneViewer, InfraSegment, InfraWalk]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraScenePlot]()[*scene*, *graph*, *instance*]</code> draws the bound declared objects of *scene* in the saved *instance* on *graph*.

<code>[InfraScenePlot]()[*scene*, *graph*, *instance*, *objects*]</code> draws the specified list of objects, resolving their names from *instance*.

<!-- #| annotation: 26.10.18: A concrete sampled binding and its mathematical construction family are different display objects. This adapter adds presentation only; scene sampling, assertion evaluation and interactive exploration remain separate. -->

## Details & Options

- The result is a static [Graph](). The instance has the form <code>[InfraSceneInstance]()[*bindings*]</code>. A fourth positional [List]() denotes display objects; supply default-form options as a sequence of rules.
- The default display follows declaration order, omits unbound objects and excludes extra initial bindings. Explicitly requested unresolved names remain unevaluated.
- A named side draws its saved walk. An explicit <code>[InfraSegment]()[*a*, *b*]</code> draws all shortest paths between its saved endpoint values. Further assertions on the sampled side are not reapplied to this family.
- Object kinds come from the scene declarations. Literal vertex labels and saved values are preserved; an undeclared list binding needs an explicit interpretation such as [InfraWalk]().
- Plotting uses [InfraSubstrateHighlight]() without solving the scene or choosing representatives, and preserves the ambient random state. [InfraSceneViewer]() provides interactive exploration.
- Styling uses the [InfraSubstrateHighlight]() grammar: [Directive]() items, <code>[Style]()[*object*, *directives*]</code> and object-style rules. Style payloads are left unchanged.

| Option | Default | Description |
|---|---|---|
| Options of [InfraSubstrateHighlight]() | inherited | Density styling and [HighlightGraph]() options; the first duplicate option takes precedence |

## Basic Examples

Draw the saved point and selected side:

```wl
SeedRandom[ 101 ];
ClearAll[ a, b, ab ];
With[
	{ g = GridGraph[ { 3, 3 } ] },
	{ scene = InfraScene[ { a, b, ab }, { a == InfraPoint[ ], b == InfraPoint[ ], ab == InfraSegment[ a, b ] } ] },
	{ instance = InfraSceneInstance[ <| a -> 1, b -> 9, ab -> { 1, 2, 3, 6, 9 } |> ] },
	InfraScenePlot[ scene, g, instance ] ]
```
<!-- => a Graph highlighting the saved two points and four-edge side -->


---

Compare one saved path with the complete segment at the same endpoints:

```wl
SeedRandom[ 101 ];
ClearAll[ a, b, ab ];
With[
	{ g = GridGraph[ { 3, 3 } ] },
	{ scene = InfraScene[ { a, b, ab }, { a == InfraPoint[ ], b == InfraPoint[ ], ab == InfraSegment[ a, b ] } ] },
	{ instance = InfraSceneInstance[ <| a -> 1, b -> 9, ab -> { 1, 2, 3, 6, 9 } |> ] },
	GraphicsRow[ {
		InfraScenePlot[ scene, g, instance, { ab, a, b } ],
		InfraScenePlot[ scene, g, instance, { InfraSegment[ a, b ], a, b } ] } ] ]
```
<!-- => a GraphicsRow containing the saved-path and complete-segment graphs -->


## Scope

A partial instance can draw a family before any side is selected:

```wl
SeedRandom[ 101 ];
ClearAll[ a, b, ab ];
With[
	{ g = GridGraph[ { 3, 3 } ] },
	{ scene = InfraScene[ { a, b, ab }, { a == InfraPoint[ ], b == InfraPoint[ ], ab == InfraSegment[ a, b ] } ] },
	{ instance = InfraSceneInstance[ <| a -> 1, b -> 9 |> ] },
	InfraScenePlot[ scene, g, instance, { InfraSegment[ a, b ], a, b } ] ]
```
<!-- => a Graph highlighting the complete segment at the saved points -->


---

The default display skips the unbound side:

```wl
SeedRandom[ 101 ];
ClearAll[ a, b, ab ];
With[
	{ g = GridGraph[ { 3, 3 } ] },
	{ scene = InfraScene[ { a, b, ab }, { a == InfraPoint[ ], b == InfraPoint[ ], ab == InfraSegment[ a, b ] } ] },
	InfraScenePlot[ scene, g, InfraSceneInstance[ <| a -> 1, b -> 9 |> ] ] ]
```
<!-- => a Graph highlighting only the two bound points -->


---

A requested side without a saved value remains unevaluated:

```wl
ClearAll[ a, b, ab ];
With[
	{ scene = InfraScene[ { a, b, ab }, { a == InfraPoint[ ], b == InfraPoint[ ], ab == InfraSegment[ a, b ] } ] },
	InfraScenePlot[ scene, PathGraph[ Range[ 3 ] ], InfraSceneInstance[ <| a -> 1, b -> 3 |> ], { ab } ] ]
```
<!-- => the requested missing-side expression, unevaluated -->


## Options

Apply object styles and ordinary graph options:

```wl
SeedRandom[ 101 ];
ClearAll[ a, b ];
With[
	{ g = GridGraph[ { 3, 3 } ] },
	{ scene = InfraScene[ { a, b }, { a == InfraPoint[ ], b == InfraPoint[ ] } ] },
	{ instance = InfraSceneInstance[ <| a -> 1, b -> 9 |> ] },
	InfraScenePlot[ scene, g, instance, {
		Directive[ StandardBlue ], InfraSegment[ a, b ],
		Style[ a, StandardRed, AbsolutePointSize[ 8 ] ], b -> StandardGreen },
		"OpacityRange" -> { 0.2, 1 }, ImageSize -> 300, PlotLabel -> "Fixed endpoints" ] ]
```
<!-- => a Graph with the requested object styles, image size and plot label -->


## Properties and Relations

An explicit empty list draws the substrate without highlights:

```wl
SeedRandom[ 101 ];
ClearAll[ a ];
With[
	{ scene = InfraScene[ { a }, { a == InfraPoint[ ] } ] },
	InfraScenePlot[ scene, CycleGraph[ 4 ], InfraSceneInstance[ <| a -> 1 |> ], { } ] ]
```
<!-- => the unhighlighted four-cycle Graph -->

