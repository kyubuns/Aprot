package aprotHx;

import aprotHx.type.ArrayWrapper;

class Entity implements hxbit.Serializable
{
	public function new(id: Int)
	{
		this.id = id;
	}

	@:s public var id: Int;
	@:s public var components: ArrayWrapper<Component> = new ArrayWrapper<Component>();

	public function add(component: Component)
	{
		components.value.push(component);
	}
}
