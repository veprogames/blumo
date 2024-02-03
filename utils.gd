class_name Utils
extends Object

static func sum(array: Array) -> Variant:
	if len(array) == 0:
		return null
	
	var result: Variant = array[0]
	for i: int in range(1, len(array)):
		result += array[i]
	return result
