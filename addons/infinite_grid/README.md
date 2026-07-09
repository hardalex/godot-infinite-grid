# Infinite Grid

Reusable 2D and 3D infinite grid components for Godot 4.x.

The grid is shader-driven, keeps line widths stable in screen space, fades between LOD levels, and follows the active camera so it appears endless without generating large geometry.

## Features

- `InfiniteGrid3D`: an XZ ground grid rendered from a small procedural mesh.
- `InfiniteGrid2D`: a full-viewport `ColorRect` grid for `Camera2D` scenes.
- Smooth LOD transitions for zooming or camera distance changes.
- Screen-space line width and anti-aliasing.
- Configurable cell size, colors, opacity, and debug LOD coloring.
- No external runtime dependencies.

## Requirements

- Godot 4.x

## Installation

Copy this folder to your project:

```text
res://addons/infinite_grid/
```

No plugin activation is required. Instance the provided scenes directly.

## Quick start

Open one of the included example scenes:

- `res://addons/infinite_grid/examples/scene-3d.tscn`
- `res://addons/infinite_grid/examples/scene-2d.tscn`

## Usage

### InfiniteGrid3D

Instance the reusable scene:

```text
res://addons/infinite_grid/infinite_grid_3d.tscn
```

Add it to a 3D scene with a `Camera3D`. By default, the grid follows the active viewport camera on the XZ plane.

Useful exported properties:

| Property | Default | Description |
| --- | ---: | --- |
| `follow_viewport_camera` | `true` | Keep the grid centered under the active camera. |
| `grid_size` | `2000.0` | Size of the finite mesh used for the visible grid area. |
| `cell_size` | `1.0` | Base grid cell size in world units. |
| `min_pixels_between_cells` | `2.0` | Minimum spacing before the shader switches LOD. |
| `line_width_pixels` | `1.0` | Grid line width in screen pixels. |
| `lod_finer_levels` | `3` | Number of LOD levels finer than `cell_size`. |
| `lod_total_levels` | `8` | Total number of LOD levels. |
| `debug_lod_colors` | `false` | Show LOD layers as blue, green, and red. |
| `enable_grazing_opacity` | `true` | Fade the grid at shallow viewing angles. |
| `thin_line_color` | gray | Color for minor grid lines. |
| `thick_line_color` | gray | Color for major grid lines. |

Runtime helpers:

```gdscript
$InfiniteGrid3D.set_grid_size(4000.0)
$InfiniteGrid3D.set_cell_size(0.5)
$InfiniteGrid3D.follow_camera($Camera3D)
```

### InfiniteGrid2D

Instance the reusable scene:

```text
res://addons/infinite_grid/infinite_grid_2d.tscn
```

Place it inside a `CanvasLayer` so it stays screen-aligned. Use a low layer value if the grid should render behind the game UI or world overlays:

```text
CanvasLayer
  InfiniteGrid2D
```

By default, it reads the active viewport `Camera2D`. If you want to drive it manually, disable `follow_viewport_camera` and call `set_camera_state()`:

```gdscript
$GridLayer/InfiniteGrid2D.follow_viewport_camera = false
$GridLayer/InfiniteGrid2D.set_camera_state(camera_position, camera_zoom, camera_rotation)
```

Useful exported properties:

| Property | Default | Description |
| --- | ---: | --- |
| `follow_viewport_camera` | `true` | Read the active `Camera2D` every frame. |
| `grid_origin` | `(0, 0)` | World-space origin of the grid. |
| `cell_size` | `10.0` | Base grid cell size in world units. |
| `min_pixels_between_cells` | `3.0` | Minimum spacing before the shader switches LOD. |
| `line_width_pixels` | `1.0` | Grid line width in screen pixels. |
| `lod_finer_levels` | `3` | Number of LOD levels finer than `cell_size`. |
| `lod_total_levels` | `8` | Total number of LOD levels. |
| `debug_lod_colors` | `false` | Show LOD layers as blue, green, and red. |
| `thin_line_color` | gray | Color for minor grid lines. |
| `thick_line_color` | gray | Color for major grid lines. |

## Examples

- `examples/scene-3d.tscn`: shows `InfiniteGrid3D` in a 3D scene with an editor-style free camera.
- `examples/scene-2d.tscn`: shows `InfiniteGrid2D` in a 2D camera scene with pan and zoom controls.

## License

MIT License. See [LICENSE](LICENSE).
