package aprotHx;

import aprotHx.type.ArrayWrapper;

class EntityList
{
	public function new() {}

	public var nextId: Int = 0;
	public var entities: ArrayWrapper<Entity> = new ArrayWrapper<Entity>();

	public function add(components: Array<Component>): Entity
	{
		var newEntity = new Entity(nextId);
		entities.value.push(newEntity);
		nextId++;

		for (component in components)
		{
			newEntity.add(component);
		}

		return newEntity;
	}
}
