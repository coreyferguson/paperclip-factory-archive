extends GridContainer

func collect(item):
	Inventory.add(item)

func _on_Timer_timeout():
	refresh()

func refresh():
	for index in range(0, Inventory.capacity):
		var item = Inventory.items[index]
		if item != null:
			get_node('InventorySlot'+str(index)).set_item(item.texture, item.quantity)
		else:
			get_node('InventorySlot'+str(index)).clear_item()
