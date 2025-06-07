class_name Utils
extends Object

static func sum(array: Array) -> Variant:
	if len(array) == 0:
		return null
	
	var result: Variant = array[0]
	for i: int in range(1, len(array)):
		result += array[i]
	return result

static func format_thousands(n: float) -> String:
	var result: String = ""
	
	var string: String = ("%.0f" % floorf(n)).replace("-", "")
	var digit: int = 0
	
	for i: int in range(len(string) - 1, -1, -1):
		result = string[i] + result
		if digit % 3 == 2 and i > 0:
			result = " " + result
		digit += 1
	
	if n < 0:
		return "-" + result
	
	return result

static func format_number(n: float) -> String:
	n = absf(n)
	var suffixes: String = " MTQSNU!\"§$%&/()=?/*-+,;@<>#~"
	var index: int = int(log(n / 100.0) / log(1e6))
	if index > 0:
		var suffix: String = suffixes[index] if index < suffixes.length() else "e%02d" % (6 * index)
		return "%s%s" % [
			format_thousands(n / 1e6 ** index),
			suffix
		]
	return format_thousands(n)

static func sigmoid(x: float) -> float:
	return 1.0 / (1.0 + exp(-x))

static func is_mobile() -> bool:
	return OS.has_feature("mobile")
