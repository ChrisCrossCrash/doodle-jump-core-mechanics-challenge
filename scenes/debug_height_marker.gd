class_name DebugHeightMarker
extends Node2D
## Debug overlay node that labels a horizontal gridline with its world-space Y coordinate.

@onready var _label: Label = $Label


func _ready() -> void:
    _label.text = str(position.y)
