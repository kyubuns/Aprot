package system;

import aprot.System;
import component.*;

class Hoge extends System
{
	public override function get(): Array<Array<String>>
	{
		return [Type.getInstanceFields(Entity1)];
	}

	public function run(entities: Array<Entity1>)
	{
		for (entity in entities)
		{
			entity.transform.position.x += 1;
			entity.transform.position.y += 1;
		}
	}
}

private class Entity1
{
	public var movable: Movable;
	public var transform: Transform;
}
