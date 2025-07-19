class_name DoorComponent
extends Node

@export var closed_tile_coordinate := Vector2i(11, 0)
@export var open_tile_coordinate := Vector2i(11, 2)
@export var tilemap_layer: TileMapLayer
@export var tile_coordinate: Vector2i


func open() -> void:
	tilemap_layer.set_cell(tile_coordinate, 0, open_tile_coordinate)


func close() -> void:
	tilemap_layer.set_cell(tile_coordinate, 0, closed_tile_coordinate)
