class_name ItemDetector
extends Detector


func get_detected() -> Item:
	var detected := super()
	if detected != null:
		return detected as Item
	return null
