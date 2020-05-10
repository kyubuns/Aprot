package aprotHx;

import aprotHx.type.ArrayWrapper;

class Entity
{
	public function new(id: Int)
	{
		this.id = id;
	}

	public var id: Int;
	public var components: ArrayWrapper<Component> = new ArrayWrapper<Component>();

	public function add(component: Component)
	{
		components.value.push(component);
	}
}
