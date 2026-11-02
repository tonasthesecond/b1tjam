class_name DevoteeDetector
extends Detector


func get_detected() -> Devotee:
	var detected := super()
	if detected != null:
		return detected as Devotee
	return null
