package proto.system;

import proto.component.*;
import aprotHx.*;

class Dummy implements aprotHx.System
{
	function update(context: Context, entities: Array<Entity2<Transform, Velocity>>)
	{
		for (entity in entities)
		{
			entity.value1.position.x += entity.value2.vector.x;
			entity.value1.position.y += entity.value2.vector.y;
		}
	}
}
