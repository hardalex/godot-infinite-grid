# Godot Infinite Grid

Reusable infinite grid components for Godot 4.x, with ready-to-run 2D and 3D example scenes.

The project contains shader-driven grids that keep line widths stable in screen space, fade between LOD levels, and follow the active camera so the grid appears endless without generating large geometry.

## Features

- `InfiniteGrid3D`: an XZ ground grid rendered from a small procedural mesh.
- `InfiniteGrid2D`: a full-viewport `ColorRect` grid for `Camera2D` scenes.
- Smooth LOD transitions for zooming or camera distance changes.
- Screen-space line width and anti-aliasing.
- Configurable cell size, colors, opacity, and debug LOD coloring.
- HiDPI-aware example scenes targeting a 1280x720 design viewport.
- No external runtime dependencies.

## Requirements

- Godot 4.x

The project is configured for D3D12 on Windows, but the grid components are plain GDScript scenes and shaders.

## Quick start

Open the project in Godot and run one of the example scenes:

- `res://examples/scene-3d.tscn`
- `res://examples/scene-2d.tscn`

The default main scene is:

```text
res://examples/scene-3d.tscn
```

## Using `InfiniteGrid3D`

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

## Using `InfiniteGrid2D`

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

## Example controls

### 3D scene

The 3D example uses `res://entities/free_camera.tscn`, an editor-style debug camera.

| Action | Control |
| --- | --- |
| Orbit | Middle mouse drag |
| Pan | Shift + middle mouse drag |
| Zoom | Mouse wheel or Ctrl + middle mouse drag |
| Enter freelook | Hold right mouse button |
| Move in freelook | WASD, Q, E |
| Faster / slower freelook | Shift / Alt |
| Exit captured freelook | Esc |

### 2D scene

| Action | Control |
| --- | --- |
| Pan | Left or middle mouse drag |
| Zoom | Mouse wheel or trackpad gesture |

## Development

Initialize local tools and Git hooks:

```bash
just init
```

Common commands:

```bash
just test              # Run gdUnit4 tests if gdUnit4 is installed
just fmt               # Format GDScript outside addons/
just lint              # Lint GDScript outside addons/
just check             # Run formatting and lint checks
just release v1.0.0    # Create an annotated tag and GitHub Release
```

## Project structure

```text
addons/
  infinite_grid/
    infinite_grid_2d.tscn
    infinite_grid_2d.gd
    infinite_grid_2d.gdshader
    infinite_grid_3d.tscn
    infinite_grid_3d.gd
    infinite_grid_3d.gdshader
entities/
  free_camera.tscn
  free_camera.gd
examples/
  scene-2d.tscn
  scene-2d.gd
  scene-3d.tscn
  scene-3d.gd
project.godot
```

## License

MIT License. See [LICENSE](LICENSE).
