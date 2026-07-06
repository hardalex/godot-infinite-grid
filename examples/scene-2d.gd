extends Node2D
## InfiniteGrid2D example scene with a Camera2D pan/zoom controller.

const DESIGN_WIDTH := 1280
const DESIGN_HEIGHT := 720
const PAN_ZOOM_BASE := 1.05
const PAN_ZOOM_MAX_STEPS := 6.0
const MIN_ZOOM := 0.05
const MAX_ZOOM := 100.0

var _last_info_text := ""

@onready var _camera: Camera2D = $Camera2D
@onready var _info_label: Label = $UI/InfoLabel


func _ready() -> void:
  _initialize_window_size()
  _update_info_label()


func _process(_delta: float) -> void:
  _update_info_label()


func _input(event: InputEvent) -> void:
  if event is InputEventMouseButton:
    if event.button_index == MOUSE_BUTTON_WHEEL_UP:
      _zoom_at(event.position, 1.1)
    elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
      _zoom_at(event.position, 1.0 / 1.1)
  elif event is InputEventMouseMotion and (
      Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE) or
      Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
  ):
    _camera.position -= event.relative / _camera.zoom
  elif event is InputEventPanGesture:
    var zoom_steps := clampf(event.delta.y, -PAN_ZOOM_MAX_STEPS, PAN_ZOOM_MAX_STEPS)
    if not is_zero_approx(zoom_steps):
      _zoom_at(get_viewport().get_mouse_position(), pow(PAN_ZOOM_BASE, -zoom_steps))


func _draw() -> void:
  var font := ThemeDB.fallback_font
  draw_line(Vector2(-1000.0, 0.0), Vector2(1000.0, 0.0), Color(0.85, 0.20, 0.20, 0.95), 4.0, true)
  draw_line(Vector2(0.0, -1000.0), Vector2(0.0, 1000.0), Color(0.20, 0.55, 0.95, 0.95), 4.0, true)
  draw_circle(Vector2.ZERO, 5.0, Color.WHITE)

  for index in range(8):
    var angle := TAU * float(index) / 8.0
    var position := Vector2(cos(angle), sin(angle)) * 120.0
    draw_circle(position, 14.0, Color(1.0, 0.78, 0.20, 0.95))
    draw_string(font, position + Vector2(20.0, 4.0), "P%d" % index, HORIZONTAL_ALIGNMENT_LEFT, -1, 16)


func _zoom_at(screen_pos: Vector2, factor: float) -> void:
  var pre_zoom := _camera.zoom
  var next_zoom := clampf(_camera.zoom.x * factor, MIN_ZOOM, MAX_ZOOM)
  _camera.zoom = Vector2(next_zoom, next_zoom)
  _camera.position += (screen_pos - get_viewport_rect().size * 0.5) * (1.0 / pre_zoom.x - 1.0 / _camera.zoom.x)
  _update_info_label()


func _initialize_window_size() -> void:
  var dpi_scale := DisplayServer.screen_get_max_scale()
  get_window().size = Vector2i(roundi(DESIGN_WIDTH * dpi_scale), roundi(DESIGN_HEIGHT * dpi_scale))
  get_window().content_scale_size = Vector2i(DESIGN_WIDTH, DESIGN_HEIGHT)
  get_window().content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
  get_window().content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP


func _update_info_label() -> void:
  var text := "Camera2D  Pos: (%.1f, %.1f)  Zoom: %.3fx" % [_camera.position.x, _camera.position.y, _camera.zoom.x]
  if text == _last_info_text:
    return

  _info_label.text = text
  _last_info_text = text
