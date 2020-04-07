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
		/*
			var tmp = new Array<Vector2>();
			for (i in 0...entities.length)
			{
				tmp.push(new Vector2(1, 999));
			}
			Main.world.renderer.queue = tmp;
		 */
	}
}

private class Entity1
{
	public var transform: Transform;
}
