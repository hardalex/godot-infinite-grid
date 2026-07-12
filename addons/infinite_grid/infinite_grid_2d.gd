extends ColorRect
## InfiniteGrid2D: full-viewport quad shader grid for Camera2D.
##
## Place it in a CanvasLayer so the quad stays screen-aligned. The shader maps
## screen pixels back to Camera2D world coordinates and draws the grid on the GPU.

const GRID_SHADER := preload("res://addons/infinite_grid/infinite_grid_2d.gdshader")

@export var follow_viewport_camera := true
@export var grid_origin := Vector2.ZERO:
  set(value):
    grid_origin = value
    _set_shader_parameter(&"grid_origin", grid_origin)
@export var cell_size := 10.0:
  set(value):
    cell_size = maxf(value, 0.0001)
    _set_shader_parameter(&"cell_size", cell_size)
@export var min_pixels_between_cells := 2.0:
  set(value):
    min_pixels_between_cells = maxf(value, 0.1)
    _set_shader_parameter(&"min_pixels_between_cells", min_pixels_between_cells)
@export var line_width_pixels := 1.0:
  set(value):
    line_width_pixels = maxf(value, 0.25)
    _set_shader_parameter(&"line_width_pixels", line_width_pixels)
@export var lod_finer_levels := 3:
  set(value):
    lod_finer_levels = maxi(value, 0)
    _apply_lod_range_parameters()
@export var lod_total_levels := 8:
  set(value):
    lod_total_levels = maxi(value, 3)
    _apply_lod_range_parameters()
@export var thin_line_color := Color(0.30, 0.30, 0.30, 0.50):
  set(value):
    thin_line_color = value
    _set_shader_parameter(&"thin_line_color", thin_line_color)
@export var thick_line_color := Color(0.42, 0.42, 0.42, 0.70):
  set(value):
    thick_line_color = value
    _set_shader_parameter(&"thick_line_color", thick_line_color)
@export var debug_lod_colors := false:
  set(value):
    debug_lod_colors = value
    _set_shader_parameter(&"debug_lod_colors", debug_lod_colors)

var _shader_material: ShaderMaterial
var _last_viewport_size := Vector2.ZERO
var _last_camera_position := Vector2.INF
var _last_camera_zoom := Vector2.INF
var _last_camera_rotation := INF


func _ready() -> void:
  color = Color.TRANSPARENT
  mouse_filter = Control.MOUSE_FILTER_IGNORE
  set_anchors_preset(Control.PRESET_FULL_RECT)
  offset_left = 0.0
  offset_top = 0.0
  offset_right = 0.0
  offset_bottom = 0.0

  _ensure_shader_material()
  _apply_shader_parameters()
  _update_viewport_size(true)
  _update_camera_parameters(true)


func _process(_delta: float) -> void:
  _update_viewport_size(false)
  _update_camera_parameters(false)


func set_camera_state(camera_position: Vector2, camera_zoom: Vector2, camera_rotation := 0.0) -> void:
  _set_camera_parameters(camera_position, camera_zoom, camera_rotation, true)


func _ensure_shader_material() -> void:
  _shader_material = material as ShaderMaterial
  if _shader_material != null:
    return

  _shader_material = ShaderMaterial.new()
  _shader_material.shader = GRID_SHADER
  material = _shader_material


func _apply_shader_parameters() -> void:
  if _shader_material == null:
    return

  _shader_material.set_shader_parameter("grid_origin", grid_origin)
  _shader_material.set_shader_parameter("cell_size", cell_size)
  _shader_material.set_shader_parameter("min_pixels_between_cells", min_pixels_between_cells)
  _shader_material.set_shader_parameter("line_width_pixels", line_width_pixels)
  _apply_lod_range_parameters()
  _shader_material.set_shader_parameter("debug_lod_colors", debug_lod_colors)
  _shader_material.set_shader_parameter("thin_line_color", thin_line_color)
  _shader_material.set_shader_parameter("thick_line_color", thick_line_color)


func _apply_lod_range_parameters() -> void:
  if _shader_material == null:
    return

  var min_lod_power := -float(maxi(lod_finer_levels, 0))
  var max_lod_power := min_lod_power + float(maxi(lod_total_levels, 3) - 1)
  _shader_material.set_shader_parameter("min_lod_power", min_lod_power)
  _shader_material.set_shader_parameter("max_lod_power", max_lod_power)


func _update_viewport_size(force: bool) -> void:
  var viewport_size := get_viewport_rect().size
  if not force and viewport_size.is_equal_approx(_last_viewport_size):
    return

  _last_viewport_size = viewport_size
  _set_shader_parameter(&"viewport_size", viewport_size)


func _update_camera_parameters(force: bool) -> void:
  if not follow_viewport_camera:
    return

  var camera := get_viewport().get_camera_2d()
  if camera == null:
    _set_camera_parameters(Vector2.ZERO, Vector2.ONE, 0.0, force)
    return

  _set_camera_parameters(camera.get_screen_center_position(), camera.zoom, camera.global_rotation, force)


func _set_camera_parameters(camera_position: Vector2, camera_zoom: Vector2, camera_rotation: float, force: bool) -> void:
  if (
      not force and
      camera_position.is_equal_approx(_last_camera_position) and
      camera_zoom.is_equal_approx(_last_camera_zoom) and
      is_equal_approx(camera_rotation, _last_camera_rotation)
  ):
    return

  _last_camera_position = camera_position
  _last_camera_zoom = camera_zoom
  _last_camera_rotation = camera_rotation
  _set_shader_parameter(&"camera_position", camera_position)
  _set_shader_parameter(&"camera_zoom", camera_zoom)
  _set_shader_parameter(&"camera_rotation", camera_rotation)


func _set_shader_parameter(parameter_name: StringName, value: Variant) -> void:
  if _shader_material == null:
    return

  _shader_material.set_shader_parameter(parameter_name, value)
