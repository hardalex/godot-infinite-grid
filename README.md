# Godot Infinite Grid

Reusable infinite grid components for Godot 4.x.

This repository is the development project for the `infinite_grid` addon. The addon provides shader-driven 2D and 3D grids that keep line widths stable in screen space, fade between LOD levels, and follow the active camera so the grid appears endless without generating large geometry.

## Features

- `InfiniteGrid3D` for editor-style ground grids in 3D scenes.
- `InfiniteGrid2D` for full-viewport grids in `Camera2D` scenes.
- Screen-space line width and anti-aliasing.
- Smooth decimal LOD transitions.
- Configurable cell size, colors, opacity, and debug LOD colors.
- No external runtime dependencies.

## Getting started

For installation, usage, and exported properties, see the addon README:

- [`addons/infinite_grid/README.md`](addons/infinite_grid/README.md)

## Examples

- `examples/scene-3d.tscn`: shows `InfiniteGrid3D` in a 3D scene with an editor-style free camera.
- `examples/scene-2d.tscn`: shows `InfiniteGrid2D` in a 2D camera scene with pan and zoom controls.

## Development

Initialize local tools and Git hooks:

```bash
just init
```

Common commands:

```bash
just test              # Run gdUnit4 tests if gdUnit4 is installed
just fmt               # Format project GDScript
just lint              # Lint project GDScript
just check             # Run formatting and lint checks
just changelog         # Generate CHANGELOG.md with cocogitto
just release v1.0.0    # Create an annotated tag, addon ZIP, and GitHub Release
```

## Project structure

```text
addons/
  infinite_grid/
    README.md
    LICENSE
    infinite_grid_2d.tscn
    infinite_grid_2d.gd
    infinite_grid_2d.gdshader
    infinite_grid_3d.tscn
    infinite_grid_3d.gd
    infinite_grid_3d.gdshader
examples/
  free_camera.tscn
  free_camera.gd
  logo-128.svg
  scene-2d.tscn
  scene-2d.gd
  scene-3d.tscn
  scene-3d.gd
project.godot
```

## License

MIT License. See [LICENSE](LICENSE).
