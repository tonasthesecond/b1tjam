class_name LifeBar
extends TextureProgressBar


func _ready() -> void:
	var devotee: Devotee = Locator.ref(Locator.ID.Devotee)
	devotee.data.life.value_changed.connect(_on_life_changed)


func _on_life_changed(new_current: float, new_max: float) -> void:
	value = new_current
	max_value = new_max

	$Label.text = str(new_current) + " / " + str(new_max)
