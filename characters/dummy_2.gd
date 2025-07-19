class_name Dummy2
extends StaticBody2D

@export var target: Node2D
@export var stats: CharacterStats

@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var floating_text_manager_component: FloatingTextManagerComponent = $FloatingTextManagerComponent
@onready var bullet_spawner_component: SpawnerComponent = $BulletSpawnerComponent
@onready var bullet_spawn_timer: Timer = $BulletSpawnerComponent/BulletSpawnTimer

func _ready() -> void:
	hurtbox_component.hurt.connect(
		func(hitbox: HitboxComponent) -> void:
			floating_text_manager_component.show_value(hitbox.damage)
			get_tree().create_timer(0.4).timeout.connect(
				func():
					stats.health += hitbox.damage
			)
	)
	
	bullet_spawn_timer.timeout.connect(_spawn_bullet)


func start_attacking() -> void:
	bullet_spawn_timer.start()


func _spawn_bullet() -> void:
	var bullet_move_component := bullet_spawner_component.spawn().move_component as MoveComponent
	bullet_move_component.owner.look_at(target.global_position)
	bullet_move_component.velocity = (target.global_position - global_position).normalized() * 600
