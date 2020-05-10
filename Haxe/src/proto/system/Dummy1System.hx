package proto.system;

import proto.inputContext.InputContext;
import proto.outputContext.OutputContext;
import proto.component.*;
import aprotHx.*;

class Dummy1System extends aprotHx.System
{
	public function new() {}

	public function dummyUpdateInternal(context: Dynamic /*Context<InputContext, OutputContext>*/, entityList: EntityList)
	{
		trace("Dummy1System.dummyUpdateInternal!!!!!!!!!!!");
		var entities = new Array<RefEntity<Transform, Velocity>>();
		for (entity in entityList.entities.value)
		{
			var t1 = entity.components.value.filter(x -> Std.is(x, Transform));
			var t2 = entity.components.value.filter(x -> Std.is(x, Velocity));
			if (t1.length > 0 && t2.length > 0)
			{
				entities.push(new RefEntity<Transform, Velocity>(cast(t1[0], Transform), cast(t2[0], Velocity)));
			}
		}
		update(context, entities);
	}

	public function update(context: Context<InputContext, OutputContext>, entities: Array<RefEntity<Transform, Velocity>>)
	{
		trace("Dummy1System.update!!!!!!");
		for (entity in entities)
		{
			entity.transform.position.x += entity.velocity.vector.x * context.input.time.deltaTime;
			entity.transform.position.y += entity.velocity.vector.y * context.input.time.deltaTime;
		}
	}
}
