class_name FlashComponent
extends Node

const FLASH_MATERIAL = preload("res://effects/white_flash_material.tres")

@export var sprites: Array[CanvasItem]
@export var flash_duration: = 0.2

var flash_material: Material
var original_sprite_materials: Array[Material]
var timer: Timer = Timer.new()

func _ready() -> void:
	add_child(timer)
	flash_material = FLASH_MATERIAL.duplicate()
	for sprite: CanvasItem in sprites:
		original_sprite_materials.append(sprite.material)


func flash(color: Color = Color.BLACK):
	for sprite: CanvasItem in sprites:
		sprite.material = flash_material
		sprite.material.set("shader_parameter/color", Vector3(color.r, color.g, color.b))
	
	timer.start(flash_duration)
	timer.timeout.connect(
		func():
			for i: int in len(sprites):
				sprites[i].material = original_sprite_materials[i]
	, CONNECT_ONE_SHOT
	)
