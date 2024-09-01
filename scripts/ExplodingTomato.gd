extends Node2D

@onready var animation = $Tomato/AnimationPlayer
@onready var boss = $"../Boss"

signal boss_death_done

func _on_boss_defeated() -> void:
	show()
	position = boss.position
	animation.play("die")


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "die":
		emit_signal("boss_death_done")
