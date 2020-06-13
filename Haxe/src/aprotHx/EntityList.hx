package aprotHx;

import aprotHx.type.ArrayWrapper;

class EntityList implements EntityAccess implements hxbitmini.Serializable
{
	public function new()
	{
	}

	@:s public var nextId: Int = 0;
	@:s public var entities: ArrayWrapper<Entity> = new ArrayWrapper<Entity>();

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

	public function delete(id: Int)
	{
		for (target in entities.value.filter(x -> x.id == id))
		{
			entities.value.remove(target);
		}
	}
}
