extends Building

func processResource(res: inventoryResource) -> bool:
	for order in gameStateManager.orderManager.orders:
		if order.orderResource.resource==res:
			order.orderSuccess()
			return true
	return false
