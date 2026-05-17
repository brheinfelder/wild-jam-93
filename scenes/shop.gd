extends Building

func processResource(res: inventoryResource) -> bool:
	for order in gameStateManager.orderManager.orders:
		if order.orderResource.resource.id==res.id:
			order.orderSuccess()
			return true
	return false
