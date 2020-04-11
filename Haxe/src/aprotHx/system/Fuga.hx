package aprotHx.system;

import aprotHx.core.*;
import aprotHx.component.*;

class Fuga extends System
{
	public override function get(): Array<Array<String>>
	{
		return [Type.getInstanceFields(Entity1)];
	}

	public function run(entities: Array<Entity1>)
	{
		for (i in 0...100)
		{
			for (entity in entities)
			{
				entity.transform.position.x += 100 * Main.inputWorld.time.deltaTime * 0.01;

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
}

private class Entity1
{
	public var transform: Transform;
}
