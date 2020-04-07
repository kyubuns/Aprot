package aprotHx.system;

import aprotHx.core.*;
import aprotHx.component.*;

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
			entity.transform.position.x += 500 * Main.inputWorld.time.deltaTime;
			entity.transform.position.y += 500 * Main.inputWorld.time.deltaTime;

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
