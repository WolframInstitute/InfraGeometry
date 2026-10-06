---
Template: Symbol
Name: InfraSubstrateStyle
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSubstrateStyle
Keywords: [substrate, backdrop, style, vertex size, opacity, drawing]
SeeAlso: [InfraSubstrate, InfraSubstrateCode, InfraSubstrateHighlight]
RelatedGuides: [InfraSubstrates]
---

## Usage

<code>[InfraSubstrateStyle]()[*size*]</code> gives the list of [Graph]() options a substrate of size *size* is drawn with: `"Small"`, `"Medium"` or `"Large"`, and `"Default"` for none.

<code>[InfraSubstrateStyle]()[*name*, *size*]</code> gives the style of the named substrate at *size*.

<code>[InfraSubstrateStyle]()[]</code> lists the styles, the default ones and the custom ones. <code>[InfraSubstrateStyle]()[All]</code> gives them as one list.

## Details & Options

A substrate is a backdrop: the construction drawn on it carries the colour. The style draws the substrate in gray, [StandardGray]() edges and faintly filled vertex disks with a dark outline, lighter as the substrate grows.

| *size* | Edge opacity | Vertex opacity | Vertex size |
|---|---|---|---|
| `"Small"` | 0.35 | 0.5 | 0.013 |
| `"Medium"` | 0.3 | 0.45 | 0.009 |
| `"Large"` | 0.22 | 0.33 | 0.006 |

The vertex size is a fraction of the diagonal of the drawing, so a vertex stays one small dot however many vertices the substrate has.

Every named substrate takes the style of its size. A custom look for one substrate is one more definition <code>[InfraSubstrateStyle]()[*name*, *size*] = …</code>, and the listing then shows it under `"Custom"`.

To draw a graph of one's own like a substrate, splice the style into it: <code>[Graph]()[*g*, [Sequence]() @@ [InfraSubstrateStyle]()[*size*]]</code>.

## Basic Examples

A ball of the hyperbolic tiling by squares, five at every vertex, with no style and in the three styles.

```wl
With[
  {g = TessellationNeighborhoodGraph[{4, 5}, 4]},
  GraphicsRow @ Table[Graph[g, Sequence @@ InfraSubstrateStyle[style]], {style, {"Default", "Small", "Medium", "Large"}}]]
```

The small style, beside the ball drawn in it.

```wl
With[
  {g = TessellationNeighborhoodGraph[{4, 5}, 4]},
  {Graph[g, Sequence @@ InfraSubstrateStyle["Small"]], InfraSubstrateStyle["Small"]}]
```

## Scope

The listing: four default styles and no custom one.

```wl
With[
  {g = TessellationNeighborhoodGraph[{3, 7}, 3]},
  {GraphicsRow @ Table[Graph[g, Sequence @@ InfraSubstrateStyle[style]], {style, InfraSubstrateStyle[All]}], Normal @ InfraSubstrateStyle[]}]
```

A named substrate takes the style of its size.

```wl
With[
  {g = TessellationNeighborhoodGraph[{3, 7}, 3]},
  {Graph[g, Sequence @@ InfraSubstrateStyle["HyperbolicTilingGraph", "Small"]],
   InfraSubstrateStyle["HyperbolicTilingGraph", "Small"] === InfraSubstrateStyle["Small"]}]
```

## Properties and Relations

[InfraSubstrate]() draws a substrate with the style of its size spliced into its drawing with no style.

```wl
With[
  {plain = InfraSubstrate["SquareTilingGraph", "Small", "Default", "KeepCoordinates" -> True]},
  {styled = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {GraphicsRow[{plain, styled}], styled === Graph[plain, Sequence @@ InfraSubstrateStyle["Small"]]}]
```

A substrate at a raw size takes the style of the size its vertex count falls in: up to 250 vertices small, up to 800 medium, more large. The square tiling cut at radius 7, 15 and 25, its vertex counts and vertex sizes:

```wl
With[
  {tilings = Table[InfraSubstrate["SquareTilingGraph", radius, "KeepCoordinates" -> True], {radius, {7, 15, 25}}]},
  {GraphicsRow[tilings], VertexCount /@ tilings, Options[#, VertexSize] & /@ tilings}]
```
