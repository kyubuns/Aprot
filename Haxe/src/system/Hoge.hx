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
			entity.transform.position.x += 20;
			entity.transform.position.y += 20;

			if (entity.transform.position.x > 450)
			{
				entity.transform.position.x = -450;
			}

			if (entity.transform.position.y > 450)
			{
				entity.transform.position.y = -450;
			}
		}
	}
}

private class Entity1
{
	public var movable: Movable;
	public var transform: Transform;
}
