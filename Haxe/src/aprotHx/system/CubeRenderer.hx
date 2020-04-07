package aprotHx.system;

import aprotHx.core.*;
import aprotHx.component.*;

class CubeRenderer extends System
{
	public override function get(): Array<Array<String>>
	{
		return [Type.getInstanceFields(Entity1)];
	}

	public function run(entities: Array<Entity1>)
	{
		var tmp = new Array<Vector2>();
		for (entity in entities)
		{
			tmp.push(entity.transform.position);
		}
		Main.outputWorld.renderer.queue.value = tmp;
	}
}

private class Entity1
{
	public var transform: Transform;
}
