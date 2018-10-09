
var type
var quantity

func _init(type_value=null, quantity_value=null):
	type = type_value
	quantity = quantity_value

func copy_from(natural_resource_stack):
	type = natural_resource_stack.type
	quantity = natural_resource_stack.quantity
	return self
