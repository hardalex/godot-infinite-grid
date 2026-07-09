extends Node3D
## Infinite grid example scene with the shared free camera.

const DESIGN_WIDTH := 1280
const DESIGN_HEIGHT := 720
const FreeCameraScript := preload("res://addons/infinite_grid/examples/free_camera.gd")

var _last_info_text := ""

@onready var _free_camera := $FreeCamera as FreeCameraScript
@onready var _info_label: Label = $UI/InfoLabel


func _ready() -> void:
  _initialize_window_size()
  _update_info_label()


func _process(_delta: float) -> void:
  _update_info_label()


func _input(event: InputEvent) -> void:
  if event.is_action_pressed(&"ui_cancel") and _free_camera.is_freelook_active():
    _free_camera.set_freelook_active(false)


func _initialize_window_size() -> void:
  var dpi_scale := DisplayServer.screen_get_max_scale()
  get_window().size = Vector2i(roundi(DESIGN_WIDTH * dpi_scale), roundi(DESIGN_HEIGHT * dpi_scale))
  get_window().content_scale_size = Vector2i(DESIGN_WIDTH, DESIGN_HEIGHT)
  get_window().content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
  get_window().content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP


func _update_info_label() -> void:
  var text: String = _free_camera.get_info_text()
  if text == _last_info_text:
    return

  _info_label.text = text
  _last_info_text = text
